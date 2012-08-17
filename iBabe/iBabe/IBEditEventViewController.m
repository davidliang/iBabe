//
//  IBEditEventViewController.m
//  iBabe
//
//  Created by David Liang on 30/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "IBEditEventViewController.h"

static const CGFloat    KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat    MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat    MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat    PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat    LANDSCAPE_KEYBOARD_HEIGHT = 140;
static const CGFloat    NAVIGATION_BAR_HEIGHT = 44;
static NSString         *BUTTON_STRING_FORMAT = @"   %@";
static NSString         *ALARM_NOT_SET = @"Not Set";
static const NSInteger  ALERTVIEW_TAG_CONFIRM_DELETE_EVENT = 1;
static const NSInteger  ALERTVIEW_TAG_NORMAL = 0;

CGFloat animatedDistance;

NSArray *alarmValues;
NSArray *alarmTitles;

NSInteger   selectedAlarm1Row;
NSInteger   selectedAlarm2Row;

typedef enum PickType {
    startDate = 0,
    startTime = 1,
    endTime = 2,
    endDate = 3
}               PickType;
enum PickType   pType;

typedef enum dateCompareResult {
    earlier,
    same,
    later
} dateTimeCompareResult;

typedef enum GeneralPickerType {
    alarm1,
    alarm2
}                       GeneralPickerType;
enum GeneralPickerType  genPType;

@interface IBEditEventViewController ()

@end

@implementation IBEditEventViewController
@synthesize tvNote;
@synthesize tvLocation;
@synthesize scrollView;
@synthesize contentView;
@synthesize btnSave;
@synthesize tbTitle;
@synthesize btnDateStart;
@synthesize btnStartTime;
@synthesize btnEndTime;
@synthesize btnDateEnd;
@synthesize btnAlarm1;
@synthesize btnAlarm2;
@synthesize btnDelete;
@synthesize currentEvent;
@synthesize isNewEvent;

#pragma mark- TextView Delegate

// ---- shift the whole view up for the current textview when editing.
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    CGRect  textFieldRect = [self.view.window convertRect:textView.bounds fromView:textView];
    CGRect  viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
        midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
        (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;

    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    } else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }

    UIInterfaceOrientation orientation =
        [[UIApplication sharedApplication] statusBarOrientation];

    if ((orientation == UIInterfaceOrientationPortrait) ||
        (orientation == UIInterfaceOrientationPortraitUpsideDown)) {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    } else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }

    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];

    [self.view setFrame:viewFrame];

    [UIView commitAnimations];

    return YES;
}

- (void)resetViewPositionAfterKeyboardDissmised
{
    CGRect viewFrame = self.view.frame;

    viewFrame.origin.y = 0.0f;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];

    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

#pragma mark- View Life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        // Custom initialization
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customiseUI];

    if (currentEvent == Nil) {
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        currentEvent = [EKEvent eventWithEventStore:eventStore];
        currentEvent.title = @"";
        [eventStore release];
    }

    if (isNewEvent) {
        [btnDelete setHidden:YES];
    }

    alarmValues = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:-5 * 60], [NSNumber numberWithInt:-15 * 60], [NSNumber numberWithInt:-30 * 60], [NSNumber numberWithInt:-60 * 60], [NSNumber numberWithInt:-2 * 60 * 60], [NSNumber numberWithInt:-24 * 60 * 60], [NSNumber numberWithInt:-2 * 24 * 60 * 60], nil];

    alarmTitles = [[NSArray alloc] initWithObjects:@"At time of event", @"5 mins before", @"15 mins before", @"30 mins before", @"1 hour before", @"2 hours before", @"1 day before", @"2 days before", ALARM_NOT_SET, nil];

    [self boundData];
}

- (void)boundData
{
    [self.tbTitle setText:currentEvent.title];
    [self.tvLocation setText:currentEvent.location];
    [self.tvNote setText:currentEvent.notes];

    [self.btnDateStart setTitle:[NSString stringWithFormat:BUTTON_STRING_FORMAT, [SMDateConvertUtil getDDMMYYYYFromNSDate:currentEvent.startDate]] forState:UIControlStateNormal];

    [self.btnStartTime setTitle:[NSString stringWithFormat:BUTTON_STRING_FORMAT, [SMDateConvertUtil getTimeFromNSDate:currentEvent.startDate]] forState:UIControlStateNormal];

    [self.btnDateEnd setTitle:[NSString stringWithFormat:BUTTON_STRING_FORMAT, [SMDateConvertUtil getDDMMYYYYFromNSDate:currentEvent.endDate]] forState:UIControlStateNormal];

    [self.btnEndTime setTitle:[NSString stringWithFormat:BUTTON_STRING_FORMAT, [SMDateConvertUtil getTimeFromNSDate:currentEvent.endDate]] forState:UIControlStateNormal];

    NSString    *alarmTitle1 = ALARM_NOT_SET;
    NSString    *alarmTitle2 = ALARM_NOT_SET;

    if (currentEvent.alarms != Nil) {
        if ([currentEvent.alarms count] > 0) {
            EKAlarm *alarm1 = [currentEvent.alarms objectAtIndex:0];

            if (alarm1 != Nil) {
                NSInteger alarm1Row = [alarmValues indexOfObject:[NSNumber numberWithInt:alarm1.relativeOffset]];
                alarmTitle1 = [alarmTitles objectAtIndex:alarm1Row];
            }
        }

        if ([currentEvent.alarms count] > 1) {
            EKAlarm *alarm2 = [currentEvent.alarms objectAtIndex:1];

            if (alarm2 != Nil) {
                NSInteger alarm2Row = [alarmValues indexOfObject:[NSNumber numberWithInt:alarm2.relativeOffset]];
                alarmTitle2 = [alarmTitles objectAtIndex:alarm2Row];
            }
        }
    }

    [self.btnAlarm1 setTitle:[NSString stringWithFormat:@"   %@", alarmTitle1] forState:UIControlStateNormal];
    [self.btnAlarm2 setTitle:[NSString stringWithFormat:@"   %@", alarmTitle2] forState:UIControlStateNormal];
}

- (void)customiseUI
{
    // --- add border and setup border color for the text boxes.
    tvNote.layer.borderWidth = 1;
    tvNote.layer.borderColor = [[UIColor colorWithRed:0.878 green:0.773 blue:0.804 alpha:1] CGColor];

    tbTitle.layer.borderWidth = 1;
    tbTitle.layer.borderColor = [[UIColor colorWithRed:0.878 green:0.773 blue:0.804 alpha:1] CGColor];

    tvLocation.layer.borderWidth = 1;
    tvLocation.layer.borderColor = [[UIColor colorWithRed:0.878 green:0.773 blue:0.804 alpha:1] CGColor];

    // --- Content and scroll view
    [[self contentView] setFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT * 2, self.contentView.frame.size.width, self.btnDelete.frame.origin.y + self.btnDelete.frame.size.height + NAVIGATION_BAR_HEIGHT * 3)];

    [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.contentView.frame.size.height)];

    // --- buttons.
    [[self btnStartTime] setTintColor:[UIColor colorWithRed:0.925 green:0.784 blue:0.839 alpha:1]];
    [[self btnEndTime] setTintColor:[UIColor colorWithRed:0.925 green:0.784 blue:0.839 alpha:1]];
    [[self btnDateStart] setTintColor:[UIColor colorWithRed:0.925 green:0.784 blue:0.839 alpha:1]];
}

- (void)viewDidUnload
{
    [self setTvNote:nil];
    [self setTvLocation:nil];
    [self setScrollView:nil];
    [self setBtnSave:nil];

    [self setContentView:nil];
    [self setTbTitle:nil];
    [self setBtnDateStart:nil];
    [self setBtnStartTime:nil];
    [self setBtnEndTime:nil];
    [self setBtnDateEnd:nil];
    [self setBtnAlarm1:nil];
    [self setBtnAlarm2:nil];
    [self setBtnDelete:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

// - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
// {
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
// }
//

#pragma mark -
#pragma mark Date Picker Delegate

- (IBAction)didTapDateStart:(id)sender
{
    if (datePickerView == Nil) {
        datePickerView = [[TDDatePickerController alloc]
            initWithNibName :@"TDDatePickerController"
            bundle          :nil];

        datePickerView.delegate = self;
    }

    // -- Pass the current Date Value to the DatePicker.
    NSString    *currentDateStr = [self.btnDateStart.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSDate      *currentDate = [SMDateConvertUtil convertString2Date:currentDateStr withFormatterStyle:ddMMMyyyy];
    [datePickerView setupPickerWithDatePickerMode:UIDatePickerModeDate AndInitDatePickerValue:currentDate];

    [datePickerView.datePicker setMinimumDate:Nil];
    pType = startDate;

    [self presentSemiModalViewController:datePickerView];
}

- (IBAction)didTapTimeStart:(id)sender
{
    pType = startTime;

    if (datePickerView == Nil) {
        datePickerView = [[TDDatePickerController alloc]
            initWithNibName :@"TDDatePickerController"
            bundle          :nil];
        datePickerView.delegate = self;
    }

    // --- Set the init selected start time on the picker.
    NSString *startDateTimeStr = [NSString stringWithFormat:@"%@ %@", [self.btnDateStart.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], [self.btnStartTime.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];

    NSDate *startDateTime = [SMDateConvertUtil convertString2Date:startDateTimeStr withFormatterStyle:ddMMMyyyyhhmmssa];
    [datePickerView setupPickerWithDatePickerMode:UIDatePickerModeTime AndInitDatePickerValue:startDateTime];

    // --- Reset the minimum date value for the picker.
    [datePickerView.datePicker setMinimumDate:Nil];

    [self presentSemiModalViewController:datePickerView];
}

- (IBAction)didTapTimeEnd:(id)sender
{
    pType = endTime;

    if (datePickerView == Nil) {
        datePickerView = [[TDDatePickerController alloc]
            initWithNibName :@"TDDatePickerController"
            bundle          :nil];
        datePickerView.delegate = self;
    }

    // --- Set minimum end time to be 5 mins after the start time.
    NSString *startDateTimeStr = [NSString stringWithFormat:@"%@ %@", [self.btnDateStart.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], [self.btnStartTime.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];

    NSDate  *startDateTime = [SMDateConvertUtil convertString2Date:startDateTimeStr withFormatterStyle:ddMMMyyyyhhmmssa];
    NSDate  *minEndDateTime = [startDateTime dateByAddingTimeInterval:5 * 60];
    [datePickerView.datePicker setMinimumDate:minEndDateTime];

    // --- Set the init selected end time on the picker.
    NSString *endDateTimeStr = [NSString stringWithFormat:@"%@ %@", [self.btnDateEnd.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], [self.btnEndTime.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];

    NSDate *endDateTime = [SMDateConvertUtil convertString2Date:endDateTimeStr withFormatterStyle:ddMMMyyyyhhmmssa];

    [datePickerView setupPickerWithDatePickerMode:UIDatePickerModeTime AndInitDatePickerValue:endDateTime];

    [self presentSemiModalViewController:datePickerView];
}

- (IBAction)didTapDateEnd:(id)sender
{
    pType = endDate;

    if (datePickerView == Nil) {
        datePickerView = [[TDDatePickerController alloc]
            initWithNibName :@"TDDatePickerController"
            bundle          :nil];
        datePickerView.delegate = self;
    }

    NSDate *currentEndDate = [SMDateConvertUtil convertString2Date:self.btnDateEnd.titleLabel.text withFormatterStyle:ddMMMyyyy];

    NSDate *currentStartDate = [SMDateConvertUtil convertString2Date:self.btnDateStart.titleLabel.text withFormatterStyle:ddMMMyyyy];

    if ([currentStartDate compare:currentEndDate] != NSOrderedDescending) {
        [datePickerView setupPickerWithDatePickerMode:UIDatePickerModeDate AndInitDatePickerValue:currentEndDate];
    } else {
        [datePickerView setupPickerWithDatePickerMode:UIDatePickerModeDate AndInitDatePickerValue:currentStartDate];
    }

    [datePickerView.datePicker setMinimumDate:currentStartDate];
    [self presentSemiModalViewController:datePickerView];
}

- (IBAction)didTapAlarm1:(id)sender
{
    if (genPickerView == Nil) {
        genPickerView = [[TDGeneralPickerController alloc]
            initWithNibName :@"TDGeneralPickerController"
            bundle          :nil];

        genPickerView.pickerData = alarmTitles;
        genPickerView.delegate = self;
    }

    genPType = alarm1;

    NSString *alarmTitle1 = [self.btnAlarm1.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (![alarmTitle1 isEqualToString:@"Not set"]) {
        NSInteger titleIdx1 = [alarmTitles indexOfObject:alarmTitle1];
        [genPickerView setSelectedIdx:titleIdx1];
    }

    [self presentSemiModalViewController:genPickerView];
}

- (IBAction)didTapAlarm2:(id)sender
{
    if (genPickerView == Nil) {
        genPickerView = [[TDGeneralPickerController alloc]
            initWithNibName :@"TDGeneralPickerController"
            bundle          :nil];
        genPickerView.pickerData = alarmTitles;
        genPickerView.delegate = self;
    }

    genPType = alarm2;
    NSString *alarmTitle2 = [self.btnAlarm2.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (![alarmTitle2 isEqualToString:@"Not set"]) {
        NSInteger titleIdx2 = [alarmTitles indexOfObject:alarmTitle2];
        [genPickerView setSelectedIdx:titleIdx2];
    }

    [self presentSemiModalViewController:genPickerView];
}

- (IBAction)didTapDelete:(id)sender
{
    UIAlertView *confirmView = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this reminder?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", Nil];

    confirmView.tag = ALERTVIEW_TAG_CONFIRM_DELETE_EVENT;

    [confirmView show];
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: // -- Cancel button
            switch (alertView.tag) {
                case ALERTVIEW_TAG_CONFIRM_DELETE_EVENT:
                case ALERTVIEW_TAG_NORMAL:
                default:
                    break;
            }

            break;

        case 1: // -- Action button
            switch (alertView.tag) {
                case ALERTVIEW_TAG_CONFIRM_DELETE_EVENT:
                    [IBEKCalendarHelper deleteEvent:[currentEvent eventIdentifier]];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    break;

                case ALERTVIEW_TAG_NORMAL:
                default:
                    break;
            }

            break;

        default:
            break;
    }
}

#pragma mark -
#pragma mark TDGeneralPickerController Delegate
- (void)pickerSetValue:(TDGeneralPickerController *)viewController
{
    [self dismissSemiModalViewController:genPickerView];
    NSInteger selectedRow = [viewController.picker selectedRowInComponent:0];

    switch (genPType) {
        case alarm1:
            [self.btnAlarm1 setTitle:[NSString stringWithFormat:@"   %@", [alarmTitles objectAtIndex:selectedRow]] forState:UIControlStateNormal];
            break;

        case alarm2:
            [self.btnAlarm2 setTitle:[NSString stringWithFormat:@"   %@", [alarmTitles objectAtIndex:selectedRow]] forState:UIControlStateNormal];
            break;

        default:
            break;
    }
}

- (void)pickerCancel:(TDGeneralPickerController *)viewController
{
    [self dismissSemiModalViewController:genPickerView];
}

- (void)pickerSetValueToNotSet:(TDGeneralPickerController *)viewController
{
    switch (genPType) {
        case alarm1:
            [self.btnAlarm1 setTitle:@"   Not Set" forState:UIControlStateNormal];
            break;

        case alarm2:
            [self.btnAlarm2 setTitle:@"   Not Set" forState:UIControlStateNormal];
            break;

        default:
            break;
    }

    [self dismissSemiModalViewController:genPickerView];
}

#pragma mark -
#pragma mark TDDatePickerController Delegate
- (void)datePickerSetDate:(TDDatePickerController *)viewController
{
    [self dismissSemiModalViewController:datePickerView];

    switch (pType) {
        case startDate:
            [self.btnDateStart setTitle:[NSString stringWithFormat:BUTTON_STRING_FORMAT, [SMDateConvertUtil getDDMMYYYYFromNSDate:viewController.datePicker.date]] forState:UIControlStateNormal];

            // --- compare the current end date value, if current end date less than the new start date then pre set the end date to the new start date.

            NSDate *currentEndDate = [SMDateConvertUtil convertString2Date:self.btnDateEnd.titleLabel.text withFormatterStyle:ddMMMyyyy];

            NSDate *newStartDate = viewController.datePicker.date;

            if ([newStartDate compare:currentEndDate] == NSOrderedDescending) {
                [self.btnDateEnd setTitle:self.btnDateStart.titleLabel.text forState:UIControlStateNormal];
            }

            // ---- fix up end time
            if ([self compareCurrentStartTimeWithCurrentEndTime] != earlier) {
                if ([self compareCurrentStartDateWithCurrentEndDate] == same) {
                    // -- Pre set the end time and force it 5 min later than the start time.
                    presetEndDateTime = [[SMDateConvertUtil convertString2Date:self.btnStartTime.titleLabel.text withFormatterStyle:hhmmssa] dateByAddingTimeInterval:60 * 5];

                    [self.btnEndTime setTitle:[NSString stringWithFormat:BUTTON_STRING_FORMAT, [SMDateConvertUtil getTimeFromNSDate:presetEndDateTime]] forState:UIControlStateNormal];
                }
            }

            break;

        case startTime:
            [self.btnStartTime setTitle:[NSString stringWithFormat:BUTTON_STRING_FORMAT, [SMDateConvertUtil getTimeFromNSDate:viewController.datePicker.date]] forState:UIControlStateNormal];

            if ([self compareCurrentStartDateWithCurrentEndDate] == same) {
                // -- Pre set the end time and force it 5 min later than the start time.
                presetEndDateTime = [viewController.datePicker.date dateByAddingTimeInterval:60 * 5];
                [self.btnEndTime setTitle:[NSString stringWithFormat:BUTTON_STRING_FORMAT, [SMDateConvertUtil getTimeFromNSDate:presetEndDateTime]] forState:UIControlStateNormal];
            }

            break;

        case endTime:
            [self.btnEndTime setTitle:[NSString stringWithFormat:BUTTON_STRING_FORMAT, [SMDateConvertUtil getTimeFromNSDate:viewController.datePicker.date]] forState:UIControlStateNormal];
            break;

        case endDate:
            [self.btnDateEnd setTitle:[NSString stringWithFormat:BUTTON_STRING_FORMAT, [SMDateConvertUtil getDDMMYYYYFromNSDate:viewController.datePicker.date]] forState:UIControlStateNormal];

            if ([self compareCurrentStartTimeWithCurrentEndTime] != earlier) {
                if ([self compareCurrentStartDateWithCurrentEndDate] == same) {
                    // -- Pre set the end time and force it 5 min later than the start time.
                    presetEndDateTime = [[SMDateConvertUtil convertString2Date:self.btnStartTime.titleLabel.text withFormatterStyle:hhmmssa] dateByAddingTimeInterval:60 * 5];

                    [self.btnEndTime setTitle:[NSString stringWithFormat:BUTTON_STRING_FORMAT, [SMDateConvertUtil getTimeFromNSDate:presetEndDateTime]] forState:UIControlStateNormal];
                }
            }

            break;

        default:
            break;
    }
}

- (void)datePickerCancel:(TDDatePickerController *)viewController
{
    [self dismissSemiModalViewController:datePickerView];
}

- (BOOL)currentStartDateEarlierThanOrSameAsCurrentEndDate
{
    NSDate *currentEndDate = [SMDateConvertUtil convertString2Date:self.btnDateEnd.titleLabel.text withFormatterStyle:ddMMMyyyy];

    NSDate *currentStartDate = [SMDateConvertUtil convertString2Date:self.btnDateStart.titleLabel.text withFormatterStyle:ddMMMyyyy];

    if ([currentStartDate compare:currentEndDate] != NSOrderedDescending) {
        return YES;
    } else {
        return NO;
    }
}

- (dateTimeCompareResult)compareCurrentStartDateWithCurrentEndDate
{
    NSDate *currentEndDate = [SMDateConvertUtil convertString2Date:self.btnDateEnd.titleLabel.text withFormatterStyle:ddMMMyyyy];

    NSDate *currentStartDate = [SMDateConvertUtil convertString2Date:self.btnDateStart.titleLabel.text withFormatterStyle:ddMMMyyyy];

    if ([currentStartDate compare:currentEndDate] == NSOrderedAscending) {
        return earlier;
    }

    if ([currentStartDate compare:currentEndDate] == NSOrderedSame) {
        return same;
    }

    if ([currentStartDate compare:currentEndDate] == NSOrderedDescending) {
        return later;
    }

    return later;
}

- (dateTimeCompareResult)compareCurrentStartTimeWithCurrentEndTime
{
    NSDate *currentEndTime = [SMDateConvertUtil convertString2Date:self.btnEndTime.titleLabel.text withFormatterStyle:hhmmssa];

    NSDate *currentStartTime = [SMDateConvertUtil convertString2Date:self.btnStartTime.titleLabel.text withFormatterStyle:hhmmssa];

    if ([currentStartTime compare:currentEndTime] == NSOrderedAscending) {
        return earlier;
    }

    if ([currentStartTime compare:currentEndTime] == NSOrderedSame) {
        return same;
    }

    if ([currentStartTime compare:currentEndTime] == NSOrderedDescending) {
        return later;
    }

    return later;
}

#pragma mark -
#pragma MBProgressHUD Delegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    // Remove HUD from screen when the HUD was hidded
    [progressHud removeFromSuperview];
    [progressHud release];
    progressHud = nil;
}

#pragma mark- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

#pragma mark- Guesture functions

- (IBAction)tapToCloseKeyboard:(id)sender
{
    [tvNote resignFirstResponder];
    [tvLocation resignFirstResponder];
    [tbTitle resignFirstResponder];

    [self resetViewPositionAfterKeyboardDissmised];
}

- (void)saveEvent
{
    if ([SMStringUtil isEmptyString:self.tbTitle.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input" message:@"Title cannot be blank" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alert.tag = ALERTVIEW_TAG_NORMAL;
        [alert show];
        [alert release];
    } else {
        currentEvent.title = self.tbTitle.text;
        currentEvent.location = self.tvLocation.text;
        currentEvent.notes = self.tvNote.text;

        NSString *startDateTimeStr = [NSString stringWithFormat:@"%@ %@", [self.btnDateStart.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], [self.btnStartTime.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];

        currentEvent.startDate = [SMDateConvertUtil convertString2Date:startDateTimeStr withFormatterStyle:ddMMMyyyyhhmmssa];

        NSString *endDateTimeStr = [NSString stringWithFormat:@"%@ %@", [self.btnDateEnd.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], [self.btnEndTime.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];

        currentEvent.endDate = [SMDateConvertUtil convertString2Date:endDateTimeStr withFormatterStyle:ddMMMyyyyhhmmssa];

        // --- Alarms
        NSString *alarmTitle1 = [self.btnAlarm1.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        // NSMutableArray* newAlarms = [[NSMutableArray alloc]init];

        switch ([currentEvent.alarms count]) {
            case 1:
                [currentEvent removeAlarm:[currentEvent.alarms objectAtIndex:0]];
                break;

            case 2:
                [currentEvent removeAlarm:[currentEvent.alarms objectAtIndex:1]];
                [currentEvent removeAlarm:[currentEvent.alarms objectAtIndex:0]];

                break;

            default:
                break;
        }

        if (![alarmTitle1 isEqualToString:ALARM_NOT_SET]) {
            NSInteger titleIdx1 = [alarmTitles indexOfObject:alarmTitle1];

            NSNumber    *alarmSelectedVal1 = (NSNumber *)[alarmValues objectAtIndex:titleIdx1];
            EKAlarm     *alarm1 = [[EKAlarm alloc] init];
            alarm1.relativeOffset = [alarmSelectedVal1 integerValue];

            [currentEvent addAlarm:alarm1];

            [alarm1 release];
        }

        NSString *alarmTitle2 = [self.btnAlarm2.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        if (![alarmTitle2 isEqualToString:ALARM_NOT_SET]) {
            NSNumber    *alarmSelectedVal1 = (NSNumber *)[alarmValues objectAtIndex:[alarmTitles indexOfObject:alarmTitle2]];
            EKAlarm     *alarm2 = [[EKAlarm alloc] init];
            alarm2.relativeOffset = [alarmSelectedVal1 integerValue];

            [currentEvent addAlarm:alarm2];
            [alarm2 release];
        }

        if (!isNewEvent) {
            isSaved = [IBEKCalendarHelper updateEvent:currentEvent];
        } else {
            isSaved = [IBEKCalendarHelper addEvent:currentEvent];
        }

        [progressHud hide:YES];

        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)didTapBtnSave:(id)sender
{
    isSaved = NO;

    progressHud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [progressHud setLabelText:@"Saving..."];
    [progressHud setMode:MBProgressHUDModeIndeterminate];

    [self.navigationController.view addSubview:progressHud];

    progressHud.dimBackground = YES;

    // Regiser for HUD callbacks so we can remove it from the window at the right time
    progressHud.delegate = self;

    // Show the HUD while the provided method executes in a new thread
    [progressHud showWhileExecuting:@selector(saveEvent) onTarget:self withObject:nil animated:YES];
}

- (IBAction)swipeToNavBack:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [scrollView release];
    [btnSave release];
    [contentView release];
    [tbTitle release];
    [btnDateStart release];
    [btnStartTime release];
    [btnEndTime release];
    // [currentEvent release];
    [btnDateEnd release];
    [btnAlarm1 release];
    [btnAlarm2 release];
    [btnDelete release];
    [progressHud release];
    [datePickerView release];
    [super dealloc];
}

@end