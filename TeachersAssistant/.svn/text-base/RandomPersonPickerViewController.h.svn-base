//
//  RandomPersonPickerViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 4/10/12.
//  Copyright 2012 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"
@class ClassPeriod;

// Public Constants

// Protocols

@interface RandomPersonPickerViewController : BTIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIPrintInteractionControllerDelegate>
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) IBOutlet UILabel *groupSizeLabel;
@property (nonatomic, retain) IBOutlet UIButton *minusButton;
@property (nonatomic, retain) IBOutlet UIButton *plusButton;
@property (nonatomic, retain) IBOutlet UISegmentedControl *modeSegmentedControl;

// Other Public Properties
@property (nonatomic, retain) ClassPeriod *classPeriod;

// IBActions
- (IBAction)groupSizeButtonPressed:(UIButton *)button;
- (IBAction)modeSegmentedControlValueChanged:(UISegmentedControl *)control;

// Other Public Methods


@end
