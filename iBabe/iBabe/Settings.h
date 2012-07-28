//
//  Settings.h
//  iBabe
//
//  Created by David on 7/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property (retain, nonatomic) NSDate* dueDate;
@property (retain, nonatomic) NSDate* userSelectedDate;
@property (nonatomic) BOOL isSelectedLastPeriod;

@end
