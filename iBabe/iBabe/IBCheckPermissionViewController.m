//
//  IBCheckPermissionViewController.m
//  iBabe
//
//  Created by David on 22/09/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "IBCheckPermissionViewController.h"

@implementation IBCheckPermissionViewController

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

- (void)dealloc
{
    [_contentScrollView release];
    [_contentView release];
    [_pageCtrl release];
    [_btnDismiss release];

    [_imgDialogBg release];
    [super dealloc];
}



- (void)initContentViews
{
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1192, 328)];
    [_contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"permission-all-steps.png"]]];
    [_contentScrollView addSubview:_contentView];

    [_contentScrollView setContentSize:CGSizeMake(_contentView.frame.size.width, _contentView.frame.size.height)];
    [_contentScrollView setDelegate:self];
    [self setBackgroundColor:[UIColor colorWithRed:0.012 green:0.008 blue:0.009 alpha:0.400]];

    [_imgDialogBg setFrame:CGRectMake(0, self.frame.size.height - _imgDialogBg.frame.size.height - 5, _imgDialogBg.frame.size.width, _imgDialogBg.frame.size.height)];
    [_contentScrollView setFrame:CGRectMake(_contentScrollView.frame.origin.x, _imgDialogBg.frame.origin.y + 30, _contentScrollView.frame.size.width, _contentScrollView.frame.size.height)];
    [_btnDismiss setFrame:CGRectMake(_btnDismiss.frame.origin.x, _imgDialogBg.frame.origin.y - 5, _btnDismiss.frame.size.width, _btnDismiss.frame.size.height)];
}



- (IBAction)didTapBtnDismiss:(id)sender
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self setAlpha:0];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.contentScrollView.frame.size.width;
    int     page = floor((self.contentScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    self.pageCtrl.currentPage = page;

    //	if (page < self.pageCtrl.numberOfPages-1)
    //	{
    //		[self.btnDismiss setHidden:YES];
    //	}
    //	else
    //	{
    //		[self.btnDismiss setHidden:NO];
    //	}
}



@end