//
//  IBSettingsNavViewController.m
//  iBabe
//
//  Created by David Liang on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IBSettingsNavViewController.h"

@interface IBSettingsNavViewController ()

@end

@implementation IBSettingsNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	
	if([[[UIDevice currentDevice]systemVersion]intValue]>=5)
	{
		[self.navigationBar setBackgroundImage:[UIImage imageNamed:@"tab-bar-bg.png"] forBarMetrics:UIBarMetricsDefault];
	}
	
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

@end
