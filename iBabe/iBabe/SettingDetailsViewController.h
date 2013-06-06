//
//  SettingDetailsViewController.h
//  iBabe
//
//  Created by k on 6/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingDetailsViewController : UIViewController<UIPickerViewDelegate>
{
	UIAlertView* alert;
	IBOutlet UIImageView *bg;
}

@property(atomic,retain) IBOutlet UIDatePicker *dueDatePicker;
@property(atomic,retain) IBOutlet UISegmentedControl *dateType;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *btnSaveDueDate;


-(IBAction)datePickerValueChanged:(id)sender;
- (IBAction)dateTypeValueChanged:(id)sender;
- (IBAction)onSaveDueDateClicked:(id)sender;


@end
