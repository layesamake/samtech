# Changelog

Toutes les modifications notables du projet SAMTECH CRM seront documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/).

## [Non publié]

### Ajouté

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
- Pub Workspace Dart composé d'une application et de huit packages membres explicites.
- Application Flutter Android/iOS minimale avec Riverpod, go_router et écran de démarrage.
- Package `ui_kit` contenant les fondations UI du Sprint 0.
- Packages `analytics`, `authentication`, `backup`, `license_manager`, `notifications`, `pdf_engine` et `security` réservés, sans API ni logique métier au Sprint 0.
- Workflow GitHub Actions pour le formatage non mutant, l'analyse statique et les tests Flutter réellement présents.
- Documentation du socle technique et de ses limites de validation.
- Rapport d'audit indépendant du Sprint 0 avec état initial, corrections, contrôles finaux et risques résiduels.

### Modifié

- Statut des décisions Flutter et offline-first passé de « proposé » à « validé ».
- Spécifications fonctionnelles enrichies pour relier modules, règles, stories et cas d'utilisation.
- Documentation design remplacée par une architecture prête pour le prototypage utilisateur.
- Documentation de base de données remplacée par un modèle logique prêt pour validation technique.
- Documentation technique remplacée par une architecture prête pour les spikes et le découpage des développements.
- Monorepo migré vers Pub Workspaces et Melos 8.2.2, avec un seul lockfile racine et des commandes Melos locales.
- Baseline portée à Flutter 3.44.6, Dart 3.12.2, Riverpod 3.3.2, go_router 17.3.0, `flutter_lints` 6.0.0 et `lints` 6.1.0.
- Workflow de qualité migré vers `actions/checkout@v6` afin d'utiliser l'environnement Node.js 24 maintenu par GitHub Actions.

### Validation Sprint 0

- Qualité : format non mutant, analyse fatale sans diagnostic et 25 tests passants sur l'arbre réel et une copie propre.
- Android : APK debug généré sur l'arbre réel et une copie propre restaurée avec `--enforce-lockfile`.
- iOS : projet initialisé mais non validé dans l'environnement Windows utilisé.

### Limites connues du Sprint 0

- Aucun module métier, stockage, protocole de licence, sécurité native, notification, PDF, sauvegarde ou analytics n'est implémenté.
- Les sept packages Dart réservés n'exposent aucune API fonctionnelle au Sprint 0.
