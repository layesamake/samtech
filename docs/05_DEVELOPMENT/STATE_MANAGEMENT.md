# Gestion d'état avec Riverpod

| Élément | Valeur |
|---|---|
| Statut | Référence technique |
| Version | 1.0 |
| Date | 14 juillet 2026 |

## 1. Rôle

Riverpod gère la composition des dépendances et l'état de présentation. Il ne remplace ni le domaine ni la base de données.

## 2. Catégories

### Dépendances stables

Providers pour `Clock`, générateur UUID, base, repositories et services. Ils sont remplaçables par overrides dans les tests.

### Requêtes réactives

Providers observant les flux de repositories pour contacts, relances, factures et indicateurs. Drift reste la source de vérité.

### Commandes

Controllers/Notifiers pour création, édition, émission, paiement, campagne, sauvegarde et licence. Ils exposent un état de commande explicite.

### État UI local

`StatefulWidget`, hooks éventuels ou provider auto-disposé pour texte temporaire, onglet, filtres et sélection. Ne pas persister un état local sans besoin métier.

## 3. Règles

- Aucun provider « magasin global » contenant toute la base.
- Les widgets regardent uniquement l'état nécessaire, avec sélection ciblée si utile.
- Un provider ne déclenche pas un effet externe simplement parce qu'un widget le regarde.
- Les effets sont lancés par une commande explicite.
- Les providers d'écran sont auto-disposés sauf besoin documenté.
- Les services coûteux sont conservés à la durée appropriée.
- Le domaine ne dépend pas de `Ref`, `AsyncValue` ou `ProviderContainer`.

## 4. États de commande

Une commande distingue au minimum :

```text
idle
validating
submitting
success
failure(code, recoverability)
```

`AsyncValue` peut transporter l'asynchronisme technique, mais le ViewState conserve les informations métier nécessaires : champs invalides, progression, résultat et action de reprise.

## 5. Flux recommandé

```text
Widget
  → controller.command(input)
  → validation de présentation
  → use case
  → repository/service
  → Result métier
  → ViewState
  → Widget + effet UI ponctuel
```

Les navigations, snackbars et dialogues sont des effets de présentation déclenchés après un résultat, pas stockés éternellement dans un état réémis.

## 6. Formulaires

- conserver les valeurs dans un contrôleur de formulaire dédié ;
- séparer valeur, erreur et état d'envoi ;
- ne pas écrire en base à chaque frappe sauf brouillon explicitement conçu ;
- empêcher les doubles soumissions ;
- avertir avant abandon d'un formulaire modifié ;
- réinitialiser après réussite confirmée.

## 7. Session applicative

Un état racine calculé orchestre :

```text
booting
databaseRecoveryRequired
licenseActivationRequired
organizationSetupRequired
pinSetupRequired
locked
ready
licenseRestricted
```

Le routeur observe cet état, sans appeler les services réseau lui-même.

## 8. Tests

- override des ports et repositories ;
- horloge et UUID déterministes ;
- vérification de chaque transition d'état ;
- absence de double commande ;
- annulation/auto-dispose ;
- flux Drift simulés ou base temporaire ;
- erreurs attendues transformées en ViewState stable.

## 9. Génération

La génération Riverpod est retenue comme candidate car Drift utilise déjà un pipeline de génération. Elle doit être validée dans le prototype pour le temps de build et la lisibilité. Les fichiers générés ne contiennent aucune logique manuelle.

