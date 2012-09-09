//
//  TDDatePickerController.m
//
//  Created by Nathan  Reed on 30/09/10.
//  Copyright 2010 Nathan Reed. All rights reserved.
//

#import "TDDatePickerController.h"


@implementation TDDatePickerController
@synthesize datePicker, delegate;

-(void)viewDidLoad {
    [super viewDidLoad];
        
    
	// we need to set the subview dimensions or it will not always render correctly
	// http://stackoverflow.com/questions/1088163
	for (UIView* subview in datePicker.subviews) {
		subview.frame = datePicker.bounds;
	}
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (initDate==Nil)
        datePicker.date = [NSDate date];
    else {
        datePicker.date = initDate;
    }
    
    datePicker.datePickerMode = initMode;
}

-(void)setupPickerWithDatePickerMode:(UIDatePickerMode)mode AndInitDatePickerValue:(NSDate *)date
{
    initDate = date;
    initMode = mode;
}



#pragma mark -
#pragma mark Actions

-(IBAction)saveDateEdit:(id)sender {
	if([self.delegate respondsToSelector:@selector(datePickerSetDate:)]) {
		[self.delegate datePickerSetDate:self];
	}
}

//-(IBAction)clearDateEdit:(id)sender {
//	if([self.delegate respondsToSelector:@selector(datePickerClearDate:)]) {
//		[self.delegate datePickerClearDate:self];
//	}
//}

-(IBAction)cancelDateEdit:(id)sender {
	if([self.delegate respondsToSelector:@selector(datePickerCancel:)]) {
		[self.delegate datePickerCancel:self];
	} else {
		// just dismiss the view automatically?
	}
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];

	self.datePicker = nil;
	self.delegate = nil;

}

- (void)dealloc {
	self.datePicker = nil;
	self.delegate = nil;

    [super dealloc];
}




@end


