import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:spk_db_001/src/app/spike_app.dart';
import 'package:spk_db_001/src/bootstrap/spike_report.dart';

void main() {
  testWidgets('shows a successful encrypted-database report', (tester) async {
    const report = SpikeReport(
      openDuration: Duration(milliseconds: 12),
      writeDuration: Duration(milliseconds: 34),
      readDuration: Duration(milliseconds: 5),
      insertedRows: 5000,
      foreignKeysEnabled: true,
      journalMode: 'wal',
      cipher: 'chacha20',
    );

    await tester.pumpWidget(SpikeApp(report: Future.value(report)));
    await tester.pumpAndSettle();

    expect(find.text('Base chiffrée opérationnelle'), findsOneWidget);
    expect(find.text('5000'), findsOneWidget);
    expect(find.text('chacha20'), findsOneWidget);
  });

  testWidgets('does not expose exception details on bootstrap failure', (
    tester,
  ) async {
    final report = Completer<SpikeReport>();
    await tester.pumpWidget(SpikeApp(report: report.future));
    report.completeError(StateError('sensitive'));
    await tester.pump();

    expect(find.textContaining('Échec du prototype'), findsOneWidget);
    expect(find.textContaining('sensitive'), findsNothing);
  });
}
