# Audit technique indépendant — Sprint 0

| Élément | Valeur |
|---|---|
| Projet | SAMTECH CRM |
| Branche auditée | `feature/sprint-0-foundation` |
| Baseline | `4bf9184b38d9e6a030e312077262a43ef28d8a4c` |
| Date de l'audit | 15 juillet 2026 |
| Environnement | Windows, Flutter 3.44.6 stable, Dart 3.12.2 |
| Verdict | Socle Sprint 0 conforme après corrections sur Android ; preuve iOS différée faute de macOS |

## 1. Mandat et indépendance

L'audit a porté sur les fichiers réellement présents dans `D:\dev\samtech`, sans prendre le rapport du développeur comme preuve. La phase de constat a été terminée avant toute correction des sources.

Contraintes respectées :

- aucun commit, tag ou push créé ;
- `HEAD` est resté sur la baseline `4bf9184b38d9e6a030e312077262a43ef28d8a4c` ;
- aucun code d'un tag ou de la branche d'archive interdits n'a été restauré ;
- la recherche de copie a été limitée à une comparaison de hashes Git ;
- les corrections sont limitées au socle technique, aux tests, à la CI et à la documentation du Sprint 0.

## 2. Référentiel lu avant correction

Les documents imposés ont été lus intégralement :

- `README.md` ;
- `docs/00_FOUNDATION/DECISIONS.md` ;
- `docs/01_PRODUCT/VISION.md` ;
- `docs/02_ANALYSIS/CAHIER_DES_CHARGES.md` ;
- `docs/03_ARCHITECTURE/ARCHITECTURE.md` ;
- `docs/03_ARCHITECTURE/SECURITY.md` ;
- `docs/04_DESIGN/DESIGN_SYSTEM.md` ;
- `docs/04_DESIGN/ACCESSIBILITY.md` ;
- `docs/05_DEVELOPMENT/SPRINT_0.md` ;
- `docs/05_DEVELOPMENT/PROJECT_STRUCTURE.md` ;
- `docs/05_DEVELOPMENT/DEPENDENCIES.md` ;
- `docs/05_DEVELOPMENT/CODING_STANDARDS.md` ;
- `docs/05_DEVELOPMENT/TESTING.md` ;
- `docs/05_DEVELOPMENT/DEFINITION_OF_DONE.md`.

Le diff complet depuis `4bf9184`, les manifestes, les locks, les fichiers natifs, les sources, les tests, la CI et les documents modifiés ont également été examinés.

## 3. État initial figé en phase 1

### 3.1 Git et outillage

- branche : `feature/sprint-0-foundation` ;
- `HEAD` : `4bf9184b38d9e6a030e312077262a43ef28d8a4c` ;
- état non commité initial : 15 fichiers suivis modifiés et 194 fichiers non suivis ;
- SDK local : Flutter 3.44.6 stable et Dart 3.12.2 ;
- lock racine : Melos 6.3.3 ;
- commande globale `melos` : absente.

### 3.2 Résultats initiaux des commandes

| Contrôle initial | Résultat observé |
|---|---|
| `dart run melos list` | neuf membres reconnus ; graphe limité à `samtech_crm -> ui_kit` ; aucun cycle |
| `dart format --output=none --set-exit-if-changed apps packages` | 38 fichiers, aucun changement |
| analyse de `samtech_crm` | réussite |
| analyse des huit packages | échec fatal sur `dangling_library_doc_comments` |
| `dart run melos run test --no-select` | échec avant les tests : le script appelait un Melos global absent |
| tests Flutter directs de l'application | 5 tests passants |
| tests Flutter directs de `ui_kit` | 16 tests passants |
| tests Dart directs | tests de constantes de version seulement, donc sans preuve fonctionnelle |
| build Android debug | réussite, malgré les défauts de configuration restants |
| build iOS | non exécutable sous Windows |

Le succès initial du build Android n'a pas été interprété comme une preuve suffisante de conformité.

### 3.3 Écarts initiaux

| ID | Gravité Sprint 0 | Constat initial | Décision/correction |
|---|---|---|---|
| A-01 | Élevée | `linux/`, `macos/`, `web/` et `windows/` avaient été générés par le template Flutter sans exigence produit. | Suppression ; seuls Android et iOS sont conservés. |
| A-02 | Élevée | Android utilisait encore le namespace et le package Kotlin `com.samtech.samtech_crm`. Les targets de tests iOS utilisaient `com.samtech.samtechCrm.RunnerTests`. | Namespace, package Kotlin et bundles de tests alignés sur `com.samtech.crm`. |
| A-03 | Élevée | Configuration Melos 6 indépendante des Pub Workspaces, dix lockfiles au total et override local redondant. | Migration Pub Workspace/Melos 8, un lock racine, aucun override. |
| A-04 | Élevée | La CI utilisait Flutter 3.22.x, donc un Dart incompatible avec la contrainte du projet, ainsi qu'un Melos global non verrouillé. | CI alignée sur Flutter 3.44.6, Melos local 8.2.2 et lock strict. |
| A-05 | Élevée | Les scripts utilisaient `dart pub get` ou `dart test` pour des membres Flutter, appelaient Melos globalement et le contrôle de format de CI mutait les fichiers. | Scripts Melos 8 exécutables, format non mutant, analyse fatale et tests Flutter filtrés. |
| A-06 | Moyenne | Riverpod 2.6.1, go_router 14.8.1 et flutter_lints 5.0.0 étaient en retrait de la baseline vérifiée. | Mise à niveau vers Riverpod 3.3.2, go_router 17.3.0 et flutter_lints 6.0.0. |
| A-07 | Élevée | Huit packages échouaient à l'analyse malgré une documentation annonçant un socle propre. | Bibliothèques déclarées correctement ; analyse finale sans diagnostic. |
| A-08 | Moyenne | Sept packages réservés exposaient seulement des constantes de version et des tests qui validaient ces constantes. | Placeholders et tests factices supprimés ; frontières réservées explicitement vides. |
| A-09 | Moyenne | Un `ThemeData` sombre était livré alors que sa validation est explicitement différée ; une paire sombre danger/surface avait un contraste d'environ 2,61:1. | Suppression du thème sombre livré ; tokens sombres conservés comme préparation documentée. |
| A-10 | Faible | Taille d'icône `64` codée en dur et interlignes non documentés dans les styles. | Utilisation d'un token d'espacement et retrait des hauteurs inventées. |
| A-11 | Moyenne | `apiBaseUrl` pointait vers localhost et les commentaires de bootstrap annonçaient prématurément Drift et la sécurité. | Configuration ramenée au seul environnement et commentaires prospectifs supprimés. |
| A-12 | Moyenne | Pas de test de route inconnue, routeur/conteneurs non systématiquement libérés, test de bootstrap ne testant pas réellement `bootstrap`. | Tests utiles ajoutés et ressources libérées avec `onDispose`/`dispose`. |
| A-13 | Moyenne | README et documents confondaient cible future et état implémenté, et annonçaient thèmes/composants ou annotations absents. | Documentation réécrite pour distinguer état réel, cible et validation non effectuée. |
| A-14 | Élevée | Le changelog remplaçait l'historique de la baseline au lieu d'ajouter les changements du Sprint 0. | Les 30 entrées historiques de la baseline ont été préservées et le Sprint 0 ajouté. |
| A-15 | Faible | Configurations de lints redondantes et dépendances/configurations pas toujours cohérentes avec le type de package. | Baseline Flutter 6.0.0 et Dart 6.1.0 clarifiée par type de membre. |
| A-16 | Information | Risque demandé de reprise de l'ancien code. | Aucun hash de source/configuration substantielle ne correspond ; seul un fichier générique d'analyse et des fichiers natifs de template concordent. |

## 4. Corrections finales vérifiées

### 4.1 Plateformes et identité

L'application conserve uniquement :

- `apps/samtech_crm/android` ;
- `apps/samtech_crm/ios`.

Identité vérifiée dans les fichiers natifs :

| Propriété | Valeur finale | Preuves principales |
|---|---|---|
| nom Dart | `samtech_crm` | `apps/samtech_crm/pubspec.yaml` |
| nom visible | `SAMTECH CRM` | manifeste Android et `Info.plist` iOS |
| Android application ID/namespace | `com.samtech.crm` | `android/app/build.gradle.kts` |
| package Kotlin | `com.samtech.crm` | `MainActivity.kt` |
| iOS bundle ID | `com.samtech.crm` | configurations Xcode |
| iOS tests bundle ID | `com.samtech.crm.RunnerTests` | configurations Xcode |

Le style Android nocturne reste volontairement clair au Sprint 0 afin d'éviter un splash noir avant un `ThemeData` clair. Le test iOS généré et vide a été remplacé par une assertion du bundle hôte ; il n'est pas compté comme exécuté dans cet environnement.

### 4.2 Workspace et dépendances

Le `pubspec.yaml` racine énumère exactement les neuf membres demandés. Chaque membre déclare `resolution: workspace`.

Classification finale :

- membres Flutter : `apps/samtech_crm` et `packages/ui_kit` ;
- packages Dart réservés : `analytics`, `authentication`, `backup`, `license_manager`, `notifications`, `pdf_engine`, `security`.

Graphe final :

```text
samtech_crm -> ui_kit
analytics, authentication, backup, license_manager,
notifications, pdf_engine, security, ui_kit -> aucune dépendance interne
```

Il n'existe aucun cycle, aucun import d'un package partagé vers l'application et aucune dépendance interne par chemin. Pub Workspaces résout `ui_kit ^0.1.0` vers le membre local.

Politique de résolution finale :

- un seul `pubspec.lock`, à la racine ;
- SHA-256 du lock : `34A1989F23AB0FF9EDEAB552F29DD4A5F7223A74BC0CFAEE1646D63DEF91930A` ;
- aucun `pubspec_overrides.yaml` ;
- locks enfants et overrides persistants ignorés par Git ;
- CI restaurée avec `flutter pub get --enforce-lockfile`.

Dépendances directes du Sprint 0 :

- racine : Melos 8.2.2 et flutter_lints 6.0.0 ;
- application : Flutter, flutter_riverpod 3.3.2, go_router 17.3.0 et ui_kit 0.1.0 ;
- ui_kit : Flutter et flutter_lints 6.0.0 ;
- packages Dart réservés : lints 6.1.0 en développement seulement.

Aucune dépendance Drift/SQLite, chiffrement, licence, PIN/biométrie, notification, PDF, WhatsApp, sauvegarde, cloud ou analytics distant n'est intégrée.

### 4.3 Architecture applicative

- `main.dart` délègue à un `bootstrap` séparé ;
- `ProviderScope` est à la racine et reçoit l'override de configuration ;
- la configuration ne contient que l'environnement ;
- le routeur GoRouter est fourni par Riverpod et libéré à la destruction du provider ;
- une route inconnue affiche une page générique sans effet réseau ;
- aucun widget n'appelle un plugin natif ;
- aucune logique métier, base, sécurité, licence ou synchronisation n'est implémentée ;
- aucune arborescence future vide n'est matérialisée.

### 4.4 Packages partagés et UI

`ui_kit` contient uniquement les couleurs, espacements, rayons, typographies documentés et le thème clair Material 3. Les tokens sombres restent disponibles pour une validation ultérieure, sans `ThemeData` sombre livré.

Les tests contrôlent :

- les valeurs documentées ;
- le mapping du thème clair ;
- l'absence d'interlignes inventés ;
- le contraste WCAG AA des paires de contenu clair actuellement utilisées.

Les sept autres packages documentent une frontière future sans API fonctionnelle, source placeholder, test factice ni logique métier.

### 4.5 CI et documentation

La CI :

- utilise Flutter 3.44.6 stable ;
- n'installe pas Melos globalement ;
- impose le lockfile ;
- exécute le même gate `quality` qu'en local ;
- emploie un contrôle de format non mutant ;
- traite infos et avertissements d'analyse comme fatals.

Les README, la structure, la politique de dépendances, le Sprint 0 et le changelog décrivent désormais l'état réel. Les structures, packages et dépendances futurs sont présentés comme des cibles conditionnelles, pas comme des implémentations.

## 5. Contrôles finaux sur l'arbre réel

| Commande | Résultat final |
|---|---|
| `flutter pub get --enforce-lockfile` | réussite |
| `dart pub workspace list` | racine et neuf membres exacts |
| `dart run melos list --relative --parsable` | neuf chemins exacts |
| `dart run melos list --cycles` | aucun cycle |
| `dart run melos list --graph` | seule arête `samtech_crm -> ui_kit` |
| `dart run melos run quality --no-select` | réussite |
| format dans `quality` | 25 fichiers, 0 changement |
| analyse dans `quality` | aucun diagnostic avec infos/avertissements fatals |
| tests `samtech_crm` | 7 passants |
| tests `ui_kit` | 18 passants |
| total | 25 tests passants |
| `flutter build apk --debug --no-pub` | réussite en 133,0 s |

APK produit sur l'arbre réel :

`apps/samtech_crm/build/app/outputs/flutter-apk/app-debug.apk`

Le build iOS n'a pas été tenté : Flutter/Xcode exige macOS. Les fichiers iOS ont été contrôlés statiquement seulement.

## 6. Test de reproductibilité sans état local

Les modifications n'étant pas encore commitées, un clone Git littéral ne peut pas les contenir. La vérification équivalente la plus stricte a donc utilisé une copie fidèle de l'arbre, créée sans :

- `.git` ;
- `.dart_tool` ;
- répertoires `build` ;
- fichiers d'IDE ;
- override Pub ;
- artefacts Flutter générés.

État de départ de cette copie : un lock racine, zéro override, zéro cache Dart et zéro répertoire de build.

Résultats :

| Contrôle sur copie propre | Résultat |
|---|---|
| `flutter pub get --enforce-lockfile` | réussite |
| hash du lock avant/après restauration | identique au lock de l'arbre réel |
| `dart run melos run quality --no-select` | réussite, analyse propre et 25 tests passants |
| `flutter build apk --debug --no-pub` | réussite en 115,7 s |
| APK debug | généré, 149 088 474 octets ; SHA-256 `407B6B6E8E630648BA94CE4B1B96352789A28516935E035C3D6739DA4911DF84` |

La copie temporaire et ses artefacts ont ensuite été supprimés. Ce contrôle démontre que le socle ne dépend pas des locks enfants, d'un override, d'un Melos global ou des caches du dépôt.

## 7. Contrôle de non-reprise du code interdit

Les références `sprint-0`, `spk-db-001` et `archive/ai-code-before-reset-20260715` n'ont pas été restaurées ni utilisées comme source. La comparaison demandée a porté uniquement sur les identifiants de blobs.

Résultat :

- aucune correspondance exacte pour une implémentation ou configuration substantielle du Sprint 0 actuel ;
- correspondance d'un `analysis_options.yaml` générique ;
- correspondances attendues dans des fichiers natifs générés par le même template Flutter.

Aucun indice de copie substantielle de l'ancien code n'a été trouvé. Une comparaison de hashes prouve l'absence de copie exacte, pas l'absence théorique de toute réécriture sémantique.

## 8. Validation CI distante post-audit

La Pull Request `#1` a déclenché le workflow de qualité sur GitHub Actions. Le premier passage s'est terminé avec succès en 2 min 02 s, mais a signalé la dépréciation de Node.js 20 dans `actions/checkout@v4`. Le workflow a donc été migré vers `actions/checkout@v6`, version officielle utilisant Node.js 24.

## 9. Risques résiduels et décisions différées

| Risque/limite | Impact | Action requise |
|---|---|---|
| iOS non compilé et test natif non exécuté | Bloquant avant une livraison iOS | Exécuter restauration, analyse, tests et build sur macOS/Xcode. |
| Variant Android `release` encore signé avec la clé debug du template | Bloquant avant publication, hors Sprint 0 | Configurer une signature de production sécurisée avant toute release. |
| `outline` `#CBD5E1` sur blanc a un contraste d'environ 1,48:1 | Potentiellement insuffisant pour la limite d'un futur contrôle non textuel | Revalider ou remplacer le token avant le premier TextField/OutlinedButton ; aucun tel composant n'est livré au Sprint 0. |
| Minima de plateformes issus du template, politique produit non validée | Risque de compatibilité lors des futurs plugins | Décider les minima Android/iOS après les spikes natifs. |
| Pub signale neuf versions transitives plus récentes incompatibles avec la résolution courante | Entretien futur, sans écart direct Sprint 0 identifié | Réexaminer par lot avec `flutter pub outdated`, sans forcer de résolution non testée. |

## 10. Verdict

Après correction, le Sprint 0 satisfait son périmètre technique vérifiable sur Windows :

- plateformes limitées à Android/iOS ;
- identité native cohérente ;
- workspace moderne, reproductible et sans cycle ;
- dépendances limitées au socle ;
- architecture minimale sans logique anticipée ;
- documentation honnête ;
- gate qualité vert ;
- APK Android généré sur l'arbre réel et un environnement sans état local.

Le socle peut être accepté comme fondation Android du Sprint 0. Il ne doit pas être présenté comme validé pour une livraison iOS ni comme prêt pour une publication Android release tant que les réserves de la section 8 ne sont pas levées.

## 11. Références techniques de politique

- Pub Workspaces : <https://dart.dev/tools/pub/workspaces>
- Migration Melos 8 : <https://melos.invertase.dev/guides/migrations>
- Melos 8.2.2 : <https://pub.dev/packages/melos>
- flutter_riverpod : <https://pub.dev/packages/flutter_riverpod>
- go_router : <https://pub.dev/packages/go_router>
