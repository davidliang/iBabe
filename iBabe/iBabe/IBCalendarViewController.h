//
//  IBCalendarViewController.h
//  iBabe
//
//  Created by David Liang on 19/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKCalendarMonthView.h"
#import <EventKit/EventKit.h>
#import "IBDateHelper.h"
#import "IBEditEventViewController.h"
#import "IBEventDetailsViewController.h"

@interface IBCalendarViewController : UIViewController<TKCalendarMonthViewDelegate,TKCalendarMonthViewDataSource, UITableViewDataSource,UITableViewDelegate>
{
	TKCalendarMonthView *calendar;	
	UITableView* eventTable;
	NSMutableArray* eventsForCurrentMonth;
	NSMutableArray* eventsForCurrentDate;
	
	EKEvent* selectedEvent;
}


- (void) toggleCalendar;



@end
