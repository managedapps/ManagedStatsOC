//
//  ManagedStats.h
//  Pods
//
//  Created by Bob Pascazio on 9/11/15.
//
//

#import <Foundation/Foundation.h>

@interface ManagedStats : NSObject

@property (nonatomic, strong) NSString *appKey;

- (id)initWithAppKey:(NSString*)appKey;
- (void)recordRun;

@end
