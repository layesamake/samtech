# Structure du projet Flutter

| Élément | Valeur |
|---|---|
| Statut | Structure de référence |
| Version | 1.0 |
| Date | 14 juillet 2026 |

## 1. Monorepo

```text
samtech/
├── apps/
│   └── samtech_crm/
├── packages/
│   ├── analytics/
│   ├── authentication/
│   ├── backup/
│   ├── license_manager/
│   ├── notifications/
│   ├── pdf_engine/
│   ├── security/
│   └── ui_kit/
├── docs/
├── scripts/
├── test/
├── pubspec.yaml              # Pub workspace et configuration Melos
└── pubspec.yaml
```

Les services serveur de licence et le portail d'administration seront des livrables séparés. Leur emplacement final — même monorepo ou dépôts dédiés — sera décidé avant leur implémentation.

## 2. Application CRM

```text
apps/samtech_crm/
├── android/
├── ios/
├── assets/
│   ├── branding/
│   ├── fonts/
│   └── templates/
├── integration_test/
├── lib/
│   ├── main.dart
│   ├── bootstrap.dart
│   ├── app/
│   │   ├── app.dart
│   │   ├── app_config.dart
│   │   ├── router/
│   │   ├── localization/
│   │   └── shell/
│   ├── core/
│   │   ├── domain/
│   │   ├── errors/
│   │   ├── logging/
│   │   ├── time/
│   │   └── validation/
│   ├── database/
│   │   ├── app_database.dart
│   │   ├── tables/
│   │   ├── daos/
│   │   ├── migrations/
│   │   └── mappers/
│   └── features/
│       ├── activation/
│       ├── app_lock/
│       ├── dashboard/
│       ├── contacts/
│       ├── catalog/
│       ├── follow_ups/
│       ├── campaigns/
│       ├── invoicing/
│       ├── payments/
│       ├── statistics/
│       ├── backup_restore/
│       └── settings/
└── test/
```

## 3. Structure d'une fonctionnalité

```text
features/invoicing/
├── domain/
│   ├── entities/
│   ├── value_objects/
│   ├── repositories/
│   ├── policies/
│   └── failures/
├── application/
│   ├── commands/
│   ├── queries/
│   └── use_cases/
├── data/
│   ├── repositories/
│   ├── mappers/
│   └── models/
└── presentation/
    ├── controllers/
    ├── screens/
    ├── widgets/
    └── view_states/
```

Une fonctionnalité simple peut omettre un dossier vide. La structure reflète la complexité réelle, pas une obligation cérémonielle.

## 4. Packages partagés

### `ui_kit`

Tokens, thèmes, composants accessibles et états visuels. Ne dépend d'aucun domaine métier CRM.

### `security`

Ports et adaptateurs de stockage sécurisé, primitives cryptographiques validées, redaction et génération de secrets. Aucun algorithme maison.

### `authentication`

PIN, biométrie, verrouillage temporisé et session locale. Dépend de `security` par contrat minimal.

### `license_manager`

Modèle de licence, vérification de signature, machine d'états, période de grâce et client d'activation abstrait.

### `notifications`

Planification locale, permissions, fuseaux et réconciliation. Ignore le domaine des prospects.

### `pdf_engine`

Moteur de documents, polices, pagination et tests visuels. Reçoit un modèle de document figé.

### `backup`

Enveloppe, manifeste, chiffrement, validation et orchestration de restauration via ports.

### `analytics`

Mesures locales et événements minimisés. Aucune télémétrie distante par défaut.

## 5. Règles d'import

- `domain` importe Dart et d'autres éléments de domaine stables seulement ;
- `application` importe `domain` ;
- `data` importe `domain`, Drift et adaptateurs ;
- `presentation` importe application, domaine et UI kit ;
- un package partagé n'importe jamais `apps/samtech_crm` ;
- les fonctionnalités n'importent pas le dossier `presentation` d'une autre fonctionnalité ;
- les fichiers générés ne sont jamais édités manuellement.

## 6. Nommage

- fichiers Dart en `snake_case` ;
- classes en `UpperCamelCase` ;
- providers suffixés selon le rôle, pas systématiquement `Provider` dans le domaine ;
- ports nommés par capacité (`InvoiceRepository`, `Clock`, `SecureStorage`) ;
- implémentations suffixées (`DriftInvoiceRepository`, `PlatformSecureStorage`) ;
- écrans `...Screen`, contrôleurs `...Controller`, états `...ViewState` ;
- cas d'utilisation par verbe (`IssueInvoice`, `RecordPayment`).

## 7. Tests en miroir

`test/` reproduit la structure de `lib/`. Les fakes partagés restent dans `test/support/`, jamais dans la production. Les fixtures financières sont lisibles et datées.

## 8. Génération de code

Génération autorisée : Drift, Riverpod et sérialisation versionnée. Chaque générateur est épinglé par le lockfile et exécuté de manière reproductible. Le CI vérifie que le code généré est à jour selon la politique choisie.

## 9. Fichiers interdits dans Git

- clés de signature Android/iOS ;
- profils de provisionnement ;
- secrets d'API et clés privées ;
- bases réelles et sauvegardes ;
- PDF clients ;
- fichiers `.env` contenant un secret ;
- logs avec données personnelles.

## 10. Bootstrap du Sprint 0

Depuis le 14 juillet 2026, le monorepo utilise les Pub workspaces avec Melos 8.
Chaque membre déclare `resolution: workspace` et la liste explicite des membres
est maintenue dans le `pubspec.yaml` racine. Les commandes reproductibles sont
documentées dans `SPRINT_0.md`.
