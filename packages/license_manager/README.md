# License Manager

Package Dart pur du prototype SPK-LIC-001, limité à la vérification locale stricte de licences SAMTECH au format JWS Compact Ed25519.

## Garanties du prototype

- authentification et intégrité du jeton avec `package:cryptography` ;
- profil JOSE V1 fermé (`alg`, `typ`, `kid`) et algorithme `EdDSA` uniquement ;
- parsing base64url canonique, UTF-8/JSON strict et rejet des doublons ;
- validation des claims, bindings, bornes temporelles et reculs d'horloge ;
- rotation par trousseau de clés publiques Ed25519 activées.

Le jeton est signé, pas chiffré : header et payload ne sont pas confidentiels. Le package n'accepte et n'expose aucune clé privée.

## Hors périmètre

Ce package n'est pas encore un gestionnaire de licence complet. Il ne fournit ni activation, stockage sécurisé, réseau, révocation distante, transfert, mode restreint ni export. `LicenseState.revoked` et `LicenseState.transferable` réservent les futurs états produits par des réponses serveur authentifiées ; le vérificateur local ne les simule pas.

Les erreurs de vérification sont des exceptions typées. L'intégration applicative devra les convertir en état `invalid` tout en préservant les données CRM et un chemin d'export sécurisé.

Voir `docs/03_ARCHITECTURE/SPIKE_LICENSE_SIGNATURE.md` et le rapport `docs/03_ARCHITECTURE/SPK_LIC_001_AUDIT.md`.
