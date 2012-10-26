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

- (void)launchCheckPermissionViewWithWidth:(CGFloat)width Height:(CGFloat)height
{
    CGRect                          statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    NSArray                         *xibContentsPermission = [[NSBundle mainBundle] loadNibNamed:@"CheckPermissionView" owner:self options:nil];
    IBCheckPermissionViewController *permissionView = [xibContentsPermission lastObject];

	
	CGRect screen = [[UIScreen mainScreen]bounds];
	
    //	[permissionView setFrame:CGRectMake(0,height+statusBarFrame.size.height, width, height)];
    [permissionView setFrame:CGRectMake(0, statusBarFrame.size.height, width, screen.size.height-statusBarFrame.size.height)];

    [permissionView setAlpha:0.2];

    [permissionView initContentViews];

    IBAppDelegate *appDelegate = (IBAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[appDelegate window] addSubview:permissionView];

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [permissionView setAlpha:1];

        } completion:^(BOOL finished) {
        }];
}

@end