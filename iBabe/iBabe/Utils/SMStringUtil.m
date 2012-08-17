//
//  SMStringUtil.m
//  iBabe
//
//  Created by David Liang on 24/07/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "SMStringUtil.h"

@implementation SMStringUtil

+ (BOOL)isEmptyString:(NSString *)string
{
    if ([string length] == 0)   // string is empty or nil
    {
        return YES;
    }
    else if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
    {
        // string is all whitespace
        return YES;
    }

    return NO;
}



@end