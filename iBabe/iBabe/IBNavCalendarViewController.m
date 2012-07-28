//
//  IBNavCalendarViewController.m
//  iBabe
//
//  Created by David on 3/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IBNavCalendarViewController.h"

@implementation IBNavCalendarViewController

@synthesize calendarView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void) loadView {
    [super loadView];
    
    self.calendarView = [[CXCalendarView new] autorelease];
    [self.view addSubview: self.calendarView];
    self.calendarView.frame = self.view.bounds;
    self.calendarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.calendarView.selectedDate = [NSDate date];
    
    self.calendarView.delegate = self;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void) calendarView: (CXCalendarView *) calendarView
        didSelectDate: (NSDate *) date {
    
    NSLog(@"Selected date: %@", date);
    //TTAlert([NSString stringWithFormat: @"Selected date: %@", date]);
}


@end
