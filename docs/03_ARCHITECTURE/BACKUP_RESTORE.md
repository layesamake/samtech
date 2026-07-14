# Architecture de sauvegarde et restauration

| Élément | Valeur |
|---|---|
| Statut | Conception de référence, cryptographie à prototyper |
| Version | 1.0 |
| Date | 14 juillet 2026 |

## 1. Objectifs

- produire un fichier cohérent et chiffré ;
- détecter toute altération avant restauration ;
- permettre le transfert des données entre Android et iPhone selon la licence ;
- conserver la base existante intacte si la restauration échoue ;
- ne jamais inclure de secret serveur ou clé privée de licence.

## 2. Contenu logique

Le paquet contient :

```text
manifest.json
database.enc
assets/
  organization-logo.enc   (si présent)
checksums/authentication data
```

La structure physique définitive dépendra de la bibliothèque cryptographique retenue. Les noms internes ne contiennent pas de donnée personnelle.

## 3. Manifeste minimal

| Champ | Description |
|---|---|
| `format_version` | version de l'enveloppe |
| `schema_version` | version de la base |
| `app_version` | version créatrice |
| `created_at` | instant UTC |
| `source_platform` | Android ou iOS |
| `organization_id_hash` | indicateur pseudonyme, pas l'identité |
| `database_size` | contrôle préliminaire |
| `assets` | liste et versions |
| `crypto_suite` | identifiant de suite, sans secret |

## 4. Clés

Deux scénarios doivent être prototypés :

1. sauvegarde protégée par un mot de passe choisi, avec dérivation mémoire-dure et paramètres enregistrés dans l'enveloppe ;
2. sauvegarde protégée par une clé de récupération générée, affichée une seule fois et conservée par l'utilisateur.

La clé locale du coffre natif ne suffit pas pour une sauvegarde destinée à un autre appareil. Aucun mot de passe n'est journalisé ou envoyé à SAMTECH par défaut.

## 5. Création

1. authentifier l'utilisateur ;
2. vérifier l'espace et l'état de la base ;
3. obtenir un snapshot cohérent après point de contrôle WAL ;
4. construire le manifeste ;
5. chiffrer et authentifier chaque contenu ;
6. écrire dans un fichier temporaire ;
7. vérifier le paquet produit ;
8. remettre le fichier au sélecteur/partage natif ;
9. enregistrer le résultat dans `backup_history`.

Une annulation du partage ne doit pas être enregistrée comme sauvegarde externe réussie.

## 6. Restauration

1. sélectionner le fichier ;
2. lire uniquement l'en-tête nécessaire et appliquer les limites de taille ;
3. dériver/obtenir la clé ;
4. authentifier le paquet avant d'utiliser le contenu ;
5. vérifier les versions ;
6. déchiffrer dans une zone temporaire ;
7. ouvrir et vérifier la base temporaire ;
8. migrer si nécessaire ;
9. afficher un résumé non sensible ;
10. demander confirmation renforcée ;
11. fermer la base active et effectuer le remplacement atomique ;
12. rouvrir et vérifier les invariants ;
13. conserver ou supprimer l'ancien snapshot selon la politique de récupération.

## 7. Défenses

- limites strictes de taille et de nombre de fichiers ;
- aucune extraction de chemin arbitraire ;
- authentification avant interprétation profonde ;
- refus des algorithmes inconnus ou obsolètes ;
- messages d'erreur qui ne distinguent pas inutilement mauvais secret et contenu précis ;
- nettoyage des fichiers temporaires ;
- aucune restauration partielle.

## 8. Licence et appareil

La sauvegarde restaure les données commerciales, pas la liaison de licence. Sur un nouvel appareil, la licence doit être activée ou transférée séparément avant l'usage normal. Le fichier peut contenir un identifiant d'organisation pseudonyme pour aider à détecter une erreur, jamais un mécanisme permettant de cloner la licence.

## 9. Tests

- bon et mauvais mot de passe ;
- fichier tronqué, altéré ou trop volumineux ;
- version future inconnue ;
- sauvegarde Android restaurée sur iOS et inversement ;
- interruption à chaque phase ;
- absence d'espace ;
- données accentuées et pièces jointes autorisées ;
- base ancienne nécessitant migration ;
- vérification de l'absence de licence clonée ;
- base active intacte après chaque échec.

## 10. Points ouverts

- mot de passe ou clé de récupération comme expérience par défaut ;
- algorithmes et bibliothèques exacts ;
- politique de conservation du snapshot précédent ;
- taille maximale du paquet ;
- inclusion future des documents PDF générés ou régénération à la demande.

