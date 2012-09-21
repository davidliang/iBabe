//
//  IBSettingsViewController.h
//  iBabe
//
//  Created by David on 3/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBSettingsViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property(assign) IBOutlet UITableView *settingsView;

@property(atomic,retain) NSArray *settings;
@property (retain, nonatomic) IBOutlet UITextField *tbNumberOfRecentReminders;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellDueDate;
@property (retain, nonatomic) IBOutlet UIStepper *stpRecentReminders;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellAbout;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellHintScreen;
@property (retain, nonatomic) IBOutlet UITableView *tableSettings;

- (void) loadSettingsFromPlist;
- (IBAction)dismissRecentReminderKeyboard:(id)sender;

- (IBAction)stpRecentRemindersStepperValueChanged:(id)sender;



@end
