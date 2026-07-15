# Authentication

Package Dart réservé à la future frontière d'authentification locale de SAMTECH.

## Statut Sprint 0

Aucune API ni logique d'authentification n'est implémentée. Le package réserve uniquement le nom et la frontière architecturale.

## Responsabilités envisagées

- PIN avec dérivation de clé validée ;
- biométrie déléguée au système ;
- verrouillage temporisé ;
- session locale.

Les adaptateurs natifs éventuels seront décidés après les spikes de sécurité et ne devront pas compromettre le domaine Dart pur.
