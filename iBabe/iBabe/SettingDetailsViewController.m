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

	
	[bg setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

	
    alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input" message:@"Invalid \"Last Period \" value. Your last period should be earlier than today." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [self.view addSubview:alert];

    [self   customiseSegmentControl];
}



- (void)customiseSegmentControl
{
    // --- Prepare images for the different parts of the Segment Control.
    UIImage *imgSelected = [[UIImage imageNamed:@"segments-selected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20.0f, 0, 20.0f)];
    UIImage *imgUnselected = [[UIImage imageNamed:@"segments-unselected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20.0f, 0, 20.0f)];

    UIImage *imgSelectedUnSelected = [[UIImage imageNamed:@"segment-divider.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *imgUnSelectedUnSelected = [[UIImage imageNamed:@"segment-divider.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *imgUnSelectedSelected = [[UIImage imageNamed:@"segment-divider.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

    // --- set the selected and unselected image.
    [dateType setBackgroundImage:imgUnselected forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [dateType setBackgroundImage:imgSelected forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];

    // --- Divider
    [dateType setDividerImage:imgSelectedUnSelected forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [dateType setDividerImage:imgUnSelectedUnSelected forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [dateType setDividerImage:imgUnSelectedSelected forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
}



- (void)loadView
{
    [super loadView];
}



- (void)viewDidUnload
{
    [self setBtnSaveDueDate:nil];

	[bg release];
	bg = nil;
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
	[bg release];
    [super dealloc];
}



- (IBAction)onSaveDueDateClicked:(id)sender
{
    NSInteger   selectedTypeIdx = [self.dateType selectedSegmentIndex];
    NSDate      *calDueDate = Nil;

    BOOL        validDate = YES;
    NSString    *errMsg1 = @"Oops! Your last period should be earlier than today. Please try again.";
    NSString    *errMsg2 = @"Oops! Based on the value that you have provided, your baby should had been born. Please try again.";
    NSString    *errMsg3 = @"Oops! Due date should not be more than 40 weeks from today. Please try again.";

    switch (selectedTypeIdx) {
        case 0:
            // --- Selected the "Last Period" Option.
            calDueDate = [IBDateHelper calculateDueDateBy:[dueDatePicker date]];

            // --- Check if the selected last period date is earlier than today.
            if ([[dueDatePicker date] compare:[NSDate date]] == NSOrderedDescending)
            {
                validDate = NO;

                [alert setMessage:errMsg1];
                [alert show];
            }
            // --- Check if calulated due date which based on the last period date value
            // --- Validate or not. If due date earlier than today = Invalid.
            else if ([calDueDate compare:[NSDate date]] == NSOrderedAscending)
            {
                validDate = NO;
                [alert setMessage:errMsg2];
                [alert show];
            }
            else
            {
                [IBBCommon saveDueDateToPlist:calDueDate];
            }

            break;

        case 1:
            // --- Selected the "Due Date" option.

            if ([[dueDatePicker date] compare:[NSDate date]] == NSOrderedAscending)
            {
                validDate = NO;
                [alert setMessage:errMsg2];
                [alert show];
            }

            else if ([[dueDatePicker date] compare:[[NSDate date] dateByAddingTimeInterval:60 * 60 * 24 * 7 * 40]] == NSOrderedDescending)
            {
                validDate = NO;
                [alert setMessage:errMsg3];
                [alert show];
            }

            else
            {
                [IBBCommon saveDueDateToPlist:[dueDatePicker date]];
            }

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