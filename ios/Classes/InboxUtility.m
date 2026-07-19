#import "InboxUtility.h"

@implementation InboxUtility

- (NSMutableArray<NSDictionary *> *)processInboxMessages:(NSArray<NSDictionary *> *)inboxMessages {
    NSMutableArray<NSDictionary *> *updatedMessages = [NSMutableArray array];

    for (NSDictionary *message in inboxMessages) {
        NSMutableDictionary *updatedMessage = [message mutableCopy];
        [self convertDatesInMessage:updatedMessage];
        [self convertFlagsInMessage:updatedMessage];
        [self convertCustomObjectInMessage:updatedMessage];
        [updatedMessages addObject:updatedMessage];
    }

    return updatedMessages;
}

- (NSString *)convertDictionaryToJSONString:(NSDictionary *)dictionary {
    if (![NSJSONSerialization isValidJSONObject:dictionary]) {
        NSLog(@"Error converting dictionary to JSON string: dictionary contains values that cannot be serialized to JSON");
        return nil;
    }
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
    if (jsonData) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        NSLog(@"Error converting dictionary to JSON string: %@", jsonError.localizedDescription);
        return nil;
    }
}

// Shared formatter with a fixed locale, timezone and pattern so the emitted
// string is always ISO-8601 UTC, regardless of the device locale, calendar or
// 12/24-hour setting (see Apple QA1480), and matches the Android plugin output.
+ (NSDateFormatter *)utcDateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    });
    return dateFormatter;
}

- (void)convertDatesInMessage:(NSMutableDictionary *)message {
    // Convert every NSDate in the message (not just the known
    // startDateUtc/sendDateUtc/endDateUtc keys) so a date field added by a
    // future SDK version can never reach NSJSONSerialization unconverted.
    for (NSString *field in [message allKeys]) {
        [self convertDateField:field inMessage:message];
    }
}

- (void)convertDateField:(NSString *)field inMessage:(NSMutableDictionary *)message {
    if ([message[field] isKindOfClass:[NSDate class]]) {
        NSDate *date = message[field];
        NSString *dateString = [[InboxUtility utcDateFormatter] stringFromDate:date];
        message[field] = dateString;
    }
}

- (void)convertFlagsInMessage:(NSMutableDictionary *)message {
    message[@"deleted"] = @([message[@"deleted"] boolValue]);
    message[@"read"] = @([message[@"read"] boolValue]);
}

- (void)convertCustomObjectInMessage:(NSMutableDictionary *)message {
    id customObject = message[@"custom"];
    if (!customObject || customObject == [NSNull null]) {
        customObject = @{};
    }

    if ([customObject isKindOfClass:[NSDictionary class]] &&
        [NSJSONSerialization isValidJSONObject:customObject]) {
        NSError *jsonError;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:customObject options:NSJSONWritingPrettyPrinted error:&jsonError];
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
