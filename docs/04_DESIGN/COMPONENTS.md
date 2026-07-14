# Catalogue de composants

| Élément | Valeur |
|---|---|
| Statut | Inventaire fonctionnel initial |
| Version | 1.0 |
| Date | 14 juillet 2026 |

Chaque composant doit définir apparence, contenu, variantes, états, sémantique d'accessibilité et comportement Android/iOS. Les composants n'embarquent pas de règle métier qui appartient au domaine.

## 1. Navigation

### `SamtechAppBar`

- titre, retour, action principale et menu facultatifs ;
- variantes standard, grande et transparente si justifiée ;
- le titre accepte deux lignes avec texte agrandi ;
- aucune donnée sensible dans une capture système si l'écran le requiert.

### `SamtechBottomNavigation`

- cinq destinations avec icône et libellé ;
- état actif non dépendant uniquement de la couleur ;
- badges limités aux informations nécessitant une action ;
- compatible avec zones sûres Android/iOS.

### `SamtechNavigationRail`

- adaptation large écran des mêmes destinations ;
- ne crée pas de hiérarchie différente.

### `ContextActionMenu`

- actions secondaires contextuelles ;
- sépare clairement les actions destructives ;
- chaque entrée comporte un libellé.

## 2. Actions

### `PrimaryButton`

États : normal, pressé, focus, désactivé et en cours. Une progression conserve la largeur et bloque le double déclenchement.

### `SecondaryButton`

Alternative visible à une action principale. Ne doit pas être utilisé pour une action dangereuse.

### `TextAction`

Action de faible emphase avec cible tactile complète.

### `DestructiveButton`

Action explicite telle que « Annuler la facture ». Requiert la confirmation définie par le parcours.

### `QuickActionButton`

Icône, libellé et raccourci vers prospect, relance, facture ou paiement. Les actions indisponibles expliquent la condition manquante.

### `FloatingCreateButton`

Action de création dans une liste. Ne masque ni le dernier élément ni un bouton principal.

## 3. Champs et sélecteurs

### `SamtechTextField`

Libellé persistant, aide, compteur facultatif, erreur et action d'effacement. Gère lecture seule et désactivé comme deux états différents.

### `PhoneField`

Indicatif pays, numéro affiché et validation. Expose le format normalisé au domaine sans le montrer comme valeur principale.

### `MoneyField`

Devise visible, séparateur local, saisie entière/décimale contrôlée et conversion sûre en unité mineure.

### `DateField` et `DateTimeField`

Saisie accessible, sélecteur natif ou adapté, fuseau explicite pour une échéance.

### `SearchField`

Libellé, effacement, délai de saisie et état de progression local si nécessaire.

### `ReferencePicker`

Sélection recherchable pour localité, source ou catégorie ; création contrôlée si autorisée ; état archivé non sélectionnable.

### `MultiSelectPicker`

Sélection de produits ou tags, avec résumé lisible lorsque plusieurs valeurs sont choisies.

### `StatusPicker`

Affiche chaque statut avec libellé et éventuelle explication des conséquences.

## 4. Affichage de données

### `KpiCard`

Titre, valeur, période, tendance facultative et action vers le détail. La valeur ne dépend pas d'un graphique seul.

### `FinancialSummary`

Montants facturé, encaissé et restant, avec devise et période. L'ordre reste constant dans toute l'application.

### `ContactListItem`

Nom, téléphone, localité, statut, intérêt et prochaine action. Compatible nom long et contact sans nom.

### `InvoiceListItem`

Numéro, client, date, total, solde et statut. Une facture échue est signalée par texte en plus de la couleur.

### `FollowUpListItem`

Heure/date, contact, priorité et état. Une relance en retard annonce le retard aux technologies d'assistance.

### `ProductListItem`

Nom, type, prix et état. Les produits sans prix affichent « Prix à définir ».

### `TimelineItem`

Type, résumé, date métier et auteur/origine. Les événements système et notes ont une représentation distincte.

### `StatusChip`

Variantes contact, relance, campagne, facture, licence et intérêt. Le texte reste présent.

### `TagChip`

Tag simple, supprimable uniquement dans un contexte d'édition avec annonce accessible.

## 5. Contacts

### `ContactHeader`

Identité, téléphone, statuts, localité et actions principales. Le téléphone est copiable et l'action WhatsApp annonce la destination.

### `NextActionCard`

Affiche prochaine relance, retard ou invitation à planifier. N'invente jamais une recommandation sans règle explicite.

### `ProductInterestList`

Produits demandés, date et actions d'édition. L'archivage du produit n'efface pas l'intérêt historique.

### `DuplicateWarningCard`

Présente les correspondances probables et les choix ouvrir, compléter ou confirmer la création.

## 6. Relances et messages

### `FollowUpEditor`

Contact, date/heure, priorité et note. Avertit si l'échéance est passée.

### `MessageTemplatePicker`

Recherche, aperçu et indication des modèles archivés dans l'historique.

### `MessageComposer`

Message final modifiable, variables résolues, erreurs de variable et action « Ouvrir WhatsApp ».

### `WhatsAppHandoffNotice`

Texte invariant expliquant que l'envoi sera confirmé dans WhatsApp.

### `FollowUpResultSheet`

Au retour : terminé, reporter, erreur ou ne rien changer. Aucun choix n'est présélectionné.

## 7. Campagnes

### `AudienceFilterBuilder`

Filtres combinables, estimation du nombre, accès au détail et remise à zéro.

### `ExclusionSummary`

Nombre et raisons des exclusions : refus marketing, archive, téléphone invalide, doublon.

### `CampaignRecipientPreview`

Échantillon ou liste complète des contacts figés avant démarrage.

### `CampaignProgressHeader`

Position, total, progression et état. Les valeurs sont textuelles et graphiques.

### `CampaignRecipientCard`

Un destinataire, message final et actions contrôlées.

## 8. Facturation et paiements

### `InvoiceLineEditor`

Désignation, quantité, prix, remise facultative et suppression. Les erreurs sont liées à la ligne concernée.

### `InvoiceTotals`

Sous-total, remise, taxe et net à payer avec détail de calcul. Le total final est visuellement dominant.

### `InvoiceStatusHeader`

Numéro, statut, dates et client. Un brouillon affiche clairement l'absence de numéro définitif.

### `PaymentSummary`

Total, encaissé et restant. Les valeurs ne changent visuellement qu'après confirmation réussie.

### `PaymentEditor`

Solde avant, montant, mode, date, référence et solde après. Bloque le dépassement.

### `PdfPreviewActions`

Prévisualiser, partager et régénérer si nécessaire, sans modifier la facture émise.

## 9. États système

### `EmptyState`

Illustration facultative, titre, explication et action. Variantes aucune donnée et aucun résultat filtré.

### `ErrorState`

Résumé, effet sur les données et reprise. Le détail technique n'est pas affiché par défaut.

### `OfflineActionBanner`

Visible uniquement lorsque l'action en cours nécessite Internet.

### `LicenseBanner`

Variantes information, grâce, urgence et blocage. Le niveau d'emphase dépend du délai et de l'impact.

### `BackupStatusCard`

Date de dernière sauvegarde connue, état et action. Ne prétend pas qu'un fichier externe existe encore.

### `PermissionRationale`

Explique la valeur avant la demande native et offre une alternative si refusée.

## 10. Dialogues et feuilles

### `ConfirmationDialog`

Titre factuel, conséquence, action principale et annulation. Le bouton destructif est nommé précisément.

### `UnsavedChangesDialog`

Continuer l'édition, abandonner ou sauvegarder lorsque disponible.

### `FilterBottomSheet`

Filtres recherchables, nombre de résultats et actions appliquer/réinitialiser.

### `ActionResultSheet`

Utilisé après retour d'une application externe pour demander le résultat déclaré.

## 11. Critères de qualité d'un composant

Avant intégration, chaque composant doit disposer de :

- variantes et états documentés ;
- exemple clair et sombre si le thème sombre est livré ;
- comportement avec texte agrandi ;
- sémantique lecteur d'écran ;
- navigation clavier/focus lorsque pertinente ;
- tests widget des états critiques ;
- absence de logique métier cachée ;
- utilisation exclusive des tokens validés.

