# Conventions fonctionnelles transversales

| Élément | Valeur |
|---|---|
| Statut | Version de référence initiale |
| Version | 1.0 |
| Date | 14 juillet 2026 |

`BUSINESS_RULES.md` contient les règles métier identifiées. Le présent document fixe les conventions communes utilisées dans les spécifications et l'interface.

## 1. Langue et rédaction

- Le français est la langue initiale.
- Les textes utilisateur emploient des phrases courtes et évitent le jargon technique.
- Les actions utilisent des verbes explicites : « Enregistrer le paiement », « Reporter la relance », « Ouvrir dans WhatsApp ».
- Une confirmation destructive précise l'objet et la conséquence.
- Aucun message ne prétend qu'un WhatsApp a été envoyé ou lu sans preuve disponible.

## 2. Champs et validation

- Les champs obligatoires sont identifiés avant la soumission.
- La validation se produit au plus près du champ et lors de la soumission.
- Une erreur conserve les données déjà saisies.
- Les espaces en début et fin sont supprimés ; le texte interne n'est pas réécrit arbitrairement.
- Les listes de référence proposent la création contrôlée d'une nouvelle valeur lorsque cela est autorisé.

## 3. Téléphone

- L'indicatif pays est demandé ou déduit du pays configuré, tout en restant modifiable.
- Le format affiché reste lisible pour l'utilisateur.
- Le format normalisé sert aux comparaisons et aux liens WhatsApp.
- Un numéro invalide empêche l'ouverture WhatsApp, mais peut être corrigé sans recréer la fiche.

## 4. Dates et heures

- Les dates sont affichées selon la langue et le pays configurés.
- Le fuseau horaire actif est visible dans les paramètres.
- Une date seule n'est pas transformée en date-heure UTC sans règle explicite.
- Les échéances passées sont visuellement distinguées, sans dépendre uniquement de la couleur.

## 5. Montants et calculs

- Tous les montants affichent la devise ou utilisent un contexte qui la rend sans ambiguïté.
- Le séparateur décimal et le groupement suivent la locale.
- Les calculs financiers n'utilisent pas de nombres flottants binaires.
- Le détail du calcul d'une facture reste consultable avant émission.

## 6. Numérotation

- Les numéros de facture sont séquentiels dans un périmètre défini par l'entreprise.
- Un préfixe et l'année peuvent être configurables.
- Un numéro attribué n'est ni modifié ni réutilisé.
- Les collisions lors d'un import ou d'une restauration bloquent l'opération avant modification de la base.

## 7. États et transitions

- Chaque changement d'état respecte une transition documentée.
- Une action indisponible est masquée ou désactivée avec une explication utile.
- Les états calculés, comme « facture payée », ne peuvent pas être forcés manuellement.
- Une annulation n'est pas une suppression et reste traçable.

## 8. Suppression et archivage

- L'archivage est privilégié pour toute donnée référencée par l'historique.
- La suppression définitive requiert une confirmation renforcée.
- Une restauration après suppression n'est proposée que si elle est techniquement et juridiquement sûre.
- Les obligations de confidentialité peuvent imposer anonymisation ou suppression ; la politique sera documentée avant commercialisation.

## 9. Recherche, tri et filtres

- La recherche ignore la casse et les espaces superflus.
- Le tri actif et les filtres sont visibles.
- Une action permet de réinitialiser tous les filtres.
- Les listes volumineuses ne chargent pas tous les éléments en mémoire.
- Les résultats vides distinguent « aucune donnée » de « aucun résultat pour ces filtres ».

## 10. Consentement marketing

- La fiche contact contient un état d'éligibilité marketing : non renseigné, autorisé ou refusé.
- Un refus exclut automatiquement le contact de toute nouvelle campagne.
- La date et la source d'un changement de consentement sont conservées.
- Le produit n'affirme pas garantir la conformité juridique ; les règles locales doivent être validées avant lancement dans chaque pays.

## 11. Notifications

- Une notification n'affiche pas de donnée sensible inutile sur l'écran verrouillé.
- Le refus de permission ne bloque aucune donnée ni navigation.
- La modification ou l'annulation d'une relance met à jour la notification associée.
- Au redémarrage ou après une mise à jour, les rappels futurs sont réconciliés avec la base.

## 12. Erreurs et fonctionnement offline

- Une erreur réseau ne doit pas empêcher l'accès aux données locales.
- Les erreurs proposent une action de reprise lorsqu'elle est pertinente.
- Les opérations non terminées ne laissent pas un état métier incohérent.
- Les fonctions nécessitant Internet affichent cette dépendance avant l'action.
- Les détails techniques sont réservés au diagnostic et ne contiennent pas de données personnelles.

## 13. Accessibilité

- Les contrôles tactiles respectent une taille minimale adaptée.
- L'information ne repose pas uniquement sur la couleur ou une icône.
- Les libellés sont disponibles pour les technologies d'assistance.
- L'interface supporte l'agrandissement du texte sans masquer les actions essentielles.
- Les animations respectent les préférences de réduction de mouvement.

## 14. Données de démonstration et tests

- Les environnements de développement utilisent uniquement des données fictives.
- Aucun numéro, facture ou sauvegarde réelle ne doit entrer dans le dépôt Git.
- Les scénarios de test précisent les dates et devises afin d'être reproductibles.
- Les tests de migration couvrent au moins une base vide, une base nominale et une base volumineuse.

## 15. Traçabilité documentaire

- Toute user story cite les règles métier pertinentes.
- Toute règle implémentée possède au moins un test ou un contrôle documenté.
- Toute décision modifiant le périmètre est ajoutée dans `DECISIONS.md`.
- Toute évolution notable est ajoutée dans `CHANGELOG.md`.

