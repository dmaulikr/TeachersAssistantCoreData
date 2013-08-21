//
//  ActionPickerValuesViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/18/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"
@class ActionFieldInfo;
@class ActionValue;
@class PickerValue;

// Public Constants

// Protocols

@interface ActionPickerValuesViewController : BTIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;


// Other Public Properties
@property (nonatomic, retain) NSManagedObjectContext *scratchObjectContext;
@property (nonatomic, retain) ActionFieldInfo *actionFieldInfo;
@property (nonatomic, retain) ActionValue *scratchActionValue;
@property (nonatomic, retain) ActionValue *actionValue;

// IBActions


// Other Public Methods
- (void)addPickerValueToSelection:(PickerValue *)pickerValue;

@end
