#import <Flutter/Flutter.h>
#import <os/log.h>

@interface SfmcPlugin : NSObject<FlutterPlugin>
@property(nonatomic, strong) os_log_t logger;
@end
