//
//  AssignActionsToPersonsViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/20/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "AssignActionsToPersonsViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface AssignActionsToPersonsViewController ()

// Private Properties
@property (nonatomic, retain) NSFetchedResultsController *classPeriodsFetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *personsFetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *searchPersonsFetchedResultsController;
@property (nonatomic, retain) NSMutableSet *classPeriodsSelectionSet;
@property (nonatomic, retain) NSMutableSet *personsSelectionSet;
@property (nonatomic, copy) NSString *savedSearchTerm;

// Notification Handlers



// UI Response Methods
- (void)assignButtonPressed:(UIBarButtonItem *)button;
- (void)allButtonPressed:(UIBarButtonItem *)button;
- (void)noneButtonPressed:(UIBarButtonItem *)button;

// Misc Methods
- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end

@implementation AssignActionsToPersonsViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize scratchObjectContext = ivScratchObjectContext;
@synthesize scratchAction = ivScratchAction;

// Private
@synthesize classPeriodsFetchedResultsController = ivClassPeriodsFetchedResultsController;
@synthesize personsFetchedResultsController = ivPersonsFetchedResultsController;
@synthesize searchPersonsFetchedResultsController = ivSearchPersonsFetchedResultsController;
@synthesize classPeriodsSelectionSet = ivClassPeriodsSelectionSet;
@synthesize personsSelectionSet = ivPersonsSelectionSet;
@synthesize savedSearchTerm = ivSavedSearchTerm;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTableView:nil];
	[self setScratchObjectContext:nil];
	[self setScratchAction:nil];
	
	// Private Properties
    [self setClassPeriodsFetchedResultsController:nil];
    [self setPersonsFetchedResultsController:nil];
    [self setSearchPersonsFetchedResultsController:nil];
    [self setClassPeriodsSelectionSet:nil];
    [self setPersonsSelectionSet:nil];
	[self setSavedSearchTerm:nil];
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	[self setMainTableView:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

- (NSFetchedResultsController *)classPeriodsFetchedResultsController
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivClassPeriodsFetchedResultsController == nil)
	{
		DataController *dataController = [DataController sharedDataController];
		NSManagedObjectContext *context = [dataController managedObjectContext];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		[fetchRequest setEntity:[ClassPeriod entityDescriptionInContextBTI:context]];
		
		[fetchRequest setSortDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
		
		ivClassPeriodsFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																		 managedObjectContext:context
																		   sectionNameKeyPath:nil
																					cacheName:nil];
		[ivClassPeriodsFetchedResultsController setDelegate:self];
		
		[ivClassPeriodsFetchedResultsController performFetchBTI];
		
		[fetchRequest release], fetchRequest = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivClassPeriodsFetchedResultsController;
}

- (NSFetchedResultsController *)personsFetchedResultsController
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivPersonsFetchedResultsController == nil)
	{
		DataController *dataController = [DataController sharedDataController];
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		NSManagedObjectContext *context = [dataController managedObjectContext];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		[fetchRequest setEntity:[Person entityDescriptionInContextBTI:context]];
		
		NSString *sectionNameKeyPath = nil;
		
		switch ([userDefaults btiPersonSortMode]) {
			case BTIPersonSortModeFirstLast:
			{
				[fetchRequest setSortDescriptors:[dataController descriptorArrayForFirstNameAlphabeticSort]];
//				sectionNameKeyPath = kFIRST_LETTER_OF_FIRST_NAME;
			}
				break;
			case BTIPersonSortModeLastFirst:
			{
				[fetchRequest setSortDescriptors:[dataController descriptorArrayForLastNameAlphabeticSort]];
//				sectionNameKeyPath = kFIRST_LETTER_OF_LAST_NAME;
			}
				break;
			default:
				break;
		}
		
		ivPersonsFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																		 managedObjectContext:context
																		   sectionNameKeyPath:sectionNameKeyPath
																					cacheName:nil];
		[ivPersonsFetchedResultsController setDelegate:self];
		
		[ivPersonsFetchedResultsController performFetchBTI];
		
		[fetchRequest release], fetchRequest = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivPersonsFetchedResultsController;
}

- (NSFetchedResultsController *)searchPersonsFetchedResultsController
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivSearchPersonsFetchedResultsController == nil)
	{
		DataController *dataController = [DataController sharedDataController];
		NSManagedObjectContext *context = [dataController managedObjectContext];
		
		NSFetchRequest *mainFetchRequest = [[self personsFetchedResultsController] fetchRequest];
		NSFetchRequest *searchFetchRequest = [[NSFetchRequest alloc] init];
		
		[searchFetchRequest setEntity:[mainFetchRequest entity]];
		[searchFetchRequest setSortDescriptors:[mainFetchRequest sortDescriptors]];
		
		if ([self savedSearchTerm] != nil)
		{
			NSPredicate *firstNamePredicate = [NSPredicate predicateWithFormat:@"firstName CONTAINS[c] %@", [self savedSearchTerm]];
			NSPredicate *lastNamePredicate = [NSPredicate predicateWithFormat:@"lastName CONTAINS[c] %@", [self savedSearchTerm]];
			NSPredicate *detailsPredicate = [NSPredicate predicateWithFormat:@"ANY personDetailValues.name CONTAINS[c] %@", [self savedSearchTerm]];
			
			[searchFetchRequest setPredicate:[NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:firstNamePredicate, lastNamePredicate, detailsPredicate, nil]]];
			
//			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(firstName CONTAINS[c] %@) OR (lastName CONTAINS[c] %@) OR (other CONTAINS[c] %@)", [self savedSearchTerm], [self savedSearchTerm], [self savedSearchTerm]];
//			[searchFetchRequest setPredicate:predicate];
		}
		
		ivSearchPersonsFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:searchFetchRequest
																			   managedObjectContext:context
																				 sectionNameKeyPath:nil
																						  cacheName:nil];
		[ivSearchPersonsFetchedResultsController setDelegate:self];
		[ivSearchPersonsFetchedResultsController performFetchBTI];
		
		[searchFetchRequest release], searchFetchRequest = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivSearchPersonsFetchedResultsController;
}

- (NSMutableSet *)classPeriodsSelectionSet
{
	if (ivClassPeriodsSelectionSet == nil)
	{
		ivClassPeriodsSelectionSet = [[NSMutableSet alloc] init];
	}
	return ivClassPeriodsSelectionSet;
}

- (NSMutableSet *)personsSelectionSet
{
	if (ivPersonsSelectionSet == nil)
	{
		ivPersonsSelectionSet = [[NSMutableSet alloc] init];
	}
	return ivPersonsSelectionSet;
}

#pragma mark - Initialization and UI Creation Methods


#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:[NSString stringWithFormat:@"Select %@", [[DataController sharedDataController] pluralNameForTermInfoIndentifier:kTermInfoIdentifierPerson]]];
	
	UIBarButtonItem *assign = [[UIBarButtonItem alloc] initWithTitle:@"Assign"
															   style:UIBarButtonItemStyleBordered
															  target:self
															  action:@selector(assignButtonPressed:)];
	[[self navigationItem] setRightBarButtonItem:assign];
	[assign release], assign = nil;
	
	UIBarButtonItem *allButton = [[UIBarButtonItem alloc] initWithTitle:@"Select All"
																  style:UIBarButtonItemStyleBordered
																 target:self
																 action:@selector(allButtonPressed:)];
	
	UIBarButtonItem *noneButton = [[UIBarButtonItem alloc] initWithTitle:@"Select None"
																   style:UIBarButtonItemStyleBordered
																  target:self
																  action:@selector(noneButtonPressed:)];
	
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	
	[self setToolbarItems:[NSArray arrayWithObjects:noneButton, flexItem, allButton, nil]];
	
	[allButton release], allButton = nil;
	[noneButton release], noneButton = nil;
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
	
	[[self searchPersonsFetchedResultsController] setDelegate:nil];
	[[self classPeriodsFetchedResultsController] setDelegate:nil];
	[[self personsFetchedResultsController] setDelegate:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidDisappear:animated];
	
	
	
	[self setSearchPersonsFetchedResultsController:nil];
	[self setClassPeriodsFetchedResultsController:nil];
	[self setPersonsFetchedResultsController:nil];
	
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

- (void)assignButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	DataController *dataController = [DataController sharedDataController];
	NSManagedObjectContext *context = [self scratchObjectContext];
	
	NSDate *createdDate = [NSDate date];
	NSDate *modifiedDate = [NSDate date];
	
	for (Person *person in [self personsSelectionSet])
	{
		Person *scratchPerson = (Person *)[[self scratchObjectContext] existingObjectWithID:[person objectID] error:nil];
		
		Action *scratchNewAction = [Action managedObjectInContextBTI:context];
		[scratchNewAction setDateCreated:createdDate];
		[scratchNewAction setDateModified:modifiedDate];
		[scratchNewAction setPerson:scratchPerson];
		
		for (ActionValue *scratchActionValue in [[self scratchAction] actionValues])
		{
			ActionValue *scratchNewActionValue = [ActionValue managedObjectInContextBTI:context];
			[scratchNewActionValue setActionFieldInfo:[scratchActionValue actionFieldInfo]];
			[scratchNewActionValue setAction:scratchNewAction];
			
			[scratchNewActionValue setDate:[scratchActionValue date]];
			[scratchNewActionValue setBoolean:[scratchActionValue boolean]];
			[scratchNewActionValue setLongText:[scratchActionValue longText]];
			
			for (PickerValue *pickerValue in [scratchActionValue pickerValues])
			{
				PickerValue *scratchPickerValue = (PickerValue *)[[self scratchObjectContext] existingObjectWithID:[pickerValue objectID] error:nil];
				
				[scratchNewActionValue addPickerValuesObject:scratchPickerValue];
			}
		}
	}

	[[self scratchObjectContext] deleteObject:[self scratchAction]];
	
	[dataController saveManagedObjectContext:[self scratchObjectContext]];
	
	[dataController saveCoreDataContext];
	
	[[self navigationController] popToRootViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)allButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSArray *allClasses = [[self classPeriodsFetchedResultsController] fetchedObjects];
	NSArray *allPersons = [[self personsFetchedResultsController] fetchedObjects];
	
	[[self classPeriodsSelectionSet] unionSet:[NSSet setWithArray:allClasses]];
	[[self personsSelectionSet] unionSet:[NSSet setWithArray:allPersons]];
	
	[[self mainTableView] reloadData];
	[[[self searchDisplayController] searchResultsTableView] reloadData];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)noneButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self classPeriodsSelectionSet] removeAllObjects];
	[[self personsSelectionSet] removeAllObjects];
	
	[[self mainTableView] reloadData];
	[[[self searchDisplayController] searchResultsTableView] reloadData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView
														   indexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSFetchedResultsController *controllerToReturn = nil;

	if (tableView != [self mainTableView])
	{
		controllerToReturn = [self searchPersonsFetchedResultsController];
	}
	else
	{
		if ([indexPath section] == 0)
			controllerToReturn = [self classPeriodsFetchedResultsController];
		else
			controllerToReturn = [self personsFetchedResultsController];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return controllerToReturn;
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger sections = 2;
	
	if (tableView != [self mainTableView])
		sections = 1;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return sections;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *header = nil;
	
	if (tableView == [self mainTableView])
	{
		if ([[[self classPeriodsFetchedResultsController] fetchedObjects] count] != 0)
		{
			DataController *dataController = [DataController sharedDataController];
			
			if (section == 0)
				header = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierClass];
			else
				header = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return header;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
	id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsControllerForTableView:tableView indexPath:indexPath] sections] objectAtIndex:0];
	
	NSInteger rows = [sectionInfo numberOfObjects];
	
	NSLog(@"rows is: %d", rows);
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
	}
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSFetchedResultsController *fetchedResultsController = [self fetchedResultsControllerForTableView:tableView indexPath:indexPath];
	
	NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:[indexPath row] inSection:0];
	
	if ( (tableView != [self mainTableView]) || ([indexPath section] == 1) )
	{
		Person *person = [fetchedResultsController objectAtIndexPath:adjustedIndexPath];
		
		switch ([userDefaults btiPersonDisplayMode]) {
			case BTIPersonSortModeFirstLast:
				[[cell textLabel] setText:[person fullName]];
				break;
			case BTIPersonSortModeLastFirst:
			{
				[[cell textLabel] setText:[person reverseFullName]];
			}
				break;
			default:
				break;
		}
		
		[cell setAccessoryType:([[self personsSelectionSet] containsObject:person]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
	}
	else
	{
		ClassPeriod *class = [fetchedResultsController objectAtIndexPath:adjustedIndexPath];
		
		[[cell textLabel] setText:[class name]];
		
		[cell setAccessoryType:([[self classPeriodsSelectionSet] containsObject:class]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
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
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	NSFetchedResultsController *fetchedResultsController = [self fetchedResultsControllerForTableView:tableView indexPath:indexPath];
	
	NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:[indexPath row] inSection:0];
	
	if (fetchedResultsController == [self classPeriodsFetchedResultsController])
	{
		ClassPeriod *class = [fetchedResultsController objectAtIndexPath:adjustedIndexPath];
		
		if ([[self classPeriodsSelectionSet] containsObject:class])
		{
			[cell setAccessoryType:UITableViewCellAccessoryNone];
			[[self classPeriodsSelectionSet] removeObject:class];
			
			[[self personsSelectionSet] minusSet:[class persons]];
		}
		else
		{
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
			[[self classPeriodsSelectionSet] addObject:class];
			
			[[self personsSelectionSet] unionSet:[class persons]];
			
			[tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
		}
	}
	else
	{
		Person *person = [fetchedResultsController objectAtIndexPath:adjustedIndexPath];
		
		if ([[self personsSelectionSet] containsObject:person])
		{
			[cell setAccessoryType:UITableViewCellAccessoryNone];
			[[self personsSelectionSet] removeObject:person];
		}
		else
		{
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
			[[self personsSelectionSet] addObject:person];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
