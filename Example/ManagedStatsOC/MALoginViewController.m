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
@end

@implementation MALoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)LoginBtnTapped:(UIButton *)sender {
    
    
//    if ([self.userEmail isEqual:@""] || [self.userPassword isEqual:@""] ) {
//        NSLog(@"Add Alert");
//    }else{
        ManagedStats* ms = [[ManagedStats alloc] init];
        [ms userHasAuthToken];
        ms.delegate = self;
        [ms login:@"test@test.com" password:@"12345678"];
//    }
}

- (void)loginStatus:(BOOL)result{
    
}

- (void)signupStatus:(BOOL)result{
    
}

- (void)deviceTokenSendStatus:(BOOL)result{
    
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
