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

@end
