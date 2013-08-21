//
//  EmailBlastPersonPickerViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 12/11/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"
@class ClassPeriod;

// Public Constants

// Protocols

@interface EmailBlastPersonPickerViewController : BTIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate, MFMailComposeViewControllerDelegate>
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;


// Other Public Properties
@property (nonatomic, retain) ClassPeriod *classPeriod;

// IBActions


// Other Public Methods


@end
