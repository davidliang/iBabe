//
//  TDGeneralPickerController.h
//  iBabe
//
//  Created by David Liang on 8/07/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	"TDSemiModal.h"

@interface TDGeneralPickerController : TDSemiModalViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{	id delegate;
}

@property (nonatomic, retain) IBOutlet id delegate;

@property (retain, nonatomic) IBOutlet UIBarButtonItem *btnCancel;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *btnSave;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *btnNotSet;
@property (retain, nonatomic) IBOutlet UIPickerView *picker;
@property (retain, nonatomic) NSArray* pickerData;
@property (nonatomic) NSInteger selectedIdx;



-(IBAction)saveValueEdit:(id)sender;
-(IBAction)cancelValueEdit:(id)sender;
-(IBAction)setValueToNotSet:(id)sender;

@end

@interface NSObject (TDGeneralPickerControllerDelegate)
-(void)pickerSetValueToNotSet:(TDGeneralPickerController*)viewController;
-(void)pickerSetValue:(TDGeneralPickerController*)viewController;
-(void)pickerCancel:(TDGeneralPickerController*)viewController;
@end
