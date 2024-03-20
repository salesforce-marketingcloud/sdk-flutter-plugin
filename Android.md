# Android step by step Guide

> **Depending on your app and Flutter version below steps may vary.**

## 1. Installation

> This plugin is compatible with Flutter version 3.3.0 and above.

To add the plugin to your application via [pub](https://pub.dev/packages/sfmc), run the following command:

```shell
flutter pub add sfmc
```

## 2. Add Marketing Cloud SDK repository

`android/build.gradle`

```groovy
allprojects {
    repositories {
        maven { url "https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/repository" }
        //... Other repos
    }
}
```

## 3. Adding the MarketingCloud SDK dependency

Navigate to `android/app/build.gradle` and update the `dependencies` section to include `marketingcloudsdk` dependency.

```groovy
dependencies {
    implementation "com.salesforce.marketingcloud:marketingcloudsdk:8.1.+"

    //rest of dependencies
}
```

## 4. Update `compileSdk/compileSdkVersion` and `minSdkVersion`

Ensure in your `android/app/build.gradle` that `compileSdk/compileSdkVersion` is `34` and `minSdkVersion` is `21`.

If not, update the `compileSdk/compileSdkVersion` and `minSdkVersion` in `android/app/build.gradle` to `34` and `21` respectively.

## 5. Update `kotlin version`

The location for specifying the `kotlin version` might differ depending on your app.

Ensure the `kotlin version` specified is equal to or above `1.9.10`.

> The Kotlin version could be specified either in `android/build.gradle` or `android/settings.gradle` depending on your Flutter app.

## 6. Provide FCM credentials

1. To enable push support for the Android platform you will need to include the `google-services.json` file. Download the file from your Firebase console and place it into the `android/app` directory

2. Include the Google Services plugin in your build
   `YOUR_APP/android/settings.gradle`

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

## 7. Update `MainApplication.kt`

> If `MainApplication.kt` is not there in your app create `MainApplication` extending `FlutterApplication` class and also update the `AndroidManifest.xml`.

```xml
// add ".MainApplication" entry in main/AndroidManifest.xml

<application android:name=".MainApplication" ...>
```

Update the `MainApplication.kt` in your app.

```kotlin
//MainApplication.kt

//YOUR_package

//rest of imports...
import android.util.Log
import com.salesforce.marketingcloud.MarketingCloudConfig
import com.salesforce.marketingcloud.notifications.NotificationCustomizationOptions
import com.salesforce.marketingcloud.sfmcsdk.InitializationStatus
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdk
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdkModuleConfig
import io.flutter.app.FlutterApplication

class MainApplication : FlutterApplication() {

    //Update onCreate
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

        //rest of onCreate...
    }

    //rest of MainApplication...
}
```

## 8. Declare the notification permission

Update the `AndroidManifest.xml` to declare the notification permission.

```xml
//AndroidManifest.xml
<manifest ...>
    //Add this line to declare the notification permission.
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    <application ...>
        ...
    </application>
</manifest>
```

## 9. URL Handling

The SDK doesn’t automatically present URLs from these sources.

- CloudPage URLs from push notifications.
- OpenDirect URLs from push notifications.
- Action URLs from in-app messages.

To handle URLs from push notifications, please follow below steps:

### Update `setNotificationCustomizationOptions`

Navigate to `MainApplication.kt` and update the `setNotificationCustomizationOptions` options to handle the url's

#### 1. Add `imports`

```kotlin
//MainApplication.kt

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import com.salesforce.marketingcloud.notifications.NotificationManager
import com.salesforce.marketingcloud.notifications.NotificationMessage

import java.util.Random
```

#### 2. Update the `setNotificationCustomizationOptions` of `SFMCSdk.configure`

```kotlin
//MainApplication.kt

setNotificationCustomizationOptions(NotificationCustomizationOptions.create { context: Context, notificationMessage: NotificationMessage ->
    NotificationManager.createDefaultNotificationChannel(context).let { channelId ->
        NotificationManager.getDefaultNotificationBuilder(
            context,
            notificationMessage,
            channelId,
            R.mipmap.ic_launcher
        ).apply {
            setContentIntent(
                NotificationManager.redirectIntentForAnalytics(
                    context,
                    getPendingIntent(context, notificationMessage),
                    notificationMessage,
                    true
                )
            )
        }
    }
})
```

#### 3. Implement the following methods in `MainApplication.kt`

```kotlin
//MainApplication.kt

private fun provideIntentFlags(): Int {
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    } else {
        PendingIntent.FLAG_UPDATE_CURRENT
    }
}

private fun getPendingIntent(
    context: Context,
    notificationMessage: NotificationMessage
): PendingIntent {
    val intent = if (notificationMessage.url.isNullOrEmpty()) {
        context.packageManager.getLaunchIntentForPackage(context.packageName)
    } else {
        Intent(Intent.ACTION_VIEW, Uri.parse(notificationMessage.url))
    }
    return PendingIntent.getActivity(context, Random().nextInt(), intent, provideIntentFlags())
}
```

Please also see additional documentation on URL Handling for [Android](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/sdk-implementation/url-handling.html).

# Troubleshooting

### Java sealed classes or Dexing problems

If you encounter errors related to `Java sealed classes` or `Dexing`, you need to add the r8 dependency to your app. For more information about this, please visit [this link](https://issuetracker.google.com/issues/290412574).

Update the `settings.gradle` to add `r8` dependency.

> In case you don't have `pluginManagement` in your `settings.gradle`, update the `buildscript` `dependencies `section of `android/build.gradle`.

```groovy
pluginManagement {
    buildscript {
        repositories {
            mavenCentral()
        }
        dependencies {
            //Add the r8 dependency
            classpath("com.android.tools:r8:8.2.42")

            //other dependencies
        }
    }
// rest of settings.gradle
}

```
