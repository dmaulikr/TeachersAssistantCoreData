//
//  TeachersAssistantAppDelegate.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/14/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ImportCSVViewController.h"
#import "HomeViewController.h"

@interface TeachersAssistantAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate>
{	
}

// Public Properties
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet HomeViewController *homeViewController;

#pragma mark - Notification Handlers
- (void)shouldShowCSVImporter:(NSNotification *)notification;

#pragma mark - Misc
- (void)processLaunchURL:(NSURL *)url;
- (void)showScreenLock;
+ (BOOL)isRetinaDisplay;
- (void)jumpButtonPressed;
- (void)emailBlastButtonPressed;

@end
