//
//  ManagedStats.h
//  Pods
//
//  Created by Bob Pascazio on 9/11/15.
//
//

#import <Foundation/Foundation.h>

@protocol ManagedStatsProtocol <NSObject, UIWebViewDelegate>

@optional

- (void)loginStatus:(BOOL)result;
- (void)signupStatus:(BOOL)result;
- (void)deviceTokenSendStatus:(BOOL)result;
- (void)postStatus:(BOOL)result responseObject:(id)obj;

@end

@interface ManagedStats : NSObject

@property (weak, nonatomic) id <ManagedStatsProtocol> delegate;
@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *apiKey;

+(void) setAppKey:(NSString *)appKey setApiKey:(NSString *)apiKey;
+ (void)appLaunched;
+ (void)sessionStart;
+ (void)storeDeviceTokenLocally:(NSData *)deviceToken;
- (void)login:(NSString*)email password:(NSString*)pass;
- (void)signup:(NSString*)email password:(NSString*)pass firstName:(NSString*)first lastName:(NSString*)last phoneNumber:(NSString*)phone;
- (void)post:(NSDictionary*)parameters urlString:(NSString*)url;
- (void)logout;
- (BOOL)userHasAuthToken;
+ (NSString*)getAuthToken;
+ (NSString*)getDeviceToken;
+ (void)sendDeviceToken;
- (void)alertWithMessage:(NSString *)message;

@end
