//
//  MSViewController.h
//  Pods
//
//  Created by Bob Pascazio on 10/9/15.
//
//

#import <UIKit/UIKit.h>

@interface MSViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic) BOOL styleHideStatusBar;
@property (nonatomic) BOOL styleHideNavigationBar;
@property (weak, nonatomic) NSString* styleCoaching;
@property (nonatomic) NSTimeInterval styleCoachingDelay;
@property (nonatomic) CGFloat styleCoachingAlpha;

- (void) customInit;
- (void) resetCoach;

@end
