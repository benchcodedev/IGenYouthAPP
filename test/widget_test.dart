import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igen_youth/main.dart';

void main() {
  testWidgets('IGen Youth app renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: IGenYouthApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('IGen Youth'), findsWidgets);
  });
}
