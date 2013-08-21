//
//  GradingPeriodDetailViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 1/31/12.
//  Copyright 2012 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"
@class GradingPeriod;

// Public Constants

// Protocols

@interface GradingPeriodDetailViewController : BTIViewController <UITextFieldDelegate>
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITextField *mainTextField;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

// Other Public Properties
@property (nonatomic, retain) GradingPeriod *gradingPeriod;

// IBActions
- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)control;

// Other Public Methods


@end
