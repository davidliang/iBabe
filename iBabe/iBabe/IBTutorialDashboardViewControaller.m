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


-(void)setTutorialWithParentViewName:(ParentViewName)pViewName
{
	
	currentParentViewName = pViewName;
	
	switch (pViewName) {
		case IBParentViewNameCalendarView:
			[imgTutorial setImage:[UIImage imageNamed:@"tutorial-calendar.png"]];
			break;
		case IBParentViewNameDashboardView:
			[imgTutorial setImage:[UIImage imageNamed:@"tutorial-dashboard.png"]];
			break;
			
		default:
			break;
	}
}


- (void)dealloc {
	[btnClose release];
	[imgTutorial release];
    [super dealloc];
}

- (IBAction)didTapCloseTutorial:(id)sender {
	[self setHidden:YES];
	
//	NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//	
//	switch (currentParentViewName) {
//		case IBParentViewNameDashboardView:
//			[userDef setBool:YES forKey:@"shownTutorial1"];
//			break;
//			
//		case IBParentViewNameCalendarView:
//			[userDef setBool:YES forKey:@"shownTutorial2"];
//			break;
//		default:
//			break;
//	}
	
}
@end
