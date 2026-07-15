# Sprint 0 — Socle technique Flutter

| Élément | Valeur |
|---|---|
| Statut | Implémenté et audité sur Windows ; validation iOS différée faute de macOS |
| Date | 15 juillet 2026 |

## 1. Objectif

Mettre en place le monorepo SAMTECH et initialiser un socle Flutter minimal selon l'architecture de référence, sans logique métier ni intégration anticipée.

## 2. Périmètre réalisé

- Pub Workspace Dart composé d'une application et de huit packages membres explicites ;
- Melos 8 configuré dans le `pubspec.yaml` racine, sans installation globale ;
- résolution Pub unique et politique d'un seul `pubspec.lock` racine ;
- CI GitHub Actions utilisant le SDK et le lockfile du projet ;
- bootstrap Riverpod, routeur déclaratif et écran de démarrage temporaire ;
- tokens et fondations UI dans `ui_kit`.

## 3. Périmètre exclu

- logique métier, modules fonctionnels, base de données et migrations ;
- Drift/SQLCipher, coffre natif, biométrie et notifications ;
- moteur PDF, sauvegarde, analytics, protocole de licence et synchronisation ;
- génération de code Riverpod ou routeur ;
- publication d'un package ou d'une application.

## 4. Membres du workspace

| Membre | Type au Sprint 0 | État |
|---|---|---|
| `apps/samtech_crm` | Flutter | bootstrap minimal Android/iOS |
| `packages/ui_kit` | Flutter | tokens et fondations de thème |
| `packages/analytics` | Dart | réservé, sans API ni logique métier |
| `packages/authentication` | Dart | réservé, sans API ni logique métier |
| `packages/backup` | Dart | réservé, sans API ni logique métier |
| `packages/license_manager` | Dart | réservé, sans API ni logique métier |
| `packages/notifications` | Dart | réservé, sans API ni logique métier |
| `packages/pdf_engine` | Dart | réservé, sans API ni logique métier |
| `packages/security` | Dart | réservé, sans API ni logique métier |

La qualification « Dart » décrit uniquement la frontière actuelle. Toute future intégration Flutter/native devra être isolée derrière des ports ou dans un adaptateur dédié.

## 5. Baseline technique

- Flutter `3.44.6` stable et Dart `3.12.2` ;
- Melos `8.2.2` ;
- `flutter_riverpod` `3.3.2` ;
- `go_router` `17.3.0` ;
- `flutter_lints` `6.0.0` et `lints` `6.1.0`.

Les contraintes sont déclarées dans les manifestes ; le lockfile racine constitue la résolution reproductible de référence.

## 6. Commandes de développement

Depuis la racine :

```shell
flutter pub get
dart pub workspace list
dart run melos run format --no-select
dart run melos run analyze --no-select
dart run melos run test --no-select
dart run melos run quality --no-select
```

`format` est un contrôle non mutant. `test` exécute les suites Flutter réellement présentes dans l'application et `ui_kit` ; les sept packages Dart réservés n'ont volontairement aucun test factice. La CI utilise `flutter pub get --enforce-lockfile` puis la même commande `quality`.

## 7. État des critères d'acceptation

| Critère | État documenté |
|---|---|
| Workspace et neuf membres reconnus | oui ; neuf membres exacts, graphe sans cycle |
| Android initialisé | oui |
| iOS initialisé | oui, mais build non validé |
| Riverpod et go_router amorcés | oui |
| Absence de logique métier | oui |
| Format, analyse et tests | oui ; format inchangé, analyse sans diagnostic, 25 tests passants |
| Build Android | oui ; APK debug généré sur l'arbre réel et sur une copie propre |
| Build iOS | non validé : environnement macOS indisponible |

Une structure initialisée n'est pas une preuve de build. Les résultats ci-dessus proviennent des commandes exécutées le 15 juillet 2026 avec Flutter 3.44.6 ; le rapport `SPRINT_0_AUDIT.md` en conserve le détail et les limites.

## 8. Risques et travaux différés

- valider iOS sur une machine macOS avant toute livraison ;
- exécuter les spikes chiffrement, licence, sauvegarde et notifications avant d'ajouter leurs dépendances ;
- ne créer les couches et API des packages réservés qu'au moment où un besoin validé les justifie.
