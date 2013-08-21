//
//  PersonFilterBooleanViewController.h
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

@interface PersonFilterBooleanViewController : BTIViewController
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

// Other Public Properties
@property (nonatomic, retain) ActionFieldInfo *actionFieldInfo;
@property (nonatomic, retain) ActionValue *actionValue;

// IBActions


// Other Public Methods


@end
