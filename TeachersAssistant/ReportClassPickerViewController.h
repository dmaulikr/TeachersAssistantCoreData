//
//  ReportClassPickerViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 2/1/12.
//  Copyright 2012 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"
@class GradingPeriod;

// Public Constants

// Protocols


@interface ReportClassPickerViewController : BTIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;


// Other Public Properties
@property (nonatomic, assign) NSInteger reportMode;
@property (nonatomic, retain) GradingPeriod *gradingPeriod;

// IBActions


// Other Public Methods


@end
