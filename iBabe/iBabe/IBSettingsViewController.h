//
//  IBSettingsViewController.h
//  iBabe
//
//  Created by David on 3/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBSettingsViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property(assign) IBOutlet UITableView *settingsView;

@property(atomic,retain) NSArray *settings;
@property (retain, nonatomic) IBOutlet UITextField *tbNumberOfRecentReminders;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellDueDate;
@property (retain, nonatomic) IBOutlet UIStepper *stpRecentReminders;

- (void) loadSettingsFromPlist;
- (IBAction)dismissRecentReminderKeyboard:(id)sender;

- (IBAction)stpRecentRemindersStepperValueChanged:(id)sender;


@end
