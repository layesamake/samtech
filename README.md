# SAMTECH Software Platform

Monorepo de référence pour les produits SAMTECH, à commencer par **SAMTECH CRM** : un CRM mobile offline-first centré sur WhatsApp, la prospection, la facturation et les paiements.

## État

Le Sprint 0 fournit uniquement le socle technique : un Pub Workspace Dart, une application Flutter minimale, un package UI et sept frontières de packages réservées. Aucune logique métier CRM n'est implémentée dans ces packages réservés.

Les projets Android et iOS sont initialisés. La validation iOS nécessite macOS et n'a pas été effectuée dans l'environnement Windows du Sprint 0.

## Outillage

- Flutter `3.44.6` stable, incluant Dart `3.12.2` ;
- Pub Workspaces avec une résolution et un `pubspec.lock` uniques à la racine ;
- Melos `8.2.2`, exécuté depuis la dépendance locale du workspace.

## Structure

- `apps/samtech_crm/` : application Flutter Android/iOS minimale ;
- `packages/ui_kit/` : tokens et fondations de thème Flutter ;
- `packages/{analytics,authentication,backup,license_manager,notifications,pdf_engine,security}/` : packages Dart réservés, sans API ni logique métier au Sprint 0 ;
- `docs/` : source de vérité produit, métier, technique, design et marketing ;
- `assets/`, `scripts/` et `test/` : emplacements partagés, utilisés seulement lorsqu'un besoin réel apparaît.

## Démarrage technique

Depuis la racine du dépôt :

```shell
flutter pub get
dart pub workspace list
dart run melos run quality --no-select
```

Les commandes Melos globales ne sont pas utilisées. La CI résout les dépendances avec `flutter pub get --enforce-lockfile` et exécute la même commande `quality` que le développement local.

## Gouvernance

Lire le manifeste et la vision produit avant toute évolution, consigner les décisions structurantes dans `docs/00_FOUNDATION/DECISIONS.md`, puis mettre à jour documentation, tests et changelog avec le code concerné.
