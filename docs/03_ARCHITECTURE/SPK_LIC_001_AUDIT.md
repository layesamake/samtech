# Audit indépendant — SPK-LIC-001

| Élément | Valeur |
|---|---|
| Auditeur | Codex, intervenant après l'implémentation initiale |
| Date | 15 juillet 2026 |
| Dépôt | `D:\dev\samtech` |
| Branche observée | `spike/spk-lic-001-license-signature` |
| Périmètre corrigé | SPK-LIC-001, documentation transverse et câblage qualité associé |
| Interdictions respectées | aucun commit, tag, push, merge ou Pull Request ; aucun fichier SPK-DB-001 modifié |

## 1. Méthode et source de vérité

L'audit a été conduit depuis le code et les commandes réellement exécutées. Le walkthrough n'a pas été utilisé comme preuve. Tous les documents, sources, tests, manifestes et workflow demandés ont été lus. Le code initial non commité a d'abord été inspecté, puis corrigé ; les preuves finales ci-dessous concernent l'état corrigé.

Références normatives et techniques recoupées :

- [RFC 7515 — JSON Web Signature](https://www.rfc-editor.org/rfc/rfc7515.html) ;
- [RFC 8032 — Ed25519/EdDSA](https://www.rfc-editor.org/rfc/rfc8032.html) ;
- [RFC 8037 — EdDSA for JOSE, annexes A.4/A.5](https://www.rfc-editor.org/rfc/rfc8037.html) ;
- [RFC 8725 — JWT Best Current Practices](https://www.rfc-editor.org/rfc/rfc8725.html) ;
- [`cryptography` 2.9.0 sur pub.dev](https://pub.dev/packages/cryptography).

## 2. État Git initial

La branche observée correspondait à la branche attendue. L'arbre était déjà non commité :

```text
 M docs/00_FOUNDATION/DECISIONS.md
 M docs/03_ARCHITECTURE/LICENSE_MANAGER.md
 M docs/05_DEVELOPMENT/DEPENDENCIES.md
 M packages/license_manager/README.md
 M packages/license_manager/lib/license_manager.dart
 M packages/license_manager/pubspec.yaml
 M pubspec.lock
 M pubspec.yaml
?? docs/03_ARCHITECTURE/SPIKE_LICENSE_SIGNATURE.md
?? packages/license_manager/lib/src/
?? packages/license_manager/test/
```

Ces modifications initiales ont été préservées. Les corrections d'audit ont été appliquées par-dessus sans réinitialisation destructive.

## 3. Constats initiaux

### Gravité haute

1. **Base64url permissif.** Le vérificateur utilisait une blacklist de quelques caractères au lieu d'une allowlist. Les tabulations, retours chariot, ponctuations, Unicode et formes non canoniques n'étaient pas tous explicitement exclus ; `base64Url.normalize` accepte par ailleurs des formes percent-encodées que le profil JWS ne doit pas accepter.
2. **Header JOSE ouvert.** `alg == EdDSA`, `typ` et `kid` étaient contrôlés, et `alg: none` était déjà rejeté, mais `jku`, `jwk`, `x5u`, `x5c`, `crit` et tout membre inconnu étaient silencieusement acceptés.
3. **Doublons JSON silencieux.** `jsonDecode` remplaçait une valeur par la dernière occurrence. Deux `kid` ou deux `audience`, y compris via un nom échappé en Unicode, n'étaient pas détectés.
4. **Trousseau non sûr.** Deux clés portant le même `kid` s'écrasaient. Ni la syntaxe/longueur du `kid`, ni `KeyPairType.ed25519`, ni la longueur publique de 32 octets n'étaient imposées. Il n'existait pas d'état de désactivation.
5. **Injection possible dans les erreurs.** Un `kid` non fiable était interpolé dans `KeyNotFoundException` avant que la signature ne soit validée.
6. **Claims insuffisamment bornés.** Les chaînes n'avaient aucune longueur maximale ; les contrôles Unicode de journal, timestamps négatifs ou excessifs et valeurs très élevées de `max_devices` pouvaient être acceptés.

### Gravité moyenne

1. **Matrice d'attaque incomplète.** Les tests initiaux couvraient les cas nominaux principaux, mais pas les segments vides, tout l'alphabet hostile, les racines JSON non objet, l'UTF-8 invalide, les doublons, les headers de référence distante, tous les claims ni toutes les frontières temporelles.
2. **Absence de vecteur normatif indépendant.** Tous les jetons étaient produits par le helper local, ce qui laissait possible une erreur symétrique entre génération et vérification.
3. **API redondante/incomplètement expliquée.** `VerifiedLicense` doublonnait `LicenseEvaluation` sans usage. Les états `invalid`, `revoked` et `transferable` n'étaient jamais produits, sans explication du futur mapping.
4. **Documentation trompeuse.** Les expressions « forgeage impossible » et « validation parfaite », l'assimilation systématique d'un recul d'horloge à l'état de grâce, la présentation de la clé publique comme un secret CI et le périmètre survendu du package ne correspondaient ni au code ni au modèle de menace.
5. **Dépendance directe inutile.** `convert` était déclaré lors de l'état initial sans import ; le code utilise `dart:convert`.

### Informations positives déjà vraies avant correction

- le signing input était exactement `headerB64.payloadB64` ;
- Ed25519 provenait de `package:cryptography` ;
- une signature de 64 octets était exigée ;
- le payload JSON n'était interprété qu'après succès de la signature ;
- `alg: none`, HMAC, ECDSA et RSA étaient rejetés par l'égalité stricte sur `EdDSA` ;
- l'heure était injectée, sans `DateTime.now()` dans le domaine, et l'heure effective ne reculait pas sous la dernière heure serveur authentifiée ;
- aucune clé privée de production, dépendance Flutter ou entrée/sortie réseau ne se trouvait dans `license_manager`.

## 4. Corrections effectuées

### Cryptographie et parsing

- allowlist ASCII `[A-Za-z0-9_-]`, segments non vides, rejet du padding et des longueurs modulo 4 impossibles ;
- décodage puis réencodage identique pour imposer le base64url canonique ;
- limites de 12 Kio par jeton, 1 024 caractères pour le header encodé et 8 192 pour le payload encodé ;
- header V1 contenant exactement `alg`, `typ`, `kid`, avec `EdDSA` exclusivement ;
- détection des doublons de membres racine après décodage de leurs échappements JSON ;
- validation de racine objet, JSON et UTF-8 stricts ;
- interprétation du payload conservée après la vérification Ed25519 ;
- erreurs constantes et expurgées, sans interpolation de token, segment, clé ou `kid` non fiable.

### Trousseau, claims et temps

- refus des `kid` dupliqués, vides, supérieurs à 64 caractères, URL, chemins ou contrôles ;
- type `KeyPairType.ed25519` et clé publique de 32 octets imposés ;
- copie immuable des octets publics fournis ;
- clés courante et ancienne activées acceptées, clé désactivée ou retirée refusée ;
- allowlist exacte des 14 claims, types stricts, longueurs bornées, contrôles interdits, `token_version == 1`, `0 < max_devices <= 1 000 000` ;
- dates Unix entre 0 et `253402300799` avec ordre chronologique strictement validé ;
- frontières temporelles documentées et testées sans tolérance implicite ;
- `LicenseEvaluation.claims` rendu non nullable, `VerifiedLicense` supprimé ; mapping futur exceptions vers `invalid` et provenance serveur de `revoked`/`transferable` documentés.

### Tests, dépendances, documentation et CI

- ajout d'une matrice adversariale de 74 tests Dart au total ;
- ajout du vecteur Ed25519/JWS publié dans la RFC 8037 A.4/A.5, vérifié directement contre la primitive afin de rester indépendant du schéma métier SAMTECH ;
- graines déterministes confinées sous `test/` et marquées `TEST ONLY. DO NOT USE IN PRODUCTION` ;
- suppression de la dépendance directe inutile `convert` ; elle reste transitive via l'analyseur de l'outillage de test ;
- documentation corrigée pour parler d'authenticité, d'intégrité et de résistance au forgeage dans un modèle de menace, jamais de confidentialité du JWS ;
- Melos sépare les tests Flutter et Dart, puis les réunit dans `test`/`quality` ; le workflow appelle cette porte après restauration verrouillée.

## 5. Fichiers modifiés ou ajoutés

### Code et tests SPK-LIC-001

- `packages/license_manager/pubspec.yaml`
- `packages/license_manager/README.md`
- `packages/license_manager/lib/license_manager.dart`
- `packages/license_manager/lib/src/errors/license_verification_error.dart`
- `packages/license_manager/lib/src/models/license_claims.dart`
- `packages/license_manager/lib/src/models/license_evaluation.dart`
- `packages/license_manager/lib/src/models/license_state.dart`
- `packages/license_manager/lib/src/models/license_verification_context.dart`
- `packages/license_manager/lib/src/models/trusted_license_key.dart`
- `packages/license_manager/lib/src/verifier/license_token_verifier.dart`
- `packages/license_manager/lib/src/verifier/ed25519_license_token_verifier.dart`
- `packages/license_manager/test/ed25519_license_token_verifier_test.dart`
- `packages/license_manager/test/strict_verification_test.dart`
- `packages/license_manager/test/support/jws_test_generator.dart`

### Documentation et qualité

- `.github/workflows/quality.yml`
- `docs/00_FOUNDATION/DECISIONS.md`
- `docs/02_ANALYSIS/BUSINESS_RULES.md`
- `docs/03_ARCHITECTURE/LICENSE_MANAGER.md`
- `docs/03_ARCHITECTURE/SECURITY.md`
- `docs/03_ARCHITECTURE/SPIKE_LICENSE_SIGNATURE.md`
- `docs/03_ARCHITECTURE/SPK_LIC_001_AUDIT.md`
- `docs/05_DEVELOPMENT/DEPENDENCIES.md`
- `docs/05_DEVELOPMENT/TESTING.md`
- `docs/07_RELEASES/CHANGELOG.md`
- `pubspec.yaml` et `pubspec.lock` (câblage workspace/dépendances déjà présent dans le travail initial, conservé et vérifié)

Aucun fichier sous `spikes/spk_db_001` n'a été modifié.

## 6. Contrôles exécutés et résultats exacts

| Contrôle | Commande | Résultat observable |
|---|---|---|
| Branche | `git branch --show-current` | exit 0 ; `spike/spk-lic-001-license-signature` |
| Restauration verrouillée | `flutter pub get --enforce-lockfile` | exit 0 ; `Got dependencies!` ; aucune mise à jour forcée, 10 versions plus récentes incompatibles signalées |
| Format non mutant | `dart format --output=none --set-exit-if-changed apps packages` | exit 0 ; 36 fichiers, 0 changement |
| Analyse stricte workspace | `flutter analyze --no-pub --fatal-infos --fatal-warnings` | exit 0 ; `No issues found!` |
| Tests Dart package | `dart test` dans `packages/license_manager` | exit 0 ; 74/74 tests passants |
| Tests Flutter via Melos | `dart run melos run test:flutter --no-select` | exit 0 ; 7 tests `samtech_crm` + 18 tests `ui_kit`, soit 25/25 |
| Porte qualité | `dart run melos run quality --no-select` | exit 0 ; format 36/0, analyse propre, 25 tests Flutter et 74 tests Dart passants ; `SUCCESS` |
| Build Android debug | `flutter build apk --debug --no-pub` dans `apps/samtech_crm` | exit 0 ; `app-debug.apk` construit ; Gradle `assembleDebug` en 68,5 s |
| SPK-DB-001 package | `flutter analyze --no-pub --fatal-infos --fatal-warnings` puis `flutter test --no-pub` | exits 0 ; analyse propre ; 15/15 tests passants |
| SPK-DB-001 exemple | même analyse puis `flutter test test/ --no-pub` | exits 0 ; analyse propre ; 1/1 widget test passant |
| Inventaire Pub | `dart pub deps --style=compact` | exit 0 ; SDK Dart 3.12.2, Flutter 3.44.6 ; versions résolues confirmées |
| Recherche de secrets | `rg` multi-signatures sur fichiers suivis, cachés et ignorés hors caches/build | exit 0 ; aucune signature de clé privée, AWS, Google, GitHub, Slack ou OpenAI ; aucun matériel privé hors `test/` |
| Horloge/API réseau | recherches `DateTime.now`, types privés et API fichier/réseau sous `license_manager/lib` | aucune occurrence interdite |
| Diff Git | `git diff --check` | exit 0 ; aucun défaut whitespace ; avertissements informatifs LF→CRLF sur Windows |

Un premier lancement Dart en sandbox avait bien formaté/analyé mais retourné 1 après `No issues found!`, car la télémétrie tentait d'écrire hors workspace. Il n'est pas compté comme preuve de succès : les commandes ont été relancées avec l'accès requis et ont alors retourné 0. Les processus de ces lancements bloqués ont été arrêtés sans interrompre le serveur Dart de l'IDE.

## 7. Preuves cryptographiques et fonctionnelles

- La clé RFC 8037 décodée fait 32 octets, la signature 64 octets et la vérification du signing input publié retourne `true`.
- Une altération de header, payload ou signature retourne une exception de signature.
- Un payload signé mais JSON/UTF-8 invalide retourne une erreur de claims ; le même payload avec signature invalide retourne d'abord une erreur de signature, ce qui prouve l'ordre d'interprétation.
- `none`, `HS256`, `ES256`, `RS256`, `Ed448` et toute casse alternative sont rejetés.
- Les signatures de 0, 63, 64 octets aléatoires et 65 octets sont rejetées ; une signature Ed25519 valide de 64 octets est acceptée.
- Les bornes sont : avant `not_before` refusé ; `not_before` et `recheck_after` inclus en `valid` ; seconde suivante et `grace_ends_at` inclus en `grace` ; seconde suivante en `expired`.
- Un recul utilise `max(currentTime, lastServerTime)`, exige un contrôle en ligne et ne prolonge jamais la validité ni la grâce.

## 8. Dépendances

| Package | Version résolue | Nature | Licence / maintenance observée |
|---|---:|---|---|
| `cryptography` | 2.9.0 | directe | Apache-2.0, publié par dint.dev |
| `meta` | 1.18.0 | directe | BSD-3-Clause, dart.dev |
| `lints` | 6.1.0 | dev | BSD-3-Clause, dart.dev |
| `test` | 1.31.0 | dev | BSD-3-Clause, dart.dev |
| `convert` | 3.1.2 | transitive via l'outillage/analyzer | non utilisé directement par `license_manager` |

`cryptography` fournit bien `Ed25519`, `Signature`, `SimplePublicKey` et `KeyPairType.ed25519`. Aucun SDK ou package Flutter n'est une dépendance de `license_manager`. Le package tiers est maintenu et publié, mais aucune certification indépendante de son implémentation n'est déduite de sa seule présence sur pub.dev.

## 9. Preuves Melos et CI

Le `pubspec.yaml` racine sélectionne les packages Dart avec `flutter: false` et `dirExists: test`, puis exécute `dart test`. Le script `test` enchaîne Flutter puis Dart ; `quality` enchaîne format, analyse et `test`. L'exécution locale exacte de `dart run melos run quality --no-select` prouve que `license_manager` est effectivement sélectionné et que ses 74 tests sont joués.

Le job `quality` de `.github/workflows/quality.yml` restaure le workspace avec `flutter pub get --enforce-lockfile`, puis appelle la même commande Melos. Le job `quality-spike` couvre séparément SPK-DB-001. Cependant, l'état audité est non commité : aucun run GitHub Actions distant ne peut constituer une preuve de cet arbre précis. La preuve CI est donc une inspection du workflow complétée par l'exécution locale de sa porte principale, pas une exécution distante.

## 10. État Git final

`git diff --check` retourne 0. `git status --short` confirme que tout le travail demeure non commité. Le rapport lui-même est nouveau ; aucun artefact de build suivi n'a été ajouté. L'état court final exact est reproduit ci-dessous :

```text
 M .github/workflows/quality.yml
 M docs/00_FOUNDATION/DECISIONS.md
 M docs/02_ANALYSIS/BUSINESS_RULES.md
 M docs/03_ARCHITECTURE/LICENSE_MANAGER.md
 M docs/03_ARCHITECTURE/SECURITY.md
 M docs/05_DEVELOPMENT/DEPENDENCIES.md
 M docs/05_DEVELOPMENT/TESTING.md
 M docs/07_RELEASES/CHANGELOG.md
 M packages/license_manager/README.md
 M packages/license_manager/lib/license_manager.dart
 M packages/license_manager/pubspec.yaml
 M pubspec.lock
 M pubspec.yaml
?? docs/03_ARCHITECTURE/SPIKE_LICENSE_SIGNATURE.md
?? docs/03_ARCHITECTURE/SPK_LIC_001_AUDIT.md
?? packages/license_manager/lib/src/
?? packages/license_manager/test/
```

## 11. Limites restantes et risques résiduels

### Réserves de validation

- aucun run GitHub Actions distant ne couvre l'arbre non commité ;
- iOS n'a pas été exécuté sur macOS et aucune validation iOS n'est revendiquée ;
- le serveur de signature, KMS, activation, stockage natif, réseau, révocation distante, transfert, mode restreint et export sécurisé ne font pas partie du spike ;
- la distribution authentique du trousseau public doit être réalisée par la chaîne de build/mise à jour ; une clé publique n'est pas secrète mais reste un trust anchor ;
- un client totalement patché peut ignorer le résultat du vérificateur, sans pour autant obtenir la clé privée serveur ;
- JWS ne chiffre pas le payload ; toute confidentialité supposée serait une erreur d'intégration ;
- la recherche de secrets a utilisé des signatures `rg` ciblées, aucun scanner spécialisé tel que Gitleaks n'étant installé ;
- l'inventaire complet automatisé des licences transitives, le fuzzing, les performances mobiles et les canaux auxiliaires n'ont pas été audités ;
- le job CI SPK-DB-001 préexistant ne restaure pas ses dépendances avec `--enforce-lockfile`, et les actions tierces ne sont pas épinglées par SHA ; ces points sont hors correction SPK-LIC-001.

### Risque résiduel synthétique

Le prototype local apporte des preuves solides d'authenticité et d'intégrité face aux jetons hostiles dans son profil V1. Le risque principal n'est plus le parsing nominal testé, mais l'intégration future : protection de la clé privée serveur, distribution du trust anchor, persistance authentique du dernier temps serveur, traitement non destructif des erreurs, et résistance raisonnable d'un client mobile modifiable.

SPK-LIC-001 validé avec réserves
