// AppDelegate.m
//
// Copyright (c) 2024 Salesforce, Inc
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer. Redistributions in binary
// form must reproduce the above copyright notice, this list of conditions and
// the following disclaimer in the documentation and/or other materials
// provided with the distribution. Neither the name of the nor the names of
// its contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <MarketingCloudSDK/MarketingCloudSDK.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.
    // Configure the SFMC sdk ...
    PushConfigBuilder *pushConfigBuilder = [[PushConfigBuilder alloc] initWithAppId:@"16586d33-807c-4e1a-9a73-feb54a5c4ad1"];
    [pushConfigBuilder setAccessToken:@"v9q3gd5ysstjrwv2vqcst296"];
    [pushConfigBuilder setMarketingCloudServerUrl:[NSURL URLWithString:@"https://mcgrjfgk81ckrt0h4rwlnbhmbvf4.device.marketingcloudapis.com/"]];
    [pushConfigBuilder setMid:@"348137931902"];
    [pushConfigBuilder setAnalyticsEnabled:YES];
    [pushConfigBuilder setInboxEnabled:YES];

    [SFMCSdk initializeSdk:[[[SFMCSdkConfigBuilder new] setPushWithConfig:[pushConfigBuilder build] onCompletion:^(
            SFMCSdkOperationResult result) {
        if (result == SFMCSdkOperationResultSuccess) {
            [self pushSetup];
        } else {
            NSLog(@"SFMC sdk configuration failed.");
        }
    }] build]];

    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)pushSetup {
    // AppDelegate adheres to the SFMCSdkURLHandlingDelegate protocol
    // and handles URLs passed back from the SDK in `sfmc_handleURL`.
    // For more information, see https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/sdk-implementation/implementation-urlhandling.html
    [SFMCSdk requestPushSdk:^(id <PushInterface> _Nonnull mp) {
        [mp setURLHandlingDelegate:self];
    }];

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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [SFMCSdk requestPushSdk:^(id <PushInterface> _Nonnull mp) {
        [mp setDeviceToken:deviceToken];
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    os_log_debug(OS_LOG_DEFAULT, "didFailToRegisterForRemoteNotificationsWithError = %@", error);
}

// The method will be called on the delegate when the user responded to the notification by opening
// the application, dismissing the notification or choosing a UNNotificationAction. The delegate
// must be set before the application returns from applicationDidFinishLaunching:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(
        void))completionHandler {
    // tell the MarketingCloudSDK about the notification
    [SFMCSdk requestPushSdk:^(id <PushInterface> _Nonnull mp) {
        [mp setNotificationRequest:response.notification.request];
    }];
    if (completionHandler != nil) {
        completionHandler();
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(
        UNNotificationPresentationOptions options))completionHandler {
    completionHandler(
            UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(
        UIBackgroundFetchResult))completionHandler {
    [SFMCSdk requestPushSdk:^(id <PushInterface> _Nonnull mp) {
        [mp setNotificationUserInfo:userInfo];
    }];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)sfmc_handleURL:(NSURL * _Nonnull)url type:(NSString * _Nonnull)type {
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(
                BOOL success) {
            if (success) {
                NSLog(@"url %@ opened successfully", url);
            } else {
                NSLog(@"url %@ could not be opened", url);
            }
        }];
    }
}

@end
