//
//  SettingDetailsViewController.m
//  iBabe
//
//  Created by k on 6/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
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
    [self.dateType setSelectedSegmentIndex:[IBBCommon loadIsDateTypeLastPeriodFromPlist]];

    alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input" message:@"Invalid \"Last Period \" value. Your last period should be earlier than today." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [self.view addSubview:alert];
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
    [alert release];
    [super dealloc];
}



- (IBAction)onSaveDueDateClicked:(id)sender
{
    NSInteger   selectedTypeIdx = [self.dateType selectedSegmentIndex];
    NSDate      *calDueDate = Nil;

    BOOL validDate = YES;

    switch (selectedTypeIdx) {
        case 0:
            // --- Selected the "Last Period" Option.
            calDueDate = [IBDateHelper calculateDueDateBy:[dueDatePicker date]];

            // --- Check if the selected last period date is earlier than today.
            if ([[dueDatePicker date] compare:[NSDate date]] == NSOrderedDescending)
            {
                validDate = NO;

                [alert setMessage:@"Invalid \"Last Period \" value. Your last period should be earlier than today. Please try again."];

                [alert show];
            }
            // --- Check if calulated due date which based on the last period date value
            // --- Validate or not. If due date earlier than today = Invalid.
            else if ([calDueDate compare:[NSDate date]] == NSOrderedAscending)
            {
                validDate = NO;
                [alert setMessage:@"Invalid \"Last Period \" value. Based on your last period, your baby should had been born. Please try again."];
                [alert show];
            }
            else
            {
                [IBBCommon saveDueDateToPlist:calDueDate];
            }

            break;

        case 1:
            // --- Selected the "Due Date" option.
            [IBBCommon saveDueDateToPlist:[dueDatePicker date]];
            break;

        default:
            break;
    }

    if (validDate)
    {
        // --- Save date type.
        [IBBCommon saveIsDateTypeLastPeriodToPlist:selectedTypeIdx];

        // --- Save user picked date.
        [IBBCommon saveUserSelectedDateToPlist:[dueDatePicker date]];

        [btnSaveDueDate setEnabled:NO];
    }
}



@end