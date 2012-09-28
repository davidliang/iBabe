//
//  IBWelcomeViewController.m
//  iBabe
//
//  Created by David on 16/09/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "IBWelcomeViewController.h"

@implementation IBWelcomeViewController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        // Initialization code
    }

    return self;
}



/*
 *   // Only override drawRect: if you perform custom drawing.
 *   // An empty implementation adversely affects performance during animation.
 *   - (void)drawRect:(CGRect)rect
 *   {
 *    // Drawing code
 *   }
 */

- (void)initContentViews
{
    [_contentScrollView setFrame:CGRectMake(0, 0, self.bounds.size.width, self.frame.size.height)];
    [_contentScrollView setContentSize:CGSizeMake(_contentView.frame.size.width, self.frame.size.height)];
    [_contentScrollView setDelegate:self];

    [_contentView setFrame:CGRectMake(0, 0, _contentView.frame.size.width, _contentScrollView.frame.size.height)];

    [_contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"transparent-bg.png"]]];

    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"m-bg.png"]]];
}



- (IBAction)didTapCloseWelcomeBtn:(id)sender
{
    // ---- TODO: un comment
    //	NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    //	[userDef setBool:YES forKey:@"shownWelcome"];

    [self removeFromSuperview];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.contentScrollView.frame.size.width;
    int     page = floor((self.contentScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    self.pageCtrl.currentPage = page;
}



- (void)dealloc
{
    [_contentScrollView release];
    [_contentView release];
    [_pageCtrl release];
    [super dealloc];
}



@end