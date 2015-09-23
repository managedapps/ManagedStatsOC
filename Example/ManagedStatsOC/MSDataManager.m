//
//  MSDataManager.m
//  ManagedStatsOC
//
//  Created by Jacqueline Caraballo on 9/17/15.
//  Copyright (c) 2015 Bob Pascazio. All rights reserved.
//

#import "MSDataManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation MSDataManager

#pragma mark - init

+ (instancetype)sharedManager
{
    static MSDataManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}


/*
-(void)postDeviceToken:(NSData *)devToken appKey:(NSString *)appKey apiKey:(NSString *)apiKey{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"deviceToken": devToken, @"appKey": appKey, @"apiKey": apiKey};
    [manager POST:@"http://example.com/resources.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
*/
@end
