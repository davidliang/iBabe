//
//  IBFirstViewController.m
//  iBabe
//
//  Created by David on 3/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

#import "IBDashBoardViewController.h"
#import "IBDateHelper.h"
#import "IBBCommon.h"
#import "IBDashboardEventCellViewController.h"
#import "SMDateConvertUtil.h"
#import "IBEventDetailsViewController.h"
#import "IBEKCalendarHelper.h"
// #import "EventKitDataSource.h"

@implementation IBDashBoardViewController
@synthesize eventsList;
@synthesize topViewPageControl;
@synthesize topScrollView;
@synthesize weekIdxTopLeftPregnant;
@synthesize weekIdxBottomLeftPregnant;
@synthesize weekIdxTopRightPregnant;
@synthesize weekIdxBottomRightPregnant;
@synthesize dayIdxTopPregnant;
@synthesize dayIdxBottomPregnant;
@synthesize weekIdxTopLeft;
@synthesize weekIdxBottomLeft;
@synthesize weekIdxTopRight;
@synthesize weekIdxBottomRight;
@synthesize dayIdxTop;
@synthesize dayIdxBottom;
@synthesize dueDateCountDownSubView;
@synthesize pregnantDaysSubView;

#pragma mark- Top scroll view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.topScrollView.frame.size.width;
    int     page = floor((self.topScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    self.topViewPageControl.currentPage = page;
}



- (IBAction)onTopViewChanged:(id)sender
{
    // update the scroll view to the appropriate page
    CGRect frame;

    frame.origin.x = self.topScrollView.frame.size.width * self.topViewPageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.topScrollView.frame.size;
    [self.topScrollView scrollRectToVisible:frame animated:YES];
}



#pragma mark- table view delegate

// Section headers
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Events";
    }

    return @"";
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] autorelease];

    header.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category-title-bar.png"]];
    UILabel     *title = [[[UILabel alloc] initWithFrame:CGRectMake(20, 2, 200, 20)] autorelease];
    [title setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
    [title setTextColor:[UIColor grayColor]];
    [title setBackgroundColor:[UIColor clearColor]];

    [title setText:@"Upcoming reminders"];

    [header addSubview:headerImage];
    [header addSubview:title];
    [headerImage release];

    return header;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.

    if ([currentEvents count] == 0)
    {
        return 1;
    }

    return [currentEvents count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (([currentEvents count] == 0) && (indexPath.row == 0))
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc]    initWithStyle   :UITableViewCellStyleSubtitle
                                                reuseIdentifier :@"cell"] autorelease];
            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
        }

        cell.detailTextLabel.text = @"No reminder records.";

        return cell;
    }

    static NSString *CellIdentifier = @"EventCell";

    IBDashboardEventCellViewController *cell = (IBDashboardEventCellViewController *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
    {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"DashboardEventCell" owner:nil options:nil];

        for (UIView *currentView in views) {
            if ([currentView isKindOfClass:[UITableViewCell class]])
            {
                cell = (IBDashboardEventCellViewController *)currentView;
                break;
            }
        }
    }

    // Add shadow for last row
    if (indexPath.row == [currentEvents count] - 1)
    {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 75, 320, 10);

        UIColor *lightColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        UIColor *darkColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];

        gradient.colors = [NSArray arrayWithObjects:(id)darkColor.CGColor, (id)lightColor.CGColor, nil];
        [cell.layer insertSublayer:gradient atIndex:0];
    }

    EKEvent *cellEvent = [currentEvents objectAtIndex:[indexPath row]];

    NSString *month = [SMDateConvertUtil getMonthFromNSDate:[cellEvent startDate]];

    NSString    *time = [SMDateConvertUtil getTimeFromNSDate:[cellEvent startDate]];
    NSString    *day = [SMDateConvertUtil getDayFromNSDate:[cellEvent startDate]];

    NSString *location = @"";

    if ([cellEvent location] != NULL)
    {
        location = [cellEvent location];
    }

    [cell.lbLocation setText:[NSString stringWithFormat:@"Location: %@", location]];
    [cell.lbDetails setText:[cellEvent notes]];
    [cell.lbEventTitle setText:[cellEvent title]];
    [cell.lbTime setText:[NSString stringWithFormat:@"Time: %@", time]];
    [cell.lbDay setText:day];
    [cell.lbMonth setText:month];

    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([currentEvents count] > 0)
    {
        UIStoryboard                    *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        IBEventDetailsViewController    *eventView = [sb instantiateViewControllerWithIdentifier:@"IBEventDetailsViewController"];

        [eventView setCurrentEvent:(EKEvent *)[currentEvents objectAtIndex:[indexPath row]]];

        [[self navigationController] pushViewController:eventView animated:YES];
    }
}



- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}



#pragma mark- Logic for the top count down view.

- (void)initWeekAndDayIndicatorsForCountDown
{
    NSDate *due = [IBBCommon loadDueDateFromPlist];

    NSInteger   weeks = [IBDateHelper countDownGetRemainDayPartWith:due ReturnWeekPart:YES];
    NSInteger   days = [IBDateHelper countDownGetRemainDayPartWith:due ReturnWeekPart:NO];

    // ---- Week Indicator - left part
    NSMutableArray *imgNamesForWeek = [IBDateHelper getNumberImageNameByNumberForWeek:weeks];

    NSMutableArray *imgNamesForDay = [IBDateHelper getNumberImageNameByNumberForDay:days];

    UIImage *imgWTL = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imgNamesForWeek objectAtIndex:0] ofType:@"png"]];
    UIImage *imgWBL = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imgNamesForWeek objectAtIndex:1] ofType:@"png"]];

    // ---- Week Indicator - Right part
    UIImage *imgWTR = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imgNamesForWeek objectAtIndex:2] ofType:@"png"]];
    UIImage *imgWBR = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imgNamesForWeek objectAtIndex:3] ofType:@"png"]];

    // ---- Day Indicator
    UIImage *imgDT = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imgNamesForDay objectAtIndex:0] ofType:@"png"]];
    UIImage *imgDB = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imgNamesForDay objectAtIndex:1] ofType:@"png"]];

    [weekIdxTopLeft setImage:imgWTL];
    [weekIdxBottomLeft setImage:imgWBL];

    [weekIdxTopRight setImage:imgWTR];
    [weekIdxBottomRight setImage:imgWBR];

    [dayIdxTop setImage:imgDT];
    [dayIdxBottom setImage:imgDB];
}



- (void)initWeekAndDayIndicatorsForPregnancyDays
{
    NSDate *due = [IBBCommon loadDueDateFromPlist];

    NSInteger   weeks = [IBDateHelper countPregnancyDayPartWith:due ReturnWeekPart:YES];
    NSInteger   days = [IBDateHelper countPregnancyDayPartWith:due ReturnWeekPart:NO];

    // ---- Week Indicator - left part
    NSMutableArray *imgNamesForWeek = [IBDateHelper getNumberImageNameByNumberForWeek:weeks];

    NSMutableArray *imgNamesForDay = [IBDateHelper getNumberImageNameByNumberForDay:days];

    UIImage *imgWTL = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imgNamesForWeek objectAtIndex:0] ofType:@"png"]];
    UIImage *imgWBL = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imgNamesForWeek objectAtIndex:1] ofType:@"png"]];

    // ---- Week Indicator - Right part
    UIImage *imgWTR = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imgNamesForWeek objectAtIndex:2] ofType:@"png"]];
    UIImage *imgWBR = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imgNamesForWeek objectAtIndex:3] ofType:@"png"]];

    // ---- Day Indicator
    UIImage *imgDT = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imgNamesForDay objectAtIndex:0] ofType:@"png"]];
    UIImage *imgDB = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imgNamesForDay objectAtIndex:1] ofType:@"png"]];

    [weekIdxTopLeftPregnant setImage:imgWTL];
    [weekIdxBottomLeftPregnant setImage:imgWBL];

    [weekIdxTopRightPregnant setImage:imgWTR];
    [weekIdxBottomRightPregnant setImage:imgWBR];

    [dayIdxTopPregnant setImage:imgDT];
    [dayIdxBottomPregnant setImage:imgDB];
}



- (void)initRemindersList
{
    currentEvents = [IBEKCalendarHelper getCurrentEventsWithTopEventNumber:[[IBBCommon loadNoOfRecentRemindersFromPlist] integerValue]];
    [eventsList reloadData];
}



#pragma mark- View lifecycle
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    self.topScrollView.contentSize = CGSizeMake(self.topScrollView.frame.size.width * 2, self.topScrollView.frame.size.height);
    self.topViewPageControl.currentPage = 0;
}



- (void)viewDidUnload
{
    [self setWeekIdxTopLeft:nil];
    [self setWeekIdxBottomLeft:nil];
    [self setWeekIdxTopRight:nil];
    [self setWeekIdxBottomRight:nil];
    [self setDayIdxTop:nil];
    [self setDayIdxBottom:nil];
    [self setDueDateCountDownSubView:nil];
    [self setPregnantDaysSubView:nil];
    [self setTopViewPageControl:nil];
    [self setWeekIdxTopLeftPregnant:nil];
    [self setWeekIdxBottomLeftPregnant:nil];
    [self setWeekIdxTopRightPregnant:nil];
    [self setWeekIdxBottomRightPregnant:nil];
    [self setDayIdxTopPregnant:nil];
    [self setDayIdxBottomPregnant:nil];
    [self setEventsList:nil];
    [self setTopScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)viewWillAppear:(BOOL)animated
{
    [self initWeekAndDayIndicatorsForCountDown];
    [self initWeekAndDayIndicatorsForPregnancyDays];

    // --- Init the Reminders list.
    [self initRemindersList];

    [[self navigationController] setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
}



- (void)loadView
{
    [super loadView];
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO];
    [super viewWillDisappear:animated];
}



- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
    else
    {
        return interfaceOrientation == UIInterfaceOrientationPortrait;
    }
}



- (void)dealloc
{
    [weekIdxTopLeft release];
    [weekIdxBottomLeft release];
    [weekIdxTopRight release];
    [weekIdxBottomRight release];
    [dayIdxTop release];
    [dayIdxBottom release];
    [dueDateCountDownSubView release];
    [pregnantDaysSubView release];
    [topViewPageControl release];
    [weekIdxTopLeftPregnant release];
    [weekIdxBottomLeftPregnant release];
    [weekIdxTopRightPregnant release];
    [weekIdxBottomRightPregnant release];
    [dayIdxTopPregnant release];
    [dayIdxBottomPregnant release];
    [eventsList release];
    [topScrollView release];
    [super dealloc];
}



@end