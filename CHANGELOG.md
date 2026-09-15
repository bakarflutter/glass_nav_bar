## 1.0.5

- **Direct GitHub CDN Asset Links**: Updated showcase image links in documentation to point to direct raw GitHub URLs for reliable rendering on pub.dev and online package catalogs.
- **Polished Visual Showcase**: Enhanced the visual layout and responsive presentation of Light Theme, Dark Theme, and Cross-Platform Fallback previews.

## 1.0.4

- **Visual Showcase & Themes Documentation**: Added full side-by-side screenshots demonstrating iOS Light Theme, iOS Dark Theme, and the Cross-Platform Glass Fallback.
- **Theme & Fallback Highlights**: Comprehensive documentation detailing authentic iOS liquid glass blur, automatic dark/light theme switching, active tint color customization, and cross-platform frosted glass capabilities.

## 1.0.3

- **High-End Built-in Glass Fallback**: Premium floating frosted-glass navbar with smooth animated sliding indicator pill for Android, Web, macOS, Linux, and Windows.
- **Accurate Indicator Alignment**: Exact mathematical alignment positioning for sliding indicator pills across all tab counts and action button configurations.
- **Enhanced Documentation & Customization**: Comprehensive README guides on customizing the fallback navbar, theming, font sizing, and named constructors.

## 1.0.2

- **Label Overflow & Auto-Fitting**: Automatic horizontal spacing, boundary clipping, and tail truncation (`...`) preventing long text overlapping adjacent tabs.
- **Enhanced Author & Documentation**: Highlighting maintainer details and usage patterns.

## 1.0.1

- **Easy Named Constructors**: Added `.svg()`, `.icon()`, `.asset()`, and `.symbol()` constructors to `NativeLiquidGlassNavBarItem` and `NativeLiquidGlassActionButton`.
- **Optical Sizing Optimization**: Calibrated vector SVG and `IconData` font rasterization scale to match native iOS SF Symbols.
- **Dynamic Theming Controls**: Added custom `iconSize`, `fontSize`, `tintColor`, and `unselectedColor` customization.
- **Translucent Mesh Background Example**: Added interactive background switcher to demo the live liquid glass blur effect.

## 1.0.0

- Initial release of `native_liquid_glass_navbar`.
- **Custom SVG Support**: Load any SVG icon vector directly via Flutter asset paths (`svgPath`) and raw SVG strings (`svgString`).
- **PNG & Raster Image Assets**: Full support for PNG, JPEG, and WebP images (`assetPath`) and raw byte data (`imageBytes`).
- **Flutter IconData Support**: Seamlessly render Material, Cupertino, and custom font icons (`icon: Icons.home`).
- **Apple SF Symbols**: Direct native iOS SF Symbol integration (`symbol: 'house.fill'`).
- **Authentic Liquid Glass Styling**: Utilizes iOS platform views and `UITabBar` with blur effects, fluidity, and system theming.
- **Cross-Platform Fallback**: Built-in automatic navigation fallback for Android, Web, and unsupported devices with optional custom `fallback` widget.
- **In-Memory Caching**: High-performance rasterization cache ensuring zero-lag tab transitions.
