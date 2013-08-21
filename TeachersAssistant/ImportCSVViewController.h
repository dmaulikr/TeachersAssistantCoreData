//
//  ImportCSVViewController.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/30/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"
@class CSVTableCell;

// Public Constants

// Protocols

@interface ImportCSVViewController : BTIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) IBOutlet CSVTableCell *csvTableCell;

// Other Public Properties


// IBActions


// Other Public Methods
+ (NSData *)templateFileForCSVImport;
+ (void)emailTemplateCSVFileFromViewController:(id)viewController;

@end
