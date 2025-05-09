# iOS `Objective-C` step by step guide

## 1. Installation

> This plugin is compatible with Flutter version 3.3.0 and above.

To add the plugin to your application via [pub](https://pub.dev/packages/sfmc), run the following command:

```shell
flutter pub add sfmc
```

## 2. Enable Push in Capabilities

Enable push notifications in your target’s Capabilities settings in Xcode.

![push enablement](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/assets/SDKConfigure6.png)

## 3. Update the `AppDelegate`

#### 1. Naviagte to the `YOUR_APP/ios` directory and open `Runner.xcworkspace`.

#### 2. Update the `AppDelegate` to configure and enable push

Navigate to the `AppDelegate.h` and update the file.

```objc
//AppDelegate.h

#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <SFMCSDK/SFMCSDK.h>
//Other imports...

@interface AppDelegate : FlutterAppDelegate<UNUserNotificationCenterDelegate>

@end

```

Navigate to the `AppDelegate.m` and update the file.

```objc
//AppDelegate.m

#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <MarketingCloudSDK/MarketingCloudSDK.h>
//Other imports...

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //Flutter setup
    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.

    // Use the Push Config Builder to configure the Mobile Push Module. This gives you the maximum flexibility in SDK configuration.
    // The builder lets you configure the module parameters at runtime.
    PushConfigBuilder *pushConfigBuilder = [[PushConfigBuilder alloc] initWithAppId:@"{MC_APP_ID}"];
    [pushConfigBuilder setAccessToken:@"{MC_ACCESS_TOKEN}"];
    [pushConfigBuilder setMarketingCloudServerUrl:[NSURL URLWithString:@"{MC_APP_SERVER_URL}"]];
    [pushConfigBuilder setMid:@"MC_MID"];
    [pushConfigBuilder setAnalyticsEnabled:YES];

    // Once you've created the mobile push configuration, intialize the SDK.
    [SFMCSdk initializeSdk:[[[SFMCSdkConfigBuilder new] setPushWithConfig:[pushConfigBuilder build] onCompletion:^(SFMCSdkOperationResult result) {
        if (result == SFMCSdkOperationResultSuccess) {
            // module is fully configured and ready for use
            [self pushSetup];
        } else {
            NSLog(@"SFMC sdk configuration failed.");
        }
    }] build]];

    // rest of the didFinishLaunchingWithOptions method...
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)pushSetup {
    // Make sure to dispatch this to the main thread, as UNUserNotificationCenter will present UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        // Set the UNUserNotificationCenterDelegate to a class adhering to thie protocol.
        // In this exmple, the AppDelegate class adheres to the protocol (see below)
        // and handles Notification Center delegate methods from iOS.
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;

        // In any case, your application should register for remote notifications *each time* your application
        // launches to ensure that the push token used by MobilePush (for silent push) is updated if necessary.

        // Registering in this manner does *not* mean that a user will see a notification - it only means
        // that the application will receive a unique push token from iOS.
        [[UIApplication sharedApplication] registerForRemoteNotifications];

        // Request authorization from the user for push notification alerts.
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:UNAuthorizationOptionAlert |
         UNAuthorizationOptionSound |
         UNAuthorizationOptionBadge
         completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (error == nil) {
                if (granted == YES) {
                    // Your application may want to do something specific if the user has granted authorization
                    // for the notification types specified; it would be done here.
                    NSLog(@"User granted permission");
                }
            }
        }];
    });
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [SFMCSdk requestPushSdk:^(id<PushInterface> _Nonnull mp) {
        [mp setDeviceToken:deviceToken];
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    os_log_debug(OS_LOG_DEFAULT, "didFailToRegisterForRemoteNotificationsWithError = %@", error);
}

// The method will be called on the delegate when the user responded to the notification by opening
// the application, dismissing the notification or choosing a UNNotificationAction. The delegate
// must be set before the application returns from applicationDidFinishLaunching:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // tell the MarketingCloudSDK about the notification
    [SFMCSdk requestPushSdk:^(id<PushInterface> _Nonnull mp) {
        [mp setNotificationResponse:response];
    }];
    if (completionHandler != nil) {
        completionHandler();
    }
}

// The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

/** This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
 This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. **/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [SFMCSdk requestPushSdk:^(id<PushInterface> _Nonnull mp) {
        [mp setNotificationUserInfo:userInfo];
    }];
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
```

## 4. URL Handling

The SDK doesn’t automatically present URLs from these sources.

- CloudPage URLs from push notifications.
- OpenDirect URLs from push notifications.
- Action URLs from in-app messages.

To handle URLs from push notifications, please follow below steps:

### 1. Implement the `SFMCSdkURLHandlingDelegate`

Update the `AppDelegate.h` to implement `SFMCSdkURLHandlingDelegate`

```objc
// AppDelegate.h

#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <SFMCSDK/SFMCSDK.h>

//...

// Implement the SFMCSdkURLHandlingDelegate delegate
@interface AppDelegate : FlutterAppDelegate<UNUserNotificationCenterDelegate, SFMCSdkURLHandlingDelegate>

@end

```

### 2. Set the `setURLHandlingDelegate`

Update the `pushSetup` method in `AppDelegate.m` to set the `URLHandlingDelegate`.

```objc
// AppDelegate.m

- (void)pushSetup {
    // AppDelegate adheres to the SFMCSdkURLHandlingDelegate protocol
    // and handles URLs passed back from the SDK in `sfmc_handleURL`.
    // For more information, see https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/sdk-implementation/implementation-urlhandling.html
    [SFMCSdk requestPushSdk:^(id<PushInterface> _Nonnull mp) {
        [mp setURLHandlingDelegate:self];
    }];

    //rest of pushSetup...
}
```

### 3. Implement the `URLHandlingDelegate`

Implement the `URLHandlingDelegate` in the `AppDelegate.m`

```swift
// AppDelegate.m

//rest of AppDelegate.m...

/**
 This method, if implemented, can be called when a Alert+CloudPage, Alert+OpenDirect, Alert+Inbox or Inbox message is processed by the SDK.
 Implementing this method allows the application to handle the URL from Marketing Cloud data.

 Prior to the MobilePush SDK version 6.0.0, the SDK would automatically handle these URLs and present them using a SFSafariViewController.

 Given security risks inherent in URLs and web pages (Open Redirect vulnerabilities, especially), the responsibility of processing the URL shall be held by the application implementing the MobilePush SDK. This reduces risk to the application by affording full control over processing, presentation and security to the application code itself.

 @param url value NSURL sent with the Location, CloudPage, OpenDirect or Inbox message
 @param type value NSInteger enumeration of the MobilePush source type of this URL
 */
- (void)sfmc_handleURL:(NSURL * _Nonnull)url type:(NSString * _Nonnull)type {
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"url %@ opened successfully", url);
            } else {
                NSLog(@"url %@ could not be opened", url);
            }
        }];
    }
}

//rest of AppDelegate.m...
```

Please also see additional documentation on URL Handling for [iOS](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/sdk-implementation/implementation-urlhandling.html).

## 5. Integrate the MobilePush Extension SDK

The MobilePush SDK version 9.0.0 introduces two push notification features — Push Delivery events and support for Carousel template. To function properly, these features require iOS [Service Extension](https://developer.apple.com/documentation/usernotifications/unnotificationserviceextension) and [Content Extension](https://developer.apple.com/documentation/usernotificationsui/unnotificationcontentextension) added as additional targets in the main app.
Then, integrate the MobilePush iOS Extension SDK MCExtensionSDK.

>Implementing the **Service Extension** is required to enable **Push Delivery events**.    
>Implementing both the **Service Extension** and **Content Extension** is required to support **Carousel template-based Push Notifications**.

#### 1. Configure the Service Extension 
This section will guide you through setting up and configuring the Notification Service Extension for use with the MobilePush iOS Extension SDK.

 - [Add a Service Extension Target](https://developer.salesforce.com/docs/marketing/mobilepush/guide/ios-extension-sdk-integration.html#add-a-service-extension-target)
   
 - Integrate the Extension SDK with the Service Extension: Add the SDK as a dependency in your app's Podfile, follow the instructions for [Adding pods to an Xcode project](https://guides.cocoapods.org/using/using-cocoapods.html) on the CocoaPods documentation site.  

   <img width="827" alt="Screenshot 2025-04-18 at 5 11 37 PM" src="https://git.soma.salesforce.com/abhinav-mathur/sdk-flutter-plugin/assets/54985/c40aa91a-ad94-4886-8adb-e4c583588610">

   After the installation process, open the `.xcworkspace` file created by CocoaPods using Xcode.  
   **__Avoid opening .xcodeproj directly. Opening a project file instead of a workspace can lead to errors.__**
   
 - [Inherit from SFMCNotificationService](https://developer.salesforce.com/docs/marketing/mobilepush/guide/ios-extension-sdk-integration.html#inherit-from-sfmcnotificationservice)
   
 - [Additional Configuration](https://developer.salesforce.com/docs/marketing/mobilepush/guide/ios-extension-sdk-integration.html#additional-configuration-options)

#### 2. Configure the Content Extension 
This section will guide you through setting up and configuring the Notification Content Extension for use with the MobilePush iOS Extension SDK.
- [Add a Content Extension Target](https://developer.salesforce.com/docs/marketing/mobilepush/guide/ios-extension-sdk-integration.html#add-a-content-extension-target)
  
- Integrate the Extension SDK with Your Content Extension: The process for integrating the MCExtensionSDK into your Content Extension mirrors the steps taken for integration with your Service Extension.

- [Inherit from SFMCNotificationViewController](https://developer.salesforce.com/docs/marketing/mobilepush/guide/ios-extension-sdk-integration.html#inherit-from-sfmcnotificationviewcontroller)
  
- [Project and Info.plist Configuration](https://developer.salesforce.com/docs/marketing/mobilepush/guide/ios-extension-sdk-integration.html#project-and-infoplist-configuration)
  
- [Additional Configuration](https://developer.salesforce.com/docs/marketing/mobilepush/guide/ios-extension-sdk-integration.html#additional-configuration)

#### 3. [Enable App Groups Capability](https://developer.salesforce.com/docs/marketing/mobilepush/guide/ios-extension-sdk-integration.html#enable-app-groups-capability) 

## 6. Enable Rich Notifications (Optional)

Rich notifications include images, videos, titles and subtitles from the MobilePush app, and mutable content. Mutable content can include personalization in the title, subtitle, or body of your message.

### Create a Notification Service Extension
Skip the setup steps if you've already integrated Notification Service Extension during the [MobilePush Extension SDK integration](#5-integrate-the-mobilepush-extension-sdk) and refer the [sample code for integration with Extension SDK](#with-Extension-SDK-Integration).

1.  In Xcode, click **File**
2.  Click **New**
3.  Click **Target**
4.  Select Notification Service Extension
5.  Name and save the new extension

> The Notification Target must be signed with the same Xcode Managed Profile as the main project.

This service extension checks for a “\_mediaUrl” element in request.content.userInfo. If found, the extension attempts to download the media from the URL , creates a thumbnail-size version, and then adds the attachment. The service extension also checks for a ““\_mediaAlt” element in request.content.userInfo. If found, the service extension uses the element for the body text if there are any problems downloading or creating the media attachment.

A service extension can timeout when it is unable to download. In this code sample, the service extension delivers the original content with the body text changed to the value in “\_mediaAlt”.

#### **<ins>Without Extension SDK Integration</ins>**
```objc
#import <CoreGraphics/CoreGraphics.h>
#import "NotificationService.h"

@interface NotificationService ()

@property(nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property(nonatomic, strong) UNMutableNotificationContent *modifiedNotificationContent;

@end

@implementation NotificationService

- (UNNotificationAttachment *)createMediaAttachment:(NSURL *)localMediaUrl {
    // options: specify what cropping rectangle of the media to use for a thumbnail
    //          whether the thumbnail is hidden or not
    UNNotificationAttachment *mediaAttachment = [UNNotificationAttachment
        attachmentWithIdentifier:@"attachmentIdentifier"
                            URL:localMediaUrl
                        options:@{
                            UNNotificationAttachmentOptionsThumbnailClippingRectKey :
                                (NSDictionary *)CFBridgingRelease(
                                    CGRectCreateDictionaryRepresentation(CGRectZero)),
                            UNNotificationAttachmentOptionsThumbnailHiddenKey : @NO
                        }
                        error:nil];
    return mediaAttachment;
}

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request
                withContentHandler:(void (^)(UNNotificationContent *_Nonnull))contentHandler {
    // save the completion handler we will call back later
    self.contentHandler = contentHandler;

    // make a copy of the notification so we can change it
    self.modifiedNotificationContent = [request.content mutableCopy];

    // alternative text to display if there are any issues loading the media URL
    NSString *mediaAltText = request.content.userInfo[@"_mediaAlt"];

    // does the payload contains a remote URL to download or a local URL?
    NSString *mediaUrlString = request.content.userInfo[@"_mediaUrl"];
    NSURL *mediaUrl = [NSURL URLWithString:mediaUrlString];

    // if we have a URL, try to download media (i.e.,
    // https://media.giphy.com/media/3oz8xJBbCpzG9byZmU/giphy.gif)
    if (mediaUrl != nil) {
        // create a session to handle downloading of the URL
        NSURLSession *session = [NSURLSession
            sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

        // start a download task to handle the download of the media
        __weak __typeof__(self) weakSelf = self;
        [[session
            downloadTaskWithURL:mediaUrl
            completionHandler:^(NSURL *_Nullable location, NSURLResponse *_Nullable response,
                                NSError *_Nullable error) {
                BOOL useAlternateText = YES;

                // if the download succeeded, save it locally and then make an attachment
                if (error == nil) {
                    if (200 <= ((NSHTTPURLResponse *)response).statusCode &&
                        ((NSHTTPURLResponse *)response).statusCode <= 299) {
                        // download was successful, attempt save the media file
                        NSURL *localMediaUrl = [NSURL
                            fileURLWithPath:[location.path
                                                stringByAppendingString:mediaUrl
                                                                            .lastPathComponent]];

                        // remove any existing file with the same name
                        [[NSFileManager defaultManager] removeItemAtURL:localMediaUrl error:nil];

                        // move the downloaded file from the temporary location to a new file
                        if ([[NSFileManager defaultManager] moveItemAtURL:location
                                                                    toURL:localMediaUrl
                                                                    error:nil] == YES) {
                            // create an attachment with the new file
                            UNNotificationAttachment *mediaAttachment =
                                [weakSelf createMediaAttachment:localMediaUrl];

                            // if no problems creating the attachment, we can use it
                            if (mediaAttachment != nil) {
                                // set the media to display in the notification
                                weakSelf.modifiedNotificationContent.attachments =
                                    @[ mediaAttachment ];

                                // everything is ok
                                useAlternateText = NO;
                            }
                        }
                    }
                }

                // if any problems creating the attachment, use the alternate text if provided
                if ((useAlternateText == YES) && (mediaAltText != nil)) {
                    weakSelf.modifiedNotificationContent.body = mediaAltText;
                }

                // tell the OS we are done and here is the new content
                weakSelf.contentHandler(weakSelf.modifiedNotificationContent);
            }] resume];
    } else {
        // see if the media URL is for a local file  (i.e., file://movie.mp4)
        BOOL useAlternateText = YES;
        if (mediaUrlString != nil) {
            // attempt to create a URL to a file in local storage
            NSURL *localMediaUrl =
                [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                        pathForResource:mediaUrlString.lastPathComponent
                                                            .stringByDeletingLastPathComponent
                                                    ofType:mediaUrlString.pathExtension]];

            // is the URL a local file URL?
            if (localMediaUrl != nil && localMediaUrl.isFileURL == YES) {
                // create an attachment with the local media
                UNNotificationAttachment *mediaAttachment =
                    [self createMediaAttachment:localMediaUrl];

                // if no problems creating the attachment, we can use it
                if (mediaAttachment != nil) {
                    // set the media to display in the notification
                    self.modifiedNotificationContent.attachments = @[ mediaAttachment ];

                    // everything is ok
                    useAlternateText = NO;
                }
            }
        }

        // if any problems creating the attachment, use the alternate text if provided
        if ((useAlternateText == YES) && (mediaAltText != nil)) {
            self.modifiedNotificationContent.body = mediaAltText;
        }

        // tell the OS we are done and here is the new content
        contentHandler(self.modifiedNotificationContent);
    }
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the
    // original push payload will be used.

    // we took too long to download the media URL, use the alternate text if provided
    NSString *mediaAltText = self.modifiedNotificationContent.userInfo[@"_mediaAlt"];
    if (mediaAltText != nil) {
        self.modifiedNotificationContent.body = mediaAltText;
    }

    // tell the OS we are done and here is the new content
    self.contentHandler(self.modifiedNotificationContent);
}

@end
```

#### **<ins>With Extension SDK Integration</ins>**
```objc
#import "NotificationService.h"

@implementation NotificationService

// Provide SFNotificationServiceConfig configuration
- (SFMCNotificationServiceConfig *)sfmcProvideConfig {
    SFMCExtensionSdkLogLevel logLevel = SFMCExtensionSdkLogLevelNone;
#if DEBUG
    logLevel = SFMCExtensionSdkLogLevelDebug;
#endif
    return [[SFMCNotificationServiceConfig alloc] initWithLogLevel: logLevel];
}

// Custom processing when notification is received
-(void)sfmcDidReceiveRequest:(UNNotificationRequest *)request mutableContent:(UNMutableNotificationContent *)mutableContent withContentHandler:(void (^)(NSDictionary * _Nullable))contentHandler {
    
    [self addMediaToContent:mutableContent completion:^{
        contentHandler(nil);
    }];
}

// Download and attach media
- (void)addMediaToContent:(UNMutableNotificationContent *)mutableContent
               completion:(void (^)(void))completion {
    
    NSString *mediaUrlString = mutableContent.userInfo[@"_mediaUrl"];
    if (mediaUrlString == nil || mediaUrlString.length == 0) {
        completion();
        return;
    }
    
    NSURL *mediaUrl = [NSURL URLWithString:mediaUrlString];
    if (!mediaUrl) {
        completion();
        return;
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:mediaUrl
                                                        completionHandler:^(NSURL * _Nullable location,
                                                                            NSURLResponse * _Nullable response,
                                                                            NSError * _Nullable error) {
        if (error) {
            completion();
            return;
        }
        
        if (!location || ![response isKindOfClass:[NSHTTPURLResponse class]]) {
            completion();
            return;
        }
        
        NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
        if (statusCode < 200 || statusCode > 299) {
            completion();
            return;
        }
        
        NSString *fileName = mediaUrl.lastPathComponent;
        NSString *destinationPath = [[location.path stringByAppendingString:fileName] copy];
        NSURL *localMediaUrl = [NSURL fileURLWithPath:destinationPath];
        
        [[NSFileManager defaultManager] removeItemAtURL:localMediaUrl error:nil];
        
        NSError *fileError;
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:localMediaUrl error:&fileError];
        if (fileError) {
            completion();
            return;
        }
        
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"SomeAttachmentId"
                                                                                              URL:localMediaUrl
                                                                                          options:nil
                                                                                            error:nil];
        if (attachment) {
            mutableContent.attachments = @[attachment];
        }
        
        completion();
    }];
    
    [downloadTask resume];
}

@end
```

> If you get any errors after this step please check Troubleshooting section below.

### Troubleshooting

#### Resolving Cycle Error in Flutter Xcode Project

If you encounter a cycle error in your Flutter Xcode project after adding a Notification Service Extension, follow these steps to fix it:

1. Navigate to YOUR_APP_TARGET in Xcode.
2. With your app target selected, go to the "Build Phases" tab.
3. Find the `Embed Foundation Extension`.
4. Drag and position it above both `Thin Binary` and `Embed Pods Frameworks`.

This reordering should resolve the cycle error.
