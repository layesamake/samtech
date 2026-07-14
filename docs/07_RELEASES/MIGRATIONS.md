# Stratégie de migrations de données

| Élément | Valeur |
|---|---|
| Statut | Politique de référence |
| Version | 1.0 |
| Date | 14 juillet 2026 |

## 1. Objectif

Faire évoluer le schéma et les données sans perte, sans corruption silencieuse et avec une procédure de récupération vérifiable sur Android et iOS.

## 2. Versionnement

Trois versions sont distinctes :

- version de l'application ;
- version du schéma SQLite/Drift ;
- version du format de sauvegarde.

Une application peut modifier son interface sans modifier le schéma. Une sauvegarde peut évoluer indépendamment si son enveloppe de chiffrement ou son manifeste change.

## 3. Règles

1. Chaque modification de schéma incrémente la version exactement une fois.
2. Une migration est additive lorsque possible : ajouter avant de retirer.
3. Une colonne obligatoire est ajoutée nullable ou avec une valeur sûre, remplie, vérifiée puis contrainte.
4. Aucun identifiant, numéro de facture ou montant n'est recalculé sans règle explicite.
5. Une migration ne dépend pas du réseau.
6. Les clés étrangères sont vérifiées après migration.
7. Les changements irréversibles sont documentés et précédés d'une sauvegarde compatible.
8. Le code n'ignore jamais une version inconnue ou plus récente.

## 4. Structure d'une fiche de migration

Chaque migration documente :

```text
Identifiant : DB-xxx
Version source : n
Version cible : n+1
Application minimale : x.y.z
Motif :
Tables/colonnes concernées :
Transformation :
Valeurs par défaut :
Contrôles avant :
Contrôles après :
Impact sauvegardes :
Temps estimé par volume :
Reprise en cas d'échec :
Tests :
```

## 5. Procédure d'exécution

```text
Ouvrir la base avec la clé locale
  → Lire la version
  → Vérifier l'espace disponible
  → Créer un point de récupération local si la politique le permet
  → Démarrer une transaction de migration
  → Appliquer chaque version intermédiaire dans l'ordre
  → Recréer/mettre à jour index et vues
  → Vérifier foreign_key_check et invariants métier
  → Mettre à jour la version
  → Valider la transaction
  → Ouvrir l'application
```

Si une migration ne peut pas être entièrement transactionnelle, elle utilise une base temporaire, valide la copie puis effectue un remplacement atomique.

## 6. Contrôles post-migration

- `PRAGMA foreign_key_check` sans erreur ;
- version de schéma attendue ;
- nombres de contacts, factures, lignes et paiements cohérents ;
- aucune facture émise sans numéro ou ligne ;
- aucune ligne financière avec montant impossible ;
- aucun paiement valide supérieur au solde disponible au moment de la vérification ;
- unicité des numéros de facture et destinataires de campagne ;
- ouverture des requêtes critiques.

## 7. Compatibilité des sauvegardes

Le manifeste de sauvegarde indique `backup_format_version`, `schema_version`, `app_version`, plateforme source et date.

- une sauvegarde de schéma plus ancien peut être restaurée dans une zone temporaire puis migrée ;
- une sauvegarde plus récente que l'application est refusée avec instruction de mise à jour ;
- Android et iOS doivent partager le même format logique, indépendamment du chemin de stockage ;
- une restauration ne contourne jamais la vérification de licence.

## 8. Tests automatiques

Pour chaque migration :

- base vide de la version source ;
- base nominale avec toutes les entités ;
- base volumineuse ;
- caractères accentués, noms longs et numéros internationaux ;
- factures brouillon, émises, payées et annulées ;
- campagnes à chaque état ;
- interruption simulée ;
- espace disque insuffisant ;
- sauvegarde puis restauration après migration ;
- comparaison des invariants avant/après.

## 9. Support des versions

L'application doit migrer depuis toutes les versions officiellement publiées encore supportées. Si une migration directe devient trop coûteuse, elle enchaîne les migrations intermédiaires testées. Aucune version de production ne doit exiger la suppression manuelle de la base.

## 10. Journal des migrations

| ID | Source | Cible | État | Description |
|---|---:|---:|---|---|
| DB-001 | 0 | 1 | planifiée | schéma initial Starter |

Les futures entrées sont ajoutées avant publication de la version concernée.

