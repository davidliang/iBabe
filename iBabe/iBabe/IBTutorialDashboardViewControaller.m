//
//  IBTutorialDashboardViewControaller.m
//  iBabe
//
//  Created by David on 28/08/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "IBTutorialDashboardViewControaller.h"

@implementation IBTutorialDashboardViewControaller
@synthesize btnClose;
@synthesize imgTutorial;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
	
	
	
    return self;
}


- (void)dealloc {
	[btnClose release];

	[imgTutorial release];
    [super dealloc];
}

- (IBAction)didTapCloseTutorial:(id)sender {
	[self setHidden:YES];
}
@end
