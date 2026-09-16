# native_liquid_glass_navbar

<div align="center">

[![pub package](https://img.shields.io/pub/v/native_liquid_glass_navbar.svg?logo=dart&logoColor=white)](https://pub.dev/packages/native_liquid_glass_navbar)
[![platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20Android%20%7C%20Web%20%7C%20Desktop-40C4FF?logo=flutter)](https://pub.dev/packages/native_liquid_glass_navbar)
[![license](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![likes](https://img.shields.io/pub/likes/native_liquid_glass_navbar?logo=dart)](https://pub.dev/packages/native_liquid_glass_navbar)
[![popularity](https://img.shields.io/pub/popularity/native_liquid_glass_navbar?logo=dart)](https://pub.dev/packages/native_liquid_glass_navbar)

A high-performance Flutter plugin bringing the authentic iOS **Liquid Glass** navigation bar to iOS and a sleek frosted-glass navigation bar to **Android**, **Web**, and **Desktop** with full support for **PNG Images**, **Vector SVGs**, **Flutter Icons**, and **Apple SF Symbols**.

</div>

---

## 📱 Platform Architecture

| Platform | Navigation Bar Implementation | Visual & Interactive Features |
| :--- | :--- | :--- |
| 🍏 **iOS** | Native UIKit `UITabBar` (`UiKitView`) | Authentic Apple Liquid Glass blur, native haptic feedback, fluid system styling, Apple SF Symbols & rasterized icons. |
| 🤖 **Android** | Premium Frosted Glass Bar (Flutter Engine) | Smooth `ImageFilter.blur` (Sigma 25), animated sliding pill selection indicator, drop shadows, custom Flutter widgets, SVGs & PNGs. |
| 🌐 **Web & Desktop** | Premium Frosted Glass Bar (Flutter Engine) | Full cross-platform responsive glassmorphic navigation bar. |

---

## 📱 Visual Showcase & Themes

<div align="center">

| ☀️ iOS Light Theme | 🌙 iOS Dark Theme | 🚀 Cross-Platform Fallback |
| :---: | :---: | :---: |
| <img src="https://raw.githubusercontent.com/bakarflutter/glass_nav_bar/main/example/assets/white_theme_navbar.png" width="270" alt="iOS Light Theme Liquid Glass Navbar" /> | <img src="https://raw.githubusercontent.com/bakarflutter/glass_nav_bar/main/example/assets/dark_theme_navbar.png" width="270" alt="iOS Dark Theme Liquid Glass Navbar" /> | <img src="https://raw.githubusercontent.com/bakarflutter/glass_nav_bar/main/example/assets/fallback_navbar.png" width="270" alt="Cross-Platform Glass Fallback Navbar" /> |
| **Authentic iOS Light Blur**<br>• Crisp PNGs, SVGs & Icons<br>• Dynamic Live Mesh Underlay<br>• Floating Quick Action Button | **Deep Liquid Dark Blur**<br>• Custom Accent & Tinting<br>• High-contrast Retina Icons<br>• Native iOS `UITabBar` Fluidity | **Glassmorphism for All Platforms**<br>• Android, Web & Desktop Ready<br>• Smooth Animated Sliding Pill<br>• Frosted Backdrop Blur (Sigma 25) |

</div>

---

## 💡 How Icon Resolution Works (iOS Native vs. Cross-Platform)

> [!IMPORTANT]
> **Understanding Icon Rendering Across Platforms:**
> - **On iOS**: The navbar renders Apple's native **UIKit `UITabBar`** for authentic Liquid Glass blur. Native UIKit requires an Apple SF Symbol / Asset name (`symbol: 'house.fill'`), raw bitmap bytes (`imageBytes: bytes`), or `IconData` (`icon: Icons.home`).
> - **On Android, Web, & Desktop**: The navbar renders your custom Flutter widgets (`iconWidget: SvgPicture.asset(...)` or `Image.asset(...)`).
>
> **Best Practice for Custom Widgets & SVGs:**
> When using `NativeLiquidGlassNavBarItem.widget()`, always provide a native `symbol:` (or `imageBytes:`) so iOS displays the native symbol/asset image rather than falling back to a `?` (question mark):
> ```dart
> NativeLiquidGlassNavBarItem.widget(
>   label: 'Home',
>   symbol: 'house.fill', // Rendered on iOS native UITabBar
>   iconWidget: SvgPicture.asset('assets/svgs/home.svg', width: 24, height: 24), // Rendered on Android / Web
> )
> ```

---

## 🌟 Supported Icon & Image Formats

| Format / Source | How to Use | Code Snippet |
| :--- | :--- | :--- |
| 🖼️ **PNG / JPG Images** | Use `iconWidget: Image.asset(...)` + `symbol:` or `imageBytes:` | `NativeLiquidGlassNavBarItem.widget(label: 'Home', symbol: 'house.fill', iconWidget: Image.asset('assets/icons/home.png', width: 24, height: 24))` |
| 🎨 **Vector SVGs** | Use `iconWidget: SvgPicture.asset(...)` + `symbol:` | `NativeLiquidGlassNavBarItem.widget(label: 'Search', symbol: 'magnifyingglass', iconWidget: SvgPicture.asset('assets/icons/search.svg', width: 24, height: 24))` |
| 🔣 **Flutter Icons** | Use `icon: Icons.home_rounded` (Auto-rasterized for iOS) | `NativeLiquidGlassNavBarItem.icon(label: 'Home', icon: Icons.home_rounded)` |
| 🍏 **Apple SF Symbols** | Use `symbol: 'house.fill'` (Auto-mapped on Android/Web) | `NativeLiquidGlassNavBarItem.symbol(label: 'Home', symbol: 'house.fill')` |
| 🏷️ **Badges & Custom UI** | Use `iconWidget: Badge(...)` + `symbol:` | `NativeLiquidGlassNavBarItem.widget(label: 'Alerts', symbol: 'bell.fill', iconWidget: Badge(label: Text('3'), child: Icon(Icons.notifications)))` |

---

## 📦 Installation

Add `native_liquid_glass_navbar` to your `pubspec.yaml`:

```yaml
dependencies:
  native_liquid_glass_navbar: ^1.1.4
```

Then run:
```bash
flutter pub get
```

---

## 💡 Usage Examples

### 1. 🖼️ Using PNG Images (`Image.asset`)

Use `NativeLiquidGlassNavBarItem.widget()` with `Image.asset` for standard PNG icons:

```dart
NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  actionButton: NativeLiquidGlassActionButton.widget(
    symbol: 'plus', // Rendered on iOS
    iconWidget: Image.asset('assets/icons/plus.png', width: 20, height: 20, color: Colors.white), // Android/Web
    onTap: () => print('Add tapped!'),
  ),
  tabs: [
    NativeLiquidGlassNavBarItem.widget(
      label: 'Home',
      symbol: 'house.fill',
      iconWidget: Image.asset('assets/icons/home.png', width: 24, height: 24),
      selectedIconWidget: Image.asset('assets/icons/home.png', width: 24, height: 24, color: Colors.blue),
    ),
    NativeLiquidGlassNavBarItem.widget(
      label: 'Search',
      symbol: 'magnifyingglass',
      iconWidget: Image.asset('assets/icons/search.png', width: 24, height: 24),
      selectedIconWidget: Image.asset('assets/icons/search.png', width: 24, height: 24, color: Colors.blue),
    ),
    NativeLiquidGlassNavBarItem.widget(
      label: 'Saved',
      symbol: 'heart.fill',
      iconWidget: Image.asset('assets/icons/heart.png', width: 24, height: 24),
      selectedIconWidget: Image.asset('assets/icons/heart.png', width: 24, height: 24, color: Colors.blue),
    ),
    NativeLiquidGlassNavBarItem.widget(
      label: 'Settings',
      symbol: 'gearshape.fill',
      iconWidget: Image.asset('assets/icons/settings.png', width: 24, height: 24),
      selectedIconWidget: Image.asset('assets/icons/settings.png', width: 24, height: 24, color: Colors.blue),
    ),
  ],
)
```

---

### 2. 🎨 Using Vector SVGs (`SvgPicture.asset`)

Use `flutter_svg`'s `SvgPicture.asset` inside `iconWidget` and `selectedIconWidget`:

```dart
NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  actionButton: NativeLiquidGlassActionButton.widget(
    symbol: 'plus', // Rendered on iOS
    iconWidget: SvgPicture.asset( // Rendered on Android / Web
      'assets/icons/plus.svg',
      width: 20,
      height: 20,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    ),
    onTap: () => print('Action tapped!'),
  ),
  tabs: [
    NativeLiquidGlassNavBarItem.widget(
      label: 'Home',
      symbol: 'house.fill',
      iconWidget: SvgPicture.asset(
        'assets/icons/home.svg',
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
      ),
      selectedIconWidget: SvgPicture.asset(
        'assets/icons/home.svg',
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
      ),
    ),
    NativeLiquidGlassNavBarItem.widget(
      label: 'Search',
      symbol: 'magnifyingglass',
      iconWidget: SvgPicture.asset(
        'assets/icons/search.svg',
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
      ),
      selectedIconWidget: SvgPicture.asset(
        'assets/icons/search.svg',
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
      ),
    ),
    NativeLiquidGlassNavBarItem.widget(
      label: 'Saved',
      symbol: 'heart.fill',
      iconWidget: SvgPicture.asset(
        'assets/icons/heart.svg',
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
      ),
      selectedIconWidget: SvgPicture.asset(
        'assets/icons/heart.svg',
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
      ),
    ),
    NativeLiquidGlassNavBarItem.widget(
      label: 'Settings',
      symbol: 'gearshape.fill',
      iconWidget: SvgPicture.asset(
        'assets/icons/settings.svg',
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
      ),
      selectedIconWidget: SvgPicture.asset(
        'assets/icons/settings.svg',
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
      ),
    ),
  ],
)
```

---

### 3. 🔣 Using Flutter Icons (`IconData`)

Pass standard Flutter `IconData` (Material or Cupertino icons) directly using `NativeLiquidGlassNavBarItem.icon()`. The package automatically converts them to high-resolution native image bytes for iOS without requiring manual configuration:

```dart
NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  actionButton: NativeLiquidGlassActionButton.icon(
    icon: Icons.add_rounded,
    onTap: () => print('Add tapped!'),
  ),
  tabs: const [
    NativeLiquidGlassNavBarItem.icon(
      label: 'Home',
      icon: Icons.home_rounded,
    ),
    NativeLiquidGlassNavBarItem.icon(
      label: 'Search',
      icon: Icons.search_rounded,
    ),
    NativeLiquidGlassNavBarItem.icon(
      label: 'Saved',
      icon: Icons.favorite_rounded,
    ),
    NativeLiquidGlassNavBarItem.icon(
      label: 'Settings',
      icon: Icons.tune_rounded,
    ),
  ],
)
```

---

### 4. 🍏 Using Apple SF Symbols (`symbol`)

Pass native Apple SF Symbol names for authentic iOS rendering. On Android, Web, and Desktop, matching Material icons are automatically used as fallback:

```dart
NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  actionButton: NativeLiquidGlassActionButton.symbol(
    symbol: 'plus',
    onTap: () => print('Add tapped!'),
  ),
  tabs: const [
    NativeLiquidGlassNavBarItem.symbol(
      label: 'Home',
      symbol: 'house.fill',
    ),
    NativeLiquidGlassNavBarItem.symbol(
      label: 'Search',
      symbol: 'magnifyingglass',
    ),
    NativeLiquidGlassNavBarItem.symbol(
      label: 'Saved',
      symbol: 'heart.fill',
    ),
    NativeLiquidGlassNavBarItem.symbol(
      label: 'Settings',
      symbol: 'gearshape.fill',
    ),
  ],
)
```

---

### 5. 🔀 Mix & Match (PNGs, SVGs, Icons, and Badges)

You can freely mix different icon types and custom widgets across your navigation bar:

```dart
NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  tabs: [
    // 1. PNG Image
    NativeLiquidGlassNavBarItem.widget(
      label: 'Home',
      symbol: 'house.fill',
      iconWidget: Image.asset('assets/icons/home.png', width: 24, height: 24),
    ),
    // 2. Vector SVG
    NativeLiquidGlassNavBarItem.widget(
      label: 'Search',
      symbol: 'magnifyingglass',
      iconWidget: SvgPicture.asset('assets/icons/search.svg', width: 24, height: 24),
    ),
    // 3. Custom Badge with Flutter Icon
    NativeLiquidGlassNavBarItem.widget(
      label: 'Alerts',
      symbol: 'bell.fill',
      iconWidget: const Badge(
        label: Text('3'),
        child: Icon(Icons.notifications_rounded, size: 24),
      ),
    ),
    // 4. Flutter IconData
    const NativeLiquidGlassNavBarItem.icon(
      label: 'Settings',
      icon: Icons.settings_rounded,
    ),
  ],
)
```

---

## 🎨 Dynamic Theming & Appearance

You can customize the active tint color, unselected color, icon size, label font size, and light/dark appearance:

```dart
NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  tintColor: const Color(0xFF0A84FF),      // Active tab color (Apple Blue)
  unselectedColor: const Color(0xFF8E8E93),// Inactive tab color
  iconSize: 26.0,                          // Custom icon dimension
  fontSize: 11.0,                          // Custom label font size
  tabs: _myTabs,
)
```

---

## 🌐 Cross-Platform Fallback

When running on **Android, Web, macOS, Linux, or Windows** (or unsupported devices), `native_liquid_glass_navbar` automatically renders a high-end floating frosted-glass navigation bar featuring:
- **`ImageFilter.blur` (sigma 25)** backdrop glassmorphic blur.
- **Animated sliding indicator pill** tracking active tab transitions.
- Light and dark mode support with automatic border gradients and drop shadows.

You can also provide a custom fallback widget via `fallback:`:

```dart
NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  tabs: _tabs,
  // Custom fallback widget for non-iOS platforms:
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
| `onTap` | `ValueChanged<int>` | Callback triggered when a tab is tapped. |
| `actionButton` | `NativeLiquidGlassActionButton?` | Optional circular action button floating to the right of the tabs. |
| `tintColor` | `Color?` | Custom tint color for active tab and indicator. |
| `unselectedColor` | `Color?` | Custom color for unselected tabs. |
| `iconSize` | `double?` | Custom icon dimension (default: `26.0`). |
| `fontSize` | `double?` | Custom label font size (default: `10.0`). |
| `fallback` | `Widget?` | Optional custom fallback widget for non-iOS platforms. |

---

### `NativeLiquidGlassNavBarItem`

**Named Constructors:**
- `NativeLiquidGlassNavBarItem.widget({required String label, required Widget iconWidget, Widget? selectedIconWidget, Uint8List? imageBytes, String? symbol, double? iconSize})`
- `NativeLiquidGlassNavBarItem.icon({required String label, required IconData icon, String? symbol, double? iconSize})`
- `NativeLiquidGlassNavBarItem.symbol({required String label, required String symbol, double? iconSize})`

| Property | Type | Description |
| :--- | :--- | :--- |
| `label` | `String` | Text label displayed under the tab icon. |
| `iconWidget` | `Widget?` | Any Flutter widget (`Image.asset`, `SvgPicture.asset`, `Icon`, `Badge`, etc.) rendered on Android/Web fallback. |
| `selectedIconWidget` | `Widget?` | Optional custom Flutter widget to render when active/selected. |
| `imageBytes` | `Uint8List?` | Raw bitmap/PNG image bytes for direct high-res native iOS rendering. |
| `icon` | `IconData?` | Flutter `IconData` (`Icons.home_rounded`, `CupertinoIcons.house`). Auto-rasterized for iOS. |
| `symbol` | `String?` | Apple SF Symbol name (`house.fill`, `gearshape.fill`) or iOS Asset Catalog image name. |
| `iconSize` | `double?` | Individual tab icon size override. |

---

### `NativeLiquidGlassActionButton`

**Named Constructors:**
- `NativeLiquidGlassActionButton.widget({required Widget iconWidget, required VoidCallback onTap, Uint8List? imageBytes, String? symbol, double? iconSize})`
- `NativeLiquidGlassActionButton.icon({required IconData icon, required VoidCallback onTap, String? symbol, double? iconSize})`
- `NativeLiquidGlassActionButton.symbol({required String symbol, required VoidCallback onTap, double? iconSize})`

| Property | Type | Description |
| :--- | :--- | :--- |
| `onTap` | `VoidCallback` | Callback triggered when the action button is tapped. |
| `iconWidget` | `Widget?` | Any Flutter widget (`Image.asset`, `SvgPicture.asset`, `Icon`). |
| `imageBytes` | `Uint8List?` | Raw bitmap/PNG image bytes for direct high-res native iOS rendering. |
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
