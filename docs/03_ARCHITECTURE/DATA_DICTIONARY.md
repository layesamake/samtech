# Dictionnaire de données — SAMTECH CRM Starter

| Élément | Valeur |
|---|---|
| Statut | Modèle logique de référence |
| Version | 1.0 |
| Date | 14 juillet 2026 |

## 1. Conventions

### Types logiques

| Type | Stockage SQLite | Convention |
|---|---|---|
| UUID | `TEXT` | forme canonique, clé générée côté application |
| Timestamp | `INTEGER` | millisecondes UTC depuis l'époque Unix |
| Date métier | `TEXT` | ISO `YYYY-MM-DD` |
| Booléen | `INTEGER` | `0` ou `1` avec contrainte |
| Montant | `INTEGER` | unité mineure, jamais flottant |
| Enum | `TEXT` | valeur technique stable |
| JSON snapshot | `TEXT` | JSON versionné et validé avant écriture |

### Colonnes communes

Sauf mention contraire, les entités métier modifiables contiennent :

| Colonne | Type | Null | Description |
|---|---|---:|---|
| `id` | UUID | non | clé primaire |
| `organization_id` | UUID | non | propriétaire local |
| `created_at` | Timestamp | non | création technique |
| `updated_at` | Timestamp | non | dernière modification |
| `record_version` | INTEGER | non | commence à 1, incrémenté à chaque modification |

`archived_at` ou `deleted_at` sont ajoutés seulement lorsque la règle métier l'exige.

## 2. Installation et configuration

### 2.1 `organizations`

Profil d'entreprise unique de l'installation.

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| `id` | UUID | non | PK |
| `legal_name` | TEXT | oui | raison sociale |
| `display_name` | TEXT | non | nom commercial non vide |
| `phone_display` | TEXT | oui | numéro affiché |
| `phone_normalized` | TEXT | oui | format comparable |
| `email` | TEXT | oui | format validé par l'application |
| `address_line` | TEXT | oui | adresse libre |
| `locality_text` | TEXT | oui | libellé figé de l'adresse de l'entreprise |
| `country_code` | TEXT | non | ISO alpha-2 |
| `currency_code` | TEXT | non | ISO 4217 si applicable |
| `currency_decimals` | INTEGER | non | généralement 0 pour XOF |
| `timezone_id` | TEXT | non | identifiant IANA |
| `tax_identifier` | TEXT | oui | selon marché |
| `registration_identifier` | TEXT | oui | selon marché |
| `logo_file_name` | TEXT | oui | référence interne, pas chemin absolu |
| `invoice_footer` | TEXT | oui | mention personnalisée |
| `created_at` | Timestamp | non | création |
| `updated_at` | Timestamp | non | modification |
| `record_version` | INTEGER | non | version |

Contraintes : un seul enregistrement actif dans la Starter, `currency_decimals` entre 0 et 3.

### 2.2 `app_settings`

Paramètres non sensibles. Les secrets et clés de chiffrement sont exclus.

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| `id` | UUID | non | PK |
| `organization_id` | UUID | non | FK unique |
| `locale_code` | TEXT | non | ex. `fr_SN` |
| `theme_mode` | TEXT | non | `system`, `light`, `dark` |
| `auto_lock_seconds` | INTEGER | non | valeur positive |
| `biometrics_enabled` | Booléen | non | préférence, pas secret |
| `notifications_enabled` | Booléen | non | état applicatif |
| `default_follow_up_priority` | Enum | non | `low`, `normal`, `high` |
| `backup_reminder_days` | INTEGER | non | zéro désactive le rappel |
| `invoice_prefix` | TEXT | non | ex. `FAC` |
| `invoice_yearly_reset` | Booléen | non | stratégie de séquence |
| `tax_enabled` | Booléen | non | affichage des taxes |
| `default_tax_basis_points` | INTEGER | non | 100 points = 1 % |
| `discount_before_tax` | Booléen | non | règle figée à l'émission |
| `created_at` | Timestamp | non | création |
| `updated_at` | Timestamp | non | modification |
| `record_version` | INTEGER | non | version |

### 2.3 `license_state`

Cache local minimal. Le jeton signé est opaque pour les données métier.

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| `id` | UUID | non | PK, un enregistrement |
| `organization_id` | UUID | oui | peut précéder la configuration |
| `license_key_hint` | TEXT | oui | version masquée, jamais clé complète si évitable |
| `license_type` | TEXT | non | `starter` en V1 |
| `status` | Enum | non | `not_activated`, `valid`, `grace`, `expired`, `revoked`, `transferable`, `invalid` |
| `device_binding_id` | TEXT | oui | identifiant pseudonyme |
| `activated_at` | Timestamp | oui | première activation locale |
| `last_verified_at` | Timestamp | oui | dernière vérification serveur réussie |
| `grace_ends_at` | Timestamp | oui | échéance calculée à partir du jeton |
| `signed_token` | TEXT | oui | jeton signé, sans clé privée |
| `token_version` | INTEGER | oui | version du format |
| `last_server_time` | Timestamp | oui | détection prudente d'anomalie d'horloge |
| `updated_at` | Timestamp | non | modification |

### 2.4 `backup_history`

Journal local informatif. Il ne garantit pas que le fichier externe existe encore.

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| `id` | UUID | non | PK |
| `organization_id` | UUID | non | FK |
| `operation_type` | Enum | non | `export`, `restore` |
| `status` | Enum | non | `started`, `succeeded`, `failed`, `cancelled` |
| `backup_format_version` | INTEGER | oui | version du fichier |
| `schema_version` | INTEGER | oui | version DB incluse |
| `file_display_name` | TEXT | oui | nom sans chemin sensible |
| `file_size_bytes` | INTEGER | oui | non négatif |
| `checksum_hint` | TEXT | oui | empreinte tronquée non secrète |
| `started_at` | Timestamp | non | début |
| `completed_at` | Timestamp | oui | fin |
| `error_code` | TEXT | oui | code non sensible |

## 3. Référentiels

### 3.1 `localities`

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| colonnes communes |  |  | voir section 1 |
| `parent_id` | UUID | oui | FK vers `localities` |
| `type` | Enum | non | `country`, `region`, `city`, `district` |
| `name` | TEXT | non | libellé affiché |
| `normalized_name` | TEXT | non | unicité logique dans parent/type |
| `country_code` | TEXT | oui | obligatoire pour pays, héritable sinon |
| `sort_order` | INTEGER | non | défaut 0 |
| `archived_at` | Timestamp | oui | archivage |

Contrainte unique active : `(organization_id, parent_id, type, normalized_name)`.

### 3.2 `lead_sources`

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| colonnes communes |  |  |  |
| `name` | TEXT | non | ex. WhatsApp, recommandation |
| `normalized_name` | TEXT | non | unicité active |
| `system_code` | TEXT | oui | code d'une source préinstallée |
| `sort_order` | INTEGER | non | défaut 0 |
| `archived_at` | Timestamp | oui | archivage |

### 3.3 `tags`

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| colonnes communes |  |  |  |
| `name` | TEXT | non | libellé |
| `normalized_name` | TEXT | non | unicité active |
| `color_token` | TEXT | oui | token du design system, pas hex arbitraire |
| `archived_at` | Timestamp | oui | archivage |

### 3.4 `product_categories`

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| colonnes communes |  |  |  |
| `name` | TEXT | non | libellé |
| `normalized_name` | TEXT | non | unicité active |
| `description` | TEXT | oui | texte court |
| `sort_order` | INTEGER | non | défaut 0 |
| `archived_at` | Timestamp | oui | archivage |

## 4. Contacts et CRM

### 4.1 `contacts`

Identité unique indépendamment du rôle prospect/client.

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| colonnes communes |  |  |  |
| `display_name` | TEXT | oui | valeur utilisateur ou calculée |
| `first_name` | TEXT | oui | prénom |
| `last_name` | TEXT | oui | nom |
| `company_name` | TEXT | oui | entreprise du contact |
| `profession` | TEXT | oui | profession/fonction |
| `phone_display` | TEXT | non | numéro lisible |
| `phone_normalized` | TEXT | non | comparaison et WhatsApp |
| `phone_country_code` | TEXT | non | ISO alpha-2 ou indicatif documenté |
| `email` | TEXT | oui | adresse validée si fournie |
| `locality_id` | UUID | oui | FK vers `localities` |
| `address_line` | TEXT | oui | adresse libre |
| `archived_at` | Timestamp | oui | archive métier |
| `deleted_at` | Timestamp | oui | suppression logique autorisée |

Index unique partiel sur téléphone normalisé pour les contacts non supprimés. La création forcée d'un doublon exigera une stratégie documentée si SQLite doit autoriser l'exception ; par défaut l'unicité stricte est privilégiée.

### 4.2 `commercial_profiles`

Une ligne exactement par contact.

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| `id` | UUID | non | PK |
| `organization_id` | UUID | non | FK |
| `contact_id` | UUID | non | FK unique |
| `prospect_status` | Enum | non | `new`, `contacted`, `interested`, `follow_up`, `negotiation`, `converted`, `lost` |
| `interest_level` | Enum | oui | `hot`, `warm`, `cold` |
| `lead_source_id` | UUID | oui | FK |
| `first_contact_at` | Timestamp | non | date du premier contact |
| `last_contact_at` | Timestamp | oui | dernière action confirmée |
| `converted_at` | Timestamp | oui | première conversion, immuable |
| `is_client` | Booléen | non | cohérent avec conversion |
| `lost_reason` | TEXT | oui | facultatif |
| `marketing_consent_current` | Enum | non | cache `unknown`, `allowed`, `denied` |
| `marketing_consent_updated_at` | Timestamp | oui | dernière décision |
| `created_at` | Timestamp | non | création |
| `updated_at` | Timestamp | non | modification |
| `record_version` | INTEGER | non | version |

La mise à jour du consentement courant et l'ajout à `contact_consents` sont transactionnels.

### 4.3 `contact_tags`

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| `contact_id` | UUID | non | PK composite, FK |
| `tag_id` | UUID | non | PK composite, FK |
| `created_at` | Timestamp | non | date d'association |

### 4.4 `contact_consents`

Historique append-only des décisions marketing.

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| `id` | UUID | non | PK |
| `organization_id` | UUID | non | FK |
| `contact_id` | UUID | non | FK |
| `channel` | Enum | non | `whatsapp` en V1, extensible |
| `status` | Enum | non | `unknown`, `allowed`, `denied` |
| `source` | TEXT | oui | oral, formulaire, import, utilisateur |
| `reason` | TEXT | oui | note factuelle |
| `recorded_at` | Timestamp | non | date métier |
| `created_at` | Timestamp | non | insertion technique |

### 4.5 `product_interests`

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| colonnes communes |  |  |  |
| `contact_id` | UUID | non | FK |
| `product_id` | UUID | non | FK |
| `interest_level` | Enum | oui | valeur spécifique facultative |
| `note` | TEXT | oui | contexte court |
| `interested_at` | Timestamp | non | date de la demande |
| `archived_at` | Timestamp | oui | fin de l'association active |

Unique active : `(contact_id, product_id)`.

### 4.6 `contact_notes`

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| colonnes communes |  |  |  |
| `contact_id` | UUID | non | FK |
| `body` | TEXT | non | texte non vide |
| `pinned` | Booléen | non | défaut 0 |
| `archived_at` | Timestamp | oui | archive |

### 4.7 `timeline_events`

Événement système immuable. Les corrections créent un autre événement.

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| `id` | UUID | non | PK |
| `organization_id` | UUID | non | FK |
| `contact_id` | UUID | non | FK |
| `event_type` | Enum | non | type stable documenté |
| `occurred_at` | Timestamp | non | date métier |
| `source_entity_type` | TEXT | oui | ex. `invoice`, `follow_up` |
| `source_entity_id` | UUID | oui | identifiant source |
| `summary_key` | TEXT | non | clé localisable |
| `metadata_json` | TEXT | oui | données minimales versionnées |
| `created_at` | Timestamp | non | insertion |

Pas de `updated_at` : table append-only.

## 5. Catalogue

### 5.1 `products`

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| colonnes communes |  |  |  |
| `category_id` | UUID | oui | FK |
| `type` | Enum | non | `product`, `service`, `training` |
| `name` | TEXT | non | libellé |
| `normalized_name` | TEXT | non | unicité active |
| `reference` | TEXT | oui | référence interne unique si fournie |
| `description` | TEXT | oui | description |
| `unit_label` | TEXT | oui | unité, séance, mois, etc. |
| `default_unit_price_minor` | Montant | non | supérieur ou égal à 0 |
| `currency_code` | TEXT | non | devise du prix par défaut |
| `tax_basis_points` | INTEGER | oui | taxe spécifique facultative |
| `archived_at` | Timestamp | oui | archivage |

## 6. Relances et messages

### 6.1 `follow_ups`

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| colonnes communes |  |  |  |
| `contact_id` | UUID | non | FK |
| `message_template_id` | UUID | oui | modèle suggéré |
| `status` | Enum | non | `pending`, `completed`, `postponed`, `cancelled` |
| `priority` | Enum | non | `low`, `normal`, `high` |
| `due_at` | Timestamp | non | échéance UTC |
| `due_timezone_id` | TEXT | non | fuseau d'intention |
| `note` | TEXT | oui | contexte |
| `prepared_message` | TEXT | oui | dernier message préparé si conservation justifiée |
| `completed_at` | Timestamp | oui | fin confirmée |
| `cancelled_at` | Timestamp | oui | annulation |
| `cancel_reason` | TEXT | oui | motif facultatif |
| `postponed_from_id` | UUID | oui | relance précédente |

« En retard » est calculé lorsque `status = pending` et `due_at < now`.

### 6.2 `message_templates`

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| colonnes communes |  |  |  |
| `name` | TEXT | non | unique actif |
| `normalized_name` | TEXT | non | unicité |
| `category` | TEXT | oui | premier contact, relance, promotion… |
| `body` | TEXT | non | contenu et variables autorisées |
| `variables_json` | TEXT | non | liste détectée/versionnée |
| `archived_at` | Timestamp | oui | archivage |

### 6.3 `notification_jobs`

Correspondance avec le planificateur natif, sans contenu sensible inutile.

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| `id` | UUID | non | PK |
| `organization_id` | UUID | non | FK |
| `follow_up_id` | UUID | non | FK unique |
| `platform_notification_id` | INTEGER | non | identifiant local |
| `scheduled_at` | Timestamp | non | date planifiée |
| `status` | Enum | non | `scheduled`, `cancelled`, `delivered_unknown`, `failed` |
| `last_error_code` | TEXT | oui | diagnostic non sensible |
| `updated_at` | Timestamp | non | modification |

## 7. Campagnes

### 7.1 `campaigns`

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| colonnes communes |  |  |  |
| `name` | TEXT | non | libellé |
| `objective` | TEXT | oui | objectif interne |
| `status` | Enum | non | `draft`, `ready`, `running`, `suspended`, `completed`, `cancelled` |
| `message_template_id` | UUID | oui | modèle source |
| `message_template_snapshot` | TEXT | oui | contenu figé au démarrage |
| `filter_snapshot_json` | TEXT | oui | filtres versionnés |
| `eligible_count` | INTEGER | oui | compteur figé |
| `excluded_count` | INTEGER | oui | compteur figé |
| `started_at` | Timestamp | oui | démarrage |
| `suspended_at` | Timestamp | oui | suspension |
| `completed_at` | Timestamp | oui | fin |
| `cancelled_at` | Timestamp | oui | annulation |
| `cancel_reason` | TEXT | oui | motif |

### 7.2 `campaign_recipients`

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| `id` | UUID | non | PK |
| `organization_id` | UUID | non | FK |
| `campaign_id` | UUID | non | FK |
| `contact_id` | UUID | non | FK |
| `position` | INTEGER | non | ordre stable, >= 1 |
| `display_name_snapshot` | TEXT | oui | libellé au démarrage |
| `phone_snapshot` | TEXT | non | numéro utilisé |
| `message_snapshot` | TEXT | non | message résolu |
| `recipient_status` | Enum | non | `pending`, `opened`, `completed`, `skipped`, `error` |
| `opened_at` | Timestamp | oui | ouverture externe déclarée par l'application |
| `completed_at` | Timestamp | oui | résultat déclaré |
| `skip_reason` | TEXT | oui | motif facultatif |
| `error_code` | TEXT | oui | code non sensible |
| `created_at` | Timestamp | non | figement |
| `updated_at` | Timestamp | non | progression |
| `record_version` | INTEGER | non | version |

Contraintes uniques : `(campaign_id, contact_id)` et `(campaign_id, position)`.

## 8. Facturation et paiements

### 8.1 `invoice_sequences`

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| `id` | UUID | non | PK |
| `organization_id` | UUID | non | FK |
| `sequence_key` | TEXT | non | ex. `FAC-2026` |
| `prefix` | TEXT | non | préfixe figé |
| `period` | TEXT | oui | année si réinitialisation |
| `last_value` | INTEGER | non | >= 0 |
| `padding` | INTEGER | non | taille numérique |
| `updated_at` | Timestamp | non | modification |

Unique : `(organization_id, sequence_key)`. L'incrément et l'émission sont dans la même transaction.

### 8.2 `invoices`

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| colonnes communes |  |  |  |
| `contact_id` | UUID | non | FK client |
| `invoice_sequence_id` | UUID | oui | FK après émission |
| `invoice_number` | TEXT | oui | nul en brouillon, unique après émission |
| `status` | Enum | non | `draft`, `issued`, `partially_paid`, `paid`, `cancelled` |
| `issue_date` | Date métier | oui | obligatoire à l'émission |
| `due_date` | Date métier | oui | >= issue_date |
| `currency_code` | TEXT | non | devise figée |
| `currency_decimals` | INTEGER | non | précision figée |
| `seller_snapshot_version` | INTEGER | oui | version du JSON |
| `seller_snapshot_json` | TEXT | oui | obligatoire à l'émission |
| `customer_snapshot_version` | INTEGER | oui | version du JSON |
| `customer_snapshot_json` | TEXT | oui | obligatoire à l'émission |
| `subtotal_minor` | Montant | non | >= 0 |
| `discount_minor` | Montant | non | >= 0 |
| `tax_minor` | Montant | non | >= 0 |
| `total_minor` | Montant | non | >= 0 |
| `discount_before_tax` | Booléen | non | règle figée |
| `notes` | TEXT | oui | notes visibles ou internes selon décision UI |
| `legal_terms_snapshot` | TEXT | oui | mentions figées |
| `issued_at` | Timestamp | oui | instant d'émission |
| `cancelled_at` | Timestamp | oui | annulation |
| `cancel_reason` | TEXT | oui | obligatoire si annulée |

Le solde n'est pas stocké comme source de vérité. L'état financier est recalculé dans la transaction de paiement.

### 8.3 `invoice_lines`

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| `id` | UUID | non | PK |
| `organization_id` | UUID | non | FK |
| `invoice_id` | UUID | non | FK |
| `product_id` | UUID | oui | FK d'origine, snapshot autonome |
| `line_position` | INTEGER | non | >= 1, unique par facture |
| `description_snapshot` | TEXT | non | désignation figée |
| `unit_label_snapshot` | TEXT | oui | unité figée |
| `quantity_scaled` | INTEGER | non | quantité entière mise à l'échelle |
| `quantity_scale` | INTEGER | non | puissance décimale, ex. 1000 |
| `unit_price_minor` | Montant | non | >= 0 |
| `discount_basis_points` | INTEGER | non | >= 0 |
| `tax_basis_points` | INTEGER | non | >= 0 |
| `line_subtotal_minor` | Montant | non | résultat avant remise/taxe |
| `line_discount_minor` | Montant | non | remise calculée |
| `line_tax_minor` | Montant | non | taxe calculée |
| `line_total_minor` | Montant | non | total figé |
| `created_at` | Timestamp | non | création |
| `updated_at` | Timestamp | non | modifiable seulement en brouillon |

La quantité utilise une représentation entière mise à l'échelle pour éviter les flottants tout en permettant 0,5 ou 1,25 unité.

### 8.4 `payments`

| Colonne | Type | Null | Règle |
|---|---|---:|---|
| `id` | UUID | non | PK |
| `organization_id` | UUID | non | FK |
| `invoice_id` | UUID | non | FK |
| `status` | Enum | non | `valid`, `cancelled` |
| `amount_minor` | Montant | non | strictement positif |
| `currency_code` | TEXT | non | identique à la facture |
| `payment_method` | Enum | non | `cash`, `wave`, `orange_money`, `bank_transfer`, `card`, `other` |
| `reference` | TEXT | oui | référence externe |
| `paid_at` | Timestamp | non | date effective |
| `note` | TEXT | oui | note courte |
| `cancelled_at` | Timestamp | oui | annulation |
| `cancel_reason` | TEXT | oui | obligatoire si annulé |
| `created_at` | Timestamp | non | saisie |

Pas de `updated_at` pour les valeurs financières validées. Une correction annule puis recrée un paiement.

## 9. Types d'événements initiaux

Valeurs prévues pour `timeline_events.event_type` :

```text
contact_created
contact_updated
contact_archived
contact_reactivated
prospect_status_changed
product_interest_added
product_interest_archived
note_created
note_updated
follow_up_scheduled
follow_up_postponed
follow_up_completed
follow_up_cancelled
campaign_recipient_opened
campaign_recipient_completed
campaign_recipient_skipped
contact_converted
invoice_issued
invoice_cancelled
payment_recorded
payment_cancelled
```

Toute nouvelle valeur nécessite une migration compatible, une clé de traduction et un test de chronologie.

## 10. Vues ou requêtes nommées proposées

- `active_contacts_with_profile` ;
- `today_follow_ups` ;
- `overdue_follow_ups` ;
- `invoice_payment_totals` ;
- `invoice_balances` ;
- `contact_financial_summary` ;
- `product_demand_summary` ;
- `campaign_progress_summary`.

Ces noms décrivent des requêtes Drift ou vues SQL. Leur matérialisation n'est décidée qu'après mesure.

## 11. Traçabilité vers les règles métier

| Domaine | Tables | Règles principales |
|---|---|---|
| Contact unique | `contacts`, `commercial_profiles` | BR-CON-001 à BR-CON-010 |
| Référentiels | `localities`, `lead_sources`, `tags`, `product_categories` | BR-REF-001 à BR-REF-005 |
| Produits | `products`, `product_interests` | BR-PRO-001 à BR-PRO-006 |
| Chronologie | `contact_notes`, `timeline_events` | BR-TIM-001 à BR-TIM-004 |
| Relances | `follow_ups`, `notification_jobs` | BR-FOL-001 à BR-FOL-007 |
| Messages | `message_templates` | BR-MSG-001 à BR-MSG-005 |
| Campagnes | `campaigns`, `campaign_recipients` | BR-CAM-001 à BR-CAM-009 |
| Factures | `invoice_sequences`, `invoices`, `invoice_lines` | BR-INV-001 à BR-INV-012 |
| Paiements | `payments` | BR-PAY-001 à BR-PAY-007 |
| Sauvegarde | `backup_history` | BR-BCK-001 à BR-BCK-006 |
| Licence | `license_state` | BR-LIC-001 à BR-LIC-009 |

