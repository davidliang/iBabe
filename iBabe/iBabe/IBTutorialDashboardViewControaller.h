//
//  IBTutorialDashboardViewControaller.h
//  iBabe
//
//  Created by David on 28/08/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBTutorialDashboardViewControaller : UIView

@property (retain, nonatomic) IBOutlet UIButton *btnClose;

@property (retain, nonatomic) IBOutlet UIImageView *imgTutorial;

@property (retain, nonatomic) NSString *parentViewName;

- (IBAction)didTapCloseTutorial:(id)sender;

@end