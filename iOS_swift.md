# iOS `Swift` step by step guide

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

Navigate to the `AppDelegate.swift` and update the file.

```swift
//AppDelegate.swift

import UIKit
import Flutter
import SFMCSDK
import MarketingCloudSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    // The appID, accessToken and appEndpoint are required values for MobilePush SDK Module configuration and are obtained from your MobilePush app.
    // See https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/get-started/get-started-setupapps.html for more information.
    let appID = "<your appID here>"
    let accessToken = "<your accessToken here>"
    let appEndpointURL = "<your appEndpoint here>"
    let mid = "<your account MID here>"
    // Define features of MobilePush your app will use.
    let analytics = true

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        //Add this line to configure the SFMC sdk on App Launch
        self.configureSDK()

        // rest of the didFinishLaunchingWithOptions method...
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // SDK: REQUIRED IMPLEMENTATION
    func configureSDK() {
        let appEndpoint = URL(string: appEndpointURL)!

        // Use the Mobile Push Config Builder to configure the Mobile Push Module. This gives you the maximum flexibility in SDK configuration.
        // The builder lets you configure the module parameters at runtime.
        let mobilePushConfiguration = PushConfigBuilder(appId: appID)
            .setAccessToken(accessToken)
            .setMarketingCloudServerUrl(appEndpoint)
            .setMid(mid)
            .setAnalyticsEnabled(analytics)
            .build()

        // Set the completion handler to take action when module initialization is completed. The result indicates if initialization was sucesfull or not.
        // Seting the completion handler is optional.
        let completionHandler: (OperationResult) -> () = { result in
            if result == .success {
                // module is fully configured and ready for use
                self.setupMobilePush()
            } else {
                print("SFMC sdk configuration failed.");
            }
        }

        // Once you've created the mobile push configuration, intialize the SDK.
        SFMCSdk.initializeSdk(ConfigBuilder().setPush(config: mobilePushConfiguration, onCompletion: completionHandler).build())
    }

    func setupMobilePush() {
        // Make sure to dispatch this to the main thread, as UNUserNotificationCenter will present UI.
        DispatchQueue.main.async {
            // Set the UNUserNotificationCenterDelegate to a class adhering to thie protocol.
            // In this exmple, the AppDelegate class adheres to the protocol (see below)
            // and handles Notification Center delegate methods from iOS.
            UNUserNotificationCenter.current().delegate = self

            // Request authorization from the user for push notification alerts.
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {(_ granted: Bool, _ error: Error?) -> Void in
                if error == nil {
                    if granted == true {
                        // Your application may want to do something specific if the user has granted authorization
                        // for the notification types specified; it would be done here.
                    }
                }
            })

            // In any case, your application should register for remote notifications *each time* your application
            // launches to ensure that the push token used by MobilePush (for silent push) is updated if necessary.

            // Registering in this manner does *not* mean that a user will see a notification - it only means
            // that the application will receive a unique push token from iOS.
            UIApplication.shared.registerForRemoteNotifications()
        }
    }


    // MobilePush SDK: REQUIRED IMPLEMENTATION
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SFMCSdk.requestPushSdk { mp in
            mp.setDeviceToken(deviceToken)
        }
    }

    // MobilePush SDK: REQUIRED IMPLEMENTATION
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }

    // MobilePush SDK: REQUIRED IMPLEMENTATION
    /** This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
     This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. **/
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        SFMCSdk.requestPushSdk { mp in
            mp.setNotificationUserInfo(userInfo)
        }
        completionHandler(.newData)
    }


        // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        // Required: tell the MarketingCloudSDK about the notification. This will collect MobilePush analytics
        // and process the notification on behalf of your application.
        SFMCSdk.requestPushSdk { mp in
            mp.setNotificationRequest(response.notification.request)
        }

        completionHandler()
    }

    // The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
    override  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler(.alert)
    }
}


```

## 4. URL Handling

The SDK doesn’t automatically present URLs from these sources.

- CloudPage URLs from push notifications.
- OpenDirect URLs from push notifications.
- Action URLs from in-app messages.

To handle URLs from push notifications, please follow below steps:

### 1. Set the `setURLHandlingDelegate`

Update the `setupMobilePush` method in `AppDelegate.swift` to set the `URLHandlingDelegate`.

```swift
func setupMobilePush() {
    // Set the URLHandlingDelegate to a class adhering to the protocol.
    // In this example, the AppDelegate class adheres to the protocol (see below)
    // and handles URLs passed back from the SDK.
    // For more information, see https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/sdk-implementation/implementation-urlhandling.html
    SFMCSdk.requestPushSdk { mp in
        mp.setURLHandlingDelegate(self)
    }

    //rest of setupMobilePush...
}
```

### 2. Implement the `URLHandlingDelegate`

Implement the `URLHandlingDelegate` and add the following code at the end of `AppDelegate.swift`

```swift
// AppDelegate.swift

//rest of AppDelegate.swift...

// MobilePush SDK: REQUIRED IMPLEMENTATION
extension AppDelegate: URLHandlingDelegate {
    /**
     This method, if implemented, can be called when a Alert+CloudPage, Alert+OpenDirect, Alert+Inbox or Inbox message is processed by the SDK.
     Implementing this method allows the application to handle the URL from Marketing Cloud data.

     Prior to the MobilePush SDK version 6.0.0, the SDK would automatically handle these URLs and present them using a SFSafariViewController.

     Given security risks inherent in URLs and web pages (Open Redirect vulnerabilities, especially), the responsibility of processing the URL shall be held by the application implementing the MobilePush SDK. This reduces risk to the application by affording full control over processing, presentation and security to the application code itself.

     @param url value NSURL sent with the Location, CloudPage, OpenDirect or Inbox message
     @param type value NSInteger enumeration of the MobilePush source type of this URL
     */
    func sfmc_handleURL(_ url: URL, type: String) {
        // Very simply, send the URL returned from the MobilePush SDK to UIApplication to handle correctly.
        UIApplication.shared.open(url,
                                  options: [:],
                                  completionHandler: {
            (success) in
            print("Open \(url): \(success)")
        })
    }
}
```

Please also see additional documentation on URL Handling for [iOS](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/sdk-implementation/implementation-urlhandling.html).

## 5. Enable Rich Notifications (Optional):

**Enable Rich Notifications:** Rich notifications include images, videos, titles and subtitles from the MobilePush app, and mutable content. Mutable content can include personalization in the title, subtitle, or body of your message.

1.  In Xcode, click **File**
2.  Click **New**
3.  Click **Target**
4.  Select Notification Service Extension
5.  Name and save the new extension

This service extension checks for a “\_mediaUrl” element in request.content.userInfo. If found, the extension attempts to download the media from the URL , creates a thumbnail-size version, and then adds the attachment. The service extension also checks for a ““\_mediaAlt” element in request.content.userInfo. If found, the service extension uses the element for the body text if there are any problems downloading or creating the media attachment.

A service extension can timeout when it is unable to download. In this code sample, the service extension delivers the original content with the body text changed to the value in “\_mediaAlt”.

```swift
import CoreGraphics
import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((_ contentToDeliver: UNNotificationContent) -> Void)? = nil
    var modifiedNotificationContent: UNMutableNotificationContent?

    func createMediaAttachment(_ localMediaUrl: URL) -> UNNotificationAttachment {
        // options: specify what cropping rectangle of the media to use for a thumbnail
        //          whether the thumbnail is hidden or not
        let clippingRect = CGRect.zero
        let mediaAttachment = try? UNNotificationAttachment(identifier: "attachmentIdentifier", url: localMediaUrl, options: [UNNotificationAttachmentOptionsThumbnailClippingRectKey: clippingRect.dictionaryRepresentation, UNNotificationAttachmentOptionsThumbnailHiddenKey: false])
        return mediaAttachment!
    }

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {

        // save the completion handler we will call back later
        self.contentHandler = contentHandler

        // make a copy of the notification so we can change it
        modifiedNotificationContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        // does the payload contains a remote URL to download or a local URL?
        if let mediaUrlString = request.content.userInfo["_mediaUrl"] as? String {
            // see if the media URL is for a local file  (i.e., file://movie.mp4)
            guard let mediaUrl = URL(string: mediaUrlString) else {
                // attempt to create a URL to a file in local storage
                var useAlternateText: Bool = true
                if mediaUrlString.isEmpty == false {
                    let mediaUrlFilename:NSString = mediaUrlString as NSString
                    let fileName = (mediaUrlFilename.lastPathComponent as NSString).deletingPathExtension
                    let fileExtension = (mediaUrlFilename.lastPathComponent as NSString).pathExtension

                    // is it in the bundle?
                    if let localMediaUrlPath = Bundle.main.path(forResource: fileName, ofType: fileExtension) {
                        // is the URL a local file URL?
                        let localMediaUrl = URL.init(fileURLWithPath: localMediaUrlPath)
                        if localMediaUrl.isFileURL == true {
                            // create an attachment with the local media
                            let mediaAttachment: UNNotificationAttachment? = createMediaAttachment(localMediaUrl)

                            // if no problems creating the attachment, we can use it
                            if mediaAttachment != nil {
                                // set the media to display in the notification
                                modifiedNotificationContent?.attachments = [mediaAttachment!]

                                // everything is ok
                                useAlternateText = false
                            }
                        }
                    }
                }

                // if any problems creating the attachment, use the alternate text if provided
                if (useAlternateText == true) {
                    if let mediaAltText = request.content.userInfo["_mediaAlt"] as? String {
                        if mediaAltText.isEmpty == false {
                            modifiedNotificationContent?.body = mediaAltText
                        }
                    }
                }

                // tell the OS we are done and here is the new content
                contentHandler(modifiedNotificationContent!)
                return
            }

            // if we have a URL, try to download media (i.e., https://media.giphy.com/media/3oz8xJBbCpzG9byZmU/giphy.gif)
            if mediaUrl.isFileURL == false {
                // create a session to handle downloading of the URL
                let session = URLSession(configuration: URLSessionConfiguration.default)

                // start a download task to handle the download of the media
                weak var weakSelf: NotificationService? = self
                session.downloadTask(with: mediaUrl, completionHandler: {(_ location: URL?, _ response: URLResponse?, _ error: Error?) -> Void in
                    var useAlternateText: Bool = true
                    // if the download succeeded, save it locally and then make an attachment
                    if error == nil {
                        let downloadResponse = response as! HTTPURLResponse
                        if (downloadResponse.statusCode >= 200 && downloadResponse.statusCode <= 299) {
                            // download was successful, attempt save the media file
                            let localMediaUrl = URL.init(fileURLWithPath: location!.path + mediaUrl.lastPathComponent)

                            // remove any existing file with the same name
                            try? FileManager.default.removeItem(at: localMediaUrl)

                            // move the downloaded file from the temporary location to a new file
                            if ((try? FileManager.default.moveItem(at: location!, to: localMediaUrl)) != nil) {
                                // create an attachment with the new file
                                let mediaAttachment: UNNotificationAttachment? = weakSelf?.createMediaAttachment(localMediaUrl)

                                // if no problems creating the attachment, we can use it
                                if mediaAttachment != nil {
                                    // set the media to display in the notification
                                    weakSelf?.modifiedNotificationContent?.attachments = [mediaAttachment!]

                                    // everything is ok
                                    useAlternateText = false
                                }
                            }
                        }
                    }

                    // if any problems creating the attachment, use the alternate text if provided
                    // alternative text to display if there are any issues loading the media URL
                    if (useAlternateText == true) {
                        if let mediaAltText = request.content.userInfo["_mediaAlt"] as? String {
                            if mediaAltText.isEmpty == false {
                                weakSelf?.modifiedNotificationContent?.body = mediaAltText
                            }
                        }
                    }

                    // tell the OS we are done and here is the new content
                    weakSelf?.contentHandler!((weakSelf?.modifiedNotificationContent)!)
                }).resume()
            }
        }
        else {
            // no media URL found in the payload, just pass on the orginal payload
            contentHandler(request.content)
            return
        }
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        // we took too long to download the media URL, use the alternate text if provided

        if let mediaAltText = modifiedNotificationContent?.userInfo["_mediaAlt"] as? String {
            // alternative text to display if there are any issues loading the media URL
            if mediaAltText.isEmpty == false {
                modifiedNotificationContent?.body = mediaAltText
            }
        }

        // tell the OS we are done and here is the new content
        contentHandler!(modifiedNotificationContent!)
    }
}
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
