import 'package:flutter/material.dart';
import 'package:native_liquid_glass_navbar/native_liquid_glass_navbar.dart';

void main() {
  runApp(const LiquidGlassApp());
}

class LiquidGlassApp extends StatefulWidget {
  const LiquidGlassApp({super.key});

  @override
  State<LiquidGlassApp> createState() => _LiquidGlassAppState();
}

class _LiquidGlassAppState extends State<LiquidGlassApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Color _tintColor = const Color(0xFF0A84FF); // Apple System Blue

  void _updateThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  void _updateTintColor(Color color) {
    setState(() => _tintColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Liquid Glass Navbar',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _tintColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF2F4F7),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _tintColor,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
      ),
      home: RootNavigationScreen(
        themeMode: _themeMode,
        tintColor: _tintColor,
        onThemeChanged: _updateThemeMode,
        onTintChanged: _updateTintColor,
      ),
    );
  }
}

class RootNavigationScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final Color tintColor;
  final ValueChanged<ThemeMode> onThemeChanged;
  final ValueChanged<Color> onTintChanged;

  const RootNavigationScreen({
    super.key,
    required this.themeMode,
    required this.tintColor,
    required this.onThemeChanged,
    required this.onTintChanged,
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
                'Quick Action',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Triggered by the floating Action Button',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: widget.tintColor.withValues(alpha: 0.15),
                  child: Icon(Icons.add_photo_alternate_rounded, color: widget.tintColor),
                ),
                title: const Text('Upload Media'),
                subtitle: const Text('Add photos or videos'),
                onTap: () => Navigator.pop(ctx),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: widget.tintColor.withValues(alpha: 0.15),
                  child: Icon(Icons.note_add_rounded, color: widget.tintColor),
                ),
                title: const Text('Create New Post'),
                subtitle: const Text('Draft and publish new content'),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Crucial: draws background elements behind liquid glass navbar
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildFeedTab(),
          _buildSearchTab(),
          _buildFavoritesTab(),
          _buildSettingsTab(),
        ],
      ),
      bottomNavigationBar: LiquidGlassNavBar(
        currentIndex: _currentIndex,
        tintColor: widget.tintColor,
        onTap: (index) => setState(() => _currentIndex = index),
        actionButton: LiquidGlassActionButton(
          svgPath: 'assets/icons/plus.svg',
          onTap: _openCreateModal,
        ),
        tabs: const [
          LiquidGlassNavBarItem(
            label: 'Feed',
            svgPath: 'assets/icons/home.svg',
          ),
          LiquidGlassNavBarItem(
            label: 'Search',
            svgPath: 'assets/icons/search.svg',
          ),
          LiquidGlassNavBarItem(
            label: 'Saved',
            icon: Icons.favorite_rounded,
          ),
          LiquidGlassNavBarItem(
            label: 'Settings',
            svgPath: 'assets/icons/settings.svg',
          ),
        ],
      ),
    );
  }

  Widget _buildFeedTab() {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: const Text('Explore Feed'),
          centerTitle: false,
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildHighlightCard(
                title: 'Authentic Liquid Glass',
                subtitle: 'Powered by native iOS UITabBar for genuine blur & fluidity.',
                icon: Icons.auto_awesome_rounded,
              ),
              const SizedBox(height: 16),
              _buildMetricGrid(),
              const SizedBox(height: 16),
              const Text(
                'Recent Activities',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildActivityItem('Custom SVG rendered: assets/icons/home.svg', Icons.polyline_rounded),
              _buildActivityItem('Custom SVG rendered: assets/icons/search.svg', Icons.search_rounded),
              _buildActivityItem('Flutter IconData: Icons.favorite_rounded', Icons.favorite_rounded),
              const SizedBox(height: 100), // Spacing for floating navbar
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchTab() {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: const Text('Discover'),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              SearchBar(
                hintText: 'Search SVGs, icons, and components...',
                leading: const Icon(Icons.search),
                elevation: const WidgetStatePropertyAll(0),
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).cardColor.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                children: [
                  Chip(label: const Text('All SVGs')),
                  Chip(label: const Text('PNG Assets')),
                  Chip(label: const Text('IconData')),
                  Chip(label: const Text('Liquid Glass')),
                ],
              ),
              const SizedBox(height: 100),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesTab() {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: const Text('Saved Items'),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildHighlightCard(
                title: 'IconData & Asset Mixing',
                subtitle: 'Mix vector SVGs, raster PNGs, and Flutter font icons seamlessly.',
                icon: Icons.star_rounded,
              ),
              const SizedBox(height: 100),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final colorOptions = [
      const Color(0xFF0A84FF), // Blue
      const Color(0xFF5E5CE6), // Indigo
      const Color(0xFF30D158), // Green
      const Color(0xFFFF375F), // Pink
      const Color(0xFFFF9F0A), // Orange
      const Color(0xFFBF5AF2), // Purple
    ];

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: const Text('Preferences'),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Appearance & Theme',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode)),
                          ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode)),
                          ButtonSegment(value: ThemeMode.system, label: Text('Auto'), icon: Icon(Icons.brightness_auto)),
                        ],
                        selected: {widget.themeMode},
                        onSelectionChanged: (set) => widget.onThemeChanged(set.first),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Liquid Glass Tint Color',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: colorOptions.map((color) {
                          final isSelected = widget.tintColor == color;
                          return GestureDetector(
                            onTap: () => widget.onTintChanged(color),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                        color: isDark ? Colors.white : Colors.black,
                                        width: 3,
                                      )
                                    : null,
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 100),
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
            widget.tintColor.withValues(alpha: 0.85),
            widget.tintColor.withValues(alpha: 0.60),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: widget.tintColor.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 44, color: Colors.white),
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
                    color: Colors.white.withValues(alpha: 0.9),
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

  Widget _buildMetricGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('Custom SVGs', 'Vector 3x', Icons.image_aspect_ratio_rounded),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('Liquid Glass', 'Native Blur', Icons.blur_on_rounded),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: widget.tintColor, size: 28),
          const SizedBox(height: 12),
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
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: widget.tintColor),
        title: Text(text, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
