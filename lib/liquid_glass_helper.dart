/// A helper library for checking support for the native glass effect.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// A helper class to check if the device supports the native glass effect.
class LiquidGlassHelper {
  LiquidGlassHelper._();

  static const MethodChannel _channel = MethodChannel('native_liquid_tab_bar');

  /// Checks if the current device supports the liquid glass effect.
  ///
  /// Returns `true` if the platform is iOS and the native check returns true.
  /// Returns `false` otherwise.
  static Future<bool> isLiquidGlassSupported() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) return false;
    try {
      final bool supported = await _channel.invokeMethod(
        'isLiquidGlassSupported',
      );
      return supported;
    } on PlatformException {
      return false;
    } catch (_) {
      return false;
    }
  }
}
