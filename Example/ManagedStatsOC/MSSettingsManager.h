//
//  MSSettingsManager.h
//  ManagedStatsOC
//
//  Created by Jacqueline Caraballo on 9/17/15.
//  Copyright (c) 2015 Bob Pascazio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSSettingsManager : NSObject

@property (nonatomic, strong) NSData *deviceToken;

+ (instancetype)sharedManager;

- (void)registerDefaults;
- (NSDictionary *)deviceInfo;

@end
