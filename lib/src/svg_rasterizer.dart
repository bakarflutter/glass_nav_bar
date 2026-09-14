import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Helper to render SVG assets or strings into rasterized PNG bytes for native platform views.
class SvgRasterizer {
  SvgRasterizer._();

  static final Map<String, Uint8List> _cache = <String, Uint8List>{};

  /// Clears the in-memory cache of rasterized SVG images.
  static void clearCache() {
    _cache.clear();
  }

  /// Rasterizes an SVG from an asset path, raw string, or bytes into PNG [Uint8List] bytes.
  ///
  /// [svgPath] is the Flutter asset path (e.g. 'assets/icons/home.svg').
  /// [svgString] is raw SVG XML string.
  /// [svgBytes] is raw SVG byte data.
  /// [targetWidth] and [targetHeight] are the logical dimensions in points (default: 24.0 x 24.0).
  /// [pixelRatio] is the scale factor (default: 3.0 for retina display @3x).
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
        '${svgPath ?? ''}_${svgString ?? ''}_${svgBytes?.length ?? 0}_${targetWidth}_${targetHeight}_$pixelRatio';
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

      final double scaleX = width / originalWidth;
      final double scaleY = height / originalHeight;

      canvas.scale(scaleX, scaleY);
      canvas.drawPicture(pictureInfo.picture);

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
        debugPrint('SvgRasterizer failed to rasterize SVG: $e\n$stack');
      }
      return null;
    }
  }
}
