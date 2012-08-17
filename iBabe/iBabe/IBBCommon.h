//
//  IBBCommon.h
//  iBabe
//
//  Created by k on 6/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Settings;

@interface IBBCommon : NSObject

+ (NSDate *)loadDueDateFromPlist;
+ (void)saveDueDateToPlist:(NSDate *)date;

+ (NSNumber *)loadNoOfRecentRemindersFromPlist;
+ (void)saveNoOfRecentRemindersToPlist:(NSNumber *)amount;

+ (NSDate *)loadUserSelectedDateFromPlist;
+ (void)saveUserSelectedDateToPlist:(NSDate *)date;

+ (BOOL)loadIsDateTypeLastPeriodFromPlist;
+ (void)saveIsDateTypeLastPeriodToPlist:(BOOL)isLastPeriod;

+ (BOOL)loadIsDateTypeLastPeriodFromPlist;
+ (void)saveIsDateTypeLastPeriodToPlist:(BOOL)isLastPeriod;

+ (Settings *)loadSettingsFromPlist;
+ (void)saveSettingsToPlist:(Settings *)newSettings;

+ (void)createBBSettingsPlistFileForNewVersionWithThisVersionNumber:(int)thisVersion;

@end