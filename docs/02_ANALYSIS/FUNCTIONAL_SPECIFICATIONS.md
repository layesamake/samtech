# Spécifications fonctionnelles — Index de traçabilité

| Élément | Valeur |
|---|---|
| Statut | Cadrage fonctionnel validable |
| Version | 0.3 |
| Date | 14 juillet 2026 |

## 1. Sources de vérité

- Vision et limites : `../01_PRODUCT/VISION.md`
- Périmètre complet : `CAHIER_DES_CHARGES.md`
- Règles identifiées : `BUSINESS_RULES.md`
- Conventions transversales : `RULES.md`
- Backlog testable : `USER_STORIES.md`
- Parcours métier : `USE_CASES.md`

## 2. Matrice des modules

| Module | Stories | Règles dominantes | Priorité |
|---|---|---|---|
| Licence et accès | US-LIC, US-SEC | BR-LIC | P0 |
| Configuration | US-SET | BR-SYS | P0 |
| Contacts et prospects | US-CON | BR-CON, BR-TIM | P0 |
| Référentiels | US-REF | BR-REF | P1 |
| Produits et services | US-PRO | BR-PRO | P0 |
| Relances | US-FOL | BR-FOL | P0 |
| Modèles | US-MSG | BR-MSG | P1 |
| Campagnes | US-CAM | BR-CAM | P0 |
| Clients | US-CLI | BR-CON, BR-STA | P0 |
| Factures | US-INV | BR-INV | P0 |
| Paiements | US-PAY | BR-PAY | P0 |
| Tableau de bord | US-DAS | BR-STA, BR-FOL | P0 |
| Statistiques | US-STA | BR-STA | P0 |
| Sauvegarde | US-BCK | BR-BCK | P0 |

## 3. Transitions principales

### Prospect

```text
Nouveau → Contacté → Intéressé → À relancer → Négociation → Converti
                 └──────────────────────────────→ Perdu
Perdu → À relancer
```

Tout passage vers « Converti » crée le profil client. Une réactivation depuis « Perdu » est tracée.

### Relance

```text
En attente → Terminée
En attente → Reportée → nouvelle relance En attente
En attente → Annulée
```

« En retard » est un qualificatif calculé d'une relance en attente, pas un état persistant indépendant.

### Campagne

```text
Brouillon → Prête → En cours ⇄ Suspendue → Terminée
    └──────────────→ Annulée
```

Une campagne terminée est immuable pour sa sélection et sa progression.

### Facture

```text
Brouillon → Émise → Partiellement payée → Payée
              └────────────→ Annulée
```

Les états de paiement sont calculés. Une facture comportant des paiements valides ne peut pas être annulée directement.

### Licence

```text
Non activée → Valide → Grâce → Valide
                 ├────→ Expirée
                 ├────→ Révoquée
                 └────→ Transférable
Toute licence → Invalide si la signature échoue
```

## 4. Événements de chronologie

Les événements minimaux sont : contact créé, statut modifié, note créée/modifiée, intérêt produit ajouté, relance planifiée/reportée/terminée/annulée, campagne traitée, prospect converti, facture émise/annulée, paiement créé/annulé et contact archivé/réactivé.

Chaque événement possède un type stable, une date métier, une date technique, l'entité source et un résumé localisable. Les données financières ou personnelles ne doivent pas être dupliquées inutilement dans le texte de l'événement.

## 5. États d'interface obligatoires

Chaque écran alimenté par des données prévoit :

- chargement initial ;
- contenu nominal ;
- absence totale de données ;
- absence de résultat filtré ;
- erreur récupérable ;
- indisponibilité réseau lorsque pertinente ;
- permission native refusée lorsque pertinente ;
- action en cours empêchant un double déclenchement.

## 6. Validation et qualité

Une fonctionnalité n'est prête au développement que si :

1. sa user story et sa priorité sont définies ;
2. ses règles métier sont référencées ;
3. les entrées, sorties et erreurs sont connues ;
4. ses événements de chronologie sont identifiés ;
5. les états d'interface sont prévus ;
6. les critères d'acceptation sont testables ;
7. les impacts Android/iOS et offline sont analysés ;
8. les impacts sur le modèle de données sont documentés.

## 7. Prochaine spécialisation

L'étape UX produira l'arborescence, les parcours écran par écran et les wireframes. L'étape données traduira les règles et événements en entités, relations, contraintes et index. Aucun choix d'interface ou de schéma ne doit contredire les règles identifiées sans nouvelle décision documentée.

