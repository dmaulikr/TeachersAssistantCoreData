//
//  ActionDetailViewController_iPad.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/22/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ActionDetailViewController.h"
@class ActionDetailPickerCell;
@class ActionDetailBooleanCell;
@class ActionDetailLongTextCell;
@class ActionDetailColorCell;
@class ActionDetailImageCell;

// Public Constants

@interface ActionDetailViewController_iPad : ActionDetailViewController <UITextViewDelegate, UIPopoverControllerDelegate>
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet ActionDetailPickerCell *actionDetailPickerCell;
@property (nonatomic, retain) IBOutlet ActionDetailBooleanCell *actionDetailBooleanCell;
@property (nonatomic, retain) IBOutlet ActionDetailLongTextCell *actionDetailLongTextCell;
@property (nonatomic, retain) IBOutlet ActionDetailColorCell *actionDetailColorCell;
@property (nonatomic, retain) IBOutlet ActionDetailImageCell *actionDetailImageCell;

// Other Public Properties


// IBActions
- (IBAction)detailButtonPressed:(UIButton *)button;
- (IBAction)switchValueChanged:(UICustomSwitch *)customSwitch;
- (IBAction)imageButtonPressed:(UIButton *)button;

// Other Public Methods


@end
