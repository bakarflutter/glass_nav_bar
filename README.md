# native_liquid_glass_navbar

A high-performance, **zero-dependency** Flutter plugin that brings the authentic iOS **Liquid Glass** navigation bar to Flutter apps with full support for **custom Flutter widgets (SVGs, Images, Badges)**, **Flutter IconData**, and **Apple SF Symbols**.

This package renders the native iOS `UITabBar` on iOS devices to provide authentic Apple Liquid Glass blur, haptics, and fluidity, while automatically providing a beautiful frosted-glass navbar on non-iOS platforms (Android, Web, Desktop).

---

## 📱 Visual Showcase & Themes

<div align="center">

| ☀️ iOS Light Theme | 🌙 iOS Dark Theme | 🚀 Cross-Platform Fallback |
| :---: | :---: | :---: |
| <img src="https://raw.githubusercontent.com/bakarflutter/glass_nav_bar/main/example/assets/white_theme_navbar.png" width="270" alt="iOS Light Theme Liquid Glass Navbar" /> | <img src="https://raw.githubusercontent.com/bakarflutter/glass_nav_bar/main/example/assets/dark_theme_navbar.png" width="270" alt="iOS Dark Theme Liquid Glass Navbar" /> | <img src="https://raw.githubusercontent.com/bakarflutter/glass_nav_bar/main/example/assets/fallback_navbar.png" width="270" alt="Cross-Platform Glass Fallback Navbar" /> |
| **Authentic iOS Light Blur**<br>• Crisp Custom Widgets & Icons<br>• Dynamic Live Mesh Underlay<br>• Floating Quick Action Button | **Deep Liquid Dark Blur**<br>• Custom Accent & Tinting<br>• High-contrast Retina Icons<br>• Native iOS `UITabBar` Fluidity | **Glassmorphism for All Platforms**<br>• Android, Web & Desktop Ready<br>• Smooth Animated Sliding Pill<br>• Frosted Backdrop Blur (Sigma 25) |

</div>

---

## 🚀 Key Features

- 🧩 **Any Flutter Widget (`iconWidget`)**: Pass any widget directly — `SvgPicture.asset(...)`, `Image.asset(...)`, custom badge, animated container, etc.
- 📦 **Zero External Dependencies**: Pure Flutter SDK implementation. Bring your own packages without version conflicts.
- 🔣 **Flutter IconData**: Seamless support for Material and Cupertino icons (`icon: Icons.home`).
- 🍏 **Apple SF Symbols**: Built-in support for native iOS SF Symbols (`symbol: 'house.fill'`).
- 🔘 **Floating Action Button**: Add a circular action button to the right of the tabs for central app actions (e.g. Create, Add, Camera).
- 📱 **Cross-Platform Fallback**: Automatically renders a floating frosted-glass navbar on Android, Web, macOS, Linux, and Windows.
- 💎 **Authentic Liquid Glass Blur**: Genuine native iOS materials and blur styling with zero frame drops.

---

## 📦 Installation

Add `native_liquid_glass_navbar` to your `pubspec.yaml`:

```yaml
dependencies:
  native_liquid_glass_navbar: ^1.1.1
```

Run:
```bash
flutter pub get
```

---

## 💡 Quick Start

### 1. Using Custom Widgets (e.g., SVGs / Images)

Pass your custom widget directly via `iconWidget`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:native_liquid_glass_navbar/native_liquid_glass_navbar.dart';

NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  tintColor: Colors.blueAccent,
  onTap: (index) => setState(() => _currentIndex = index),
  actionButton: NativeLiquidGlassActionButton.widget(
    iconWidget: SvgPicture.asset('assets/icons/plus.svg', width: 20, height: 20),
    symbol: 'plus',
    onTap: () => print('Action tapped!'),
  ),
  tabs: [
    NativeLiquidGlassNavBarItem.widget(
      label: 'Home',
      iconWidget: SvgPicture.asset('assets/icons/home.svg', width: 24, height: 24),
      symbol: 'house.fill',
    ),
    NativeLiquidGlassNavBarItem.widget(
      label: 'Search',
      iconWidget: SvgPicture.asset('assets/icons/search.svg', width: 24, height: 24),
      symbol: 'magnifyingglass',
    ),
    NativeLiquidGlassNavBarItem.widget(
      label: 'Saved',
      iconWidget: SvgPicture.asset('assets/icons/heart.svg', width: 24, height: 24),
      symbol: 'heart.fill',
    ),
    NativeLiquidGlassNavBarItem.widget(
      label: 'Settings',
      iconWidget: SvgPicture.asset('assets/icons/settings.svg', width: 24, height: 24),
      symbol: 'gearshape.fill',
    ),
  ],
)
```

---

### 2. Using Flutter `IconData` or SF Symbols

You can also use standard Flutter icons or Apple SF Symbols:

```dart
NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  tabs: const [
    NativeLiquidGlassNavBarItem.icon(
      label: 'Home',
      icon: Icons.home_rounded,
      symbol: 'house.fill',
    ),
    NativeLiquidGlassNavBarItem.icon(
      label: 'Search',
      icon: Icons.search_rounded,
      symbol: 'magnifyingglass',
    ),
    NativeLiquidGlassNavBarItem.icon(
      label: 'Saved',
      icon: Icons.favorite_rounded,
      symbol: 'heart.fill',
    ),
    NativeLiquidGlassNavBarItem.icon(
      label: 'Settings',
      icon: Icons.settings_rounded,
      symbol: 'gearshape.fill',
    ),
  ],
)
```

---

## 🎨 Customizing Active & Inactive States

You can supply an optional `selectedIconWidget` to show a different widget when a tab is selected:

```dart
NativeLiquidGlassNavBarItem(
  label: 'Home',
  iconWidget: SvgPicture.asset(
    'assets/icons/home.svg',
    colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
  ),
  selectedIconWidget: SvgPicture.asset(
    'assets/icons/home.svg',
    colorFilter: const ColorFilter.mode(Colors.blueAccent, BlendMode.srcIn),
  ),
  symbol: 'house.fill',
)
```

---

## 🌐 Cross-Platform Fallback

When running on non-iOS platforms (Android, Web, Desktop), `native_liquid_glass_navbar` automatically renders a floating frosted-glass navbar with:
- **`ImageFilter.blur` (sigma 25)** backdrop glassmorphic blur.
- **Animated sliding indicator pill** tracking active tab transitions.
- Light & dark mode glass border effects and shadows.

You can also provide your own custom fallback widget via the `fallback:` parameter:

```dart
NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  tabs: _tabs,
  // Custom fallback widget for Android / Web:
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

## 📖 API Reference

### `NativeLiquidGlassNavBar`

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `tabs` | `List<NativeLiquidGlassNavBarItem>` | List of tabs (up to 5 tabs, or 4 when `actionButton` is provided). |
| `currentIndex` | `int` | The index of the currently active tab. |
| `onTap` | `ValueChanged<int>` | Callback triggered when a tab is selected. |
| `actionButton` | `NativeLiquidGlassActionButton?` | Optional circular action button floating to the right of the tabs. |
| `tintColor` | `Color?` | Custom tint color for the active tab and indicator. |
| `unselectedColor` | `Color?` | Custom color for unselected tabs. |
| `iconSize` | `double?` | Custom icon dimension (default: `26.0`). |
| `fontSize` | `double?` | Custom label font size (default: `10.0`). |
| `fallback` | `Widget?` | Optional custom widget for non-iOS platforms. |

---

### `NativeLiquidGlassNavBarItem`

**Named Constructors:**
- `NativeLiquidGlassNavBarItem.widget({required String label, required Widget iconWidget, Widget? selectedIconWidget, String? symbol, double? iconSize})`
- `NativeLiquidGlassNavBarItem.icon({required String label, required IconData icon, String? symbol, double? iconSize})`
- `NativeLiquidGlassNavBarItem.symbol({required String label, required String symbol, double? iconSize})`

| Property | Type | Description |
| :--- | :--- | :--- |
| `label` | `String` | Text label displayed under the tab icon. |
| `iconWidget` | `Widget?` | Custom Flutter widget to render (e.g. `SvgPicture.asset`, `Image.asset`, custom badge). |
| `selectedIconWidget` | `Widget?` | Optional custom Flutter widget to render when the tab is active/selected. |
| `icon` | `IconData?` | Flutter `IconData` (`Icons.home`, `CupertinoIcons.house`). |
| `symbol` | `String?` | Apple SF Symbol name (`house.fill`, `gearshape.fill`). |
| `iconSize` | `double?` | Individual tab icon size override. |

---

### `NativeLiquidGlassActionButton`

**Named Constructors:**
- `NativeLiquidGlassActionButton.widget({required Widget iconWidget, required VoidCallback onTap, String? symbol, double? iconSize})`
- `NativeLiquidGlassActionButton.icon({required IconData icon, required VoidCallback onTap, String? symbol, double? iconSize})`
- `NativeLiquidGlassActionButton.symbol({required String symbol, required VoidCallback onTap, double? iconSize})`

| Property | Type | Description |
| :--- | :--- | :--- |
| `onTap` | `VoidCallback` | Callback triggered when the action button is tapped. |
| `iconWidget` | `Widget?` | Custom Flutter widget to render as the action button icon. |
| `icon` | `IconData?` | Flutter `IconData` for the action button. |
| `symbol` | `String?` | Apple SF Symbol name (`plus`). |
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
