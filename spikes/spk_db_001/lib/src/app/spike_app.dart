import 'package:flutter/material.dart';
import 'package:spk_db_001/src/bootstrap/spike_report.dart';

class SpikeApp extends StatelessWidget {
  const SpikeApp({required this.report, super.key});

  final Future<SpikeReport> report;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'SPK-DB-001',
    theme: ThemeData(colorSchemeSeed: const Color(0xFF006B5F)),
    home: SpikeHome(report: report),
  );
}

class SpikeHome extends StatelessWidget {
  const SpikeHome({required this.report, super.key});

  final Future<SpikeReport> report;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('SPK-DB-001')),
    body: FutureBuilder<SpikeReport>(
      future: report,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Échec du prototype. Consultez le résultat du test sans '
                'journaliser de donnée sensible.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final value = snapshot.requireData;
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Icon(Icons.verified_user, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Base chiffrée opérationnelle',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _ResultLine(label: 'Chiffrement', value: value.cipher),
            _ResultLine(label: 'Journal', value: value.journalMode),
            _ResultLine(
              label: 'Clés étrangères',
              value: value.foreignKeysEnabled ? 'actives' : 'inactives',
            ),
            _ResultLine(
              label: 'Lignes fictives',
              value: '${value.insertedRows}',
            ),
            _ResultLine(
              label: 'Ouverture',
              value: '${value.openDuration.inMilliseconds} ms',
            ),
            _ResultLine(
              label: 'Écriture',
              value: '${value.writeDuration.inMilliseconds} ms',
            ),
            _ResultLine(
              label: 'Lecture',
              value: '${value.readDuration.inMilliseconds} ms',
            ),
          ],
        );
      },
    ),
  );
}

class _ResultLine extends StatelessWidget {
  const _ResultLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(label),
    trailing: Text(value),
  );
}
