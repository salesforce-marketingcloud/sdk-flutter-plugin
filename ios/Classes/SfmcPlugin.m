#import "SfmcPlugin.h"
#import <SFMCSDK/SFMCSDK.h>
#import <MarketingCloudSDK/MarketingCloudSDK.h>

@implementation SfmcPlugin
const int LOG_LENGTH = 800;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"sfmc"
            binaryMessenger:[registrar messenger]];
  SfmcPlugin* instance = [[SfmcPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
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
        [self setContactKey:contactKey];
        result(nil);
    } else if ([@"getContactKey" isEqualToString:call.method]) {
        [self getContactKeyWithResult:result];
    } else if ([@"addTag" isEqualToString:call.method]) {
        NSString* tag = call.arguments[@"tag"];
        [self addTag:tag];
        result(nil);
    } else if ([@"removeTag" isEqualToString:call.method]) {
        NSString* tag = call.arguments[@"tag"];
        [self removeTag:tag];
        result(nil);
    } else if ([@"getTags" isEqualToString:call.method]) {
        [self getTagsWithResult:result];
    } else if ([@"setAttribute" isEqualToString:call.method]) {
        NSDictionary* args = call.arguments;
        NSString* name = args[@"key"];
        NSString* value = args[@"value"];
        [self setAttributeWithName:name value:value];
        result(nil);
    } else if ([@"clearAttribute" isEqualToString:call.method]) {
        NSString* name = call.arguments[@"key"];
        [self clearAttributeWithName:name];
        result(nil);
    } else if ([@"getAttributes" isEqualToString:call.method]) {
        [self getAttributesWithResult:result];
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

- (void)setContactKey:(NSString* _Nonnull)contactKey {
    [[SFMCSdk identity] setProfileId:contactKey];
}

- (void)getContactKeyWithResult:(FlutterResult)result {
    NSString* contactKey = [[SFMCSdk mp] contactKey];
    result(contactKey);
}

- (void)addTag:(NSString* _Nonnull)tag {
    [[SFMCSdk mp] addTag:tag];
}

- (void)removeTag:(NSString* _Nonnull)tag {
    [[SFMCSdk mp] removeTag:tag];
}

- (void)getTagsWithResult:(FlutterResult)result {
    NSArray* tags = [[[SFMCSdk mp] tags] allObjects];
    result(tags);
}

- (void)setAttributeWithName:(NSString* _Nonnull)name value:(NSString* _Nonnull)value {
    [[SFMCSdk identity] setProfileAttributes:@{name: value}];
}

- (void)clearAttributeWithName:(NSString* _Nonnull)name {
    [[SFMCSdk identity] clearProfileAttributeWithKey:name];
}

- (void)getAttributesWithResult:(FlutterResult)result {
    NSDictionary* attributes = [[SFMCSdk mp] attributes];
    result((attributes != nil) ? attributes : @{});
}

@end
