# Security

Package Dart réservé à la future frontière de sécurité de SAMTECH.

## Statut Sprint 0

Aucune API, primitive cryptographique ni intégration de stockage sécurisé n'est implémentée. Le package réserve uniquement le nom et la frontière architecturale.

## Responsabilités envisagées

- ports de stockage sécurisé ;
- primitives cryptographiques validées, sans algorithme maison ;
- occultation des données sensibles dans les logs ;
- génération de secrets.

Les adaptateurs natifs seront isolés et ajoutés seulement après les spikes de sécurité.
