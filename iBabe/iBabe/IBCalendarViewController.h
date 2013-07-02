//
//  IBCalendarViewController.h
//  iBabe
//
//  Created by David Liang on 19/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKCalendarMonthView.h"
#import <EventKit/EventKit.h>
#import "IBDateHelper.h"
#import "IBEditEventViewController.h"
#import "IBEventDetailsViewController.h"
#import "IBEKCalendarHelper.h"
#import "IBEventCellViewController.h"
#import "IBTutorialDashboardViewControaller.h"
#import "IBAppDelegate.h"
#import "IBCheckPermissionLauncher.h"

@interface IBCalendarViewController : UIViewController <TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource, UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate,UIAlertViewDelegate>
{
    TKCalendarMonthView         *calendar;
    UITableView                 *eventTable;
    NSMutableArray              *eventsForCurrentMonth;
    NSMutableArray              *eventsForCurrentDate;
    NSDate                      *selectedDate;
    EKEvent                     *selectedEvent;

    UISwipeGestureRecognizer    *swipeDownRecognizer;
    UISwipeGestureRecognizer    *swipeUpRecognizer;
	
	UIButton* btnSpliter;
}

- (void)toggleCalendar;

@end