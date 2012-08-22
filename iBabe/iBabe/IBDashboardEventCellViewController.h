//
//  IBDashboardEventCellViewController.h
//  iBabe
//
//  Created by David Liang on 22/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBDashboardEventCellViewController : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *lbMonth;
@property (retain, nonatomic) IBOutlet UILabel *lbDay;
@property (retain, nonatomic) IBOutlet UILabel *lbEventTitle;
@property (retain, nonatomic) IBOutlet UILabel *lbTime;
@property (retain, nonatomic) IBOutlet UILabel *lbDetails;
@property (retain, nonatomic) IBOutlet UILabel *lbLocation;
@property (retain, nonatomic) IBOutlet UIImageView *imgArrow;
@property (retain, nonatomic) IBOutlet UIImageView *imgBackground;


@end
