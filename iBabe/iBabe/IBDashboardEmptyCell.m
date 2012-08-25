//
//  IBDashboardEmptyCell.m
//  iBabe
//
//  Created by David on 25/08/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "IBDashboardEmptyCell.h"

@implementation IBDashboardEmptyCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {

    [super dealloc];
}

@end
