//
//  ClassPeriodPersonPickerViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/21/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"
@class ClassPeriod;

// Public Constants

// Protocols

@interface ClassPeriodPersonPickerViewController : BTIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;


// Other Public Properties
@property (nonatomic, retain) ClassPeriod *classPeriod;

// IBActions


// Other Public Methods


@end
