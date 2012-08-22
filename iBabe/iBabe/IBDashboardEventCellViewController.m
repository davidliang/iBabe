//
//  IBDashboardEventCellViewController.m
//  iBabe
//
//  Created by David Liang on 22/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "IBDashboardEventCellViewController.h"

@implementation IBDashboardEventCellViewController
@synthesize lbMonth;
@synthesize lbDay;
@synthesize lbEventTitle;
@synthesize lbTime;
@synthesize lbDetails;
@synthesize lbLocation;
@synthesize imgArrow;
@synthesize imgBackground;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self)
    {
        // Initialization code
    }

    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected)
    {
    }
    else
    {
    }

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)dealloc
{
    [lbMonth release];
    [lbDay release];
    [lbEventTitle release];
    [lbTime release];
    [lbDetails release];
    [lbLocation release];
    [imgArrow release];
    [imgBackground release];

    [super dealloc];
}



@end