//
//  IBCheckPermissionViewController.h
//  iBabe
//
//  Created by David on 22/09/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBAppDelegate.h"
#import "IBEKCalendarHelper.h"

@interface IBCheckPermissionViewController : UIView <UIScrollViewDelegate>
{
}
@property (retain, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (retain, nonatomic) IBOutlet UIView       *contentView;
@property (retain, nonatomic) IBOutlet UIPageControl *pageCtrl;

@property (retain, nonatomic) IBOutlet UIButton *btnDismiss;

- (void)initContentViews;
- (IBAction)didTapBtnDismiss:(id)sender;


@end