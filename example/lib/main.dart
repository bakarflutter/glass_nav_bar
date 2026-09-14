import 'package:flutter/material.dart';
import 'package:native_liquid_glass_navbar/native_liquid_glass_navbar.dart';

void main() {
  runApp(const LiquidGlassApp());
}

enum BackgroundStyle { vibrantMesh, auroraGlow, minimalSolid }

enum IconSourceMode { svgs, pngs, iconData, symbols }

class LiquidGlassApp extends StatefulWidget {
  const LiquidGlassApp({super.key});

  @override
  State<LiquidGlassApp> createState() => _LiquidGlassAppState();
}

class _LiquidGlassAppState extends State<LiquidGlassApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Color _tintColor = const Color(0xFF0A84FF); // Apple Blue
  Color _unselectedColor = const Color(0xFF8E8E93); // Apple System Gray
  double _iconSize = 26.0;
  double _fontSize = 10.0;
  BackgroundStyle _backgroundStyle = BackgroundStyle.vibrantMesh;
  IconSourceMode _iconSourceMode = IconSourceMode.svgs;

  void _updateThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  void _updateTintColor(Color color) {
    setState(() => _tintColor = color);
  }

  void _updateUnselectedColor(Color color) {
    setState(() => _unselectedColor = color);
  }

  void _updateIconSize(double size) {
    setState(() => _iconSize = size);
  }

  void _updateFontSize(double size) {
    setState(() => _fontSize = size);
  }

  void _updateBackgroundStyle(BackgroundStyle style) {
    setState(() => _backgroundStyle = style);
  }

  void _updateIconSourceMode(IconSourceMode mode) {
    setState(() => _iconSourceMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Native Liquid Glass Navbar',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _tintColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.transparent,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _tintColor,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: RootNavigationScreen(
        themeMode: _themeMode,
        tintColor: _tintColor,
        unselectedColor: _unselectedColor,
        iconSize: _iconSize,
        fontSize: _fontSize,
        backgroundStyle: _backgroundStyle,
        iconSourceMode: _iconSourceMode,
        onThemeChanged: _updateThemeMode,
        onTintChanged: _updateTintColor,
        onUnselectedColorChanged: _updateUnselectedColor,
        onIconSizeChanged: _updateIconSize,
        onFontSizeChanged: _updateFontSize,
        onBackgroundChanged: _updateBackgroundStyle,
        onIconSourceChanged: _updateIconSourceMode,
      ),
    );
  }
}

class RootNavigationScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final Color tintColor;
  final Color unselectedColor;
  final double iconSize;
  final double fontSize;
  final BackgroundStyle backgroundStyle;
  final IconSourceMode iconSourceMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final ValueChanged<Color> onTintChanged;
  final ValueChanged<Color> onUnselectedColorChanged;
  final ValueChanged<double> onIconSizeChanged;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<BackgroundStyle> onBackgroundChanged;
  final ValueChanged<IconSourceMode> onIconSourceChanged;

  const RootNavigationScreen({
    super.key,
    required this.themeMode,
    required this.tintColor,
    required this.unselectedColor,
    required this.iconSize,
    required this.fontSize,
    required this.backgroundStyle,
    required this.iconSourceMode,
    required this.onThemeChanged,
    required this.onTintChanged,
    required this.onUnselectedColorChanged,
    required this.onIconSizeChanged,
    required this.onFontSizeChanged,
    required this.onBackgroundChanged,
    required this.onIconSourceChanged,
  });

  @override
  State<RootNavigationScreen> createState() => _RootNavigationScreenState();
}

class _RootNavigationScreenState extends State<RootNavigationScreen> {
  int _currentIndex = 0;

  void _openCreateModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Quick Action Modal',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Triggered by the floating Action Button (plus.svg)',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: widget.tintColor.withValues(alpha: 0.15),
                  child: Icon(
                    Icons.add_photo_alternate_rounded,
                    color: widget.tintColor,
                  ),
                ),
                title: const Text('Upload Vector SVG'),
                subtitle: const Text('Add SVG icons dynamically to navigation'),
                onTap: () => Navigator.pop(ctx),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: widget.tintColor.withValues(alpha: 0.15),
                  child: Icon(Icons.palette_rounded, color: widget.tintColor),
                ),
                title: const Text('Change Glass Theme'),
                subtitle: const Text(
                  'Toggle blur effects and liquid glass styling',
                ),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      },
    );
  }

  List<NativeLiquidGlassNavBarItem> _buildTabs() {
    switch (widget.iconSourceMode) {
      case IconSourceMode.svgs:
        // Default SVG Icons
        return const [
          NativeLiquidGlassNavBarItem(
            label: 'Home',
            svgPath: 'assets/icons/home.svg',
          ),
          NativeLiquidGlassNavBarItem(
            label: 'Search',
            svgPath: 'assets/icons/search.svg',
          ),
          NativeLiquidGlassNavBarItem(
            label: 'Saved',
            svgPath: 'assets/icons/heart.svg',
          ),
          NativeLiquidGlassNavBarItem(
            label: 'Settings',
            svgPath: 'assets/icons/settings.svg',
          ),
        ];
      case IconSourceMode.pngs:
        // Bundled PNG Image Assets
        return const [
          NativeLiquidGlassNavBarItem(
            label: 'Home',
            assetPath: 'assets/icons/home.png',
          ),
          NativeLiquidGlassNavBarItem(
            label: 'Search',
            assetPath: 'assets/icons/search.png',
          ),
          NativeLiquidGlassNavBarItem(
            label: 'Saved',
            assetPath: 'assets/icons/heart.png',
          ),
          NativeLiquidGlassNavBarItem(
            label: 'Settings',
            assetPath: 'assets/icons/settings.png',
          ),
        ];
      case IconSourceMode.iconData:
        return const [
          NativeLiquidGlassNavBarItem(label: 'Home', icon: Icons.home_rounded),
          NativeLiquidGlassNavBarItem(
            label: 'Search',
            icon: Icons.search_rounded,
          ),
          NativeLiquidGlassNavBarItem(
            label: 'Saved',
            icon: Icons.favorite_rounded,
          ),
          NativeLiquidGlassNavBarItem(
            label: 'Settings',
            icon: Icons.tune_rounded,
          ),
        ];
      case IconSourceMode.symbols:
        return const [
          NativeLiquidGlassNavBarItem(label: 'Home', symbol: 'house.fill'),
          NativeLiquidGlassNavBarItem(
            label: 'Search',
            symbol: 'magnifyingglass',
          ),
          NativeLiquidGlassNavBarItem(label: 'Saved', symbol: 'heart.fill'),
          NativeLiquidGlassNavBarItem(
            label: 'Settings',
            symbol: 'gearshape.fill',
          ),
        ];
    }
  }

  NativeLiquidGlassActionButton _buildActionButton() {
    switch (widget.iconSourceMode) {
      case IconSourceMode.svgs:
        return NativeLiquidGlassActionButton(
          svgPath: 'assets/icons/plus.svg',
          onTap: _openCreateModal,
        );
      case IconSourceMode.pngs:
        return NativeLiquidGlassActionButton(
          assetPath: 'assets/icons/plus.png',
          onTap: _openCreateModal,
        );
      case IconSourceMode.iconData:
        return NativeLiquidGlassActionButton(
          icon: Icons.add_rounded,
          onTap: _openCreateModal,
        );
      case IconSourceMode.symbols:
        return NativeLiquidGlassActionButton(
          symbol: 'plus',
          onTap: _openCreateModal,
        );
    }
  }

  Widget _buildBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (widget.backgroundStyle) {
      case BackgroundStyle.vibrantMesh:
        return Stack(
          children: [
            Container(
              color: isDark ? const Color(0xFF090D16) : const Color(0xFFF1F4F9),
            ),
            // Glowing vibrant gradient blobs for glass blur showcase
            Positioned(
              top: -80,
              right: -60,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      widget.tintColor.withValues(alpha: isDark ? 0.35 : 0.25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left: -40,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(
                        0xFFFF2D55,
                      ).withValues(alpha: isDark ? 0.35 : 0.25),
                      const Color(
                        0xFFAF52DE,
                      ).withValues(alpha: isDark ? 0.25 : 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              right: -20,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(
                        0xFF34C759,
                      ).withValues(alpha: isDark ? 0.30 : 0.20),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      case BackgroundStyle.auroraGlow:
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [
                      Color(0xFF0F172A),
                      Color(0xFF1E1B4B),
                      Color(0xFF311042),
                    ]
                  : const [
                      Color(0xFFEFF6FF),
                      Color(0xFFFDF4FF),
                      Color(0xFFFFF1F2),
                    ],
            ),
          ),
        );
      case BackgroundStyle.minimalSolid:
        return Container(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBackground(context),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBody:
              true, // Extends background content right behind liquid glass blur
          body: IndexedStack(
            index: _currentIndex,
            children: [
              _buildFeedTab(),
              _buildSearchTab(),
              _buildSavedTab(),
              _buildSettingsTab(),
            ],
          ),
          bottomNavigationBar: NativeLiquidGlassNavBar(
            currentIndex: _currentIndex,
            tintColor: widget.tintColor,
            unselectedColor: widget.unselectedColor,
            iconSize: widget.iconSize,
            fontSize: widget.fontSize,
            onTap: (index) => setState(() => _currentIndex = index),
            actionButton: _buildActionButton(),
            tabs: _buildTabs(),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedTab() {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: const Text('Glass Explorer'),
          centerTitle: false,
          actions: [
            IconButton(
              tooltip: 'Toggle Glass Wallpaper Background',
              icon: Icon(
                widget.backgroundStyle == BackgroundStyle.vibrantMesh
                    ? Icons.blur_on_rounded
                    : Icons.blur_circular_rounded,
                color: widget.tintColor,
              ),
              onPressed: () {
                final next =
                    widget.backgroundStyle == BackgroundStyle.vibrantMesh
                    ? BackgroundStyle.minimalSolid
                    : BackgroundStyle.vibrantMesh;
                widget.onBackgroundChanged(next);
              },
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildHighlightCard(
                title: 'All-SVG Liquid Glass Bar',
                subtitle:
                    'Every tab uses vector SVGs rendered at native retina sharpness with live liquid blur.',
                icon: Icons.auto_awesome_rounded,
              ),
              const SizedBox(height: 16),
              _buildBackgroundToggleCard(),
              const SizedBox(height: 16),
              _buildMetricGrid(),
              const SizedBox(height: 16),
              const Text(
                'Active Navigation Tabs (SVGs)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildActivityItem(
                'Tab 1: assets/icons/home.svg (Home)',
                Icons.home_rounded,
              ),
              _buildActivityItem(
                'Tab 2: assets/icons/search.svg (Search)',
                Icons.search_rounded,
              ),
              _buildActivityItem(
                'Tab 3: assets/icons/heart.svg (Saved)',
                Icons.favorite_rounded,
              ),
              _buildActivityItem(
                'Tab 4: assets/icons/settings.svg (Settings)',
                Icons.settings_rounded,
              ),
              _buildActivityItem(
                'Action: assets/icons/plus.svg (Quick Action)',
                Icons.add_circle_rounded,
              ),
              const SizedBox(height: 16),
              _buildGlassShowcaseCard(),
              const SizedBox(height: 120),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundToggleCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B).withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.tintColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wallpaper_rounded, color: widget.tintColor),
              const SizedBox(width: 8),
              const Text(
                'Glass Background Effect',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Switch background styles to see the native liquid glass blur react dynamically.',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          SegmentedButton<BackgroundStyle>(
            segments: const [
              ButtonSegment(
                value: BackgroundStyle.vibrantMesh,
                label: Text('Mesh Glass'),
                icon: Icon(Icons.blur_on),
              ),
              ButtonSegment(
                value: BackgroundStyle.auroraGlow,
                label: Text('Aurora'),
                icon: Icon(Icons.gradient),
              ),
              ButtonSegment(
                value: BackgroundStyle.minimalSolid,
                label: Text('Solid'),
                icon: Icon(Icons.check_box_outline_blank),
              ),
            ],
            selected: {widget.backgroundStyle},
            onSelectionChanged: (set) => widget.onBackgroundChanged(set.first),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: const Text('Search & Explore'),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              SearchBar(
                hintText: 'Search SVGs, components, or styles...',
                leading: const Icon(Icons.search),
                elevation: const WidgetStatePropertyAll(0),
                backgroundColor: WidgetStatePropertyAll(
                  isDark
                      ? const Color(0xFF1E293B).withValues(alpha: 0.8)
                      : Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    avatar: const Icon(Icons.image, size: 16),
                    label: const Text('Vector SVGs (Default)'),
                  ),
                  Chip(
                    avatar: const Icon(Icons.format_size, size: 16),
                    label: Text('Icon Size: ${widget.iconSize.toInt()}pt'),
                  ),
                  Chip(
                    avatar: const Icon(Icons.text_fields, size: 16),
                    label: Text('Font Size: ${widget.fontSize.toInt()}pt'),
                  ),
                  Chip(
                    avatar: const Icon(Icons.blur_linear, size: 16),
                    label: const Text('Native iOS Blur'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildHighlightCard(
                title: 'Vector Scaling Engine',
                subtitle:
                    'SVGs are parsed with FlutterSvg and converted into ultra-crisp resolution buffers for the native tab bar.',
                icon: Icons.layers_rounded,
              ),
              const SizedBox(height: 120),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSavedTab() {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: const Text('Saved & Favorites'),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildHighlightCard(
                title: 'Retina SVG Vector Support',
                subtitle:
                    'Clean vector rendering with seamless dark & light mode tinting.',
                icon: Icons.favorite_rounded,
              ),
              const SizedBox(height: 16),
              _buildGlassShowcaseCard(),
              const SizedBox(height: 120),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final tintColorOptions = [
      const Color(0xFF0A84FF), // Apple Blue
      const Color(0xFF5E5CE6), // Indigo
      const Color(0xFF30D158), // Emerald Green
      const Color(0xFFFF375F), // Pink / Rose
      const Color(0xFFFF9F0A), // Sunset Orange
      const Color(0xFFBF5AF2), // Electric Purple
      const Color(0xFF64D2FF), // Cyan / Sky
      const Color(0xFFFF453A), // Coral Red
    ];

    final unselectedColorOptions = [
      const Color(0xFF8E8E93), // Apple System Gray
      const Color(0xFF64748B), // Slate
      const Color(0xFF94A3B8), // Light Slate
      const Color(0xFF475569), // Dark Charcoal
      const Color(0xFFA1A1AA), // Zinc Gray
    ];

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: const Text('Preferences'),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Card(
                elevation: 0,
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.85)
                    : Colors.white.withValues(alpha: 0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon Mode Selection
                      const Text(
                        'Icon Source Mode',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<IconSourceMode>(
                        segments: const [
                          ButtonSegment(
                            value: IconSourceMode.svgs,
                            label: Text('SVGs'),
                            icon: Icon(Icons.brush_rounded),
                          ),
                          ButtonSegment(
                            value: IconSourceMode.pngs,
                            label: Text('PNGs'),
                            icon: Icon(Icons.image_rounded),
                          ),
                          ButtonSegment(
                            value: IconSourceMode.iconData,
                            label: Text('Icons'),
                            icon: Icon(Icons.widgets_rounded),
                          ),
                          ButtonSegment(
                            value: IconSourceMode.symbols,
                            label: Text('Symbols'),
                            icon: Icon(Icons.apple),
                          ),
                        ],
                        selected: {widget.iconSourceMode},
                        onSelectionChanged: (set) =>
                            widget.onIconSourceChanged(set.first),
                      ),
                      const SizedBox(height: 24),

                      // Theme Mode
                      const Text(
                        'Appearance Theme',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment(
                            value: ThemeMode.light,
                            label: Text('Light'),
                            icon: Icon(Icons.light_mode),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            label: Text('Dark'),
                            icon: Icon(Icons.dark_mode),
                          ),
                          ButtonSegment(
                            value: ThemeMode.system,
                            label: Text('Auto'),
                            icon: Icon(Icons.brightness_auto),
                          ),
                        ],
                        selected: {widget.themeMode},
                        onSelectionChanged: (set) =>
                            widget.onThemeChanged(set.first),
                      ),
                      const SizedBox(height: 24),

                      // Background Wallpaper Toggle
                      const Text(
                        'Glass Background Style',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<BackgroundStyle>(
                        segments: const [
                          ButtonSegment(
                            value: BackgroundStyle.vibrantMesh,
                            label: Text('Mesh Glass'),
                          ),
                          ButtonSegment(
                            value: BackgroundStyle.auroraGlow,
                            label: Text('Aurora'),
                          ),
                          ButtonSegment(
                            value: BackgroundStyle.minimalSolid,
                            label: Text('Solid'),
                          ),
                        ],
                        selected: {widget.backgroundStyle},
                        onSelectionChanged: (set) =>
                            widget.onBackgroundChanged(set.first),
                      ),
                      const SizedBox(height: 24),

                      // Custom Icon Size Slider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Custom Icon Size',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${widget.iconSize.toInt()} pt',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: widget.tintColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: widget.iconSize,
                        min: 16.0,
                        max: 32.0,
                        divisions: 16,
                        label: '${widget.iconSize.toInt()} pt',
                        onChanged: widget.onIconSizeChanged,
                      ),
                      const SizedBox(height: 16),

                      // Custom Font Size Slider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Custom Label Text Size',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${widget.fontSize.toInt()} pt',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: widget.tintColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: widget.fontSize,
                        min: 9.0,
                        max: 15.0,
                        divisions: 6,
                        label: '${widget.fontSize.toInt()} pt',
                        onChanged: widget.onFontSizeChanged,
                      ),
                      const SizedBox(height: 20),

                      // Active Tint Color Picker
                      const Text(
                        'Active Tint Color (Icon & Text)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: tintColorOptions.map((color) {
                          final isSelected = widget.tintColor == color;
                          return GestureDetector(
                            onTap: () => widget.onTintChanged(color),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                        width: 3,
                                      )
                                    : null,
                                boxShadow: [
                                  if (isSelected)
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                ],
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 18,
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Unselected Color Picker
                      const Text(
                        'Unselected Color (Inactive Tab & Text)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: unselectedColorOptions.map((color) {
                          final isSelected = widget.unselectedColor == color;
                          return GestureDetector(
                            onTap: () => widget.onUnselectedColorChanged(color),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                        color: widget.tintColor,
                                        width: 3,
                                      )
                                    : null,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 18,
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 120),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.tintColor.withValues(alpha: 0.88),
            widget.tintColor.withValues(alpha: 0.65),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: widget.tintColor.withValues(alpha: 0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 42, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassShowcaseCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B).withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_fix_high_rounded, color: widget.tintColor),
              const SizedBox(width: 8),
              const Text(
                'Liquid Glass Translucency',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Scroll this page all the way to the bottom to see cards, colors, and gradients diffuse smoothly beneath the native iOS glass tab bar.',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Custom SVGs',
            'Retina 3x',
            Icons.image_aspect_ratio_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Liquid Glass',
            'Live Blur',
            Icons.blur_on_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B).withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: widget.tintColor, size: 28),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String text, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 0,
      color: isDark
          ? const Color(0xFF1E293B).withValues(alpha: 0.7)
          : Colors.white.withValues(alpha: 0.75),
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, color: widget.tintColor),
        title: Text(text, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
