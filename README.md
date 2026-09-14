# native_liquid_glass_navbar

A high-performance Flutter plugin that brings the authentic iOS **Liquid Glass** navigation bar to Flutter apps with full support for **custom SVGs**, **PNG/raster images**, **Flutter IconData**, and **Apple SF Symbols**.

This package uses [platform views and method channels](https://docs.flutter.dev/platform-integration/ios/platform-views) to render the actual native iOS `UITabBar`. This eliminates the uncanny valley effect often found in simulated Flutter implementations, providing authentic Apple Liquid Glass blur, haptics, fluidity, and tab animations.

---

## Showcase & Highlights

| 💎 Liquid Glass & SVGs | 🌈 Live Mesh Translucency | 🔘 Quick Action Button |
| :--- | :--- | :--- |
| **Authentic Apple Blur**<br>Native `UITabBar` rendering with zero frame drops | **Retina Vector SVGs**<br>High-resolution rasterization for pixel-perfect clarity | **Floating Action Pill**<br>Circular action button for quick adds & media triggers |

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
  native_liquid_glass_navbar: ^1.0.0
```

Run `flutter pub get`.

---

## Usage

Import the package:

```dart
import 'package:native_liquid_glass_navbar/native_liquid_glass_navbar.dart';
```

### 1. Using Custom SVG Icons

Place your `.svg` files in your Flutter assets folder (e.g., `assets/icons/`) and declare them in your `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/icons/
```

Then create your navigation bar:

```dart
NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) {
    setState(() {
      _currentIndex = index;
    });
  },
  tabs: const [
    NativeLiquidGlassNavBarItem(
      label: 'Home',
      svgPath: 'assets/icons/home.svg',
    ),
    NativeLiquidGlassNavBarItem(
      label: 'Search',
      svgPath: 'assets/icons/search.svg',
    ),
    NativeLiquidGlassNavBarItem(
      label: 'Settings',
      svgPath: 'assets/icons/settings.svg',
    ),
  ],
)
```

---

### 2. Using PNGs, SVGs, and Flutter IconData

You can mix and match custom SVGs, PNGs, and Flutter `IconData`:

```dart
NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  tabs: const [
    NativeLiquidGlassNavBarItem(
      label: 'Home',
      svgPath: 'assets/icons/home.svg',
    ),
    NativeLiquidGlassNavBarItem(
      label: 'Profile',
      assetPath: 'assets/icons/profile.png',
    ),
    NativeLiquidGlassNavBarItem(
      label: 'Settings',
      icon: Icons.settings_rounded,
    ),
  ],
)
```

---

### 3. Adding an Action Button

You can add an action button (e.g., for creating a new post or item). When an action button is present, the maximum number of tabs is 4 (for a total of 5 items including the action button).

```dart
NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  actionButton: NativeLiquidGlassActionButton(
    svgPath: 'assets/icons/plus.svg',
    onTap: () {
      print('Action button tapped!');
    },
  ),
  tabs: const [
    NativeLiquidGlassNavBarItem(
      label: 'Home',
      svgPath: 'assets/icons/home.svg',
    ),
    NativeLiquidGlassNavBarItem(
      label: 'Search',
      svgPath: 'assets/icons/search.svg',
    ),
  ],
)
```

---

### 4. Cross-Platform Fallback (Android & Older iOS)

Since this plugin utilizes native iOS Liquid Glass APIs, on Android or unsupported platforms it will automatically render a built-in fallback navigation bar, or you can provide a custom `fallback` widget:

```dart
NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  tabs: const [
    NativeLiquidGlassNavBarItem(label: 'Home', svgPath: 'assets/icons/home.svg'),
    NativeLiquidGlassNavBarItem(label: 'Settings', icon: Icons.settings),
  ],
  fallback: NavigationBar(
    selectedIndex: _currentIndex,
    onDestinationSelected: (index) => setState(() => _currentIndex = index),
    destinations: const [
      NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
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
| `tabs` | `List<NativeLiquidGlassNavBarItem>` | List of tabs to display. Maximum 5 (or 4 when `actionButton` is provided). |
| `currentIndex` | `int` | The zero-based index of the currently active tab. |
| `onTap` | `ValueChanged<int>` | Callback triggered when a tab is tapped. |
| `actionButton` | `NativeLiquidGlassActionButton?` | Optional circular action button floating to the right of the tabs. |
| `tintColor` | `Color?` | Custom tint color for active tab and icons. Defaults to `Theme.of(context).colorScheme.primary`. |
| `fallback` | `Widget?` | Optional widget to display on non-iOS or unsupported devices (automatic fallback provided by default). |

---

### `NativeLiquidGlassNavBarItem`

Provide at least **one** icon source (`svgPath`, `assetPath`, `icon`, `svgString`, `imageBytes`, or `symbol`).

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `label` | `String` | Text label displayed under the tab icon. |
| `svgPath` | `String?` | Flutter asset path to an SVG vector file (e.g. `'assets/icons/home.svg'`). |
| `assetPath` | `String?` | Flutter asset path to a PNG/JPEG/WebP image (e.g. `'assets/icons/home.png'`). |
| `icon` | `IconData?` | Flutter [IconData] to render as an icon (e.g. `Icons.home`, `CupertinoIcons.house`). |
| `svgString` | `String?` | Raw SVG XML string to render dynamically. |
| `imageBytes` | `Uint8List?` | Raw PNG byte buffer for in-memory images. |
| `symbol` | `String?` | Apple SF Symbol name (e.g. `'house'`, `'gear'`) or native iOS asset catalog name. |

---

### `NativeLiquidGlassActionButton`

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `onTap` | `VoidCallback` | Callback triggered when the action button is tapped. |
| `svgPath` | `String?` | Flutter asset path to an SVG vector icon. |
| `assetPath` | `String?` | Flutter asset path to a PNG/JPEG/WebP image. |
| `icon` | `IconData?` | Flutter [IconData] for the action button. |
| `svgString` | `String?` | Raw SVG XML string. |
| `imageBytes` | `Uint8List?` | Raw PNG byte buffer. |
| `symbol` | `String?` | Apple SF Symbol name or native asset name. |

---

## Author

**Abou Bakar**  
📧 Email: [ab.dev.pk@gmail.com](mailto:ab.dev.pk@gmail.com)

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
