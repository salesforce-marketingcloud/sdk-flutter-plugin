import 'sfmc_platform_interface.dart';

/// Salesforce Marketing Cloud SDK for Flutter.
class SFMCSdk {
  /// Returns the system token used by the Marketing Cloud to send push messages to the device.
  ///
  /// Returns a Future that resolves to the system token string.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/get-system-token.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)deviceToken)
  static Future<String?> getSystemToken() {
    return SfmcPlatform.instance.getSystemToken();
  }

  /// Checks if push messaging is enabled in the Marketing Cloud SDK.
  ///
  /// Returns a Future that resolves to a boolean indicating if push is enabled.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.push/-push-message-manager/is-push-enabled.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)pushEnabled)
  static Future<bool?> isPushEnabled() {
    return SfmcPlatform.instance.isPushEnabled();
  }

  /// Enables push messaging in the native Marketing Cloud SDK.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.push/-push-message-manager/enable-push.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)setPushEnabled:)
  static Future<void> enablePush() {
    return SfmcPlatform.instance.enablePush();
  }

  /// Disables push messaging in the native Marketing Cloud SDK.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.push/-push-message-manager/disable-push.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)setPushEnabled:)
  static Future<void> disablePush() {
    return SfmcPlatform.instance.disablePush();
  }

  /// Enables verbose logging within the native Marketing Cloud SDK and Unified SFMC SDK.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/trouble-shooting/loginterface.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/SFMCSdk/8.0/Classes/SFMCSdk.html#/c:@M@SFMCSDK@objc(cs)SFMCSdk(cm)setLoggerWithLogLevel:logOutputter:)
  static Future<void> enableLogging() {
    return SfmcPlatform.instance.enableLogging();
  }

  /// Disables verbose logging within the native Marketing Cloud SDK.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/trouble-shooting/loginterface.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/SFMCSdk/8.0/Classes/SFMCSdk.html#/c:@M@SFMCSDK@objc(cs)SFMCSdk(cm)setLoggerWithLogLevel:logOutputter:)
  static Future<void> disableLogging() {
    return SfmcPlatform.instance.disableLogging();
  }

  /// Logs the SDK state to the native logging system (Logcat for Android and Xcode/Console.app for iOS).
  /// This can help diagnose most issues within the SDK and is often requested by the Marketing Cloud support team.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/SFMCSdk/8.0/com.salesforce.marketingcloud.sfmcsdk/-s-f-m-c-sdk/get-sdk-state.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/SFMCSdk/8.0/Classes/SFMCSdk.html#/c:@M@SFMCSDK@objc(cs)SFMCSdk(cm)state)
  static Future<void> logSdkState() {
    return SfmcPlatform.instance.logSdkState();
  }

  /// Returns the device ID used by the Marketing Cloud to send push messages to the device.
  ///
  /// Returns a Future that resolves to the device ID.
  ///
  /// See:
  /// - [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/get-device-id.html)
  /// - [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)deviceIdentifier)
  static Future<String?> getDeviceId() {
    return SfmcPlatform.instance.getDeviceId();
  }
}
