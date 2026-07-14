# User stories et critères d'acceptation — SAMTECH CRM Starter

| Élément | Valeur |
|---|---|
| Statut | Backlog fonctionnel initial |
| Version | 1.0 |
| Date | 14 juillet 2026 |
| Priorités | P0 indispensable, P1 importante, P2 amélioration |

## 1. Licence et accès

### US-LIC-001 — Activer l'application — P0

En tant que nouvel utilisateur, je veux activer SAMTECH CRM avec ma clé afin d'utiliser une licence officielle sur mon téléphone.

Critères d'acceptation :

- Étant donné une application non activée, lorsque je saisis une clé valide avec Internet disponible, alors l'activation est confirmée et la licence locale signée est enregistrée.
- Une clé invalide, révoquée ou déjà liée au maximum d'appareils affiche une raison compréhensible sans révéler de détail serveur sensible.
- Une interruption réseau ne crée pas d'activation partielle et permet de réessayer.
- La clé privée de signature n'est jamais présente dans l'application.

Règles : BR-LIC-001, BR-LIC-002, BR-LIC-003.

### US-LIC-002 — Continuer hors ligne — P0

En tant qu'utilisateur activé, je veux continuer à travailler temporairement sans Internet afin de ne pas interrompre mon activité.

Critères d'acceptation :

- Une licence valide précédemment vérifiée permet l'accès pendant la période de grâce.
- L'application affiche clairement le besoin d'une future vérification sans bloquer prématurément les données locales.
- Une horloge suspecte déclenche le comportement défini sans supprimer de donnée.

Règles : BR-LIC-004, BR-LIC-005, BR-LIC-006.

### US-SEC-001 — Protéger l'accès par PIN — P0

En tant qu'utilisateur, je veux définir un PIN afin de protéger mes données commerciales.

Critères d'acceptation :

- Le PIN doit être confirmé lors de sa création et n'est jamais stocké en clair.
- Après le délai configuré, l'application demande de nouveau le PIN.
- Les échecs répétés imposent un délai progressif sans effacer les données.
- Le changement de PIN exige le PIN actuel ou une procédure de récupération autorisée.

Règles : BR-LIC-007.

### US-SEC-002 — Utiliser la biométrie — P1

En tant qu'utilisateur d'un téléphone compatible, je veux déverrouiller l'application par biométrie afin d'accéder plus rapidement à mes données.

Critères d'acceptation :

- La biométrie est facultative et nécessite d'abord un PIN valide.
- Son indisponibilité ou son échec permet de revenir au PIN.
- Désactiver la biométrie ne modifie ni le PIN ni la licence.

Règles : BR-LIC-008.

## 2. Configuration initiale

### US-SET-001 — Configurer l'entreprise — P0

En tant qu'utilisateur, je veux enregistrer l'identité de mon entreprise afin de personnaliser mes factures et paramètres.

Critères d'acceptation :

- Le nom commercial et la devise principale sont obligatoires.
- Le logo, les coordonnées, les mentions et les informations fiscales restent facultatifs tant que le marché ne les impose pas.
- Une prévisualisation montre les informations destinées aux factures.
- Le changement de devise avertit qu'il ne modifie pas les factures existantes.

Règles : BR-SYS-001, BR-SYS-002, BR-SYS-006.

### US-SET-002 — Configurer langue, pays et fuseau — P0

En tant qu'utilisateur, je veux choisir mes paramètres régionaux afin d'obtenir des dates, numéros et montants adaptés.

Critères d'acceptation :

- Le pays propose un indicatif téléphonique et un fuseau modifiables.
- Les montants et dates suivent les paramètres retenus.
- Un changement de fuseau ne modifie pas silencieusement l'intention des relances existantes.

Règles : BR-FOL-007, BR-SYS-003.

## 3. Prospects et contacts

### US-CON-001 — Créer rapidement un prospect — P0

En tant que commercial, je veux enregistrer un prospect à partir de son numéro afin de ne pas perdre une demande WhatsApp.

Critères d'acceptation :

- Un numéro exploitable suffit pour enregistrer une fiche minimale.
- Le nom, la localité, la source, les produits, le statut, l'intérêt, les tags et les notes peuvent être ajoutés.
- La création enregistre la date du premier contact et un événement de chronologie.
- Les données saisies sont conservées si une validation échoue.

Règles : BR-CON-002, BR-CON-004, BR-TIM-001.

### US-CON-002 — Prévenir un doublon — P0

En tant qu'utilisateur, je veux être averti lorsqu'un numéro existe déjà afin de conserver une base propre.

Critères d'acceptation :

- La détection compare le numéro normalisé, indépendamment de son format d'affichage.
- L'avertissement présente la fiche existante et propose de l'ouvrir.
- Une création forcée exige une confirmation explicite.
- Aucun doublon n'est fusionné automatiquement.

Règles : BR-CON-001, BR-CON-003.

### US-CON-003 — Modifier et enrichir une fiche — P0

En tant qu'utilisateur, je veux compléter un prospect progressivement afin de refléter les nouvelles informations obtenues.

Critères d'acceptation :

- Les champs modifiables sont validés avant enregistrement.
- Les produits, tags et notes peuvent être ajoutés ou retirés sans supprimer l'historique de facture.
- Un changement important de statut produit un événement de chronologie.
- La date de modification est actualisée.

Règles : BR-CON-007, BR-CON-008, BR-TIM-001.

### US-CON-004 — Rechercher et filtrer — P0

En tant qu'utilisateur, je veux rechercher mes contacts et combiner des filtres afin de retrouver rapidement une cible.

Critères d'acceptation :

- La recherche porte au minimum sur nom et téléphone.
- Les filtres incluent localité, produit, statut, intérêt, tag, source et période.
- Les filtres actifs sont visibles et réinitialisables.
- L'état vide distingue l'absence de contacts de l'absence de résultats.

Règles : BR-REF-001, BR-REF-005.

### US-CON-005 — Archiver un contact — P1

En tant qu'utilisateur, je veux archiver un contact inactif afin d'alléger mes listes sans perdre son historique.

Critères d'acceptation :

- L'archivage demande confirmation et retire le contact des listes actives et campagnes.
- Les factures, paiements et événements restent consultables.
- Le contact peut être réactivé.
- Une suppression définitive non autorisée est remplacée par une explication et l'option d'archivage.

Règles : BR-CON-009, BR-CON-010.

### US-CON-006 — Consulter la chronologie — P0

En tant qu'utilisateur, je veux voir toute l'histoire commerciale d'un contact afin de préparer une relance ou une vente.

Critères d'acceptation :

- La chronologie présente les événements les plus récents en premier.
- Les créations, changements de statut, relances, campagnes, factures et paiements sont identifiables.
- Un événement système n'est pas modifiable comme une note.
- Une note indique sa dernière modification.

Règles : BR-TIM-001 à BR-TIM-004.

## 4. Référentiels et catalogue

### US-REF-001 — Gérer les localités et tags — P1

En tant qu'utilisateur, je veux réutiliser mes localités et tags afin de classer les contacts de manière cohérente.

Critères d'acceptation :

- Une valeur active identique ne peut pas être créée deux fois après normalisation.
- Une valeur peut être archivée si elle n'est plus utilisée pour de nouvelles fiches.
- L'archivage ne modifie pas les fiches et statistiques historiques.

Règles : BR-REF-001 à BR-REF-005.

### US-PRO-001 — Créer un produit ou service — P0

En tant qu'utilisateur, je veux gérer mon catalogue afin de suivre les demandes et de facturer rapidement.

Critères d'acceptation :

- Le nom et le type sont obligatoires.
- Le prix est stocké dans la devise configurée et peut être nul si le tarif est à définir.
- Un nom actif identique est refusé.
- Le produit peut être immédiatement associé à un prospect ou une facture.

Règles : BR-PRO-001 à BR-PRO-003.

### US-PRO-002 — Modifier ou archiver un produit — P0

En tant qu'utilisateur, je veux actualiser mon catalogue sans modifier mes ventes passées.

Critères d'acceptation :

- Modifier le prix n'altère aucune facture existante.
- Un produit archivé n'est plus proposé par défaut pour une nouvelle opération.
- Les anciennes demandes et lignes de facture conservent leur libellé et valeur historique.

Règles : BR-PRO-004, BR-PRO-006.

### US-PRO-003 — Associer plusieurs produits demandés — P0

En tant qu'utilisateur, je veux associer plusieurs produits à un prospect afin de comprendre ses besoins.

Critères d'acceptation :

- Un contact peut être associé à plusieurs produits actifs.
- La même association active ne peut pas être dupliquée.
- La date de création de l'intérêt est conservée.
- Les statistiques comptent une association unique par contact et produit.

Règles : BR-PRO-005, BR-STA-003.

## 5. Relances et messages

### US-FOL-001 — Planifier une relance — P0

En tant qu'utilisateur, je veux planifier une action avec une date et une priorité afin de ne pas oublier un prospect.

Critères d'acceptation :

- Une relance comporte un contact, une échéance, une priorité et une note facultative.
- Elle apparaît dans les listes du jour, futures ou en retard selon l'échéance.
- Une notification locale est programmée si l'autorisation existe.
- Le refus de notification n'empêche pas l'enregistrement.

Règles : BR-FOL-001 à BR-FOL-003, BR-FOL-006.

### US-FOL-002 — Reporter ou annuler une relance — P0

En tant qu'utilisateur, je veux reporter ou annuler une relance afin d'adapter mon suivi.

Critères d'acceptation :

- Reporter exige une nouvelle échéance et conserve l'ancienne dans la chronologie.
- Annuler demande confirmation et supprime la notification future correspondante.
- Une relance terminée ne peut pas être reportée sans créer une nouvelle relance.

Règles : BR-FOL-001, BR-FOL-004.

### US-FOL-003 — Effectuer une relance WhatsApp — P0

En tant qu'utilisateur, je veux préparer un message personnalisé et ouvrir WhatsApp afin de relancer le contact.

Critères d'acceptation :

- L'utilisateur peut sélectionner, prévisualiser et modifier un modèle résolu.
- Une variable manquante est signalée avant l'ouverture.
- L'application ouvre le bon numéro lorsque WhatsApp est disponible.
- L'utilisateur confirme séparément si la relance est terminée.
- Si WhatsApp est absent, le message peut être copié ou partagé autrement.

Règles : BR-FOL-005, BR-MSG-002 à BR-MSG-005.

### US-MSG-001 — Gérer les modèles — P1

En tant qu'utilisateur, je veux créer des modèles réutilisables afin de gagner du temps et garder un ton cohérent.

Critères d'acceptation :

- Le nom du modèle est obligatoire et unique parmi les modèles actifs.
- Les variables autorisées sont proposées dans l'éditeur.
- Le modèle peut être prévisualisé avec un contact choisi.
- Un modèle archivé reste associé aux historiques mais n'est plus proposé par défaut.

Règles : BR-MSG-001 à BR-MSG-003.

## 6. Campagnes assistées

### US-CAM-001 — Créer une campagne ciblée — P0

En tant qu'utilisateur, je veux sélectionner des contacts selon plusieurs critères afin d'envoyer une communication pertinente.

Critères d'acceptation :

- Les filtres couvrent localité, produit, statut, intérêt, tag, source et période.
- La prévisualisation affiche le nombre de destinataires uniques et les exclusions.
- Les contacts archivés, sans numéro exploitable ou opposés au marketing sont exclus.
- La campagne reste en brouillon jusqu'à confirmation de la sélection et du modèle.

Règles : BR-CAM-001, BR-CAM-003 à BR-CAM-005.

### US-CAM-002 — Exécuter une campagne assistée — P0

En tant qu'utilisateur, je veux ouvrir les messages un par un dans WhatsApp afin de garder le contrôle sur chaque envoi.

Critères d'acceptation :

- Le démarrage fige la sélection des destinataires.
- Chaque destinataire exige une action explicite avant l'ouverture de WhatsApp.
- Le retour dans l'application permet de marquer terminé, ignoré ou en erreur.
- Aucun message n'est envoyé en arrière-plan.
- La progression est conservée après fermeture de l'application.

Règles : BR-CAM-002, BR-CAM-006, BR-CAM-007.

### US-CAM-003 — Suspendre et reprendre — P0

En tant qu'utilisateur, je veux suspendre une campagne et la reprendre plus tard afin de traiter une longue liste sans doublon.

Critères d'acceptation :

- La suspension conserve la progression et les destinataires.
- La reprise commence sur un destinataire non traité.
- Les destinataires terminés ou ignorés ne sont pas reproposés automatiquement.
- Une campagne terminée ne peut pas être redémarrée ; elle peut être dupliquée en nouveau brouillon.

Règles : BR-CAM-008, BR-CAM-009.

## 7. Clients et conversion

### US-CLI-001 — Convertir un prospect — P0

En tant qu'utilisateur, je veux convertir un prospect en client afin de poursuivre le cycle de vente sans ressaisie.

Critères d'acceptation :

- La conversion utilise le contact existant et ne crée aucun doublon.
- La date de conversion et un événement de chronologie sont enregistrés.
- Les notes, produits demandés, relances et campagnes restent visibles.
- L'utilisateur peut créer immédiatement une facture.

Règles : BR-CON-001, BR-CON-005, BR-CON-006.

### US-CLI-002 — Consulter la fiche client à 360° — P0

En tant qu'utilisateur, je veux voir coordonnées, historique, factures, paiements et total dépensé afin de préparer une nouvelle action commerciale.

Critères d'acceptation :

- Les montants facturés, encaissés et dus sont distingués.
- Les factures sont accessibles par état et date.
- La chronologie inclut les événements du prospect antérieurs à la conversion.
- L'archivage du client ne supprime aucun document financier.

Règles : BR-CON-005, BR-CON-009, BR-STA-004.

## 8. Facturation

### US-INV-001 — Créer un brouillon — P0

En tant qu'utilisateur, je veux préparer une facture pour un client afin de vérifier les lignes avant émission.

Critères d'acceptation :

- Un client et au moins une ligne valide sont requis pour enregistrer un brouillon complet.
- Une ligne contient désignation, quantité positive et prix non négatif.
- Les calculs de sous-total, remise, taxe et total se mettent à jour de manière déterministe.
- Aucun numéro définitif n'est consommé au stade brouillon.

Règles : BR-INV-001, BR-INV-003, BR-INV-004, BR-INV-006, BR-INV-007.

### US-INV-002 — Émettre une facture — P0

En tant qu'utilisateur, je veux émettre une facture numérotée afin de figer le document commercial.

Critères d'acceptation :

- L'émission vérifie les champs obligatoires et l'échéance.
- Un numéro unique non réutilisable est attribué.
- Les informations de l'entreprise, du client et des lignes sont figées.
- L'événement d'émission apparaît dans la chronologie du client.
- Les données financières ne sont plus modifiables directement.

Règles : BR-INV-003, BR-INV-005, BR-INV-008, BR-INV-009.

### US-INV-003 — Générer et partager le PDF — P0

En tant qu'utilisateur, je veux générer un PDF fidèle et le partager par WhatsApp afin de transmettre la facture au client.

Critères d'acceptation :

- Le PDF correspond à la version enregistrée et comporte numéro, identité, lignes, totaux, devise et état.
- La pagination ne coupe pas une ligne de manière illisible.
- Le partage natif propose WhatsApp s'il est installé.
- Un échec de génération n'altère pas la facture.

Règles : BR-INV-005, BR-INV-011.

### US-INV-004 — Annuler une facture — P1

En tant qu'utilisateur, je veux annuler une facture erronée afin de conserver une trace correcte sans la supprimer.

Critères d'acceptation :

- Une confirmation indique que le numéro restera utilisé.
- Une facture avec paiement valide ne peut être annulée avant traitement de ce paiement.
- Le motif et la date d'annulation sont conservés.
- Une facture annulée est exclue du montant facturé actif mais reste consultable.

Règles : BR-INV-009, BR-INV-010, BR-INV-012.

## 9. Paiements

### US-PAY-001 — Enregistrer un paiement — P0

En tant qu'utilisateur, je veux enregistrer un paiement complet ou partiel afin de connaître le solde réel d'une facture.

Critères d'acceptation :

- Le montant est positif et ne dépasse pas le solde restant.
- La date, le mode et une référence facultative sont enregistrés.
- Le solde et l'état de la facture sont recalculés automatiquement.
- Un événement de paiement apparaît dans la chronologie.

Règles : BR-PAY-001 à BR-PAY-004, BR-PAY-006.

### US-PAY-002 — Enregistrer plusieurs paiements — P0

En tant qu'utilisateur, je veux fractionner le règlement d'une facture afin de suivre les acomptes successifs.

Critères d'acceptation :

- Chaque paiement conserve sa date, son mode et sa référence.
- La facture reste partiellement payée tant que le total valide est inférieur au net à payer.
- Elle devient payée lorsque le solde atteint exactement zéro.
- Un nouveau paiement supérieur au solde est refusé.

Règles : BR-INV-002, BR-PAY-002, BR-PAY-006.

### US-PAY-003 — Annuler un paiement erroné — P1

En tant qu'utilisateur, je veux annuler un paiement mal saisi afin de corriger le solde tout en conservant une trace.

Critères d'acceptation :

- L'annulation exige un motif et une confirmation.
- Le paiement reste visible avec son état annulé.
- Le solde et l'état de la facture sont recalculés.
- L'opération apparaît dans la chronologie.

Règles : BR-PAY-005, BR-PAY-006.

## 10. Tableau de bord et statistiques

### US-DAS-001 — Voir les priorités du jour — P0

En tant qu'utilisateur, je veux voir les relances dues et les factures impayées afin de prioriser ma journée.

Critères d'acceptation :

- Les relances du jour et en retard sont distinguées.
- Les montants dus excluent les factures annulées.
- Chaque indicateur ouvre la liste filtrée correspondante.
- La date ou période de référence est visible.

Règles : BR-FOL-001, BR-STA-001, BR-STA-004.

### US-STA-001 — Analyser prospects et conversions — P0

En tant que dirigeant, je veux analyser les prospects par localité, source, statut et période afin de comprendre mon acquisition.

Critères d'acceptation :

- Les filtres et la période sont visibles.
- Le taux de conversion suit une méthode de cohorte unique et documentée.
- Les totaux d'un graphique correspondent à la liste détaillée associée.
- Les contacts archivés restent dans l'historique de leur période.

Règles : BR-STA-001, BR-STA-002, BR-STA-005.

### US-STA-002 — Identifier les produits demandés et vendus — P0

En tant que dirigeant, je veux comparer demandes et ventes par produit afin d'adapter mon offre.

Critères d'acceptation :

- Une demande unique correspond à une association contact-produit.
- Les ventes proviennent des lignes de factures émises non annulées.
- Les produits archivés restent visibles dans les périodes historiques.
- La période analysée est affichée.

Règles : BR-STA-001, BR-STA-003 à BR-STA-005.

### US-STA-003 — Suivre facturation et encaissements — P0

En tant que dirigeant, je veux distinguer facturé, encaissé et restant dû afin de suivre ma trésorerie commerciale.

Critères d'acceptation :

- Le montant facturé exclut les factures annulées.
- L'encaissé utilise la date effective des paiements valides.
- Le restant dû correspond aux factures émises non annulées.
- Les valeurs peuvent être rapprochées d'une liste détaillée.

Règles : BR-STA-004, BR-PAY-007.

## 11. Sauvegarde et restauration

### US-BCK-001 — Créer une sauvegarde chiffrée — P0

En tant qu'utilisateur, je veux exporter mes données dans un fichier protégé afin de pouvoir les récupérer en cas de problème.

Critères d'acceptation :

- La sauvegarde contient les données métier et métadonnées de version nécessaires.
- Le fichier est chiffré et protégé contre une modification non détectée.
- L'utilisateur choisit la destination via le système natif.
- Aucun secret serveur ou clé privée n'est exporté.

Règles : BR-BCK-001 à BR-BCK-003.

### US-BCK-002 — Restaurer une sauvegarde — P0

En tant qu'utilisateur, je veux restaurer un fichier valide afin de récupérer une base cohérente.

Critères d'acceptation :

- L'intégrité et la compatibilité sont vérifiées avant toute modification.
- L'utilisateur s'authentifie et confirme le remplacement des données.
- Une restauration réussie restitue les totaux attendus sans doublon.
- Un échec laisse la base précédente intacte.
- La licence n'est pas transférée automatiquement.

Règles : BR-BCK-003 à BR-BCK-006.

## 12. Exigences transversales d'acceptation

Toutes les stories P0 doivent également respecter les critères suivants :

- le parcours essentiel fonctionne sans Internet sauf dépendance explicitement documentée ;
- les erreurs ne suppriment pas les données déjà saisies ;
- les états vide, chargement, succès et erreur sont prévus ;
- les contrôles essentiels sont utilisables avec l'agrandissement du texte ;
- aucune donnée personnelle ou clé sensible n'apparaît dans les journaux ;
- le comportement est couvert par des tests au niveau approprié ;
- Android et iOS sont validés pour toute fonction utilisant un service natif.

## 13. Définition du MVP fonctionnel

Le MVP Starter exige toutes les stories P0. Les stories P1 peuvent intégrer la V1 si leur coût ne met pas en risque la stabilité, la sécurité ou la date du pilote. Les stories P2 seront ajoutées après retour terrain ; aucune story P2 n'est encore indispensable au premier pilote.

