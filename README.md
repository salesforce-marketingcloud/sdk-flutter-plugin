# Salesforce Marketing Cloud SDK for Flutter

This module enables the integration of the Marketing Cloud Push SDK into your Flutter applications.

## Release Notes

For release notes, please refer to [CHANGELOG.md](./CHANGELOG.md).

## Installation

> This plugin is compatible with Flutter version 3.3.0 and above.

To add the plugin to your application via [pub](https://pub.dev/packages/sfmc), run the following command:

```shell
flutter pub add sfmc
```

## Example Implementation

An example implementation is provided within the plugin. For setup details, see the [example app](/example).

### Android Setup

Please follow detailed [step by step guide](./Android.md) to setup Android Platform.

### iOS Setup

Please follow detailed step by step guide for [Swift](./iOS_swift.md) or [Objective-C](./iOS_objc.md) to setup iOS Platform.

## URL Handling

The SDK doesn’t automatically present URLs from these sources.

- CloudPage URLs from push notifications.
- OpenDirect URLs from push notifications.
- Action URLs from in-app messages.

To handle URLs from push notifications, please follow iOS step by step guide for [Swift](./iOS_swift.md) or [Objective-C](./iOS_objc.md) and [Android step by step guide](./Android.md).

Please also see additional documentation on URL Handling for [Android](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/sdk-implementation/url-handling.html) and [iOS](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/sdk-implementation/implementation-urlhandling.html).

## Using APIs

In your app `import` the package and utilize the `SFMCSdk` APIs.

```
// Import the SFMC package into your application
import 'package:sfmc/sfmc.dart';

// Utilize the APIs
SFMCSdk.getSystemToken();
```

Please find the [API Refrences](#refrence) below.

## API Reference <a name="reference"></a>

**Kind**: global class

- [SFMCSdk](#SFMCSdk)<a name="SFMCSdk"></a>
  - [.isPushEnabled()](#SFMCSdk.isPushEnabled) ⇒ <code>Future&lt;bool?&gt;</code>
  - [.enablePush()](#SFMCSdk.enablePush) ⇒ <code>Future&lt;void&gt;</code>
  - [.disablePush()](#SFMCSdk.disablePush) ⇒ <code>Future&lt;void&gt;</code>
  - [.getSystemToken()](#SFMCSdk.getSystemToken) ⇒ <code>Future&lt;String?&gt;</code>
  - [.getAttributes()](#SFMCSdk.getAttributes) ⇒ <code>Future&lt;Map<Object?, Object?>?&gt;</code>
  - [.setAttribute(key, value)](#SFMCSdk.setAttribute) ⇒ <code>Future&lt;void&gt;</code>
  - [.clearAttribute(key)](#SFMCSdk.clearAttribute) ⇒ <code>Future&lt;void&gt;</code>
  - [.addTag(tag)](#SFMCSdk.addTag) ⇒ <code>Future&lt;void&gt;</code>
  - [.removeTag(tag)](#SFMCSdk.removeTag) ⇒ <code>Future&lt;void&gt;</code>
  - [.getTags()](#SFMCSdk.getTags) ⇒ <code>Future&lt;List<String&gt;&gt;</code>
  - [.setContactKey(contactKey)](#SFMCSdk.setContactKey) ⇒ <code>Future&lt;void&gt;</code>
  - [.getContactKey()](#SFMCSdk.getContactKey) ⇒ <code>Future&lt;String?&gt;</code>
  - [.enableLogging()](#SFMCSdk.enableLogging) ⇒ <code>Future&lt;void&gt;</code>
  - [.disableLogging()](#SFMCSdk.disableLogging) ⇒ <code>Future&lt;void&gt;</code>
  - [.logSdkState()](#SFMCSdk.logSdkState) ⇒ <code>Future&lt;void&gt;</code>
  - [.trackEvent(event)](#SFMCSdk.track) ⇒ <code>Future&lt;void&gt;</code>
  - [.getDeviceId()](#SFMCSdk.getDeviceId) ⇒ <code>Future&lt;String?&gt;</code>
  - [.setAnalyticsEnabled(analyticsEnabled)](#SFMCSdk.setAnalyticsEnabled) ⇒ <code>Future&lt;void&gt;</code>
  - [.isAnalyticsEnabled()](#SFMCSdk.isAnalyticsEnabled) ⇒ <code>Future&lt;bool&gt;</code>
  - [.setPiAnalyticsEnabled(analyticsEnabled)](#SFMCSdk.setPiAnalyticsEnabled) ⇒ <code>Future&lt;void&gt;</code>
  - [.isPiAnalyticsEnabled()](#SFMCSdk.isPiAnalyticsEnabled) ⇒ <code>Future&lt;bool&gt;</code>

<a name="SFMCSdk.isPushEnabled"></a>

### SFMCSdk.isPushEnabled() ⇒ <code>Future&lt;bool?&gt;</code>

The current state of the pushEnabled flag in the native Marketing Cloud
SDK.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**Returns**: <code>Future&lt;bool?&gt;</code> - A future to the nullable boolean representation of whether push is
enabled.  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.push/-push-message-manager/is-push-enabled.html)
- [iOS Docs](<https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)pushEnabled>)

<a name="SFMCSdk.enablePush"></a>

### SFMCSdk.enablePush() ⇒ <code>Future&lt;void&gt;</code>

Enables push messaging in the native Marketing Cloud SDK.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.push/-push-message-manager/enable-push.html)
- [iOS Docs](<https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)setPushEnabled:>)

<a name="SFMCSdk.disablePush"></a>

### SFMCSdk.disablePush() ⇒ <code>Future&lt;void&gt;</code>

Disables push messaging in the native Marketing Cloud SDK.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.messages.push/-push-message-manager/disable-push.html)
- [iOS Docs](<https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)setPushEnabled:>)

<a name="SFMCSdk.getSystemToken"></a>

### SFMCSdk.getSystemToken() ⇒ <code>Future&lt;String?&gt;</code>

Returns the token used by the Marketing Cloud to send push messages to
the device.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**Returns**: <code>Future&lt;String?&gt;</code> - A future to the nullable system token string.  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/get-system-token.html)
- [iOS Docs](<https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)deviceToken>)

<a name="SFMCSdk.getAttributes"></a>

### SFMCSdk.getAttributes() ⇒ <code>Future&lt;Map&lt;String, String&gt;&gt;</code>

Returns the maps of attributes set in the registration.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**Returns**: <code>Future&lt;Map&lt;String, String&gt;&gt;</code> - A future to the string key/value map of attributes set
in the registration.  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/get-attributes.html)
- [iOS Docs](<https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)attributes>)

<a name="SFMCSdk.setAttribute"></a>

### SFMCSdk.setAttribute(key, value) ⇒ <code>Future&lt;void&gt;</code>

Sets the value of an attribute in the registration.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/SFMCSdk/8.0/com.salesforce.marketingcloud.sfmcsdk.components.identity/-identity/set-profile-attribute.html)
- [iOS Docs](<https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/SFMCSdk/8.0/Classes/IDENTITY.html#/c:@M@SFMCSDK@objc(cs)SFMCSdkIDENTITY(im)setProfileAttributes:>)

| Param | Type                | Description                                                     |
| ----- | ------------------- | --------------------------------------------------------------- |
| key   | <code>string</code> | The name of the attribute to be set in the registration.        |
| value | <code>string</code> | The value of the `key` attribute to be set in the registration. |

<a name="SFMCSdk.clearAttribute"></a>

### SFMCSdk.clearAttribute(key) ⇒ <code>Future&lt;void&gt;</code>

Clears the value of an attribute in the registration.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/-editor/clear-attribute.html)
- [iOS Docs](<https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/SFMCSdk/8.0/Classes/IDENTITY.html#/c:@M@SFMCSDK@objc(cs)SFMCSdkIDENTITY(im)clearProfileAttributeWithKey:>)

| Param | Type                | Description                                                                    |
| ----- | ------------------- | ------------------------------------------------------------------------------ |
| key   | <code>string</code> | The name of the attribute whose value should be cleared from the registration. |

<a name="SFMCSdk.addTag"></a>

### SFMCSdk.addTag(tag) ⇒ <code>Future&lt;void&gt;</code>

Adds a tag to the list of tags in the registration.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/-editor/add-tag.html)
- [iOS Docs](<https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)addTag:>)

| Param | Type                | Description                              |
| ----- | ------------------- | ---------------------------------------- |
| tag   | <code>string</code> | The tag to be added to the registration. |

<a name="SFMCSdk.removeTag"></a>

### SFMCSdk.removeTag(tag) ⇒ <code>Future&lt;void&gt;</code>

Removes a tag from the list of tags in the registration.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/-editor/remove-tag.html)
- [iOS Docs](<https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)removeTag:>)

| Param | Type                | Description                                  |
| ----- | ------------------- | -------------------------------------------- |
| tag   | <code>string</code> | The tag to be removed from the registration. |

<a name="SFMCSdk.getTags"></a>

### SFMCSdk.getTags() ⇒ <code>Future&lt;List&lt;String&gt;&gt;</code>

Returns the list of tags currently set in the registration.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**Returns**: <code>Future&lt;List&lt;String&gt;&gt;</code> - A future to the list of strings representing the tags
currently set in the registration.  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/get-tags.html)
- [iOS Docs](<https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)tags>)

<a name="SFMCSdk.setContactKey"></a>

### SFMCSdk.setContactKey(contactKey) ⇒ <code>Future&lt;void&gt;</code>

Sets the contact key for the device's user.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/SFMCSdk/8.0/com.salesforce.marketingcloud.sfmcsdk.components.identity/-identity/set-profile-id.html)
- [iOS Docs](<https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/SFMCSdk/8.0/Classes/IDENTITY.html#/c:@M@SFMCSDK@objc(cs)SFMCSdkIDENTITY(im)setProfileId:>)

| Param      | Type                | Description                                      |
| ---------- | ------------------- | ------------------------------------------------ |
| contactKey | <code>string</code> | The contact key to be set for the device's user. |

<a name="SFMCSdk.getContactKey"></a>

### SFMCSdk.getContactKey() ⇒ <code>Future&lt;String?&gt;</code>

Returns the contact key associated with the device's user.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**Returns**: <code>Future&lt;String?&gt;</code> - A future to the nullable string representation of the contact key
associated with the device's user.  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/get-contact-key.html)
- [iOS Docs](<https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)contactKey>)

<a name="SFMCSdk.enableLogging"></a>

### SFMCSdk.enableLogging() ⇒ <code>Future&lt;void&gt;</code>

Enables verbose logging within the native Marketing Cloud SDK and Unified SFMC SDK.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/trouble-shooting/loginterface.html)
- [iOS Docs](<https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/SFMCSdk/8.0/Classes/SFMCSdk.html#/c:@M@SFMCSDK@objc(cs)SFMCSdk(cm)setLoggerWithLogLevel:logOutputter:>)

<a name="SFMCSdk.disableLogging"></a>

### SFMCSdk.disableLogging() ⇒ <code>Future&lt;void&gt;</code>

Disables verbose logging within the native Marketing Cloud SDK.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/trouble-shooting/loginterface.html)
- [iOS Docs](<https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/SFMCSdk/8.0/Classes/SFMCSdk.html#/c:@M@SFMCSDK@objc(cs)SFMCSdk(cm)setLoggerWithLogLevel:logOutputter:>)

<a name="SFMCSdk.logSdkState"></a>

### SFMCSdk.logSdkState() ⇒ <code>Future&lt;void&gt;</code>

Instructs the native SDK to log the SDK state to the native logging system (Logcat for
Android and Xcode/Console.app for iOS). This content can help diagnose most issues within
the SDK and will be requested by the Marketing Cloud support team.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/SFMCSdk/8.0/com.salesforce.marketingcloud.sfmcsdk/-s-f-m-c-sdk/get-sdk-state.html)
- [iOS Docs](<https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/SFMCSdk/8.0/Classes/SFMCSdk.html#/c:@M@SFMCSDK@objc(cs)SFMCSdk(cm)state>)

<a name="SFMCSdk.track"></a>

### SFMCSdk.track(event) ⇒ <code>Future&lt;void&gt;</code>

This method helps to track events, which could result in actions such as an InApp Message being displayed.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/event-tracking/event-tracking-event-tracking.html)
- [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/event-tracking/event-tracking-event-tracking.html)

| Param | Type                                                                                                                                                                         | Description              |
| ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| event | <code>CustomEvent</code> \| <code>EngagementEvent</code> \| <code>SystemEvent</code> \| <code>CartEvent</code> \| <code>OrderEvent</code> \| <code>CatalogObjectEvent</code> | The event to be tracked. |

<a name="SFMCSdk.getDeviceId"></a>

### SFMCSdk.getDeviceId() ⇒ <code>Future&lt;String?&gt;</code>

Returns the deviceId used by the Marketing Cloud to send push messages to the device.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**Returns**: <code>Future&lt;String?&gt;</code> - A future to the device Id.  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/get-device-id.html)
- [iOS Docs](<https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)deviceIdentifier>)

<a name="SFMCSdk.setAnalyticsEnabled"></a>

### SFMCSdk.setAnalyticsEnabled(analyticsEnabled) ⇒ <code>Future&lt;void&gt;</code>

Enables or disables analytics in the Marketing Cloud SDK.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/sdk-implementation/runtime-toggles.html)
- [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/sdk-implementation/runtime-toggles.html)

| Param            | Type                 | Description                                            |
| ---------------- | -------------------- | ------------------------------------------------------ |
| analyticsEnabled | <code>boolean</code> | A flag indicating whether analytics should be enabled. |

<a name="SFMCSdk.isAnalyticsEnabled"></a>

### SFMCSdk.isAnalyticsEnabled() ⇒ <code>Future&lt;bool&gt;</code>

Checks if analytics is enabled in the Marketing Cloud SDK.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**Returns**: <code>Future&lt;bool&gt;</code> - A future to the boolean representation of whether analytics is enabled.  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/sdk-implementation/runtime-toggles.html)
- [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/sdk-implementation/runtime-toggles.html)

<a name="SFMCSdk.setPiAnalyticsEnabled"></a>

### SFMCSdk.setPiAnalyticsEnabled(analyticsEnabled) ⇒ <code>Future&lt;void&gt;</code>

Enables or disables Predictive Intelligence analytics in the Marketing Cloud SDK.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/sdk-implementation/runtime-toggles.html)
- [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/sdk-implementation/runtime-toggles.html)

| Param            | Type                 | Description                                               |
| ---------------- | -------------------- | --------------------------------------------------------- |
| analyticsEnabled | <code>boolean</code> | A flag indicating whether PI analytics should be enabled. |

<a name="SFMCSdk.isPiAnalyticsEnabled"></a>

### SFMCSdk.isPiAnalyticsEnabled() ⇒ <code>Future&lt;bool&gt;</code>

Checks if Predictive Intelligence analytics is enabled in the Marketing Cloud SDK.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**Returns**: <code>Future&lt;bool&gt;</code> - A future to the boolean representation of whether PI analytics is enabled.  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/sdk-implementation/runtime-toggles.html)
- [iOS Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/sdk-implementation/runtime-toggles.html)

### 3rd Party Product Language Disclaimers

Where possible, we changed noninclusive terms to align with our company value of Equality. We retained noninclusive terms to document a third-party system, but we encourage the developer community to embrace more inclusive language. We can update the term when it’s no longer required for technical accuracy.
