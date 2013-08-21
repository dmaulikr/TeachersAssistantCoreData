//
//  PickerInfoViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/18/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"
@class PickerValue;
@class ActionFieldInfo;

// Public Constants

// Protocols

@interface PickerInfoViewController : BTIViewController <UITableViewDataSource, UITableViewDelegate>
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITextField *mainTextField;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) IBOutlet UILabel *colorLabel;

// Other Public Properties
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) ActionFieldInfo *actionFieldInfo;
@property (nonatomic, retain) PickerValue *pickerValue;

// IBActions


// Other Public Methods


@end
