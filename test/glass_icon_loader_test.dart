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

      test('Constructs NativeLiquidGlassNavBarItem with named widget constructor', () {
        const item = NativeLiquidGlassNavBarItem.widget(
          label: 'Widget Tab',
          iconWidget: Icon(Icons.star),
        );
        expect(item.label, 'Widget Tab');
        expect(item.iconWidget, isA<Icon>());
      });

      test('Constructs NativeLiquidGlassNavBarItem with IconData', () {
        const item = NativeLiquidGlassNavBarItem.icon(
          label: 'Settings',
          icon: Icons.settings,
        );
        expect(item.label, 'Settings');
        expect(item.icon, Icons.settings);
      });

      test('Constructs NativeLiquidGlassNavBarItem with SF symbol', () {
        const item = NativeLiquidGlassNavBarItem.symbol(
          label: 'Home',
          symbol: 'house.fill',
        );
        expect(item.label, 'Home');
        expect(item.symbol, 'house.fill');
      });

      test('Constructs NativeLiquidGlassActionButton with custom iconWidget', () {
        final button = NativeLiquidGlassActionButton.widget(
          iconWidget: const Icon(Icons.add),
          onTap: () {},
        );
        expect(button.iconWidget, isA<Icon>());
      });

      test('Constructs NativeLiquidGlassActionButton with IconData', () {
        final button = NativeLiquidGlassActionButton.icon(
          icon: Icons.add,
          onTap: () {},
        );
        expect(button.icon, Icons.add);
      });

      test('Constructs NativeLiquidGlassActionButton with SF symbol', () {
        final button = NativeLiquidGlassActionButton.symbol(
          symbol: 'plus',
          onTap: () {},
        );
        expect(button.symbol, 'plus');
      });
    },
  );
}
