//
//  MSDataManager.h
//  ManagedStatsOC
//
//  Created by Jacqueline Caraballo on 9/17/15.
//  Copyright (c) 2015 Bob Pascazio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSDataManager : NSObject

@property (nonatomic, readwrite) BOOL receivedNotification;
//@property (nonatomic, strong) NSString *appKey;
//@property (nonatomic, strong) NSString *apiKey;

+ (instancetype)sharedManager;
-(void)postDeviceToken:(NSData *)devToken appKey:(NSString *)appKey apiKey:(NSString *)apiKey;
@end
