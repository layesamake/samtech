# Sprint 0 — Socle Flutter

| Élément | Valeur |
|---|---|
| Statut | Audité et corrigé |
| Date | 14 juillet 2026 |
| Flutter | 3.44.6 stable |
| Dart | 3.12.2 |

## Périmètre livré

- application samtech_crm générée pour Android et iOS ;
- neuf membres du Pub workspace : l'application et huit packages partagés ;
- Melos 8.2.2 configuré sur le Pub workspace ;
- bootstrap avec ProviderScope, configuration stable et routeur déclaratif ;
- feature technique startup avec deux écrans vérifiant la navigation ;
- premiers tokens d'espacement et thème clair dans samtech_ui_kit ;
- analyse stricte, formatage et tests orchestrés par Melos.

## Commandes

    dart pub get
    dart run melos list
    dart run melos run format
    dart run melos run analyze
    dart run melos run test

Le build Android se vérifie avec flutter build apk --debug depuis
apps/samtech_crm. Le build iOS nécessite macOS et Xcode et ne peut pas être
produit depuis l'environnement Windows actuel.

## Limites volontaires

Aucun module métier, stockage, plugin natif, chiffrement, licence ou
génération Riverpod n'est introduit. Les packages concernés exposent seulement
leur point d'entrée jusqu'aux spikes et sprints documentés. Le routeur du Sprint
0 ne crée pas encore la shell des cinq destinations : il valide uniquement le
câblage avant l'implémentation des parcours fonctionnels.

## Garde-fous d'audit

- le script de tests Melos est non interactif et compatible avec la CI ;
- la feature `startup` possède ses chemins de route et ne dépend pas du dossier
  global `app/` ;
- une route inconnue affiche un écran neutre sans détail interne ;
- aucun build Android release ne retombe sur la clé de signature debug ;
- le workflow `quality.yml` vérifie formatage, analyse et tests sans secret.

## Résultat de l'audit

L'audit du 14 juillet 2026 confirme : formatage conforme, analyse statique sans
diagnostic, six tests réussis et APK debug Android généré. Les dépendances
directes sont à jour et aucun secret ou donnée client réelle n'a été détecté.
Le build iOS reste à exécuter sur macOS avec Xcode, la commande n'étant pas
disponible dans l'environnement Windows de l'audit.
