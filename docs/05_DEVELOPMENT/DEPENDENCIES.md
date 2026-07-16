# Stratégie des dépendances Flutter

| Élément | Valeur |
|---|---|
| Statut | Baseline Sprint 0 définie ; candidats métier soumis aux spikes |
| Version | 1.1 |
| Date | 15 juillet 2026 |

## 1. Politique

- préférer Flutter/Dart officiels ou éditeurs reconnus ;
- vérifier maintenance, licence, plateformes, changelog et issues critiques ;
- encapsuler toute dépendance native ou critique ;
- éviter deux packages pour la même responsabilité ;
- utiliser un Pub Workspace et versionner son unique `pubspec.lock` racine ;
- interdire les locks enfants et les `pubspec_overrides.yaml` persistants ;
- faire respecter le lockfile en CI avec `flutter pub get --enforce-lockfile` ;
- automatiser l'audit et mettre à jour par lots testés ;
- déclarer les contraintes dans les manifestes et consigner ici la baseline effectivement retenue.

## 2. Baseline du Sprint 0

| Élément | Version/contrainte retenue | Usage |
|---|---|---|
| Flutter | `3.44.6` stable | SDK CI et développement |
| Dart | `3.12.2` | SDK fourni par Flutter 3.44.6 |
| Melos | `8.2.2` | orchestration locale via `dart run melos` |
| `flutter_riverpod` | `^3.3.2` | bootstrap et injection |
| `go_router` | `^17.3.0` | navigation déclarative |
| `flutter_lints` | `^6.0.0` | règles Flutter |
| `lints` | `^6.1.0` | règles des packages Dart réservés |

Melos est une dépendance de développement racine, jamais une installation globale. L'application dépend de `ui_kit` par contrainte `^0.1.0` ; Pub Workspaces résout automatiquement cette contrainte vers le membre local correspondant.

## 3. Candidats principaux

| Besoin | Package candidat | Décision |
|---|---|---|
| État et injection | `flutter_riverpod` | bootstrap minimal implémenté au Sprint 0 |
| Navigation | `go_router` | bootstrap minimal implémenté au Sprint 0 |
| Génération Riverpod/routeur | `riverpod_annotation`, `riverpod_generator`, `go_router_builder` | non retenue au Sprint 0 ; spike préalable |
| Base relationnelle | `drift`, `drift_flutter` | candidat privilégié ; ajout conditionné à SPK-DB-001 |
| SQLite chiffré | intégration SQLCipher compatible Drift | spike bloquant |
| Coffre sécurisé | `flutter_secure_storage` ou adaptateur natif | candidat, tester migrations/backup |
| Biométrie | `local_auth` | candidat officiel Flutter |
| Notifications | `flutter_local_notifications`, `timezone` | candidat |
| HTTP licence | `http` | candidat minimal ; à encapsuler s'il est retenu |
| Signature | `cryptography` | validé avec réserves par SPK-LIC-001 ; limites dans son rapport d'audit |
| PDF | `pdf`, `printing` | candidat |
| Partage | `share_plus` | candidat |
| URL WhatsApp | `url_launcher` | candidat avec repli |
| Fichiers | `file_selector`, `path_provider` | candidats |
| Informations app | `package_info_plus` | candidat |
| UUID | `uuid` | candidat |
| Localisation | `intl`, localisation Flutter | candidat, non intégré au Sprint 0 |
| Sérialisation | `json_serializable` | candidat, non intégré au Sprint 0 |
| Logs | `logging` avec façade SAMTECH | candidat |
| Génération | `build_runner`, `drift_dev`, `riverpod_generator` | conditionnels aux choix techniques validés ; absents du Sprint 0 |

## 4. Dépendances volontairement évitées au départ

- service locator global ;
- bibliothèque fonctionnelle lourde uniquement pour un type Result ;
- stockage clé-valeur comme base métier ;
- connectivité utilisée comme preuve qu'Internet fonctionne ;
- SDK analytique distant dans la Starter ;
- package d'identifiant matériel intrusif ;
- bibliothèque de cryptographie non auditée ou algorithme maison.

## 5. Spikes obligatoires

### SPK-DB-001 — Drift + SQLite chiffré

Valider ouverture background, migrations, Android/iOS, rotation de clé, sauvegarde et performances.

### SPK-LIC-001 — Signature de licence

Valider génération serveur, vérification mobile, taille du jeton, rotation de clés et résistance aux erreurs d'horloge.

Dépendances directes et de développement du package lors de l'audit :

| Dépendance | Contrainte | Résolue | Usage | Maintenance / licence |
|---|---:|---:|---|---|
| `cryptography` | `^2.9.0` | `2.9.0` | primitive Ed25519 et types de clé/signature | dint.dev, Apache-2.0 |
| `meta` | `^1.15.0` | `1.18.0` | annotations d'immutabilité | dart.dev, BSD-3-Clause |
| `lints` (dev) | `^6.1.0` | `6.1.0` | analyse statique Dart | dart.dev, BSD-3-Clause |
| `test` (dev) | `^1.24.0` | `1.31.0` | tests unitaires/adversariaux | dart.dev, BSD-3-Clause |

`convert` 3.1.2 reste transitif dans le lockfile, notamment via l'outillage de test/analyse ; il n'est ni importé ni déclaré directement par `license_manager`, qui utilise `dart:convert`. Le package n'a aucune dépendance Flutter. `cryptography` est activement publié mais reste un composant tiers : aucune certification ou revue cryptographique indépendante du package n'est revendiquée. Un inventaire automatisé complet des licences transitives reste à mettre en place.

### SPK-BCK-001 — Enveloppe de sauvegarde

Valider KDF, chiffrement authentifié, gros fichiers, restauration atomique et portabilité.

### SPK-NOT-001 — Notifications

Valider permissions, fuseaux, redémarrage, limites Android/iOS et réconciliation.

### SPK-SHR-001 — WhatsApp et partage

Valider encodage des numéros/messages, application absente, retour utilisateur et partage PDF.

## 6. Exigences de plateforme

Les projets Android et iOS utilisent les minima effectifs du template Flutter 3.44.6 (dont iOS 13.0 et `flutter.minSdkVersion` côté Android), mais la politique produit de compatibilité reste à valider après les spikes. Les packages récents peuvent relever les exigences SDK, Java, Kotlin, Gradle ou iOS ; le projet doit choisir consciemment le compromis entre sécurité, maintenance et parc d'appareils ciblé.

La validation iOS n'a pas été réalisée pendant le Sprint 0, l'environnement d'audit étant Windows. Elle requiert une machine macOS avant livraison.

## 7. Références vérifiées

- Riverpod : https://riverpod.dev/
- Drift : https://drift.simonbinder.eu/
- go_router : https://pub.dev/packages/go_router
- local_auth : https://pub.dev/packages/local_auth
- flutter_secure_storage : https://pub.dev/packages/flutter_secure_storage
- flutter_local_notifications : https://pub.dev/packages/flutter_local_notifications
- share_plus : https://pub.dev/packages/share_plus
- pdf : https://pub.dev/packages/pdf
- printing : https://pub.dev/packages/printing
- url_launcher : https://pub.dev/packages/url_launcher
