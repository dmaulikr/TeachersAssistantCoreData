//
//  PersonInfoViewController.h
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
@class PersonInfoCell;
@class PersonInfoParentCell;

// Public Constants

// Protocols


@interface PersonInfoViewController : BTIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, NSFetchedResultsControllerDelegate, UIActionSheetDelegate, ABPeoplePickerNavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate>
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) IBOutlet PersonInfoCell *personInfoCell;
@property (nonatomic, retain) IBOutlet PersonInfoParentCell *personInfoParentCell;
@property (nonatomic, retain) IBOutlet UIButton *imageButton;

// Other Public Properties
@property (nonatomic, retain) Person *person;

// IBActions
- (IBAction)imageButtonPressed:(UIButton *)button;

// Other Public Methods


@end
