import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_liquid_glass_navbar/native_liquid_glass_navbar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GlassIconLoader Tests', () {
    test('Rasterizes IconData to PNG bytes successfully', () async {
      final Uint8List? bytes = await GlassIconLoader.rasterizeIconData(
        Icons.home,
        targetSize: 24.0,
      );

      expect(bytes, isNotNull);
      expect(bytes!.isNotEmpty, isTrue);
      // Verify PNG magic header: 0x89, 0x50, 0x4E, 0x47
      expect(bytes[0], 0x89);
      expect(bytes[1], 0x50);
      expect(bytes[2], 0x4E);
      expect(bytes[3], 0x47);
    });

    test(
      'resolveImageBytes prioritizes raw imageBytes when provided',
      () async {
        final Uint8List dummyBytes = Uint8List.fromList([1, 2, 3, 4]);
        final Uint8List? result = await GlassIconLoader.resolveImageBytes(
          imageBytes: dummyBytes,
          icon: Icons.search,
        );

        expect(result, equals(dummyBytes));
      },
    );

    test('resolveImageBytes resolves IconData when provided', () async {
      final Uint8List? result = await GlassIconLoader.resolveImageBytes(
        icon: Icons.person,
      );

      expect(result, isNotNull);
      expect(result![0], 0x89);
    });

    test('Rasterizes IconData to valid PNG bytes', () async {
      final bytes = await GlassIconLoader.rasterizeIconData(
        Icons.home,
        targetSize: 28.0,
        pixelRatio: 3.0,
      );
      expect(bytes, isNotNull);
      expect(bytes!.isNotEmpty, isTrue);
    });
  });

  group(
    'NativeLiquidGlassNavBarItem and NativeLiquidGlassActionButton models',
    () {
      test('Constructs NativeLiquidGlassNavBarItem with custom iconWidget', () {
        const item = NativeLiquidGlassNavBarItem(
          label: 'Custom',
          iconWidget: FlutterLogo(),
          selectedIconWidget: FlutterLogo(textColor: Colors.blue),
        );
        expect(item.label, 'Custom');
        expect(item.iconWidget, isA<FlutterLogo>());
        expect(item.selectedIconWidget, isA<FlutterLogo>());
      });

      test('Constructs NativeLiquidGlassNavBarItem with assetPath', () {
        const item = NativeLiquidGlassNavBarItem(
          label: 'Search',
          assetPath: 'assets/icons/search.png',
        );
        expect(item.label, 'Search');
        expect(item.assetPath, 'assets/icons/search.png');
      });

      test('Constructs NativeLiquidGlassNavBarItem with IconData', () {
        const item = NativeLiquidGlassNavBarItem(
          label: 'Settings',
          icon: Icons.settings,
        );
        expect(item.label, 'Settings');
        expect(item.icon, Icons.settings);
      });

      test('Constructs NativeLiquidGlassNavBarItem with SF symbol', () {
        const item = NativeLiquidGlassNavBarItem(
          label: 'Home',
          symbol: 'house.fill',
        );
        expect(item.label, 'Home');
        expect(item.symbol, 'house.fill');
      });

      test(
        'Constructs NativeLiquidGlassActionButton with custom iconWidget',
        () {
          final button = NativeLiquidGlassActionButton(
            iconWidget: const Icon(Icons.add),
            onTap: () {},
          );
          expect(button.iconWidget, isA<Icon>());
        },
      );
    },
  );
}
