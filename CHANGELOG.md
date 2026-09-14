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
