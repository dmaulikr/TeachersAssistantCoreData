//
//  RandomClassPickerViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 4/10/12.
//  Copyright 2012 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"

// Public Constants

// Protocols

@interface RandomClassPickerViewController : BTIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;


// Other Public Properties


// IBActions


// Other Public Methods


@end
