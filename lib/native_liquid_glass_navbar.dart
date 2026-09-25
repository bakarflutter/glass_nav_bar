/// A Flutter plugin providing a native iOS Liquid Glass navigation bar with custom Flutter widget, IconData, and SF Symbol support.
library;

export 'liquid_glass_helper.dart';
export 'src/icon_rasterizer.dart';

import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_liquid_glass_navbar/liquid_glass_helper.dart';
import 'package:native_liquid_glass_navbar/src/icon_rasterizer.dart';

/// Represents a tab item in the [NativeLiquidGlassNavBar].
class NativeLiquidGlassNavBarItem {
  /// The label text to display for the tab.
  final String label;

  /// A custom Flutter [Widget] to render as the tab icon (e.g., [Image.asset], `SvgPicture.asset`, custom badge, etc.).
  final Widget? iconWidget;

  /// An optional custom Flutter [Widget] to render when this tab is currently selected.
  final Widget? selectedIconWidget;

  /// A Flutter [IconData] to render as the tab icon (e.g., [Icons.home]).
  final IconData? icon;

  /// The SF Symbol name or iOS asset catalog name (e.g., 'house.fill', 'gearshape.fill').
  final String? symbol;

  /// Raw image byte data (PNG format).
  final Uint8List? imageBytes;

  /// Optional custom icon size for this tab (defaults to navbar's [iconSize] or 24.0).
  final double? iconSize;

  /// Creates a new [NativeLiquidGlassNavBarItem].
  ///
  /// Provide at least one icon source: [iconWidget], [icon], [symbol], or [imageBytes].
  const NativeLiquidGlassNavBarItem({
    required this.label,
    this.iconWidget,
    this.selectedIconWidget,
    this.icon,
    this.symbol,
    this.imageBytes,
    this.iconSize,
  }) : assert(
         iconWidget != null ||
             icon != null ||
             symbol != null ||
             imageBytes != null,
         'Provide at least one icon source: iconWidget, icon, symbol, or imageBytes.',
       );

  /// Creates a tab item with a custom Flutter widget (e.g., [Image.asset], `SvgPicture.asset`, badges).
  const NativeLiquidGlassNavBarItem.widget({
    required this.label,
    required Widget this.iconWidget,
    this.selectedIconWidget,
    this.symbol,
    this.imageBytes,
    this.iconSize,
  })  : icon = null;

  /// Creates a tab item with a Flutter [IconData].
  const NativeLiquidGlassNavBarItem.icon({
    required this.label,
    required IconData this.icon,
    this.symbol,
    this.iconSize,
  })  : iconWidget = null,
        selectedIconWidget = null,
        imageBytes = null;

  /// Creates a tab item with an Apple SF Symbol name (e.g., 'house.fill').
  const NativeLiquidGlassNavBarItem.symbol({
    required this.label,
    required String this.symbol,
    this.iconSize,
  })  : iconWidget = null,
        selectedIconWidget = null,
        icon = null,
        imageBytes = null;
}

/// Backwards compatibility alias for [NativeLiquidGlassNavBarItem].
typedef LiquidGlassNavBarItem = NativeLiquidGlassNavBarItem;

/// Backwards compatibility alias for [NativeLiquidGlassNavBarItem].
typedef NativeGlassNavBarItem = NativeLiquidGlassNavBarItem;

/// Represents an action button in the [NativeLiquidGlassNavBar].
///
/// It appears to the right of the tab as a circular floating button.
class NativeLiquidGlassActionButton {
  /// A custom Flutter [Widget] to render as the action button icon (e.g., [Image.asset], `SvgPicture.asset`, [Icon], etc.).
  final Widget? iconWidget;

  /// A Flutter [IconData] to render as the action button icon (e.g., [Icons.add]).
  final IconData? icon;

  /// The SF Symbol name or iOS asset catalog name (e.g., 'plus').
  final String? symbol;

  /// Raw image byte data (PNG format).
  final Uint8List? imageBytes;

  /// Optional custom icon size for this action button.
  final double? iconSize;

  /// The callback to be invoked when the action button is tapped.
  final VoidCallback onTap;

  /// Creates a new [NativeLiquidGlassActionButton].
  ///
  /// Provide at least one icon source: [iconWidget], [icon], [symbol], or [imageBytes].
  const NativeLiquidGlassActionButton({
    this.iconWidget,
    this.icon,
    this.symbol,
    this.imageBytes,
    this.iconSize,
    required this.onTap,
  }) : assert(
         iconWidget != null ||
             icon != null ||
             symbol != null ||
             imageBytes != null,
         'Provide at least one icon source: iconWidget, icon, symbol, or imageBytes.',
       );

  /// Creates an action button with a custom Flutter widget.
  const NativeLiquidGlassActionButton.widget({
    required Widget this.iconWidget,
    this.symbol,
    this.imageBytes,
    this.iconSize,
    required this.onTap,
  })  : icon = null;

  /// Creates an action button with a Flutter [IconData].
  const NativeLiquidGlassActionButton.icon({
    required IconData this.icon,
    this.symbol,
    this.iconSize,
    required this.onTap,
  })  : iconWidget = null,
        imageBytes = null;

  /// Creates an action button with an Apple SF Symbol.
  const NativeLiquidGlassActionButton.symbol({
    required String this.symbol,
    this.iconSize,
    required this.onTap,
  })  : iconWidget = null,
        icon = null,
        imageBytes = null;
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
  State<NativeLiquidGlassNavBar> createState() =>
      _NativeLiquidGlassNavBarState();
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
          icon: tab.icon,
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
        icon: widget.actionButton!.icon,
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

  static IconData _iconDataForSymbol(String? symbol) {
    if (symbol == null || symbol.isEmpty) return Icons.circle;
    final clean = symbol
        .toLowerCase()
        .replaceAll('.fill', '')
        .replaceAll('.circle', '')
        .replaceAll('.slash', '');
    switch (clean) {
      case 'house':
      case 'home':
        return Icons.home_rounded;
      case 'magnifyingglass':
      case 'search':
        return Icons.search_rounded;
      case 'heart':
      case 'love':
      case 'favorite':
        return Icons.favorite_rounded;
      case 'gearshape':
      case 'gear':
      case 'settings':
      case 'gearshape.2':
        return Icons.tune_rounded;
      case 'plus':
      case 'add':
        return Icons.add_rounded;
      case 'person':
      case 'person.crop.circle':
      case 'user':
      case 'profile':
        return Icons.person_rounded;
      case 'bell':
      case 'notification':
        return Icons.notifications_rounded;
      case 'star':
        return Icons.star_rounded;
      case 'bookmark':
        return Icons.bookmark_rounded;
      case 'folder':
        return Icons.folder_rounded;
      case 'trash':
      case 'bin':
        return Icons.delete_rounded;
      case 'cart':
      case 'bag':
        return Icons.shopping_bag_rounded;
      case 'envelope':
      case 'mail':
        return Icons.mail_rounded;
      case 'message':
      case 'bubble.left':
      case 'chat':
        return Icons.chat_bubble_rounded;
      case 'camera':
        return Icons.camera_alt_rounded;
      case 'photo':
      case 'photo.on.rectangle':
      case 'image':
        return Icons.image_rounded;
      case 'music.note':
      case 'music':
        return Icons.music_note_rounded;
      case 'play':
        return Icons.play_arrow_rounded;
      case 'pause':
        return Icons.pause_rounded;
      case 'square.and.arrow.up':
      case 'share':
        return Icons.share_rounded;
      case 'clock':
      case 'timer':
        return Icons.access_time_rounded;
      case 'calendar':
        return Icons.calendar_month_rounded;
      case 'map':
      case 'location':
      case 'mappin':
        return Icons.location_on_rounded;
      case 'lock':
        return Icons.lock_rounded;
      case 'shield':
        return Icons.shield_rounded;
      case 'info':
        return Icons.info_rounded;
      case 'checkmark':
        return Icons.check_rounded;
      case 'xmark':
      case 'multiply':
        return Icons.close_rounded;
      default:
        return Icons.widgets_rounded;
    }
  }

  Widget _buildTabIconWidget({
    required NativeLiquidGlassNavBarItem tab,
    required bool isSelected,
    required Color color,
    required double size,
  }) {
    final Widget content;
    if (isSelected && tab.selectedIconWidget != null) {
      content = tab.selectedIconWidget!;
    } else if (tab.iconWidget != null) {
      content = tab.iconWidget!;
    } else if (tab.icon != null) {
      content = Icon(tab.icon, size: size, color: color);
    } else if (tab.imageBytes != null) {
      content = Image.memory(tab.imageBytes!, width: size, height: size);
    } else if (tab.symbol != null && tab.symbol!.isNotEmpty) {
      content = Icon(_iconDataForSymbol(tab.symbol), size: size, color: color);
    } else {
      content = Icon(Icons.widgets_rounded, size: size, color: color);
    }

    return IconTheme(
      data: IconThemeData(color: color, size: size),
      child: DefaultTextStyle(
        style: TextStyle(color: color, fontSize: size),
        child: SizedBox(
          width: size,
          height: size,
          child: Center(child: content),
        ),
      ),
    );
  }

  Widget _buildActionIconWidget({
    required NativeLiquidGlassActionButton actionButton,
    required Color color,
    required double size,
  }) {
    final Widget content;
    if (actionButton.iconWidget != null) {
      content = actionButton.iconWidget!;
    } else if (actionButton.icon != null) {
      content = Icon(actionButton.icon, size: size, color: color);
    } else if (actionButton.imageBytes != null) {
      content = Image.memory(actionButton.imageBytes!, width: size, height: size);
    } else if (actionButton.symbol != null && actionButton.symbol!.isNotEmpty) {
      content = Icon(
        _iconDataForSymbol(actionButton.symbol),
        size: size,
        color: color,
      );
    } else {
      content = Icon(Icons.add_rounded, size: size, color: color);
    }

    return IconTheme(
      data: IconThemeData(color: color, size: size),
      child: DefaultTextStyle(
        style: TextStyle(color: color, fontSize: size),
        child: SizedBox(
          width: size,
          height: size,
          child: Center(child: content),
        ),
      ),
    );
  }

  Widget _buildDefaultFallback(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color selectedColor = widget.tintColor ?? theme.colorScheme.primary;
    final Color unselectedColor =
        widget.unselectedColor ??
        (isDark ? const Color(0xFF8E8E93) : const Color(0xFF8E8E93));
    final double defaultIconSize = widget.iconSize ?? 26.0;
    final double defaultFontSize = widget.fontSize ?? 12.0;

    final int totalTabs = widget.tabs.length;
    final int safeIndex = widget.currentIndex.clamp(0, totalTabs - 1);
    final int totalSlots =
        widget.tabs.length + (widget.actionButton != null ? 1 : 0);
    final double alignmentX = totalSlots <= 1
        ? 0.0
        : -1.0 + (safeIndex / (totalSlots - 1)) * 2.0;

    final double bottomInset = MediaQuery.of(context).padding.bottom;
    final bool isPad = MediaQuery.of(context).size.shortestSide >= 600;
    final double bottomMargin = isPad
        ? (bottomInset > 0 ? 24.0 : 32.0)
        : (bottomInset > 0 ? 6.0 : 16.0);

    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, bottomMargin),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: selectedColor.withValues(alpha: isDark ? 0.15 : 0.05),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF1C1C1E).withValues(alpha: 0.85),
                          const Color(0xFF141416).withValues(alpha: 0.7),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.78),
                          Colors.white.withValues(alpha: 0.45),
                        ],
                ),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.25)
                      : Colors.white.withValues(alpha: 0.85),
                  width: 1.2,
                ),
              ),
              child: Stack(
                children: [
                  // Animated sliding indicator pill
                  Positioned.fill(
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.fastEaseInToSlowEaseOut,
                      alignment: Alignment(alignmentX, 0.0),
                      child: FractionallySizedBox(
                        widthFactor: 1.0 / totalSlots,
                        heightFactor: 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2C2C2E)
                                : Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(35),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : Colors.white.withValues(alpha: 0.8),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: isDark ? 0.2 : 0.04,
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      ...widget.tabs.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final NativeLiquidGlassNavBarItem tab = entry.value;
                        final bool isSelected = safeIndex == index;
                        final double tabIconSize =
                            tab.iconSize ?? defaultIconSize;

                        return Expanded(
                          child: GestureDetector(
                            onTap: () => widget.onTap(index),
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              color: Colors.transparent,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildTabIconWidget(
                                    tab: tab,
                                    isSelected: isSelected,
                                    color: isSelected
                                        ? selectedColor
                                        : unselectedColor,
                                    size: tabIconSize,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tab.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: defaultFontSize,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: isDark
                                          ? (isSelected
                                                ? Colors.white
                                                : const Color(0xFF8E8E93))
                                          : (isSelected
                                                ? const Color(0xFF111827)
                                                : const Color(0xFF3C3C43)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      if (widget.actionButton != null)
                        Expanded(
                          child: GestureDetector(
                            onTap: widget.actionButton!.onTap,
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              color: Colors.transparent,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: selectedColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: selectedColor.withValues(
                                            alpha: 0.4,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: _buildActionIconWidget(
                                      actionButton: widget.actionButton!,
                                      color: Colors.white,
                                      size:
                                          widget.actionButton!.iconSize ?? 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic>? modalRoute = ModalRoute.of(context);
    final Animation<double>? secondaryAnimation = modalRoute?.secondaryAnimation;

    Widget content = FutureBuilder<bool>(
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

        final bool isPad = MediaQuery.of(context).size.shortestSide >= 600;
        final bottomPadding = MediaQuery.of(context).padding.bottom;
        final extraPadBottom = isPad ? (bottomPadding > 0 ? 12.0 : 18.0) : 0.0;
        final height = 49.0 + bottomPadding + extraPadBottom;

        return SizedBox(
          height: height,
          child: UiKitView(
            viewType: 'NativeTabBar',
            creationParams: _createParams(),
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: (id) {
              _channel = MethodChannel('NativeTabBar_$id');
              final bool isCurrent = modalRoute?.isCurrent ?? true;
              _channel!
                  .invokeMethod('setVisibility', {'visible': isCurrent})
                  .catchError((_) {});
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

    if (secondaryAnimation != null) {
      return AnimatedBuilder(
        animation: secondaryAnimation,
        builder: (context, child) {
          final bool isCurrent = modalRoute?.isCurrent ?? true;
          if (_channel != null) {
            _channel!
                .invokeMethod('setVisibility', {'visible': isCurrent})
                .catchError((_) {});
          }
          return Visibility(
            visible: isCurrent,
            maintainState: true,
            maintainAnimation: true,
            maintainSize: false,
            child: IgnorePointer(
              ignoring: !isCurrent,
              child: child,
            ),
          );
        },
        child: content,
      );
    }

    final bool isCurrent = modalRoute?.isCurrent ?? true;
    return Visibility(
      visible: isCurrent,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: false,
      child: IgnorePointer(
        ignoring: !isCurrent,
        child: content,
      ),
    );
  }
}
