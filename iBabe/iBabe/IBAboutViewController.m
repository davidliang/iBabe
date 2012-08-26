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

-(void)webViewDidStartLoad:(UIWebView *)webView
{
	[progress show:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
	[progress hide:YES];
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
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) browseUrl
{
	NSURL* url =[NSURL URLWithString:@"http://ibabe.sigmapps.com.au/mobile_site/"];
	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	[self.webAbout loadRequest:request];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

	progress = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
	[progress setAnimationType:MBProgressHUDAnimationFade];
	[progress setMode:MBProgressHUDModeIndeterminate];
	[progress setLabelText:@"Loading..."];

	[self.navigationController.view addSubview:progress];
	progress.delegate = self;
	
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [webAbout release];
    [super dealloc];
}
@end
