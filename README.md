# SAMTECH Software Platform

Monorepo de référence pour les produits SAMTECH, à commencer par **SAMTECH CRM** : un CRM mobile, offline-first, centré sur WhatsApp, la prospection, la facturation et les paiements.

## État

Sprint 0 initialisé : application Flutter Android/iOS, packages partagés,
workspace Melos, Riverpod, go_router, analyse statique et tests du socle.

## Structure

- `apps/samtech_crm/` : première application Android/iOS.
- `packages/` : composants Flutter réutilisables.
- `docs/` : source de vérité produit, métier, technique, design et marketing.
- `assets/` : ressources partagées.
- `scripts/` : outils de développement et de livraison.
- `test/` : tests transversaux.

## Démarrage

1. Lire `docs/00_FOUNDATION/SAMTECH_MANIFESTO.md` et `docs/01_PRODUCT/VISION.md`.
2. Valider le périmètre dans `docs/02_ANALYSIS/CAHIER_DES_CHARGES.md`.
3. Consigner toute décision structurante dans `docs/00_FOUNDATION/DECISIONS.md`.
4. Installer Flutter stable et exécuter `dart pub get` à la racine.
5. Lancer les scripts Melos `format`, `analyze` et `test`.

## Règle de gouvernance

Toute évolution du code doit mettre à jour la documentation, les tests et le changelog correspondants.
