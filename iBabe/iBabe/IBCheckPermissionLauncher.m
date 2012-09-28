//
//  IBCheckPermissionLauncher.m
//  iBabe
//
//  Created by David on 22/09/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "IBCheckPermissionLauncher.h"
#import "IBCheckPermissionViewController.h"
#import "IBAppDelegate.h"

@implementation IBCheckPermissionLauncher


-(void)launchCheckPermissionViewWithWidth:(CGFloat)width Height:(CGFloat)height	
{
	CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
	NSArray                             *xibContentsPermission = [[NSBundle mainBundle] loadNibNamed:@"CheckPermissionView" owner:self options:nil];
	IBCheckPermissionViewController		*permissionView = [xibContentsPermission lastObject];
	
	[permissionView setFrame:CGRectMake(0,height+statusBarFrame.size.height, width, height)];
	
	[permissionView initContentViews];
	
	IBAppDelegate *appDelegate = (IBAppDelegate *)[[UIApplication sharedApplication] delegate];
	[[appDelegate window] addSubview:permissionView];
	
	[UIView animateWithDuration:0.1 delay:2 options:UIViewAnimationOptionCurveEaseOut animations:^{
		[permissionView setFrame:CGRectMake(0, statusBarFrame.size.height + statusBarFrame.origin.y, width, height)];
	} completion:^(BOOL finished) {
		
	}];
	

}

@end
