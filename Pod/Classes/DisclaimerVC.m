//
//  DisclaimerVC.m
//  Pods
//
//  Created by Bob Pascazio on 9/14/15.
//
//

#import "DisclaimerVC.h"

@interface DisclaimerVC ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DisclaimerVC

- (NSString *)htmlFromBodyString:(NSString *)htmlBodyString
                        textFont:(UIFont *)font
                       textColor:(UIColor *)textColor
{
    int numComponents = CGColorGetNumberOfComponents([textColor CGColor]);
    
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
    
    [_webView setOpaque:NO];
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"disclaimer" ofType:@"html"];
    
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    
    NSString *htmlColorString = [self htmlFromBodyString:htmlString
                                               textFont:[UIFont systemFontOfSize:20]
                                              textColor:[UIColor whiteColor]];
    
    [_webView loadHTMLString:htmlColorString baseURL:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)acceptHit:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
