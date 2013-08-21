//
//  ParentInfoViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/15/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"
@class Person;
@class Parent;
@class PersonInfoCell;

// Public Constants

// Protocols

@interface ParentInfoViewController : BTIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, NSFetchedResultsControllerDelegate, MFMailComposeViewControllerDelegate>
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) IBOutlet PersonInfoCell *personInfoCell;

// Other Public Properties
@property (nonatomic, retain) NSManagedObjectContext *scratchObjectContext;
@property (nonatomic, retain) Person *scratchPerson;
@property (nonatomic, retain) Parent *scratchParent;

// IBActions


// Other Public Methods


@end
