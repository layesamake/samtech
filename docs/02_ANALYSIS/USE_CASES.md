# Cas d'utilisation — SAMTECH CRM Starter

| Élément | Valeur |
|---|---|
| Statut | Référence initiale |
| Version | 1.0 |
| Date | 14 juillet 2026 |

## UC-01 — Activer et sécuriser l'application

- Acteur principal : utilisateur Starter.
- Préconditions : application installée, clé de licence disponible, Internet disponible.
- Déclencheur : premier lancement.
- Flux nominal : saisir la clé, vérifier le serveur, enregistrer la licence signée, configurer l'entreprise, créer le PIN, accéder au tableau de bord.
- Alternatives : clé invalide, quota atteint, réseau interrompu, service indisponible.
- Résultat : installation activée et protégée, sans données partielles en cas d'échec.

## UC-02 — Enregistrer un prospect

- Acteur principal : utilisateur.
- Précondition : application déverrouillée.
- Déclencheur : nouveau contact WhatsApp à suivre.
- Flux nominal : saisir le téléphone, vérifier les doublons, compléter les informations, associer localité et produits, enregistrer.
- Alternatives : contact existant, numéro invalide, nom inconnu.
- Résultat : contact-prospect créé et événement ajouté à la chronologie.

## UC-03 — Retrouver et qualifier un prospect

- Acteur principal : utilisateur.
- Flux nominal : rechercher ou filtrer, ouvrir la fiche, modifier statut/intérêt/tags/produits, ajouter une note.
- Alternatives : aucun résultat, référentiel manquant, contact archivé.
- Résultat : qualification actualisée et changements importants tracés.

## UC-04 — Planifier et effectuer une relance

- Acteur principal : utilisateur.
- Précondition : contact actif avec numéro exploitable.
- Flux nominal : créer l'échéance, recevoir ou consulter le rappel, choisir un modèle, prévisualiser, ouvrir WhatsApp, confirmer le résultat.
- Alternatives : notification refusée, variable manquante, WhatsApp absent, report ou annulation.
- Résultat : relance terminée, reportée ou annulée avec chronologie cohérente.

## UC-05 — Réaliser une campagne assistée

- Acteur principal : utilisateur.
- Flux nominal : créer le brouillon, définir les filtres, contrôler les exclusions, choisir le modèle, figer la sélection, traiter chaque destinataire, terminer la campagne.
- Alternatives : suspendre et reprendre, ignorer un destinataire, erreur d'ouverture, aucun contact éligible.
- Résultat : progression et historique enregistrés, sans envoi automatique.

## UC-06 — Convertir un prospect en client

- Acteur principal : utilisateur.
- Précondition : prospect existant non encore converti.
- Flux nominal : vérifier la fiche, confirmer la conversion, enregistrer la date, ouvrir la fiche client ou créer une facture.
- Alternative : contact déjà client.
- Résultat : même contact enrichi du profil client, historique intégral conservé.

## UC-07 — Créer et émettre une facture

- Acteur principal : utilisateur.
- Préconditions : entreprise configurée, client existant.
- Flux nominal : créer le brouillon, ajouter les lignes, vérifier les calculs, définir date et échéance, émettre, attribuer le numéro.
- Alternatives : données obligatoires manquantes, échéance invalide, collision de numéro.
- Résultat : facture immuable émise et ajoutée à la chronologie.

## UC-08 — Générer et partager une facture PDF

- Acteur principal : utilisateur.
- Précondition : facture enregistrée.
- Flux nominal : générer le PDF fidèle, prévisualiser, ouvrir le partage natif, choisir WhatsApp ou une autre application.
- Alternatives : génération impossible, stockage insuffisant, application de partage absente.
- Résultat : fichier partagé ou erreur récupérable sans altérer la facture.

## UC-09 — Enregistrer un paiement

- Acteur principal : utilisateur.
- Préconditions : facture émise non annulée avec solde positif.
- Flux nominal : saisir montant, date, mode et référence, valider, recalculer solde et état.
- Alternatives : montant supérieur au solde, date suspecte, annulation ultérieure.
- Résultat : paiement tracé, facture et statistiques actualisées.

## UC-10 — Consulter le tableau de bord et les statistiques

- Acteur principal : utilisateur.
- Flux nominal : choisir la période, consulter KPI, ouvrir un détail filtré, comparer demandes, ventes et encaissements.
- Alternatives : aucune donnée, données archivées, période personnalisée.
- Résultat : indicateurs reproductibles et période explicite.

## UC-11 — Créer une sauvegarde

- Acteur principal : utilisateur.
- Précondition : application déverrouillée.
- Flux nominal : lancer l'export, constituer l'archive, chiffrer et authentifier, choisir la destination, confirmer la réussite.
- Alternatives : stockage indisponible, annulation du partage, erreur de chiffrement.
- Résultat : fichier sauvegarde versionné sans secret serveur.

## UC-12 — Restaurer une sauvegarde

- Acteur principal : utilisateur.
- Préconditions : fichier accessible, authentification réussie.
- Flux nominal : sélectionner, vérifier intégrité et compatibilité, afficher le résumé, confirmer, restaurer atomiquement, contrôler les données.
- Alternatives : fichier altéré, version incompatible, mauvais secret, espace insuffisant, interruption.
- Résultat : nouvelles données cohérentes ou base précédente intacte.

## UC-13 — Archiver et réactiver une donnée

- Acteur principal : utilisateur.
- Objets concernés : contact, produit, tag, localité, source ou modèle selon les règles applicables.
- Flux nominal : demander l'archivage, consulter les impacts, confirmer, masquer des sélections actives, puis réactiver si nécessaire.
- Résultat : historique conservé et listes actives cohérentes.

## UC-14 — Transférer une licence

- Acteurs : utilisateur et administrateur SAMTECH.
- Préconditions : licence éligible, identité ou preuve d'achat vérifiable.
- Flux nominal proposé : demander le transfert, autoriser côté SAMTECH, désactiver/libérer l'ancien appareil, activer le nouveau, restaurer séparément les données.
- Alternatives : quota de transfert, ancien appareil indisponible, licence révoquée.
- Résultat : une liaison active conforme à l'offre ; aucune donnée commerciale transférée par le seul mécanisme de licence.

## Matrice de traçabilité

| Cas | User stories principales |
|---|---|
| UC-01 | US-LIC-001, US-LIC-002, US-SEC-001, US-SET-001 |
| UC-02 | US-CON-001, US-CON-002 |
| UC-03 | US-CON-003, US-CON-004, US-CON-006 |
| UC-04 | US-FOL-001, US-FOL-002, US-FOL-003, US-MSG-001 |
| UC-05 | US-CAM-001, US-CAM-002, US-CAM-003 |
| UC-06 | US-CLI-001, US-CLI-002 |
| UC-07 | US-INV-001, US-INV-002 |
| UC-08 | US-INV-003 |
| UC-09 | US-PAY-001, US-PAY-002, US-PAY-003 |
| UC-10 | US-DAS-001, US-STA-001, US-STA-002, US-STA-003 |
| UC-11 | US-BCK-001 |
| UC-12 | US-BCK-002 |
| UC-13 | US-CON-005, US-PRO-002, US-REF-001 |
| UC-14 | US-LIC-001, US-LIC-002 |

