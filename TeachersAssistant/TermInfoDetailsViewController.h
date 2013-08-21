//
//  TermInfoDetailsViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/19/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"
@class TermInfo;

// Public Constants

// Protocols

@interface TermInfoDetailsViewController : BTIViewController
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITextField *singularTextField;
@property (nonatomic, retain) IBOutlet UITextField *pluralTextField;


// Other Public Properties
@property (nonatomic, retain) TermInfo *termInfo;

// IBActions


// Other Public Methods


@end
