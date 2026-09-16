# native_liquid_glass_navbar

A high-performance, **zero-dependency** Flutter plugin bringing the authentic iOS **Liquid Glass** navigation bar to Flutter apps with complete support for **PNG Images**, **Vector SVGs**, **Flutter Icons**, and **Apple SF Symbols**.

This package renders the native iOS `UITabBar` on iOS devices for authentic Apple Liquid Glass blur, haptics, fluidity, and system styling, while automatically providing a smooth frosted-glass navigation bar on Android, Web, and Desktop.

---

## 📱 Visual Showcase & Themes

<div align="center">

| ☀️ iOS Light Theme | 🌙 iOS Dark Theme | 🚀 Cross-Platform Fallback |
| :---: | :---: | :---: |
| <img src="https://raw.githubusercontent.com/bakarflutter/glass_nav_bar/main/example/assets/white_theme_navbar.png" width="270" alt="iOS Light Theme Liquid Glass Navbar" /> | <img src="https://raw.githubusercontent.com/bakarflutter/glass_nav_bar/main/example/assets/dark_theme_navbar.png" width="270" alt="iOS Dark Theme Liquid Glass Navbar" /> | <img src="https://raw.githubusercontent.com/bakarflutter/glass_nav_bar/main/example/assets/fallback_navbar.png" width="270" alt="Cross-Platform Glass Fallback Navbar" /> |
| **Authentic iOS Light Blur**<br>• Crisp PNGs, SVGs & Icons<br>• Dynamic Live Mesh Underlay<br>• Floating Quick Action Button | **Deep Liquid Dark Blur**<br>• Custom Accent & Tinting<br>• High-contrast Retina Icons<br>• Native iOS `UITabBar` Fluidity | **Glassmorphism for All Platforms**<br>• Android, Web & Desktop Ready<br>• Smooth Animated Sliding Pill<br>• Frosted Backdrop Blur (Sigma 25) |

</div>

---

## 🌟 Supported Icon & Image Formats

You can pass **any image or icon** using `iconWidget`:

| Format / Source | How to Use | Example |
| :--- | :--- | :--- |
| 🖼️ **PNG / JPG Images** | Pass `Image.asset(...)` to `iconWidget` | `iconWidget: Image.asset('assets/icons/home.png', width: 24, height: 24)` |
| 🎨 **Vector SVGs** | Pass `SvgPicture.asset(...)` to `iconWidget` | `iconWidget: SvgPicture.asset('assets/icons/home.svg', width: 24, height: 24)` |
| 🔣 **Flutter Icons** | Pass `Icon(...)` to `iconWidget` or use `icon:` | `iconWidget: Icon(Icons.home_rounded)` or `icon: Icons.home_rounded` |
| 🍏 **Apple SF Symbols** | Set `symbol:` property | `symbol: 'house.fill'` |
| 🏷️ **Badges & Custom UI** | Pass any custom `Widget` to `iconWidget` | `iconWidget: Badge(label: Text('3'), child: Icon(Icons.notifications))` |

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

## 💡 Usage Examples

### 1. Using PNG Images (`Image.asset`)

```dart
NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  tabs: [
    NativeLiquidGlassNavBarItem.widget(
      label: 'Home',
      iconWidget: Image.asset('assets/icons/home.png', width: 24, height: 24),
      symbol: 'house.fill',
    ),
    NativeLiquidGlassNavBarItem.widget(
      label: 'Search',
      iconWidget: Image.asset('assets/icons/search.png', width: 24, height: 24),
      symbol: 'magnifyingglass',
    ),
    NativeLiquidGlassNavBarItem.widget(
      label: 'Saved',
      iconWidget: Image.asset('assets/icons/heart.png', width: 24, height: 24),
      symbol: 'heart.fill',
    ),
    NativeLiquidGlassNavBarItem.widget(
      label: 'Settings',
      iconWidget: Image.asset('assets/icons/settings.png', width: 24, height: 24),
      symbol: 'gearshape.fill',
    ),
  ],
)
```

---

### 2. Using Vector SVGs (`SvgPicture.asset`)

```dart
NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  actionButton: NativeLiquidGlassActionButton.widget(
    iconWidget: SvgPicture.asset('assets/icons/plus.svg', width: 20, height: 20),
    symbol: 'plus',
    onTap: () => print('Action button tapped!'),
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

### 3. Using Flutter Icons (`IconData` or `Icon` Widget)

You can pass `IconData` directly or pass an `Icon` widget:

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
      icon: Icons.tune_rounded,
      symbol: 'gearshape.fill',
    ),
  ],
)
```

---

### 4. Mix & Match (PNGs, SVGs, Icons, and Badges)

You can freely mix different widget types in the same navigation bar:

```dart
NativeLiquidGlassNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  tabs: [
    // 1. PNG Image
    NativeLiquidGlassNavBarItem.widget(
      label: 'Home',
      iconWidget: Image.asset('assets/icons/home.png', width: 24, height: 24),
      symbol: 'house.fill',
    ),
    // 2. Vector SVG
    NativeLiquidGlassNavBarItem.widget(
      label: 'Search',
      iconWidget: SvgPicture.asset('assets/icons/search.svg', width: 24, height: 24),
      symbol: 'magnifyingglass',
    ),
    // 3. Flutter Icon with Notification Badge
    NativeLiquidGlassNavBarItem.widget(
      label: 'Alerts',
      iconWidget: const Badge(
        label: Text('2'),
        child: Icon(Icons.notifications_rounded),
      ),
      symbol: 'bell.fill',
    ),
    // 4. Flutter IconData
    const NativeLiquidGlassNavBarItem.icon(
      label: 'Settings',
      icon: Icons.settings_rounded,
      symbol: 'gearshape.fill',
    ),
  ],
)
```

---

## 🎨 Active & Inactive Widget States

Provide `selectedIconWidget` to display a distinct widget (such as a filled icon or highlighted image) when active:

```dart
NativeLiquidGlassNavBarItem(
  label: 'Saved',
  // Inactive state (e.g. outline icon or dimmed PNG)
  iconWidget: Image.asset('assets/icons/heart_outline.png', width: 24, height: 24),
  // Active state (e.g. filled icon or colored PNG)
  selectedIconWidget: Image.asset('assets/icons/heart_filled.png', width: 24, height: 24),
  symbol: 'heart.fill',
)
```

---

## 🌐 Cross-Platform Fallback

When running on Android, Web, or Desktop, `native_liquid_glass_navbar` automatically renders a floating frosted-glass navbar with:
- **`ImageFilter.blur` (sigma 25)** backdrop glassmorphic blur.
- **Animated sliding indicator pill** tracking active tab transitions.
- Automatic light & dark mode borders and drop shadows.

You can also pass your own custom fallback widget via `fallback:`:

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
| `iconWidget` | `Widget?` | Any Flutter widget (`Image.asset`, `SvgPicture.asset`, `Icon`, `Badge`, etc.). |
| `selectedIconWidget` | `Widget?` | Optional custom Flutter widget to render when active/selected. |
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
| `iconWidget` | `Widget?` | Any Flutter widget (`Image.asset`, `SvgPicture.asset`, `Icon`). |
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
