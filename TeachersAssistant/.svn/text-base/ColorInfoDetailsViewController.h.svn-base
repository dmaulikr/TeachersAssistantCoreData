//
//  ColorInfoDetailsViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/29/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"
@class ColorInfo;

// Public Constants

// Protocols

@interface ColorInfoDetailsViewController : BTIViewController <UITextFieldDelegate>
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *pointTextField;
@property (nonatomic, retain) IBOutlet UIView *colorView;
@property (nonatomic, retain) IBOutlet UISlider *redSlider;
@property (nonatomic, retain) IBOutlet UISlider *greenSlider;
@property (nonatomic, retain) IBOutlet UISlider *blueSlider;

// Other Public Properties
@property (nonatomic, retain) ColorInfo *colorInfo;

// IBActions
- (IBAction)sliderValueChanged:(UISlider *)slider;

// Other Public Methods


@end
