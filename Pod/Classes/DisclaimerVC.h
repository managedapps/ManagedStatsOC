//
//  DisclaimerVC.h
//  Pods
//
//  Created by Bob Pascazio on 9/14/15.
//
//

#import <UIKit/UIKit.h>

@protocol DisclaimerProtocol <NSObject, UIWebViewDelegate>

@required

- (void)accepted;

@end

@interface DisclaimerVC : UIViewController

@property (weak, nonatomic) id <DisclaimerProtocol> delegate;

- (void)configure:(NSDictionary*)config;

@end
