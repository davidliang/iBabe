//
//  IBWelcomeViewController.h
//  iBabe
//
//  Created by David on 16/09/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBBCommon.h"
#import "IBDateHelper.h"
//#import "IBDashBoardViewController.h"
//#import "IBAppDelegate.h"



@interface IBWelcomeViewController : UIView <UIScrollViewDelegate>
{
}

@property (retain, nonatomic) IBOutlet UIScrollView     *contentScrollView;
@property (retain, nonatomic) IBOutlet UIView           *contentView;
@property (retain, nonatomic) IBOutlet UIPageControl    *pageCtrl;
@property (retain, nonatomic) IBOutlet UILabel *lbWhatIsYourDate;
@property (retain, nonatomic) IBOutlet UIButton *btnNo;
@property (retain, nonatomic) IBOutlet UIButton *btnYes;
@property (retain, nonatomic) IBOutlet UIView *viewTop;
@property (retain, nonatomic) IBOutlet UIView *viewBottom;
@property (retain, nonatomic) IBOutlet UIDatePicker *dueDatePicker;
@property (retain, nonatomic) IBOutlet UIView *welcomeView;

- (void)initContentViews;
- (IBAction)didTapCloseWelcomeBtn:(id)sender;
- (IBAction)didTapYesBtn:(id)sender;
- (IBAction)didTapNoBtn:(id)sender;

@end