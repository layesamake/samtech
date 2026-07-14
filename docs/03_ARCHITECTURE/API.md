# API de licences — Contrat conceptuel V1

| Élément | Valeur |
|---|---|
| Statut | Contrat à spécifier en OpenAPI avant implémentation |
| Version | 0.5 |
| Date | 14 juillet 2026 |

## 1. Principes

- HTTPS uniquement ;
- préfixe `/v1` ;
- JSON UTF-8 ;
- tailles et délais limités ;
- dates serveur en ISO 8601 UTC dans l'API, converties par le client ;
- `request_id` dans chaque réponse ;
- `Idempotency-Key` pour activation et transfert ;
- erreurs stables, sans détails internes ;
- rate limiting ;
- jeton de licence signé et vérifié côté mobile.

## 2. Endpoints mobiles

### `POST /v1/activations`

Crée ou retrouve idempotemment une activation.

Requête conceptuelle :

```json
{
  "license_key": "XXXX-XXXX-XXXX",
  "app_id": "samtech_crm",
  "edition": "starter",
  "installation_id": "uuid",
  "installation_public_key": "base64url-or-null",
  "platform": "android",
  "app_version": "1.0.0",
  "locale": "fr_SN"
}
```

Réponse réussie :

```json
{
  "activation_id": "uuid",
  "license_token": "signed-opaque-token",
  "server_time": "2026-07-14T12:00:00Z",
  "policy": {
    "recheck_after": "2026-08-13T12:00:00Z",
    "grace_ends_at": "2026-09-12T12:00:00Z"
  },
  "request_id": "uuid"
}
```

### `POST /v1/activations/{activationId}/verify`

Vérifie l'état et renouvelle le jeton signé. L'authentification repose sur le jeton actuel et, si retenu, une preuve de possession de la clé d'installation.

### `POST /v1/activations/{activationId}/transfer-requests`

Crée une demande ou consomme une autorisation de transfert selon la politique. Une spécification séparée détaillera la preuve de propriété.

### `POST /v1/activations/{activationId}/deactivate`

Désactivation volontaire si la politique l'autorise. Opération idempotente et auditée.

### `GET /v1/mobile-config`

Configuration publique signée et non sensible : version minimale, message de maintenance, clés publiques de licence si le mécanisme de rotation le permet. L'application conserve des valeurs sûres embarquées si l'endpoint est indisponible.

## 3. Erreurs

Format :

```json
{
  "error": {
    "code": "LICENSE_DEVICE_LIMIT_REACHED",
    "message": "Cette licence a atteint sa limite d'activations.",
    "retryable": false
  },
  "request_id": "uuid"
}
```

Codes initiaux :

```text
LICENSE_KEY_INVALID
LICENSE_REVOKED
LICENSE_EXPIRED
LICENSE_DEVICE_LIMIT_REACHED
ACTIVATION_NOT_FOUND
ACTIVATION_MISMATCH
TRANSFER_NOT_ALLOWED
APP_VERSION_UNSUPPORTED
RATE_LIMITED
REQUEST_INVALID
SERVICE_TEMPORARILY_UNAVAILABLE
```

Le client utilise le code, pas le texte, pour son comportement.

## 4. Idempotence

- la même clé d'idempotence et le même corps retournent le même résultat ;
- même clé avec corps différent retourne un conflit ;
- rétention côté serveur suffisante pour les reprises mobiles ;
- l'activation ne consomme pas plusieurs sièges lors d'un timeout client.

## 5. Authentification et signature

Le jeton signé prouve les droits offline. Les appels suivants prouvent la possession de l'activation par jeton et éventuellement signature d'un nonce. Le format final doit éviter les jetons porteurs clonables si le spike de clé d'installation est concluant.

## 6. Versionnement

Les champs inconnus sont ignorables seulement si la spécification l'autorise. Un changement incompatible crée `/v2` ou un nouveau format de jeton. Les anciennes versions sont maintenues pendant une fenêtre documentée.

## 7. Résilience

- timeout de connexion et de réponse ;
- retry automatique seulement pour opérations idempotentes ou protégées par clé ;
- backoff exponentiel avec jitter ;
- respect de `Retry-After` ;
- circuit local simple pour éviter les boucles ;
- la grâce offline reste évaluée localement.

## 8. Portail administrateur

Les endpoints administratifs sont séparés de l'API mobile, protégés par identité forte, rôles, MFA et audit. Ils ne sont pas documentés dans le binaire mobile.

## 9. Données serveur minimales

- licence, offre, état et dates ;
- activation, installation pseudonyme, application, plateforme et versions ;
- journal de création, vérification, révocation et transfert ;
- aucune base contacts, facture, paiement ou message CRM.

## 10. Avant implémentation

- produire `openapi.yaml` ;
- définir schémas et limites exactes ;
- effectuer threat modeling API ;
- choisir signature et preuve de possession ;
- définir SLA, sauvegardes et rotation ;
- créer tests de contrat client/serveur ;
- valider conformité des boutiques.

