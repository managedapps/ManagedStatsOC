//
//  MAViewController.m
//  ManagedStatsOC
//
//  Created by Bob Pascazio on 09/11/2015.
//  Copyright (c) 2015 Bob Pascazio. All rights reserved.
//

#import "MAViewController.h"

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
    
    ManagedStats* ms = [[ManagedStats alloc] initWithAppKey:@"DhaMufqfSc0pYswzoW_qUg" apiKey:@"SdUktRvd-nen_KS3g_hhWA"];
    [ms recordRun];
    
}

- (IBAction)showDisclaimer:(id)sender {

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

    
//    [config setObject:[UIColor blackColor] forKey:@kDisclaimerConfigTopColor];
//    [config setObject:[UIColor blackColor] forKey:@kDisclaimerConfigBottomColor];
//    [config setObject:[UIColor blackColor] forKey:@kDisclaimerConfigStatusColor];
    [dvc configure:config];
    dvc.delegate = self;
    [self presentViewController:dvc animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)sendDeviceTokenToServer:(UIButton *)sender {
}

- (IBAction)LogoutBtnTapped:(UIButton *)sender {
    ManagedStats* ms = [[ManagedStats alloc] init];
    [ms logout];
}

#pragma mark - DisclaimerProtocol

- (void)accepted {
    
    NSLog(@"accepted!");
    
}


@end
