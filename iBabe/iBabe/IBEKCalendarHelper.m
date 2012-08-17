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

    predicate = [currentEventStore predicateForEventsWithStartDate:start endDate:to calendars:cals];
    matchedEvents = [currentEventStore eventsMatchingPredicate:predicate];

    return matchedEvents;
}



+ (NSMutableArray *)getCurrentEventsWithTopEventNumber:(NSInteger)numberOfEvents
{
    // --- The maximun months that the logic will go through get the events.
    // --- This is to avoid the logic keep looping through the whole calendar unlimitly.
    // --- TODO: this should be able to setup from the config page.
    NSInteger maxLoopCount = 11;

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

        fromDate = toDate;
        toDate = [toDate dateByAddingTimeInterval:daysInSecond * 30];
    }

    return currentEvents;
}



+ (BOOL)createIBabeCalendar
{
    EKEventStore    *eventStore = [[EKEventStore alloc] init];
    EKSource        *locSource;

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
        return NO;
    }

    // --- Check if the iBabe Calendar exist or not.
    BOOL ibbCalExist = NO;

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

    NSString *calID = [userDefault objectForKey:USER_DEFAULT_CALENDAR_NAME];

    if (calID != Nil)
    {
        for (EKCalendar *aCal in eventStore.calendars) {
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

    if (!ibbCalExist)
    {
        EKCalendar *ibbCal = [EKCalendar calendarWithEventStore:eventStore];
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

    for (EKCalendar *aCal in eventStore.calendars) {
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
        return [ibbCal autorelease];
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
    EKEventStore    *eventStore = [[EKEventStore alloc] init];
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



@end