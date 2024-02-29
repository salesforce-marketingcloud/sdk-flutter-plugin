# Salesforce Marketing Cloud SDK for Flutter

This module enables the integration of the Marketing Cloud Push SDK into your Flutter applications.

## Release Notes

Please refer [CHANGELOG.md](./CHANGELOG.md) for release notes.

## Installation

> This plugin is compatible with Flutter version 3.3.0 and above.

Add plugin to your application via [pub](https://pub.dev/packages/sfmc)

```shell
flutter pub add sfmc
```

This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):

```shell
dependencies:
  sfmc: ^8.1.0
```

## Example Implementation

An example implementation is provided within the plugin. For setup details, see the [example app](/example).

### Android Setup

> **Please follow detailed [step by step guide](./Android.md) to setup Android Platform. For basic Android setup, please follow the steps below:**

#### 1. Add the Marketing Cloud SDK Repository

In `android/build.gradle`:

```groovy
allprojects {
    repositories {
        maven { url "https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/repository" }
        //... Other repositories
    }
}
```

#### 2. Adding the MarketingCloud SDK dependency

Navigate to `android/app/build.gradle` and update the `dependencies` section to include `marketingcloudsdk` dependency.

```groovy
dependencies {
    implementation "com.salesforce.marketingcloud:marketingcloudsdk:8.+"

    //rest of dependencies
}
```

#### 3. FCM credentials

1. To enable push support for the Android platform, you will need to include the google-services.json file. Download the file from your Firebase console and place it in the `android/app` directory.

2. Include the Google Services plugin in your build `YOUR_APP/android/settings.gradle`

> In case you don't have `pluginManagement` in your `settings.gradle`, add this dependency in `android/build.gradle` under `buildscript` section. if `buildscript` section not there, create it.

```groovy
pluginManagement {
    buildscript {
        repositories {
            mavenCentral()
        }
        dependencies {
            classpath 'com.google.gms:google-services:4.3.2'
        }
    }

    //REST of settings.gradle.....
}
```

3. Apply the plugin
   `android/app/build.gradle`

```groovy
// Add the google services plugin to your build.gradle file
apply plugin: 'com.google.gms.google-services'
```

#### 4. Configure the SDK in your `MainApplication.kt` class

> Note: If MainApplication.kt is not there in app. Please create the `MainApplication.kt` in your app. For more detailed setup please check [step-by-step guide](./Android.md).

```kotlin
override fun onCreate() {
    super.onCreate()
    SFMCSdk.configure(
        applicationContext,
        SFMCSdkModuleConfig.build {
            pushModuleConfig =
                MarketingCloudConfig.builder()
                    .apply {
                        //Update these details based on your MC config
                        setApplicationId("{MC_APP_ID}")
                        setAccessToken("{MC_ACCESS_TOKEN}")
                        setMarketingCloudServerUrl("{MC_APP_SERVER_URL}")
                        setSenderId("{FCM_SENDER_ID_FOR_MC_APP}")
                        setNotificationCustomizationOptions(
                            NotificationCustomizationOptions.create(
                                R.mipmap.ic_launcher
                            )
                        )
                    }
                    .build(applicationContext)
        }
    ) { initStatus ->
        when (initStatus.status) {
            InitializationStatus.SUCCESS -> Log.d("SFMC", "SFMC SDK Initialization Successful")
            InitializationStatus.FAILURE -> Log.d("SFMC", "SFMC SDK Initialization Failed")
            else -> Log.d("SFMC", "SFMC SDK Initialization Status: Unknown")
        }
    }
    // ... The rest of the onCreate method
}
```

### iOS Setup

> **Please follow detailed [step by step guide](./ios_push.md) to setup iOS Platform. For basic iOS setup please follow below steps:**

#### 1. Naviagte to the `YOUR_APP/ios` directory and open `Runner.xcworkspace`.

#### 2. Configure the SDK in your `AppDelegate` class

```objc
//AppDelegate.h ----

#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
//Other imports...

@interface AppDelegate : FlutterAppDelegate<UNUserNotificationCenterDelegate>

@end

//AppDelegate.m ----

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Configure the SFMC sdk
    PushConfigBuilder *pushConfigBuilder = [[PushConfigBuilder alloc] initWithAppId:@"{MC_APP_ID}"];
    [pushConfigBuilder setAccessToken:@"{MC_ACCESS_TOKEN}"];
    [pushConfigBuilder setMarketingCloudServerUrl:[NSURL URLWithString:@"{MC_APP_SERVER_URL}"]];
    [pushConfigBuilder setMid:@"MC_MID"];
    [pushConfigBuilder setAnalyticsEnabled:YES];

    [SFMCSdk initializeSdk:[[[SFMCSdkConfigBuilder new] setPushWithConfig:[pushConfigBuilder build] onCompletion:^(SFMCSdkOperationResult result) {
        if (result == SFMCSdkOperationResultSuccess) {
        //Enable Push
        } else {
          NSLog(@"SFMC sdk configuration failed.");
        }
    }] build]];

    // ... The rest of the didFinishLaunchingWithOptions method
}
```

#### 3. Enable Push

Follow [these instructions](./ios_push.md) to enable push for iOS.

## URL Handling

The SDK doesn’t automatically present URLs from these sources.

- CloudPage URLs from push notifications.
- OpenDirect URLs from push notifications.
- Action URLs from in-app messages.

To handle URLs from push notifications, please follow [iOS step by step guide](./ios_push.md) and [Android step by step guide](./Android.md).

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

- [SFMCSdk](#SFMCSdk)
  - [.isPushEnabled()](#SFMCSdk.isPushEnabled) ⇒ <code>Future&lt;bool?&gt;</code>
  - [.enablePush()](#SFMCSdk.enablePush) ⇒ <code>Future&lt;void&gt;</code>
  - [.disablePush()](#SFMCSdk.disablePush) ⇒ <code>Future&lt;void&gt;</code>
  - [.getSystemToken()](#SFMCSdk.getSystemToken) ⇒ <code>Future&lt;String?&gt;</code>
  - [.getAttributes()](#SFMCSdk.getAttributes) ⇒ <code>Future&lt;Map<Object?, Object?>?&gt;</code>
  - [.setAttribute(key, value)](#SFMCSdk.setAttribute) ⇒ <code>Future&lt;void&gt;</code>
  - [.clearAttribute(key)](#SFMCSdk.clearAttribute) ⇒ <code>Future&lt;void&gt;</code>
  - [.addTag(tag)](#SFMCSdk.addTag) ⇒ <code>Future&lt;void&gt;</code>
  - [.removeTag(tag)](#SFMCSdk.removeTag) ⇒ <code>Future&lt;void&gt;</code>
  - [.getTags()](#SFMCSdk.getTags) ⇒ <code>Future&lt;List<Object?>?&gt;</code>
  - [.setContactKey(contactKey)](#SFMCSdk.setContactKey) ⇒ <code>Future&lt;void&gt;</code>
  - [.getContactKey()](#SFMCSdk.getContactKey) ⇒ <code>Future&lt;String?&gt;</code>
  - [.enableLogging()](#SFMCSdk.enableLogging) ⇒ <code>Future&lt;void&gt;</code>
  - [.disableLogging()](#SFMCSdk.disableLogging) ⇒ <code>Future&lt;void&gt;</code>
  - [.logSdkState()](#SFMCSdk.logSdkState) ⇒ <code>Future&lt;void&gt;</code>
  - [.trackEvent(event)](#SFMCSdk.trackEvent) ⇒ <code>Future&lt;void&gt;</code>
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

### SFMCSdk.getAttributes() ⇒ <code>Future&lt;Map&lt;Object?, Object?&gt;?&gt;</code>

Returns the maps of attributes set in the registration.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**Returns**: <code>Future&lt;Map&lt;Object?, Object?&gt;?&gt;</code> - A future to the nullable key/value map of attributes set
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
- [iOS Docs](<https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/SFMCSdk/8.0/Classes/IDENTITY.html#/c:@M@SFMCSDK@objc(cs)SFMCSdkIDENTITY(im)addTag:>)

| Param | Type                | Description                              |
| ----- | ------------------- | ---------------------------------------- |
| tag   | <code>string</code> | The tag to be added to the registration. |

<a name="SFMCSdk.removeTag"></a>

### SFMCSdk.removeTag(tag) ⇒ <code>Future&lt;void&gt;</code>

Removes a tag from the list of tags in the registration.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/-editor/remove-tag.html)
- [iOS Docs](<https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/SFMCSdk/8.0/Classes/IDENTITY.html#/c:@M@SFMCSDK@objc(cs)SFMCSdkIDENTITY(im)removeTag:>)

| Param | Type                | Description                                  |
| ----- | ------------------- | -------------------------------------------- |
| tag   | <code>string</code> | The tag to be removed from the registration. |

<a name="SFMCSdk.getTags"></a>

### SFMCSdk.getTags() ⇒ <code>Future&lt;Set&lt;String&gt;?&gt;</code>

Returns the set of tags currently set in the registration.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**Returns**: <code>Future&lt;Set&lt;String&gt;?&gt;</code> - A future to the nullable set of strings representing the tags
currently set in the registration.  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/get-tags.html)
- [iOS Docs](<https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)tags>)

<a name="SFMCSdk.setContactKey"></a>

### SFMCSdk.setContactKey(contactKey) ⇒ <code>Future&lt;void&gt;</code>

Sets the contact key for the device's user.

**Kind**: static method of [<code>SFMCSdk</code>](#SFMCSdk)  
**See**

- [Android Docs](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/javadocs/MarketingCloudSdk/8.0/com.salesforce.marketingcloud.registration/-registration-manager/-editor/set-contact-key.html)
- [iOS Docs](<https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/appledocs/MarketingCloudSdk/8.0/Classes/PushModule.html#/c:@M@MarketingCloudSDK@objc(cs)SFMCSdkPushModule(im)setContactKey:>)

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

| Param | Type                                                                                                                                                                                                                             | Description              |
| ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| event | [<code>CustomEvent</code>](#CustomEvent) \| [<code>EngagementEvent</code>](#EngagementEvent) \| [<code>SystemEvent</code>](#SystemEvent) \| <code>CartEvent</code> \| <code>OrderEvent</code> \| <code>CatalogObjectEvent</code> | The event to be tracked. |

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
