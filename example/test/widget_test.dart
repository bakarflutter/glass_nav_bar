import 'package:flutter_test/flutter_test.dart';
import 'package:native_liquid_glass_navbar_example/main.dart';

void main() {
  testWidgets('Verify LiquidGlassApp loads properly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LiquidGlassApp());
    await tester.pumpAndSettle();

    expect(find.text('Explore Feed'), findsWidgets);
    expect(find.text('Authentic Liquid Glass'), findsOneWidget);
  });
}
