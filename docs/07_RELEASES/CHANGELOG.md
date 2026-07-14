# Changelog

Toutes les modifications notables sont consignées ici selon les principes de Keep a Changelog.

## [Non publié]

### Ajouté

- Prototype isolé `SPK-DB-001` pour Drift avec SQLite3MultipleCiphers, coffre natif, migrations, transactions, rotation, inspection des journaux et benchmark fictif.
- Rapport d'architecture `SPIKE_DB_ENCRYPTION.md` avec comparaison des candidats, résultats, réserves natives et recommandation d'intégration.
- Sprint 0 : application Flutter 3.44.6 générée pour Android et iOS.
- Pub workspace de huit packages partagés et orchestration Melos 8.2.2.
- Bootstrap Riverpod, navigation `go_router` et feature technique de démarrage.
- Thème clair et tokens d'espacement initiaux dans `samtech_ui_kit`.
- Tests widgets du bootstrap et de la navigation, analyse et formatage partagés.

- Squelette initial de la plateforme SAMTECH.
- Documentation produit, métier, technique, design, IA et marketing.
- Vision produit complète de SAMTECH CRM Starter.
- Cadrage fonctionnel détaillé du cahier des charges Starter.
- Décisions relatives à la cible, au périmètre, au rôle de WhatsApp et au modèle commercial initial.
- Catalogue numéroté des règles métier et conventions transversales.
- Backlog Starter avec user stories, priorités et critères d'acceptation.
- Quatorze cas d'utilisation et leur matrice de traçabilité.
- Index fonctionnel et transitions principales des états métier.
- Architecture UX mobile avec inventaire complet des écrans.
- Navigation, routes conceptuelles et parcours utilisateur critiques.
- Treize wireframes mobiles basse fidélité.
- Fondations du design system, catalogue de composants, iconographie et exigences d'accessibilité.
- Décisions UX sur la navigation, les contacts unifiés et les tokens partagés.
- Modèle relationnel Starter de 25 tables et diagramme ERD.
- Dictionnaire exhaustif des données, contraintes, index et transactions critiques.
- Stratégies de migrations, fonctionnement offline, sauvegarde et restauration sécurisée.
- Décisions sur SQLite chiffré, les primitives durables, les snapshots financiers et la séparation sauvegarde/licence.
- Architecture Flutter feature-first en couches et règles de dépendance.
- Structure détaillée du monorepo, de l'application et des packages partagés.
- Politiques Riverpod, gestion d'erreurs, tests et dépendances.
- Modèle de menace et architecture de sécurité mobile/serveur.
- Protocole du gestionnaire de licences, machine d'états et rotation des clés.
- Contrat conceptuel versionné de l'API de licences.
- Décisions sur Riverpod, go_router, l'encapsulation des plugins et l'identité d'installation.

### Modifié

- Statut des décisions Flutter et offline-first passé de « proposé » à « validé ».
- Spécifications fonctionnelles enrichies pour relier modules, règles, stories et cas d'utilisation.
- Documentation design remplacée par une architecture prête pour le prototypage utilisateur.
- Documentation de base de données remplacée par un modèle logique prêt pour validation technique.
- Documentation technique remplacée par une architecture prête pour les spikes et le découpage des développements.

### Corrigé

- Script de tests Melos rendu non interactif pour les terminaux sans TTY et la CI.
- Dépendance inverse supprimée entre les écrans `startup` et le routeur global.
- Écran de route inconnue sécurisé et couvert par un test de navigation.
- Dimensions visuelles du démarrage centralisées dans `samtech_ui_kit`.
- Signature Android release par clé debug supprimée.
- Workflow GitHub Actions ajouté pour le formatage, l'analyse et les tests.
