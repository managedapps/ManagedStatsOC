//
//  MAViewController.m
//  ManagedStatsOC
//
//  Created by Bob Pascazio on 09/11/2015.
//  Copyright (c) 2015 Bob Pascazio. All rights reserved.
//

#import "MAViewController.h"
#import "ManagedStats.h"
#import "DisclaimerVC.h"

@interface MAViewController ()

@end

@implementation MAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    ManagedStats* ms = [[ManagedStats alloc] initWithAppKey:@"8yd8gN-8AtYach1hhbT8DA"];
    [ms recordRun];
    
}

- (IBAction)showDisclaimer:(id)sender {

    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Frameworks/ManagedStatsOC" ofType:@"framework"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    DisclaimerVC *dvc = [[DisclaimerVC alloc]
                         initWithNibName:@"DisclaimerVC" bundle:bundle];
    [self presentViewController:dvc animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
