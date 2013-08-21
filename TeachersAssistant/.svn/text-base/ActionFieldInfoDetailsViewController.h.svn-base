//
//  ActionFieldInfoDetailsViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/19/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"
@class ActionFieldInfo;

// Public Constants

// Protocols


@interface ActionFieldInfoDetailsViewController : BTIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) IBOutlet UITextField *singularTextField;
@property (nonatomic, retain) IBOutlet UITextField *pluralTextField;
@property (nonatomic, retain) IBOutlet UILabel *dataTypeLabel;
@property (nonatomic, retain) IBOutlet UILabel *visibleTitleLabel;
@property (nonatomic, retain) IBOutlet UISwitch *visibleSwitch;

// Other Public Properties
@property (nonatomic, retain) ActionFieldInfo *actionFieldInfo;

// IBActions
- (IBAction)visibleSwitchValueChanged:(UISwitch *)theSwitch;

// Other Public Methods


@end
