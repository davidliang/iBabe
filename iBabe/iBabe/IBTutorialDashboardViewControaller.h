//
//  IBTutorialDashboardViewControaller.h
//  iBabe
//
//  Created by David on 28/08/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    IBParentViewNameDashboardView = 0,
    IBParentViewNameCalendarView = 1
} ParentViewName;

@interface IBTutorialDashboardViewControaller : UIView
{
	int currentParentViewName;
}

@property (retain, nonatomic) IBOutlet UIButton     *btnClose;
@property (retain, nonatomic) IBOutlet UIImageView  *imgTutorial;

- (IBAction)didTapCloseTutorial:(id)sender;
- (void) setTutorialWithParentViewName: (ParentViewName) pViewName;


@end