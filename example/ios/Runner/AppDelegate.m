#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <MarketingCloudSDK/MarketingCloudSDK.h>
#import <SFMCSDK/SFMCSDK.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.
    // Configure the SFMC sdk ...
    PushConfigBuilder *pushConfigBuilder = [[PushConfigBuilder alloc] initWithAppId:@"{MC_APP_ID}"];
    [pushConfigBuilder setAccessToken:@"{MC_ACCESS_TOKEN}"];
    [pushConfigBuilder setMarketingCloudServerUrl:[NSURL URLWithString:@"{MC_APP_SERVER_URL}"]];
    [pushConfigBuilder setMid:@"MC_MID"];
    [pushConfigBuilder setAnalyticsEnabled:YES];

    [SFMCSdk initializeSdk:[[[SFMCSdkConfigBuilder new] setPushWithConfig:[pushConfigBuilder build] onCompletion:^(SFMCSdkOperationResult result) {
      if (result == SFMCSdkOperationResultSuccess) {
        [self pushSetup];
      } else {
        // SFMC sdk configuration failed.
        NSLog(@"SFMC sdk configuration failed.");
      }
    }] build]];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)pushSetup {
  dispatch_async(dispatch_get_main_queue(), ^{
    // set the UNUserNotificationCenter delegate - the delegate must be set here in
    // didFinishLaunchingWithOptions
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    [[UNUserNotificationCenter currentNotificationCenter]
     requestAuthorizationWithOptions:UNAuthorizationOptionAlert |
     UNAuthorizationOptionSound |
     UNAuthorizationOptionBadge
     completionHandler:^(BOOL granted, NSError *_Nullable error) {
      if (error == nil) {
        if (granted == YES) {
          NSLog(@"User granted permission");
        }
      }
    }];
  });
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [SFMCSdk requestPushSdk:^(id<PushInterface> _Nonnull mp) {
        [mp setDeviceToken:deviceToken];
    }];
}

- (void)application:(UIApplication *)application
    didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    os_log_debug(OS_LOG_DEFAULT, "didFailToRegisterForRemoteNotificationsWithError = %@", error);
}

// The method will be called on the delegate when the user responded to the notification by opening
// the application, dismissing the notification or choosing a UNNotificationAction. The delegate
// must be set before the application returns from applicationDidFinishLaunching:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
    didReceiveNotificationResponse:(UNNotificationResponse *)response
             withCompletionHandler:(void (^)(void))completionHandler {
    // tell the MarketingCloudSDK about the notification
    [SFMCSdk requestPushSdk:^(id<PushInterface> _Nonnull mp) {
        [mp setNotificationRequest:response.notification.request];
    }];
    if (completionHandler != nil) {
        completionHandler();
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:
             (void (^)(UNNotificationPresentationOptions options))completionHandler {
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert |
                      UNAuthorizationOptionBadge);
}

- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo
          fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [SFMCSdk requestPushSdk:^(id<PushInterface> _Nonnull mp) {
        [mp setNotificationUserInfo:userInfo];
    }];
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
