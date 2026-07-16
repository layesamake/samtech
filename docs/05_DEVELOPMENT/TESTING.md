# Stratégie de tests

| Élément | Valeur |
|---|---|
| Statut | Politique de référence |
| Version | 1.0 |
| Date | 14 juillet 2026 |

## 1. Pyramide adaptée

```text
                 Tests appareil E2E
              Tests d'intégration Flutter
        Tests widgets / providers / repositories
             Tests unitaires du domaine
```

La majorité des règles est validée sans appareil. Les plugins et parcours natifs sont validés sur Android/iOS réels ou simulateurs appropriés.

## 2. Tests unitaires du domaine

Priorités :

- `Money`, quantités et arrondis ;
- transitions des états ;
- éligibilité de campagne ;
- normalisation téléphone ;
- calcul de facture ;
- paiement partiel/complet ;
- grâce et horloge de licence ;
- validation des snapshots et manifests.

Les règles financières et la machine d'états de licence exigent une couverture de branches exhaustive sur les scénarios documentés.

## 3. Tests application

Cas d'utilisation avec repositories fakes :

- création contact + profil ;
- conversion sans duplication ;
- report de relance ;
- figement campagne ;
- émission transactionnelle ;
- paiement et annulation ;
- sauvegarde/restauration ;
- activation/vérification de licence.

Horloge, UUID et réseau sont déterministes.

## 4. Tests base et migrations

- schéma, contraintes et index ;
- DAOs et requêtes observables ;
- transactions et rollback ;
- numérotation concurrente simulée ;
- migrations depuis chaque version publiée ;
- `foreign_key_check` ;
- invariants financiers ;
- base vide, nominale et volumineuse ;
- moteur chiffré avec bonne/mauvaise clé.

## 5. Tests de providers

- overrides et composition ;
- états chargement/succès/échec ;
- commandes non doublées ;
- auto-dispose ;
- propagation des flux ;
- session racine et redirections.

## 6. Tests widgets

- formulaires et erreurs ;
- liste vide et filtrée ;
- texte agrandi ;
- lecteurs d'écran via sémantique ;
- confirmations sensibles ;
- campagne un destinataire à la fois ;
- affichage des montants et statuts.

Les golden tests sont limités aux composants stables et documents visuels critiques, pas à chaque écran.

## 7. Tests PDF

- comparaison structurelle des textes et montants ;
- rendu visuel de factures courtes, longues et multipages ;
- accents, noms longs et gros montants ;
- police embarquée et absence de ressource réseau ;
- régénération identique à partir du snapshot.

## 8. Tests sauvegarde

- aller-retour complet ;
- mauvais secret, fichier altéré/tronqué ;
- version ancienne/future ;
- interruption ;
- Android vers iOS et inversement ;
- base existante intacte après échec ;
- licence non clonée.

## 9. Tests licence

- contrat API avec serveur simulé ;
- signature correcte/incorrecte ;
- vecteur Ed25519/JWS indépendant de la RFC 8037 ;
- segments compacts, alphabet base64url canonique, tailles et signatures de 0/63/64/65 octets ;
- UTF-8/JSON invalides, racines non-objet et doublons de clés, y compris échappées ;
- allowlist exacte du header JOSE et rejet de tout algorithme autre que `EdDSA` ;
- trousseau : doublons, type Ed25519, clé courante/ancienne/désactivée/retirée ;
- chaque claim absent, de mauvais type, vide, excessif ou invalide ;
- frontières exactes de `not_before`, `recheck_after`, `grace_ends_at` et recul d'horloge ;
- activation idempotente ;
- offline avant/après échéance ;
- horloge reculée ;
- révocation reçue ;
- transfert ;
- jeton d'une autre application ou installation.

Les tests Dart purs s'exécutent dans le package avec `dart test`, et dans le workspace avec `dart run melos run test:dart --no-select`. La porte complète est `dart run melos run quality --no-select`. Un nombre global de tests ne remplace pas les catégories adversariales ci-dessus.

## 10. Tests d'intégration natifs

| Fonction | Android | iOS |
|---|---:|---:|
| Coffre sécurisé | requis | requis |
| Biométrie/PIN système | requis | requis |
| Notifications et fuseau | requis | requis |
| Ouverture WhatsApp/repli | requis | requis |
| Partage texte/PDF | requis | requis |
| Sélection fichier | requis | requis |
| Base chiffrée | requis | requis |

## 11. Parcours E2E P0

1. activer, configurer et créer le PIN ;
2. créer et qualifier un prospect ;
3. relancer via WhatsApp simulé/contrôlé ;
4. exécuter et reprendre une campagne ;
5. convertir, facturer et partager ;
6. enregistrer deux paiements ;
7. sauvegarder, modifier les données puis restaurer ;
8. travailler en mode avion après activation.

## 12. Performance

Mesurer : démarrage, ouverture DB, recherche, listes, tableau de bord, émission, PDF, sauvegarde et migration. Jeux minimaux : 5 000 contacts, 10 000 événements, 2 000 factures et 4 000 paiements. Les seuils sont fixés après prototype sur appareil de référence.

## 13. CI

À chaque changement : format, analyse statique, tests unitaires, providers, widgets et base non native. Sur branche protégée ou livraison : génération vérifiée, migrations, PDF, build Android/iOS et tests d'intégration disponibles.

Le CI ne possède aucun certificat ou secret en clair. Les signatures de livraison utilisent les coffres du système d'intégration.

## 14. Critère de sortie

Une story P0 n'est terminée que si ses critères d'acceptation, règles métier, erreurs et plateformes concernées sont testés. Un pourcentage global de couverture ne remplace pas cette traçabilité.
