import 'package:fieldsync/app/di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fieldsync/main.dart';

void main() {

  testWidgets('The text shows SyncSyncing after tapping Sync now', (tester) async {
    setupDi();
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Sync now'));
    await tester.pump();
    expect(find.text('Current status: SyncSyncing()'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Current status: SyncIdle()'), findsOneWidget);
  });
}
