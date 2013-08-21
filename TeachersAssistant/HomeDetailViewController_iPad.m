//
//  HomeDetailViewController.m
//  infraction
//
//  Created by Brian Slick on 10/6/10.
//  Copyright 2010 BriTer Ideas LLC. All rights reserved.
//

#import "HomeDetailViewController_iPad.h"


@interface HomeDetailViewController_iPad ()

// Private Properties
@property (nonatomic, retain) UIPopoverController *masterPopoverController;
@property (nonatomic, retain) UIBarButtonItem *masterPopoverBarButtonItem;

// Notification Handlers
- (void)logoImageDidChange:(NSNotification *)notification;
- (void)buttonTitleShouldChange:(NSNotification *)notification;
- (void)shouldShowMasterViewController:(NSNotification *)notification;
- (void)shouldHideMasterViewController:(NSNotification *)notification;
- (void)applicationWillEnterBackground:(NSNotification *)notification;


// UI Response Methods



// Misc Methods
- (void)refreshUserInterface;


@end

@implementation HomeDetailViewController_iPad

#pragma mark - Synthesized Properties

// Public
@synthesize backgroundImageView = ivBackgroundImageView;
@synthesize logoImageView = ivLogoImageView;
@synthesize personalizePopover = ivPersonalizePopover;
@synthesize imagePickerController = ivImagePickerController;

// Private
@synthesize masterPopoverController = ivMasterPopoverController;
@synthesize masterPopoverBarButtonItem = ivMasterPopoverBarButtonItem;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setBackgroundImageView:nil];
	[self setLogoImageView:nil];
	[self setPersonalizePopover:nil];
	[self setImagePickerController:nil];
    
	// Private Properties
    [self setMasterPopoverController:nil];
    [self setMasterPopoverBarButtonItem:nil];
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	[self setBackgroundImageView:nil];
	[self setLogoImageView:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)didReceiveMemoryWarning
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super didReceiveMemoryWarning];
	
	[[self backgroundImageView] setImage:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

#pragma mark - Initialization and UI Creation Methods

- (void)awakeFromNib
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[super awakeFromNib];

	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter addObserver:self selector:@selector(applicationWillEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(buttonTitleShouldChange:) name:kSplitMasterTitleDidChangeNotification object:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	if ([[DataController sharedDataController] isLiteVersion])
	{
		[self setTitle:@"Teacher's Assistant Lite"];
		
		UIBarButtonItem *upgradeButton = [[UIBarButtonItem alloc] initWithTitle:@"Upgrade to Pro"
																		  style:UIBarButtonItemStyleBordered
																		 target:self
																		 action:@selector(upgradeButtonPressed:)];
		[[self navigationItem] setRightBarButtonItem:upgradeButton];
		[upgradeButton release], upgradeButton = nil;
	}
	else
	{
		[self setTitle:@"Teacher's Assistant"];
		
		UIBarButtonItem *personalizeButton = [[UIBarButtonItem alloc] initWithTitle:@"Personalize"
																			  style:UIBarButtonItemStyleBordered
																			 target:self
																			 action:@selector(personalizeButtonPressed:)];
		[[self navigationItem] setRightBarButtonItem:personalizeButton];
		[personalizeButton release], personalizeButton = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	// Remove existing notifications to avoid duplicates
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter addObserver:self selector:@selector(logoImageDidChange:) name:kLogoImageDidChangeNotification object:nil];
//	[notificationCenter addObserver:self selector:@selector(buttonTitleShouldChange:) name:kSplitMasterTitleDidChangeNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(shouldShowMasterViewController:) name:kShouldShowMasterViewControllerNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(shouldHideMasterViewController:) name:kShouldHideMasterViewControllerNotification object:nil];
	
	TeachersAssistantAppDelegate_iPad *appDelegate = (TeachersAssistantAppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
	
	[[appDelegate splitViewController] setDelegate:self];
	
	[self refreshUserInterface];
	
	if ([self masterPopoverBarButtonItem] != nil)
	{
		UINavigationController *navController = [[[self splitViewController] viewControllers] objectAtIndex:0];
		UIViewController *viewController = [[navController viewControllers] lastObject];
		if ([[viewController title] length] == 0)
		{
			NSInteger numberOfViewControllers = [[navController viewControllers] count];
			NSInteger nextToLastIndex = numberOfViewControllers - 2;
			if (nextToLastIndex >= 0)
			{
				viewController = [[navController viewControllers] objectAtIndex:nextToLastIndex];
			}
		}
		[[self masterPopoverBarButtonItem] setTitle:[viewController title]];
	}
	
	[[self navigationController] setToolbarHidden:YES animated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidAppear:animated];
	
	NSLog(@"SplitViewController delegate is: %@", [[self splitViewController] delegate]);
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillDisappear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillDisappear:animated];
	
	if ([[self personalizePopover] isPopoverVisible])
	{
		[[self personalizePopover] setDelegate:nil];
		[[self personalizePopover] dismissPopoverAnimated:NO];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidDisappear:animated];
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

	[notificationCenter removeObserver:self name:kLogoImageDidChangeNotification object:nil];
//	[notificationCenter removeObserver:self name:kSplitMasterTitleDidChangeNotification object:nil];
	[notificationCenter removeObserver:self name:kShouldShowMasterViewControllerNotification object:nil];
	[notificationCenter removeObserver:self name:kShouldHideMasterViewControllerNotification object:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Notification Handlers

- (void)logoImageDidChange:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self refreshUserInterface];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)buttonTitleShouldChange:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSDictionary *userInfo = [notification userInfo];
	
	NSString *buttonTitle = [userInfo objectForKey:@"title"];
	
	[[[self navigationItem] leftBarButtonItem] setTitle:buttonTitle];
	[[self masterPopoverBarButtonItem] setTitle:buttonTitle];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)shouldShowMasterViewController:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if ( ([self interfaceOrientation] == UIInterfaceOrientationPortrait) || ([self interfaceOrientation] == UIInterfaceOrientationPortraitUpsideDown) )
	{
		if ( ([self masterPopoverController] != nil) && ([self masterPopoverBarButtonItem] != nil) )
		{
			[[self masterPopoverController] presentPopoverFromBarButtonItem:[self masterPopoverBarButtonItem] permittedArrowDirections:UIPopoverArrowDirectionUp animated:NO];
		}
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)shouldHideMasterViewController:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if ( ([self interfaceOrientation] == UIInterfaceOrientationPortrait) || ([self interfaceOrientation] == UIInterfaceOrientationPortraitUpsideDown) )
	{
		if ( ([self masterPopoverController] != nil) && ([self masterPopoverBarButtonItem] != nil) )
		{
			if ([[self masterPopoverController] isPopoverVisible])
			{
				[[self masterPopoverController] dismissPopoverAnimated:YES];
			}
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)applicationWillEnterBackground:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if ([self masterPopoverController] != nil)
	{
		[[self masterPopoverController] dismissPopoverAnimated:NO];
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UI Response Methods

- (IBAction)urlButton:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.youtube.com/watch?v=BQDyIoiOeOQ"]]; 
}
- (IBAction)urlButton2:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.youtube.com/watch?v=XK-OYSBIC6w"]]; 
}
- (IBAction)urlButton3:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/teachersassistant"]]; 
}

- (IBAction)urlButton4:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.youtube.com/watch?v=EQUO4lyksbQ"]]; 
}

- (IBAction)urlButton5:(id)sender {

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/cleveriosapps"]]; 
}
- (IBAction)urlButton6:(id)sender {
//	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:chris@cleveriosapps.com?subject=Teachers-Assistant-App-V5"]]; 
	
	[[DataController sharedDataController] sendSupportEmailFromViewController:[self splitViewController]];
}

- (IBAction)upgradeButtonPressed:(id)sender
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kShouldShowUpgradeViewNotification object:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (IBAction)personalizeButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

//	[[[self navigationItem] leftBarButtonItem] setEnabled:NO];
	
	if ([[self personalizePopover] isPopoverVisible])
	{
		[[self personalizePopover] setDelegate:nil];
		[[self personalizePopover] dismissPopoverAnimated:NO];
	}
	
	if ([[self masterPopoverController] isPopoverVisible])
	{
		[[self masterPopoverController] dismissPopoverAnimated:YES];
		[self setMasterPopoverController:nil];
	}
	
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	[self setImagePickerController:imagePicker];
	[imagePicker setMediaTypes:[NSArray arrayWithObject:(NSString *)kUTTypeImage]];
	[imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
	[imagePicker setDelegate:self];
	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
	[self setPersonalizePopover:popover];
	[popover setDelegate:self];
		
	[popover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
	[popover release], popover = nil;
	[imagePicker release], imagePicker = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (void)refreshUserInterface
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	DataController *dataController = [DataController sharedDataController];
	NSString *path = [[dataController imageDirectory] stringByAppendingPathComponent:kUserLogoImageFileName];
	
	UIImage *image = nil;
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:path])
	{
		image = [UIImage imageWithContentsOfFile:path];
	}
	
	if (image == nil)
	{
		image = [UIImage imageNamed:@"iDisciplineDocumentIcon320.png"];
	}

	[[self logoImageView] setImage:image];
	
	if ([[self backgroundImageView] image] == nil)
	{
		// TODO: Use smaller image
		[[self backgroundImageView] setImage:[UIImage imageNamed:@"paper_background_1004x768.png"]];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UISplitViewControllerDelegate Methods

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
			  inOrientation:(UIInterfaceOrientation)orientation
{
	return NO;
}

- (void)splitViewController:(UISplitViewController *)svc
	 willHideViewController:(UIViewController *)aViewController
		  withBarButtonItem:(UIBarButtonItem *)barButtonItem
	   forPopoverController:(UIPopoverController *)pc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSLog(@"viewController: %@", [aViewController description]);
	NSLog(@"barButtonItem: %@", [barButtonItem description]);
	
	[self setMasterPopoverController:pc];
	[self setMasterPopoverBarButtonItem:barButtonItem];
	
    if ([aViewController isKindOfClass:[UINavigationController class]])
    {
        id lastViewController = [[(UINavigationController *)aViewController viewControllers] lastObject];
        [barButtonItem setTitle:[lastViewController title]];
    }
    else
    {
        [barButtonItem setTitle:[aViewController title]];
    }
	
	NSLog(@"button title is: %@", [barButtonItem title]);
	[[self navigationItem] setLeftBarButtonItem:barButtonItem];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)splitViewController:(UISplitViewController *)svc
	 willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[self navigationItem] setLeftBarButtonItem:nil];
	[self setMasterPopoverController:nil];
	[self setMasterPopoverBarButtonItem:nil];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)splitViewController:(UISplitViewController *)svc 
		  popoverController:(UIPopoverController *)pc
  willPresentViewController:(UIViewController *)aViewController
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[self setMasterPopoverController:pc];
	
	if ([[self personalizePopover] isPopoverVisible])
	{
		[[self personalizePopover] setDelegate:nil];
		[[self personalizePopover] dismissPopoverAnimated:YES];
		[self setPersonalizePopover:nil];
	}
	
	[self setImagePickerController:nil];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UIPopoverController Delegate Methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

//	[[[self navigationItem] leftBarButtonItem] setEnabled:YES];
	
	[self setPersonalizePopover:nil];
	[self setImagePickerController:nil];
	
	[self refreshUserInterface];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	UIImage *image = nil;
	if ([info objectForKey:UIImagePickerControllerEditedImage] != nil)
		image = [info objectForKey:UIImagePickerControllerEditedImage];
	else
		image = [info objectForKey:UIImagePickerControllerOriginalImage];
	
	if (image != nil)
	{
		CGSize imageSize = [image size];
		
		CGFloat scaleFactor = 2.0;
		
		CGFloat imageMaxSideLength = [[self logoImageView] bounds].size.height;
		
		if ( (imageSize.width > imageMaxSideLength) || (imageSize.height > imageMaxSideLength) )
		{
			if (imageSize.width > imageSize.height)
				scaleFactor = imageMaxSideLength / imageSize.width;
			else
				scaleFactor = imageMaxSideLength / imageSize.height;
		}
		
		if (scaleFactor < 1.0)
		{
			CGSize newSize = CGSizeMake(scaleFactor * imageSize.width, scaleFactor * imageSize.height);
			
			image = [image resizedImage:newSize interpolationQuality:kCGInterpolationDefault];
		}
		
		DataController *dataController = [DataController sharedDataController];
		NSString *path = [[dataController imageDirectory] stringByAppendingPathComponent:kUserLogoImageFileName];
		NSData *data = UIImagePNGRepresentation(image);
		
		[data writeToFile:path atomically:YES];
	}
	
	if ([[self personalizePopover] isPopoverVisible])
	{
		[[self personalizePopover] setDelegate:nil];
		[[self personalizePopover] dismissPopoverAnimated:YES];
		[self setPersonalizePopover:nil];
	}
	
	[self setImagePickerController:nil];
	
	[self refreshUserInterface];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if ([[self personalizePopover] isPopoverVisible])
	{
		[[self personalizePopover] setDelegate:nil];
		[[self personalizePopover] dismissPopoverAnimated:YES];
		[self setPersonalizePopover:nil];
	}

	[self setImagePickerController:nil];
	
	[self refreshUserInterface];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
