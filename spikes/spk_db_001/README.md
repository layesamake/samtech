# SPK-DB-001 — Drift avec SQLite chiffré

Prototype isolé destiné à valider la pile `Drift` + `sqlite3` +
`SQLite3MultipleCiphers` sur Android et iOS. Il ne contient que deux tables de
test génériques et des données fictives.

La clé de 256 bits est créée avec `Random.secure()` puis conservée par
`flutter_secure_storage` dans Android Keystore ou iOS Keychain. Elle n'est
jamais journalisée ni stockée dans les préférences ordinaires.

Le spike est volontairement hors du workspace Pub racine : `drift_dev 2.34.0`
requiert `cli_util 0.4`, incompatible avec `melos 8.2.2` qui requiert
`cli_util 0.5`. Les commandes doivent donc être lancées depuis ce dossier.

```shell
flutter pub get
dart run build_runner build
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build apk --debug --target-platform android-x64
flutter test integration_test/device_secure_database_test.dart \
  -d emulator-5554 --dart-define=SPK_PRESERVE_STATE=true
flutter test integration_test/device_secure_database_test.dart \
  -d emulator-5554 --dart-define=SPK_PRESERVE_STATE=true \
  --dart-define=SPK_EXPECT_EXISTING_STATE=true
```

Les résultats et réserves sont consignés dans
`docs/03_ARCHITECTURE/SPIKE_DB_ENCRYPTION.md` à la racine du dépôt.
