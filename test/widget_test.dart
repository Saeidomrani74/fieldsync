import 'package:fieldsync/app/di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fieldsync/main.dart';

void main() {
  testWidgets('The text shows Syncing after tapping Sync now', (tester) async {
    setupDi();
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Sync now'));
    await tester.pump();
    expect(find.text('Current status: Syncing'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Current status: Idle'), findsOneWidget);
  });
}
