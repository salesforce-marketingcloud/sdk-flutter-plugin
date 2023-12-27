#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint sfmc.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'sfmc'
  s.version          = '8.1.0'
  s.summary          = 'Flutter Plugin to access the native Salesforce Marketing Cloud MobilePush SDKs.'
  s.description      = <<-DESC
  Flutter Plugin to access the native Salesforce Marketing Cloud MobilePush SDKs.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'MarketingCloudSDK','~> 8.1.0'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
