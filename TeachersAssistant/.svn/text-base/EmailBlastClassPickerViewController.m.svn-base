//
//  EmailBlastClassPickerViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 12/11/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "EmailBlastClassPickerViewController.h"

// Models and other global

// Sub-controllers
#import "EmailBlastPersonPickerViewController.h"
#import "EmailBlastRecipientsViewController.h"

// Views

// Private Constants


@interface EmailBlastClassPickerViewController ()

// Private Properties
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

// Notification Handlers



// UI Response Methods
- (void)settingsButtonPressed:(UIBarButtonItem *)button;


// Misc Methods

@end

@implementation EmailBlastClassPickerViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize fromSettings = ivFromSettings;

// Private
@synthesize fetchedResultsController = ivFetchedResultsController;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTableView:nil];
	
	
	// Private Properties
	[self setFetchedResultsController:nil];
	
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	[[self fetchedResultsController] setDelegate:nil];
	[self setFetchedResultsController:nil];
	
	[self setMainTableView:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

- (NSFetchedResultsController *)fetchedResultsController
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivFetchedResultsController == nil)
	{
		DataController *dataController = [DataController sharedDataController];
		NSManagedObjectContext *context = [dataController managedObjectContext];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		[fetchRequest setEntity:[ClassPeriod entityDescriptionInContextBTI:context]];
		
		[fetchRequest setSortDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
		
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"sortOrder >= %@", [NSNumber numberWithInt:0]]];
		
		ivFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																		 managedObjectContext:context
																		   sectionNameKeyPath:nil
																					cacheName:nil];
		[ivFetchedResultsController setDelegate:self];
		
		[ivFetchedResultsController performFetchBTI];
		
		[fetchRequest release], fetchRequest = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivFetchedResultsController;
}

#pragma mark - Initialization and UI Creation Methods

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:@"Email Blast"];
	
	NSString *buttonTitle = @"Set Email Blast Recipients";
	
	if ([self isFromSettings])
	{
		[self setTitle:@"Specify Recipients"];
		buttonTitle = @"Go to Email Blast List";
	}
	
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	
	UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:buttonTitle
																	   style:UIBarButtonItemStyleBordered
																	  target:self
																	  action:@selector(settingsButtonPressed:)];
	
	[self setToolbarItems:[NSArray arrayWithObjects:flexItem, settingsButton, flexItem, nil]];
	[settingsButton release], settingsButton = nil;
	[flexItem release], flexItem = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self navigationController] setToolbarHidden:NO animated:YES];
	
	[[self mainTableView] reloadData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidAppear:animated];
	
	if (![self isFromSettings])
	{
		if (![[NSUserDefaults standardUserDefaults] btiDidShowEmailBlastTip])
		{
			RIButtonItem *cancelButton = [RIButtonItem item];
			[cancelButton setLabel:@"Ok"];
			
			RIButtonItem *settingsButton = [RIButtonItem item];
			[settingsButton setLabel:@"Settings"];
			[settingsButton setAction:^{
				
				EmailBlastClassPickerViewController *nextViewController = [[EmailBlastClassPickerViewController alloc] init];
				[nextViewController setFromSettings:YES];
				
				[[self navigationController] pushViewController:nextViewController animated:YES];
				
				[nextViewController release], nextViewController = nil;
				
			}];
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
															message:@"You must add specific recipients for your Email Blast by tapping the button at the bottom of the screen"
												   cancelButtonItem:cancelButton
												   otherButtonItems:settingsButton, nil];
			[alert show];
			[alert release], alert = nil;
			
			[[NSUserDefaults standardUserDefaults] btiSetDidShowEmailBlastTip:YES];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillDisappear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillDisappear:animated];
	
	[[self fetchedResultsController] setDelegate:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidDisappear:animated];
	
	
	[self setFetchedResultsController:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)setEditing:(BOOL)editing
		  animated:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super setEditing:editing animated:animated];
	
	[[self mainTableView] setEditing:editing animated:animated];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Notification Handlers



#pragma mark - UI Response Methods

- (void)settingsButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if ([self isFromSettings])
	{
		[(TeachersAssistantAppDelegate *)[[UIApplication sharedApplication] delegate] emailBlastButtonPressed];
	}
	else
	{
		EmailBlastClassPickerViewController *nextViewController = [[EmailBlastClassPickerViewController alloc] init];
		[nextViewController setFromSettings:YES];
		
		[[self navigationController] pushViewController:nextViewController animated:YES];
		
		[nextViewController release], nextViewController = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


#pragma mark - Misc Methods


#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger sections = [[[self fetchedResultsController] sections] count];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return sections;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
	
	NSInteger rows = [sectionInfo numberOfObjects] + 1;		// Allow for "All" row
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger row = [indexPath row];
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	
	if (row == 0)
	{
		[[cell textLabel] setText:[NSString stringWithFormat:@"All %@", [[DataController sharedDataController] pluralNameForTermInfoIndentifier:kTermInfoIdentifierPerson]]];
	}
	else
	{
		NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:row - 1 inSection:0];
		
		ClassPeriod *class = [[self fetchedResultsController] objectAtIndexPath:adjustedIndexPath];
		
		[[cell textLabel] setText:[class name]];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSInteger row = [indexPath row];
	
	UIViewController *nextViewController = nil;
	
	if ([self isFromSettings])
	{
		nextViewController = [[EmailBlastRecipientsViewController alloc] init];
	}
	else
	{	
		nextViewController = [[EmailBlastPersonPickerViewController alloc] init];
	}
	
	if (row != 0)
	{
		NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:row - 1 inSection:0];
		
		ClassPeriod *class = [[self fetchedResultsController] objectAtIndexPath:adjustedIndexPath];
		
		[(EmailBlastPersonPickerViewController *)nextViewController setClassPeriod:class];
	}
	
	[[self navigationController] pushViewController:nextViewController animated:YES];
	
	[nextViewController release], nextViewController = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
