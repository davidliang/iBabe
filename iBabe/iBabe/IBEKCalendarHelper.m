//
//  IBEKCalendarHelper.m
//  iBabe
//
//  Created by David Liang on 6/07/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "IBEKCalendarHelper.h"

@implementation IBEKCalendarHelper

+ (NSArray *)getEventsFromDate:(NSDate *)start toDate:(NSDate *)to
{
    EKEventStore *currentEventStore = [[EKEventStore alloc] init];

    NSPredicate *predicate;
    NSArray     *matchedEvents;

    EKCalendar      *ibbCal = [IBEKCalendarHelper getIBabeCalendar];
    NSMutableArray  *cals = [[NSMutableArray alloc] initWithObjects:ibbCal, nil];

    if ([cals count] < 1)
    {
        [cals release];
        [currentEventStore release];

        return nil;
    }

    predicate = [currentEventStore predicateForEventsWithStartDate:start endDate:to calendars:cals];
    matchedEvents = [currentEventStore eventsMatchingPredicate:predicate];

    //	[cals release];
    //	[currentEventStore release];
    return matchedEvents;
}



+ (NSMutableArray *)getCurrentEventsWithTopEventNumber:(NSInteger)numberOfEvents
{
    // --- The maximun months that the logic will go through get the events.
    // --- This is to avoid the logic keep looping through the whole calendar unlimitly.
    // --- Default value is to go through 12 months.
    NSInteger maxLoopCount = 12;

    NSMutableArray  *currentEvents = [[NSMutableArray alloc] init];
    EKEventStore    *currentEventStore = [[EKEventStore alloc] init];

    NSInteger   daysInSecond = 24 * 60 * 60;
    NSDate      *fromDate = [NSDate date];
    NSDate      *toDate = [fromDate dateByAddingTimeInterval:daysInSecond * 30];

    NSInteger   eventCount = 0;
    NSPredicate *predicate;
    NSArray     *matchedEvents;
    BOOL        enoughEvent = NO;

    EKCalendar      *ibbCal = [IBEKCalendarHelper getIBabeCalendar];
    NSMutableArray  *cals = [[NSMutableArray alloc] initWithObjects:ibbCal, nil];

    if ([cals count] > 0)
    {
        for (int currentLoop = 0; !enoughEvent && currentLoop < maxLoopCount; currentLoop++) {
            predicate = [currentEventStore predicateForEventsWithStartDate:fromDate endDate:toDate calendars:cals];
            matchedEvents = [currentEventStore eventsMatchingPredicate:predicate];

            for (EKEvent *anEvent in matchedEvents) {
                if (eventCount == numberOfEvents)
                {
                    enoughEvent = YES;
                    break;
                }

                [currentEvents addObject:anEvent];
                eventCount++;
            }

            fromDate = [toDate dateByAddingTimeInterval:daysInSecond * 1];
            toDate = [toDate dateByAddingTimeInterval:daysInSecond * 4 * 7];
        }
    }

    return currentEvents;
}



+ (BOOL)createIBabeCalendar
{
    EKEventStore    *eventStore = [[EKEventStore alloc] init];
    EKSource        *locSource = Nil;

    // ---- Check if there is a local event source.
    for (EKSource *aSource in eventStore.sources) {
        if (aSource.sourceType == EKSourceTypeLocal)
        {
            locSource = aSource;
            break;
        }
    }

    // --- If local source not available then return nil.
    if (locSource == nil)
    {
        [eventStore release];
        return NO;
    }

    // --- Check if the iBabe Calendar exist or not.
    BOOL ibbCalExist = NO;

    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    NSString        *calID = [userDefault objectForKey:USER_DEFAULT_CALENDAR_NAME];

    // --- Cal ID has already been set to the user settings.
    // --- That means app had been ran before and Cal has been created.
    if (calID != Nil)
    {
        for (EKCalendar *aCal in [eventStore calendarsForEntityType:EKEntityTypeEvent]) {
            if ([aCal.title isEqualToString:CALENDAR_NAME])
            {
                ibbCalExist = YES;
                break;
            }

            if ([aCal.calendarIdentifier isEqualToString:calID])
            {
                ibbCalExist = YES;
                break;
            }
        }
    }
    else
    {
        // --->>Cal ID hasn't been set to the user settings.
        // --- That can be either 1st time user of the app OR the app has been
        // --- installed but removed and the user reinstall again. In this case,
        // --- the app will check if there is any iBabe Calendar existing, if yes
        // --- the app will pick up the exiting Calendar ID and add to the user settings.
        // --- If not, then add a new one.

        for (EKCalendar *aCal in [eventStore calendarsForEntityType:EKEntityTypeEvent]) {
            if ([aCal.title isEqualToString:CALENDAR_NAME])
            {
                ibbCalExist = YES;

                // -- Add the existing calender identifier to the user defaults.
                [userDefault setObject:aCal.calendarIdentifier forKey:USER_DEFAULT_CALENDAR_NAME];

                break;
            }
        }
    }

    if (!ibbCalExist)
    {
        //EKCalendar *ibbCal = [EKCalendar calendarWithEventStore:eventStore];
		EKCalendar *ibbCal = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:eventStore];
		
		
        ibbCal.title = CALENDAR_NAME;
        ibbCal.source = locSource;
        calID = ibbCal.calendarIdentifier;

        NSError *err = Nil;
        BOOL    calAdded = [eventStore saveCalendar:ibbCal commit:YES error:&err];

        [eventStore release];

        if (calAdded)
        {
            // -- Add the calender identifier to the user defaults.
            [userDefault setObject:calID forKey:USER_DEFAULT_CALENDAR_NAME];

            // NSLog(@"iBBCal Added. Cal Id=%@", calID);
            return YES;
        }
        else
        {
            // NSLog(@"iBBCal can't be added");
            return NO;
        }

        [ibbCal release];
    }

    [eventStore release];
    return YES;
}



+ (BOOL)deleteEvent:(NSString *)eventId
{
    EKEventStore    *eventStore = [[EKEventStore alloc] init];
    EKEvent         *event = [eventStore eventWithIdentifier:eventId];

    NSError *err = Nil;

    [eventStore removeEvent:event span:EKSpanThisEvent commit:YES error:&err];

    [eventStore release];

    if (err != noErr)
    {
        NSLog(@"##ERROR: deleteEvent Err - %@", err);
        return NO;
    }

    return YES;
}



+ (void)removeDevCal
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];

    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    NSString        *calID = [userDefault objectForKey:USER_DEFAULT_CALENDAR_NAME];

    NSError     *e = Nil;
    EKCalendar  *tCal = [eventStore calendarWithIdentifier:calID];

    [eventStore removeCalendar:tCal commit:YES error:&e];

    for (EKCalendar *aCal in [eventStore calendarsForEntityType:EKEntityTypeEvent]) {
        if ([aCal.title isEqualToString:CALENDAR_NAME])
        {
            [eventStore removeCalendar:aCal commit:YES error:&e];
            break;
        }
    }

    [eventStore release];
}



+ (EKCalendar *)getIBabeCalendar
{
    if ([IBEKCalendarHelper createIBabeCalendar])
    {
        EKEventStore    *eventStore = [[EKEventStore alloc] init];
        NSString        *calID = [[NSUserDefaults new] objectForKey:USER_DEFAULT_CALENDAR_NAME];

        EKCalendar *ibbCal = [eventStore calendarWithIdentifier:calID];

        [eventStore release];
        return ibbCal;
    }

    return Nil;
}



+ (BOOL)updateEvent:(EKEvent *)event
{
    EKEventStore    *eventStore = [[EKEventStore alloc] init];
    NSError         *err = nil;

    EKEvent *storedEvent = [eventStore eventWithIdentifier:event.eventIdentifier];

    storedEvent.title = event.title;
    storedEvent.location = event.location;
    storedEvent.startDate = event.startDate;
    storedEvent.endDate = event.endDate;
    storedEvent.alarms = event.alarms;
    storedEvent.notes = event.notes;

    [eventStore saveEvent:storedEvent span:EKSpanThisEvent error:&err];

    [eventStore release];

    if (err != noErr)
    {
        NSLog(@"##ERROR: updateEvent Err - %@", err);
        return NO;
    }

    return YES;
}



+ (BOOL)addEvent:(EKEvent *)newEvent
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];

    EKEvent         *event = [EKEvent eventWithEventStore:eventStore];
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    NSString        *calID = [userDefault objectForKey:USER_DEFAULT_CALENDAR_NAME];

    event.calendar = [eventStore calendarWithIdentifier:calID];

    event.title = newEvent.title;
    event.URL = newEvent.URL;
    event.location = newEvent.location;
    event.startDate = newEvent.startDate;
    event.endDate = newEvent.endDate;
    event.notes = newEvent.notes;
    event.alarms = newEvent.alarms;

    NSError *err = nil;
    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];

    if (err != noErr)
    {
        NSLog(@"%@", err);
        return NO;
    }

    return YES;
}



//#pragma mark-
//#pragma UIAlertView Delegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
//
//    switch (buttonIndex) {
//        case 0:
//            NSLog(@"0");
//            break;
//
//        case 1:
//
//            [[UIApplication sharedApplication] openURL:url];
//            break;
//
//        default:
//            break;
//    }
//}
//
//
//
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//}
//
//
//
//+ (void)checkAccessPermissionWithEventStoreObj:(EKEventStore *)eventStore
//{
//    if ([IBBCommon checkIsDeviceVersionHigherThanRequiredVersion:@"6.0"])
//    {
//        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * error) {
//                if (!granted)
//                {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint" message:@"Please allow iBabe to access to your calendar for the reminder feature of the iBabe." delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles:@"Settings", nil];
//
//                    [alert show];
//                }
//            }];
//    }
//}

+ (BOOL)checkIsCalendarAccessible
{
    EKEventStore    *eventStore = [[EKEventStore alloc] init];
    __block BOOL    canAccess = NO;
//	__block BOOL blockRan = NO;
	
	
	
	
	
	
	if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
	{
		/* iOS Settings > Privacy > Calendars > MY APP > ENABLE | DISABLE */
		[eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
		 {
			 if ( granted )
			 {
				 NSLog(@"User has granted permission!");
			 }
			 else
			 {
				 NSLog(@"User has not granted permission!");
			 }
			 
			 if (error!=Nil)
			 {
				 NSLog (@"# checkIsCalendarAccessible ERROR = %@", error);
			 }

			 
			 canAccess = granted;
		 }];
	}
	
	
	
	
//	if(![IBBCommon checkIsDeviceVersionHigherThanRequiredVersion:@"6"])
//		   return NO;
//	
//	
//	
//    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * error) {
//            canAccess = granted;
//
//            if (error!=Nil)
//            {
//                NSLog (@"# checkIsCalendarAccessible ERROR = %@", error);
//            }
//		    
////			blockRan = YES;
//        }];

//	while (!blockRan) {
//		sleep(1);
//	}
	
	[eventStore release];
    return canAccess;
}
@end