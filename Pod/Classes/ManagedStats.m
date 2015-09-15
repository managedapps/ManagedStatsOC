//
//  ManagedStats.m
//  Pods
//
//  Created by Bob Pascazio on 9/11/15.
//
//

#import "ManagedStats.h"
#import "AFNetworking.h"
#import "Constants.h"

@implementation ManagedStats {
    
}

- (id)initWithAppKey:(NSString*)appKey {
    
    _appKey = appKey;
    
    return self;
    
}


- (void)recordRun {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *firstRun = [defaults objectForKey:@kNSUDKeyFirstRun];

    if (firstRun == nil) {
    
        NSLog(@"MANAGEDAPPS.CO -> Recording a Run!");
        NSLog(@"MANAGEDAPPS.CO -> appkey is %@", _appKey);
        NSString *fullUrl = [NSString stringWithFormat:@kFirstRunURL, _appKey];
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

@end