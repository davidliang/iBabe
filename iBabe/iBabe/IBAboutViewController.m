//
//  IBAboutViewController.m
//  iBabe
//
//  Created by David on 24/08/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "IBAboutViewController.h"

@interface IBAboutViewController ()

@end

@implementation IBAboutViewController
@synthesize webAbout;

#pragma mark -
#pragma UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // [progress show:YES];
}



- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // [progress hide:YES];
    [imgAbout setHidden:YES];
}



#pragma mark -
#pragma MBProgressHUD Delegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    // Remove HUD from screen when the HUD was hidded
    [progress removeFromSuperview];
    [progress release];
    progress = nil;
}



#pragma mark -
#pragma UIView Standard Methods.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self)
    {
        // Custom initialization
    }

    return self;
}



- (void)browseUrl
{
    NSURL           *url = [NSURL URLWithString:@"http://ibabe.sigmapps.com.au/mobile_site/"];
    NSURLRequest    *request = [NSURLRequest requestWithURL:url];

    [self.webAbout loadRequest:request];
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    if (imgAbout == nil)
    {
        imgAbout = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [imgAbout setImage:[UIImage imageNamed:@"about-screen.png"]];


		// --- Use the web view to load the loading img.
		UIWebView* wvLoading = [[UIWebView alloc]initWithFrame:CGRectMake((imgAbout.frame.size.width-70), 130, 48, 48)];
		NSData* gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loading-animation-2" ofType:@"gif"]];
		wvLoading.userInteractionEnabled = NO;
		[wvLoading loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
		[wvLoading setBackgroundColor:[UIColor clearColor]];
		[wvLoading setOpaque:NO];		
		[imgAbout addSubview:wvLoading];
		
		
        [self.view addSubview:imgAbout];
    }

    if (progress == nil)
    {
        progress = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [progress setAnimationType:MBProgressHUDAnimationFade];
        [progress setMode:MBProgressHUDModeIndeterminate];
        [progress setLabelText:@"Loading..."];

        [self.navigationController.view addSubview:progress];
        progress.delegate = self;
    }

    [self browseUrl];

    // Do any additional setup after loading the view.
}



- (void)viewDidUnload
{
    [self setWebAbout:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}



- (void)dealloc
{
    [webAbout release];
    [super dealloc];
}



@end