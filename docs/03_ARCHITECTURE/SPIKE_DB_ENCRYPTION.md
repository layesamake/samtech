# SPK-DB-001 — Drift avec SQLite chiffré

| Élément | Valeur |
|---|---|
| Date | 14 juillet 2026 |
| Statut | Validé avec réserves |
| Prototype | `spikes/spk_db_001` |
| Données | Uniquement fictives |

## 1. Objectif et périmètre

Ce spike vérifie une base locale relationnelle chiffrée compatible avec Drift,
Android, iOS, migrations, transactions, exécution hors du thread d'interface
et stockage natif de la clé. Il ne définit aucune table métier et ne traite ni
prospect, ni facture, ni campagne.

Le résultat est un choix d'infrastructure, pas une autorisation d'intégrer les
tables métier. La sauvegarde portable reste du ressort de `SPK-BCK-001`.

## 2. Solutions comparées

| Solution | Maintenance et licence | Android/iOS | Migrations et arrière-plan | Clé et rotation | Impact natif | Conclusion |
|---|---|---|---|---|---|---|
| Drift `NativeDatabase` + `sqlite3` 3.x + SQLite3MultipleCiphers | Voie recommandée par Drift pour une nouvelle application ; Drift, `sqlite3` et SQLite3MultipleCiphers sont sous licence MIT | Bibliothèques natives fournies par les hooks pour Android et iOS | Migrations Drift inchangées ; `NativeDatabase.createInBackground` utilise un isolate | `PRAGMA key` accepte une clé brute ; `PRAGMA rekey` permet la rotation | Téléchargement d'un binaire natif vérifié par empreinte ; pas de plugin SQLite ni de règle ProGuard dédiée | Retenue |
| `encrypted_drift` + `sqflite_sqlcipher` | Adaptateur présent dans le dépôt Drift, mais distribué par dépendance Git ; plugin `sqflite_sqlcipher` 3.4.0 sous MIT et SQLCipher Community sous licence BSD avec attribution | Android/iOS/macOS | Migrations Drift possibles ; exécution assurée par les files natives de sqflite | Mot de passe transmis au plugin ; rotation moins directement exposée par l'adaptateur | Règles ProGuard Android et risques de conflit de pods FMDB/SQLCipher sur iOS | Alternative de repli, non retenue |
| SQLCipher direct via les hooks `sqlite3` | Projet SQLCipher maintenu ; édition Community BSD avec attribution, éditions commerciales disponibles | Android/iOS | Compatible API SQLite et Drift natif | `PRAGMA key` et `PRAGMA rekey` | Choix de distribution/licence et compatibilité de format à maintenir | À reconsidérer si support commercial ou format SQLCipher imposé |
| `sqlcipher_flutter_libs` | Version `0.7.0+eol`, package désormais vide | Historiquement Android/iOS | Ancienne intégration FFI | Ancien chemin SQLCipher | Conflits de linkage possibles avec les bibliothèques SQLite récentes | Rejetée car en fin de vie |

Sources vérifiées :

- https://drift.simonbinder.eu/platforms/encryption/
- https://pub.dev/packages/sqlite3
- https://github.com/utelle/SQLite3MultipleCiphers
- https://utelle.github.io/SQLite3MultipleCiphers/docs/configuration/config_sql_pragmas/
- https://pub.dev/packages/sqflite_sqlcipher
- https://pub.dev/packages/sqlcipher_flutter_libs
- https://www.zetetic.net/sqlcipher/license/
- https://pub.dev/packages/flutter_secure_storage

## 3. Solution prototypée

Le prototype retient :

- Drift avec `NativeDatabase.createInBackground` ;
- `sqlite3` configuré par hook avec `source: sqlite3mc` ;
- SQLite3MultipleCiphers avec le schéma `chacha20` explicite
  (ChaCha20-Poly1305) ;
- une clé brute aléatoire de 32 octets générée par `Random.secure()` ;
- `flutter_secure_storage` derrière le port `SecureKeyStore` ;
- Android Keystore avec RSA-OAEP/AES-GCM par défaut, sans remise à zéro
  silencieuse en cas d'erreur ;
- iOS Keychain avec `first_unlock_this_device` et sans synchronisation iCloud ;
- `PRAGMA foreign_keys = ON`, `secure_delete = ON`, `temp_store = MEMORY` et
  `journal_mode = WAL` à chaque ouverture ;
- un contrôle d'exécution bloquant si le `PRAGMA cipher` n'existe pas.

La clé n'est ni codée en dur, ni journalisée, ni placée dans les préférences
ordinaires. Android désactive la sauvegarde applicative afin d'éviter une
restauration dissociant le fichier chiffré de sa clé Keystore.

## 4. Versions effectivement résolues

| Composant | Version testée |
|---|---|
| Flutter | 3.44.6 stable |
| Dart | 3.12.2 |
| Drift | 2.34.0 |
| `drift_dev` | 2.34.0 |
| `sqlite3` | 3.4.0 |
| SQLite3MultipleCiphers | 2.3.6, SQLite 3.53.3 |
| `flutter_secure_storage` | 10.3.1 |
| `path_provider` | 2.1.6 |
| Android | API minimale effective 24 avec Flutter 3.44.6 |
| iOS | cible minimale 13.0 générée par Flutter |

Le spike reste volontairement hors du workspace Pub racine. Au 14 juillet
2026, `drift_dev 2.34.0` contraint `cli_util 0.4`, tandis que Melos 8.2.2 du
workspace contraint `cli_util 0.5`. Modifier Melos pour le spike aurait changé
une décision du Sprint 0 sans nécessité.

## 5. Scénarios et résultats

| Scénario | Résultat |
|---|---|
| Génération cryptographiquement sûre de 256 bits | Réussi |
| Création, fermeture et réouverture | Réussi sur le moteur natif Windows |
| Réutilisation de la clé persistée | Réussi localement et sur Android Keystore |
| Ouverture avec une mauvaise clé | Rejetée avec `SQLITE_NOTADB` |
| Recherche d'un marqueur dans le fichier, WAL, SHM et journal | Aucun texte clair trouvé |
| En-tête SQLite standard dans le fichier | Absent |
| Transaction validée | Réussi |
| Rollback après exception | Réussi |
| Migration réelle du schéma 1 vers 2 | Réussi, colonne ajoutée et `user_version = 2` |
| Activation et violation des clés étrangères | Activation confirmée ; insertion orpheline rejetée |
| Clé absente avec base existante | Échec fermé explicite |
| Coffre inaccessible ou écriture non persistée | Échec fermé, aucune clé de repli |
| WAL et stockage temporaire | WAL actif ; `temp_store = MEMORY` |
| Rotation du moteur | Nouvelle clé acceptée, ancienne clé rejetée |
| Rotation coordonnée avec le coffre | Réussie ; rollback testé si l'écriture du coffre échoue |
| Analyse statique | Réussie, aucune anomalie |
| Tests Flutter locaux | 19 tests réussis |
| Build Android | Réussi pour Android x64, APK debug produit |
| Exécution Android/Keystore | Deux exécutions successives réussies avec le coffre natif ; l'assertion stricte de présence de l'état du processus précédent a été ajoutée, mais sa relance finale a été interrompue avant le chargement du test par l'instabilité de l'émulateur |
| Build iOS/Keychain | Non disponible depuis l'hôte Windows |

## 6. Mesures

Mesure indicative sur l'hôte Windows, build de test, 5 000 lignes fictives,
une seule exécution :

| Opération | Durée |
|---|---:|
| Ouverture, chargement de clé et vérification du schéma | 410,747 ms |
| Écriture groupée de 5 000 lignes | 381,199 ms |
| Comptage et lecture de 250 lignes | 64,844 ms |

Ces valeurs prouvent le fonctionnement et donnent un ordre de grandeur. Elles
ne constituent pas un budget de performance mobile ; les mesures Android et
iOS en mode profile restent obligatoires avant intégration.

## 7. Fichiers temporaires, WAL et journaux

Le mode WAL crée normalement `-wal` et `-shm` pendant l'ouverture. Le test lit
le fichier principal et tous les artefacts connus (`-wal`, `-shm`, `-journal`)
avant et après fermeture et n'y retrouve pas le marqueur fictif. Le stockage
temporaire SQLite est forcé en mémoire. La rotation effectue un checkpoint,
passe temporairement en journal `DELETE`, applique `rekey`, puis réactive WAL.

## 8. Limitations et risques

- Le build et le coffre iOS ne sont pas encore validés ; ils restent une porte
  bloquante avant intégration dans SAMTECH CRM.
- Android est validé sur un émulateur x64 API 37/Android 17. Les architectures
  ARM/ARM64 et un appareil physique restent à contrôler avant livraison.
- La relance Android de l'assertion inter-processus stricte n'a pas atteint le
  code du test : le runner a perdu sa connexion WebSocket pendant le chargement,
  puis l'émulateur est resté en état `connecting/authorizing`. Ce contrôle doit
  être rejoué sur un émulateur stable ou un appareil physique.
- SQLite3MultipleCiphers n'utilise pas par défaut le format de fichier
  SQLCipher. Une exigence d'interopérabilité SQLCipher changerait la
  configuration et imposerait de nouveaux tests de migration.
- La rotation synchrone sait revenir à l'ancienne clé si le coffre refuse
  l'écriture. Un arrêt brutal entre `rekey` et la mise à jour du coffre exige
  cependant un protocole durable à deux emplacements avant production.
- La clé existe brièvement dans la mémoire Dart et sous forme hexadécimale pour
  le `PRAGMA`. Le prototype ne prétend pas garantir l'effacement mémoire.
- Les obligations de licence et notices des composants natifs doivent être
  intégrées à l'écran ou au document de licences de l'application finale.
- La stratégie de sauvegarde/restauration et la portabilité des clés ne sont
  pas couvertes ici.

## 9. Recommandation et intégration future

La pile Drift + `sqlite3` + SQLite3MultipleCiphers est recommandée, avec les
réserves natives ci-dessus. Avant toute table métier :

1. confirmer le build ARM64 et le coffre sur un appareil Android physique ;
2. rendre verts le build et le test Keychain sur iPhone/simulateur iOS ;
3. mesurer Android et iOS en mode profile ;
4. concevoir une rotation crash-safe à deux emplacements ;
5. encapsuler l'exécuteur et le coffre dans le package `security` ou un package
   de persistance dédié, conformément à l'ADR-017 ;
6. exporter et tester chaque migration Drift ;
7. traiter séparément la sauvegarde/restauration dans `SPK-BCK-001`.

## 10. Conclusion

**SPK-DB-001 validé avec réserves.**

Le moteur, Drift, les migrations, les transactions, les contraintes, la
mauvaise clé, l'inspection des artefacts, l'arrière-plan et la rotation sont
validés localement et Android x64. L'intégration produit reste interdite tant
que les portes iOS et appareils physiques listées ci-dessus ne sont pas
passées.
