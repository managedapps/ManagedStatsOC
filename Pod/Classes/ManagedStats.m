//
//  ManagedStats.m
//  Pods
//
//  Created by Bob Pascazio on 9/11/15.
//
//

#import "ManagedStats.h"
#import "Constants.h"

static NSString *kdeviceTokenURL = @"https://epi-dev.herokuapp.com/api/v1/new_phone?api_key=";
static NSString *kauthTokenURL = @"https://epi-dev.herokuapp.com/api/v1/login";
static NSString *ksignUpURL = @"https://epi-dev.herokuapp.com/api/v1/users/new";
static NSString *klogoutURL = @"https://epi-dev.herokuapp.com/api/v1/logout?api_key=";
static NSString *_appKey;
static NSString *_apiKey;


@implementation ManagedStats {
    
}

+(void) setAppKey:(NSString *)appKey setApiKey:(NSString *)apiKey {
    _appKey = appKey;
    _apiKey = apiKey;
}



+ (void)appLaunched {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *firstRun = [defaults objectForKey:@kNSUDKeyFirstRun];
    
    if (firstRun == nil) {
        NSLog(@"MANAGEDAPPS.CO -> Recording a Run!");
        NSLog(@"MANAGEDAPPS.CO -> appkey is %@", _appKey);
        NSLog(@"MANAGEDAPPS.CO -> apikey is %@", _apiKey);
        NSString *fullUrl = [NSString stringWithFormat:@kFirstRunURL, _appKey, _apiKey];
        NSLog(@"MANAGEDAPPS.CO -> fullUrl %@", fullUrl);
        NSURL *url = [NSURL URLWithString:fullUrl];
        NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                              dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                  //Handle response here
                                                  NSLog(@"MANAGEDAPPS.CO -> result %@", response);
                                                  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                  [defaults setObject:@"YES" forKey:@kNSUDKeyFirstRun];
                                                  [defaults synchronize];
                                                  if(error) {
                                                      NSLog(@"\n\nError: %@", error);
                                                  }
                                              }];
        
        [downloadTask resume];
    } else {
        NSLog(@"MANAGEDAPPS.CO -> First Run Previously Recorded.");
        [self sessionStart];
    }
}

+ (ManagedStats*)sharedInstance {
    static ManagedStats *managedStats = nil;
    if (managedStats == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            managedStats = [[ManagedStats alloc] init];
        });
    }
    
    return managedStats;
}

+ (void)sessionStart {
    //jackye
    
    NSString *fullUrl = [NSString stringWithFormat:@kSessionStartURL, _appKey];
    NSLog(@"MANAGEDAPPS.CO -> sessionStart fullUrl %@", fullUrl);
    NSURL *url = [NSURL URLWithString:fullUrl];
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              //Handle response here
                                              NSLog(@"MANAGEDAPPS.CO -> sessionStart result %@", response);
                                              if(error) {
                                                  NSLog(@"\n\nError: %@", error);
                                              }
                                          }];
    
    [downloadTask resume];
}


+ (void)storeDeviceTokenLocally:(NSData *)deviceToken {
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
    
    NSURL *url = [NSURL URLWithString:klogoutURL];
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              //Handle response here
                                              if(error) {
                                                  NSLog(@"Error getting %@, HTTP response %i", klogoutURL, response );
                                              }
                                              NSLog(@"JSON: %@", response);
                                              NSLog(@"MANAGEDAPPS.CO ->logout successful");
                                              [defaults removeObjectForKey:@"authToken"];
                                          }];
    
    [downloadTask resume];
}

- (void)signup:(NSString*)email password:(NSString*)pass firstName:(UITextField*)first lastName:(NSString*)last phoneNumber:(NSString*)phone {
    //jackye
    
    NSDictionary *parameters = @{@"email": email, @"password": pass, @"fname": first, @"lname": last, @"phone_number": phone};
    NSURL *url = [NSURL URLWithString:ksignUpURL ];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters
                                                   options:kNilOptions error:&error];
    
    if (!error) {
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                   fromData:data
                                                          completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                              if(error){
                                                                  NSLog(@"Error = %@, HTTP response %i", error, response );
                                                                  if (self.delegate != nil) {
                                                                      [self.delegate signupStatus:NO];
                                                                  }
                                                              }
                                                              NSLog(@"JSON: %@", response);
                                                              NSLog(@"MANAGEDAPPS.CO ->signup successful");
                                                              
                                                              NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
                                                              NSLog(@"headers = %@",headers);
                                                              
                                                              NSData *authTok = headers[@"auth_token"];
                                                              NSLog(@"Auth Token from server = %@", authTok);
                                                              [self storeAuthTokenLocally:authTok];
                                                              if (self.delegate != nil) {
                                                                  [self.delegate signupStatus:YES];
                                                              }
                                                              
                                                          }];
        
        [uploadTask resume];
    }
}

- (void)post:(NSDictionary*)parameters urlString:(NSString*)url {
    
    NSURL *URL = [NSURL URLWithString: url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    request.HTTPMethod = @"POST";
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters
                                                   options:kNilOptions error:&error];
    
    if (!error) {
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                   fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                       if(error){
                                                                           NSLog(@"Error = %@, HTTP response %i", error, response );
                                                                           if (self.delegate != nil) {
                                                                               [self.delegate postStatus:NO responseObject:nil];
                                                                           }
                                                                       }
                                                                       
                                                                       NSLog(@"JSON: %@", response);
                                                                       NSLog(@"MANAGEDAPPS.CO ->post successful");
                                                                       if (self.delegate != nil) {
                                                                           [self.delegate postStatus:YES responseObject:response];
                                                                       }
                                                                   }];
        
        [uploadTask resume];
    }
    
    
}

- (void)login:(NSString*)email password:(NSString*)pass {
    NSDictionary *parameters = @{@"email": email, @"password": pass};
    
    NSURL *url = [NSURL URLWithString:kauthTokenURL];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters
                                                   options:kNilOptions error:&error];
    
    if (!error) {
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                   fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                       if (error){
                                                                           NSLog(@"Error: %@", error);
                                                                           if (self.delegate != nil) {
                                                                               [self.delegate loginStatus:NO];
                                                                           }
                                                                       }
                                                                       
                                                                       NSLog(@"JSON: %@", response);
                                                                       NSLog(@"MANAGEDAPPS.CO ->login successful");
                                                                       
                                                                       
                                                                       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                                       NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
                                                                       
                                                                       NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
                                                                       NSLog(@"headers = %@",headers);
                                                                       
                                                                       NSData *authTok = headers[@"auth_token"];
                                                                       
                                                                       NSLog(@"Auth Token from server = %@", authTok);
                                                                       [self storeAuthTokenLocally:authTok];
                                                                       
//                                                                       NSNumber* statusCode = headers[@"status_code"];
//                                                                       NSLog(@"Status code from server = %@", statusCode);
                                                                       
                                                                       if( httpResponse.statusCode != nil && httpResponse.statusCode == 200) {
                                                                           if (self.delegate != nil) {
                                                                               [self.delegate loginStatus:YES];
                                                                           }
                                                                       } else {
                                                                           if (self.delegate != nil) {
                                                                               [self.delegate loginStatus:NO];
                                                                           }
                                                                       }
                                                                   }];
        
        [uploadTask resume];
    }
}

+ (NSString*)getAuthToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *authTok = nil;
    if (defaults != nil) {
        authTok = [defaults objectForKey: @"authToken"];
    }
    return authTok;
}

+ (NSString*)getDeviceToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceTok = nil;
    if (defaults != nil) {
        deviceTok = [defaults objectForKey: @"deviceToken"];
    }
    
//    if (deviceTok == nil ) {
//        if (self.delegate != nil) {
//            [self.delegate deviceTokenSendStatus:NO];
//        }
//    }
    
    return deviceTok;
}


+ (void)sendDeviceToken {
    
    NSString * deviceToken = [self getDeviceToken];
    NSString * deviceTokenString = [[[[deviceToken description]
                                      stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                     stringByReplacingOccurrencesOfString: @">" withString: @""]
                                    stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"The generated device token string is : %@",deviceTokenString);
    NSDictionary *parameter = @{@"token": deviceTokenString};
    
    NSString *fullUrl = [NSString stringWithFormat:@kDevicesURL, _appKey];
    NSURL *url = [NSURL URLWithString:fullUrl];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject: parameter options: kNilOptions error:&error];
    
    if (!error) {
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                   fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                       
                                                                       NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                                       if (!error && httpResp.statusCode == 200) {
                                                                           
                                                                           NSLog(@"httpResp: %@", httpResp);
                                                                           
                                                                           NSLog(@"JSON: %@", response);
                                                                           NSLog(@"MANAGEDAPPS.CO -> sendDeviceToken successful");
                                                                           //                                                                       if (self.delegate != nil) {
                                                                           //                                                                           [self.delegate deviceTokenSendStatus:YES];
                                                                           //                                                                       }
                                                                       }else{
                                                                           NSLog(@"Error: %@", error);
//                                                                           if (self.delegate != nil) {
//                                                                               [self.delegate deviceTokenSendStatus:NO];
//                                                                           }
                                                                       }
                                                                   }];
        [uploadTask resume];
    }
}

-(void)alertWithMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                                                                   message: message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                NSLog(@"You pressed OK button");
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                NSLog(@"You pressed Cancel button");
                                            }]];
    
    //    [self presentViewController:alert animated:YES completion:nil]; // 6
}


@end