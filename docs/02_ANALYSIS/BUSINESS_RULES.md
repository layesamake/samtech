# Règles métier — SAMTECH CRM Starter

| Élément | Valeur |
|---|---|
| Statut | Version de référence initiale |
| Version | 1.0 |
| Date | 14 juillet 2026 |
| Référence | `CAHIER_DES_CHARGES.md` |

## 1. Objet

Ce document définit les règles qui garantissent la cohérence fonctionnelle de SAMTECH CRM Starter. Chaque règle possède un identifiant stable utilisable dans les user stories, les tests et le modèle de données.

## 2. Contacts, prospects et clients

### BR-CON-001 — Contact unique

Une personne est représentée par un contact unique. Les rôles de prospect et de client sont des états ou profils commerciaux rattachés à ce contact, et non des copies indépendantes.

### BR-CON-002 — Téléphone principal

Un contact doit posséder au minimum un numéro de téléphone exploitable. Le numéro saisi est conservé pour l'affichage et une version normalisée est utilisée pour la recherche de doublons.

### BR-CON-003 — Doublon probable

Lorsqu'un numéro normalisé existe déjà, l'application avertit l'utilisateur et propose d'ouvrir ou de compléter la fiche existante. La création forcée d'un doublon exige une confirmation explicite et doit rester exceptionnelle.

### BR-CON-004 — Identité incomplète

Le nom peut être provisoirement inconnu si un numéro est disponible. L'interface utilise alors un libellé neutre tel que « Contact sans nom ».

### BR-CON-005 — Conversion

La conversion d'un prospect en client conserve le même identifiant de contact, toute sa chronologie, ses intérêts, relances, campagnes et notes.

### BR-CON-006 — Date de conversion

La première conversion en client enregistre une date immuable. Les éventuelles réactivations commerciales n'effacent pas cette date.

### BR-CON-007 — Statuts du prospect

Les statuts initiaux sont : nouveau, contacté, intéressé, à relancer, négociation, converti et perdu. Un statut converti implique l'existence du profil client.

### BR-CON-008 — Niveau d'intérêt

Le niveau d'intérêt est facultatif et prend l'une des valeurs : chaud, tiède ou froid. Il ne remplace pas le statut.

### BR-CON-009 — Archivage

Un contact archivé est absent des listes actives et des campagnes, mais reste visible dans les historiques, factures et statistiques passées.

### BR-CON-010 — Suppression définitive

La suppression définitive n'est possible que si aucune facture, aucun paiement et aucune obligation de conservation ne s'y oppose. Sinon, l'archivage est imposé.

## 3. Localités, sources et tags

### BR-REF-001 — Hiérarchie géographique

Une localité peut être décrite par pays, région, ville et quartier. Seule la ville est utilisée comme niveau de classement principal dans la Starter ; les autres niveaux restent facultatifs.

### BR-REF-002 — Valeurs réutilisables

Les localités, sources, catégories et tags sont réutilisables afin d'éviter les variantes typographiques dans les statistiques.

### BR-REF-003 — Unicité logique

Deux référentiels actifs de même type ne peuvent avoir le même nom après suppression des espaces superflus et comparaison insensible à la casse.

### BR-REF-004 — Archivage d'un référentiel

Une valeur archivée ne peut plus être choisie pour de nouvelles données, mais reste affichée sur les enregistrements historiques.

### BR-REF-005 — Tags

Un contact peut avoir plusieurs tags. Un tag ne modifie automatiquement ni le statut ni le niveau d'intérêt.

## 4. Produits, services et intérêts

### BR-PRO-001 — Types commercialisables

Un élément du catalogue est un produit, un service ou une formation.

### BR-PRO-002 — Nom obligatoire

Chaque élément possède un nom obligatoire et unique parmi les éléments actifs après normalisation typographique.

### BR-PRO-003 — Prix

Le prix par défaut est exprimé dans la devise de l'entreprise et stocké en unité monétaire mineure. Il peut être nul uniquement si le prix doit être déterminé lors de la vente.

### BR-PRO-004 — Prix historique

La modification du prix du catalogue n'affecte jamais les intérêts passés, lignes de facture émises ou statistiques historiques.

### BR-PRO-005 — Produits demandés

Un prospect peut être intéressé par plusieurs produits. Chaque intérêt peut comporter une date, une note et un niveau d'intérêt propre dans une évolution future ; la V1 conserve au minimum l'association et sa date de création.

### BR-PRO-006 — Archivage produit

Un produit archivé ne peut plus être ajouté par défaut à une nouvelle facture ou un nouvel intérêt, mais reste consultable dans l'historique.

## 5. Chronologie commerciale

### BR-TIM-001 — Événements obligatoires

La création du contact, le changement de statut important, la conversion, les relances terminées, la participation à une campagne, l'émission d'une facture et les paiements créent un événement de chronologie.

### BR-TIM-002 — Intégrité

Un événement système ne peut pas être modifié comme une note libre. Toute correction crée un nouvel événement d'annulation ou de rectification.

### BR-TIM-003 — Notes

Les notes utilisateur peuvent être modifiées ou archivées. La date de création et la dernière date de modification sont conservées.

### BR-TIM-004 — Ordre

La chronologie est affichée par date métier puis date de création, les événements les plus récents en premier par défaut.

## 6. Relances et notifications

### BR-FOL-001 — États

Une relance est en attente, terminée, reportée ou annulée. Une relance en attente dont la date est dépassée est également qualifiée « en retard » dans l'interface.

### BR-FOL-002 — Date future

Une nouvelle relance en attente doit être planifiée dans le futur. Une relance immédiate peut être créée avec l'heure courante et apparaît dans les actions du jour.

### BR-FOL-003 — Priorité

La priorité est faible, normale ou haute. La valeur par défaut est normale.

### BR-FOL-004 — Report

Reporter une relance conserve l'ancienne échéance dans la chronologie et définit une nouvelle échéance.

### BR-FOL-005 — Terminaison

Terminer une relance exige la confirmation de l'action réalisée. L'ouverture de WhatsApp seule ne prouve pas qu'un message a été envoyé.

### BR-FOL-006 — Notifications

Le refus de la permission de notification ne bloque pas les relances. L'application indique clairement que les rappels système sont désactivés.

### BR-FOL-007 — Fuseau horaire

Les échéances sont enregistrées de manière non ambiguë et présentées selon le fuseau de l'utilisateur. Un changement de fuseau ne doit pas transformer silencieusement l'heure métier choisie.

## 7. Modèles de messages et WhatsApp

### BR-MSG-001 — Modèle

Un modèle possède un nom unique, un contenu et un état actif ou archivé.

### BR-MSG-002 — Variables

Seules les variables documentées sont interprétées. Une variable inconnue ou sans valeur est signalée avant l'ouverture de WhatsApp.

### BR-MSG-003 — Prévisualisation

Le message final doit être prévisualisable et modifiable avant son transfert vers WhatsApp.

### BR-MSG-004 — Confirmation externe

SAMTECH CRM ne considère jamais l'ouverture de WhatsApp comme une preuve d'envoi ou de lecture. L'utilisateur confirme manuellement le résultat dans la V1.

### BR-MSG-005 — Application absente

Si WhatsApp n'est pas disponible, l'utilisateur peut copier le message ou utiliser le partage natif sans perte de son travail.

## 8. Campagnes assistées

### BR-CAM-001 — États

Une campagne est brouillon, prête, en cours, suspendue, terminée ou annulée.

### BR-CAM-002 — Sélection figée

Au démarrage d'une campagne, la liste des destinataires est figée pour garantir la traçabilité. Les changements ultérieurs de filtres ou de fiches ne modifient pas silencieusement cette liste.

### BR-CAM-003 — Consentement

Un contact marqué comme opposé aux communications marketing est automatiquement exclu. Cette exclusion ne peut pas être contournée depuis le flux normal de campagne.

### BR-CAM-004 — Numéro exploitable

Seuls les contacts actifs possédant un numéro exploitable sont éligibles.

### BR-CAM-005 — Doublons

Un même contact ne peut apparaître qu'une fois dans une campagne, même s'il correspond à plusieurs critères.

### BR-CAM-006 — Envoi assisté

Chaque message exige une action explicite de l'utilisateur dans SAMTECH CRM puis une validation dans WhatsApp. Aucun envoi automatique, arrière-plan ou contournement n'est autorisé.

### BR-CAM-007 — Progression

La progression conserve pour chaque destinataire : en attente, ouvert dans WhatsApp, terminé, ignoré ou en erreur. « Terminé » est une déclaration utilisateur et non un accusé WhatsApp.

### BR-CAM-008 — Reprise

Une campagne suspendue reprend au premier destinataire non traité sans dupliquer ceux marqués terminés ou ignorés.

### BR-CAM-009 — Modification

Après le démarrage, le nom et les notes internes peuvent être corrigés, mais le modèle source et la sélection figée restent traçables.

## 9. Factures

### BR-INV-001 — Client obligatoire

Une facture doit être rattachée à un client actif ou archivé identifiable.

### BR-INV-002 — États

Une facture est brouillon, émise, partiellement payée, payée ou annulée. Les états partiellement payée et payée découlent du total des paiements valides.

### BR-INV-003 — Numéro

Un numéro unique est attribué lors de l'émission, jamais à la simple création du brouillon. Un numéro attribué ne doit pas être réutilisé.

### BR-INV-004 — Lignes

Une facture comporte au moins une ligne avec désignation, quantité strictement positive et prix unitaire supérieur ou égal à zéro.

### BR-INV-005 — Instantané

Lors de l'émission, l'identité de l'entreprise, celle du client, la devise, les lignes, prix, remises, taxes et mentions légales sont figés dans la facture.

### BR-INV-006 — Calcul

Le sous-total est la somme des quantités multipliées par les prix unitaires. Les règles d'ordre entre remise et taxe doivent être configurées une fois et affichées sur le document.

### BR-INV-007 — Arrondi

Tous les calculs intermédiaires utilisent une précision déterministe. Le montant final est arrondi selon le nombre de décimales de la devise.

### BR-INV-008 — Échéance

La date d'échéance ne peut être antérieure à la date d'émission.

### BR-INV-009 — Modification après émission

Les données financières d'une facture émise sont immuables. Une correction exige l'annulation documentée puis la création d'une nouvelle facture tant que le mécanisme d'avoir n'existe pas.

### BR-INV-010 — Annulation

Une facture payée ou partiellement payée ne peut être annulée avant traitement ou annulation contrôlée de ses paiements.

### BR-INV-011 — PDF

Le PDF reflète exactement la version enregistrée de la facture et indique clairement son numéro, son état, sa devise et son solde lorsque pertinent.

### BR-INV-012 — Suppression

Un brouillon sans paiement peut être supprimé. Une facture émise est conservée et peut uniquement être annulée selon les règles applicables.

## 10. Paiements

### BR-PAY-001 — Montant

Un paiement possède un montant strictement positif dans la devise de la facture.

### BR-PAY-002 — Limite

Le total des paiements valides ne peut pas dépasser le net à payer. Les trop-perçus et avoirs sont hors périmètre de la Starter initiale.

### BR-PAY-003 — Modes

Les modes initiaux sont espèces, Wave, Orange Money, virement, carte et autre. Une référence est recommandée pour les paiements non espèces.

### BR-PAY-004 — Date

La date de paiement ne peut pas être future sans confirmation particulière. Elle peut être antérieure à la saisie si l'utilisateur enregistre un paiement déjà reçu.

### BR-PAY-005 — Annulation

Un paiement validé n'est pas supprimé silencieusement. Son annulation exige un motif et crée un événement de chronologie.

### BR-PAY-006 — État automatique

Après chaque création ou annulation de paiement, l'état et le solde de la facture sont recalculés automatiquement.

### BR-PAY-007 — Client

Le paiement contribue au total encaissé du client et aux statistiques selon sa date effective, pas selon sa date de saisie.

## 11. Statistiques

### BR-STA-001 — Période visible

Tout indicateur dépendant du temps affiche ou permet de connaître la période analysée.

### BR-STA-002 — Conversion

Le taux de conversion d'une période est le nombre de prospects de la cohorte choisie devenus clients, divisé par le nombre de prospects de cette cohorte. La méthode de cohorte doit être identique dans toute l'application.

### BR-STA-003 — Produits demandés

Le classement des produits demandés compte les associations d'intérêt uniques entre contacts et produits, et non le nombre de modifications de la fiche.

### BR-STA-004 — Chiffre d'affaires

Le montant facturé inclut les factures émises non annulées. Le montant encaissé correspond aux paiements valides. Le restant dû est calculé sur les factures émises non annulées.

### BR-STA-005 — Suppressions et archives

L'archivage d'un contact ou produit n'efface pas les statistiques historiques. Une donnée supprimée conformément à une obligation de confidentialité peut modifier les statistiques et doit être traitée de manière cohérente.

## 12. Sauvegarde et restauration

### BR-BCK-001 — Contenu

Une sauvegarde complète contient les données métier, paramètres et métadonnées nécessaires, mais jamais les clés privées SAMTECH ni un secret serveur.

### BR-BCK-002 — Chiffrement

Le fichier est chiffré et authentifié. Une altération doit être détectée avant toute écriture dans la base active.

### BR-BCK-003 — Version

Chaque sauvegarde indique une version de format, la version de l'application, la date et un identifiant non sensible.

### BR-BCK-004 — Restauration transactionnelle

La restauration valide d'abord l'intégrité et la compatibilité, puis remplace les données dans une transaction ou via une stratégie atomique. Un échec laisse les données existantes intactes.

### BR-BCK-005 — Confirmation

L'utilisateur est averti qu'une restauration peut remplacer les données actuelles et doit confirmer son intention après authentification.

### BR-BCK-006 — Licence exclue

La restauration commerciale ne transfère pas automatiquement la licence vers un autre appareil.

## 13. Licence et sécurité d'accès

### BR-LIC-001 — Activation

La première activation nécessite une clé valide, une connexion au service SAMTECH et la liaison autorisée à l'appareil.

### BR-LIC-002 — Signature

La licence locale est signée par le serveur. L'application embarque uniquement la clé publique nécessaire à sa vérification.

### BR-LIC-003 — États

Les états métier sont : non activée, valide, période de grâce, expirée, révoquée, transférable ou invalide.

### BR-LIC-004 — Grâce offline

Une licence précédemment validée peut continuer pendant une période de grâce documentée lorsque le serveur est inaccessible. La durée exacte reste une décision ouverte.

### BR-LIC-005 — Horloge

Une modification suspecte de l'horloge déclenche une vérification renforcée ou limite la grâce, mais ne doit pas provoquer une perte de données.

### BR-LIC-006 — Blocage

Une licence invalide peut empêcher l'usage normal, mais l'utilisateur doit conserver un moyen sûr d'exporter ses données selon la politique commerciale et juridique définie.

### BR-LIC-007 — PIN

Le PIN n'est jamais stocké en clair. Les tentatives répétées entraînent un délai progressif, sans mécanisme destructeur automatique.

### BR-LIC-008 — Biométrie

La biométrie est une facilité locale et ne remplace pas la procédure de récupération ou le PIN principal.

### BR-LIC-009 — Transfert

Le transfert de licence désactive ou libère l'ancienne liaison selon une procédure administrée. Restaurer une sauvegarde ne constitue pas un transfert.

## 14. Paramètres, dates et audit

### BR-SYS-001 — Devise

La devise principale est définie lors de la configuration. Le changement ultérieur n'altère pas les factures existantes et exige un avertissement.

### BR-SYS-002 — Unités monétaires

Les montants sont stockés sous forme entière dans la plus petite unité de la devise, avec le code ISO lorsque applicable.

### BR-SYS-003 — Dates techniques

Les horodatages techniques sont stockés en UTC. Les dates métier conservent l'intention locale nécessaire, notamment pour relances et factures.

### BR-SYS-004 — Audit minimal

Les entités sensibles conservent date de création, date de modification et origine de l'action. Le journal ne contient pas le texte des messages ni de secret inutile.

### BR-SYS-005 — Identifiants

Les entités utilisent des identifiants UUID afin de préparer les imports et la synchronisation future.

### BR-SYS-006 — Entreprise unique

La Starter gère un seul profil d'entreprise actif par installation.

## 15. Points nécessitant une décision ultérieure

- durée exacte de la période de grâce offline ;
- politique d'essai, renouvellement et transfert ;
- formule de taxe et ordre remise/taxe selon le marché ;
- règles légales de numérotation et d'annulation des factures par pays ;
- conservation et suppression des données personnelles ;
- versions minimales Android et iOS ;
- limites de volume garanties pour la Starter.

