//
//  TermInfoViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/19/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"

// Public Constants

// Protocols

@interface TermInfoViewController : BTIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;


// Other Public Properties


// IBActions


// Other Public Methods


@end
