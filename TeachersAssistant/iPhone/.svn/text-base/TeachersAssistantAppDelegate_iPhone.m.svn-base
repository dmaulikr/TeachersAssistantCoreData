//
//  TeachersAssistantAppDelegate_iPhone.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/14/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "TeachersAssistantAppDelegate_iPhone.h"

#import "ScreenLockViewController.h"


@implementation TeachersAssistantAppDelegate_iPhone

#pragma mark - Synthesized Properties

@synthesize navigationController = ivNavigationController;


#pragma mark - Dealloc and Memory Management

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Public Properties
	[self setNavigationController:nil];
	
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UIApplication Delegate Methods

- (BOOL)application:(UIApplication *)application 
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self window] setRootViewController:[self navigationController]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application
			openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
		 annotation:(id)annotation
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }
	
	if (url != nil)
	{
		[self processLaunchURL:url];
		
		[[self navigationController] popToRootViewControllerAnimated:NO];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return YES;
}

#pragma mark - Notification Handlers

- (void)shouldShowCSVImporter:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	ImportCSVViewController *ivc = [[ImportCSVViewController alloc] init];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ivc];
	
	[[self navigationController] presentModalViewController:navController animated:YES];
	
	[navController release], navController = nil;
	[ivc release], ivc = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (void)showScreenLock
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Using a navigation controller seems to avoid parentViewController issue on iOS 5.  It is not otherwise necessary here.
	
	ScreenLockViewController *slvc = [[ScreenLockViewController alloc] init];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:slvc];
	[navController setNavigationBarHidden:YES animated:NO];
	
//	[[self navigationController] presentModalViewController:slvc animated:NO];
	[[self navigationController] presentModalViewController:navController animated:NO];
	
	[slvc release], slvc = nil;
	[navController release], navController = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)jumpButtonPressed
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	switch ([[NSUserDefaults standardUserDefaults] btiJumpButtonMode]) {
		case BTIJumpButtonModeHome:
		{
			[[self navigationController] popToRootViewControllerAnimated:YES];
		}
			break;
		case BTIJumpButtonModeClasses:
		case BTIJumpButtonModeStudents:
		{
			[[self navigationController] popToRootViewControllerAnimated:NO];
			[[self homeViewController] pushToJumpDestination];
		}
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)emailBlastButtonPressed
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self navigationController] popToRootViewControllerAnimated:NO];
	[[self homeViewController] pushToEmailBlast];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
