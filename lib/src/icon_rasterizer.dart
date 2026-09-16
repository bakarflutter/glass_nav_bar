import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Helper to rasterize Flutter [IconData] into crisp PNG bytes for native platform views.
class GlassIconLoader {
  GlassIconLoader._();

  static final Map<String, Uint8List> _cache = <String, Uint8List>{};

  /// Clears the in-memory cache of rasterized images.
  static void clearCache() {
    _cache.clear();
  }

  /// Resolves any icon type (Flutter [IconData] or raw bytes) into PNG byte data.
  static Future<Uint8List?> resolveImageBytes({
    IconData? icon,
    Uint8List? imageBytes,
    double targetWidth = 24.0,
    double targetHeight = 24.0,
    double pixelRatio = 3.0,
  }) async {
    // 1. Direct raw image bytes
    if (imageBytes != null && imageBytes.isNotEmpty) {
      return imageBytes;
    }

    // 2. Flutter IconData (Material, Cupertino, or custom IconData)
    if (icon != null) {
      return rasterizeIconData(
        icon,
        targetSize: targetWidth,
        pixelRatio: pixelRatio,
      );
    }

    return null;
  }

  /// Rasterizes Flutter [IconData] to high-resolution PNG bytes with proper icon centering.
  static Future<Uint8List?> rasterizeIconData(
    IconData iconData, {
    double targetSize = 24.0,
    double pixelRatio = 3.0,
  }) async {
    final String cacheKey =
        'icon_${iconData.codePoint}_${iconData.fontFamily}_${iconData.fontPackage}_${targetSize}_$pixelRatio';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey];
    }

    try {
      final int dimension = (targetSize * pixelRatio).round();
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final ui.Canvas canvas = ui.Canvas(recorder);

      final double fontSize = dimension * 1.25;
      final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: String.fromCharCode(iconData.codePoint),
          style: TextStyle(
            inherit: false,
            color: const Color(0xFF000000),
            fontSize: fontSize,
            fontFamily: iconData.fontFamily,
            package: iconData.fontPackage,
            fontFamilyFallback: iconData.fontFamilyFallback,
          ),
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          (dimension - textPainter.width) / 2,
          (dimension - textPainter.height) / 2,
        ),
      );

      final ui.Picture picture = recorder.endRecording();
      final ui.Image image = await picture.toImage(dimension, dimension);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      picture.dispose();
      image.dispose();
      textPainter.dispose();

      if (byteData == null) return null;

      final Uint8List result = byteData.buffer.asUint8List();
      _cache[cacheKey] = result;
      return result;
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('GlassIconLoader failed to rasterize IconData: $e\n$stack');
      }
      return null;
    }
  }
}
