import 'package:flutter_test/flutter_test.dart';
import 'package:native_liquid_glass_navbar_example/main.dart';

void main() {
  testWidgets('Verify LiquidGlassApp loads properly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LiquidGlassApp());
    await tester.pumpAndSettle();

    expect(find.byType(LiquidGlassApp), findsOneWidget);
    expect(find.text('Glass Explorer'), findsWidgets);
  });
}
