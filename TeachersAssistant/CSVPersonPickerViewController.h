//
//  CSVPersonPickerViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 3/4/12.
//  Copyright 2012 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"
@class ClassPeriod;

// Public Constants

// Protocols

@interface CSVPersonPickerViewController : BTIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate, MFMailComposeViewControllerDelegate>
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;


// Other Public Properties
@property (nonatomic, assign) NSInteger exportMode;
@property (nonatomic, retain) ClassPeriod *classPeriod;

// IBActions


// Other Public Methods


@end
