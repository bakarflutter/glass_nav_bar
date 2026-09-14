## 1.1.0

- **Custom SVG Support**: Added support for custom SVG icon assets (`svgPath`), raw SVG strings (`svgString`), and bytes.
- **Custom PNG / Raster Assets**: Added support for PNG/JPEG image assets (`assetPath`) and raw image bytes (`imageBytes`).
- **Flutter IconData Support**: Added direct support for Flutter `IconData` (`Icons.home`, `CupertinoIcons`, custom font icons) via `icon`.
- **Hybrid Symbol Support**: Maintained backwards compatibility with Apple SF Symbols and Xcode named assets via `symbol`.
- **In-Memory Caching**: Added high-performance rasterization cache in `GlassIconLoader` for smooth 60/120fps tab transitions without re-rasterizing.
- **Swift Package Manager & CocoaPods**: Enhanced iOS native layer to support both SPM and CocoaPods with template rendering mode for automatic system theme tinting.

## 1.0.3

- Added Swift Package Manager support for iOS while retaining CocoaPods compatibility.
- Shared native sources and the privacy manifest between both build systems.

## 1.0.2

- Fixed an issue where tab bar would briefly flash the wrong color when app theme differed from system theme.
- Added support for custom image asset icons in tab bar items and action buttons.
- Added an example screen demonstrating custom icon assets.

## 1.0.1

- Added documentation for public API members.
- Enabled `public_member_api_docs` lint rule.

## 1.0.0

- Initial release of liquid_glass_navbar Flutter plugin
