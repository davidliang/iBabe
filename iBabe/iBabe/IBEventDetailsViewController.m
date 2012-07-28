//
//  IBEventDetailsViewController.m
//  iBabe
//
//  Created by David Liang on 26/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];
	[self customiseUI];
}

-(void)customiseUI
{
    // --- Content and scroll view
    [[self contentView] setFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT*2, self.contentView.frame.size.width, self.lbNote.frame.origin.y + self.lbNote.frame.size.height + NAVIGATION_BAR_HEIGHT*3)];
    
    [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"] ]];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.contentView.frame.size.height) ];
    

}

-(void) initNavigationBar
{
    UIBarButtonItem* btnEdit = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIControlStateNormal target:self action:@selector(didTapNavEditButton)];
    [[self navigationItem] setRightBarButtonItem:btnEdit];
	
	[btnEdit release];
}

-(void) didTapNavEditButton
{
    [self performSegueWithIdentifier:@"segueEditEvent" sender:self];
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[self reloadData];
    [super viewWillAppear:YES];
}

-(void) reloadData
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
	else {
		[btnShowLocation setHidden:NO];
	}

}

- (void)dealloc {
    [lbEventTitle release];
    [currentEvent release];
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
    [super dealloc];
}

- (void)viewDidUnload {
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
    [super viewDidUnload];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"mapViewSegue"])
    {
        IBEventLocationMapViewController* locationViewCtrl = [segue destinationViewController];
        locationViewCtrl.location = [lbLocation text];
    }
	else if ([segue.identifier isEqualToString:@"segueEditEvent"]) {
		IBEditEventViewController* editEventViewCtrl = [segue destinationViewController];
		editEventViewCtrl.currentEvent = currentEvent;
	}

}

@end
