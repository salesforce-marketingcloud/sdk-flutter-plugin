// SfmcPlugin.m
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

#import "SfmcPlugin.h"
#import <SFMCSDK/SFMCSDK.h>
#import <MarketingCloudSDK/MarketingCloudSDK.h>
#import "NSDictionary+SFMCEvent.h"

@implementation SfmcPlugin
const int LOG_LENGTH = 800;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"sfmc"
                                     binaryMessenger:[registrar messenger]];
    SfmcPlugin* instance = [[SfmcPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    [registrar addApplicationDelegate:instance];
    
    //Add default tag.
    [SFMCSdk requestPushSdk:^(id<PushInterface> _Nonnull mp) {
        (void)[mp addTag:@"Flutter"];
    }];
}

- (void)log:(NSString *)msg {
    if (self.logger == nil) {
        self.logger = os_log_create("com.salesforce.marketingcloud.marketingcloudsdk", "Cordova");
    }
    os_log_info(self.logger, "%{public}@", msg);
}

- (void)splitLog:(NSString *)msg {
    NSInteger length = msg.length;
    for (int i = 0; i < length; i += LOG_LENGTH) {
        NSInteger rangeLength = MIN(length - i, LOG_LENGTH);
        [self log:[msg substringWithRange:NSMakeRange((NSUInteger)i, (NSUInteger)rangeLength)]];
    }
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"logSdkState" isEqualToString:call.method]) {
        [self logSdkStateWithResult:result];
    } else if ([@"getSystemToken" isEqualToString:call.method]) {
        [self getSystemTokenWithResult:result];
    } else if ([@"enableLogging" isEqualToString:call.method]) {
        [self enableLoggingWithResult:result];
    } else if ([@"disableLogging" isEqualToString:call.method]) {
        [self disableLoggingWithResult:result];
    } else if ([@"enablePush" isEqualToString:call.method]) {
        [self enablePushWithResult:result];
    } else if ([@"disablePush" isEqualToString:call.method]) {
        [self disablePushWithResult:result];
    } else if ([@"isPushEnabled" isEqualToString:call.method]) {
        [self isPushEnabledWithResult:result];
    } else if ([@"getDeviceId" isEqualToString:call.method]) {
        [self getDeviceIdWithResult:result];
    } else if ([@"setContactKey" isEqualToString:call.method]) {
        NSString* contactKey = call.arguments[@"contactKey"];
        [self setContactKey:contactKey result:result];
    } else if ([@"getContactKey" isEqualToString:call.method]) {
        [self getContactKeyWithResult:result];
    } else if ([@"addTag" isEqualToString:call.method]) {
        NSString* tag = call.arguments[@"tag"];
        [self addTag:tag result:result];
    } else if ([@"removeTag" isEqualToString:call.method]) {
        NSString* tag = call.arguments[@"tag"];
        [self removeTag:tag result:result];
    } else if ([@"getTags" isEqualToString:call.method]) {
        [self getTagsWithResult:result];
    } else if ([@"setAttribute" isEqualToString:call.method]) {
        NSDictionary* args = call.arguments;
        NSString* key = args[@"key"];
        NSString* value = args[@"value"];
        [self setAttributeWithKey:key value:value result:result];
        result(nil);
    } else if ([@"clearAttribute" isEqualToString:call.method]) {
        NSString* key = call.arguments[@"key"];
        [self clearAttributeWithKey:key result:result];
    } else if ([@"getAttributes" isEqualToString:call.method]) {
        [self getAttributesWithResult:result];
    } else if ([@"trackEvent" isEqualToString:call.method]) {
        NSDictionary* eventJson = call.arguments;
        [self trackEventWithJson:eventJson result:result];
    } else if ([@"setAnalyticsEnabled" isEqualToString:call.method]) {
        NSNumber* analyticsEnabled = call.arguments[@"analyticsEnabled"];
        [self setAnalyticsEnabled:[analyticsEnabled boolValue] result:result];
    } else if ([@"isAnalyticsEnabled" isEqualToString:call.method]) {
        [self isAnalyticsEnabledWithResult:result];
    } else if ([@"setPiAnalyticsEnabled" isEqualToString:call.method]) {
        NSNumber* analyticsEnabled = call.arguments[@"analyticsEnabled"];
        [self setPiAnalyticsEnabled:[analyticsEnabled boolValue] result:result];
    } else if ([@"isPiAnalyticsEnabled" isEqualToString:call.method]) {
        [self isPiAnalyticsEnabledWithResult:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)logSdkStateWithResult:(FlutterResult)result {
    [self splitLog:[SFMCSdk state]];
    result(nil);
}

- (void)getSystemTokenWithResult:(FlutterResult)result {
    [SFMCSdk requestPushSdk:^(id<PushInterface> mp) {
        NSString* deviceToken = [mp deviceToken];
        result(deviceToken);
    }];
}

- (void)enableLoggingWithResult:(FlutterResult)result {
    [SFMCSdk setLoggerWithLogLevel:SFMCSdkLogLevelDebug logOutputter:[[SFMCSdkLogOutputter alloc] init]];
    result(nil);
}

- (void)disableLoggingWithResult:(FlutterResult)result {
    [SFMCSdk setLoggerWithLogLevel:SFMCSdkLogLevelFault logOutputter:[[SFMCSdkLogOutputter alloc] init]];
    result(nil);
}

- (void)enablePushWithResult:(FlutterResult)result {
    [SFMCSdk requestPushSdk:^(id<PushInterface> mp) {
        [mp setPushEnabled:YES];
        result(nil);
    }];
}

- (void)disablePushWithResult:(FlutterResult)result {
    [SFMCSdk requestPushSdk:^(id<PushInterface> mp) {
        [mp setPushEnabled:NO];
        result(nil);
    }];
}

- (void)isPushEnabledWithResult:(FlutterResult)result {
    [SFMCSdk requestPushSdk:^(id<PushInterface> mp) {
        BOOL status = [mp pushEnabled];
        result(@(status));
    }];
}

- (void)getDeviceIdWithResult:(FlutterResult)result {
    [SFMCSdk requestPushSdk:^(id<PushInterface> mp) {
        NSString* deviceId =  [mp deviceIdentifier];
        result(deviceId);
    }];
}

- (void)setContactKey:(NSString* _Nonnull)contactKey result:(FlutterResult)result {
    [SFMCSdk requestPushSdk:^(id<PushInterface> mp) {
        [[SFMCSdk identity] setProfileId:contactKey];
        result(nil);
    }];
}

- (void)getContactKeyWithResult:(FlutterResult)result {
    [SFMCSdk requestPushSdk:^(id<PushInterface> mp) {
        NSString* contactKey = [mp contactKey];
        result(contactKey);
    }];
}

- (void)addTag:(NSString* _Nonnull)tag result:(FlutterResult)result {
    [SFMCSdk requestPushSdk:^(id<PushInterface> mp) {
        BOOL ignore = [mp addTag:tag];
        result(nil);
    }];
}

- (void)removeTag:(NSString* _Nonnull)tag result:(FlutterResult)result {
    [SFMCSdk requestPushSdk:^(id<PushInterface> mp) {
        BOOL ignore = [mp removeTag:tag];
        result(nil);
    }];
}

- (void)getTagsWithResult:(FlutterResult)result {
    [SFMCSdk requestPushSdk:^(id<PushInterface> mp) {
        NSArray* tags = [[mp tags] allObjects];
        result((tags != nil) ? tags : @[]);
    }];
}

- (void)setAttributeWithKey:(NSString* _Nonnull)key value:(NSString* _Nonnull)value result:(FlutterResult)result {
    [SFMCSdk requestPushSdk:^(id<PushInterface> mp) {
        [[SFMCSdk identity] setProfileAttributes:@{key: value}];
        result(nil);
    }];
}

- (void)clearAttributeWithKey:(NSString* _Nonnull)key result:(FlutterResult)result {
    [SFMCSdk requestPushSdk:^(id<PushInterface> mp) {
        [[SFMCSdk identity] clearProfileAttributeWithKey:key];
        result(nil);
    }];
}

- (void)getAttributesWithResult:(FlutterResult)result {
    [SFMCSdk requestPushSdk:^(id<PushInterface> mp) {
        NSDictionary* attributes = [mp attributes];
        result((attributes != nil) ? attributes : @{});
    }];
}

- (void)trackEventWithJson:(NSDictionary *)eventJson result:(FlutterResult)result {
    [SFMCSdk trackWithEvent:[NSDictionary SFMCEvent:eventJson]];
    result(nil);
}

- (void)setAnalyticsEnabled:(BOOL)enabled result:(FlutterResult)result {
    [SFMCSdk requestPushSdk:^(id<PushInterface> mp) {
        [mp setAnalyticsEnabled:enabled];
        result(nil);
    }];
}

- (void)isAnalyticsEnabledWithResult:(FlutterResult)result {
    [SFMCSdk requestPushSdk:^(id<PushInterface> mp) {
        BOOL isEnabled = [mp isAnalyticsEnabled];
        result(@(isEnabled));
    }];
}

- (void)setPiAnalyticsEnabled:(BOOL)enabled result:(FlutterResult)result {
    [SFMCSdk requestPushSdk:^(id<PushInterface> mp) {
        [mp setPiAnalyticsEnabled:enabled];
        result(nil);
    }];
}

- (void)isPiAnalyticsEnabledWithResult:(FlutterResult)result {
    [SFMCSdk requestPushSdk:^(id<PushInterface> mp) {
        BOOL isEnabled = [mp isPiAnalyticsEnabled];
        result(@(isEnabled));
    }];
}

// https://github.com/flutter/flutter/issues/52895
// Flutter overrides `respondToSelector` and does shady things. There is issue in flutter where `didReceiveRemoteNotification`
// not getting called on AppDelegate. This is workaround to make sure AppDeleage `didReceiveRemoteNotification` gets called.
- (BOOL)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    completionHandler(UIBackgroundFetchResultNoData);
    return YES;
}

@end
