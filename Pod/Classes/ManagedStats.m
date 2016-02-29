//
//  ManagedStats.m
//  Pods
//
//  Created by Bob Pascazio on 9/11/15.
//
//

#import "ManagedStats.h"
#import <AFNetworking/AFNetworking.h>
#import "Constants.h"

static NSString *kdeviceTokenURL = @"https://epi-dev.herokuapp.com/api/v1/new_phone?api_key=";
static NSString *kauthTokenURL = @"https://epi-dev.herokuapp.com/api/v1/login";
static NSString *ksignUpURL = @"https://epi-dev.herokuapp.com/api/v1/users/new";
static NSString *klogoutURL = @"https://epi-dev.herokuapp.com/api/v1/logout?api_key=";

@implementation ManagedStats {
  
}

- (id)initWithAppKey:(NSString*)appKey apiKey:(NSString*)key {
    _appKey = appKey;
    _apiKey = key;
    return self;
}

- (void)recordRun {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *firstRun = [defaults objectForKey:@kNSUDKeyFirstRun];

    if (firstRun == nil) {
        NSLog(@"MANAGEDAPPS.CO -> Recording a Run!");
        NSLog(@"MANAGEDAPPS.CO -> appkey is %@", _appKey);
        NSLog(@"MANAGEDAPPS.CO -> apikey is %@", _apiKey);
        NSString *fullUrl = [NSString stringWithFormat:@kFirstRunURL, _appKey, _apiKey];
        NSLog(@"MANAGEDAPPS.CO -> fullUrl %@", fullUrl);
        NSURL *URL = [NSURL URLWithString:fullUrl];
        AFHTTPSessionManager *operation = [AFHTTPSessionManager manager];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"MANAGEDAPPS.CO -> result %@", responseObject);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"YES" forKey:@kNSUDKeyFirstRun];
            [defaults synchronize];
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
/*       
 Please see link regarding migration from AFNetworking 2.0 to AFNetworking 3.0.
 https://github.com/AFNetworking/AFNetworking/wiki/AFNetworking-3.0-Migration-Guide
        
*/
    } else {
        NSLog(@"MANAGEDAPPS.CO -> First Run Previously Recorded.");
    }
}

- (void)storeDeviceTokenLocally:(NSData *)deviceToken {
    //jackye
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: deviceToken forKey:@"deviceToken"];
    
    if ([defaults objectForKey: @"deviceToken"] != nil) {
        NSLog(@"deviceToken saved in NSUserDefaults");
    }else{
        NSLog(@"deviceToken not saved in NSUserDefaults");
    }
}

- (void)storeAuthTokenLocally:(NSData *)authToken {
    //jackye
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: authToken forKey:@"authToken"];
    if ([defaults objectForKey: @"authToken"] != nil) {
        NSLog(@"authToken saved in NSUserDefaults");
    }else{
        NSLog(@"authToken not saved in NSUserDefaults");
    }
}

- (BOOL)userHasAuthToken {
    //jackye
    //look in NSUserDefaults to see if there is an auth token
    //return yes if this is the case
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey: @"authToken"] != nil) {
        NSLog(@"user has authToken");
        return YES;
    }else{
        NSLog(@"user does not have authToken");
        return NO;
    }
}

- (void)logout {
    //jackye
 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *authTok = [defaults objectForKey: @"authToken"];
    NSLog(@"logging out %@", authTok);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@", klogoutURL,authTok] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSLog(@"MANAGEDAPPS.CO ->logout successful");
        [defaults removeObjectForKey:@"authToken"];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)signup:(NSString*)email password:(NSString*)pass firstName:(UITextField*)first lastName:(NSString*)last phoneNumber:(NSString*)phone {

    NSDictionary *parameters = @{@"email": email, @"password": pass, @"fname": first, @"lname": last, @"phone_number": phone};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:ksignUpURL parameters:parameters  progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                NSLog(@"MANAGEDAPPS.CO ->signup successful");
                NSData *authTok= responseObject[@"auth_token"];
                NSLog(@"Auth Token from server = %@", authTok);
                [self storeAuthTokenLocally:authTok];
                if (self.delegate != nil) {
                    [self.delegate signupStatus:YES];
                }
        
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                if (self.delegate != nil) {
                    [self.delegate signupStatus:NO];
                }
            }];
}

- (void)post:(NSDictionary*)parameters urlString:(NSString*)url {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST: url parameters:parameters progress:nil  success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSLog(@"MANAGEDAPPS.CO ->post successful");
        if (self.delegate != nil) {
            [self.delegate postStatus:YES responseObject:responseObject];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (self.delegate != nil) {
            [self.delegate postStatus:NO responseObject:nil];
        }
    }];
    
    
    
    
}

- (void)login:(NSString*)email password:(NSString*)pass {
    NSDictionary *parameters = @{@"email": email, @"password": pass};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@", kauthTokenURL] parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSLog(@"MANAGEDAPPS.CO ->login successful");
        NSData *authTok= responseObject[@"auth_token"];
        NSLog(@"Auth Token from server = %@", authTok);
        [self storeAuthTokenLocally:authTok];
        
        NSNumber* statusCode= responseObject[@"status_code"];
        NSLog(@"Status code from server = %@", statusCode);
        
        if( statusCode!=nil && statusCode.integerValue == 200) {
            if (self.delegate != nil) {
                [self.delegate loginStatus:YES];
            }
        } else {
            if (self.delegate != nil) {
                [self.delegate loginStatus:NO];
            }
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (self.delegate != nil) {
            [self.delegate loginStatus:NO];
        }
    }];
    
    
    
}

- (NSString*)getAuthToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *authTok = nil;
    if (defaults != nil) {
        authTok = [defaults objectForKey: @"authToken"];
    }
    return authTok;
}

- (NSString*)getDeviceToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceTok = nil;
    if (defaults != nil) {
        deviceTok = [defaults objectForKey: @"deviceToken"];
    }
    
    if (deviceTok == nil ) {
        if (self.delegate != nil) {
            [self.delegate deviceTokenSendStatus:NO];
        }
    }
    
    return deviceTok;
}


- (void)sendDeviceToken {
    
    NSString * authTok = [self getAuthToken];
    NSString * deviceToken = [self getDeviceToken];
    
    NSLog(@"sending token: device %@ auth %@", deviceToken, authTok);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{@"token": deviceToken};
    
    [manager POST :[NSString stringWithFormat:@"%@%@", kdeviceTokenURL, authTok] parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSLog(@"MANAGEDAPPS.CO -> sendDeviceToken successful");
        if (self.delegate != nil) {
            [self.delegate deviceTokenSendStatus:YES];
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (self.delegate != nil) {
            [self.delegate deviceTokenSendStatus:NO];
        }
    }];

}

/*
-(void)sendDeviceTokenToServer:(NSData *)deviceToken {
    
    if (deviceToken != nil) {
        NSLog(@"MANAGEDAPPS.CO -> Recording a Device Token!");
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"token": deviceToken, @"app_key": _appKey};
        [manager POST: [NSString stringWithFormat:@"%@%@", kdeviceTokenURL, _apiKey] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    } else {
        NSLog(@"MANAGEDAPPS.CO -> Device Token is nil");
    }
}
 */

-(void)alertWithMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                                                                   message: message
                                                            preferredStyle:UIAlertControllerStyleAlert]; // 1
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                NSLog(@"You pressed OK button");
                                            }]]; // 2
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                NSLog(@"You pressed Cancel button");
                                            }]]; // 3
    
//    [self presentViewController:alert animated:YES completion:nil]; // 6
}

@end