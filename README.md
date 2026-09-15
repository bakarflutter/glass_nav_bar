# native_liquid_glass_navbar

A high-performance Flutter plugin that brings the authentic iOS **Liquid Glass** navigation bar to Flutter apps with full support for **custom SVGs**, **PNG/raster images**, **Flutter IconData**, and **Apple SF Symbols**.

This package uses [platform views and method channels](https://docs.flutter.dev/platform-integration/ios/platform-views) to render the actual native iOS `UITabBar`. This eliminates the uncanny valley effect often found in simulated Flutter implementations, providing authentic Apple Liquid Glass blur, haptics, fluidity, and tab animations.

---

## 📱 Visual Showcase & Themes

<div align="center">

| ☀️ iOS Light Theme | 🌙 iOS Dark Theme | 🚀 Cross-Platform Fallback |
| :---: | :---: | :---: |
| <img src="https://raw.githubusercontent.com/bakarflutter/glass_nav_bar/main/example/assets/white_theme_navbar.png" width="270" alt="iOS Light Theme Liquid Glass Navbar" /> | <img src="https://raw.githubusercontent.com/bakarflutter/glass_nav_bar/main/example/assets/dark_theme_navbar.png" width="270" alt="iOS Dark Theme Liquid Glass Navbar" /> | <img src="https://raw.githubusercontent.com/bakarflutter/glass_nav_bar/main/example/assets/fallback_navbar.png" width="270" alt="Cross-Platform Glass Fallback Navbar" /> |
| **Authentic iOS Light Blur**<br>• Crisp Vector SVGs & PNGs<br>• Dynamic Live Mesh Underlay<br>• Floating Quick Action Pill | **Deep Liquid Dark Blur**<br>• Custom Accent & Tinting<br>• High-contrast Retina Icons<br>• Native iOS `UITabBar` Fluidity | **Glassmorphism for All Platforms**<br>• Android, Web & Desktop Ready<br>• Smooth Animated Sliding Pill<br>• Frosted Backdrop Blur (Sigma 25) |

</div>

---

## 🌟 Key Highlights & Theming

### ☀️ Light Theme (Liquid Glass)
- **Authentic Apple Vibrancy**: Uses native iOS glass materials that dynamically sample the colors and gradients passing beneath the navigation bar.
- **Retina Crisp Vector SVGs**: High-resolution vector rasterization ensuring pixel-perfect clarity without blurriness on @2x and @3x screens.
- **Floating Action Pill**: Sleek circular action button for central actions (e.g. Create, Add, Camera) seamlessly integrated into the navigation bar hierarchy.

### 🌙 Dark Theme (Deep Translucency)
- **Automatic System & App Theme Adaptation**: Automatically responds to iOS Dark Mode and Flutter `ThemeData.brightness`.
- **Dynamic Active Tinting**: Customize active tab colors (`tintColor`) and unselected states (`unselectedColor`) with seamless color transitions.
- **Zero Frame Drops**: Completely offloaded to native `UITabBar` rendering for rock-solid 60/120 FPS performance.

### 🚀 Cross-Platform Fallback (Android, Web & Desktop)
- **Built-in Frosted Glass Container**: Features backdrop glassmorphic blur (`ImageFilter.blur(sigmaX: 25, sigmaY: 25)`), dynamic glass borders, and subtle elevation shadows.
- **Interactive Sliding Pill Indicator**: Smooth spring-animated pill indicator tracks active tab transitions across all non-iOS platforms.
- **100% Feature Parity**: Full support for custom SVGs, PNG assets, Flutter `IconData`, custom sizes, and action buttons without any extra configuration.
- **Custom Fallback Widget Support**: Easily plug in a custom Material 3 `NavigationBar` or any widget via the `fallback:` parameter.

---

## Features

- 🎨 **Custom SVGs**: Load vector SVG icons directly via Flutter asset path (`svgPath`) or inline SVG string (`svgString`).
- 🖼️ **PNG & Image Assets**: Use custom PNG, JPG, or WebP assets (`assetPath`) or raw memory bytes (`imageBytes`).
- 🔣 **Flutter IconData**: Use any Material Icon, Cupertino Icon, or custom font icon (`icon: Icons.home`).
- 🍏 **Apple SF Symbols**: Built-in support for native Apple SF Symbols (`symbol: 'house.fill'`).
- 💎 **Authentic Liquid Glass Blur**: Genuine native iOS translucency and blur styling with zero frame drops.
- 🌓 **Theming & Dark Mode**: Automatically adapts to system brightness and your app's `ThemeData` primary and tint colors.
- 🔘 **Action Button**: Add a prominent circular action button to the right of the tabs for central app actions (e.g. Create / Post / Add).
- 📱 **Cross-Platform Fallback**: Automatically provides a built-in cross-platform navigation bar or accepts a custom `fallback` widget for Android, Web, and older iOS versions.
- ⚡ **High-Performance In-Memory Cache**: Icons are rasterized at high retina resolution (@3x) and cached in memory for instantaneous 60/120 FPS transitions.

---

## Installation

Add `native_liquid_glass_navbar` to your `pubspec.yaml`:

```yaml
dependencies:
  native_liquid_glass_navbar: ^1.0.5
```

Run `flutter pub get`.

---

## Easy Usage (2 Popular Options)

### Option 1: Quick Named Constructors (Recommended)

Use convenient named constructors for crisp, declarative code:

```dart
NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  actionButton: NativeLiquidGlassActionButton.svg(
    svgPath: 'assets/icons/plus.svg',
    onTap: () => _openCreateModal(),
  ),
  tabs: const [
    NativeLiquidGlassNavBarItem.svg(
      label: 'Home',
      svgPath: 'assets/icons/home.svg',
    ),
    NativeLiquidGlassNavBarItem.svg(
      label: 'Search',
      svgPath: 'assets/icons/search.svg',
    ),
    NativeLiquidGlassNavBarItem.icon(
      label: 'Saved',
      icon: Icons.favorite_rounded,
    ),
    NativeLiquidGlassNavBarItem.symbol(
      label: 'Settings',
      symbol: 'gearshape.fill',
    ),
  ],
)
```

---

### Option 2: Standard Constructor

You can mix and match custom SVGs, PNGs, and Flutter `IconData`:

```dart
NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  tintColor: const Color(0xFF0A84FF),
  unselectedColor: const Color(0xFF8E8E93),
  iconSize: 26.0,
  fontSize: 10.0,
  onTap: (index) => setState(() => _currentIndex = index),
  tabs: const [
    NativeLiquidGlassNavBarItem(
      label: 'Home',
      svgPath: 'assets/icons/home.svg',
    ),
    NativeLiquidGlassNavBarItem(
      label: 'Search',
      assetPath: 'assets/icons/search.png',
    ),
    NativeLiquidGlassNavBarItem(
      label: 'Settings',
      icon: Icons.settings_rounded,
    ),
  ],
)
```

---

## Cross-Platform Fallback & Customization

When running on non-iOS platforms (Android, Web, macOS, Windows, Linux) or older iOS versions, `native_liquid_glass_navbar` provides two flexible options:

### 1. Built-in Premium Glass Fallback (Default)

By default, the plugin automatically renders a floating frosted-glass navbar with:
- **`ImageFilter.blur` (sigma 25)** backdrop glassmorphic blur.
- **Animated sliding pill indicator** with smooth spring transitions.
- Automatic light/dark mode glass gradient borders and drop shadows.
- Direct support for all your SVGs, PNGs, `IconData`, and action buttons.

You can customize this fallback directly using the properties on `NativeLiquidGlassNavBar`:

```dart
NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  // Customization properties applied across native and fallback:
  tintColor: Colors.blueAccent,       // Active icon & label color
  unselectedColor: Colors.grey,       // Inactive icon & label color
  iconSize: 26.0,                     // Icon dimension
  fontSize: 11.0,                     // Label font size
  tabs: _tabs,
  actionButton: _actionButton,
)
```

### 2. Providing a Custom Fallback Widget

If you prefer a standard Material 3 `NavigationBar` or a custom design for Android/Web, provide the `fallback` parameter:

```dart
NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  tabs: _tabs,
  // Custom fallback widget rendered on Android / Web:
  fallback: NavigationBar(
    selectedIndex: _currentIndex,
    onDestinationSelected: (index) => setState(() => _currentIndex = index),
    destinations: const [
      NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
      NavigationDestination(icon: Icon(Icons.favorite), label: 'Saved'),
      NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
    ],
  ),
)
```

---

## API Reference

### `NativeLiquidGlassNavBar`

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `tabs` | `List<NativeLiquidGlassNavBarItem>` | List of tabs to display (maximum 5, or 4 when `actionButton` is provided). |
| `currentIndex` | `int` | The zero-based index of the currently active tab. |
| `onTap` | `ValueChanged<int>` | Callback triggered when a tab is selected. |
| `actionButton` | `NativeLiquidGlassActionButton?` | Optional circular action button floating to the right of the tabs. |
| `tintColor` | `Color?` | Custom tint color for active tab and icons. |
| `unselectedColor` | `Color?` | Custom color for inactive tabs and icons. |
| `iconSize` | `double?` | Custom size for tab icons (defaults to `26.0`). |
| `fontSize` | `double?` | Custom font size for tab labels (defaults to `10.0`). |
| `fallback` | `Widget?` | Custom fallback widget for Android/Web (uses built-in glass navbar if null). |

---

### `NativeLiquidGlassNavBarItem`

Named constructors:
- `NativeLiquidGlassNavBarItem.svg({required String label, required String svgPath, double? iconSize})`
- `NativeLiquidGlassNavBarItem.icon({required String label, required IconData icon, double? iconSize})`
- `NativeLiquidGlassNavBarItem.asset({required String label, required String assetPath, double? iconSize})`
- `NativeLiquidGlassNavBarItem.symbol({required String label, required String symbol, double? iconSize})`

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `label` | `String` | Text label displayed under the tab icon. |
| `svgPath` | `String?` | Flutter asset path to an SVG vector file (`assets/icons/home.svg`). |
| `assetPath` | `String?` | Flutter asset path to a PNG/JPEG/WebP image (`assets/icons/home.png`). |
| `icon` | `IconData?` | Flutter [IconData] to render (`Icons.home`, `CupertinoIcons.house`). |
| `svgString` | `String?` | Raw SVG XML string to render dynamically. |
| `imageBytes` | `Uint8List?` | Raw PNG byte buffer for in-memory images. |
| `symbol` | `String?` | Apple SF Symbol name (`house.fill`, `gearshape.fill`). |
| `iconSize` | `double?` | Individual tab icon size override. |

---

### `NativeLiquidGlassActionButton`

Named constructors:
- `NativeLiquidGlassActionButton.svg({required String svgPath, required VoidCallback onTap, double? iconSize})`
- `NativeLiquidGlassActionButton.icon({required IconData icon, required VoidCallback onTap, double? iconSize})`
- `NativeLiquidGlassActionButton.asset({required String assetPath, required VoidCallback onTap, double? iconSize})`
- `NativeLiquidGlassActionButton.symbol({required String symbol, required VoidCallback onTap, double? iconSize})`

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `onTap` | `VoidCallback` | Callback triggered when the action button is tapped. |
| `svgPath` | `String?` | Flutter asset path to an SVG vector icon. |
| `assetPath` | `String?` | Flutter asset path to a PNG/JPEG/WebP image. |
| `icon` | `IconData?` | Flutter [IconData] for the action button. |
| `svgString` | `String?` | Raw SVG XML string. |
| `imageBytes` | `Uint8List?` | Raw PNG byte buffer. |
| `symbol` | `String?` | Apple SF Symbol name or native asset name. |
| `iconSize` | `double?` | Action button icon size override. |

---

## 👨‍💻 Author & Maintainer

<div align="center">

### **Abou Bakar**
*Flutter Developer & Open-Source Creator*

[![GitHub](https://img.shields.io/badge/GitHub-bakarflutter-181717?style=for-the-badge&logo=github)](https://github.com/bakarflutter)
[![Email](https://img.shields.io/badge/Email-ab.dev.pk%40gmail.com-EA4335?style=for-the-badge&logo=gmail&logoColor=white)](mailto:ab.dev.pk@gmail.com)

</div>

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
