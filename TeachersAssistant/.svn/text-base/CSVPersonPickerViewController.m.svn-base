//
//  CSVPersonPickerViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 3/4/12.
//  Copyright 2012 BriTer Ideas LLC. All rights reserved.
//

#import "CSVPersonPickerViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface CSVPersonPickerViewController ()

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
- (void)generateDemographicEmail;
- (void)generateActionEmail;

@end

@implementation CSVPersonPickerViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize exportMode = ivExportMode;
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

	switch ([self exportMode]) {
		case BTICSVExportModeDemographics:
			[self generateDemographicEmail];
			break;
		case BTICSVExportModeActions:
			[self generateActionEmail];
			break;
		default:
			break;
	}
	
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

- (void)generateDemographicEmail
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	DataController *dataController = [DataController sharedDataController];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSManagedObjectContext *context = [dataController managedObjectContext];
	
	NSString *personText = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
	NSString *parentText = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierParent];
	NSString *classText = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierClass];
//	NSString *otherText = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierOther];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity:[PersonDetailInfo entityDescriptionInContextBTI:context]];
	[fetchRequest setSortDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
	
	NSArray *personDetailInfos = [context executeFetchRequest:fetchRequest error:nil];
	
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
	
	NSMutableArray *lines = [NSMutableArray array];
	NSString *comma = @",";
	NSString *semicolon = @";";
	NSInteger maxNumberOfParents = 0;
	
	for (Person *person in sortedPersons)
	{
		NSMutableString *line = [[NSMutableString alloc] init];
		
		// First name
		NSString *firstName = [person firstName];
		if (firstName != nil)
		{
			[line appendString:firstName];
		}
		[line appendString:comma];
		
		// Last name
		NSString *lastName = [person lastName];
		if (lastName != nil)
		{
			[line appendString:lastName];
		}
		[line appendString:comma];
		
		// Class Name
		NSArray *sortedClasses = [[person classPeriods] sortedArrayUsingDescriptors:[dataController descriptorArrayForNameAlphabeticSort]];
		NSMutableArray *sortedClassNames = [NSMutableArray arrayWithArray:[sortedClasses valueForKeyPath:@"name"]];
		[sortedClassNames removeObject:kAllStudentsClassName];
		[line appendString:[sortedClassNames componentsJoinedByString:semicolon]];
		
		// Additional details
		for (PersonDetailInfo *detailInfo in personDetailInfos)
		{
			[line appendString:comma];
			
			PersonDetailValue *detailValue = [person detailValueForPersonDetailInfo:detailInfo];
			// Format on purpose to avoid problem with nil.  (null) cleaner will fix it later
			[line appendFormat:@"%@", [detailValue name]];
		}
		
		// Other
//		NSString *other = [person other];
//		if (other != nil)
//		{
//			[line appendString:other];
//		}
		
		
//		[line appendString:comma];		// Omit final comma.  Parent loop will provide if necessary.
		
		// Parents
		NSArray *sortedParents = [[person parents] sortedArrayUsingDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
		
		NSInteger numberOfParents = [sortedParents count];
		if (numberOfParents > maxNumberOfParents)
			maxNumberOfParents = numberOfParents;
		
		for (Parent *parent in sortedParents)
		{
			[line appendString:comma];
			
			// Parent name
			NSString *parentName = [parent name];
			if (parentName != nil)
			{
				[line appendString:parentName];
			}
			[line appendString:comma];
			
			// Phone number
			NSArray *sortedPhones = [[parent phoneNumbers] sortedArrayUsingDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
			if ([sortedPhones count] > 0)
			{
				PhoneNumber *phoneNumber = [sortedPhones objectAtIndex:0];
				[line appendString:[phoneNumber value]];
			}
			[line appendString:comma];
			
			// Email
			NSArray *sortedEmails = [[parent emailAddresses] sortedArrayUsingDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
			if ([sortedEmails count] > 0)
			{
				EmailAddress *emailAddress = [sortedEmails objectAtIndex:0];
				[line appendString:[emailAddress value]];
			}
//			[line appendString:comma];		// Omitting final comma
		}
		
		[line replaceOccurrencesOfString:@"(null)" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [line length])];
		
		[lines addObject:line];
		NSLog(@"line is:\n%@\n", line);
		[line release], line = nil;
	}
	
	// Header row
	NSMutableString *header = [NSMutableString string];
	[header appendString:[NSString stringWithFormat:@"%@ First Name", personText]];
	[header appendString:comma];
	[header appendString:[NSString stringWithFormat:@"%@ Last Name", personText]];
	[header appendString:comma];
	[header appendString:[NSString stringWithFormat:@"%@ Name", classText]];
//	[header appendString:comma];
//	[header appendString:otherText];
	for (PersonDetailInfo *detailInfo in personDetailInfos)
	{
		[header appendString:comma];
		// Format on purpose to avoid problem with nil.  (null) cleaner will fix it later
		[header appendFormat:@"%@", [detailInfo name]];
	}
	
	// Omit comma if this is final.  Parent loop will add if needed
	
	for (int i = 1; i <= maxNumberOfParents; i++)
	{
		NSLog(@"Adding parent header");
		[header appendString:comma];
		[header appendString:[NSString stringWithFormat:@"%@ %d Name", parentText, i]];
		[header appendString:comma];
		[header appendString:[NSString stringWithFormat:@"%@ %d Phone", parentText, i]];
		[header appendString:comma];
		[header appendString:[NSString stringWithFormat:@"%@ %d Email", parentText, i]];
	}
	
	[header replaceOccurrencesOfString:@"(null)" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [header length])];
	
	[lines insertObject:header atIndex:0];
	
	NSLog(@"lines is:\n %@", lines);
	
	NSString *csvContents = [lines componentsJoinedByString:@"\n"];
	NSLog(@"csvContents is:\n %@", csvContents);
	
	NSData *file = [csvContents dataUsingEncoding:NSUTF8StringEncoding];
	
	NSString *subject = @"Teacher's Assistant Demographic Export";
	
	MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
	[mailComposer setMailComposeDelegate:self];
	
	[mailComposer setSubject:subject];
//	[mailComposer setMessageBody:messageBody isHTML:NO];
	
	[mailComposer addAttachmentData:file
							 mimeType:@"text/csv"
							 fileName:@"TAP_CSV_Demographics.csv"];
	
	[self presentModalViewController:mailComposer animated:YES];


	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)generateActionEmail
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	DataController *dataController = [DataController sharedDataController];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSManagedObjectContext *context = [dataController managedObjectContext];
	
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
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity:[ActionFieldInfo entityDescriptionInContextBTI:context]];
	[fetchRequest setSortDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(isHidden == %@) AND (type != %@) AND (type != %@) AND (type != %@)", [NSNumber numberWithBool:NO], [NSNumber numberWithInt:BTIActionFieldValueTypeAudio], [NSNumber numberWithInt:BTIActionFieldValueTypeImage], [NSNumber numberWithInt:BTIActionFieldValueTypeVideo]]];
	
	NSArray *sortedFieldInfos = [[dataController managedObjectContext] executeFetchRequest:fetchRequest error:nil];
	
	NSMutableArray *lines = [NSMutableArray array];
	NSString *comma = @",";
	NSString *semicolon = @";";
	
	// Header
	NSMutableString *header = [[NSMutableString alloc] init];
	[header appendString:@"First Name"];
	[header appendString:comma];
	[header appendString:@"Last Name"];
	// Field Info loop will handle last comma
	
	for (ActionFieldInfo *actionFieldInfo in sortedFieldInfos)
	{
		[header appendString:comma];
		
		TermInfo *termInfo = [actionFieldInfo termInfo];
		NSString *plural = [dataController pluralNameForTermInfo:termInfo];
		if (plural == nil)
		{
			NSString *singular = [dataController singularNameForTermInfo:termInfo];
			if (singular != nil)
			{
				[header appendString:singular];
			}
		}
		else
		{
			[header appendString:plural];
		}
	}
	
	{{
		[header appendString:comma];
		[header appendString:@"Points"];
	}}
	
	[lines addObject:header];
	
	[header release], header = nil;
	
	// Actions
	
	NSSortDescriptor *dateDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"defaultSortDate" ascending:[userDefaults isActionsSortAscendingBTI]] autorelease];
	
	for (Person *person in sortedPersons)
	{
		NSArray *sortedActions = [[person actions] sortedArrayUsingDescriptors:[NSArray arrayWithObject:dateDescriptor]];
		
		for (Action *action in sortedActions)
		{
			NSMutableString *line = [[NSMutableString alloc] init];
			
			NSString *firstName = [person firstName];
			if (firstName != nil)
				[line appendString:firstName];
			
			[line appendString:comma];
			
			NSString *lastName = [person lastName];
			if (lastName != nil)
				[line appendString:lastName];
			
			for (ActionFieldInfo *actionFieldInfo in sortedFieldInfos)
			{
				[line appendString:comma];
				
				ActionValue *actionValue = [action actionValueForActionFieldInfo:actionFieldInfo];
				NSString *emailString = [actionValue labelText];
				NSString *csvString = [emailString stringByReplacingOccurrencesOfString:comma withString:semicolon];
				
				if (csvString != nil)
				{
					[line appendString:csvString];
				}
			}
			
			{{
				[line appendString:comma];
				[line appendFormat:@"%@", [action colorLabelPointValue]];
			}}
			
			[line replaceOccurrencesOfString:@"(null)" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [line length])];
			[line replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [line length])];
			
			[lines addObject:line];
			
			[line release], line = nil;
		}
	}
	
	NSLog(@"lines is: %@", lines);
	
	NSString *csvContents = [lines componentsJoinedByString:@"\n"];
	
	NSData *file = [csvContents dataUsingEncoding:NSUTF8StringEncoding];
	
	NSString *actionText = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierAction];
	
	NSString *subject = [NSString stringWithFormat:@"Teacher's Assistant %@ Export", actionText];
	
	MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
	[mailComposer setMailComposeDelegate:self];
	
	[mailComposer setSubject:subject];
	//	[mailComposer setMessageBody:messageBody isHTML:NO];
	
	[mailComposer addAttachmentData:file
						   mimeType:@"text/csv"
						   fileName:@"TAP_CSV_Actions.csv"];
	
	[self presentModalViewController:mailComposer animated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
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

