#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint liquid_glass_navbar.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'liquid_glass_navbar'
  s.version          = '1.1.0'
  s.summary          = 'A Flutter plugin that brings the native iOS Liquid Glass style navigation bar to your Flutter apps with custom SVG, PNG, and icon support.'
  s.description      = <<-DESC
A Flutter plugin that brings the native iOS Liquid Glass style navigation bar to your Flutter apps with custom SVG, PNG, and icon support.
                       DESC
  s.homepage         = 'https://github.com/TechSupportz/liquid_glass_navbar'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Abou Bakar' => 'ab.dev.pk@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'liquid_glass_navbar/Sources/liquid_glass_navbar/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # Privacy manifest, shared with the Swift Package Manager target.
  # See https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  s.resource_bundles = {'liquid_glass_navbar_privacy' => ['liquid_glass_navbar/Sources/liquid_glass_navbar/PrivacyInfo.xcprivacy']}
end
