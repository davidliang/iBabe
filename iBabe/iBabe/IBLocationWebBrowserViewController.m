//
//  IBLocationWebBrowserViewController.m
//  iBabe
//
//  Created by David on 14/09/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "IBLocationWebBrowserViewController.h"

@interface IBLocationWebBrowserViewController ()

@end

@implementation IBLocationWebBrowserViewController
@synthesize locationName;

#pragma mark -
#pragma Webview Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}



- (void)webViewDidStartLoad:(UIWebView *)webView
{
 	[progressHUD show:YES];	
}



- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[progressHUD hide:YES afterDelay:1.0f];
}




- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Oops! This web page cannot be loaded. Error Details: %@", error.description] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];

    [alert show];
    [alert release];
}



#pragma mark -
#pragma View life cycle methods.

- (void)viewWillAppear:(BOOL)animated
{
}



- (void)searchLocationInfoWithLocationName:(NSString *)location
{
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self)
    {
        // Custom initialization
    }

    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    if (![SMStringUtil isEmptyString:locationName])
    {
        locationName = [locationName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        NSString    *strUrl = [NSString stringWithFormat:@"http://www.google.com.au/#q=%@", locationName];
        NSString    *language = [[NSLocale preferredLanguages] objectAtIndex:0];

        if (language == @"zh")
        {
            strUrl = [NSString stringWithFormat:@"www.baidu.com/s?wd=%@", locationName];
        }

        NSURL           *url = [NSURL URLWithString:strUrl];
        NSURLRequest    *urlRequest = [NSURLRequest requestWithURL:url];
		[self.webView loadRequest:urlRequest];

		if (progressHUD == nil)
		{
			progressHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
			[progressHUD setLabelText:@"Loading..."];
			[progressHUD setMode:MBProgressHUDModeIndeterminate];
			progressHUD.dimBackground = YES;
			progressHUD.delegate = self;
			[self.navigationController.view addSubview:progressHUD];
		}
		

    }
}



#pragma mark -
#pragma MBProgressHUD Delegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    // Remove HUD from screen when the HUD was hidded
    [progressHUD removeFromSuperview];
    [progressHUD release];
    progressHUD = nil;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (void)dealloc
{
    [_webView release];
    [super dealloc];
}



- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
}



@end