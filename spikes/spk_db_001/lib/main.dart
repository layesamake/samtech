import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spk_db_001/src/app/spike_app.dart';
import 'package:spk_db_001/src/bootstrap/spike_bootstrap.dart';
import 'package:spk_db_001/src/security/flutter_secure_key_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final supportDirectory = await getApplicationSupportDirectory();
  final bootstrap = SpikeBootstrap(
    supportDirectory: supportDirectory,
    keyStore: FlutterSecureKeyStore(),
  );

  runApp(SpikeApp(report: bootstrap.run()));
}
