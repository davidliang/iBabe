//
//  IBEditEventViewController.h
//  iBabe
//
//  Created by David Liang on 30/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <EventKit/EventKit.h>

#import "IBEKCalendarHelper.h"
#import "TDDatePickerController.h"
#import "TDGeneralPickerController.h"
#import "SMDateConvertUtil.h"
#import "SMStringUtil.h"

#import "MBProgressHUD.h"

@interface IBEditEventViewController : UIViewController <UITextViewDelegate, UIGestureRecognizerDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>
{
    // ---
    TDDatePickerController      *datePickerView;
    TDGeneralPickerController   *genPickerView;
    NSDate                      *presetEndDateTime;

    MBProgressHUD   *progressHud;
    BOOL            isSaved;
}

@property (retain, nonatomic) IBOutlet UITextView   *tvNote;
@property (retain, nonatomic) IBOutlet UITextView   *tvLocation;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIView       *contentView;
@property (retain, nonatomic) IBOutlet UIButton     *btnSave;
@property (retain, nonatomic) IBOutlet UITextField  *tbTitle;

@property (retain, nonatomic) IBOutlet UIButton *btnDateStart;
@property (retain, nonatomic) IBOutlet UIButton *btnStartTime;
@property (retain, nonatomic) IBOutlet UIButton *btnEndTime;
@property (retain, nonatomic) IBOutlet UIButton *btnDateEnd;
@property (retain, nonatomic) IBOutlet UIButton *btnAlarm1;
@property (retain, nonatomic) IBOutlet UIButton *btnAlarm2;
@property (retain, nonatomic) IBOutlet UIButton *btnDelete;

@property (retain, nonatomic) EKEvent   *currentEvent;
@property (nonatomic) BOOL              isNewEvent;

- (IBAction)tapToCloseKeyboard:(id)sender;
- (IBAction)didTapBtnSave:(id)sender;
- (IBAction)swipeToNavBack:(id)sender;

- (IBAction)didTapDateStart:(id)sender;
- (IBAction)didTapTimeStart:(id)sender;
- (IBAction)didTapTimeEnd:(id)sender;
- (IBAction)didTapDateEnd:(id)sender;
- (IBAction)didTapAlarm1:(id)sender;
- (IBAction)didTapAlarm2:(id)sender;
- (IBAction)didTapDelete:(id)sender;

@end