# Stratégie des dépendances Flutter

| Élément | Valeur |
|---|---|
| Statut | Candidats vérifiés, versions à épingler au démarrage du code |
| Version | 1.0 |
| Date | 14 juillet 2026 |

## 1. Politique

- préférer Flutter/Dart officiels ou éditeurs reconnus ;
- vérifier maintenance, licence, plateformes, changelog et issues critiques ;
- encapsuler toute dépendance native ou critique ;
- éviter deux packages pour la même responsabilité ;
- épingler via `pubspec.lock` pour les applications ;
- automatiser l'audit et mettre à jour par lots testés ;
- ne jamais copier une version depuis ce document : utiliser la dernière version stable compatible au moment du bootstrap.

## 2. Candidats principaux

| Besoin | Package candidat | Décision |
|---|---|---|
| État et injection | `flutter_riverpod`, `riverpod_annotation` | retenu sous réserve du spike |
| Navigation | `go_router`, éventuellement `go_router_builder` | retenu |
| Base relationnelle | `drift`, `drift_flutter` | retenu logiquement |
| SQLite chiffré | `sqlite3` 3.x avec hook `sqlite3mc` | retenu avec réserves par `SPK-DB-001` |
| Coffre sécurisé | `flutter_secure_storage` derrière un port SAMTECH | retenu avec réserves Android/iOS |
| Biométrie | `local_auth` | candidat officiel Flutter |
| Notifications | `flutter_local_notifications`, `timezone` | candidat |
| HTTP licence | `http` | suffisant, encapsulé |
| Signature | `cryptography` ou binding validé | spike sécurité |
| PDF | `pdf`, `printing` | candidat |
| Partage | `share_plus` | candidat |
| URL WhatsApp | `url_launcher` | candidat avec repli |
| Fichiers | `file_selector`, `path_provider` | candidats |
| Informations app | `package_info_plus` | candidat |
| UUID | `uuid` | candidat |
| Localisation | `intl`, localisation Flutter | retenu |
| Sérialisation | `json_serializable` | snapshots/API versionnés |
| Logs | `logging` avec façade SAMTECH | candidat |
| Génération | `build_runner`, `drift_dev`, `riverpod_generator` | nécessaire si spikes validés |

## 3. Dépendances volontairement évitées au départ

- service locator global ;
- bibliothèque fonctionnelle lourde uniquement pour un type Result ;
- stockage clé-valeur comme base métier ;
- connectivité utilisée comme preuve qu'Internet fonctionne ;
- SDK analytique distant dans la Starter ;
- package d'identifiant matériel intrusif ;
- bibliothèque de cryptographie non auditée ou algorithme maison.

## 4. Spikes obligatoires

### SPK-DB-001 — Drift + SQLite chiffré

Statut : validé avec réserves le 14 juillet 2026. Le prototype isolé utilise
Drift 2.34.0, `sqlite3` 3.4.0, SQLite3MultipleCiphers 2.3.6 et
`flutter_secure_storage` 10.3.1. Ouverture en isolate, migrations,
transactions, mauvaise clé, fichiers bruts, clés étrangères, WAL, erreurs de
coffre, rotation et mesures locales sont couverts. Android x64 et le Keystore
ont été validés sur émulateur ; iOS et les appareils physiques restent
obligatoires avant intégration. Voir
`docs/03_ARCHITECTURE/SPIKE_DB_ENCRYPTION.md`.

### SPK-LIC-001 — Signature de licence

Valider génération serveur, vérification mobile, taille du jeton, rotation de clés et résistance aux erreurs d'horloge.

### SPK-BCK-001 — Enveloppe de sauvegarde

Valider KDF, chiffrement authentifié, gros fichiers, restauration atomique et portabilité.

### SPK-NOT-001 — Notifications

Valider permissions, fuseaux, redémarrage, limites Android/iOS et réconciliation.

### SPK-SHR-001 — WhatsApp et partage

Valider encodage des numéros/messages, application absente, retour utilisateur et partage PDF.

## 5. Exigences de plateforme

Les versions minimales Android/iOS seront définies après résolution des candidats. Les packages récents peuvent relever les exigences SDK, Java, Kotlin, Gradle ou iOS ; le projet doit choisir consciemment le compromis entre sécurité, maintenance et parc d'appareils ciblé.

## 6. Références vérifiées

- Riverpod : https://riverpod.dev/
- Drift : https://drift.simonbinder.eu/
- Chiffrement Drift : https://drift.simonbinder.eu/platforms/encryption/
- SQLite3MultipleCiphers : https://github.com/utelle/SQLite3MultipleCiphers
- sqlite3 : https://pub.dev/packages/sqlite3
- go_router : https://pub.dev/packages/go_router
- local_auth : https://pub.dev/packages/local_auth
- flutter_secure_storage : https://pub.dev/packages/flutter_secure_storage
- flutter_local_notifications : https://pub.dev/packages/flutter_local_notifications
- share_plus : https://pub.dev/packages/share_plus
- pdf : https://pub.dev/packages/pdf
- printing : https://pub.dev/packages/printing
- url_launcher : https://pub.dev/packages/url_launcher
