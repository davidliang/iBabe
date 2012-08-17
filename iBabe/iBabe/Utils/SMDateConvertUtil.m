//
//  SMDateConvertUtil.m
//  iBabe
//
//  Created by David Liang on 25/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "SMDateConvertUtil.h"

@implementation SMDateConvertUtil

#pragma mark -
#pragma mark Convert NSDate to NSString

+ (NSString *)getDDMMYYYYhhmmssaFromNSDate:(NSDate *)rawDate
{
    return [self getNSDateInfoFromNSDate:rawDate forInfoTypeOf:6];
}



+ (NSString *)getSystemStdFormatFromNSDate:(NSDate *)rawDate
{
    return [self getNSDateInfoFromNSDate:rawDate forInfoTypeOf:7];
}



+ (NSString *)getDDMMYYYYFromNSDate:(NSDate *)rawDate
{
    return [self getNSDateInfoFromNSDate:rawDate forInfoTypeOf:5];
}



+ (NSString *)getDateFromNSDate:(NSDate *)rawDate
{
    return [self getNSDateInfoFromNSDate:rawDate forInfoTypeOf:2];
}



+ (NSString *)getMonthFromNSDate:(NSDate *)rawDate
{
    return [self getNSDateInfoFromNSDate:rawDate forInfoTypeOf:1];
}



+ (NSString *)getYearFromNSDate:(NSDate *)rawDate
{
    return [self getNSDateInfoFromNSDate:rawDate forInfoTypeOf:0];
}



+ (NSString *)getTimeFromNSDate:(NSDate *)rawDate
{
    return [self getNSDateInfoFromNSDate:rawDate forInfoTypeOf:4];
}



+ (NSString *)getDayFromNSDate:(NSDate *)rawDate
{
    return [self getNSDateInfoFromNSDate:rawDate forInfoTypeOf:3];
}



+ (NSString *)getFormatedDateStringForCalendarControllerFromNSDate:(NSDate *)rawDate
{
    return [self getNSDateInfoFromNSDate:rawDate forInfoTypeOf:8];
}



+ (NSString *)getNSDateInfoFromNSDate:(NSDate *)rawDate forInfoTypeOf:(NSInteger)infoType
{
    NSString *formatString = @"dd/MMM/yyyy hh:mm:ss a";

    switch (infoType) {
        case 0:
            formatString = @"yyyy"; // Year
            break;

        case 1:
            formatString = @"MMM"; // Month in 'Nov' form
            break;

        case 2:
            formatString = @"EEE"; // Weekday
            break;

        case 3:
            formatString = @"d"; // Date
            break;

        case 4:
            formatString = @"hh:mm:ss a"; // Time
            break;

        case 5:
            formatString = @"dd/MMM/yyyy";
            break;

        case 6:
            formatString = @"dd/MMM/yyyy hh:mm:ss a";
            break;

        case 7:
            formatString = @"yyyy-MM-dd hh:mm:ss Z";
            break;

        case 8:
            // --- This format is ONLY for the Tapku Calendar controller to put a dot mark on the calendar.
            formatString = @"yyyy-MM-dd 00:00:00 +0000";
            break;

        default:
            break;
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];

    if (rawDate == Nil)
    {
        rawDate = [NSDate date];
    }

    NSString *result = [formatter stringFromDate:rawDate];
    [formatter release];

    return result;
}



#pragma mark -
#pragma mark Convert NSString to NSDate

+ (NSDate *)convertString2Date:(NSString *)strDateTime withFormatterStyle:(dateFormatStringTypes)formatStyle
{
    if ([strDateTime isEqualToString:@""])
    {
        return [NSDate date];
    }

    NSString *formatStyleString = @"dd/MM/yyyy hh:mm:ss a";

    switch (formatStyle) {
        case ddMMyyyy:
            formatStyleString = @"dd/MM/yyyy";
            break;

        case ddMMMyyyy:
            formatStyleString = @"dd/MMM/yyyy";
            break;

        case hhmmssa:
            formatStyleString = @"hh:mm:ss a";
            break;

        case ddMMMyyyyhhmmssa:
            formatStyleString = @"dd/MMM/yyyy hh:mm:ss a";
            break;

        case ddMMyyyhhmmssa:
        default:
            break;
    }

    strDateTime = [strDateTime stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:formatStyleString];
    NSDate *result = [formatter dateFromString:strDateTime];

    return result;
}



+ (NSArray *)getBeginAndEndOfADate:(NSDate *)rawDate
{
    NSString    *baseDateStr = [SMDateConvertUtil getDDMMYYYYFromNSDate:rawDate];
    NSString    *endDateStr = [NSString stringWithFormat:@"%@ 11:59:59 pm", baseDateStr];
    NSString    *beginDateStr = [NSString stringWithFormat:@"%@ 00:00:00 am", baseDateStr];

    NSDate  *endDate = [SMDateConvertUtil convertString2Date:endDateStr withFormatterStyle:ddMMyyyhhmmssa];
    NSDate  *beginDate = [SMDateConvertUtil convertString2Date:beginDateStr withFormatterStyle:ddMMyyyhhmmssa];

    NSArray *results = [NSArray arrayWithObjects:beginDate, endDate, nil];

    return results;
}



@end