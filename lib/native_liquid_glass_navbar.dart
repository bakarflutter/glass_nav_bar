/// A Flutter plugin that provides a native liquid glass navigation bar for iOS with custom SVG, PNG, and icon support.
library;

export 'liquid_glass_helper.dart';
export 'src/icon_rasterizer.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:native_liquid_glass_navbar/liquid_glass_helper.dart';
import 'package:native_liquid_glass_navbar/src/icon_rasterizer.dart';

/// Represents a tab item in the [NativeLiquidGlassNavBar].
class NativeLiquidGlassNavBarItem {
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

  /// Optional custom icon size for this tab (defaults to navbar's [iconSize] or 24.0).
  final double? iconSize;

  /// Creates a new [NativeLiquidGlassNavBarItem].
  ///
  /// Provide at least one icon source: [svgPath], [assetPath], [icon], [svgString],
  /// [imageBytes], or [symbol].
  const NativeLiquidGlassNavBarItem({
    required this.label,
    this.svgPath,
    this.assetPath,
    this.icon,
    this.svgString,
    this.imageBytes,
    this.symbol,
    this.iconSize,
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

/// Backwards compatibility alias for [NativeLiquidGlassNavBarItem].
typedef LiquidGlassNavBarItem = NativeLiquidGlassNavBarItem;

/// Backwards compatibility alias for [NativeLiquidGlassNavBarItem].
typedef NativeGlassNavBarItem = NativeLiquidGlassNavBarItem;

/// Represents an action button in the [NativeLiquidGlassNavBar].
///
/// It appears to the right of the tab as a circular floating button.
class NativeLiquidGlassActionButton {
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

  /// Optional custom icon size for this action button.
  final double? iconSize;

  /// The callback to be invoked when the action button is tapped.
  final VoidCallback onTap;

  /// Creates a new [NativeLiquidGlassActionButton].
  ///
  /// Provide at least one icon source: [svgPath], [assetPath], [icon], [svgString],
  /// [imageBytes], or [symbol].
  const NativeLiquidGlassActionButton({
    this.svgPath,
    this.assetPath,
    this.icon,
    this.svgString,
    this.imageBytes,
    this.symbol,
    this.iconSize,
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

/// Backwards compatibility alias for [NativeLiquidGlassActionButton].
typedef LiquidGlassActionButton = NativeLiquidGlassActionButton;

/// Backwards compatibility alias for [NativeLiquidGlassActionButton].
typedef TabBarActionButton = NativeLiquidGlassActionButton;

/// A widget that displays a native glass liquid navigation bar on iOS.
///
/// On non-iOS platforms or when the glass effect is not supported,
/// it displays a custom [fallback] widget or an automatic built-in navigation fallback.
class NativeLiquidGlassNavBar extends StatefulWidget {
  /// The list of tabs to display in the navigation bar.
  ///
  /// If [actionButton] is provided, supports up to 4 tabs, else supports up to 5 tabs.
  final List<NativeLiquidGlassNavBarItem> tabs;

  /// An optional action button.
  ///
  /// If provided, the action button appears to the right of the tabs as a circular floating button.
  final NativeLiquidGlassActionButton? actionButton;

  /// The index of the currently selected tab.
  final int currentIndex;

  /// A callback that is called when a tab is tapped.
  final ValueChanged<int> onTap;

  /// The color to use for the selected tab icon and label.
  ///
  /// If null, defaults to the primary color of the current [Theme].
  final Color? tintColor;

  /// The color to use for unselected tab icons and labels.
  ///
  /// If null, defaults to iOS system gray.
  final Color? unselectedColor;

  /// Custom icon size in points (default: 24.0).
  final double? iconSize;

  /// Custom label font size in points (default: 10.0).
  final double? fontSize;

  /// An optional widget to display when the native iOS glass effect is not supported.
  /// If null, a built-in cross-platform navigation bar will be rendered automatically.
  final Widget? fallback;

  /// Creates a new [NativeLiquidGlassNavBar].
  const NativeLiquidGlassNavBar({
    super.key,
    required this.tabs,
    this.actionButton,
    required this.currentIndex,
    required this.onTap,
    this.tintColor,
    this.unselectedColor,
    this.iconSize,
    this.fontSize,
    this.fallback,
  }) : assert(
         tabs.length <= (actionButton == null ? 5 : 4),
         actionButton == null
             ? 'NativeLiquidGlassNavBar supports a maximum of 5 tabs.'
             : 'NativeLiquidGlassNavBar with an action button supports a maximum of 4 tabs.',
       );

  @override
  State<NativeLiquidGlassNavBar> createState() => _NativeLiquidGlassNavBarState();
}

/// Backwards compatibility alias for [NativeLiquidGlassNavBar].
typedef LiquidGlassNavBar = NativeLiquidGlassNavBar;

/// Backwards compatibility alias for [NativeLiquidGlassNavBar].
typedef NativeGlassNavBar = NativeLiquidGlassNavBar;

class _NativeLiquidGlassNavBarState extends State<NativeLiquidGlassNavBar> {
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
    final double defaultSize = widget.iconSize ?? 26.0;

    final List<Uint8List?> tabImages = await Future.wait(
      widget.tabs.map(
        (tab) => GlassIconLoader.resolveImageBytes(
          svgPath: tab.svgPath,
          assetPath: tab.assetPath,
          icon: tab.icon,
          svgString: tab.svgString,
          imageBytes: tab.imageBytes,
          targetWidth: tab.iconSize ?? defaultSize,
          targetHeight: tab.iconSize ?? defaultSize,
        ),
      ),
    );

    Uint8List? actionImg;
    if (widget.actionButton != null) {
      final double actionSize = widget.actionButton!.iconSize ?? defaultSize;
      actionImg = await GlassIconLoader.resolveImageBytes(
        svgPath: widget.actionButton!.svgPath,
        assetPath: widget.actionButton!.assetPath,
        icon: widget.actionButton!.icon,
        svgString: widget.actionButton!.svgString,
        imageBytes: widget.actionButton!.imageBytes,
        targetWidth: actionSize,
        targetHeight: actionSize,
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
      'unselectedColor': widget.unselectedColor?.toARGB32(),
      'iconSize': widget.iconSize ?? 26.0,
      'fontSize': widget.fontSize ?? 10.0,
    };
  }

  @override
  void initState() {
    super.initState();
    _initFuture = _initialize();
  }

  @override
  void didUpdateWidget(NativeLiquidGlassNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadImages().then((_) {
      if (mounted) {
        _updateNativeView();
      }
    });
  }

  Widget _buildDefaultFallback(BuildContext context) {
    final Color selectedColor =
        widget.tintColor ?? Theme.of(context).colorScheme.primary;
    final Color unselectedColor =
        widget.unselectedColor ?? Theme.of(context).colorScheme.onSurfaceVariant;
    final double iconSize = widget.iconSize ?? 24.0;

    return NavigationBar(
      selectedIndex: widget.currentIndex.clamp(0, widget.tabs.length - 1),
      onDestinationSelected: widget.onTap,
      indicatorColor: selectedColor.withValues(alpha: 0.15),
      destinations: widget.tabs.map((tab) {
        final double tabSize = tab.iconSize ?? iconSize;

        Widget buildIcon(Color color) {
          if (tab.icon != null) {
            return Icon(tab.icon, size: tabSize, color: color);
          } else if (tab.svgPath != null) {
            return SvgPicture.asset(
              tab.svgPath!,
              width: tabSize,
              height: tabSize,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            );
          } else if (tab.svgString != null) {
            return SvgPicture.string(
              tab.svgString!,
              width: tabSize,
              height: tabSize,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            );
          } else if (tab.assetPath != null) {
            return Image.asset(tab.assetPath!, width: tabSize, height: tabSize);
          } else if (tab.imageBytes != null) {
            return Image.memory(tab.imageBytes!, width: tabSize, height: tabSize);
          } else {
            return Icon(Icons.circle, size: tabSize * 0.7, color: color);
          }
        }

        return NavigationDestination(
          icon: buildIcon(unselectedColor),
          selectedIcon: buildIcon(selectedColor),
          label: tab.label,
        );
      }).toList(),
    );
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
          return _buildDefaultFallback(context);
        }

        final bottomPadding = MediaQuery.of(context).padding.bottom;
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
