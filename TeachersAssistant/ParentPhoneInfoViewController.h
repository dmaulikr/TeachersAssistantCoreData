//
//  ParentPhoneInfoViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/24/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"
@class Parent;
@class PhoneNumber;

// Public Constants

// Protocols


@interface ParentPhoneInfoViewController : BTIViewController
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITextField *mainTextField;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

// Other Public Properties
@property (nonatomic, retain) NSManagedObjectContext *scratchObjectContext;
@property (nonatomic, retain) Parent *scratchParent;
@property (nonatomic, retain) PhoneNumber *scratchPhoneNumber;

// IBActions


// Other Public Methods


@end
