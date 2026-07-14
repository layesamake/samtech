# Navigation et arborescence

| Élément | Valeur |
|---|---|
| Statut | Proposition de référence |
| Version | 1.0 |
| Date | 14 juillet 2026 |

## 1. Carte générale

```text
SAMTECH CRM
├── Accueil
│   ├── Tableau de bord
│   ├── Centre d'actions
│   └── Recherche globale
├── Contacts
│   ├── Tous
│   ├── Prospects
│   ├── Clients
│   ├── Archivés
│   └── Fiche contact
├── Relances
│   ├── Aujourd'hui
│   ├── En retard
│   ├── À venir
│   ├── Campagnes
│   └── Modèles
├── Ventes
│   ├── Vue d'ensemble
│   ├── Factures
│   ├── Paiements
│   └── Produits
└── Plus
    ├── Statistiques
    ├── Référentiels
    ├── Sauvegarde et restauration
    ├── Licence et sécurité
    ├── Paramètres entreprise
    └── Aide et à propos
```

## 2. Justification

- **Contacts** réunit prospects et clients car une même personne conserve son identité pendant la conversion.
- **Relances** rassemble le travail à effectuer et les campagnes, qui sont des relances groupées assistées.
- **Ventes** regroupe catalogue, factures et paiements.
- **Plus** contient les actions moins fréquentes et ne doit pas recevoir une fonction quotidienne sans réévaluation.

## 3. Navigation inférieure

| Destination | Libellé | Icône conceptuelle | Badge autorisé |
|---|---|---|---|
| Accueil | Accueil | maison | total des actions urgentes, plafonné |
| Contacts | Contacts | personnes | aucun par défaut |
| Relances | Relances | calendrier/coché | relances en retard |
| Ventes | Ventes | document/monnaie | factures échues, si activé |
| Plus | Plus | grille ou menu | action de licence urgente uniquement |

Les cinq libellés restent visibles. La destination active combine couleur, libellé et indicateur visuel, sans dépendre uniquement de la couleur.

## 4. Routes conceptuelles

Les noms définitifs dépendront de GoRouter, mais les routes fonctionnelles proposées sont :

```text
/onboarding
/license/activate
/unlock
/home
/search
/contacts
/contacts/new
/contacts/:contactId
/contacts/:contactId/edit
/contacts/:contactId/follow-ups/new
/follow-ups
/campaigns
/campaigns/new
/campaigns/:campaignId
/campaigns/:campaignId/run
/sales
/products
/invoices
/invoices/new
/invoices/:invoiceId
/invoices/:invoiceId/payment/new
/statistics
/settings
/settings/backup
/settings/license
```

Les identifiants de route ne doivent jamais contenir de nom, téléphone ou donnée personnelle.

## 5. Règles de retour

- Le retour ferme d'abord une feuille ou un dialogue, puis revient à l'écran précédent.
- Depuis une destination principale, le retour système Android demande de quitter seulement si aucun sous-écran n'est ouvert.
- Après création, l'utilisateur arrive sur le détail de l'objet créé.
- Après édition, il revient au détail avec confirmation discrète.
- Le retour vers une liste restaure position, recherche et filtres temporaires.
- Une campagne en cours ou un formulaire modifié intercepte le retour pour éviter une perte non annoncée.

## 6. Liens profonds internes

Une notification de relance ouvre la fiche de la relance dans le contexte du contact. Une notification de licence ouvre l'état de licence. Si l'application est verrouillée, l'utilisateur s'authentifie avant d'atteindre la destination, sans perdre le lien demandé.

## 7. Actions rapides

Le bouton global ne doit jamais masquer une action essentielle en bas de page. Il peut devenir un bouton étendu sur l'accueil et une action simple dans les listes. Les actions disponibles suivent les droits et l'état : aucune création de facture si le profil entreprise n'est pas suffisamment configuré.

## 8. Adaptation tablette

Une largeur supérieure peut utiliser :

- rail de navigation ;
- liste et détail côte à côte pour contacts et factures ;
- formulaires centrés avec largeur maximale.

Cette adaptation est progressive et ne change pas la hiérarchie fonctionnelle de la V1 téléphone.

