//
//  IBEventDetailsViewController.h
//  iBabe
//
//  Created by David Liang on 26/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "SMStringUtil.h"



@interface IBEventDetailsViewController : UIViewController
{
	NSArray* alarmValues;
	NSArray* alarmTitles;
}


@property (retain, nonatomic) IBOutlet UILabel *lbEventTitle;
@property (retain, nonatomic) IBOutlet UILabel *lbDate;

@property (retain, nonatomic) IBOutlet UILabel *lbStartTime;
@property (retain, nonatomic) IBOutlet UILabel *lbEndTime;
@property (retain, nonatomic) IBOutlet UILabel *lbAlarm1;
@property (retain, nonatomic) IBOutlet UILabel *lbAlarm2;

@property (retain, nonatomic) IBOutlet UITextView *lbNote;

@property (retain, nonatomic) IBOutlet UITextView *lbLocation;

@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) EKEvent* currentEvent;
@property (retain, nonatomic) IBOutlet UIButton *btnShowLocation;
@property (retain, nonatomic) IBOutlet UIView *baseView;


- (void) reloadData;

@end
