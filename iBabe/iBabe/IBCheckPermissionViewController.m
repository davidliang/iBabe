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

    [super dealloc];
}



- (void)initContentViews
{
	_contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1087, 259)];
    [_contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"permission_all_steps.png"]]];
	[_contentScrollView addSubview:_contentView];
	
	//	[_contentScrollView setFrame:CGRectMake(0, 0, 280, _contentView.frame.size.height)];
    [_contentScrollView setContentSize:CGSizeMake(_contentView.frame.size.width, _contentView.frame.size.height)];
    [_contentScrollView setDelegate:self];

	[self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"permission-bg.png"]]];
	
	[self.btnDismiss setHidden:YES];

}

- (IBAction)didTapBtnDismiss:(id)sender {
	
	[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		
		[self setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height) ];
		
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
	}];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.contentScrollView.frame.size.width;
    int     page = floor((self.contentScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageCtrl.currentPage = page;
	
	if (page < self.pageCtrl.numberOfPages-1)
	{
		[self.btnDismiss setHidden:YES];
	}
	else
	{
		[self.btnDismiss setHidden:NO];
	}
	
	
	
}

@end