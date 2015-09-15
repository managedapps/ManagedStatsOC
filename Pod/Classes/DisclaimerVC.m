//
//  DisclaimerVC.m
//  Pods
//
//  Created by Bob Pascazio on 9/14/15.
//
//

#import "DisclaimerVC.h"
#import "Constants.h"

@interface DisclaimerVC ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) NSDictionary *config;
@property (weak, nonatomic) IBOutlet UIButton *centerButton;

@end

@implementation DisclaimerVC

- (void)configure:(NSDictionary*)config
{
    _config = config;
}

- (NSString *)htmlFromBodyString:(NSString *)htmlBodyString
                        textFont:(UIFont *)font
                       textColor:(UIColor *)textColor
{
    size_t numComponents = CGColorGetNumberOfComponents([textColor CGColor]);
    
    NSAssert(numComponents == 4 || numComponents == 2, @"Unsupported color format");
    
    // E.g. FF00A5
    NSString *colorHexString = nil;
    
    const CGFloat *components = CGColorGetComponents([textColor CGColor]);
    
    if (numComponents == 4)
    {
        unsigned int red = components[0] * 255;
        unsigned int green = components[1] * 255;
        unsigned int blue = components[2] * 255;
        colorHexString = [NSString stringWithFormat:@"%02X%02X%02X", red, green, blue];
    }
    else
    {
        unsigned int white = components[0] * 255;
        colorHexString = [NSString stringWithFormat:@"%02X%02X%02X", white, white, white];
    }
    
    NSString *HTML = [NSString stringWithFormat:@"<html>\n"
                      "<head>\n"
                      "<style type=\"text/css\">\n"
                      "body {font-family: \"%@\"; font-size: %@; color:#%@;}\n"
                      "</style>\n"
                      "</head>\n"
                      "<body>%@</body>\n"
                      "</html>",
                      font.familyName, @(font.pointSize), colorHexString, htmlBodyString];
    
    return HTML;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    UIFont *textFont = nil;
    UIColor *textColor = nil;
    
    [_webView setOpaque:NO];
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"disclaimer" ofType:@"html"];
    
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];

    if (_config != nil) {
    
        textFont = [_config objectForKey:@kDisclaimerConfigTextFont];
        textColor = [_config objectForKey:@kDisclaimerConfigTextColor];
        
        if (textFont == nil) {
            textFont = [UIFont systemFontOfSize:20];
        }
        
        if (textColor == nil) {
            textColor = [UIColor whiteColor];
        }
        
    }

    NSString *htmlColorString = [self htmlFromBodyString:htmlString
                                               textFont:textFont
                                              textColor:textColor];
    
    [_webView loadHTMLString:htmlColorString baseURL:nil];
    
    if (_config != nil) {
        
        UIColor *color = [_config objectForKey:@kDisclaimerConfigButtonColor];
        UIImage *image = [_config objectForKey:@kDisclaimerConfigButton];
        NSString *buttonTitle = [_config objectForKey:@kDisclaimerConfigButtonTitle];
       
        if (image != nil) {
            [_centerButton setBackgroundImage:image forState:UIControlStateNormal];
        }
        
        if (buttonTitle != nil) {
            [_centerButton setTitle:buttonTitle forState:UIControlStateNormal];
        }
        
        if (color != nil) {
            [_centerButton setTitleColor:color forState:UIControlStateNormal];
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)acceptHit:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (_delegate != nil) {
        [_delegate accepted];
    }
    
}

@end
