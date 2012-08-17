//
//  IBEKCalendarHelper.h
//  iBabe
//
//  Created by David Liang on 6/07/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
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
+ (EKCalendar*) getIBabeCalendar;



+ (BOOL) addEvent:(EKEvent*) newEvent;
+ (BOOL) updateEvent: (EKEvent*) event;
+ (BOOL) createIBabeCalendar;
+ (BOOL) deleteEvent: (NSString*) eventId;

+ (void) removeDevCal;





@end
