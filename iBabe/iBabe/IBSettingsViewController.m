//
//  IBSettingsViewController.m
//  iBabe
//
//  Created by David on 3/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IBSettingsViewController.h"
#import "IBBCommon.h"

@implementation IBSettingsViewController

@synthesize settingsView;
@synthesize settings;
@synthesize tbNumberOfRecentReminders;
@synthesize cellDueDate;
@synthesize stpRecentReminders;

- (void)viewWillAppear:(BOOL)animated
{
    [self loadSettingsFromPlist];
    [settingsView reloadData];
	
	

	[cellDueDate.textLabel setText:[settings objectAtIndex:0]];
	[tbNumberOfRecentReminders setText:[settings objectAtIndex:1]];
	

	
	[stpRecentReminders setValue:[[settings objectAtIndex:1] doubleValue]];
	
}



- (void)loadSettingsFromPlist
{
    NSDate *date = [IBBCommon loadDueDateFromPlist];

    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];

    [dateFormat setDateFormat:@"dd/MM/yyyy"];

    NSNumber *amountOfReminders = [IBBCommon loadNoOfRecentRemindersFromPlist];

    self.settings = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@", [dateFormat stringFromDate:date]], [NSString stringWithFormat:@"%@", amountOfReminders], nil];
}

- (IBAction)dismissRecentReminderKeyboard:(id)sender {
	[tbNumberOfRecentReminders resignFirstResponder];
}

- (IBAction)stpRecentRemindersStepperValueChanged:(id)sender {
	
	[tbNumberOfRecentReminders setText:[NSString stringWithFormat:@"%0.f",[stpRecentReminders value]]];
}



- (void)loadView
{
    [super loadView];

    [self loadSettingsFromPlist];

    [settingsView setDelegate:self];
    [settingsView setDataSource:self];

    self.title = @"Settings";
}



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

- (void)dealloc
{
    [settings release];
    [settingsView release];
	[tbNumberOfRecentReminders release];
	[cellDueDate release];
	[stpRecentReminders release];
    [super dealloc];
}



- (void)viewDidUnload
{
	[self setTbNumberOfRecentReminders:nil];
	[self setCellDueDate:nil];
	[self setStpRecentReminders:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



// - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
// {
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
// }


@end