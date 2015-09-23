//
//  ManagedStats.h
//  Pods
//
//  Created by Bob Pascazio on 9/11/15.
//
//

#import <Foundation/Foundation.h>

@protocol ManagedStatsProtocol <NSObject, UIWebViewDelegate>

@required

- (void)loginStatus:(BOOL)result;
- (void)signupStatus:(BOOL)result;
- (void)deviceTokenSendStatus:(BOOL)result;

@end

@interface ManagedStats : NSObject

@property (weak, nonatomic) id <ManagedStatsProtocol> delegate;
@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *apiKey;

- (id)initWithAppKey:(NSString*)appKey apiKey:(NSString*)key;
- (void)recordRun;
- (void)storeDeviceTokenLocally:(NSData *)deviceToken;
- (void)login:(NSString*)email password:(NSString*)pass;
- (void)signup:(NSString*)email password:(NSString*)pass firstName:(NSString*)first lastName:(NSString*)last phoneNumber:(NSString*)phone;
- (void)logout;
- (BOOL)userHasAuthToken;
- (void)sendDeviceToken;
- (void)alertWithMessage:(NSString *)message;

@end
