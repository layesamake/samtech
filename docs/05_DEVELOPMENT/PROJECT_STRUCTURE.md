# Structure du projet Flutter

| Élément | Valeur |
|---|---|
| Statut | Structure Sprint 0 et cible future distinguées |
| Version | 1.1 |
| Date | 15 juillet 2026 |

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
├── assets/
├── docs/
├── scripts/
├── test/
├── pubspec.yaml        # membres workspace et configuration Melos 8
└── pubspec.lock        # résolution unique versionnée
```

Les neuf membres sont énumérés explicitement dans `workspace:`. Chacun déclare `resolution: workspace`. Aucun lockfile enfant ni override local persistant n'appartient au dépôt.

Les services serveur de licence et le portail d'administration seront des livrables séparés. Leur emplacement final — même monorepo ou dépôts dédiés — sera décidé avant leur implémentation.

## 2. Application CRM au Sprint 0

```text
apps/samtech_crm/
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   ├── bootstrap.dart
│   └── app/
│       ├── app.dart
│       ├── app_config.dart
│       ├── router/
│       └── presentation/screens/
└── test/
```

Android et iOS sont les seules plateformes produit conservées. Le build iOS n'est pas validé au Sprint 0 faute de machine macOS. Aucune arborescence `core`, `database` ou `features` n'est créée avant un besoin réel.

## 3. Structure cible d'une fonctionnalité

La structure suivante est une cible conditionnelle, pas une arborescence implémentée au Sprint 0 :

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

Au Sprint 0, `ui_kit` contient les fondations UI décrites ci-dessous. Les sept autres packages sont réservés, sans API ni logique métier ; leurs sections décrivent uniquement des responsabilités envisagées.

### `ui_kit`

Tokens documentés et thème clair Material 3. Les tokens sombres sont préparés, mais les composants, états visuels et le `ThemeData` sombre restent différés. Ne dépend d'aucun domaine métier CRM.

### `security`

Ports et adaptateurs de stockage sécurisé, primitives cryptographiques validées, redaction et génération de secrets. Aucun algorithme maison.

### `authentication`

PIN, biométrie, verrouillage temporisé et session locale. Une éventuelle dépendance contractuelle vers `security` devra être décidée lors de l'implémentation ; elle n'existe pas au Sprint 0.

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

## 5. Conventions cibles d'import

Ces règles s'appliqueront lorsque les couches concernées seront créées ; elles ne décrivent pas une arborescence déjà présente au Sprint 0.

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

## 7. Convention cible de tests en miroir

À mesure que les fonctionnalités seront ajoutées, `test/` reproduira la structure utile de `lib/`. Les fakes partagés resteront dans `test/support/`, jamais dans la production, et les fixtures financières seront lisibles et datées. Au Sprint 0, les tests couvrent seulement le bootstrap, le routeur, l'écran temporaire, les tokens et le thème, sans créer de miroirs vides.

## 8. Génération de code

La génération Drift, Riverpod ou de sérialisation n'est pas activée au Sprint 0. Si un spike la valide, chaque générateur sera contraint dans son manifeste, résolu par l'unique lockfile racine et exécuté de manière reproductible. La CI devra alors vérifier que le code généré est à jour.

## 9. Fichiers interdits dans Git

- clés de signature Android/iOS ;
- profils de provisionnement ;
- secrets d'API et clés privées ;
- bases réelles et sauvegardes ;
- PDF clients ;
- fichiers `.env` contenant un secret ;
- logs avec données personnelles.
