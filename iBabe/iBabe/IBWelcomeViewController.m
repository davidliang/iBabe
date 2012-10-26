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

    [_viewTop setFrame:CGRectMake(_viewTop.frame.origin.x, (self.frame.size.height - _viewTop.frame.size.height) / 2, _viewTop.frame.size.width, _viewTop.frame.size.height)];
    [_viewBottom setHidden:YES];
    [_viewBottom setFrame:CGRectMake(_viewBottom.frame.origin.x, _viewTop.frame.origin.y + _viewTop.frame.size.height, _viewBottom.frame.size.width, _viewBottom.frame.size.height)];

	[_pageCtrl setFrame:CGRectMake(_pageCtrl.frame.origin.x,self.frame.size.height-_pageCtrl.frame.size.height, _pageCtrl.frame.size.width, _pageCtrl.frame.size.height)];
	
    //    [_contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"transparent-bg.png"]]];

    //    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"m-bg.png"]]];
}



- (IBAction)didTapCloseWelcomeBtn:(id)sender
{
    // ---- TODO: un comment
    //	NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    //	[userDef setBool:YES forKey:@"shownWelcome"];

    [self removeFromSuperview];
}



- (IBAction)didTapYesBtn:(id)sender
{
    [self.btnNo setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnYes setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnNo setBackgroundImage:[UIImage imageNamed:@"button-mid-gray@2x.png"] forState:UIControlStateNormal];
    [self.btnYes setBackgroundImage:[UIImage imageNamed:@"button-mid-green-down@2x.png"] forState:UIControlStateNormal];
    [self.lbWhatIsYourDate setText:@"What is your due date?"];
    [self setupLayoutOnButtonTap];
}



- (IBAction)didTapNoBtn:(id)sender
{
    [self.btnYes setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnNo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnYes setBackgroundImage:[UIImage imageNamed:@"button-mid-gray@2x.png"] forState:UIControlStateNormal];
    [self.btnNo setBackgroundImage:[UIImage imageNamed:@"button-mid-blue-down@2x.png"] forState:UIControlStateNormal];
    [self.lbWhatIsYourDate setText:@"What is your last period date?"];
    [self setupLayoutOnButtonTap];
}



- (void)setupLayoutOnButtonTap
{
    [self.viewBottom setHidden:NO];

    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.viewTop setFrame:CGRectMake (self.viewTop.frame.origin.x, 0, self.viewTop.frame.size.width, self.viewTop.frame.size.height)];
            [self.viewBottom setFrame:CGRectMake (self.viewBottom.frame.origin.x, self.viewTop.frame.origin.y + self.viewTop.frame.size.height, self.viewBottom.frame.size.width, self.viewBottom.frame.size.height)];
        } completion:^(BOOL finished) {
        }];
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
    [_lbWhatIsYourDate release];
    [_btnNo release];
    [_btnYes release];
    [_viewTop release];
    [_viewBottom release];
    [super dealloc];
}



@end