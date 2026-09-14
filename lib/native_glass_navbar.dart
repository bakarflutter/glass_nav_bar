/// A Flutter plugin that provides a native liquid glass navigation bar for iOS with custom SVG, PNG, and icon support.
library native_glass_navbar;

export 'liquid_glass_helper.dart';
export 'src/icon_rasterizer.dart';

import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_glass_navbar/liquid_glass_helper.dart';
import 'package:native_glass_navbar/src/icon_rasterizer.dart';

/// Represents a tab item in the [NativeGlassNavBar].
class NativeGlassNavBarItem {
  /// The label text to display for the tab.
  final String label;

  /// The Flutter asset path for a custom SVG icon (e.g., 'assets/icons/home.svg').
  final String? svgPath;

  /// The Flutter asset path for a custom PNG/raster icon (e.g., 'assets/icons/home.png').
  final String? assetPath;

  /// A Flutter [IconData] to render as the tab icon (e.g., [Icons.home]).
  final IconData? icon;

  /// The raw SVG XML string for the icon.
  final String? svgString;

  /// Raw image byte data (PNG format).
  final Uint8List? imageBytes;

  /// The SF Symbol name or iOS asset catalog name (e.g., 'house', 'gear').
  final String? symbol;

  /// Creates a new [NativeGlassNavBarItem].
  ///
  /// Provide at least one icon source: [svgPath], [assetPath], [icon], [svgString],
  /// [imageBytes], or [symbol].
  const NativeGlassNavBarItem({
    required this.label,
    this.svgPath,
    this.assetPath,
    this.icon,
    this.svgString,
    this.imageBytes,
    this.symbol,
  }) : assert(
         svgPath != null ||
             assetPath != null ||
             icon != null ||
             svgString != null ||
             imageBytes != null ||
             symbol != null,
         'Provide at least one icon source (svgPath, assetPath, icon, svgString, imageBytes, or symbol).',
       );
}

/// Represents an action button in the [NativeGlassNavBar].
///
/// It appears to the right of the tab as a circular floating button.
class TabBarActionButton {
  /// The Flutter asset path for a custom SVG icon (e.g., 'assets/icons/plus.svg').
  final String? svgPath;

  /// The Flutter asset path for a custom PNG/raster icon (e.g., 'assets/icons/plus.png').
  final String? assetPath;

  /// A Flutter [IconData] to render as the action button icon (e.g., [Icons.add]).
  final IconData? icon;

  /// The raw SVG XML string for the icon.
  final String? svgString;

  /// Raw image byte data (PNG format).
  final Uint8List? imageBytes;

  /// The SF Symbol name or iOS asset catalog name (e.g., 'plus').
  final String? symbol;

  /// The callback to be invoked when the action button is tapped.
  final VoidCallback onTap;

  /// Creates a new [TabBarActionButton].
  ///
  /// Provide at least one icon source: [svgPath], [assetPath], [icon], [svgString],
  /// [imageBytes], or [symbol].
  const TabBarActionButton({
    this.svgPath,
    this.assetPath,
    this.icon,
    this.svgString,
    this.imageBytes,
    this.symbol,
    required this.onTap,
  }) : assert(
         svgPath != null ||
             assetPath != null ||
             icon != null ||
             svgString != null ||
             imageBytes != null ||
             symbol != null,
         'Provide at least one icon source (svgPath, assetPath, icon, svgString, imageBytes, or symbol).',
       );
}

/// A widget that displays a native glass liquid navigation bar on iOS.
///
/// On non-iOS platforms or when the glass effect is not supported,
/// it can optionally display a [fallback] widget.
class NativeGlassNavBar extends StatefulWidget {
  /// The list of tabs to display in the navigation bar.
  ///
  /// If [actionButton] is provided, supports up to 4 tabs, else supports up to 5 tabs.
  final List<NativeGlassNavBarItem> tabs;

  /// An optional action button.
  ///
  /// If provided, the action button appears to the right of the tabs as a circular floating button.
  final TabBarActionButton? actionButton;

  /// The index of the currently selected tab.
  final int currentIndex;

  /// A callback that is called when a tab is tapped.
  final ValueChanged<int> onTap;

  /// The color to use for the selected tab icon and label.
  ///
  /// If null, defaults to the primary color of the current [Theme].
  final Color? tintColor;

  /// A widget to display when the native glass effect is not supported.
  final Widget? fallback;

  /// Creates a new [NativeGlassNavBar].
  const NativeGlassNavBar({
    super.key,
    required this.tabs,
    this.actionButton,
    required this.currentIndex,
    required this.onTap,
    this.tintColor,
    this.fallback,
  }) : assert(
         tabs.length <= (actionButton == null ? 5 : 4),
         actionButton == null
             ? 'NativeGlassNavBar supports a maximum of 5 tabs.'
             : 'NativeGlassNavBar with an action button supports a maximum of 4 tabs.',
       );

  @override
  State<NativeGlassNavBar> createState() => _NativeGlassNavBarState();
}

class _NativeGlassNavBarState extends State<NativeGlassNavBar> {
  MethodChannel? _channel;
  late Future<bool> _initFuture;
  List<Uint8List?> _tabImages = [];
  Uint8List? _actionButtonImage;

  Future<bool> _initialize() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return false;
    }

    final bool isSupported = await LiquidGlassHelper.isLiquidGlassSupported();
    if (isSupported) {
      await _loadImages();
    }
    return isSupported;
  }

  Future<void> _loadImages() async {
    final List<Uint8List?> tabImages = await Future.wait(
      widget.tabs.map(
        (tab) => GlassIconLoader.resolveImageBytes(
          svgPath: tab.svgPath,
          assetPath: tab.assetPath,
          icon: tab.icon,
          svgString: tab.svgString,
          imageBytes: tab.imageBytes,
        ),
      ),
    );

    Uint8List? actionImg;
    if (widget.actionButton != null) {
      actionImg = await GlassIconLoader.resolveImageBytes(
        svgPath: widget.actionButton!.svgPath,
        assetPath: widget.actionButton!.assetPath,
        icon: widget.actionButton!.icon,
        svgString: widget.actionButton!.svgString,
        imageBytes: widget.actionButton!.imageBytes,
      );
    }

    _tabImages = tabImages;
    _actionButtonImage = actionImg;
  }

  void _updateNativeView() {
    if (_channel != null) {
      _channel!.invokeMethod('update', _createParams());
    }
  }

  Map<String, dynamic> _createParams() {
    return {
      'labels': widget.tabs.map((e) => e.label).toList(),
      'symbols': widget.tabs.map((e) => e.symbol ?? '').toList(),
      'itemImages': _tabImages,
      'actionButtonSymbol': widget.actionButton?.symbol ?? '',
      'actionButtonImage': _actionButtonImage,
      'selectedIndex': widget.currentIndex,
      'isDark': Theme.of(context).brightness == Brightness.dark,
      'tintColor': widget.tintColor != null
          ? widget.tintColor!.toARGB32()
          : Theme.of(context).colorScheme.primary.toARGB32(),
    };
  }

  @override
  void initState() {
    super.initState();
    _initFuture = _initialize();
  }

  @override
  void didUpdateWidget(NativeGlassNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadImages().then((_) {
      if (mounted) {
        _updateNativeView();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        if (snapshot.data != true) {
          if (widget.fallback != null) {
            return widget.fallback!;
          }

          if (kDebugMode) {
            developer.log(
              'Liquid glass effect is not supported on this device. '
              'Falling back to an empty widget. Provide a `fallback` widget to handle this case.',
              name: 'NativeGlassNavBar',
              level: 900,
            );
          }
          return const SizedBox.shrink();
        }

        final bottomPadding = MediaQuery.of(context).padding.bottom;
        // Standard tab bar height is 49. Add bottom padding for safe area.
        final height = 49.0 + bottomPadding;

        return SizedBox(
          height: height,
          child: UiKitView(
            viewType: 'NativeTabBar',
            creationParams: _createParams(),
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: (id) {
              _channel = MethodChannel('NativeTabBar_$id');
              _channel!.setMethodCallHandler((call) async {
                if (call.method == 'valueChanged') {
                  final index = call.arguments['index'] as int;
                  widget.onTap(index);
                }

                if (call.method == 'actionButtonPressed') {
                  widget.actionButton?.onTap();
                }
              });
            },
          ),
        );
      },
    );
  }
}
