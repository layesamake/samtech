# Architecture de la base de données — SAMTECH CRM Starter

| Élément | Valeur |
|---|---|
| Statut | Modèle logique de référence |
| Version | 1.0 |
| Date | 14 juillet 2026 |
| Cible | SQLite local chiffré, accès via Drift à confirmer par prototype |

## 1. Objectifs

Le modèle doit :

- couvrir le cycle prospect → client → facture → paiement ;
- fonctionner intégralement en local pour la Starter ;
- préserver l'historique lors des modifications de contacts et produits ;
- garantir des calculs financiers déterministes ;
- supporter sauvegarde, restauration et migrations fiables ;
- préparer une synchronisation future sans l'implémenter en V1 ;
- rester performant avec au moins 5 000 contacts et un historique commercial réaliste, seuil à confirmer par tests.

## 2. Choix structurants

### 2.1 Base relationnelle

SQLite est retenu comme cible logique. Les clés étrangères sont activées à chaque connexion. Les écritures portant sur plusieurs tables utilisent une transaction.

### 2.2 Chiffrement

Le fichier local doit être chiffré avec une solution SQLite maintenue et auditée, compatible Android/iOS. Le choix précis — par exemple SQLCipher via une intégration Flutter éprouvée — reste soumis à un prototype avant validation technique définitive.

La clé de base n'est jamais stockée dans le fichier, les préférences ordinaires, les logs ou le dépôt. Elle est générée localement et protégée par le coffre natif de la plateforme.

### 2.3 Identifiants

Toutes les entités métier utilisent un UUID canonique stocké en `TEXT`. Cette décision facilite les imports et une synchronisation future sans dépendre d'un identifiant séquentiel local.

### 2.4 Temps

- horodatage technique : entier représentant les millisecondes UTC depuis l'époque Unix ;
- date métier sans heure : texte ISO `YYYY-MM-DD` ;
- échéance locale : instant UTC plus fuseau ou décalage d'origine lorsque l'intention locale doit être conservée ;
- l'interface convertit vers le fuseau configuré.

### 2.5 Montants

Les montants sont stockés en `INTEGER` dans la plus petite unité de la devise. Chaque document financier conserve le code devise ISO et le nombre de décimales utilisés lors de son émission.

### 2.6 Énumérations

Les états métier sont stockés sous forme de chaînes stables en anglais technique, contraintes par l'application et, lorsque raisonnable, par `CHECK`. Les libellés français restent dans la couche de présentation.

### 2.7 Archivage

- `archived_at` masque une entité des sélections actives tout en conservant son historique ;
- `deleted_at` est réservé aux suppressions logiques nécessaires ;
- factures émises et paiements validés ne sont jamais supprimés silencieusement ; ils sont annulés avec un motif et une trace.

### 2.8 Préparation à la synchronisation

Les tables métier modifiables possèdent `created_at`, `updated_at` et `record_version`. La V1 n'implémente ni serveur de synchronisation, ni outbox active, ni résolution de conflit.

## 3. Domaines et tables

### 3.1 Installation et configuration

| Table | Rôle |
|---|---|
| `organizations` | profil unique de l'entreprise locale |
| `app_settings` | paramètres non sensibles et préférences |
| `license_state` | cache local minimal de la licence signée |
| `backup_history` | historique local des exports/restaurations |

### 3.2 Référentiels

| Table | Rôle |
|---|---|
| `localities` | pays, régions, villes et quartiers hiérarchiques |
| `lead_sources` | origines des prospects |
| `tags` | étiquettes réutilisables |
| `product_categories` | catégories du catalogue |

### 3.3 Contacts et CRM

| Table | Rôle |
|---|---|
| `contacts` | identité et coordonnées uniques |
| `commercial_profiles` | statut prospect/client et qualification |
| `contact_tags` | association contacts-tags |
| `contact_consents` | historique du consentement marketing |
| `product_interests` | produits demandés par les contacts |
| `contact_notes` | notes éditables |
| `timeline_events` | événements commerciaux immuables |

### 3.4 Catalogue

| Table | Rôle |
|---|---|
| `products` | produits, services et formations |

### 3.5 Relances et messages

| Table | Rôle |
|---|---|
| `follow_ups` | relances et échéances |
| `message_templates` | bibliothèque de messages |
| `notification_jobs` | correspondance avec les notifications locales |

### 3.6 Campagnes

| Table | Rôle |
|---|---|
| `campaigns` | définition, état et filtres figés |
| `campaign_recipients` | destinataires figés, message et progression |

### 3.7 Facturation et paiements

| Table | Rôle |
|---|---|
| `invoice_sequences` | séquence transactionnelle de numérotation |
| `invoices` | en-tête, snapshots et totaux de facture |
| `invoice_lines` | lignes immuables après émission |
| `payments` | paiements et annulations contrôlées |

## 4. Relations principales

- Une organisation possède les données locales de la Starter.
- Un contact possède exactement un profil commercial.
- Un contact peut avoir plusieurs tags, intérêts, notes, événements, relances, consentements, campagnes et factures.
- Un produit appartient facultativement à une catégorie et peut apparaître dans plusieurs intérêts et lignes de facture.
- Une campagne possède une sélection figée de destinataires.
- Une facture possède une ou plusieurs lignes et zéro à plusieurs paiements.
- Une facture conserve ses snapshots sans dépendre de la modification future du contact, de l'organisation ou des produits.

Le diagramme complet est dans `ERD.md`. Les champs sont décrits dans `DATA_DICTIONARY.md`.

## 5. Contraintes d'intégrité

### 5.1 Contraintes obligatoires

- clés étrangères activées ;
- UUID non nuls et clés primaires ;
- `organization_id` valide sur toutes les entités appartenant à l'entreprise ;
- téléphone normalisé unique parmi les contacts non supprimés, sous réserve du traitement contrôlé des doublons ;
- une association contact-tag unique ;
- un intérêt contact-produit actif unique ;
- quantité de ligne strictement positive ;
- montants financiers non négatifs, paiement strictement positif ;
- date d'échéance non antérieure à la date d'émission ;
- numéro de facture unique dans l'organisation ;
- total des paiements valides inférieur ou égal au net à payer, garanti par transaction applicative et tests ;
- un destinataire unique par campagne et contact.

### 5.2 Suppressions référentielles

| Relation | Comportement |
|---|---|
| organisation → données | `RESTRICT` en usage normal |
| contact → profil/tags/intérêts/relances | `CASCADE` uniquement pour une purge autorisée |
| contact → factures | `RESTRICT` |
| produit → intérêts/lignes | `RESTRICT`, utiliser l'archivage |
| facture → lignes | `CASCADE` seulement pour un brouillon supprimable |
| facture → paiements | `RESTRICT` |
| campagne → destinataires | `CASCADE` uniquement pour un brouillon jamais démarré |

Les règles applicatives restent plus strictes que les cascades physiques.

## 6. Index

### 6.1 Contacts

- unique partiel sur `(organization_id, phone_normalized)` pour les contacts non supprimés ;
- index sur nom normalisé ;
- index sur `(organization_id, archived_at)` ;
- index sur `locality_id` ;
- index sur statut, niveau d'intérêt et date de premier contact via `commercial_profiles`.

### 6.2 Relances

- index sur `(organization_id, status, due_at)` ;
- index sur `(contact_id, due_at DESC)` ;
- index sur `notification_jobs(follow_up_id)`.

### 6.3 Campagnes

- index sur `(organization_id, status, created_at DESC)` ;
- unique sur `(campaign_id, contact_id)` ;
- index sur `(campaign_id, recipient_status, position)`.

### 6.4 Factures et paiements

- unique sur `(organization_id, invoice_number)` lorsqu'il est non nul ;
- index sur `(organization_id, status, issue_date DESC)` ;
- index sur `(contact_id, issue_date DESC)` ;
- index sur `(invoice_id, line_position)` ;
- index sur `(invoice_id, status, paid_at)` ;
- index sur `(organization_id, paid_at)` pour les statistiques.

### 6.5 Chronologie et statistiques

- index sur `(contact_id, occurred_at DESC)` ;
- index sur `(organization_id, event_type, occurred_at)` ;
- index sur produit et date pour les intérêts ;
- index sur dates de conversion, émission et paiement.

Tout index doit être justifié par une requête réelle et vérifié par `EXPLAIN QUERY PLAN` pendant l'implémentation.

## 7. Transactions critiques

Les opérations suivantes sont atomiques :

1. création d'un contact et de son profil commercial ;
2. conversion en client et création de l'événement ;
3. report d'une relance, mise à jour de notification et chronologie ;
4. démarrage d'une campagne et figement des destinataires ;
5. émission d'une facture, attribution du numéro, snapshot et événement ;
6. ajout/annulation d'un paiement, recalcul de l'état et chronologie ;
7. restauration d'une sauvegarde ;
8. migration de schéma.

## 8. Données dérivées

Ne pas stocker un indicateur si une requête fiable et suffisamment rapide peut le calculer. Les valeurs suivantes sont dérivées :

- relance « en retard » à partir de l'état et de l'échéance ;
- solde de facture à partir du net à payer et des paiements valides ;
- état partiellement payée/payée à partir du solde ;
- chiffre d'affaires et encaissé à partir des factures/paiements ;
- produit le plus demandé à partir des intérêts.

Des vues SQL ou caches contrôlés pourront être introduits après mesure, jamais comme seconde source de vérité non synchronisée.

## 9. Données immuables et snapshots

À l'émission d'une facture :

- `seller_snapshot_json` conserve l'identité pertinente de l'entreprise ;
- `customer_snapshot_json` conserve l'identité pertinente du client ;
- la devise, les règles de calcul et mentions sont figées ;
- chaque ligne conserve désignation, quantité, prix, remise et taxe ;
- le PDF est régénérable à partir de ces données.

Le JSON est réservé aux snapshots versionnés et filtres figés ; les données nécessaires aux recherches et contraintes restent dans des colonnes relationnelles.

## 10. Confidentialité et minimisation

- aucune conversation WhatsApp complète n'est copiée ;
- les messages préparés sont conservés uniquement lorsque nécessaire à la traçabilité de campagne ;
- les logs ne contiennent ni numéro complet, ni note, ni contenu de message, ni clé ;
- les exports sont chiffrés et authentifiés ;
- la licence locale ne contient que les informations nécessaires à la vérification ;
- les politiques de conservation et suppression doivent être définies avant commercialisation par pays.

## 11. Sauvegarde

La sauvegarde logique ou physique choisie doit produire une image cohérente après point de contrôle WAL. Elle inclut la version de schéma, la version de format de sauvegarde, les données et métadonnées d'intégrité. La clé de licence privée et les secrets natifs sont exclus.

## 12. Tests requis

- contraintes de clés étrangères et unicité ;
- calculs monétaires et arrondis ;
- concurrence sur la numérotation ;
- émission et immutabilité des factures ;
- paiements partiels, complets et annulations ;
- campagnes suspendues/reprises sans doublon ;
- migration depuis chaque version supportée ;
- sauvegarde/restauration nominale, altérée et interrompue ;
- requêtes sur base vide, nominale et volumineuse ;
- ouverture avec mauvaise clé de chiffrement sans fuite de données.

## 13. Points à confirmer par prototype

- intégration Drift avec le moteur de chiffrement retenu ;
- rotation et récupération de la clé locale ;
- performances des recherches textuelles et besoin éventuel de FTS5 ;
- volume maximal garanti ;
- compatibilité de sauvegarde entre versions Android et iOS ;
- stratégie de stockage du logo et des fichiers PDF générés ;
- politique légale de conservation et de numérotation par marché.

