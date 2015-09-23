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

static NSString *kdeviceTokenURL = @"https://epi-api.herokuapp.com/api/v1/new_phone";

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
}

- (void)storeAuthTokenLocally:(NSData *)deviceToken {
    //jackye
}

- (BOOL)userHasAuthToken {
    //jackye
    //look in NSUserDefaults to see if there is an auth token
    //return yes if this is the case
}

- (void)logout {
    //jackye
    //clear NSUserDefaults auth token
}

- (void)signup:(NSString*)email password:(NSString*)pass firstName:(NSString*)first lastName:(NSString*)last phoneNumber:(NSString*)phone {

    
    //jackye
    //call signup API
    //return yes or no
    //save auth token
    //call delegate signupStatus

}

- (void)login:(NSString*)email password:(NSString*)pass {
    
    //jackye

    // Hit the network with email, pass, appkey, etc...
    // Save the auth token with storeAuthTokenLocally
    // Call the delegate and say it was a success
    
    if (self.delegate != nil) {
        [self.delegate loginStatus:YES];
    }
    
}

- (void)sendDeviceToken {
    
    // jackye

    // Hit the network with authToken, deviceToken, appkey, etc...
    // Call sendDeviceTokenToServer

    if (self.delegate != nil) {
        [self.delegate deviceTokenSendStatus:YES];
    }
    
}

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