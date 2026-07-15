# SAMTECH CRM

Application Flutter Android/iOS destinée à devenir le CRM mobile offline-first de SAMTECH.

## État Sprint 0

L'application contient uniquement le bootstrap Flutter, le `ProviderScope` Riverpod, le routeur et un écran de démarrage temporaire utilisant `ui_kit`. Aucun module métier, stockage, sécurité, licence, synchronisation ou effet réseau fonctionnel n'est livré.

Les sources Android et iOS sont initialisées. La validation iOS n'a pas été effectuée, faute d'environnement macOS dans le Sprint 0.

## Commandes

La résolution et les contrôles sont pilotés depuis la racine du Pub Workspace :

```shell
flutter pub get
dart run melos run quality --no-select
```
