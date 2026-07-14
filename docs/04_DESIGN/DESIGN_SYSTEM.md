# Design system — SAMTECH CRM

| Élément | Valeur |
|---|---|
| Statut | Fondations proposées, identité visuelle à valider |
| Version | 0.5 |
| Date | 14 juillet 2026 |

## 1. Intention visuelle

L'interface doit paraître professionnelle, calme, accessible et fiable. Elle évite l'imitation visuelle de WhatsApp et conserve une identité SAMTECH propre.

La palette proposée associe un bleu profond, qui soutient la confiance, à un turquoise utilisé avec modération pour les actions positives. Ces couleurs restent provisoires jusqu'à validation de l'identité de marque.

## 2. Couleurs proposées

### 2.1 Couleurs de marque

| Token | Clair | Sombre | Usage |
|---|---|---|---|
| `brand.primary` | `#174A7E` | `#8FC8FF` | navigation, action principale |
| `brand.onPrimary` | `#FFFFFF` | `#002F52` | contenu sur primaire |
| `brand.secondary` | `#007C78` | `#6EDBD4` | accent, succès commercial |
| `brand.onSecondary` | `#FFFFFF` | `#003735` | contenu sur secondaire |

### 2.2 Surfaces neutres

| Token | Clair | Sombre |
|---|---|---|
| `surface.canvas` | `#F6F8FB` | `#101418` |
| `surface.base` | `#FFFFFF` | `#181C20` |
| `surface.raised` | `#FFFFFF` | `#20252A` |
| `surface.subtle` | `#EDF2F7` | `#293038` |
| `border.default` | `#CBD5E1` | `#46515C` |
| `text.primary` | `#16202A` | `#F1F5F9` |
| `text.secondary` | `#526170` | `#B8C2CC` |
| `text.disabled` | `#8A98A6` | `#788590` |

### 2.3 Couleurs sémantiques

| Token | Clair | Usage |
|---|---|---|
| `status.success` | `#18794E` | paiement, sauvegarde réussie |
| `status.warning` | `#9A6700` | grâce de licence, échéance proche |
| `status.danger` | `#B42318` | erreur, retard, action destructive |
| `status.info` | `#175CD3` | information et synchronisation future |

Chaque association texte/fond doit satisfaire les niveaux de contraste applicables. Une couleur sémantique est toujours accompagnée d'un texte, d'une icône ou d'une forme.

## 3. Typographie

Utiliser la police système de chaque plateforme dans la V1 pour la lisibilité, les performances et l'intégration native. Une police de marque pourra être ajoutée si sa licence, ses accents et son rendu des chiffres sont validés.

| Style | Taille indicative | Graisse | Usage |
|---|---:|---:|---|
| Display | 32 | 700 | chiffre principal exceptionnel |
| Titre 1 | 24 | 700 | titre d'écran |
| Titre 2 | 20 | 600 | section majeure |
| Titre 3 | 17 | 600 | carte ou sous-section |
| Corps | 16 | 400 | contenu principal |
| Corps compact | 14 | 400 | métadonnées lisibles |
| Libellé | 14 | 600 | boutons et champs |
| Légende | 12 | 400 | aide secondaire, jamais essentielle seule |

Le texte suit le facteur d'échelle du système. Les conteneurs doivent accepter au moins 200 % lorsque la plateforme le permet sans perdre les actions essentielles.

## 4. Espacement

Base de 4 points :

| Token | Valeur |
|---|---:|
| `space.1` | 4 |
| `space.2` | 8 |
| `space.3` | 12 |
| `space.4` | 16 |
| `space.5` | 20 |
| `space.6` | 24 |
| `space.8` | 32 |
| `space.10` | 40 |
| `space.12` | 48 |

Les marges d'écran sont de 16 points sur téléphone, adaptables à 24 points sur large écran. Les listes compactes ne réduisent jamais la cible tactile.

## 5. Formes et élévation

| Token | Valeur | Usage |
|---|---:|---|
| `radius.small` | 8 | puce, petit contrôle |
| `radius.medium` | 12 | champ, bouton, carte |
| `radius.large` | 16 | feuille et carte importante |
| `radius.full` | 999 | badge circulaire |

Les ombres restent discrètes. La hiérarchie privilégie la couleur de surface, la bordure et l'espacement. Une ombre forte n'est pas utilisée pour signaler un état métier.

## 6. Grille et dimensions

- largeur téléphone de référence : 360 à 430 points logiques ;
- largeur maximale des formulaires sur grand écran : 640 points ;
- cible tactile minimale : 48 × 48 points logiques ;
- champ standard : hauteur minimale 56 points ;
- bouton principal : hauteur minimale 48 points ;
- barre inférieure : dimension native adaptée à la plateforme.

## 7. Boutons

### Principal

Une seule action principale visible par zone. Fond primaire, libellé explicite et état de progression empêchant le double déclenchement.

### Secondaire

Bordure ou surface discrète. Utilisé pour une alternative réelle, pas pour toutes les actions disponibles.

### Texte

Actions de faible emphase et réversibles. La zone tactile reste complète.

### Destructif

Libellé explicite, couleur danger et confirmation proportionnée. Jamais placé comme action par défaut d'un dialogue.

## 8. Champs

Chaque champ comporte un libellé persistant, une valeur, une aide éventuelle et une erreur. Le placeholder ne remplace pas le libellé. Les champs téléphone, monnaie et date utilisent un clavier et un format adaptés sans empêcher la saisie locale.

## 9. Cartes et listes

Les cartes sont réservées aux regroupements utiles : priorité du jour, résumé financier, fiche contact. Une liste répétitive utilise des séparateurs et une hiérarchie typographique plutôt qu'une accumulation de cartes flottantes.

## 10. Statuts

Les statuts sont représentés par une puce combinant texte, couleur et éventuellement icône. Les libellés sont toujours complets : « Partiellement payée », pas seulement une couleur orange.

## 11. Visualisation des données

- privilégier barres horizontales pour localités et produits ;
- utiliser courbe uniquement pour une évolution temporelle ;
- éviter les graphiques circulaires au-delà de trois catégories ;
- afficher les valeurs exactes ou accessibles ;
- fournir une liste détaillée derrière chaque graphique ;
- conserver une palette compatible avec les déficiences de perception des couleurs.

## 12. Mouvement

Les animations expliquent un changement : ouverture de feuille, insertion d'une ligne, progression. Durées indicatives de 150 à 250 ms. Désactiver ou réduire selon les préférences système. Aucun mouvement décoratif ne retarde une action.

## 13. Thème sombre

Le thème sombre est préparé dans les tokens. Son inclusion dans le MVP dépendra du budget de validation. Il ne doit pas être livré sans contrôle de tous les PDF, graphiques, champs, dialogues et couleurs sémantiques.

## 14. Ton rédactionnel

- direct : « Enregistrer le prospect » ;
- rassurant : « Vos données actuelles resteront intactes si la restauration échoue » ;
- précis : « WhatsApp va s'ouvrir. Vous confirmerez l'envoi dans WhatsApp » ;
- non culpabilisant : « Aucun résultat pour ces filtres » ;
- orienté solution : « Vérifiez votre connexion puis réessayez ».

## 15. Gouvernance des tokens

Les écrans ne définissent pas directement couleur, taille, rayon ou espacement. Ils utilisent les tokens du `ui_kit`. Toute nouvelle valeur exige une justification et une mise à jour de ce document. Les couleurs de marque restent proposées tant que l'identité SAMTECH n'est pas officiellement approuvée.

