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

static NSString *kdeviceTokenURL = @"http://portal.managedapps.co/api/v1/add_device?api_key=KF4y0GeMVzIMMKMBJE6TpA";

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

-(void)sendDeviceTokenToServer:(NSData *)deviceToken{
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString* newStr = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
    //    NSData *devToken = [defaults objectForKey:newStr];
    
    if (deviceToken != nil) {
        
        NSLog(@"MANAGEDAPPS.CO -> Recording a Device Token!");
        NSLog(@"MANAGEDAPPS.CO -> appkey is %@", _appKey);
        NSLog(@"MANAGEDAPPS.CO -> apikey is %@", _apiKey);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"token": deviceToken, @"app_key": _appKey};
        [manager POST: kdeviceTokenURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            //////////////////////////
            NSString *fullUrl = [NSString stringWithFormat:@kDeviceTokenURL, _apiKey];
            NSLog(@"MANAGEDAPPS.CO -> device token fullUrl %@", fullUrl);
            NSURL *URL = [NSURL URLWithString:fullUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc]
                                          initWithRequest:request];
            op.responseSerializer = [AFJSONResponseSerializer serializer];
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *oper, id responseObject) {
                NSLog(@"MANAGEDAPPS.CO -> device token result %@", responseObject);
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                //            [defaults setObject:@"YES" forKey:devToken];
                [defaults synchronize];
            } failure:nil];
            [op start];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    } else {
        NSLog(@"MANAGEDAPPS.CO -> Device Token is nil");
    }
    
}

@end