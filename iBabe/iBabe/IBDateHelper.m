//
//  IBDateHelper.m
//  iBabe
//
//  Created by David on 7/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "IBDateHelper.h"
static NSString* appFlag = @"[iBabe]";

@implementation IBDateHelper


#pragma -
#pragma Calendar Event Functions


+(void)addCalendarEventWithStartDate: (NSDate*) startDate EndDate:(NSDate*) endDate EventTitle: (NSString*) eventTitle  EventContents:(NSString*) eventContents AlarmInterval: (NSTimeInterval) alarmInterval
{
	
	
	EKEventStore *eventStore = [[[EKEventStore alloc] init]autorelease];
	
	EKEvent *event = [EKEvent eventWithEventStore:eventStore];
	
	
	event.notes = appFlag;
	
	event.title = eventTitle;
	
	event.startDate = startDate;
	//This is startdate and time of the event we can set by using date time fucntions to calulate and set this.
	
	event.endDate = endDate;
	//Similarly this is event's end date and time
	
	NSTimeInterval interval = 60;
	//This is the time at which you can see the native calendar alert. Note that here i write (-min) this indicates that alert will show before event time otherwise it will appear after event start time
	
	EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:interval]; //Create object of alarm
	
	[event addAlarm:alarm]; //Add alarm to your event
	
	[event setCalendar:[eventStore defaultCalendarForNewEvents]];
	NSError *err;
	[eventStore saveEvent:event span:EKSpanThisEvent error:&err];
	// Add event to iPhone Calendar
}




#pragma -
#pragma Count down and pregnancy day calculation.

+(NSInteger)countPregnancyDayPartWith:(NSDate *)dueDate ReturnWeekPart:(BOOL)isReturnWeekPart
{
    NSInteger remainWeeks = [self countDownGetRemainDayPartWith:dueDate ReturnWeekPart:YES];
    NSInteger remainDays = [self countDownGetRemainDayPartWith:dueDate ReturnWeekPart:NO];
    

    
    NSInteger result = 39 - remainWeeks;
    
	if (7-remainDays ==7)
		result ++;
	
    if (!isReturnWeekPart)
	{
        result = 7 - remainDays;
		
		if (result == 7)
			result =0;
		
	}
	
    
    return result;
}


+(NSMutableArray*) getNumberImageNameByNumberForWeek: (NSInteger ) number
{
    
    NSString* imgNameUpL = @"b-0-up";
    NSString* imgNameDownL = @"b-0-down";
    
    NSString* imgNameUpR = @"b-0-up";
    NSString* imgNameDownR = @"b-0-down";
    
    NSInteger lNumber =floor(number/10);
    NSInteger rNumber =  number  - lNumber*10;
    
    
    imgNameUpL = [NSString stringWithFormat:@"b-%d-up",lNumber ];
    imgNameDownL = [NSString stringWithFormat:@"b-%d-down",lNumber ];
    
    imgNameUpR = [NSString stringWithFormat:@"b-%d-up",rNumber ];
    imgNameDownR = [NSString stringWithFormat:@"b-%d-down",rNumber ];
    
    
    
    NSMutableArray* imgNames = [NSMutableArray arrayWithObjects:imgNameUpL,imgNameDownL,imgNameUpR,imgNameDownR, nil];
    
    
    return imgNames;
    
}

+(NSMutableArray *)getNumberImageNameByNumberForDay:(NSInteger)number
{
    NSString* imgNameUp = @"w-0-up";
    NSString* imgNameDown = @"w-0-down";
    
    if (number<10 && number>0)
    {
        
        imgNameUp = [NSString stringWithFormat:@"w-%d-up",number ];
        imgNameDown = [NSString stringWithFormat:@"w-%d-down",number ];
    }
    
    NSMutableArray* imgNames = [NSMutableArray arrayWithObjects:imgNameUp,imgNameDown, nil];
    return imgNames;
}



+(NSInteger)countDownGetRemainDayPartWith:(NSDate *)dueDate ReturnWeekPart:(BOOL)isReturnWeekPart
{
    NSDate* now = [NSDate date];
    
    [dueDate compare:now];
    
    NSDateFormatter *df = [NSDateFormatter new];  
    [df setDateFormat:@"dd MM yyyy"]; // here we cut time part
    NSString *todayString = [df stringFromDate:[NSDate date]];
    NSString *targetDateString = [df stringFromDate:dueDate]; 
    
    NSTimeInterval time = [[df dateFromString:targetDateString]    timeIntervalSinceDate:[df dateFromString:todayString]];
    [df release];
    
    
    if(time <=0)
        return 0;
    
    int differenceTotalDays = time / 60 / 60/ 24;
    
    int differenceWeeks = differenceTotalDays/7;
    int differenceDaysLeft = differenceTotalDays - differenceWeeks*7;
    
	if (differenceDaysLeft==7)
	{
		differenceDaysLeft = 0;
		differenceWeeks++;
	}
	
    if (isReturnWeekPart)
    {
        return differenceWeeks;
    }
    
    
    return differenceDaysLeft;
}



+(NSDate *)calculateDueDateBy:(NSDate *)lastPeriodDate
{
    int weeksMax = 40;
    //int weeksMin = 37;
    
    NSDate* dueDate = [lastPeriodDate dateByAddingTimeInterval:60*60*24*7*weeksMax]; 
    
    return dueDate;
    
}

@end
