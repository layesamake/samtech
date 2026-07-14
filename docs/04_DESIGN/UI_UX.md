# UX mobile — SAMTECH CRM Starter

| Élément | Valeur |
|---|---|
| Statut | Architecture UX de référence |
| Version | 1.0 |
| Date | 14 juillet 2026 |
| Plateformes | Android et iPhone |

## 1. Objectif UX

SAMTECH CRM doit permettre à un utilisateur non technique de comprendre sa situation commerciale et d'accomplir les actions fréquentes sans formation : enregistrer un prospect, préparer une relance, convertir un client, facturer et enregistrer un paiement.

Le produit doit donner une impression de clarté, de fiabilité et de maîtrise. WhatsApp reste le lieu de conversation ; SAMTECH CRM est le lieu d'organisation et de suivi.

## 2. Principes d'expérience

### 2.1 Une action principale par écran

Chaque écran possède un objectif dominant. Les actions secondaires sont regroupées dans un menu ou une zone distincte afin de limiter les erreurs.

### 2.2 Montrer la prochaine action

La fiche contact met en évidence la prochaine relance ou, à défaut, propose d'en planifier une. Une facture met en évidence le solde et l'action de paiement.

### 2.3 Révélation progressive

La création rapide ne demande que le minimum. Les informations détaillées restent accessibles ensuite. Les paramètres avancés ne ralentissent pas le premier usage.

### 2.4 Confiance avant vitesse

Les montants, destinataires de campagne, remplacements de sauvegarde et états de licence sont confirmés clairement. Une action sensible ne dépend jamais d'une icône ambiguë.

### 2.5 Offline par défaut

Le fonctionnement hors ligne est normal. L'application ne montre une alerte réseau que lorsqu'une action précise exige Internet, par exemple l'activation de licence.

### 2.6 Continuité avec WhatsApp

Avant d'ouvrir WhatsApp, l'utilisateur voit le numéro, le destinataire et le message final. Au retour, SAMTECH CRM lui demande le résultat sans affirmer que WhatsApp a envoyé ou livré le message.

### 2.7 Accessibilité intégrée

Les tailles tactiles, contrastes, libellés et états ne sont pas ajoutés en fin de projet. Ils font partie de chaque composant et parcours.

## 3. Architecture de navigation

La navigation principale comporte cinq destinations persistantes :

1. **Accueil** — priorités, indicateurs et raccourcis ;
2. **Contacts** — prospects et clients dans une base unifiée ;
3. **Relances** — agenda, retards et campagnes ;
4. **Ventes** — produits, factures et paiements ;
5. **Plus** — statistiques, modèles, sauvegarde, licence et paramètres.

Sur téléphone, les destinations utilisent une barre inférieure avec icône et libellé. Sur largeur supérieure, la même architecture peut utiliser un rail latéral sans modifier les concepts.

Le détail des routes et règles de retour se trouve dans `NAVIGATION.md`.

## 4. Actions globales

Un bouton d'action rapide accessible depuis les destinations principales propose :

- Nouveau prospect ;
- Nouvelle relance ;
- Nouvelle facture ;
- Enregistrer un paiement.

Le menu adapte les actions au contexte. Depuis un contact, « Nouvelle relance » et « Ouvrir WhatsApp » sont prioritaires. Depuis une facture, « Enregistrer un paiement » est prioritaire si un solde existe.

## 5. Inventaire des écrans

### 5.1 Démarrage et sécurité

| ID | Écran | Objectif |
|---|---|---|
| ONB-01 | Bienvenue | Expliquer brièvement la valeur et démarrer |
| LIC-01 | Activation | Saisir et vérifier la clé de licence |
| LIC-02 | État de licence | Comprendre validité, grâce ou action requise |
| SET-01 | Configuration entreprise | Définir identité, devise et pays |
| SEC-01 | Création du PIN | Protéger l'accès |
| SEC-02 | Déverrouillage | Accéder par PIN ou biométrie |
| SEC-03 | Changement du PIN | Modifier la protection après vérification |

### 5.2 Accueil

| ID | Écran | Objectif |
|---|---|---|
| HOM-01 | Tableau de bord | Voir priorités et chiffres essentiels |
| HOM-02 | Centre d'actions | Afficher relances et factures nécessitant une action |
| HOM-03 | Recherche globale | Retrouver rapidement contact, facture ou produit |

### 5.3 Contacts

| ID | Écran | Objectif |
|---|---|---|
| CON-01 | Liste des contacts | Rechercher, filtrer et ouvrir une fiche |
| CON-02 | Création rapide | Enregistrer téléphone et identité minimale |
| CON-03 | Formulaire complet | Qualifier prospect et intérêts |
| CON-04 | Doublon probable | Choisir la fiche existante ou confirmer |
| CON-05 | Fiche contact | Comprendre identité, statut et prochaine action |
| CON-06 | Chronologie | Parcourir l'histoire commerciale |
| CON-07 | Édition | Modifier les informations autorisées |
| CON-08 | Conversion client | Confirmer et poursuivre vers la vente |
| CON-09 | Archive | Consulter et réactiver les contacts archivés |

### 5.4 Relances, messages et campagnes

| ID | Écran | Objectif |
|---|---|---|
| FOL-01 | Agenda des relances | Voir aujourd'hui, retards et à venir |
| FOL-02 | Planifier une relance | Définir échéance, priorité et note |
| FOL-03 | Préparer le message | Choisir, résoudre et modifier un modèle |
| FOL-04 | Résultat de la relance | Terminer, reporter ou laisser en attente |
| MSG-01 | Liste des modèles | Gérer la bibliothèque |
| MSG-02 | Éditeur de modèle | Créer contenu et variables |
| CAM-01 | Liste des campagnes | Suivre brouillons, en cours et terminées |
| CAM-02 | Informations campagne | Définir nom et objectif |
| CAM-03 | Ciblage | Construire les filtres et exclusions |
| CAM-04 | Prévisualisation | Vérifier destinataires et message |
| CAM-05 | Exécution | Traiter les destinataires un à un |
| CAM-06 | Résumé | Consulter la progression et les résultats déclarés |

### 5.5 Ventes

| ID | Écran | Objectif |
|---|---|---|
| SAL-01 | Vue Ventes | Résumer factures et encaissements |
| PRO-01 | Catalogue | Rechercher et gérer les produits |
| PRO-02 | Produit | Créer ou modifier un produit/service |
| INV-01 | Liste des factures | Filtrer par état, client et période |
| INV-02 | Éditeur de facture | Construire et vérifier un brouillon |
| INV-03 | Sélecteur de ligne | Ajouter catalogue ou ligne libre |
| INV-04 | Détail de facture | Voir document, paiements et actions |
| INV-05 | Prévisualisation PDF | Contrôler avant partage |
| INV-06 | Annulation | Expliquer impacts et saisir le motif |
| PAY-01 | Saisie du paiement | Enregistrer montant, date et mode |
| PAY-02 | Détail du paiement | Consulter ou annuler de façon contrôlée |

### 5.6 Analyse et administration locale

| ID | Écran | Objectif |
|---|---|---|
| STA-01 | Statistiques | Choisir domaine et période |
| STA-02 | Prospection | Analyser acquisition et conversion |
| STA-03 | Produits | Comparer demandes et ventes |
| STA-04 | Finances | Comparer facturé, encaissé et dû |
| BCK-01 | Sauvegarde | Exporter et voir la dernière sauvegarde |
| BCK-02 | Restauration | Vérifier et confirmer un fichier |
| SET-02 | Paramètres | Accéder aux sections de configuration |
| SET-03 | Référentiels | Gérer localités, sources, tags et catégories |
| SET-04 | Facturation | Configurer numérotation, taxes et PDF |
| SET-05 | Notifications | Configurer rappels et permissions |
| ABO-01 | À propos et assistance | Version, aide, confidentialité et support |

## 6. Structure des écrans principaux

### 6.1 Tableau de bord

Ordre recommandé :

1. en-tête avec date, salutation courte et accès recherche ;
2. carte « À faire aujourd'hui » avec relances dues et en retard ;
3. actions rapides ;
4. trois indicateurs : prospects, clients, conversion ;
5. résumé financier : facturé, encaissé, restant ;
6. produit le plus demandé ;
7. état discret de sauvegarde ou licence uniquement si une action est nécessaire.

Le tableau de bord ne doit pas devenir un mur de graphiques. Chaque carte ouvre un détail utile.

### 6.2 Liste des contacts

Chaque ligne affiche : nom ou libellé de secours, téléphone, localité, statut, intérêt et prochaine relance si elle existe. Les actions WhatsApp et appel ne sont pas toutes exposées simultanément dans la ligne afin d'éviter les erreurs ; elles sont accessibles depuis la fiche ou un geste documenté.

### 6.3 Fiche contact

Ordre recommandé :

1. identité, téléphone et statuts ;
2. action principale « Ouvrir WhatsApp » ;
3. prochaine relance ou invitation à en créer une ;
4. produits demandés et informations de qualification ;
5. résumé client si converti ;
6. chronologie ;
7. actions secondaires : modifier, convertir, archiver.

### 6.4 Éditeur de facture

L'écran utilise des sections : client, lignes, remise/taxe, dates, notes, résumé. Le total reste visible près de l'action « Émettre ». Le brouillon est sauvegardé explicitement ; aucune émission ne résulte d'un simple retour écran.

### 6.5 Exécution de campagne

L'écran montre une seule personne à la fois : position dans la campagne, identité, numéro, message final et actions « Ouvrir WhatsApp », « Ignorer » et « Suspendre ». Au retour de WhatsApp, une feuille demande « Que souhaitez-vous enregistrer ? » avec les choix terminé, reporter la décision ou erreur.

## 7. Formulaires

- Les formulaires longs sont divisés en sections, pas en multiples étapes arbitraires.
- La création rapide d'un prospect demande téléphone, nom facultatif et produit facultatif.
- Les sélecteurs de référentiels permettent la recherche et, si autorisé, la création contrôlée.
- Le bouton principal reste visible lorsque le clavier est ouvert.
- Une sortie avec modifications non enregistrées affiche une confirmation.
- Les erreurs sont annoncées à proximité du champ et résumées si plusieurs sections sont concernées.

## 8. Recherche et filtres

La recherche globale et les recherches de module sont distinctes :

- recherche globale pour retrouver un objet précis ;
- recherche locale pour filtrer la liste courante ;
- filtres avancés dans une feuille inférieure avec nombre de résultats ;
- puces visibles pour les filtres actifs ;
- action unique « Tout effacer ».

Les filtres temporaires sont conservés pendant la navigation vers un détail puis le retour, mais réinitialisés après une longue interruption ou action explicite.

## 9. États système

### 9.1 Hors ligne

Aucune bannière permanente si tout fonctionne localement. Une bannière compacte apparaît uniquement pour une opération en attente de réseau, avec action « Réessayer ».

### 9.2 Licence

- valide : aucun message constant ;
- grâce : information progressive avec date limite ;
- action urgente : bannière non bloquante puis écran dédié ;
- invalide ou révoquée : écran explicatif, accès au support et option d'export selon la politique.

### 9.3 Sauvegarde

Une alerte douce est affichée lorsque la dernière sauvegarde dépasse un délai recommandé. L'application ne prétend jamais qu'une sauvegarde locale a été copiée ailleurs sans confirmation du système.

### 9.4 Erreurs

Le message répond à trois questions : que s'est-il passé, quelles données ont été conservées et que peut faire l'utilisateur maintenant ?

## 10. Confirmations sensibles

Une confirmation renforcée est requise pour :

- restaurer une sauvegarde ;
- annuler une facture ou un paiement ;
- archiver un contact avec actions en cours ;
- changer la devise principale ;
- transférer une licence ;
- supprimer définitivement une donnée.

Les confirmations ordinaires ne doivent pas être surutilisées pour les actions facilement réversibles.

## 11. Comportement Android et iOS

Les concepts, contenus et priorités restent identiques. Les contrôles natifs, retour système, partage, sélection de fichiers, permissions et biométrie suivent les conventions de chaque plateforme. Les adaptations ne doivent pas créer deux produits fonctionnellement différents.

## 12. Validation UX avant développement

Les parcours suivants doivent être testés sur prototype avec au moins cinq utilisateurs représentatifs :

1. activation et configuration initiale ;
2. création d'un prospect en moins d'une minute ;
3. planification et exécution d'une relance ;
4. création d'une campagne de dix destinataires ;
5. conversion et émission d'une facture ;
6. enregistrement de deux paiements partiels ;
7. sauvegarde et compréhension du risque de restauration.

Les observations doivent mesurer réussite sans aide, temps, erreurs, hésitations et compréhension des états WhatsApp, facture et licence.

