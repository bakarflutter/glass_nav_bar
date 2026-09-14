import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Helper to render SVGs, PNG assets, and Flutter IconData into rasterized PNG bytes for native platform views.
class GlassIconLoader {
  GlassIconLoader._();

  static final Map<String, Uint8List> _cache = <String, Uint8List>{};

  /// Clears the in-memory cache of rasterized images.
  static void clearCache() {
    _cache.clear();
  }

  /// Resolves any icon type (SVG, PNG asset, Flutter IconData, or raw bytes) into PNG byte data.
  static Future<Uint8List?> resolveImageBytes({
    String? svgPath,
    String? svgString,
    Uint8List? svgBytes,
    String? assetPath,
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

    // 2. PNG / Raster Asset Path (e.g. 'assets/icons/home.png')
    if (assetPath != null && assetPath.isNotEmpty) {
      if (assetPath.toLowerCase().endsWith('.svg')) {
        return rasterizeSvg(
          svgPath: assetPath,
          targetWidth: targetWidth,
          targetHeight: targetHeight,
          pixelRatio: pixelRatio,
        );
      }
      return loadRasterAsset(assetPath);
    }

    // 3. Custom SVG
    if (svgPath != null || svgString != null || svgBytes != null) {
      return rasterizeSvg(
        svgPath: svgPath,
        svgString: svgString,
        svgBytes: svgBytes,
        targetWidth: targetWidth,
        targetHeight: targetHeight,
        pixelRatio: pixelRatio,
      );
    }

    // 4. Flutter IconData (Material, Cupertino, or custom IconData)
    if (icon != null) {
      return rasterizeIconData(
        icon,
        targetSize: targetWidth,
        pixelRatio: pixelRatio,
      );
    }

    return null;
  }

  /// Loads a raster asset (PNG, JPG, WebP) from Flutter rootBundle.
  static Future<Uint8List?> loadRasterAsset(String assetPath) async {
    final String cacheKey = 'asset_$assetPath';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey];
    }

    try {
      final ByteData byteData = await rootBundle.load(assetPath);
      final Uint8List bytes = byteData.buffer.asUint8List();
      _cache[cacheKey] = bytes;
      return bytes;
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('GlassIconLoader failed to load raster asset "$assetPath": $e\n$stack');
      }
      return null;
    }
  }

  /// Rasterizes Flutter [IconData] to high-resolution PNG bytes with proper icon padding.
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

      final double fontSize = dimension * 0.75;
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
          (dimension - textPainter.height) / 2 - (dimension * 0.04),
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

  /// Rasterizes an SVG into high-resolution PNG bytes with uniform aspect ratio & centering.
  static Future<Uint8List?> rasterizeSvg({
    String? svgPath,
    String? svgString,
    Uint8List? svgBytes,
    double targetWidth = 24.0,
    double targetHeight = 24.0,
    double pixelRatio = 3.0,
  }) async {
    if (svgPath == null && svgString == null && svgBytes == null) {
      return null;
    }

    final String cacheKey =
        'svg_${svgPath ?? ''}_${svgString ?? ''}_${svgBytes?.length ?? 0}_${targetWidth}_${targetHeight}_$pixelRatio';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey];
    }

    try {
      final BytesLoader loader;
      if (svgPath != null) {
        loader = SvgAssetLoader(svgPath);
      } else if (svgString != null) {
        loader = SvgStringLoader(svgString);
      } else {
        loader = SvgBytesLoader(svgBytes!);
      }

      final PictureInfo pictureInfo = await vg.loadPicture(loader, null);

      final int width = (targetWidth * pixelRatio).round();
      final int height = (targetHeight * pixelRatio).round();

      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final ui.Canvas canvas = ui.Canvas(recorder);

      final double originalWidth =
          pictureInfo.size.width > 0 ? pictureInfo.size.width : targetWidth;
      final double originalHeight =
          pictureInfo.size.height > 0 ? pictureInfo.size.height : targetHeight;

      final double targetDrawableWidth = width * 0.82;
      final double targetDrawableHeight = height * 0.82;

      // Maintain uniform aspect ratio
      final double scale = math.min(
        targetDrawableWidth / originalWidth,
        targetDrawableHeight / originalHeight,
      );

      final double scaledWidth = originalWidth * scale;
      final double scaledHeight = originalHeight * scale;

      // Center the scaled icon within the canvas with slight top lift
      final double offsetX = (width - scaledWidth) / 2;
      final double offsetY =
          (height - scaledHeight) / 2 - (height * 0.04);

      canvas.save();
      canvas.translate(offsetX, offsetY);
      canvas.scale(scale, scale);
      canvas.drawPicture(pictureInfo.picture);
      canvas.restore();

      final ui.Picture scaledPicture = recorder.endRecording();
      final ui.Image image = await scaledPicture.toImage(width, height);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      pictureInfo.picture.dispose();
      scaledPicture.dispose();
      image.dispose();

      if (byteData == null) {
        return null;
      }

      final Uint8List result = byteData.buffer.asUint8List();
      _cache[cacheKey] = result;
      return result;
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('GlassIconLoader failed to rasterize SVG: $e\n$stack');
      }
      return null;
    }
  }
}
