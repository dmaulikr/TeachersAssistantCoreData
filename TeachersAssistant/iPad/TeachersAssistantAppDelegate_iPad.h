//
//  TeachersAssistantAppDelegate_iPad.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/14/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "TeachersAssistantAppDelegate.h"

@interface TeachersAssistantAppDelegate_iPad : TeachersAssistantAppDelegate
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet UINavigationController *leftNavigationController;
@property (nonatomic, retain) IBOutlet UINavigationController *rightNavigationController;

- (void)dismissMasterPopover;

@end
