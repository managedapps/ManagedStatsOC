//
//  MALoginViewController.m
//  ManagedStatsOC
//
//  Created by Jacqueline Caraballo on 9/23/15.
//  Copyright © 2015 Bob Pascazio. All rights reserved.
//

#import "MALoginViewController.h"

@interface MALoginViewController ()


@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (strong, nonatomic) ManagedStats *ms;
@end

@implementation MALoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ms = [[ManagedStats alloc] initWithAppKey:@"" apiKey:@""];
    self.ms.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)LoginBtnTapped:(UIButton *)sender {

    [self.ms login:@"test@test.com" password:@"12345678"];
}

- (void)loginStatus:(BOOL)result{
    NSLog(@"login result");
    if (result == YES) {
        [self.ms sendDeviceToken];
        NSLog(@"login success");
    } else {
        NSLog(@"login failed");
    }
}

- (void)signupStatus:(BOOL)result{
    
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
