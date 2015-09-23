//
//  MAViewController.m
//  ManagedStatsOC
//
//  Created by Bob Pascazio on 09/11/2015.
//  Copyright (c) 2015 Bob Pascazio. All rights reserved.
//

#import "MAViewController.h"
#import "Constants.h"

@interface MAViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userFirstName;
@property (weak, nonatomic) IBOutlet UITextField *userLastName;
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;

@end

@implementation MAViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    ManagedStats* ms = [[ManagedStats alloc] initWithAppKey:@kAppKey apiKey:@kApiKey];
    [ms recordRun];
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendDeviceTokenToServer:(UIButton *)sender
{
}

- (IBAction)LogoutBtnTapped:(UIButton *)sender
{
    ManagedStats* ms = [[ManagedStats alloc] init];
    [ms logout];
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
    ms.delegate = self;
    NSString* authToken = [ms getAuthToken];
    NSLog(@"auth token is %@\n", authToken);
    
    NSString* url = [NSString stringWithFormat:@"https://epi-api.herokuapp.com/api/v1/emergency?api_key=%@", authToken];
    
    NSDictionary *parameters = @{@"alert_type": @"red"};
    [ms post:parameters urlString:url];
}

#pragma mark - DisclaimerProtocol

- (void)accepted {
    
    NSLog(@"accepted!");
    
}

@end
