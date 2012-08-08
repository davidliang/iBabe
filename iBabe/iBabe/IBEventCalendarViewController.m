//
//  IBEventCalendarViewController.m
//  iBabe
//
//  Created by David Liang on 11/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IBEventCalendarViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "EventKitDataSource.h"
#import "IBNavKalViewWrapperViewController.h"
#import "IBAppDelegate.h"


@interface IBEventCalendarViewController ()

@end

@implementation IBEventCalendarViewController





#pragma -
#pragma Kal Delegate
@synthesize navItems;


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	
}


// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"eventDetailSegue"]) {
		
        //--- Get destination view
        //SecondView *vc = [segue destinationViewController];
		
        //--- Get button tag number (or do whatever you need to do here, based on your object
        //NSInteger tagIndex = [(UIButton *)sender tag];
		
        //--- Pass the information to your destination view
        //[vc setSelectedButton:tagIndex];
    }
}




// Action handler for the navigation bar's right bar button item.
- (void)showAndSelectToday
{
	[self showAndSelectDate:[NSDate date]];
}

-(void) addNewEvent
{
	NSLog(@"Add clicked");
}


#pragma -
#pragma View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	navItems.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStyleBordered target:self action:@selector(showAndSelectToday)] autorelease];
	
	navItems.rightBarButtonItem = [[[UIBarButtonItem alloc ] initWithTitle:@"Add" style:UIBarButtonSystemItemAdd target:self action:@selector(addNewEvent)]autorelease];
	
	
	self.delegate=self;
	self.dataSource = [[EventKitDataSource alloc]init];
	[self reloadData];
}

- (void)viewDidUnload
{
	[self setNavItems:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
	[eventsDateSource release];
	[navItems release];
	[super dealloc];
}
@end
