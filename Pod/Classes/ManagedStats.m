//
//  ManagedStats.m
//  Pods
//
//  Created by Bob Pascazio on 9/11/15.
//
//

#import "ManagedStats.h"
#import "AFNetworking.h"

@implementation ManagedStats {
    
}

- (id)initWithAppKey:(NSString*)appKey {
    
    _appKey = appKey;
    
    return self;
    
}


- (void)recordRun {
    NSLog(@"MANAGEDAPPS.CO -> Recording a Run!");
    NSLog(@"MANAGEDAPPS.CO -> appkey is %@", _appKey);
}

@end