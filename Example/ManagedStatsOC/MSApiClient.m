//
//  MSApiClient.m
//  ManagedStatsOC
//
//  Created by Jacqueline Caraballo on 9/17/15.
//  Copyright (c) 2015 Bob Pascazio. All rights reserved.
//

#import "MSApiClient.h"
#import "MSSettingsManager.h"

#if DEBUG
static NSString *kBaseURL = @"http://portal.managedapps.co/";
#else
static NSString *kBaseURL = @"http://portal.managedapps.co/";
#endif

// or http://portal.managedapps.co/v1

@implementation MSApiClient : NSObject 

//+ (instancetype)sharedManager
//{
//    static MSApiClient *_sharedManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
//    });
//    
//    return _sharedManager;
//}

#pragma mark - services

//- (void)authenticateUserWithLoginInfo:(NSDictionary *)loginInfo completion:(MSAPIClientCompletionBlock)completion
//{
//    NSMutableDictionary *params = [[MSSettingsManager sharedManager] deviceInfo].mutableCopy;
//    [loginInfo setValue:[params objectForKey:@"app_version"] forKey:@"app_version"];
//    [loginInfo setValue:[params objectForKey:@"device_os"] forKey:@"device_os"];
//    [loginInfo setValue:[params objectForKey:@"device_token"] forKey:@"device_token"];
//    
//    [params setObject:loginInfo forKey:@"user"];
//    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];
//    [paramsDict setObject:loginInfo forKey:@"user"];
//    
//    NSParameterAssert(completion);
//    [self
//     POST:[NSString stringWithFormat:@"login"]
//     parameters:paramsDict
//     success:^(NSURLSessionDataTask *task, id responseObject) {
//         completion(responseObject, nil);
//         NSLog(@"responseObject = %@", responseObject);
//         
//     }
//     failure:^(NSURLSessionDataTask *task, NSError *error) {
//         completion(nil, error);
//     }];
//}

//- (void)createUserWithLoginInfo:(NSDictionary *)loginInfo completion:(MSAPIClientCompletionBlock)completion
//{
//    NSMutableDictionary *params = [[MSSettingsManager sharedManager] deviceInfo].mutableCopy;
//    
//    [params setObject:[loginInfo objectForKey:@"latitude"] forKey:@"latitude"];
//    [params setObject:[loginInfo objectForKey:@"longitude"] forKey:@"longitude"];
//    
//    [loginInfo setValue:[params objectForKey:@"app_version"] forKey:@"app_version"];
//    [loginInfo setValue:[params objectForKey:@"device_os"] forKey:@"device_os"];
//    [loginInfo setValue:[params objectForKey:@"device_token"] forKey:@"device_token"];
//    
//    [params setObject:loginInfo forKey:@"user"];
//    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];
//    [paramsDict setObject:loginInfo forKey:@"user"];
//    
//    NSParameterAssert(completion);
//    [self
//     POST: [NSString stringWithFormat:@"users"]
//     parameters:params
//     success:^(NSURLSessionDataTask *task, id responseObject) {
//         completion(responseObject, nil);
//     }
//     failure:^(NSURLSessionDataTask *task, NSError *error) {
//         completion(nil, error);
//     }];
//}

@end
