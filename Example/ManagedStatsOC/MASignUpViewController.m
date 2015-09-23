//
//  MASignUpViewController.m
//  ManagedStatsOC
//
//  Created by Jacqueline Caraballo on 9/23/15.
//  Copyright © 2015 Bob Pascazio. All rights reserved.
//

#import "MASignUpViewController.h"

@interface MASignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userFirstName;
@property (weak, nonatomic) IBOutlet UITextField *userLastName;
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (weak, nonatomic) IBOutlet UITextField *userPhone;

@end

@implementation MASignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signupBtnTapped:(UIButton *)sender {
    
    ManagedStats* ms = [[ManagedStats alloc] init];
    NSString* email = self.userEmail.text;
    [ms signup:email password:@"password" firstName:@"firstName" lastName:@"lastName" phoneNumber: @"phoneNumber"];
    ms.delegate = self;
}

- (void)loginStatus:(BOOL)result{
    
}

- (void)signupStatus:(BOOL)result{
    NSLog(@"signup result");
    if (result == YES) {
        ManagedStats* ms = [[ManagedStats alloc] init];
       [ms sendDeviceToken];
        NSLog(@"signup success");
    } else {
        NSLog(@"signup failed");
    }
}

- (void)deviceTokenSendStatus:(BOOL)result{
    NSLog(@"deviceTokenSendStatus result");
    if (result == YES) {
        NSLog(@"deviceTokenSendStatus success");
    } else {
        NSLog(@"deviceTokenSendStatus failed");
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
