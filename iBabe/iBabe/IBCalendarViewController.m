//
//  IBCalendarViewController.m
//  iBabe
//
//  Created by David Liang on 19/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IBCalendarViewController.h"
static int calendarShadowOffset = (int)-20;

@implementation IBCalendarViewController

#pragma -
#pragma TableView Delegate
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [eventsForCurrentDate count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CalendarEventCell";

    IBEventCellViewController *cell = (IBEventCellViewController *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
    {
        NSArray *topLvObjs = [[NSBundle mainBundle] loadNibNamed:@"CalendarEventCell" owner:nil options:nil];

        for (id currentObj in topLvObjs) {
            if ([currentObj isKindOfClass:[UITableViewCell class]])
            {
                cell = (IBEventCellViewController *)currentObj;
                break;
            }
        }
    }

    [cell.lbTitle setText:[[eventsForCurrentDate objectAtIndex:[indexPath row]] title]];

    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedEvent = [eventsForCurrentDate objectAtIndex:[indexPath row]];

    UIStoryboard                    *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    IBEventDetailsViewController    *eventView = [sb instantiateViewControllerWithIdentifier:@"IBEventDetailsViewController"];

    [eventView setCurrentEvent:selectedEvent];

    [[self navigationController] pushViewController:eventView animated:YES];
}



- (void)viewWillAppear:(BOOL)animated
{
    [calendar reload];

    if (selectedDate == Nil)
    {
        [calendar selectDate:[NSDate date]];
    }
    else
    {
        [calendar selectDate:selectedDate];
    }

    [eventTable reloadData];
}



- (void)didTapGoToToday
{
    [calendar selectDate:[NSDate date]];
    [self loadEventsForSelectedDate:[NSDate date]];
}



- (void)loadView
{
    eventsForCurrentMonth = [[NSMutableArray alloc] init];
    eventsForCurrentDate = [[NSMutableArray alloc] init];

    NSArray *startAndEndDate = [SMDateConvertUtil getBeginAndEndOfADate:[NSDate date]];

    NSArray *initEventsTemp = [IBEKCalendarHelper getEventsFromDate:[startAndEndDate objectAtIndex:0] toDate:[startAndEndDate objectAtIndex:1]];

    for (EKEvent *aEvent in initEventsTemp) {
        [eventsForCurrentDate addObject:aEvent];
    }

    calendar = [[TKCalendarMonthView alloc] init];
    calendar.delegate = self;
    calendar.dataSource = self;

    // Costruct the view because we aren't using a
    int statusBarHeight = 20;

    CGRect applicationFrame = (CGRect)[[UIScreen mainScreen] applicationFrame];
    self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, statusBarHeight, applicationFrame.size.width, applicationFrame.size.height)] autorelease];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor grayColor];

    // Back ground image
    UIImage *bgImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background" ofType:@"png"]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:bgImg]];

    calendar.frame = CGRectMake(0, 0, calendar.frame.size.width, calendar.frame.size.height);

    UIBarButtonItem *btnAddEvent = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTapAddEventButton)];
    //	[[self navigationItem] setRightBarButtonItem:btnAddEvent];
    [[self navigationItem] setTitle:@"iBabe Calendar"];

    UIBarButtonItem *btnToday = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStyleBordered target:self action:@selector(didTapGoToToday)];

    NSArray *btnsetRight = [[NSArray alloc] initWithObjects:btnAddEvent, btnToday, nil];

    [[self navigationItem] setRightBarButtonItems:btnsetRight animated:YES];

    UIBarButtonItem *btnToggleCal = [[UIBarButtonItem alloc] initWithTitle:@"Cal" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleCalendar)];

    [[self navigationItem] setLeftBarButtonItem:btnToggleCal];

    eventTable = [[UITableView alloc] initWithFrame:CGRectMake(0, calendar.frame.size.height + calendar.frame.origin.y, applicationFrame.size.width, applicationFrame.size.height - calendar.frame.size.height)];

    eventTable.autoresizingMask &= ~UIViewAutoresizingFlexibleBottomMargin;

    eventTable.delegate = self;
    eventTable.dataSource = self;
    [self.view addSubview:eventTable];

    // Ensure this is the last "addSubview" because the calendar must be the top most view layer
    [self.view addSubview:calendar];
}



- (void)didTapAddEventButton
{
    [self performSegueWithIdentifier:@"showAddEventSegue" sender:self];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAddEventSegue"])
    {
        EKEventStore    *eventStore = [[[EKEventStore alloc] init] autorelease];
        EKEvent         *newEvent = [EKEvent eventWithEventStore:eventStore];

        EKCalendar *cal = [IBEKCalendarHelper getIBabeCalendar];
        [newEvent setCalendar:cal];
        [newEvent setStartDate:[calendar dateSelected]];
        [newEvent setEndDate:[[calendar dateSelected] dateByAddingTimeInterval:60 * 5]];

        IBEditEventViewController *editEventViewCtrl = [segue destinationViewController];
        [editEventViewCtrl setCurrentEvent:newEvent];
        [editEventViewCtrl setIsNewEvent:YES];
    }
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}



// Show/Hide the calendar by sliding it down/up from the top of the device.
- (void)toggleCalendar
{
    // If calendar is off the screen, show it, else hide it (both with animations)
    if (calendar.frame.origin.y == -calendar.frame.size.height + calendarShadowOffset)
    {
        // Show
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.75];
        calendar.frame = CGRectMake(0, 0, calendar.frame.size.width, calendar.frame.size.height);
        [UIView commitAnimations];
    }
    else
    {
        // Hide
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.75];
        calendar.frame = CGRectMake(0, -calendar.frame.size.height + calendarShadowOffset, calendar.frame.size.width, calendar.frame.size.height);
        [UIView commitAnimations];
    }
}



#pragma mark -
#pragma mark TKCalendarMonthViewDelegate methods

- (void)calendarMonthView:(TKCalendarMonthView *)monthView didSelectDate:(NSDate *)d
{
    [self loadEventsForSelectedDate:d];
}



- (void)loadEventsForSelectedDate:(NSDate *)d
{
    [eventsForCurrentDate removeAllObjects];

    for (EKEvent *aEvent in eventsForCurrentMonth) {
        if ([[SMDateConvertUtil getFormatedDateStringForCalendarControllerFromNSDate:[aEvent startDate]] isEqualToString:[SMDateConvertUtil getFormatedDateStringForCalendarControllerFromNSDate:d]])
        {
            [eventsForCurrentDate addObject:aEvent];
        }
    }

    [eventTable reloadData];
}



- (void)calendarMonthView:(TKCalendarMonthView *)monthView monthDidChange:(NSDate *)d
{
    // NSLog(@"calendarMonthView monthDidChange");
}



#pragma mark -
#pragma mark TKCalendarMonthViewDataSource methods

- (void)calendarMonthView:(TKCalendarMonthView *)monthView monthDidChange:(NSDate *)month animated:(BOOL)animated
{
    // ---- reset the table postion to avoid the top part hidding behind the calendar.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.75];
    eventTable.frame = CGRectMake(0, calendar.frame.size.height + calendar.frame.origin.y, eventTable.frame.size.width, eventTable.frame.size.height);
    [UIView commitAnimations];

    [calendar selectDate:month];
    [self loadEventsForSelectedDate:month];

    // ---- Reload the table data
    [eventTable reloadData];
}



- (NSArray *)calendarMonthView:(TKCalendarMonthView *)monthView marksFromDate:(NSDate *)startDate toDate:(NSDate *)lastDate
{
    NSMutableArray  *data = [[[NSMutableArray alloc] init] autorelease];
    NSArray         *events = [IBEKCalendarHelper getEventsFromDate:startDate toDate:lastDate];

    [eventsForCurrentMonth removeAllObjects];

    for (EKEvent *aEvent in events) {
        [data addObject:[SMDateConvertUtil getFormatedDateStringForCalendarControllerFromNSDate:[aEvent startDate]]];

        [eventsForCurrentMonth addObject:aEvent];
    }

    // Initialise empty marks array, this will be populated with TRUE/FALSE in order for each day a marker should be placed on.
    NSMutableArray *marks = [NSMutableArray array];

    // Initialise calendar to current type and set the timezone to never have daylight saving
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

    // Construct DateComponents based on startDate so the iterating date can be created.
    // Its massively important to do this assigning via the NSCalendar and NSDateComponents because of daylight saving has been removed
    // with the timezone that was set above. If you just used "startDate" directly (ie, NSDate *date = startDate;) as the first
    // iterating date then times would go up and down based on daylight savings.
    NSDateComponents *comp = [cal   components  :(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit |
            NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit)
                                    fromDate    :startDate];
    NSDate *d = [cal dateFromComponents:comp];

    // Init offset components to increment days in the loop by one each time
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:1];

    // for each date between start date and end date check if they exist in the data array
    while (YES) {
        // Is the date beyond the last date? If so, exit the loop.
        // NSOrderedDescending = the left value is greater than the right
        if ([d compare:lastDate] == NSOrderedDescending)
        {
            break;
        }

        // If the date is in the data array, add it to the marks array, else don't
        if ([data containsObject:[d description]])
        {
            [marks addObject:[NSNumber numberWithBool:YES]];
        }
        else
        {
            [marks addObject:[NSNumber numberWithBool:NO]];
        }

        // Increment day using offset components (ie, 1 day in this instance)
        d = [cal dateByAddingComponents:offsetComponents toDate:d options:0];
    }

    [offsetComponents release];
    return [NSArray arrayWithArray:marks];
}



#pragma mark -
#pragma mark Rotation

// Override to allow orientations other than the default portrait orientation.
// - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//	// Disabled rotation for this example
//	return NO;
// }

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc. that aren't in use.
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)dealloc
{
    [calendar release];
    [eventTable release];
    [selectedEvent release];
    [super dealloc];
}



@end