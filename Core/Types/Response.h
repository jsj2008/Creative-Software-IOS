//
//  Created by Rene Dohan on 11/2/12.
//

@protocol RequestProtocol;

@interface Response : NSObject

@property(copy, nonatomic) void (^onSuccess)(id);
@property(copy, nonatomic) void (^onFailed)(Response <RequestProtocol> *);
@property(copy, nonatomic) void (^onDone)(void);

- (void)success:(id)data;

- (void)failed:(Response *)response;

- (void)cancel;

@property(nonatomic, readonly) BOOL canceled;

@property(nonatomic, copy) NSString *message;

- (Response *)failIfFail:(Response *)request;

- (Response *)connect:(Response *)response;

- (Response *)successIfSuccess:(Response *)response;

- (void)failedWithMessage:(NSString *)string;
@end