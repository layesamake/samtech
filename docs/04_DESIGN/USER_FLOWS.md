# Parcours utilisateur critiques

| Élément | Valeur |
|---|---|
| Statut | Référence pour prototypage |
| Version | 1.0 |
| Date | 14 juillet 2026 |

## 1. Première utilisation

```text
Bienvenue
  → Activer la licence
  → Vérification réussie
  → Configurer l'entreprise et la devise
  → Créer le PIN
  → Proposer la biométrie
  → Demander les notifications au moment utile
  → Accueil vide guidé
```

Les permissions ne sont pas toutes demandées au premier lancement. Chaque permission est sollicitée lorsque sa valeur est compréhensible.

## 2. Prospect reçu sur WhatsApp

```text
Accueil ou Contacts
  → Nouveau prospect
  → Saisir le numéro
  → Vérifier les doublons
  → Ajouter nom, produit et localité
  → Enregistrer
  → Fiche contact
  → Planifier la prochaine relance
```

Objectif : fiche minimale enregistrée en moins d'une minute.

## 3. Relance individuelle

```text
Notification ou Relances
  → Ouvrir la relance
  → Choisir un modèle
  → Résoudre les variables
  → Prévisualiser et modifier
  → Ouvrir WhatsApp
  → Retour dans SAMTECH CRM
  → Terminer ou reporter
  → Chronologie mise à jour
```

Le retour de WhatsApp ne déclenche aucune conclusion automatique.

## 4. Campagne assistée

```text
Relances → Campagnes
  → Nouvelle campagne
  → Nom et objectif
  → Définir les filtres
  → Examiner inclusions et exclusions
  → Choisir le modèle
  → Prévisualiser des exemples
  → Figer les destinataires
  → Traiter un destinataire
  → Ouvrir WhatsApp
  → Enregistrer le résultat déclaré
  → Suivant / Suspendre
  → Résumé final
```

Un indicateur permanent rappelle que l'envoi est manuel et que les résultats sont déclaratifs.

## 5. Conversion et première facture

```text
Fiche prospect
  → Convertir en client
  → Confirmer l'identité
  → Client créé sur le même contact
  → Créer une facture
  → Ajouter les lignes
  → Vérifier le calcul
  → Émettre
  → Prévisualiser le PDF
  → Partager dans WhatsApp
```

La facture ne peut pas être émise si les informations indispensables ou le profil entreprise sont incomplets.

## 6. Paiement en plusieurs fois

```text
Détail facture impayée
  → Enregistrer un paiement
  → Montant, mode, date, référence
  → Confirmer
  → Facture partiellement payée
  → Plus tard : nouveau paiement
  → Solde zéro
  → Facture payée
```

Le solde est visible avant, pendant et après la saisie. Un montant supérieur au solde est bloqué avant confirmation.

## 7. Sauvegarde

```text
Plus → Sauvegarde
  → Voir la date de dernière sauvegarde
  → Créer une sauvegarde
  → Authentifier si nécessaire
  → Générer et chiffrer
  → Choisir la destination
  → Confirmation et rappel de conserver le fichier
```

## 8. Restauration

```text
Plus → Sauvegarde → Restaurer
  → Choisir le fichier
  → Vérifier intégrité et compatibilité
  → Afficher résumé et avertissement
  → Authentifier
  → Confirmer le remplacement
  → Restaurer atomiquement
  → Vérifier les totaux
  → Retour à l'accueil
```

En cas d'échec, la base active reste intacte et une action de reprise est proposée.

## 9. Licence en période de grâce

```text
Ouverture de l'application
  → Licence locale valide mais vérification distante échouée
  → Accès normal
  → Information discrète avec échéance
  → L'utilisateur retrouve Internet
  → Vérification réussie
  → Information supprimée
```

Une alerte renforcée n'apparaît qu'à proximité de la fin de grâce.

## 10. Scénarios de test UX

Chaque parcours est testé avec :

- un utilisateur novice ;
- une connexion coupée lorsque l'action le permet ;
- un téléphone Android de gamme modeste ;
- un iPhone supporté ;
- une taille de texte agrandie ;
- au moins un cas d'erreur et un abandon avec reprise.

