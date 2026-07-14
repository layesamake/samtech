# Cahier des charges — SAMTECH CRM Starter

| Élément | Valeur |
|---|---|
| Statut | Cadrage fonctionnel initial |
| Version du document | 0.2 |
| Date de mise à jour | 14 juillet 2026 |
| Référence produit | `docs/01_PRODUCT/VISION.md` |

## 1. Objet

Ce document définit le périmètre fonctionnel, les contraintes et les résultats attendus de SAMTECH CRM Starter V1 pour Android et iPhone. Il sert de base aux spécifications détaillées, aux parcours UX, au modèle de données et au découpage des développements.

## 2. Objectif général

Permettre à un utilisateur travaillant principalement avec WhatsApp de gérer le cycle suivant depuis son téléphone :

```text
Prospect → Qualification → Relance → Client → Facture → Paiement → Fidélisation
```

## 3. Acteurs

### 3.1 Utilisateur Starter

Propriétaire des données et utilisateur unique de l'application. Il gère ses contacts, relances, campagnes, factures, paiements et sauvegardes.

### 3.2 Administrateur SAMTECH

Gère les licences depuis un système distinct : création, activation, état, révocation et autorisation de transfert. Il n'accède pas aux données commerciales locales de l'utilisateur.

### 3.3 Services externes

- WhatsApp ou WhatsApp Business installé sur le téléphone ;
- système de partage Android/iOS ;
- service SAMTECH d'activation des licences ;
- système de notifications locales ;
- stockage choisi par l'utilisateur pour exporter une sauvegarde.

## 4. Plateformes et fonctionnement

- Android et iPhone dès la V1 ;
- interface mobile portrait en priorité ;
- mono-utilisateur ;
- une licence Starter par appareil ;
- base de données locale chiffrée ;
- fonctions commerciales principales disponibles sans Internet ;
- connexion requise uniquement pour les opérations de licence et futurs services en ligne ;
- français comme première langue, architecture préparée pour l'internationalisation.

## 5. Modules fonctionnels

### 5.1 Démarrage, licence et sécurité

L'application doit permettre :

- l'affichage d'un parcours de bienvenue ;
- l'activation par une clé de licence ;
- la vérification cryptographique de la licence locale ;
- l'affichage clair des états valide, grâce, expirée, révoquée ou invalide ;
- la création et la modification d'un PIN ;
- le verrouillage automatique après une période configurable ;
- l'usage facultatif de la biométrie lorsque le téléphone le permet ;
- une procédure contrôlée de transfert ou de récupération.

La perte de connexion ne doit pas bloquer immédiatement une licence déjà activée et valide.

### 5.2 Tableau de bord

Le tableau de bord doit afficher au minimum :

- le nombre total de prospects ;
- le nombre de clients ;
- les relances du jour et en retard ;
- le produit le plus demandé ;
- le chiffre d'affaires facturé ;
- les montants encaissés et restant dus ;
- des raccourcis vers les actions principales.

Les indicateurs doivent préciser la période utilisée et ouvrir la liste correspondante lorsque cela est pertinent.

### 5.3 Prospects et contacts

L'utilisateur doit pouvoir :

- créer, consulter, modifier, archiver et rechercher un prospect ;
- enregistrer nom, téléphone WhatsApp, coordonnées et notes ;
- associer pays, région, ville et quartier ;
- associer un ou plusieurs produits demandés ;
- attribuer source, tags, statut et niveau d'intérêt ;
- enregistrer la date du premier contact ;
- détecter les doublons probables par numéro normalisé ;
- ouvrir la conversation WhatsApp du contact ;
- consulter une chronologie des événements commerciaux.

### 5.4 Localités, tags et référentiels

L'utilisateur doit pouvoir créer et réutiliser ses localités, tags, sources et catégories. L'application doit limiter les doublons typographiques et permettre l'archivage d'une valeur sans supprimer l'historique associé.

### 5.5 Produits et services

Le catalogue doit gérer :

- nom, référence facultative, catégorie et description ;
- prix de vente et devise ;
- type produit, service ou formation ;
- état actif ou archivé ;
- association aux demandes des prospects et aux lignes de facture.

Une modification de prix ne doit jamais modifier rétroactivement une facture existante.

### 5.6 Relances

L'utilisateur doit pouvoir :

- planifier une relance avec date, heure, priorité et note ;
- recevoir une notification locale ;
- consulter les relances du jour, futures et en retard ;
- reporter, terminer ou annuler une relance ;
- sélectionner un modèle de message ;
- personnaliser le message avant d'ouvrir WhatsApp ;
- conserver l'événement de relance dans la chronologie.

### 5.7 Modèles de messages

L'application doit proposer une bibliothèque modifiable de modèles. Les variables autorisées peuvent inclure le prénom, le nom, l'entreprise, le produit et la localité. Une prévisualisation doit signaler toute variable non résolue avant le partage.

### 5.8 Campagnes assistées

L'utilisateur doit pouvoir :

- créer une campagne et définir son objectif ;
- filtrer les destinataires par localité, produit, statut, intérêt, tag, source ou période ;
- exclure les contacts ne devant pas recevoir de communication ;
- choisir un modèle et prévisualiser les messages ;
- ouvrir successivement les conversations WhatsApp ;
- marquer chaque destinataire comme préparé, ouvert, ignoré ou terminé ;
- interrompre puis reprendre la campagne ;
- conserver l'historique des destinataires.

La V1 ne doit pas envoyer de message automatiquement ni simuler une validation de l'utilisateur.

### 5.9 Conversion prospect-client

La conversion doit :

- conserver l'identité et la chronologie du contact ;
- enregistrer la date de conversion ;
- éviter la duplication du contact ;
- permettre la création immédiate d'une facture ;
- rendre disponibles l'historique des achats, factures et paiements.

Un client reste un contact commercial et peut recevoir de futures campagnes s'il est éligible.

### 5.10 Facturation

L'utilisateur doit pouvoir :

- créer un brouillon de facture depuis un client ;
- ajouter des produits ou lignes libres ;
- saisir quantité, prix, remise et taxe si activée ;
- calculer automatiquement sous-total, remises, taxes et net à payer ;
- attribuer un numéro unique selon une séquence configurable ;
- définir date d'émission et échéance ;
- passer par les états brouillon, émise, partiellement payée, payée ou annulée ;
- générer un PDF avec l'identité de l'entreprise ;
- partager le PDF par WhatsApp ou par le système natif.

Une facture émise doit conserver un instantané des informations du client, des lignes, prix et taxes utilisés.

### 5.11 Paiements

L'utilisateur doit pouvoir enregistrer :

- date, montant, mode et référence facultative ;
- paiements en espèces, Wave, Orange Money, virement, carte ou autre ;
- plusieurs paiements pour une même facture ;
- le solde restant calculé automatiquement ;
- l'annulation contrôlée d'un paiement erroné avec trace dans la chronologie.

Le total encaissé ne peut pas dépasser le net à payer sans traitement explicite d'un trop-perçu ou d'un avoir, hors périmètre initial.

### 5.12 Statistiques

La Starter doit fournir :

- prospects par période, localité, source et statut ;
- produits les plus demandés ;
- clients créés et taux de conversion ;
- produits les plus vendus ;
- montant facturé, encaissé et restant dû ;
- factures par état ;
- relances prévues, effectuées et en retard ;
- statistiques élémentaires des campagnes assistées.

Les calculs doivent être reproductibles à partir des données locales et afficher la période analysée.

### 5.13 Recherche et filtres

Une recherche doit retrouver les contacts par nom, téléphone et termes utiles. Les listes principales doivent accepter des filtres combinables et permettre de les réinitialiser facilement.

### 5.14 Paramètres de l'entreprise

L'utilisateur doit pouvoir configurer :

- nom commercial, coordonnées et logo ;
- devise et format des montants ;
- pays, langue et fuseau horaire ;
- numérotation des factures ;
- taxes et mentions affichées sur les PDF ;
- délai de verrouillage et préférences de notifications.

### 5.15 Sauvegarde et restauration

L'application doit permettre :

- la création manuelle d'une sauvegarde chiffrée ;
- le choix d'un emplacement ou d'une application de partage ;
- l'identification de la version du format ;
- la vérification de l'intégrité avant restauration ;
- un avertissement clair avant remplacement des données ;
- une restauration transactionnelle qui évite une base partiellement importée.

## 6. Règles métier structurantes

1. Les numéros sont conservés dans leur forme affichée et normalisés séparément pour la recherche de doublons.
2. Un contact ne doit pas être dupliqué lors de sa conversion en client.
3. Un produit archivé reste visible dans les historiques et factures.
4. Les montants sont stockés dans la plus petite unité monétaire afin d'éviter les erreurs d'arrondi.
5. Les dates techniques sont stockées en UTC et présentées dans le fuseau de l'utilisateur.
6. Les factures émises sont immuables pour leurs données commerciales essentielles ; une correction doit suivre un processus documenté.
7. Les suppressions susceptibles d'affecter l'historique utilisent l'archivage ou la suppression logique.
8. Chaque campagne exige une action explicite de l'utilisateur pour chaque message WhatsApp.
9. Les contacts ayant refusé les communications marketing doivent être exclus des campagnes.
10. Les opérations sensibles — restauration, transfert de licence, changement de PIN — exigent une confirmation renforcée.

Les règles exhaustives restent maintenues dans `BUSINESS_RULES.md` et `RULES.md`.

## 7. Exigences non fonctionnelles

### 7.1 Simplicité et accessibilité

- actions fréquentes accessibles en quelques étapes ;
- textes compréhensibles sans vocabulaire technique ;
- taille des contrôles adaptée au tactile ;
- contraste et mise à l'échelle du texte vérifiés ;
- états vide, chargement, erreur et hors ligne explicitement conçus.

### 7.2 Performance

- démarrage et recherche fluides sur des téléphones de gamme modeste ;
- listes paginées ou chargées progressivement ;
- opérations longues hors du fil d'interface ;
- objectifs chiffrés fixés lors du prototype de performance.

### 7.3 Sécurité

- chiffrement de la base et des sauvegardes ;
- clés stockées via les mécanismes sécurisés Android/iOS ;
- licence signée asymétriquement ;
- communications réseau protégées par TLS ;
- aucune donnée personnelle ou clé secrète dans les journaux ;
- versions de production signées et obfusquées ;
- collecte de données limitée au strict nécessaire.

### 7.4 Fiabilité

- migrations de base testées ;
- opérations de facture, paiement et restauration transactionnelles ;
- reprise claire après interruption ;
- compatibilité de restauration documentée entre versions.

### 7.5 Maintenabilité

- architecture Flutter modulaire ;
- packages partagés indépendants des applications ;
- analyse statique, tests et revues obligatoires ;
- documentation et changelog mis à jour avec chaque évolution.

## 8. Données principales

Le modèle détaillé devra couvrir au minimum :

- profil de l'entreprise et paramètres ;
- licence locale ;
- contacts, prospects et clients ;
- localités, sources et tags ;
- produits, catégories et intérêts ;
- chronologie et relances ;
- modèles, campagnes et destinataires ;
- factures, lignes et paiements ;
- métadonnées de sauvegarde.

La définition des tables, relations, contraintes et index appartient à `docs/03_ARCHITECTURE/DATABASE.md`.

## 9. Hors périmètre V1

- envoi automatique ou massif de WhatsApp ;
- lecture ou import automatique des conversations WhatsApp ;
- API WhatsApp Business ;
- cloud et synchronisation multiappareil ;
- multi-utilisateur et rôles ;
- portail web client ;
- comptabilité générale ;
- gestion avancée des stocks et achats fournisseurs ;
- devis, avoirs et bons de livraison avancés, sauf décision ultérieure ;
- paiements en ligne intégrés ;
- intelligence artificielle ;
- intégrations Facebook Lead Ads, sites web ou messagerie électronique.

## 10. Critères globaux d'acceptation

La Starter V1 sera fonctionnellement acceptable lorsque :

1. un nouvel utilisateur peut activer l'application et sécuriser l'accès ;
2. il peut créer un prospect, le classer et retrouver sa fiche ;
3. il peut planifier une relance et ouvrir un message personnalisé dans WhatsApp ;
4. il peut réaliser et reprendre une campagne assistée sans envoi automatique ;
5. il peut convertir un prospect sans perdre son historique ;
6. il peut créer une facture correcte, générer son PDF et la partager ;
7. il peut enregistrer plusieurs paiements et obtenir un solde exact ;
8. les statistiques essentielles correspondent aux données de test ;
9. les fonctions principales restent utilisables sans Internet ;
10. une sauvegarde chiffrée peut être restaurée sans perte ni duplication ;
11. les parcours critiques réussissent sur les versions Android et iOS supportées ;
12. les exigences de sécurité, accessibilité et qualité définies sont vérifiées.

## 11. Validation avant développement

Avant de générer le code Flutter, les livrables suivants doivent être finalisés :

- règles métier détaillées ;
- user stories et critères d'acceptation par module ;
- parcours et arborescence UX ;
- modèle relationnel et dictionnaire de données ;
- architecture technique et choix des dépendances ;
- modèle de menace et protocole de licence ;
- découpage de la V1 en lots de développement et de validation.

## 12. Points ouverts

Les décisions suivantes seront traitées dans les prochaines étapes :

- durée d'essai éventuelle et période de grâce de la licence ;
- politique exacte de transfert d'appareil ;
- pays et devise par défaut ;
- règles de taxe et mentions légales des factures par marché ;
- versions minimales Android et iOS ;
- volume maximal testé pour les contacts, factures et campagnes ;
- périmètre exact des remises, annulations et corrections de factures ;
- politique de consentement et de désinscription des campagnes.

