# Diagramme relationnel — SAMTECH CRM Starter

| Élément | Valeur |
|---|---|
| Statut | Modèle logique de référence |
| Version | 1.0 |
| Date | 14 juillet 2026 |

Le diagramme montre les relations principales. Les champs exhaustifs et règles de nullabilité sont dans `DATA_DICTIONARY.md`.

```mermaid
erDiagram
    ORGANIZATIONS ||--|| APP_SETTINGS : configure
    ORGANIZATIONS ||--|| LICENSE_STATE : active
    ORGANIZATIONS ||--o{ LOCALITIES : owns
    ORGANIZATIONS ||--o{ LEAD_SOURCES : owns
    ORGANIZATIONS ||--o{ TAGS : owns
    ORGANIZATIONS ||--o{ PRODUCT_CATEGORIES : owns
    ORGANIZATIONS ||--o{ PRODUCTS : sells
    ORGANIZATIONS ||--o{ CONTACTS : manages
    ORGANIZATIONS ||--o{ MESSAGE_TEMPLATES : owns
    ORGANIZATIONS ||--o{ CAMPAIGNS : runs
    ORGANIZATIONS ||--o{ INVOICES : issues
    ORGANIZATIONS ||--o{ BACKUP_HISTORY : records

    LOCALITIES ||--o{ LOCALITIES : parent_of
    LOCALITIES o|--o{ CONTACTS : locates
    LEAD_SOURCES o|--o{ COMMERCIAL_PROFILES : sources

    CONTACTS ||--|| COMMERCIAL_PROFILES : has
    CONTACTS ||--o{ CONTACT_TAGS : tagged
    TAGS ||--o{ CONTACT_TAGS : classifies
    CONTACTS ||--o{ CONTACT_CONSENTS : records
    CONTACTS ||--o{ PRODUCT_INTERESTS : expresses
    PRODUCTS ||--o{ PRODUCT_INTERESTS : requested
    CONTACTS ||--o{ CONTACT_NOTES : has
    CONTACTS ||--o{ TIMELINE_EVENTS : produces
    CONTACTS ||--o{ FOLLOW_UPS : receives
    CONTACTS ||--o{ CAMPAIGN_RECIPIENTS : targeted
    CONTACTS ||--o{ INVOICES : billed

    PRODUCT_CATEGORIES o|--o{ PRODUCTS : contains
    MESSAGE_TEMPLATES o|--o{ FOLLOW_UPS : suggests
    FOLLOW_UPS ||--o| NOTIFICATION_JOBS : schedules

    MESSAGE_TEMPLATES o|--o{ CAMPAIGNS : seeds
    CAMPAIGNS ||--o{ CAMPAIGN_RECIPIENTS : freezes

    INVOICE_SEQUENCES ||--o{ INVOICES : numbers
    INVOICES ||--|{ INVOICE_LINES : contains
    PRODUCTS o|--o{ INVOICE_LINES : originates
    INVOICES ||--o{ PAYMENTS : receives
```

## Agrégats métier

### Contact

Racine : `contacts`. Enfants transactionnels : profil, tags, consentements, intérêts, notes, relances et événements. Factures et campagnes référencent le contact mais conservent leurs propres snapshots.

### Campagne

Racine : `campaigns`. Les `campaign_recipients` deviennent immuables quant à la sélection après démarrage, mais leur progression évolue.

### Facture

Racine : `invoices`. Les lignes appartiennent à la facture. Les paiements sont des enregistrements financiers séparés, annulables mais non supprimables silencieusement.

### Installation

`organizations`, `app_settings` et `license_state` décrivent l'installation Starter. Les données commerciales ne sont pas contenues dans le jeton de licence.

## Règles de cardinalité importantes

- Une organisation Starter possède un profil actif.
- Un contact possède un profil commercial exactement.
- Un profil client correspond toujours à un contact existant.
- Une facture possède au moins une ligne avant émission.
- Une ligne peut référencer un produit, mais le snapshot de ligne reste autonome.
- Un paiement appartient à une seule facture.
- Un contact apparaît au maximum une fois dans une campagne donnée.

