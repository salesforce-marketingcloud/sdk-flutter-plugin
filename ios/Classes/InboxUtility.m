#import "InboxUtility.h"

@implementation InboxUtility

- (NSMutableArray

<NSDictionary *> *)processInboxMessages:(NSArray<NSDictionary *> *)inboxMessages {
    NSMutableArray < NSDictionary * > *updatedMessages = [NSMutableArray array];

    for (NSDictionary *message in inboxMessages) {
        NSMutableDictionary *updatedMessage = [message mutableCopy];
        [self convertDatesInMessage:updatedMessage];
        [self convertFlagsInMessage:updatedMessage];
        [self convertCustomDataInMessage:updatedMessage];
        [updatedMessages addObject:updatedMessage];
    }

    return updatedMessages;
}

- (void)convertDatesInMessage:(NSMutableDictionary *)message {
    [self convertDateField:@"startDateUtc" inMessage:message];
    [self convertDateField:@"sendDateUtc" inMessage:message];
}

- (void)convertDateField:(NSString *)field inMessage:(NSMutableDictionary *)message {
    if ([message[field] isKindOfClass:[NSDate class]]) {
        NSDate *date = message[field];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateString = [dateFormatter stringFromDate:date];
        message[field] = dateString;
    }
}

- (void)convertFlagsInMessage:(NSMutableDictionary *)message {
    message[@"deleted"] = @([message[@"deleted"] boolValue]);
    message[@"read"] = @([message[@"read"] boolValue]);
}

- (void)convertCustomDataInMessage:(NSMutableDictionary *)message {
    id customData = message[@"custom"];
    if (!customData || customData == [NSNull null]) {
        customData = @{};
    }

    if ([customData isKindOfClass:[NSDictionary class]]) {
        NSError *jsonError;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:customData options:NSJSONWritingPrettyPrinted error:&jsonError];
        if (jsonData) {
            NSString *customString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            message[@"custom"] = customString;
        } else {
            NSLog(@"Error converting custom dictionary to JSON string: %@",
                  jsonError.localizedDescription);
            message[@"custom"] = @"";
        }
    } else {
        NSLog(@"Custom data is not a valid NSDictionary object");
        message[@"custom"] = @"";
    }
}

@end
