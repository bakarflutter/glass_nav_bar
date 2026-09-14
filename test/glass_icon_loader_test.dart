import 'dart:io';
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

    test('Rasterizes raw SVG string to PNG bytes successfully', () async {
      const String svgStr = '''
<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>
</svg>
''';

      final Uint8List? bytes = await GlassIconLoader.rasterizeSvg(
        svgString: svgStr,
        targetWidth: 24.0,
        targetHeight: 24.0,
      );

      expect(bytes, isNotNull);
      expect(bytes!.isNotEmpty, isTrue);
      expect(bytes[0], 0x89);
      expect(bytes[1], 0x50);
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

    test('Generates PNG icon assets for example app', () async {
      final Map<String, IconData> icons = {
        'home.png': Icons.home_rounded,
        'search.png': Icons.search_rounded,
        'heart.png': Icons.favorite_rounded,
        'settings.png': Icons.settings_rounded,
        'plus.png': Icons.add_rounded,
      };

      for (final entry in icons.entries) {
        final bytes = await GlassIconLoader.rasterizeIconData(
          entry.value,
          targetSize: 28.0,
          pixelRatio: 3.0,
        );
        expect(bytes, isNotNull);
        final file = File(
          '/Users/wajid/Desktop/native_glass_navbar-main/example/assets/icons/${entry.key}',
        );
        await file.writeAsBytes(bytes!);
        expect(await file.exists(), isTrue);
      }
    });
  });

  group(
    'NativeLiquidGlassNavBarItem and NativeLiquidGlassActionButton models',
    () {
      test('Constructs NativeLiquidGlassNavBarItem with svgPath', () {
        const item = NativeLiquidGlassNavBarItem(
          label: 'Home',
          svgPath: 'assets/icons/home.svg',
        );
        expect(item.label, 'Home');
        expect(item.svgPath, 'assets/icons/home.svg');
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

      test('Constructs NativeLiquidGlassActionButton with svgPath', () {
        final button = NativeLiquidGlassActionButton(
          svgPath: 'assets/icons/plus.svg',
          onTap: () {},
        );
        expect(button.svgPath, 'assets/icons/plus.svg');
      });
    },
  );
}
