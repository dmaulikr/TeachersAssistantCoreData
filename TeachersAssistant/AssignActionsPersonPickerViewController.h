//
//  AssignActionsPersonPickerViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/26/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"
@class Action;
@class ClassPeriod;

// Public Constants

// Protocols

@interface AssignActionsPersonPickerViewController : BTIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate>
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;


// Other Public Properties
@property (nonatomic, retain) NSManagedObjectContext *scratchObjectContext;
@property (nonatomic, retain) Action *scratchAction;
@property (nonatomic, retain) ClassPeriod *classPeriod;

// IBActions


// Other Public Methods


@end
