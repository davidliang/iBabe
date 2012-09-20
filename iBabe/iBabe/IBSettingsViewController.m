//
//  IBSettingsViewController.m
//  iBabe
//
//  Created by David on 3/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "IBSettingsViewController.h"
#import "IBBCommon.h"

@implementation IBSettingsViewController

@synthesize settingsView;
@synthesize settings;
@synthesize tbNumberOfRecentReminders;
@synthesize cellDueDate;
@synthesize stpRecentReminders;
@synthesize cellAbout;
@synthesize cellHintScreen;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 2)
    {
		// --- Reset the hints value.
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef setBool:NO forKey:@"shownTutorial1"];
        [userDef setBool:NO forKey:@"shownTutorial2"];
		
		// ---show the msg view.
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setMessage:@"Hints will be shown when iBabe is rebooted."];
		[alert addButtonWithTitle:@"Dismiss"];
        [alert show];
        [alert release];
    }
}



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



- (IBAction)dismissRecentReminderKeyboard:(id)sender
{
    [tbNumberOfRecentReminders resignFirstResponder];
}



- (IBAction)stpRecentRemindersStepperValueChanged:(id)sender
{
    [tbNumberOfRecentReminders setText:[NSString stringWithFormat:@"%0.f", [stpRecentReminders value]]];
    [IBBCommon saveNoOfRecentRemindersToPlist:[NSNumber numberWithDouble:[stpRecentReminders value]]];
}



- (void)loadView
{
    [super loadView];

    [self loadSettingsFromPlist];

    [settingsView setDelegate:self];
    [settingsView setDataSource:self];

    self.title = @"Settings";
}



- (void)viewDidLoad
{
    [cellAbout.textLabel setText:@"About"];
    [cellHintScreen.textLabel setText:@"Reset"];
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
    [cellAbout release];
    [cellHintScreen release];
    [super dealloc];
}



- (void)viewDidUnload
{
    [self setTbNumberOfRecentReminders:nil];
    [self setCellDueDate:nil];
    [self setStpRecentReminders:nil];
    [self setCellAbout:nil];
    [self setCellHintScreen:nil];
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