//
//  PersonFilterDateViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/23/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"
@class ActionFieldInfo;
@class ActionValue;

// Public Constants

// Protocols


@interface PersonFilterDateViewController : BTIViewController
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

// Other Public Properties
@property (nonatomic, retain) ActionFieldInfo *actionFieldInfo;
@property (nonatomic, retain) ActionValue *actionValue;

// IBActions
- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)control;
- (IBAction)quickButtonPressed:(UIButton *)button;

// Other Public Methods


@end
