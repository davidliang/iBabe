//
//  SMUICustomiseUtil.m
//  iBabe
//
//  Created by David Liang on 2/07/12.
//  Copyright (c) 2012 Sigmapps. All rights reserved.
//

#import "SMUICustomiseUtil.h"

@implementation SMUICustomiseUtil

#pragma mark- Customise the Navigation Bar for the whole app.
+ (void)customiseNavigationBar
{
    // --- Set up the Navigation Bar background
    UIImage *imgNavBg = [UIImage imageNamed:@"tab-bar-bg.png"];

    [[UINavigationBar appearance] setBackgroundImage:imgNavBg forBarMetrics:UIBarMetricsDefault];
    //    [imgNavBg release];

    // --- Set up the general navigation bar button.
    UIImage *imgGenBtnBg = [[UIImage imageNamed:@"tab-bar-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 6)];
    [[UIBarButtonItem appearance] setBackgroundImage:imgGenBtnBg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    // --- Set up the Nav back button.
    UIImage *imgBackBtnBg = [[UIImage imageNamed:@"tab-bar-back-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 4)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:imgBackBtnBg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}



+ (void)customiseUISegmentedControlAndSwitch
{
    // --- Left and right part of the nav controller.
    UIImage *imgSelected = [[UIImage imageNamed:@"segments-selected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20.0f, 0, 20.0f)];
    UIImage *imgUnselected = [[UIImage imageNamed:@"segments-unselected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20.0f, 0, 20.0f)];

    UIImage *imgSelectedUnSelected = [[UIImage imageNamed:@"segments-selected-unselected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *imgUnSelectedUnSelected = [[UIImage imageNamed:@"segments-unselected-unselected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *imgUnSelectedSelected = [[UIImage imageNamed:@"segments-unselected-selected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

//	UIImage *imgSelectedUnSelected = [[UIImage imageNamed:@"segment-divider.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    UIImage *imgUnSelectedUnSelected = [[UIImage imageNamed:@"segment-divider.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    UIImage *imgUnSelectedSelected = [[UIImage imageNamed:@"segment-divider.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
	
	
	
	
    // --- Left and right part.
    [[UISegmentedControl appearance] setBackgroundImage:imgUnselected forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setBackgroundImage:imgSelected forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];

    // --- Divider
    [[UISegmentedControl appearance] setDividerImage:imgSelectedUnSelected forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:imgUnSelectedUnSelected forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:imgUnSelectedSelected forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
	
	
	

    // ----------- Switch
    [[UISwitch appearance] setOnTintColor:[UIColor colorWithRed:233 / 255.0 green:107 / 255.0 blue:149 / 255.0 alpha:1.0]];
}



@end