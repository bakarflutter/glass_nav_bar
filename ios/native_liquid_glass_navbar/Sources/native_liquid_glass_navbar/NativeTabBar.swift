import Flutter
import UIKit

class NativeTabBarFactory: NSObject, FlutterPlatformViewFactory {
	private var messenger: FlutterBinaryMessenger

	init(messenger: FlutterBinaryMessenger) {
		self.messenger = messenger
		super.init()
	}

	func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?)
		-> FlutterPlatformView
	{
		return NativeTabBarPlatformView(
			frame: frame,
			viewId: viewId,
			args: args,
			messenger: messenger
		)
	}

	func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
		return FlutterStandardMessageCodec.sharedInstance()
	}
}

class NativeTabBarPlatformView: NSObject, FlutterPlatformView {
	private let controller: LiquidGlassTabBarController

	init(frame: CGRect, viewId: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
		self.controller = LiquidGlassTabBarController(
			viewId: viewId,
			messenger: messenger,
			args: args
		)
		super.init()
	}

	func view() -> UIView {
		return controller.view
	}
}

struct TabBarConfig: Equatable {
	var labels: [String] = []
	var symbols: [String] = []
	var itemImagesData: [Data?] = []
	var actionButtonSymbol: String = ""
	var actionButtonImageData: Data? = nil
	var tintColor: UIColor = .systemBlue
	var unselectedColor: UIColor? = nil
	var iconSize: CGFloat = 26.0
	var fontSize: CGFloat = 10.0
	var selectedIndex: Int = 0
	var isDark: Bool = false

	var hasActionButton: Bool {
		return !actionButtonSymbol.isEmpty || actionButtonImageData != nil
	}

	init(from dict: [String: Any]?) {
		guard let dict = dict else { return }
		if let l = dict["labels"] as? [String] { self.labels = l }
		if let s = dict["symbols"] as? [String] { self.symbols = s }

		if let images = dict["itemImages"] as? [Any] {
			self.itemImagesData = images.map { item in
				if let typedData = item as? FlutterStandardTypedData {
					return typedData.data
				}
				return nil
			}
		}

		if let action = dict["actionButtonSymbol"] as? String {
			self.actionButtonSymbol = action
		}

		if let actionTypedData = dict["actionButtonImage"] as? FlutterStandardTypedData {
			self.actionButtonImageData = actionTypedData.data
		}

		if let colorInt = dict["tintColor"] as? NSNumber {
			self.tintColor = TabBarConfig.uiColorFromARGB(colorInt.intValue)
		}
		if let unselInt = dict["unselectedColor"] as? NSNumber {
			self.unselectedColor = TabBarConfig.uiColorFromARGB(unselInt.intValue)
		}
		if let isize = dict["iconSize"] as? NSNumber {
			self.iconSize = CGFloat(isize.doubleValue)
		}
		if let fsize = dict["fontSize"] as? NSNumber {
			self.fontSize = CGFloat(fsize.doubleValue)
		}
		if let idx = dict["selectedIndex"] as? Int {
			self.selectedIndex = idx
		}
		if let isDark = dict["isDark"] as? Bool {
			self.isDark = isDark
		}
	}

	func structuralChange(from other: TabBarConfig) -> Bool {
		return labels != other.labels
			|| symbols != other.symbols
			|| itemImagesData != other.itemImagesData
			|| (hasActionButton != other.hasActionButton)
			|| fontSize != other.fontSize
			|| iconSize != other.iconSize
			|| isDark != other.isDark
			|| tintColor != other.tintColor
			|| unselectedColor != other.unselectedColor
	}

	private static func uiColorFromARGB(_ argb: Int) -> UIColor {
		let a = CGFloat((argb >> 24) & 0xFF) / 255.0
		let r = CGFloat((argb >> 16) & 0xFF) / 255.0
		let g = CGFloat((argb >> 8) & 0xFF) / 255.0
		let b = CGFloat(argb & 0xFF) / 255.0
		return UIColor(red: r, green: g, blue: b, alpha: a)
	}
}

class LiquidGlassTabBarController: UITabBarController, UITabBarControllerDelegate {
	private let channel: FlutterMethodChannel
	private var config: TabBarConfig
	private var currentAppearanceIsDark: Bool

	init(viewId: Int64, messenger: FlutterBinaryMessenger, args: Any?) {
		self.channel = FlutterMethodChannel(
			name: "NativeTabBar_\(viewId)",
			binaryMessenger: messenger
		)
		self.config = TabBarConfig(from: args as? [String: Any])
		self.currentAppearanceIsDark = config.isDark
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.view.backgroundColor = .clear
		self.view.isOpaque = false
		self.delegate = self
		overrideUserInterfaceStyle = config.isDark ? .dark : .light

		self.customizableViewControllers = []
		if #available(iOS 18.0, *) {
			self.mode = .tabBar
			self.sidebar.isHidden = true
			self.sidebar.items = []
		}

		configureAppearance()
		performFullRebuild()

		channel.setMethodCallHandler { [weak self] call, result in
			self?.handle(call, result: result)
		}
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.view.backgroundColor = .clear

		// Manage overflow, truncation, and spacing for all tab item labels and icons
		for subview in tabBar.subviews {
			if let control = subview as? UIControl {
				control.clipsToBounds = true
				let buttonWidth = control.bounds.width
				let horizontalPadding: CGFloat = 6.0
				let maxLabelWidth = max(0, buttonWidth - (horizontalPadding * 2))

				for child in control.subviews {
					if let label = child as? UILabel {
						label.lineBreakMode = .byTruncatingTail
						label.numberOfLines = 1
						label.adjustsFontSizeToFitWidth = true
						label.minimumScaleFactor = 0.80
						label.textAlignment = .center
						label.clipsToBounds = true

						if label.frame.width > maxLabelWidth {
							label.frame.size.width = maxLabelWidth
							label.center.x = control.bounds.midX
						}
					}
				}
			}
		}
	}

	private func configureAppearance() {
		let appearance = UITabBarAppearance()
		appearance.configureWithDefaultBackground()
		appearance.backgroundColor = .clear
		appearance.shadowColor = .clear
		appearance.backgroundEffect = UIBlurEffect(style: config.isDark ? .dark : .light)

		let unselectedColor = config.unselectedColor ?? .systemGray
		let itemAppearance = UITabBarItemAppearance()
		itemAppearance.normal.iconColor = unselectedColor
		itemAppearance.selected.iconColor = config.tintColor

		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .center
		paragraphStyle.lineBreakMode = .byTruncatingTail

		let normalAttributes: [NSAttributedString.Key: Any] = [
			.font: UIFont.systemFont(ofSize: config.fontSize, weight: .medium),
			.foregroundColor: unselectedColor,
			.paragraphStyle: paragraphStyle
		]
		let selectedAttributes: [NSAttributedString.Key: Any] = [
			.font: UIFont.systemFont(ofSize: config.fontSize, weight: .medium),
			.foregroundColor: config.tintColor,
			.paragraphStyle: paragraphStyle
		]

		itemAppearance.normal.titleTextAttributes = normalAttributes
		itemAppearance.selected.titleTextAttributes = selectedAttributes
		itemAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 1)
		itemAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 1)

		appearance.stackedLayoutAppearance = itemAppearance
		appearance.inlineLayoutAppearance = itemAppearance
		appearance.compactInlineLayoutAppearance = itemAppearance

		tabBar.standardAppearance = appearance
		if #available(iOS 15.0, *) {
			tabBar.scrollEdgeAppearance = appearance
		}

		tabBar.isTranslucent = true
		tabBar.tintColor = config.tintColor
	}

	private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
		if call.method == "update", let dict = call.arguments as? [String: Any] {
			let newConfig = TabBarConfig(from: dict)
			let oldConfig = self.config

			if newConfig.structuralChange(from: oldConfig) {
				self.config = newConfig
				performFullRebuild()
			} else {
				self.config = newConfig
				updateSelectionAndColors()
				updateTabImagesInPlace()
			}

			result(nil)
		} else if call.method == "setVisibility", let dict = call.arguments as? [String: Any], let visible = dict["visible"] as? Bool {
			self.view.isHidden = !visible
			self.view.isUserInteractionEnabled = visible
			self.tabBar.isUserInteractionEnabled = visible
			result(nil)
		} else {
			result(FlutterMethodNotImplemented)
		}
	}

	private func updateTabImagesInPlace() {
		guard let vcs = self.viewControllers else { return }
		let tabSize = CGSize(width: config.iconSize, height: config.iconSize)
		let actionSize = CGSize(width: config.iconSize, height: config.iconSize)

		for (i, vc) in vcs.enumerated() {
			if vc.tabBarItem.tag == 99 {
				vc.tabBarItem.image = resolveImage(
					from: config.actionButtonImageData,
					fallbackSymbol: config.actionButtonSymbol,
					targetSize: actionSize
				)
			} else if i < config.labels.count {
				let imageData = i < config.itemImagesData.count ? config.itemImagesData[i] : nil
				let symbolName = i < config.symbols.count ? config.symbols[i] : ""
				vc.tabBarItem.image = resolveImage(
					from: imageData,
					fallbackSymbol: symbolName,
					targetSize: tabSize
				)
			}
		}
	}

	private func performFullRebuild() {
		configureAppearance()
		var controllers: [UIViewController] = []
		let count = max(config.labels.count, max(config.symbols.count, config.itemImagesData.count))
		let tabSize = CGSize(width: config.iconSize, height: config.iconSize)
		let actionSize = CGSize(width: config.iconSize, height: config.iconSize)

		let unselectedColor = config.unselectedColor ?? .systemGray
		let normalAttributes: [NSAttributedString.Key: Any] = [
			.font: UIFont.systemFont(ofSize: config.fontSize, weight: .medium),
			.foregroundColor: unselectedColor
		]
		let selectedAttributes: [NSAttributedString.Key: Any] = [
			.font: UIFont.systemFont(ofSize: config.fontSize, weight: .medium),
			.foregroundColor: config.tintColor
		]

		// Standard Tabs
		for i in 0..<count {
			let dummyVC = UIViewController()
			dummyVC.view.backgroundColor = .clear

			let symbolName = i < config.symbols.count ? config.symbols[i] : ""
			let label = i < config.labels.count ? config.labels[i] : ""
			let imageData = i < config.itemImagesData.count ? config.itemImagesData[i] : nil

			let item = UITabBarItem(
				title: label,
				image: resolveImage(
					from: imageData,
					fallbackSymbol: symbolName,
					targetSize: tabSize
				),
				tag: i
			)
			item.imageInsets = UIEdgeInsets(top: -1, left: 0, bottom: 1, right: 0)
			item.setTitleTextAttributes(normalAttributes, for: .normal)
			item.setTitleTextAttributes(selectedAttributes, for: .selected)
			if #available(iOS 13.0, *) {
				item.showsLargeContentViewer = false
				item.largeContentSizeImage = nil
			}
			dummyVC.tabBarItem = item
			controllers.append(dummyVC)
		}

		// Action Button
		if config.hasActionButton {
			let actionVC = UIViewController()
			actionVC.view.backgroundColor = .clear

			let item = UITabBarItem(tabBarSystemItem: .search, tag: 99)
			item.image = resolveImage(
				from: config.actionButtonImageData,
				fallbackSymbol: config.actionButtonSymbol,
				targetSize: actionSize
			)
			if #available(iOS 13.0, *) {
				item.showsLargeContentViewer = false
				item.largeContentSizeImage = nil
			}

			actionVC.tabBarItem = item
			controllers.append(actionVC)
		}

		self.setViewControllers(controllers, animated: false)

		if #available(iOS 13.0, *) {
			tabBar.interactions.removeAll { $0 is UILargeContentViewerInteraction }
		}
		for recognizer in tabBar.gestureRecognizers ?? [] {
			if recognizer is UILongPressGestureRecognizer {
				recognizer.isEnabled = false
			}
		}

		updateSelectionAndColors()
		tabBar.setNeedsLayout()
		tabBar.layoutIfNeeded()
	}

	private func updateSelectionAndColors() {
		tabBar.tintColor = config.tintColor
		currentAppearanceIsDark = config.isDark
		overrideUserInterfaceStyle = config.isDark ? .dark : .light
		configureAppearance()

		if let vcs = self.viewControllers {
			let unselectedColor = config.unselectedColor ?? .systemGray
			let normalAttributes: [NSAttributedString.Key: Any] = [
				.font: UIFont.systemFont(ofSize: config.fontSize, weight: .medium),
				.foregroundColor: unselectedColor
			]
			let selectedAttributes: [NSAttributedString.Key: Any] = [
				.font: UIFont.systemFont(ofSize: config.fontSize, weight: .medium),
				.foregroundColor: config.tintColor
			]
			for vc in vcs {
				vc.tabBarItem.standardAppearance = tabBar.standardAppearance
				if #available(iOS 15.0, *) {
					vc.tabBarItem.scrollEdgeAppearance = tabBar.scrollEdgeAppearance
				}
				vc.tabBarItem.setTitleTextAttributes(normalAttributes, for: .normal)
				vc.tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
			}
		}

		if self.selectedIndex != config.selectedIndex {
			if let vcs = self.viewControllers,
				config.selectedIndex < vcs.count,
				vcs[config.selectedIndex].tabBarItem.tag != 99
			{
				self.selectedIndex = config.selectedIndex
			}
		}

		tabBar.setNeedsLayout()
		tabBar.layoutIfNeeded()
	}

	private func resolveImage(
		from data: Data?,
		fallbackSymbol: String?,
		targetSize: CGSize
	) -> UIImage? {
		if let data = data, !data.isEmpty {
			if let rawImg = UIImage(data: data, scale: 3.0) ?? UIImage(data: data) {
				let resized = resizeImage(rawImg, targetSize: targetSize)
				return resized.withRenderingMode(.alwaysTemplate)
			}
		}
		if let symbol = fallbackSymbol, !symbol.isEmpty {
			if #available(iOS 13.0, *) {
				let config = UIImage.SymbolConfiguration(pointSize: targetSize.width * 0.75, weight: .regular)
				if let symImg = UIImage(systemName: symbol, withConfiguration: config) {
					return symImg.withRenderingMode(.alwaysTemplate)
				}
			}
			if let namedImg = UIImage(named: symbol) {
				return resizeImage(namedImg, targetSize: targetSize).withRenderingMode(.alwaysTemplate)
			}
		}
		return UIImage(systemName: "questionmark")
	}

	private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
		let format = UIGraphicsImageRendererFormat.default()
		format.scale = UIScreen.main.scale
		let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
		return renderer.image { _ in
			image.draw(in: CGRect(origin: .zero, size: targetSize))
		}
	}

	// MARK: - Delegate
	func tabBarController(
		_ tabBarController: UITabBarController,
		shouldSelect viewController: UIViewController
	) -> Bool {
		if viewController.tabBarItem.tag == 99 {
			channel.invokeMethod("actionButtonPressed", arguments: nil)
			return false
		}
		return true
	}

	func tabBarController(
		_ tabBarController: UITabBarController,
		didSelect viewController: UIViewController
	) {
		let tag = viewController.tabBarItem.tag
		if tag != 99 {
			config.selectedIndex = tag
			channel.invokeMethod("valueChanged", arguments: ["index": tag])
		}
	}
}
