//
//  ParentEmailInfoViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/24/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"
@class UICustomSwitch;
@class Parent;
@class EmailAddress;

// Public Constants

// Protocols


@interface ParentEmailInfoViewController : BTIViewController
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITextField *mainTextField;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet UICustomSwitch *customSwitch;

// Other Public Properties
@property (nonatomic, retain) NSManagedObjectContext *scratchObjectContext;
@property (nonatomic, retain) Parent *scratchParent;
@property (nonatomic, retain) EmailAddress *scratchEmailAddress;

// IBActions


// Other Public Methods


@end
