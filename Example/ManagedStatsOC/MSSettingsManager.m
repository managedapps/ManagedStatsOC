//
//  MSSettingsManager.m
//  ManagedStatsOC
//
//  Created by Jacqueline Caraballo on 9/17/15.
//  Copyright (c) 2015 Bob Pascazio. All rights reserved.
//

#import "MSSettingsManager.h"

// to be replaced with saved user profile
#define UserDefaultsKey_PresentAccountSetupOverlay  @"presentAccountSetupOverlay"

@interface MSSettingsManager ()
{

}

@property (nonatomic, strong) NSUserDefaults *userDefaults;


@end


@implementation MSSettingsManager

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static MSSettingsManager *shared;
    dispatch_once(&once, ^{
        shared = [[self alloc] init];
        shared.userDefaults = [NSUserDefaults standardUserDefaults];
        [shared registerDefaults];
    });
    
    return shared;
}

- (void)registerDefaults {
    NSDictionary *defaultPreferences = @{UserDefaultsKey_PresentAccountSetupOverlay: @(YES)};
    [self.userDefaults registerDefaults:defaultPreferences];
    [self.userDefaults synchronize];
}


- (NSDictionary *)deviceInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSString *devToken = [[NSString alloc] initWithData:[self.deviceToken base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength] encoding:NSUTF8StringEncoding];
    
    NSString  *token_string = [[[[self.deviceToken description]
                                 stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                stringByReplacingOccurrencesOfString:@">" withString:@""]
                               stringByReplacingOccurrencesOfString:@" " withString: @""];
    
    if (token_string) {
        [dict setObject:token_string forKey:@"device_token"];
    }
    
    [dict setObject:[UIDevice currentDevice].systemName forKey:@"device_os"];
    
    NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [dict setObject:version forKey:@"app_version"];
    
    return dict;
}

@end
