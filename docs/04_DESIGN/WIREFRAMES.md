# Wireframes mobiles basse fidélité

| Élément | Valeur |
|---|---|
| Statut | Base de prototype, contenu à tester |
| Version | 1.0 |
| Date | 14 juillet 2026 |

Ces wireframes décrivent la hiérarchie, pas le style final. Les dimensions exactes seront définies dans les maquettes haute fidélité.

## WF-01 — Accueil

```text
┌──────────────────────────────────┐
│ Bonjour                      🔍  │
│ Mardi 14 juillet                 │
├──────────────────────────────────┤
│ À faire aujourd'hui              │
│  5 relances  •  2 en retard   >  │
├──────────────────────────────────┤
│ Actions rapides                  │
│ [+ Prospect] [↻ Relance]         │
│ [▤ Facture ] [₣ Paiement]        │
├──────────────────────────────────┤
│ Prospects  128 │ Clients  34     │
│ Conversion 26,6 %                │
├──────────────────────────────────┤
│ Ce mois                          │
│ Facturé       450 000 FCFA       │
│ Encaissé      320 000 FCFA       │
│ Restant       130 000 FCFA    >  │
├──────────────────────────────────┤
│ Produit le plus demandé          │
│ Formation IA • 42 prospects   >  │
├──────────────────────────────────┤
│ Accueil Contacts Relances Ventes │
│                         Plus     │
└──────────────────────────────────┘
```

## WF-02 — Liste des contacts

```text
┌──────────────────────────────────┐
│ Contacts                     ⋮   │
│ [ Rechercher nom ou numéro    ]  │
│ [Tous] [Prospects] [Clients]     │
│ Filtres (2)              Trier   │
├──────────────────────────────────┤
│ AMINATA DIOP          À relancer │
│ +221 77 000 00 00 • Dakar        │
│ Formation IA • Chaud             │
│ Relance aujourd'hui               │
├──────────────────────────────────┤
│ MOUSSA BA              Nouveau   │
│ +221 76 000 00 00 • Thiès        │
│ Site web • Tiède                 │
├──────────────────────────────────┤
│                              [+] │
│ Accueil Contacts Relances Ventes │
│                         Plus     │
└──────────────────────────────────┘
```

## WF-03 — Création rapide d'un prospect

```text
┌──────────────────────────────────┐
│ ← Nouveau prospect               │
├──────────────────────────────────┤
│ Téléphone *                      │
│ [SN +221] [ 77 000 00 00      ]  │
│                                  │
│ Nom                              │
│ [ Aminata Diop                 ]  │
│                                  │
│ Produit demandé                  │
│ [ Sélectionner                v]  │
│                                  │
│ Localité                         │
│ [ Sélectionner                v]  │
│                                  │
│ [ Ajouter plus d'informations ]  │
│                                  │
│ [      Enregistrer le prospect ] │
└──────────────────────────────────┘
```

## WF-04 — Doublon probable

```text
┌──────────────────────────────────┐
│ Contact déjà présent             │
│                                  │
│ Ce numéro ressemble à une fiche  │
│ existante :                      │
│                                  │
│ Aminata Diop                     │
│ +221 77 000 00 00 • Dakar        │
│ Statut : À relancer              │
│                                  │
│ [      Ouvrir cette fiche      ] │
│ [ Compléter la fiche existante ] │
│                                  │
│ Créer quand même                 │
└──────────────────────────────────┘
```

## WF-05 — Fiche contact

```text
┌──────────────────────────────────┐
│ ← Aminata Diop               ⋮   │
│ +221 77 000 00 00                │
│ [À relancer] [Chaud] [Dakar]     │
├──────────────────────────────────┤
│ [       Ouvrir WhatsApp        ] │
│ [ Planifier une relance ]        │
├──────────────────────────────────┤
│ Prochaine relance                 │
│ Aujourd'hui à 15:00 • Haute   >  │
├──────────────────────────────────┤
│ Produits demandés                │
│ Formation IA • Formation Word    │
├──────────────────────────────────┤
│ Chronologie                      │
│ 14 juil.  Relance planifiée      │
│ 12 juil.  Message préparé        │
│ 10 juil.  Prospect créé          │
│                         Tout voir│
├──────────────────────────────────┤
│ [       Convertir en client    ] │
└──────────────────────────────────┘
```

## WF-06 — Relances

```text
┌──────────────────────────────────┐
│ Relances                     ＋  │
│ [Aujourd'hui] [Retard] [À venir] │
├──────────────────────────────────┤
│ 2 EN RETARD                      │
│ 09:00  Moussa Ba        Haute    │
│         Formation Web         >  │
│ 11:00  Fatou Ndiaye     Normale  │
├──────────────────────────────────┤
│ AUJOURD'HUI                      │
│ 15:00  Aminata Diop     Haute >  │
│ 17:30  Client Sarr      Faible>  │
├──────────────────────────────────┤
│ Campagnes en cours            >  │
│ Accueil Contacts Relances Ventes │
│                         Plus     │
└──────────────────────────────────┘
```

## WF-07 — Préparer une relance WhatsApp

```text
┌──────────────────────────────────┐
│ ← Préparer le message            │
├──────────────────────────────────┤
│ À : Aminata Diop                 │
│ +221 77 000 00 00                │
│                                  │
│ Modèle                           │
│ [ Relance après devis         v] │
│                                  │
│ Message                          │
│ ┌──────────────────────────────┐ │
│ │ Bonjour Aminata, je reviens  │ │
│ │ vers vous concernant la      │ │
│ │ Formation IA...              │ │
│ └──────────────────────────────┘ │
│ 142 caractères                   │
│                                  │
│ [       Ouvrir WhatsApp        ] │
│ L'envoi sera confirmé dans       │
│ WhatsApp.                        │
└──────────────────────────────────┘
```

## WF-08 — Ciblage d'une campagne

```text
┌──────────────────────────────────┐
│ ← Cibler les destinataires       │
├──────────────────────────────────┤
│ Localité       [ Dakar       v]  │
│ Produit        [ Formation IA ]  │
│ Statut         [ Intéressé    ]  │
│ Intérêt        [ Chaud + Tiède]  │
│ Tags           [ Promotion    ]  │
│                                  │
│ 48 contacts correspondent        │
│  3 exclus : refus marketing      │
│  1 exclu : numéro invalide       │
│                                  │
│ Destinataires retenus : 44       │
│ [       Voir la liste          ] │
│ [             Continuer        ] │
└──────────────────────────────────┘
```

## WF-09 — Exécution d'une campagne

```text
┌──────────────────────────────────┐
│ Campagne Rentrée       12 sur 44 │
│ ███████░░░░░░░░░  27 %           │
├──────────────────────────────────┤
│ Aminata Diop                     │
│ +221 77 000 00 00 • Dakar        │
│                                  │
│ ┌──────────────────────────────┐ │
│ │ Bonjour Aminata, découvrez   │ │
│ │ notre nouvelle session...    │ │
│ └──────────────────────────────┘ │
│                                  │
│ [       Ouvrir WhatsApp        ] │
│ [ Ignorer ]        [ Suspendre ] │
│                                  │
│ Chaque envoi est confirmé dans   │
│ WhatsApp.                        │
└──────────────────────────────────┘
```

## WF-10 — Éditeur de facture

```text
┌──────────────────────────────────┐
│ ← Nouvelle facture       Brouillon│
├──────────────────────────────────┤
│ Client                           │
│ Aminata Diop                  >  │
├──────────────────────────────────┤
│ Lignes                           │
│ Formation IA        1 × 75 000   │
│ Support PDF         1 ×  5 000   │
│                        [+ Ajouter]│
├──────────────────────────────────┤
│ Remise                      0     │
│ Taxe                        0     │
│ Sous-total         80 000 FCFA   │
│ TOTAL              80 000 FCFA   │
├──────────────────────────────────┤
│ Échéance             21/07/2026  │
│ Notes                         >  │
│                                  │
│ [ Sauvegarder ] [ Émettre      ] │
└──────────────────────────────────┘
```

## WF-11 — Détail d'une facture

```text
┌──────────────────────────────────┐
│ ← Facture FAC-2026-0042      ⋮   │
│ [Partiellement payée]            │
├──────────────────────────────────┤
│ Client : Aminata Diop            │
│ Émise : 14/07 • Échéance : 21/07 │
├──────────────────────────────────┤
│ Total             80 000 FCFA    │
│ Encaissé          30 000 FCFA    │
│ Reste             50 000 FCFA    │
├──────────────────────────────────┤
│ [      Enregistrer un paiement ] │
│ [ Voir le PDF ] [ Partager ]     │
├──────────────────────────────────┤
│ Paiements                        │
│ 14/07  Wave        30 000 FCFA > │
└──────────────────────────────────┘
```

## WF-12 — Paiement

```text
┌──────────────────────────────────┐
│ ← Enregistrer un paiement        │
├──────────────────────────────────┤
│ Facture FAC-2026-0042            │
│ Solde actuel : 50 000 FCFA       │
│                                  │
│ Montant *                        │
│ [ 50 000                      ]   │
│                                  │
│ Mode *                           │
│ [ Wave                        v]  │
│ Date *       [ 14/07/2026      ] │
│ Référence    [ WAVE-...         ]│
│                                  │
│ Après paiement : 0 FCFA          │
│ La facture sera marquée payée.   │
│                                  │
│ [      Enregistrer le paiement ] │
└──────────────────────────────────┘
```

## WF-13 — Sauvegarde et restauration

```text
┌──────────────────────────────────┐
│ ← Sauvegarde des données         │
├──────────────────────────────────┤
│ Dernière sauvegarde              │
│ 10 juillet 2026 à 18:42          │
│                                  │
│ [    Créer une sauvegarde      ] │
│ Fichier chiffré à conserver dans │
│ un emplacement sûr.              │
├──────────────────────────────────┤
│ Restaurer                        │
│ Remplace les données actuelles   │
│ après vérification du fichier.   │
│ [ Choisir une sauvegarde       ] │
└──────────────────────────────────┘
```

## Règles de prototypage

- Tester d'abord en niveaux de gris pour valider la hiérarchie sans dépendre de la couleur.
- Utiliser des données fictives réalistes, des noms longs et des montants élevés.
- Tester chaque écran avec taille de texte agrandie.
- Prévoir les états vide, erreur, hors ligne et permission refusée.
- La validation utilisateur précède toute maquette visuelle définitive.

