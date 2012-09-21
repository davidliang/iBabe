//
//  IBBCommon.m
//  iBabe
//
//  Created by k on 6/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "IBBCommon.h"

@implementation IBBCommon

+ (void)createBBSettingsPlistFileForNewVersionWithThisVersionNumber:(int)thisVersion
{
    NSFileManager   *defFM = [NSFileManager defaultManager];
    NSString        *docsDir = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];

    // ..Stuff that is done only once when installing a new version....
    static NSString *AppVersionKey = @"appVersion";
    int             lastVersion = [userDefaults integerForKey:AppVersionKey];

    if (lastVersion != thisVersion)     // ..do this only once after install..
    {
        [userDefaults setInteger:thisVersion forKey:AppVersionKey];
        NSString    *appDir = [[NSBundle mainBundle] resourcePath];
        NSString    *src = [appDir stringByAppendingPathComponent:@"iBBSettings.plist"];
        NSString    *dest = [docsDir stringByAppendingPathComponent:@"iBBSettings.plist"];
        [defFM removeItemAtPath:dest error:NULL];    // ..remove old copy
        [defFM copyItemAtPath:src toPath:dest error:NULL];
    }

    // ..end of stuff done only once when installing a new version.
}



+ (NSDate *)loadDueDateFromPlist
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"iBBSettings.plist"];

    NSDictionary    *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDate          *date = [dict objectForKey:@"due_date"];

    return date;
}



+ (void)saveDueDateToPlist:(NSDate *)date
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"iBBSettings.plist"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];

    [dict setObject:date forKey:@"due_date"];
    [dict writeToFile:path atomically:YES];
}



+ (NSNumber *)loadNoOfRecentRemindersFromPlist
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"iBBSettings.plist"];

    NSDictionary    *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSNumber        *amount = [dict objectForKey:@"no_of_recent_reminders"];

    return amount;
}



+ (void)saveNoOfRecentRemindersToPlist:(NSNumber *)amount
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"iBBSettings.plist"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];

    [dict setObject:amount forKey:@"no_of_recent_reminders"];
    [dict writeToFile:path atomically:YES];
}



+ (void)saveUserSelectedDateToPlist:(NSDate *)date
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"iBBSettings.plist"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];

    [dict setObject:date forKey:@"user_selected_date"];
    [dict writeToFile:path atomically:YES];
}



+ (NSDate *)loadUserSelectedDateFromPlist
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"iBBSettings.plist"];

    NSDictionary    *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDate          *date = [dict objectForKey:@"user_selected_date"];

    return date;
}



+ (void)saveIsDateTypeLastPeriodToPlist:(BOOL)isLastPeriod
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"iBBSettings.plist"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];

    [dict setObject:[NSNumber numberWithBool:isLastPeriod] forKey:@"is_due_date_type_last_period"];
    [dict writeToFile:path atomically:YES];
}



+ (BOOL)loadIsDateTypeLastPeriodFromPlist
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"iBBSettings.plist"];

    NSDictionary    *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    BOOL            isLastPeriod = [[dict objectForKey:@"is_due_date_type_last_period"] boolValue];

    return isLastPeriod;
}



+ (void)saveSettingsToPlist:(Settings *)newSettings
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"iBBSettings.plist"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];

    [dict setObject:newSettings forKey:@"settings"];
    [dict writeToFile:path atomically:YES];
}



+ (Settings *)loadSettingsFromPlist
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"iBBSettings.plist"];

    NSDictionary    *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    Settings        *settings = [dict objectForKey:@"settings"];

    return settings;
}



+ (BOOL)checkIsDeviceVersionHigherThanRequiredVersion:(NSString *)requiredVersion
{
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];

    if ([currSysVer compare:requiredVersion options:NSNumericSearch] != NSOrderedAscending)
    {
        return YES;
    }

    return NO;
}



@end