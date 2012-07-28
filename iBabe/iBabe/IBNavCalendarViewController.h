//
//  IBNavCalendarViewController.h
//  iBabe
//
//  Created by David on 3/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXCalendarView.h"

@interface IBNavCalendarViewController : UIViewController<UINavigationControllerDelegate, CXCalendarViewDelegate>

@property(assign) CXCalendarView *calendarView;
@end
