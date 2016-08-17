//
//  MAViewController.m
//  ManagedStatsOC
//
//  Created by Bob Pascazio on 09/11/2015.
//  Copyright (c) 2015 Bob Pascazio. All rights reserved.
//

#import "MAViewController.h"
#import "Constants.h"
#import "MSSettingsManager.h"

@interface MAViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userFirstName;
@property (weak, nonatomic) IBOutlet UITextField *userLastName;
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;

@end

@implementation MAViewController

- (void) customInit
{
    
    self.styleHideStatusBar = NO;
    self.styleHideNavigationBar = YES;
    self.styleCoaching = @"Coaching";
    self.styleCoachingDelay = 2.0;
    self.styleCoachingAlpha = 0.5;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)showDisclaimer:(id)sender
{
    
    if ([DisclaimerVC shouldShowDisclaimer] == NO) {
        return;
    }
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Frameworks/ManagedStatsOC" ofType:@"framework"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    DisclaimerVC *dvc = [[DisclaimerVC alloc]
                         initWithNibName:@"DisclaimerVC" bundle:bundle];
    NSMutableDictionary *config = [[NSMutableDictionary alloc] init];
    UIImage *buttonImage = [UIImage imageNamed:@"button-green-normal1"];
    [config setObject:buttonImage forKey:@kDisclaimerConfigButton];
    [config setObject:@"ACCEPT THIS" forKey:@kDisclaimerConfigButtonTitle];
    [config setObject:@"USER AGREEMENT" forKey:@kDisclaimerConfigTopLabel];
    [config setObject:[UIColor whiteColor] forKey:@kDisclaimerConfigButtonColor];
    
    [config setObject:[UIColor greenColor] forKey:@kDisclaimerConfigTextColor];
    [config setObject:[UIFont systemFontOfSize:5] forKey:@kDisclaimerConfigTextFont];
    
    UIImage *background = [UIImage imageNamed:@"disclaimer-background"];
    [config setObject:background forKey:@kDisclaimerConfigBackground];
    
    [dvc configure:config];
    dvc.delegate = self;
    [self presentViewController:dvc animated:YES completion:nil];
}

- (IBAction)sendDeviceTokenToServer:(UIButton *)sender
{
}

- (IBAction)LogoutBtnTapped:(UIButton *)sender
{
    ManagedStats* ms = [[ManagedStats alloc] init];
    [ms logout];
}

- (IBAction)resetCoachMarks:(id)sender {
    
    [self resetCoach];
}

- (IBAction)showOtherCoach:(id)sender {
    
    [self showCoachImage:@"Coaching2"];
}

- (void)loginStatus:(BOOL)result
{
    
}

- (void)postStatus:(BOOL)result responseObject:(id)obj
{
    
    if (result == true) {
        NSLog(@"success with post");
    } else {
        NSLog(@"failure with post");
    }
}

- (IBAction)sendAlert:(id)sender
{
    ManagedStats* ms = [[ManagedStats alloc] init];
//    ms.delegate = self;
    NSString* authToken = [ManagedStats getAuthToken];
    NSLog(@"auth token is %@\n", authToken);
    
    NSString* url = [NSString stringWithFormat:@"https://epi-dev.herokuapp.com/api/v1/emergency?api_key=%@", authToken];
    
    NSDictionary *parameters = @{@"alert_type": @"red"};
    [ms post:parameters urlString:url];
}

#pragma mark - DisclaimerProtocol

- (void)accepted {
    
    NSLog(@"accepted!");
    
}

@end
