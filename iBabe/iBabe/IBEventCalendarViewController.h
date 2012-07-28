//
//  IBEventCalendarViewController.h
//  iBabe
//
//  Created by David Liang on 11/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kal.h"

@interface IBEventCalendarViewController : KalViewController<UITableViewDelegate>
{
	id eventsDateSource;
}
@property (retain, nonatomic) IBOutlet UINavigationItem *navItems;

@end
