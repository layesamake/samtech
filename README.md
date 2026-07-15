# SAMTECH Software Platform

Monorepo de référence pour les produits SAMTECH, à commencer par **SAMTECH CRM** : un CRM mobile, offline-first, centré sur WhatsApp, la prospection, la facturation et les paiements.

## État

Fondations documentaires et structure de développement initialisées. Le code Flutter sera créé après validation des spécifications.

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
4. Installer Flutter stable, puis générer les projets uniquement après validation de l'architecture.

## Règle de gouvernance

Toute évolution du code doit mettre à jour la documentation, les tests et le changelog correspondants.
