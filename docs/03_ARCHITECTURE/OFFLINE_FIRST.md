# Architecture offline-first

| Élément | Valeur |
|---|---|
| Statut | Référence Starter et préparation V2 |
| Version | 1.0 |
| Date | 14 juillet 2026 |

## 1. Principe

La base locale chiffrée est la source opérationnelle de la Starter. Créer un prospect, planifier une relance, convertir, facturer, payer, consulter les statistiques et sauvegarder ne dépendent pas d'un serveur métier.

## 2. Fonctions nécessitant Internet

- activation et vérification périodique de licence ;
- ouverture de WhatsApp si son fonctionnement externe exige Internet ;
- support ou liens web facultatifs ;
- futurs services cloud hors V1.

L'indisponibilité du réseau ne bloque pas les données locales. Une fonction réseau affiche son besoin au moment de l'action.

## 3. Modèle de cohérence

- lecture après écriture immédiate dans la base locale ;
- transaction pour toute opération multi-table ;
- l'interface observe les requêtes locales via Drift ;
- aucune file réseau cachée pour les actions métier de V1 ;
- les états externes WhatsApp restent déclaratifs.

## 4. Préparation de la synchronisation future

Les entités modifiables possèdent UUID, `created_at`, `updated_at` et `record_version`. Cela ne constitue pas une synchronisation. La V2 devra décider séparément :

- identité serveur et authentification ;
- journal de mutations ou outbox ;
- curseurs de synchronisation ;
- résolution de conflits par type d'entité ;
- chiffrement en transit et au repos ;
- suppression propagée ;
- règles multi-utilisateur.

Les factures émises et paiements seront traités comme événements financiers nécessitant une stratégie plus stricte que les notes ou tags.

## 5. Horloge

L'appareil peut avoir une horloge incorrecte. Les dates saisies par l'utilisateur sont conservées comme intention métier ; les horodatages techniques utilisent l'horloge locale en V1 et sont marqués comme tels. Le serveur de licence conserve séparément son dernier temps vérifié sans réécrire l'historique commercial.

## 6. Notifications

Les notifications locales sont une projection de `follow_ups`. La base reste la source de vérité. Au lancement et après mise à jour, l'application réconcilie les échéances futures avec le planificateur natif.

## 7. Reprise après interruption

- formulaire : conserver un brouillon explicite lorsque la perte serait importante ;
- campagne : progression enregistrée après chaque destinataire ;
- facture : brouillon transactionnel, émission atomique ;
- paiement : écriture et recalcul atomiques ;
- sauvegarde/restauration : fichiers temporaires et remplacement atomique ;
- migration : transaction ou copie-remplacement.

## 8. Indicateurs UX

Le mot « hors ligne » n'est pas affiché en permanence lorsque tout fonctionne. Une bannière apparaît seulement lorsqu'une action précise requiert Internet ou lorsque la licence approche de la fin de sa grâce.

## 9. Tests offline

- lancement sans réseau après activation ;
- coupure pendant vérification de licence ;
- création et facturation en mode avion ;
- redémarrage pendant une campagne ;
- notification après redémarrage du téléphone ;
- changement de fuseau et d'heure ;
- retour du réseau sans duplication ni modification de données locales.

