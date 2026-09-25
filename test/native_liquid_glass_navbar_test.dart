import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_liquid_glass_navbar/native_liquid_glass_navbar.dart';

void main() {
  group('NativeLiquidGlassNavBar Cross-Platform & Android Fallback Widget Tests', () {
    testWidgets('Renders default frosted-glass fallback on non-iOS platforms', (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: NativeLiquidGlassNavBar(
              currentIndex: selectedIndex,
              onTap: (index) => selectedIndex = index,
              tabs: const [
                NativeLiquidGlassNavBarItem.icon(
                  label: 'Home',
                  icon: Icons.home_rounded,
                ),
                NativeLiquidGlassNavBarItem.icon(
                  label: 'Search',
                  icon: Icons.search_rounded,
                ),
                NativeLiquidGlassNavBarItem.icon(
                  label: 'Profile',
                  icon: Icons.person_rounded,
                ),
              ],
            ),
          ),
        ),
      );

      // Wait for FutureBuilder to settle
      await tester.pumpAndSettle();

      // Verify labels are displayed
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // Tap on 'Search' tab
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      expect(selectedIndex, 1);
    });

    testWidgets('Renders action button and triggers onTap', (tester) async {
      bool actionTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: NativeLiquidGlassNavBar(
              currentIndex: 0,
              onTap: (_) {},
              actionButton: NativeLiquidGlassActionButton.icon(
                icon: Icons.add_rounded,
                onTap: () => actionTapped = true,
              ),
              tabs: const [
                NativeLiquidGlassNavBarItem.icon(
                  label: 'Home',
                  icon: Icons.home_rounded,
                ),
                NativeLiquidGlassNavBarItem.icon(
                  label: 'Settings',
                  icon: Icons.settings_rounded,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the add icon
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);

      // Tap the action button
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pumpAndSettle();

      expect(actionTapped, isTrue);
    });

    testWidgets('Renders custom fallback widget when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: NativeLiquidGlassNavBar(
              currentIndex: 0,
              onTap: (_) {},
              fallback: const Text('Custom Fallback Navigation'),
              tabs: const [
                NativeLiquidGlassNavBarItem.icon(
                  label: 'Home',
                  icon: Icons.home_rounded,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Custom Fallback Navigation'), findsOneWidget);
    });

    testWidgets('Hides and ignores touches when navigated to another screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Scaffold(
                            body: Center(child: Text('New Screen')),
                          ),
                        ),
                      );
                    },
                    child: const Text('Go to Details'),
                  ),
                ),
                bottomNavigationBar: NativeLiquidGlassNavBar(
                  currentIndex: 0,
                  onTap: (_) {},
                  tabs: const [
                    NativeLiquidGlassNavBarItem.icon(
                      label: 'Home',
                      icon: Icons.home_rounded,
                    ),
                    NativeLiquidGlassNavBarItem.icon(
                      label: 'Search',
                      icon: Icons.search_rounded,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);

      // Navigate to another screen
      await tester.tap(find.text('Go to Details'));
      await tester.pumpAndSettle();

      expect(find.text('New Screen'), findsOneWidget);

      // Check Visibility of underlying navbar (route is now offstage in navigator)
      final visibilityFinder = find.byWidgetPredicate(
        (widget) => widget is Visibility && !widget.visible,
        skipOffstage: false,
      );
      expect(visibilityFinder, findsOneWidget);
    });

    testWidgets('Applies appropriate bottom margin on tablet/iPad screen sizes', (tester) async {
      tester.view.physicalSize = const Size(1024, 1366);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: NativeLiquidGlassNavBar(
              currentIndex: 0,
              onTap: (_) {},
              tabs: const [
                NativeLiquidGlassNavBarItem.icon(
                  label: 'Home',
                  icon: Icons.home_rounded,
                ),
                NativeLiquidGlassNavBarItem.icon(
                  label: 'Profile',
                  icon: Icons.person_rounded,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);

      final containerFinder = find.byWidgetPredicate(
        (w) => w is Container && w.margin is EdgeInsets && (w.margin as EdgeInsets).bottom >= 16.0,
      );
      expect(containerFinder, findsWidgets);
    });
  });
}
