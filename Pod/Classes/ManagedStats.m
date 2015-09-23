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

static NSString *kdeviceTokenURL = @"https://epi-api.herokuapp.com/api/v1/new_phone?api_key=";
static NSString *kauthTokenURL = @"https://epi-api.herokuapp.com/api/v1/login";
static NSString *klogoutURL = @"https://epi-api.herokuapp.com/api/v1/logout?api_key=";

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
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"MANAGEDAPPS.CO -> result %@", responseObject);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"YES" forKey:@kNSUDKeyFirstRun];
            [defaults synchronize];
        } failure:nil];
        [operation start];
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
        
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@", klogoutURL,authTok] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                NSLog(@"MANAGEDAPPS.CO ->logout successful");
                [defaults removeObjectForKey:@"authToken"];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
}

- (void)signup:(NSString*)email password:(NSString*)pass firstName:(UITextField*)first lastName:(NSString*)last phoneNumber:(NSString*)phone {

    
    //jackye
    //call signup API
    //return yes or no
    //save auth token
    //call delegate signupStatus

}

- (void)login:(NSString*)email password:(NSString*)pass {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"email": email, @"password": pass};
    [manager POST: [NSString stringWithFormat:@"%@", kauthTokenURL] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSLog(@"MANAGEDAPPS.CO ->login successful");
        NSData *authTok= responseObject[@"auth_token"];
        NSLog(@"Auth Token from server = %@", authTok);
        [self storeAuthTokenLocally:authTok];
        if (self.delegate != nil) {
            [self.delegate loginStatus:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (self.delegate != nil) {
            [self.delegate loginStatus:NO];
        }
    }];
}

- (void)sendDeviceToken {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *authTok = [defaults objectForKey: @"authToken"];
    NSString* deviceToken = [defaults objectForKey: @"deviceToken"];
    
    if (deviceToken == nil || authTok == nil) {
        if (self.delegate != nil) {
            [self.delegate deviceTokenSendStatus:NO];
        }
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"token": deviceToken};
    [manager POST: [NSString stringWithFormat:@"%@%@", kdeviceTokenURL, authTok] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSLog(@"MANAGEDAPPS.CO -> sendDeviceToken successful");
        if (self.delegate != nil) {
            [self.delegate deviceTokenSendStatus:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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