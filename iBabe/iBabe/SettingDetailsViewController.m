//
//  SettingDetailsViewController.m
//  iBabe
//
//  Created by k on 6/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingDetailsViewController.h"
#import "IBBCommon.h"
#import "IBDateHelper.h"

@implementation SettingDetailsViewController
@synthesize btnSaveDueDate;

@synthesize dueDatePicker, dateType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self)
    {
        // Custom initialization
    }

    return self;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle

/*
 *   // Implement loadView to create a view hierarchy programmatically, without using a nib.
 *   - (void)loadView
 *   {
 *   }
 */

/**/
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.dueDatePicker setDate:[IBBCommon loadUserSelectedDateFromPlist]];

    dispatch_async(dispatch_get_main_queue(), ^{
            [self.dateType setSelectedSegmentIndex:[IBBCommon loadIsDateTypeLastPeriodFromPlist]];
        });
}



- (void)loadView
{
    [super loadView];
}



- (void)viewDidUnload
{
    [self setBtnSaveDueDate:nil];

    [super viewDidUnload];
}



// - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
// {
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
// }

- (IBAction)datePickerValueChanged:(id)sender
{
    [btnSaveDueDate setEnabled:YES];
}



- (IBAction)dateTypeValueChanged:(id)sender
{
    [btnSaveDueDate setEnabled:YES];
}



- (void)dealloc
{
    [btnSaveDueDate release];
    [super dealloc];
}



- (IBAction)onSaveDueDateClicked:(id)sender
{
    NSInteger selectedTypeIdx = [self.dateType selectedSegmentIndex];

    if (selectedTypeIdx == 1)
    {
        [IBBCommon saveDueDateToPlist:[dueDatePicker date]];
    }
    else
    {
        NSDate *calDueDate = [IBDateHelper calculateDueDateBy:[dueDatePicker date]];
        [IBBCommon saveDueDateToPlist:calDueDate];
    }

    // --- Save date type.
    [IBBCommon saveIsDateTypeLastPeriodToPlist:selectedTypeIdx];

    // --- Save user picked date.
    [IBBCommon saveUserSelectedDateToPlist:[dueDatePicker date]];

    [btnSaveDueDate setEnabled:NO];
}



@end