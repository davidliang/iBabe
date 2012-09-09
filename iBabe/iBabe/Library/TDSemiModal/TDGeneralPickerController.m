//
//  TDGeneralPickerController.m
//  iBabe
//
//  Created by David Liang on 8/07/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "TDGeneralPickerController.h"

@interface TDGeneralPickerController ()

@end

@implementation TDGeneralPickerController
@synthesize btnNotSet;
@synthesize btnCancel;
@synthesize btnSave;
@synthesize picker;
@synthesize delegate;
@synthesize pickerData;
@synthesize selectedIdx;




#pragma mark -
#pragma mark PickerView Datasource


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [pickerData count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [pickerData objectAtIndex:row];
} 




#pragma mark -
#pragma mark Actions

-(IBAction)saveValueEdit:(id)sender {
	if([self.delegate respondsToSelector:@selector(pickerSetValue:)]) {
		[self.delegate pickerSetValue:self];
	}
}

-(IBAction)cancelValueEdit:(id)sender {
	if([self.delegate respondsToSelector:@selector(pickerCancel:)]) {
		[self.delegate pickerCancel:self];
	} else {
		// just dismiss the view automatically?
	}
}
-(IBAction)setValueToNotSet:(id)sender
{
	if([self.delegate respondsToSelector:@selector(pickerSetValueToNotSet:)]) {
		[self.delegate pickerSetValueToNotSet:self];
	} else {
		// just dismiss the view automatically?
	}
}





#pragma mark -
#pragma mark View Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
	[picker selectRow:selectedIdx inComponent:0 animated:YES];
	
}

- (void)viewDidLoad
{	
    [super viewDidLoad];
  	// we need to set the subview dimensions or it will not always render correctly
	// http://stackoverflow.com/questions/1088163
	for (UIView* subview in picker.subviews) {
		subview.frame = picker.bounds;
	}
	picker.dataSource =self;
	picker.delegate = self;
}

- (void)viewDidUnload
{
    [self setBtnSave:nil];
    [self setPicker:nil];
	[self setBtnNotSet:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [btnSave release];
	[pickerData release];
    [picker release];
	[btnNotSet release];
    [super dealloc];
}



@end
