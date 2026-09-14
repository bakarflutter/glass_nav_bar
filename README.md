# liquid_glass_navbar

A high-performance Flutter plugin that brings the authentic iOS **Liquid Glass** navigation bar to Flutter apps with full support for **custom SVGs**, **PNG/raster images**, **Flutter IconData**, and **Apple SF Symbols**.

This package uses [platform views and method channels](https://docs.flutter.dev/platform-integration/ios/platform-views) to render the actual native iOS `UITabBar`. This eliminates the uncanny valley effect often found in simulated Flutter implementations, providing authentic Apple Liquid Glass blur, haptics, fluidity, and tab animations.

---

## Demos

![output](https://github.com/user-attachments/assets/d7691c1b-5eef-451d-b18f-4d118ca3e8f2)
![output-items-bg](https://github.com/user-attachments/assets/5bbc0358-0e85-4604-89db-96eb68806053)

---

## Features

- 🎨 **Custom SVGs**: Load vector SVG icons directly via Flutter asset path (`svgPath`) or inline SVG string (`svgString`).
- 🖼️ **PNG & Image Assets**: Use custom PNG, JPG, or WebP assets (`assetPath`) or raw memory bytes (`imageBytes`).
- 🔣 **Flutter IconData**: Use any Material Icon, Cupertino Icon, or custom font icon (`icon: Icons.home`).
- 🍏 **Apple SF Symbols**: Built-in support for native Apple SF Symbols (`symbol: 'house.fill'`).
- 💎 **Authentic Liquid Glass Blur**: Genuine native iOS translucency and blur styling with zero frame drops.
- 🌓 **Theming & Dark Mode**: Automatically adapts to system brightness and your app's `ThemeData` primary and tint colors.
- 🔘 **Action Button**: Add a prominent circular action button to the right of the tabs for central app actions (e.g. Create / Post / Add).
- 📱 **Cross-Platform Fallback**: Optionally define a Flutter fallback widget (e.g. `NavigationBar` or `BottomNavigationBar`) for Android and older iOS versions.
- ⚡ **High-Performance In-Memory Cache**: Icons are rasterized at high retina resolution (@3x) and cached in memory for instantaneous 60/120 FPS transitions.

---

## Installation

Add `liquid_glass_navbar` to your `pubspec.yaml`:

```yaml
dependencies:
  liquid_glass_navbar: ^1.1.0
```

Run `flutter pub get`.

---

## Usage

Import the package:

```dart
import 'package:liquid_glass_navbar/liquid_glass_navbar.dart';
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
LiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) {
    setState(() {
      _currentIndex = index;
    });
  },
  tabs: const [
    LiquidGlassNavBarItem(
      label: 'Home',
      svgPath: 'assets/icons/home.svg',
    ),
    LiquidGlassNavBarItem(
      label: 'Search',
      svgPath: 'assets/icons/search.svg',
    ),
    LiquidGlassNavBarItem(
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
LiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  tabs: const [
    LiquidGlassNavBarItem(
      label: 'Home',
      svgPath: 'assets/icons/home.svg',
    ),
    LiquidGlassNavBarItem(
      label: 'Profile',
      assetPath: 'assets/icons/profile.png',
    ),
    LiquidGlassNavBarItem(
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
LiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  actionButton: LiquidGlassActionButton(
    svgPath: 'assets/icons/plus.svg',
    onTap: () {
      print('Action button tapped!');
    },
  ),
  tabs: const [
    LiquidGlassNavBarItem(
      label: 'Home',
      svgPath: 'assets/icons/home.svg',
    ),
    LiquidGlassNavBarItem(
      label: 'Search',
      svgPath: 'assets/icons/search.svg',
    ),
  ],
)
```

---

### 4. Cross-Platform Fallback (Android & Older iOS)

Since this plugin utilizes native iOS Liquid Glass APIs, provide a `fallback` widget (such as Flutter's standard `NavigationBar`) for Android or older devices:

```dart
LiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  tabs: const [
    LiquidGlassNavBarItem(label: 'Home', svgPath: 'assets/icons/home.svg'),
    LiquidGlassNavBarItem(label: 'Settings', icon: Icons.settings),
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

### `LiquidGlassNavBar`

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `tabs` | `List<LiquidGlassNavBarItem>` | List of tabs to display. Maximum 5 (or 4 when `actionButton` is provided). |
| `currentIndex` | `int` | The zero-based index of the currently active tab. |
| `onTap` | `ValueChanged<int>` | Callback triggered when a tab is tapped. |
| `actionButton` | `LiquidGlassActionButton?` | Optional circular action button floating to the right of the tabs. |
| `tintColor` | `Color?` | Custom tint color for active tab and icons. Defaults to `Theme.of(context).colorScheme.primary`. |
| `fallback` | `Widget?` | Widget to display on non-iOS or unsupported devices. |

---

### `LiquidGlassNavBarItem`

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

### `LiquidGlassActionButton`

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

## Publishing Checklist for Pub.dev

When publishing your own version to [pub.dev](https://pub.dev):

1. **Configure `pubspec.yaml`**: Update `homepage`, `repository`, and `issue_tracker` with your GitHub repo.
2. **Update `LICENSE`**: Replace with your name and year.
3. **Run Static Analysis & Tests**:
   ```bash
   flutter analyze
   flutter test
   ```
4. **Publish Dry Run**:
   ```bash
   dart pub publish --dry-run
   ```
5. **Publish**:
   ```bash
   dart pub publish
   ```

---

## Author

**Abou Bakar**  
📧 Email: [ab.dev.pk@gmail.com](mailto:ab.dev.pk@gmail.com)

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
