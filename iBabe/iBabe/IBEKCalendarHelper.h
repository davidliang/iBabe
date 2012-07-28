//
//  IBEKCalendarHelper.h
//  iBabe
//
//  Created by David Liang on 6/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

static NSString* CALENDAR_NAME = @"iBabe Calendar";
static NSString* USER_DEFAULT_CALENDAR_NAME=@"iBB_Cal_ID";
static NSString* URL_ID = @"http://iBabe.sigmapps.com.au";

@interface IBEKCalendarHelper : NSObject
{

}

+ (NSMutableArray*) getCurrentEventsWithTopEventNumber: (NSInteger) numberOfEvents;
+ (NSArray*) getEventsFromDate: (NSDate*) start toDate: (NSDate*) to;

+ (BOOL) updateEvent: (EKEvent*) event;
+ (BOOL) createIBabeCalendar;
+ (void) removeDevCal;
+ (EKCalendar*) getIBabeCalendar;



@end
