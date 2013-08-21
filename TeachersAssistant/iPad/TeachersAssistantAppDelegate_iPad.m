//
//  TeachersAssistantAppDelegate_iPad.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/14/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "TeachersAssistantAppDelegate_iPad.h"

// View Controllers
#import "HomeDetailViewController_iPad.h"
#import "ActionDetailViewController_iPad.h"
#import "UpgradeViewController_iPad.h"
#import "ScreenLockViewController_iPad.h"
#import "PersonInfoViewController_iPad.h"

@interface TeachersAssistantAppDelegate_iPad ()

- (void)shouldShowInfractionDetailView:(NSNotification *)notification;
- (void)shouldHideInfractionDetailView:(NSNotification *)notification;
- (void)shouldShowStudentDetailView:(NSNotification *)notification;
- (void)shouldHideStudentDetailView:(NSNotification *)notification;

@end

@implementation TeachersAssistantAppDelegate_iPad

#pragma mark - Synthesized Properties

@synthesize splitViewController = ivSplitViewController;
@synthesize leftNavigationController = ivLeftNavigationController;
@synthesize rightNavigationController = ivRightNavigationController;

#pragma mark - Dealloc and Memory Management

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Public Properties
	[self setSplitViewController:nil];
	[self setLeftNavigationController:nil];
	[self setRightNavigationController:nil];
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UIApplication Delegate Methods

- (BOOL)application:(UIApplication *)application 
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(shouldShowUpgradeView:) name:kShouldShowUpgradeViewNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(shouldShowInfractionDetailView:) name:kShouldShowActionDetailViewNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(shouldHideInfractionDetailView:) name:kShouldHideActionDetailViewNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(shouldShowStudentDetailView:) name:kShouldShowStudentDetailViewNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(shouldHideStudentDetailView:) name:kShouldHideStudentDetailViewNotification object:nil];
	
	[[self window] setRootViewController:[self splitViewController]];
	
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
		
		[[self leftNavigationController] popToRootViewControllerAnimated:NO];
		[[self rightNavigationController] popToRootViewControllerAnimated:NO];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return YES;
}

#pragma mark - UINavigationControllerDelegate Methods

//- (void)navigationController:(UINavigationController *)navigationController
//	  willShowViewController:(UIViewController *)viewController
//					animated:(BOOL)animated
//{
//	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
//
//	
//
//	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
//}

- (void)navigationController:(UINavigationController *)navigationController
	   didShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSString *title = [viewController title];
	
	if (title != nil)
	{
		NSLog(@"Now showing: %@", title);
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:title forKey:@"title"];
		[[NSNotificationCenter defaultCenter] postNotificationName:kSplitMasterTitleDidChangeNotification object:nil userInfo:userInfo];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Notification Handlers

- (void)shouldShowCSVImporter:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	ImportCSVViewController *ivc = [[ImportCSVViewController alloc] init];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ivc];
	
	[[self splitViewController] presentModalViewController:navController animated:YES];
	
	[navController release], navController = nil;
	[ivc release], ivc = nil;

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)shouldShowUpgradeView:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSArray *viewControllers = [[self rightNavigationController] viewControllers];
	
	id lastController = [viewControllers lastObject];
	
	if (![lastController isKindOfClass:[UpgradeViewController_iPad class]])
	{
		UpgradeViewController_iPad *uvc = [[UpgradeViewController_iPad alloc] init];
		
		[[self rightNavigationController] pushViewController:uvc animated:YES];
		
		[uvc release], uvc = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)shouldShowInfractionDetailView:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Remove the upgrade screen if necessary
	NSArray *viewControllers = [[self rightNavigationController] viewControllers];
	
	id lastController = [viewControllers lastObject];

	if ([lastController isKindOfClass:[UpgradeViewController_iPad class]])
	{
		[[self rightNavigationController] popViewControllerAnimated:NO];
	}
	
	NSDictionary *info = (NSDictionary *)[notification object];
	Person *person = [info objectForKey:kNotificationPersonObjectKey];
	Action *action = [info objectForKey:kNotificationActionObjectKey];
	
	ActionDetailViewController_iPad *nextViewController = [[ActionDetailViewController_iPad alloc] init];
	[nextViewController setPerson:person];
	
	if (action != nil)
	{
		[nextViewController setAction:action];
	}
	
	[[self rightNavigationController] pushViewController:nextViewController animated:YES];
	
	[nextViewController release], nextViewController = nil;
	
	[self dismissMasterPopover];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)shouldHideInfractionDetailView:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSArray *viewControllers = [[self rightNavigationController] viewControllers];
	
	id lastController = [viewControllers lastObject];
	
	if ([lastController isKindOfClass:[ActionDetailViewController_iPad class]])
	{
		[(ActionDetailViewController_iPad *)lastController saveButtonPressed:nil];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)shouldShowStudentDetailView:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	// Remove the upgrade screen if necessary
	NSArray *viewControllers = [[self rightNavigationController] viewControllers];
	
	id lastController = [viewControllers lastObject];
	
	if ([lastController isKindOfClass:[UpgradeViewController_iPad class]])
	{
		[[self rightNavigationController] popViewControllerAnimated:NO];
	}
	
	NSDictionary *info = (NSDictionary *)[notification object];
	Person *person = [info objectForKey:kNotificationPersonObjectKey];

	PersonInfoViewController_iPad *nextViewController = [[PersonInfoViewController_iPad alloc] init];
	[nextViewController setPerson:person];
	
	[[self rightNavigationController] pushViewController:nextViewController animated:YES];
	
	[nextViewController release], nextViewController = nil;
	
	[self dismissMasterPopover];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)shouldHideStudentDetailView:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSArray *viewControllers = [[self rightNavigationController] viewControllers];
	
	__block NSInteger foundIndex = NSNotFound;
	
	[viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger index, BOOL *stop) {
		
		if ([viewController isKindOfClass:[PersonInfoViewController_iPad class]])
		{
			foundIndex = index;
			*stop = YES;
		}
		
	}];
	
	if (foundIndex != NSNotFound)
	{
		if (foundIndex > 0)
		{
			foundIndex--;
		}
		
		UIViewController *targetViewController = [viewControllers objectAtIndex:foundIndex];
		
		[[self rightNavigationController] popToViewController:targetViewController animated:YES];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)dismissMasterPopover
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if ([[self splitViewController] delegate] != nil)
	{
		if ([(id)[[self splitViewController] delegate] isKindOfClass:[HomeDetailViewController_iPad class]])
		{
			HomeDetailViewController_iPad *homeDetailViewController = (HomeDetailViewController_iPad *)[[self splitViewController] delegate];
			
			if ([[homeDetailViewController masterPopoverController] isPopoverVisible])
			{
				[[homeDetailViewController masterPopoverController] dismissPopoverAnimated:YES];
			}
		}
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (void)showScreenLock
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Using a navigation controller seems to avoid parentViewController issue on iOS 5.  It is not otherwise necessary here.
	
	ScreenLockViewController_iPad *slvc = [[ScreenLockViewController_iPad alloc] init];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:slvc];
	[navController setNavigationBarHidden:YES animated:NO];
	
//	[[self splitViewController] presentModalViewController:slvc animated:NO];
	[[self splitViewController] presentModalViewController:navController animated:NO];

	[navController release], navController = nil;
	[slvc release], slvc = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)jumpButtonPressed
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	switch ([[NSUserDefaults standardUserDefaults] btiJumpButtonMode]) {
		case BTIJumpButtonModeHome:
		{
			[[self leftNavigationController] popToRootViewControllerAnimated:YES];
		}
			break;
		case BTIJumpButtonModeClasses:
		case BTIJumpButtonModeStudents:
		{
			[self shouldHideInfractionDetailView:nil];
			[[self leftNavigationController] popToRootViewControllerAnimated:NO];
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
	
	[[self leftNavigationController] popToRootViewControllerAnimated:NO];
	[[self homeViewController] pushToEmailBlast];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
