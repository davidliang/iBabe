//
//  IBDateHelper.h
//  iBabe
//
//  Created by David on 7/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface IBDateHelper : NSObject

+(NSDate*)calculateDueDateBy:(NSDate* ) lastPeriodDate;
+(NSInteger) countDownGetRemainDayPartWith: (NSDate*) dueDate ReturnWeekPart: (BOOL) isReturnWeekPart;
+(NSInteger) countPregnancyDayPartWith: (NSDate*) dueDate ReturnWeekPart: (BOOL) isReturnWeekPart;
+(NSMutableArray*) getNumberImageNameByNumberForWeek: (NSInteger ) number;
+(NSMutableArray*) getNumberImageNameByNumberForDay: (NSInteger ) number;


#pragma -
#pragma Calendar Event Functions
+(void)addCalendarEventWithStartDate: (NSDate*) startDate EndDate:(NSDate*) endDate EventTitle: (NSString*) eventTitle  EventContents:(NSString*) eventContents AlarmInterval: (NSTimeInterval) alarmInterval;


@end
