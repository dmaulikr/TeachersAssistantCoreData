//
//  ScreenLockSettingsViewController.h
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
#define kScreenLockEnableSectionKey				@"kScreenLockEnableSectionKey"
#define kScreenLockChangePinSectionKey			@"kScreenLockChangePinSectionKey"

// Protocols


@interface ScreenLockSettingsViewController : BTIViewController <UITableViewDelegate, UITableViewDataSource>
{
}

// Properties
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) IBOutlet UISwitch *lockSwitch;
@property (nonatomic, assign, getter=isLockEnabled) BOOL lockEnabled;
@property (nonatomic, retain) NSMutableArray *contents;

// Notification Handlers


// UI Response
- (IBAction)enabledSwitchValueChanged:(UISwitch *)theSwitch;

// Other
- (void)togglePinRow:(BOOL)shouldShow;


@end
