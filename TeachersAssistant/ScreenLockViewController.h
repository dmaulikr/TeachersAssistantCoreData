//
//  ScreenLockViewController.h
//  infraction
//
//  Created by Brian Slick on 3/8/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"

// Public Constants

// Protocols

@interface ScreenLockViewController : BTIViewController
{
}


// Properties
@property (nonatomic, retain) IBOutlet UILabel *promptLabel;
@property (nonatomic, retain) IBOutlet UITextField *entryTextField;
@property (nonatomic, retain) IBOutlet UILabel *pinLabel1;
@property (nonatomic, retain) IBOutlet UILabel *pinLabel2;
@property (nonatomic, retain) IBOutlet UILabel *pinLabel3;
@property (nonatomic, retain) IBOutlet UILabel *pinLabel4;
@property (nonatomic, copy) NSString *password;


// Notification Handlers
- (void)textFieldDidChangeNotification:(NSNotification *)notification;

// UI Response
- (IBAction)resumeButtonPressed:(UIButton *)button;

// Other
- (void)updateLabels;

@end
