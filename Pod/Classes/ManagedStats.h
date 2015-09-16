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
@property (nonatomic, strong) NSString *apiKey;

- (id)initWithAppKey:(NSString*)appKey apiKey:(NSString*)key;
- (void)recordRun;

@end
