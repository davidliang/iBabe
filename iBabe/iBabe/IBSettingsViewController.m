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

- (void)viewWillAppear:(BOOL)animated
{
    [self loadSettingsFromPlist];
    [settingsView reloadData];
}



- (void)loadSettingsFromPlist
{
    NSDate *date = [IBBCommon loadDueDateFromPlist];

    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];

    [dateFormat setDateFormat:@"dd/MM/yyyy"];

    self.settings = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"Due Date: %@", [dateFormat stringFromDate:date]], nil];
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

/*
 *   // Implement loadView to create a view hierarchy programmatically, without using a nib.
 *   - (void)loadView
 *   {
 *   }
 */

/*
 *   // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 *   - (void)viewDidLoad
 *   {
 *   [super viewDidLoad];
 *   }
 */

- (void)dealloc
{
    [settings release];
    [settingsView release];
    [super dealloc];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



// - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
// {
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
// }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger       row = indexPath.row;
    static NSString *SimpleTableIdentifier = @"mycell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
        SimpleTableIdentifier];

    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc]    initWithStyle   :UITableViewCellStyleDefault
                                            reuseIdentifier :SimpleTableIdentifier] autorelease];
    }

    if ([indexPath row] == 0)
    {
        cell.textLabel.text = [self.settings objectAtIndex:row];
    }

    if ([indexPath row] == 1)
    {
        cell.textLabel.text = @"No. of recent reminders";
    }

    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // id item = [self.parsedData.items objectAtIndex: [indexPath row]]; UIViewController* svc = [[StoryViewController alloc] initWithItem: item]; [self.navigationController pushViewController:svc animated:YES];

    // id item = [self.settings objectAtIndex: [indexPath row]];
}



@end