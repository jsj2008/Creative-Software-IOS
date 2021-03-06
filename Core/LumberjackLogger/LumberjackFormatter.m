//
// Created by inno on 1/31/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LumberjackFormatter.h"

@implementation LumberjackFormatter {
    NSDateFormatter *threadUnsafeDateFormatter;
}

- (id)init {
    if ((self = [super init])) {
        threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
        [threadUnsafeDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [threadUnsafeDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
    }
    return self;
}


- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage->logFlag) {
        case LOG_FLAG_ERROR :
            logLevel = @"Error";
            break;
        case LOG_FLAG_WARN  :
            logLevel = @"Warn";
            break;
        case LOG_FLAG_INFO  :
            logLevel = @"Info";
            break;
        default             :
            logLevel = @"Verbose";
            break;
    }

    NSString *dateAndTime = [threadUnsafeDateFormatter stringFromDate:(logMessage->timestamp)];
    return [NSString stringWithFormat:@"%@ %@ %@ %@ %i = %@\n", dateAndTime, logLevel, logMessage.fileName,
                                      logMessage.methodName, logMessage->lineNumber, logMessage->logMsg];
}
@end