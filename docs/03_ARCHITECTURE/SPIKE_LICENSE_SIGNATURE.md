# SPK-LIC-001 — Signature et vérification de licence

| Élément | Valeur |
|---|---|
| Statut | Validé avec réserves ; audit dans `SPK_LIC_001_AUDIT.md` |
| Date | 15 juillet 2026 |

## 1. Question technique

SAMTECH CRM peut-il vérifier localement l'authenticité et l'intégrité d'une licence émise par le serveur sans embarquer de clé privée de signature ?

Le prototype répond positivement dans le modèle de menace documenté : JWS Compact fournit l'enveloppe, `EdDSA` désigne l'algorithme JOSE et `package:cryptography` fournit exclusivement Ed25519. La résistance au forgeage dépend de la protection de la clé privée serveur, de l'authenticité de la distribution des clés publiques et de l'intégrité de l'application.

## 2. Choix et limites cryptographiques

- HMAC est exclu : un secret de vérification embarqué permettrait aussi de signer.
- RSA et ECDSA ne font pas partie du profil V1, même s'ils peuvent convenir à d'autres protocoles.
- Ed25519 produit une signature de 64 octets et permet une vérification asymétrique avec une clé publique de 32 octets.
- Le jeton est **signé, pas chiffré**. Son header et son payload sont lisibles par toute personne qui le possède ; ils ne doivent contenir ni secret ni donnée CRM confidentielle.
- Une signature ne constitue pas, à elle seule, une garantie juridique de non-répudiation.

## 3. Profil JWS V1

Format : `BASE64URL(header).BASE64URL(payload).BASE64URL(signature)`.

Le header proté contient exactement :

```json
{"alg":"EdDSA","typ":"SAMTECH-LICENSE","kid":"key_1"}
```

Tout autre membre, notamment `jku`, `jwk`, `x5u`, `x5c` ou `crit`, est rejeté. `kid` est un identifiant local opaque de 1 à 64 caractères dans `[A-Za-z0-9_-]` ; ce n'est ni une URL ni un chemin et il ne déclenche aucune entrée/sortie.

Le payload contient exactement les claims suivants :

```json
{
  "token_version": 1,
  "issuer": "SAMTECH",
  "audience": "samtech_crm",
  "license_id": "LIC_123",
  "activation_id": "ACT_123",
  "edition": "starter",
  "app_id": "samtech.crm.starter",
  "installation_thumbprint": "THUMB_123",
  "issued_at": 1700000000,
  "not_before": 1700000000,
  "recheck_after": 1700086400,
  "grace_ends_at": 1700604800,
  "max_devices": 1,
  "key_id": "key_1"
}
```

Les dates sont des secondes Unix entières comprises entre 0 et `253402300799`. L'ordre imposé est `issued_at <= not_before <= recheck_after <= grace_ends_at`. Aucune tolérance d'horloge implicite n'est appliquée par ce prototype.

## 4. Ordre de vérification

1. Refuser un jeton vide, trop grand ou ne comportant pas exactement trois segments non vides.
2. Accepter uniquement l'alphabet base64url sans padding, refuser les longueurs impossibles, décoder puis réencoder pour prouver la forme canonique.
3. Décoder le header en UTF-8/JSON strict, refuser les racines non-objet, doublons et membres hors allowlist.
4. Imposer `alg == EdDSA`, le `typ` V1 et un `kid` sûr.
5. Sélectionner une clé publique activée, explicitement Ed25519, dans le trousseau local.
6. Exiger une signature de 64 octets et vérifier exactement les octets UTF-8 de `headerB64.payloadB64`.
7. Seulement après succès cryptographique, interpréter le payload UTF-8/JSON.
8. Valider les claims, le binding, les dates et l'état temporel.

Les limites actuelles sont 12 Kio pour le jeton, 1 024 caractères pour le segment header et 8 192 pour le segment payload.

## 5. Temps et recul d'horloge

L'heure métier est fournie dans `LicenseVerificationContext`; le domaine n'appelle pas `DateTime.now()`. L'heure effective vaut le maximum entre l'heure injectée et la dernière heure serveur authentifiée. Un recul positionne `requiresOnlineCheck` sans modifier artificiellement l'état : il ne peut donc prolonger ni la validité ni la grâce.

- `effectiveTime <= recheck_after` : `valid` ;
- `recheck_after < effectiveTime <= grace_ends_at` : `grace` ;
- `effectiveTime > grace_ends_at` : `expired`.

Une révocation distante n'est jamais inventée localement. Les états `revoked` et `transferable` sont réservés aux futurs flux serveur authentifiés.

## 6. Trousseau et rotation

`TrustedLicenseKeySet` accepte plusieurs clés publiques Ed25519 actives. Il refuse les identifiants dupliqués, vides, trop longs ou non sûrs, ainsi que les clés d'un autre type ou d'une mauvaise longueur. Une clé désactivée ou retirée n'est pas utilisable.

La clé publique n'est pas un secret et n'a pas à être chiffrée comme une clé privée. Sa distribution doit toutefois être authentique, par exemple via le code signé de l'application et un processus de mise à jour maîtrisé. Aucune API de production du package n'accepte ou n'expose une clé privée.

## 7. Tests et vecteur indépendant

La suite couvre la structure compacte, les encodages canoniques, UTF-8/JSON hostile, les doublons, l'allowlist JOSE, les algorithmes concurrents, les longueurs de signature, tous les claims, les bindings, la rotation et chaque frontière temporelle.

Un test indépendant reprend le JWS, la clé publique et la signature publiés dans la RFC 8037, annexes A.4 et A.5. Les autres graines déterministes sont confinées sous `test/`, marquées non secrètes et impropres à la production.

Les nombres exacts et commandes réellement exécutées sont consignés dans `SPK_LIC_001_AUDIT.md`.

## 8. Limites restantes

- aucun stockage natif, client HTTP, service de signature ou KMS n'est implémenté ;
- aucune validation Android/iOS native n'est apportée par le package Dart pur ;
- un appareil et une application entièrement compromis peuvent contourner le code local ;
- l'état de révocation n'est connu qu'après une réponse serveur authentifiée ;
- le mode restreint et l'export sécurisé restent à intégrer sans suppression des données CRM.

## 9. Références

- RFC 7515 — JSON Web Signature ;
- RFC 8037 — EdDSA for JOSE, annexes A.4/A.5 ;
- RFC 8725 — JSON Web Token Best Current Practices ;
- `package:cryptography` 2.9.0.
