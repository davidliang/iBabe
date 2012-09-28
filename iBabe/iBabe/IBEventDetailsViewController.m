//
//  IBEventDetailsViewController.m
//  iBabe
//
//  Created by David Liang on 26/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "IBEventDetailsViewController.h"
#import "SMDateConvertUtil.h"
#import "IBEventLocationMapViewController.h"
#import "IBEditEventViewController.h"

static const CGFloat NAVIGATION_BAR_HEIGHT = 44;

@implementation IBEventDetailsViewController
@synthesize btnShowLocation;
@synthesize lbDate;
@synthesize lbStartTime;
@synthesize lbEndTime;
@synthesize lbAlarm1;
@synthesize lbAlarm2;
@synthesize lbNote;
@synthesize lbLocation;
@synthesize contentView;
@synthesize scrollView;
@synthesize lbEventTitle, currentEvent;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];
    [self customiseUI];

    alarmValues = [[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:-5 * 60], [NSNumber numberWithInt:-15 * 60], [NSNumber numberWithInt:-30 * 60], [NSNumber numberWithInt:-60 * 60], [NSNumber numberWithInt:-2 * 60 * 60], [NSNumber numberWithInt:-24 * 60 * 60], [NSNumber numberWithInt:-2 * 24 * 60 * 60], nil] autorelease];

    alarmTitles = [[[NSArray alloc] initWithObjects:@"At time of event", @"5 mins before", @"15 mins before", @"30 mins before", @"1 hour before", @"2 hours before", @"1 day before", @"2 days before", @"Not Set", nil] autorelease];

    NSString    *alarmTitle1 = @"Not Set";
    NSString    *alarmTitle2 = @"Not Set";

    if (currentEvent.alarms != Nil)
    {
        if ([currentEvent.alarms count] > 0)
        {
            EKAlarm *alarm1 = [currentEvent.alarms objectAtIndex:0];

            if (alarm1 != Nil)
            {
                NSInteger alarm1Row = [alarmValues indexOfObject:[NSNumber numberWithInt:alarm1.relativeOffset]];
                alarmTitle1 = [alarmTitles objectAtIndex:alarm1Row];
            }
        }

        if ([currentEvent.alarms count] > 1)
        {
            EKAlarm *alarm2 = [currentEvent.alarms objectAtIndex:1];

            if (alarm2 != Nil)
            {
                NSInteger alarm2Row = [alarmValues indexOfObject:[NSNumber numberWithInt:alarm2.relativeOffset]];
                alarmTitle2 = [alarmTitles objectAtIndex:alarm2Row];
            }
        }
    }

    [lbAlarm1 setText:alarmTitle1];
    [lbAlarm2 setText:alarmTitle2];
}



- (void)customiseUI
{
    // --- Content and scroll view

    CGFloat y = [[UIApplication sharedApplication] statusBarFrame].size.height + fabs(self.navigationController.navigationBar.frame.origin.y) + self.navigationController.navigationBar.frame.size.height;

    [self.scrollView setFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.scrollView];

    [[self contentView] setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.lbNote.frame.origin.y + self.lbNote.frame.size.height + NAVIGATION_BAR_HEIGHT * 3)];

    [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];

    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.contentView.frame.size.height)];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
}



- (void)initNavigationBar
{
    UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIControlStateNormal target:self action:@selector(didTapNavEditButton)];

    [[self navigationItem] setRightBarButtonItem:btnEdit];

    [btnEdit release];
}



- (void)didTapNavEditButton
{
    [self performSegueWithIdentifier:@"segueEditEvent" sender:self];
}



- (void)viewWillAppear:(BOOL)animated
{
    [self reloadData];
    [super viewWillAppear:YES];
}



- (void)reloadData
{
    [lbEventTitle setText:[currentEvent title]];
    [lbNote setText:[currentEvent notes]];
    [lbLocation setText:[currentEvent location]];
    [lbStartTime setText:[SMDateConvertUtil getDDMMYYYYhhmmssaFromNSDate:[currentEvent startDate]]];
    [lbEndTime setText:[SMDateConvertUtil getDDMMYYYYhhmmssaFromNSDate:[currentEvent endDate]]];
    [lbDate setText:[SMDateConvertUtil getDDMMYYYYFromNSDate:[currentEvent startDate]]];

    if ([SMStringUtil isEmptyString:[currentEvent location]])
    {
        [btnShowLocation setHidden:YES];
    }
    else
    {
        [btnShowLocation setHidden:NO];
    }
}



- (void)dealloc
{
    [lbEventTitle release];
    //  [currentEvent release];
    [lbDate release];
    [lbStartTime release];
    [lbEndTime release];
    [lbLocation release];
    [lbNote release];
    [btnShowLocation release];
    [lbAlarm1 release];
    [lbAlarm2 release];
    [contentView release];
    [scrollView release];
    [_baseView release];
    [super dealloc];
}



- (void)viewDidUnload
{
    [self setLbEventTitle:nil];
    [self setLbDate:nil];
    [self setLbStartTime:nil];
    [self setLbEndTime:nil];
    [self setLbLocation:nil];
    [self setLbNote:nil];
    [self setBtnShowLocation:nil];
    [self setLbAlarm1:nil];
    [self setLbAlarm2:nil];
    [self setContentView:nil];
    [self setScrollView:nil];
    [self setBaseView:nil];
    [super viewDidUnload];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"mapViewSegue"])
    {
        IBEventLocationMapViewController *locationViewCtrl = [segue destinationViewController];
        locationViewCtrl.location = [lbLocation text];
    }
    else if ([segue.identifier isEqualToString:@"segueEditEvent"])
    {
        IBEditEventViewController *editEventViewCtrl = [segue destinationViewController];
        editEventViewCtrl.currentEvent = currentEvent;
        editEventViewCtrl.isNewEvent = NO;
    }
}



@end