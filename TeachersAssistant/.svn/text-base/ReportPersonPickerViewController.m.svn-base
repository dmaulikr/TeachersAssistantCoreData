//
//  ReportPersonPickerViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 2/1/12.
//  Copyright 2012 BriTer Ideas LLC. All rights reserved.
//

#import "ReportPersonPickerViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface ReportPersonPickerViewController ()

// Private Properties
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *searchFetchedResultsController;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic, retain) NSMutableSet *selectionSet;

// Notification Handlers



// UI Response Methods
- (void)emailButtonPressed:(UIBarButtonItem *)button;
- (void)allButtonPressed:(UIBarButtonItem *)button;
- (void)noneButtonPressed:(UIBarButtonItem *)button;


// Misc Methods
- (void)handleSearchForTerm:(NSString *)searchTerm;
- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView;

@end

@implementation ReportPersonPickerViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize reportMode = ivReportMode;
@synthesize gradingPeriod = ivGradingPeriod;
@synthesize classPeriod = ivClassPeriod;


// Private
@synthesize fetchedResultsController = ivFetchedResultsController;
@synthesize searchFetchedResultsController = ivSearchFetchedResultsController;
@synthesize savedSearchTerm = ivSavedSearchTerm;
@synthesize selectionSet = ivSelectionSet;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
    [self setMainTableView:nil];
    [self setGradingPeriod:nil];
    [self setClassPeriod:nil];
	
	
	// Private Properties
	[self setFetchedResultsController:nil];
    [self setSearchFetchedResultsController:nil];
    [self setSavedSearchTerm:nil];
    [self setSelectionSet:nil];
	
	
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
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		NSManagedObjectContext *context = [dataController managedObjectContext];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		[fetchRequest setEntity:[Person entityDescriptionInContextBTI:context]];
		
		NSString *sectionNameKeyPath = nil;
		
		switch ([userDefaults btiPersonSortMode]) {
			case BTIPersonSortModeFirstLast:
			{
				[fetchRequest setSortDescriptors:[dataController descriptorArrayForFirstNameAlphabeticSort]];
				sectionNameKeyPath = kFIRST_LETTER_OF_FIRST_NAME;
			}
				break;
			case BTIPersonSortModeLastFirst:
			{
				[fetchRequest setSortDescriptors:[dataController descriptorArrayForLastNameAlphabeticSort]];
				sectionNameKeyPath = kFIRST_LETTER_OF_LAST_NAME;
			}
				break;
			default:
				break;
		}
		
		if ([self classPeriod] != nil)
		{
			[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"ANY classPeriods == %@", [self classPeriod]]];
		}
		
		ivFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																		 managedObjectContext:context
																		   sectionNameKeyPath:sectionNameKeyPath
																					cacheName:nil];
		
		[ivFetchedResultsController setDelegate:self];
		
		[ivFetchedResultsController performFetchBTI];
		
		[fetchRequest release], fetchRequest = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivFetchedResultsController;
}

- (NSFetchedResultsController *)searchFetchedResultsController
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivSearchFetchedResultsController == nil)
	{
		DataController *dataController = [DataController sharedDataController];
		NSManagedObjectContext *context = [dataController managedObjectContext];
		
		NSFetchRequest *mainFetchRequest = [[self fetchedResultsController] fetchRequest];
		NSFetchRequest *searchFetchRequest = [[NSFetchRequest alloc] init];
		
		[searchFetchRequest setEntity:[mainFetchRequest entity]];
		[searchFetchRequest setSortDescriptors:[mainFetchRequest sortDescriptors]];
		
		if ([self savedSearchTerm] != nil)
		{
			NSMutableArray *predicates = [NSMutableArray array];
			if ([mainFetchRequest predicate] != nil)
			{
				[predicates addObject:[mainFetchRequest predicate]];
			}

			NSPredicate *firstNamePredicate = [NSPredicate predicateWithFormat:@"firstName CONTAINS[c] %@", [self savedSearchTerm]];
			NSPredicate *lastNamePredicate = [NSPredicate predicateWithFormat:@"lastName CONTAINS[c] %@", [self savedSearchTerm]];
			NSPredicate *detailsPredicate = [NSPredicate predicateWithFormat:@"ANY personDetailValues.name CONTAINS[c] %@", [self savedSearchTerm]];
			
			[predicates addObject:[NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:firstNamePredicate, lastNamePredicate, detailsPredicate, nil]]];
			
//			NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"(firstName CONTAINS[c] %@) OR (lastName CONTAINS[c] %@) OR (other CONTAINS[c] %@)", [self savedSearchTerm], [self savedSearchTerm], [self savedSearchTerm]];
//			[predicates addObject:searchPredicate];
			
			[searchFetchRequest setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:predicates]];
		}
		
		ivSearchFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:searchFetchRequest
																			   managedObjectContext:context
																				 sectionNameKeyPath:nil
																						  cacheName:nil];
		[ivSearchFetchedResultsController setDelegate:self];
		[ivSearchFetchedResultsController performFetchBTI];
		
		[searchFetchRequest release], searchFetchRequest = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivSearchFetchedResultsController;
}

- (NSMutableSet *)selectionSet
{
	if (ivSelectionSet == nil)
	{
		ivSelectionSet = [[NSMutableSet alloc] init];
	}
	return ivSelectionSet;
}


#pragma mark - Initialization and UI Creation Methods


#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:[NSString stringWithFormat:@"Select %@", [[DataController sharedDataController] pluralNameForTermInfoIndentifier:kTermInfoIdentifierPerson]]];
	
	UIBarButtonItem *assign = [[UIBarButtonItem alloc] initWithTitle:@"Email"
															   style:UIBarButtonItemStyleBordered
															  target:self
															  action:@selector(emailButtonPressed:)];
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

- (void)emailButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	DataController *dataController = [DataController sharedDataController];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSString *person = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
	
	NSArray *sortedPersons = nil;
	switch ([userDefaults btiPersonSortMode]) {
		case BTIPersonSortModeFirstLast:
		{
			sortedPersons = [[self selectionSet] sortedArrayUsingDescriptors:[dataController descriptorArrayForFirstNameAlphabeticSort]];
		}
			break;
		case BTIPersonSortModeLastFirst:
		{
			sortedPersons = [[self selectionSet] sortedArrayUsingDescriptors:[dataController descriptorArrayForLastNameAlphabeticSort]];
		}
			break;
		default:
			break;
	}
	
	NSMutableString *messageBody = [NSMutableString string];
	
	for (Person *person in sortedPersons)
	{
//		NSString *summary = [person summaryStringForEmail];
		NSString *summary = [person summaryStringForReportEmailInGradingPeriod:[self gradingPeriod] reportMode:[self reportMode]];
		
		switch ([self reportMode]) {
			case BTIReportModeAllPersons:
			{
				[messageBody appendString:@"\n\n"];
				[messageBody appendString:summary];
				[messageBody appendString:@"\n\n"];
			}
				break;
			case BTIReportModePersonsWithActions:
			{
				
				if ([summary length] > 0)
				{
					[messageBody appendString:@"\n\n"];
					[messageBody appendString:summary];
					[messageBody appendString:@"\n\n"];
				}
			}
				break;
			default:
				break;
		}
		
	}
	
	NSString *subject = [NSString stringWithFormat:@"Teacher's Assistant %@ Report", person];
	
	MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
	[mailComposer setMailComposeDelegate:self];
	
	[mailComposer setSubject:subject];
	[mailComposer setMessageBody:messageBody isHTML:NO];
	
	[self presentModalViewController:mailComposer animated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)allButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self selectionSet] removeAllObjects];
	
	[[self selectionSet] addObjectsFromArray:[[self fetchedResultsController] fetchedObjects]];
	
	[[self mainTableView] reloadData];
	[[[self searchDisplayController] searchResultsTableView] reloadData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)noneButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self selectionSet] removeAllObjects];
	
	[[self mainTableView] reloadData];
	[[[self searchDisplayController] searchResultsTableView] reloadData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


#pragma mark - Misc Methods

- (void)handleSearchForTerm:(NSString *)searchTerm
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self setSavedSearchTerm:searchTerm];
	
	[self setSearchFetchedResultsController:nil];
	
	[self searchFetchedResultsController];
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSFetchedResultsController *controllerToReturn = nil;
	
	if (tableView == [self mainTableView])
	{
		controllerToReturn = [self fetchedResultsController];
	}
	else
	{
		controllerToReturn = [self searchFetchedResultsController];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return controllerToReturn;
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger sections = [[[self fetchedResultsControllerForTableView:tableView] sections] count];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return sections;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsControllerForTableView:tableView] sections] objectAtIndex:section];
	
	NSInteger rows = [sectionInfo numberOfObjects];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	DataController *dataController = [DataController sharedDataController];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	Person *person = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
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
	
	[cell setAccessoryType:([[self selectionSet] containsObject:person]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
	
	if ([userDefaults btiShouldShowPersonThumbnails])
	{
		[[cell imageView] setImage:[[person smallThumbnailMediaInfo] image]];
	}
	else
	{
		[[cell imageView] setImage:nil];
	}
	
	if ([dataController isLiteVersion])
	{
		if ([[person actions] count] >= kLiteVersionMaxNumberOfActions)
		{
			[[cell textLabel] setTextColor:[UIColor grayColor]];
			[cell setAccessoryType:UITableViewCellAccessoryNone];
		}
		else
		{
			[[cell textLabel] setTextColor:[UIColor blackColor]];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (tableView == [[self searchDisplayController] searchResultsTableView])
	{
		NSLog(@"<<< Leaving %s >>> EARLY - Search Table", __PRETTY_FUNCTION__);
		return nil;
	}
    
	NSMutableArray *indexArray = nil;
	
	if (tableView != [[self searchDisplayController] searchResultsTableView])
	{
		indexArray = [[[NSMutableArray alloc] init] autorelease];
		[indexArray addObject:UITableViewIndexSearch];
		[indexArray addObjectsFromArray:[[self fetchedResultsControllerForTableView:tableView] sectionIndexTitles]];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return indexArray;
}

- (NSInteger)tableView:(UITableView *)tableView 
sectionForSectionIndexTitle:(NSString *)title 
			   atIndex:(NSInteger)index 
{
	NSLog(@"Clicked index: %d", index);
	if (index == 0) 
	{
		[tableView scrollRectToVisible:[[tableView tableHeaderView] bounds] animated:NO];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return index-1;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	Person *person = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	if ([[self selectionSet] containsObject:person])
	{
		[cell setAccessoryType:UITableViewCellAccessoryNone];
		[[self selectionSet] removeObject:person];
	}
	else
	{
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
		[[self selectionSet] addObject:person];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	UITableView *tableView = nil;
	
	if (controller == [self fetchedResultsController])
		tableView = [self mainTableView];
	else
		tableView = [[self searchDisplayController] searchResultsTableView];
	
	[tableView beginUpdates];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	UITableView *tableView = nil;
	
	if (controller == [self fetchedResultsController])
		tableView = [self mainTableView];
	else
		tableView = [[self searchDisplayController] searchResultsTableView];
	
	[tableView endUpdates];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	UITableView *tableView = nil;
	
	if (controller == [self fetchedResultsController])
		tableView = [self mainTableView];
	else
		tableView = [[self searchDisplayController] searchResultsTableView];
	
	switch (type)
	{
		case NSFetchedResultsChangeInsert:
			NSLog(@"insert");
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			NSLog(@"delete");
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate:
			NSLog(@"update");
			//			[self configureCell:(CategoryCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
		case NSFetchedResultsChangeMove:
			NSLog(@"move");
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
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
	
	UITableView *tableView = nil;
	
	if (controller == [self fetchedResultsController])
		tableView = [self mainTableView];
	else
		tableView = [[self searchDisplayController] searchResultsTableView];
	
	switch (type)
	{
		case NSFetchedResultsChangeInsert:
			NSLog(@"insert");
			[tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			NSLog(@"delete");
			[tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		default:
			NSLog(@"There was some other option!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UISearchDisplayController Delegate Methods

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self mainTableView] reloadData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self setSearchFetchedResultsController:nil];
	
	[self handleSearchForTerm:searchString];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller
 willShowSearchResultsTableView:(UITableView *)tableView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[tableView setEditing:[self isEditing]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self setSavedSearchTerm:nil];
	
	[self setSearchFetchedResultsController:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - MFMailComposeViewControllerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController*)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError*)error
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self dismissModalViewControllerAnimated:YES];
	
	if (result == MFMailComposeResultFailed)
	{
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can not send mail"
														message:@"Sorry, we were unable to send the email."
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release], alert = nil;
	}
	
	[controller release], controller = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
