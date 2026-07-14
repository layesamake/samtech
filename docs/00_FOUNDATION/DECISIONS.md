# Journal des décisions

Ce document consigne les décisions structurantes. Une décision validée ne doit pas être modifiée silencieusement : toute évolution crée une nouvelle entrée qui remplace explicitement l'ancienne.

## ADR-001 — Flutter

- Date : 14 juillet 2026
- Statut : validé
- Décision : utiliser Flutter pour SAMTECH CRM Starter.
- Motif : partager la majorité du code entre Android et iPhone et réduire le coût de maintenance.
- Conséquences : tester les deux plateformes, isoler les adaptations natives et suivre une version Flutter stable.

## ADR-002 — Offline-first

- Date : 14 juillet 2026
- Statut : validé
- Décision : rendre les fonctions commerciales principales utilisables sans Internet.
- Motif : garantir la continuité d'activité malgré une connexion instable ou coûteuse.
- Conséquences : base locale chiffrée, migrations robustes, UUID et architecture préparée à une synchronisation future.

## ADR-003 — Cible Starter

- Date : 14 juillet 2026
- Statut : validé
- Décision : cibler en priorité les indépendants, centres de formation, prestataires, petits commerces et commerciaux utilisant principalement WhatsApp.
- Motif : ces utilisateurs partagent un problème identifiable et un mode de travail compatible avec une application mobile simple.
- Conséquences : UX non technique, mobile-first, français initial et adaptation aux téléphones de gamme modeste.

## ADR-004 — Périmètre de la Starter

- Date : 14 juillet 2026
- Statut : validé
- Décision : couvrir prospects, clients, produits, relances, campagnes assistées, factures, paiements, statistiques, sauvegarde, PIN et licence.
- Motif : offrir un cycle commercial complet sans introduire la complexité du cloud et de la collaboration.
- Conséquences : WhatsApp reste externe ; aucun envoi automatique, cloud, multi-utilisateur, IA ou comptabilité complète en V1.

## ADR-005 — Positionnement de WhatsApp

- Date : 14 juillet 2026
- Statut : validé
- Décision : SAMTECH CRM assiste l'utilisateur autour de WhatsApp et ne remplace pas WhatsApp.
- Motif : conserver les habitudes existantes et respecter les limites techniques et réglementaires de la plateforme.
- Conséquences : l'application prépare les messages et ouvre WhatsApp ; l'utilisateur confirme chaque envoi.

## ADR-006 — Modèle commercial initial

- Date : 14 juillet 2026
- Statut : orientation validée, modalités à préciser
- Décision : proposer la Starter sous licence par appareil et réserver les services continus aux éditions supérieures.
- Motif : faciliter l'adoption d'une solution offline tout en préparant des revenus récurrents pour le cloud et les services avancés.
- Conséquences : intégrer un gestionnaire de licence compatible avec les règles de distribution Apple et Google.

## ADR-007 — Navigation principale

- Date : 14 juillet 2026
- Statut : validé pour prototypage
- Décision : utiliser cinq destinations principales — Accueil, Contacts, Relances, Ventes et Plus.
- Motif : faire correspondre la navigation aux tâches quotidiennes tout en limitant le nombre de destinations visibles.
- Conséquences : barre inférieure sur téléphone, rail possible sur grand écran et conservation de la même hiérarchie sur Android/iOS.

## ADR-008 — Base de contacts unifiée

- Date : 14 juillet 2026
- Statut : validé pour prototypage
- Décision : réunir prospects et clients dans la destination Contacts, avec des vues filtrées plutôt que deux silos de navigation.
- Motif : un prospect converti conserve la même identité et le même historique.
- Conséquences : une fiche contact à 360°, des filtres Prospect/Client et aucune duplication lors de la conversion.

## ADR-009 — Design system accessible par tokens

- Date : 14 juillet 2026
- Statut : validé pour la structure ; identité visuelle à confirmer
- Décision : centraliser couleurs, typographie, espacements et états dans le package `ui_kit`, avec accessibilité intégrée.
- Motif : assurer cohérence, maintenance et réutilisation dans les futurs produits SAMTECH.
- Conséquences : aucun style arbitraire dans les écrans ; palette bleu/turquoise proposée mais non définitive avant validation de marque.

## ADR-010 — Base locale relationnelle chiffrée

- Date : 14 juillet 2026
- Statut : modèle logique validé ; intégration technique à prototyper
- Décision : utiliser SQLite chiffré comme stockage local et Drift comme couche d'accès candidate.
- Motif : contraintes relationnelles, requêtes statistiques, migrations et fonctionnement Android/iOS offline.
- Conséquences : activer les clés étrangères, utiliser des transactions et valider la combinaison Drift/chiffrement avant génération du projet.

## ADR-011 — Primitives de données durables

- Date : 14 juillet 2026
- Statut : validé
- Décision : utiliser UUID pour les entités, millisecondes UTC pour les horodatages techniques, dates ISO pour les dates métier et entiers en unités mineures pour les montants.
- Motif : éviter les collisions, ambiguïtés de date et erreurs de nombres flottants, tout en préparant la synchronisation future.
- Conséquences : conversions centralisées et tests obligatoires des fuseaux, devises et arrondis.

## ADR-012 — Immuabilité financière et snapshots

- Date : 14 juillet 2026
- Statut : validé
- Décision : figer les données commerciales d'une facture lors de son émission et annuler plutôt que modifier/supprimer les factures et paiements validés.
- Motif : préserver l'audit, la régénération fidèle du PDF et les statistiques historiques.
- Conséquences : snapshots vendeur/client, lignes autonomes, numérotation transactionnelle et corrections par annulation puis nouvel enregistrement.

## ADR-013 — Séparation sauvegarde et licence

- Date : 14 juillet 2026
- Statut : validé
- Décision : une sauvegarde transfère les données commerciales mais ne clone pas la liaison de licence.
- Motif : protéger le modèle commercial tout en garantissant la portabilité des données de l'utilisateur.
- Conséquences : activation/transfert de licence séparé, sauvegarde chiffrée multiplateforme et absence de secret serveur dans l'archive.

## ADR-014 — Architecture feature-first en couches

- Date : 14 juillet 2026
- Statut : validé
- Décision : organiser SAMTECH CRM par fonctionnalités avec présentation, application, domaine et infrastructure selon la complexité réelle.
- Motif : isoler le métier, faciliter les tests et éviter une architecture globale divisée uniquement par types techniques.
- Conséquences : dépendances dirigées vers le domaine, composition au bootstrap et interdiction des imports croisés entre présentations de fonctionnalités.

## ADR-015 — Riverpod pour composition et état de présentation

- Date : 14 juillet 2026
- Statut : validé, génération à confirmer par spike
- Décision : utiliser Riverpod pour l'injection, les flux réactifs et les ViewModels/Controllers.
- Motif : dépendances remplaçables, états asynchrones explicites et tests par overrides.
- Conséquences : aucun provider dans le domaine, Drift reste la source persistante et aucun magasin global parallèle.

## ADR-016 — go_router pour la navigation

- Date : 14 juillet 2026
- Statut : validé
- Décision : utiliser `go_router` pour les routes, la shell des cinq destinations, les redirections de session et les liens de notification.
- Motif : solution déclarative recommandée dans l'écosystème Flutter et adaptée aux liens profonds.
- Conséquences : routeur piloté par un état de session stable, guards sans effets réseau directs et navigation typée à évaluer.

## ADR-017 — Encapsulation des plugins par ports

- Date : 14 juillet 2026
- Statut : validé
- Décision : encapsuler base, coffre, biométrie, notifications, PDF, partage, WhatsApp, fichiers et HTTP derrière des interfaces SAMTECH.
- Motif : empêcher le couplage du domaine aux plugins et permettre les fakes et remplacements.
- Conséquences : aucun plugin appelé depuis les widgets, tests de contrat et adaptateurs propres à Android/iOS.

## ADR-018 — Identité d'installation respectueuse de la vie privée

- Date : 14 juillet 2026
- Statut : validé pour prototype
- Décision : lier la licence à une identité d'installation générée par SAMTECH plutôt qu'à un identifiant matériel permanent.
- Motif : minimiser la collecte, faciliter la conformité et utiliser une preuve cryptographique contrôlée.
- Conséquences : réinstallation pouvant nécessiter un transfert, matériel privé conservé dans le coffre et protocole de preuve de possession à prototyper.

## ADR-019 — Serveur de licences séparé des données CRM

- Date : 14 juillet 2026
- Statut : validé
- Décision : déployer l'API et le portail de licences comme composants serveur distincts, sans données commerciales CRM.
- Motif : réduire l'impact d'une compromission et maintenir la Starter offline-first.
- Conséquences : contrat API versionné, MFA et audit administrateur, clé privée côté KMS/serveur uniquement.
