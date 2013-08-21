//
//  ActionFieldInfoViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/19/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ActionFieldInfoViewController.h"

// Models and other global

// Sub-controllers
#import "ActionFieldInfoDetailsViewController.h"
#import "UpgradeViewController.h"

// Views

// Private Constants


@interface ActionFieldInfoViewController ()

// Private Properties
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSIndexPath *indexPathToDelete;

// Notification Handlers



// UI Response Methods
- (void)addButtonPressed:(UIBarButtonItem *)button;
- (void)upgradeButtonPressed:(id)sender;

// Misc Methods
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;


@end

@implementation ActionFieldInfoViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;

// Private
@synthesize fetchedResultsController = ivFetchedResultsController;
@synthesize indexPathToDelete = ivIndexPathToDelete;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTableView:nil];
	
	
	// Private Properties
	[self setFetchedResultsController:nil];
	[self setIndexPathToDelete:nil];
	
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
		
		[fetchRequest setEntity:[ActionFieldInfo entityDescriptionInContextBTI:context]];
		
		[fetchRequest setSortDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
		
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
	
	DataController *dataController = [DataController sharedDataController];
	NSString *string = [NSString stringWithFormat:@"%@ Fields", [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierAction]];
	[self setTitle:string];
	
	if ([dataController isLiteVersion])
	{
		UIBarButtonItem *upperUpgrade = [[UIBarButtonItem alloc] initWithTitle:@"Upgrade"
																		 style:UIBarButtonItemStyleBordered
																		target:self
																		action:@selector(upgradeButtonPressed:)];
		[[self navigationItem] setRightBarButtonItem:upperUpgrade];
		[upperUpgrade release], upperUpgrade = nil;
	}
	else
	{
		UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																				   target:self
																				   action:@selector(addButtonPressed:)];
		[[self navigationItem] setRightBarButtonItem:addButton];
		[addButton release], addButton = nil;
	}
	
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
	
	[self setToolbarItems:[NSArray arrayWithObjects:flexItem, [self editButtonItem], nil]];
    
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

- (void)addButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	ActionFieldInfoDetailsViewController *nextViewController = [[ActionFieldInfoDetailsViewController alloc] init];
	
	[[self navigationController] pushViewController:nextViewController animated:YES];
	
	[nextViewController release], nextViewController = nil;

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)upgradeButtonPressed:(id)sender
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if ([[DataController sharedDataController] isIPadVersion])
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:kShouldShowUpgradeViewNotification object:nil];
	}
	else
	{
		// Using a navigation controller seems to avoid parentViewController issue on iOS 5.  It is not otherwise necessary here.
		
		UpgradeViewController *uvc = [[UpgradeViewController alloc] init];
		
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:uvc];
		[navController setNavigationBarHidden:YES animated:NO];
		
		//		[self presentModalViewController:uvc animated:YES];
		[self presentModalViewController:navController animated:NO];
		
		[uvc release], uvc = nil;
		[navController release], navController = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (void)configureCell:(UITableViewCell *)cell
		  atIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	ActionFieldInfo *actionFieldInfo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	TermInfo *termInfo = [actionFieldInfo termInfo];
	
	[[cell textLabel] setText:[[DataController sharedDataController] singularNameForTermInfo:termInfo]];
	
	if ([[actionFieldInfo isHidden] boolValue])
	{
		[[cell textLabel] setTextColor:[UIColor lightGrayColor]];
	}
	else
	{
		[[cell textLabel] setTextColor:[UIColor blackColor]];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

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
	
	NSInteger rows = [sectionInfo numberOfObjects];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	
	[self configureCell:cell atIndexPath:indexPath];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return cell;
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
	  toIndexPath:(NSIndexPath *)toIndexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	NSMutableArray *actionFieldInfos = [NSMutableArray arrayWithArray:[[self fetchedResultsController] fetchedObjects]];
	
	ActionFieldInfo *actionFieldInfo = [actionFieldInfos objectAtIndex:[fromIndexPath row]];
	[actionFieldInfos removeObjectAtIndex:[fromIndexPath row]];
	[actionFieldInfos insertObject:actionFieldInfo atIndex:[toIndexPath row]];
	
	[[self fetchedResultsController] setDelegate:nil];
	
	[actionFieldInfos enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		ActionFieldInfo *actionFieldInfo = (ActionFieldInfo *)object;
		[actionFieldInfo setSortOrder:[NSNumber numberWithInt:index]];
		
	}];
    
	[[self fetchedResultsController] setDelegate:self];
	[[self fetchedResultsController] performFetchBTI];
	
	[[self mainTableView] performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		[self setIndexPathToDelete:indexPath];
		
		NSString *actionString = [[DataController sharedDataController] singularNameForTermInfoIndentifier:kTermInfoIdentifierAction];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Warning"
														message:[NSString stringWithFormat:@"If you delete this field, all corresponding %@ data will also be deleted.\n\nIf you would like to keep this data, HIDE the field instead.", actionString]
													   delegate:self
											  cancelButtonTitle:@"Cancel"
											  otherButtonTitles:@"Delete", @"Hide", nil];
		[alert show];
		[alert release], alert = nil;
		
//		ClassPeriod *class = [[self fetchedResultsController] objectAtIndexPath:indexPath];
//		
//		[[[DataController sharedDataController] managedObjectContext] deleteObject:class];
	}
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	ActionFieldInfo *actionFieldInfo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	ActionFieldInfoDetailsViewController *nextViewController = [[ActionFieldInfoDetailsViewController alloc] init];
	[nextViewController setActionFieldInfo:actionFieldInfo];
	
	[[self navigationController] pushViewController:nextViewController animated:YES];
	
	[nextViewController release], nextViewController = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
		   editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	UITableViewCellEditingStyle style = UITableViewCellEditingStyleDelete;
	
	ActionFieldInfo *actionFieldInfo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	if ([actionFieldInfo identifier] != nil)		// It's a default field
	{
		style = UITableViewCellEditingStyleNone;
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return style;
}

#pragma mark - NSFetchedResultsController Delegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self mainTableView] beginUpdates];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self mainTableView] endUpdates];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	switch (type)
	{
		case NSFetchedResultsChangeInsert:
			NSLog(@"insert");
			[[self mainTableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			NSLog(@"delete");
			[[self mainTableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate:
			NSLog(@"update");
			[self configureCell:[[self mainTableView] cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
		case NSFetchedResultsChangeMove:
			NSLog(@"move");
			[[self mainTableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[[self mainTableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	switch (type)
	{
		case NSFetchedResultsChangeInsert:
			NSLog(@"insert");
			[[self mainTableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			NSLog(@"delete");
			[[self mainTableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		default:
			NSLog(@"There was some other option!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSLog(@"buttonIndex is: %d", buttonIndex);
	
	if (buttonIndex != [alertView cancelButtonIndex])
	{
		ActionFieldInfo *actionFieldInfo = [[self fetchedResultsController] objectAtIndexPath:[self indexPathToDelete]];
		
		switch (buttonIndex) {
			case 1:			// Delete
			{
				[[[DataController sharedDataController] managedObjectContext] deleteObject:actionFieldInfo];
			}
				break;
			case 2:			// Hide
			{
				[actionFieldInfo setIsHidden:[NSNumber numberWithBool:YES]];
			}
			default:
				break;
		}
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
