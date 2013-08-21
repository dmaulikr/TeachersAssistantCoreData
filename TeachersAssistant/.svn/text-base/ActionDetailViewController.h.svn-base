//
//  ActionDetailViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/16/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"
@class Person;
@class Action;
@class UICustomSwitch;

// Public Constants

// Protocols


@interface ActionDetailViewController : BTIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;


// Other Public Properties
@property (nonatomic, retain) Person *person;
@property (nonatomic, retain) Action *action;
@property (nonatomic, retain, readonly) NSManagedObjectContext *scratchObjectContext;
@property (nonatomic, retain, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain, readonly) Person *scratchPerson;
@property (nonatomic, retain, readonly) Action *scratchAction;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;
@property (nonatomic, retain) NSMutableArray *imagePickerTitles;
@property (nonatomic, retain) ActionValue *scratchActiveImageActionValue;
@property (nonatomic, assign) CGPoint contentOffset;

// IBActions
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)saveButtonPressed:(UIBarButtonItem *)button;
- (void)personsButtonPressed:(UIBarButtonItem *)button;
- (IBAction)switchValueChanged:(UICustomSwitch *)customSwitch;

// Other Public Methods
- (void)addMissingActionValues;
- (void)preloadScratchActionFromDefaultValues;

@end
