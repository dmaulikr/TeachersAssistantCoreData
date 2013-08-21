//
//  UpgradeViewController.h
//  infraction
//
//  Created by Brian Slick on 10/4/10.
//  Copyright 2010 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"

// Public Constants

// Protocols

@interface UpgradeViewController : BTIViewController
{
	UIButton *ivExportButton;
}


// Properties
@property (nonatomic, retain) IBOutlet UIButton *exportButton;

// Notification Handlers


// UI Response
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)button;
- (IBAction)downloadButtonPressed:(UIButton *)button;
- (IBAction)exportButtonPressed:(UIButton *)button;

// Other

@end
