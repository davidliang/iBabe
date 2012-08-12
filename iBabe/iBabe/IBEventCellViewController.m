//
//  IBDashBoardCellViewController.m
//  iBabe
//
//  Created by David on 10/08/12.
//
//

#import "IBEventCellViewController.h"

@implementation IBEventCellViewController
@synthesize lbTitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self)
    {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"button-pink-down.png"]]];
    }

    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)dealloc
{
    [lbTitle release];
    [super dealloc];
}



@end