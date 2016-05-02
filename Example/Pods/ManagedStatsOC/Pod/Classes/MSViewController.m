//
//  MSViewController.m
//  Pods
//
//  Created by Bob Pascazio on 10/9/15.
//
//

#import "MSViewController.h"
#import "Constants.h"

@interface MSViewController ()

- (BOOL)isNavBarHidden;
- (void)showNavBar;
- (void)hideNavBar;
- (void)showStatusBar;
- (void)hideStatusBar;

@property (strong, nonatomic) UIImageView* coachImageView;

@end

@implementation MSViewController

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self && [self respondsToSelector:@selector(customInit)])
    {
        [self customInit];
    }
    return self;
}

- (void) customInit
{
    
    self.styleHideStatusBar = NO;
    self.styleHideNavigationBar = NO;
    self.styleCoaching = Nil;
    self.styleCoachingDelay = 2.0;
    self.styleCoachingAlpha = 0.7;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self && [self respondsToSelector:@selector(customInit)])
    {
        [self customInit];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if(self && [self respondsToSelector:@selector(customInit)])
    {
        [self customInit];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewDidLoad];
    if (self.styleHideNavigationBar) {
        
        [self hideNavBar];
    }
    if (self.styleHideStatusBar) {
        
        [self hideStatusBar];
    }
    
    if (self.styleCoaching != nil) {
        
        [self showCoachImage:self.styleCoaching];
    }
}

- (void) showCoachImage: (NSString*)name
{
    
    UIImage* coach = [UIImage imageNamed:name];
    if (![self shouldShowCoach:name]) {
        return;
    }
    self.coachImageView = [[UIImageView alloc] initWithImage:coach];
    self.coachImageView.frame = self.view.frame;
    self.coachImageView.center = self.view.center;
    self.coachImageView.alpha = 0.0;
    [UIView animateWithDuration:self.styleCoachingDelay animations:^{
        self.coachImageView.alpha = self.styleCoachingAlpha;
        
        // Set in defaults.
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* fullName = [NSString stringWithFormat:@"%@%@", @kNSUDKeyCoachMark, name];
        [defaults setObject:@"YES" forKey:fullName];
        [defaults synchronize];
    }];
    
    self.coachImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapCoachGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture setDelegate:self];
    [self.coachImageView addGestureRecognizer:tapGesture];
    [self.view addSubview:self.coachImageView];
   
}

- (void) tapCoachGesture: (id)sender
{
    
    [UIView animateWithDuration:self.styleCoachingDelay animations:^{
        self.coachImageView.alpha = 0;
    }];
    [self.coachImageView removeGestureRecognizer:sender];
    [self.coachImageView removeFromSuperview];
    self.coachImageView = nil;
}


- (bool)shouldShowCoach:(NSString*)name {
    
    bool shouldShow = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* fullName = [NSString stringWithFormat:@"%@%@", @kNSUDKeyCoachMark, name];
    NSString *hasShown = [defaults objectForKey:fullName];
    if (hasShown != nil) {
        NSLog(@"MANAGEDAPPS.CO -> Coach previously shown.");
        shouldShow = NO;
    }
    return shouldShow;
}


- (void)resetCoach {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* fullName = [NSString stringWithFormat:@"%@%@", @kNSUDKeyCoachMark, self.styleCoaching];
    [defaults removeObjectForKey:fullName];
    [defaults synchronize];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
    if (self.isNavBarHidden) {
        
        [self showNavBar];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideNavBar {
    
    [self.navigationController setNavigationBarHidden:true];
}

- (void)showNavBar {
    
    [self.navigationController setNavigationBarHidden:false];
}

- (BOOL)isNavBarHidden {
    
    return self.navigationController.navigationBarHidden;
}

- (void)hideStatusBar {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
}

- (void)showStatusBar {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
}

- (BOOL)prefersStatusBarHidden {
    
    return self.styleHideStatusBar;
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
