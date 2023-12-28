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
        [self logSdkState];
        result(nil);
    } else if ([@"getSystemToken" isEqualToString:call.method]) {
        [self getSystemTokenWithResult:result];
    } else if ([@"enableLogging" isEqualToString:call.method]) {
        [self enableLogging];
        result(nil);
    } else if ([@"disableLogging" isEqualToString:call.method]) {
        [self disableLogging];
        result(nil);
    } else if ([@"enablePush" isEqualToString:call.method]) {
        [self enablePush];
        result(nil);
    } else if ([@"disablePush" isEqualToString:call.method]) {
        [self disablePush];
        result(nil);
    } else if ([@"isPushEnabled" isEqualToString:call.method]) {
        [self isPushEnabledWithResult:result];
    } else if ([@"getDeviceId" isEqualToString:call.method]) {
        [self getDeviceIdWithResult:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)logSdkState {
    [self splitLog:[SFMCSdk state]];
}

- (void)getSystemTokenWithResult:(FlutterResult)result {
    NSString* deviceToken = [[SFMCSdk mp] deviceToken];
    result(deviceToken);
}

- (void)enableLogging {
    [SFMCSdk setLoggerWithLogLevel:SFMCSdkLogLevelDebug logOutputter:[[SFMCSdkLogOutputter alloc] init]];
}

- (void)disableLogging {
    [SFMCSdk setLoggerWithLogLevel:SFMCSdkLogLevelFault logOutputter:[[SFMCSdkLogOutputter alloc] init]];
}

- (void)enablePush {
    [[SFMCSdk mp] setPushEnabled:YES];
}

- (void)disablePush {
    [[SFMCSdk mp] setPushEnabled:NO];
}

- (void)isPushEnabledWithResult:(FlutterResult)result {
    BOOL status = [[SFMCSdk mp] pushEnabled];
    result(@(status));
}

- (void)getDeviceIdWithResult:(FlutterResult)result {
    NSString* deviceId = [[SFMCSdk mp] deviceIdentifier];
    result(deviceId);
}

@end
