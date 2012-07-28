//
//  Settings.m
//  iBabe
//
//  Created by David on 7/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"

@implementation Settings
@synthesize isSelectedLastPeriod, dueDate, userSelectedDate;

-(id)init  
{
    
    if(self=[super init]){

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDate* initDate = [dateFormatter dateFromString:@"20/06/2013"];
    
    
    self.dueDate = initDate;
    self.userSelectedDate = initDate;
    self.isSelectedLastPeriod = NO;
    }
    
    return self;
    
}


@end
