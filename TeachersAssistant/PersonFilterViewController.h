//
//  PersonFilterViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/23/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"

// Public Constants

// Protocols

@interface PersonFilterViewController : BTIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;


// Other Public Properties


// IBActions


// Other Public Methods


@end
