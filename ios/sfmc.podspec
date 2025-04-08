#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint sfmc.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'sfmc'
  s.version          = '9.0.0'
  s.summary          = 'Flutter Plugin to access the native Salesforce Marketing Cloud MobilePush SDKs.'
  s.description      = <<-DESC
  Flutter Plugin to access the native Salesforce Marketing Cloud MobilePush SDKs.
                       DESC
  s.homepage         = 'https://github.com/salesforce-marketingcloud/sdk-flutter-plugin'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Salesforce Marketing Cloud' => 'mobilepushsdk@salesforce.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'MarketingCloudSDK','~> 9.0.0'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
