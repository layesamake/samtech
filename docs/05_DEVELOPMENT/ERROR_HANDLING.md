# Gestion des erreurs

| Élément | Valeur |
|---|---|
| Statut | Politique de référence |
| Version | 1.0 |
| Date | 14 juillet 2026 |

## 1. Principe

Une erreur doit être traitée à la frontière qui la comprend. Les exceptions de bibliothèques ne traversent pas l'application jusqu'aux widgets.

## 2. Résultat typé

Les opérations attendues retournent un type scellé interne :

```text
Result<T>
├── Success<T>(value)
└── Failure<T>(AppFailure)
```

Les erreurs de programmation et invariants impossibles restent des exceptions capturées au niveau global pour diagnostic, sans les présenter comme une erreur métier normale.

## 3. Taxonomie

| Famille | Exemples |
|---|---|
| Validation | téléphone invalide, montant impossible |
| Conflit | doublon, numéro de facture déjà attribué |
| Introuvable | contact supprimé, facture absente |
| Permission | notifications ou biométrie refusées |
| Réseau | indisponible, délai dépassé, TLS |
| Licence | clé invalide, grâce expirée, révocation |
| Persistance | ouverture, contrainte, transaction |
| Migration | version inconnue, invariant non respecté |
| Cryptographie | clé absente, signature ou authentification invalide |
| Stockage | espace insuffisant, fichier inaccessible |
| Application externe | WhatsApp absent, partage annulé |
| Document | génération ou police PDF |
| Sauvegarde | fichier altéré, incompatible, mauvais secret |
| Inattendue | défaut non classifié, corrélation locale |

Chaque failure possède un code stable, une récupérabilité, un contexte expurgé et éventuellement l'action conseillée.

## 4. Mapping par couche

```text
Exception plugin/SQLite/HTTP
  → DataFailure technique
  → mapping repository/use case
  → AppFailure stable
  → message et action de présentation
```

Le texte utilisateur est localisé à partir du code. Les messages bruts de SQLite, HTTP ou plugin ne sont jamais affichés.

## 5. Matrice de reprise

| Erreur | Données conservées | Action |
|---|---|---|
| Réseau licence | oui | réessayer, utiliser grâce si valide |
| WhatsApp absent | oui | copier ou partager autrement |
| Notification refusée | oui | continuer et ouvrir réglages |
| Émission facture échouée | brouillon intact | corriger/réessayer |
| Paiement échoué | aucun paiement partiel | réessayer |
| PDF échoué | facture intacte | régénérer |
| Sauvegarde échouée | base intacte | changer destination/réessayer |
| Restauration échouée | base précédente intacte | vérifier fichier/secret |
| Migration échouée | snapshot précédent | écran de récupération/support |
| Coffre inaccessible | base non ouverte | authentifier/redémarrer/support |

## 6. Messages utilisateur

Format recommandé :

1. résultat : « La sauvegarde n'a pas été créée » ;
2. sécurité : « Vos données actuelles n'ont pas été modifiées » ;
3. action : « Vérifiez l'espace disponible puis réessayez ».

Éviter « Une erreur est survenue » lorsque la cause utile est connue.

## 7. Journalisation

Journaliser : code, module, opération, instant, version et identifiant de corrélation aléatoire.

Ne jamais journaliser : nom, téléphone complet, note, message, adresse, contenu de facture, fichier PDF, PIN, clé DB, jeton de licence ou secret de sauvegarde.

## 8. Zone globale

Le bootstrap capture les erreurs Flutter, Dart asynchrones et isolate selon les mécanismes supportés. La capture globale :

- expurge le contexte ;
- écrit localement de manière limitée ;
- montre un écran récupérable si nécessaire ;
- n'envoie rien au réseau sans politique et consentement.

## 9. Codes initiaux

```text
VAL_PHONE_INVALID
VAL_AMOUNT_EXCEEDS_BALANCE
CON_CONTACT_DUPLICATE
LIC_KEY_INVALID
LIC_OFFLINE_GRACE_EXPIRED
LIC_TOKEN_SIGNATURE_INVALID
DB_OPEN_FAILED
DB_CONSTRAINT_FAILED
DB_MIGRATION_FAILED
CRYPTO_KEY_UNAVAILABLE
BACKUP_INTEGRITY_FAILED
BACKUP_VERSION_UNSUPPORTED
STORAGE_SPACE_INSUFFICIENT
PERMISSION_NOTIFICATIONS_DENIED
EXTERNAL_WHATSAPP_UNAVAILABLE
PDF_GENERATION_FAILED
UNEXPECTED_FAILURE
```

## 10. Tests

Chaque code attendu possède un test de mapping et un message localisable. Les parcours P0 testent au moins un échec récupérable et vérifient que l'état précédent reste cohérent.

