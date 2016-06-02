//
//  MAAppDelegate.m
//  ManagedStatsOC
//
//  Created by Bob Pascazio on 09/11/2015.
//  Copyright (c) 2015 Bob Pascazio. All rights reserved.
//

#import "MAAppDelegate.h"
#import "MSSettingsManager.h"
#import "Constants.h"

@implementation MAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert
                                                                                             | UIUserNotificationTypeBadge
                                                                                             | UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];

    [ManagedStats setAppKey:@kAppKey setApiKey:@kApiKey];
    [ManagedStats appLaunched];
   
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [ManagedStats sessionStart];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Notifications
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"decline action"]){
    }
    else if ([identifier isEqualToString:@"answer action"]){
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"device token sent to app : %@", deviceToken);

    [ManagedStats storeDeviceTokenLocally:deviceToken ];
    [ManagedStats sendDeviceToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"failed to get token, error: %@", error);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    NSLog(@"received notification: %@", userInfo);
    NSString *alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    
    if (application.applicationState == UIApplicationStateActive)
    {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.userInfo = userInfo;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = alertValue;
        localNotification.fireDate = [NSDate date];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}



@end
