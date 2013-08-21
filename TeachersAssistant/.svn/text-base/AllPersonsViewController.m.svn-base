//
//  AllPersonsViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/14/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "AllPersonsViewController.h"

// Models and other global

// Sub-controllers
#import "PersonActionsViewController.h"
#import "PersonInfoViewController.h"
#import "PersonFilterViewController.h"
#import "UpgradeViewController.h"

// Views

// Private Constants
#define kClearAllStudentsActionSheetTag					100
#define kAddStudentActionSheetTag						200

@interface AllPersonsViewController ()

// Private Properties
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *searchFetchedResultsController;
@property (nonatomic, retain) UIBarButtonItem *trashButton;
@property (nonatomic, retain) UIBarButtonItem *addButton;
@property (nonatomic, retain) UIBarButtonItem *upgradeButton;
@property (nonatomic, retain) UIBarButtonItem *actionButton;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic, retain) UIActionSheet *activeActionSheet;
@property (nonatomic, strong) NSMutableIndexSet *mainDeletedSectionIndexes;
@property (nonatomic, strong) NSMutableIndexSet *mainInsertedSectionIndexes;
@property (nonatomic, strong) NSMutableArray *mainDeletedRowIndexPaths;
@property (nonatomic, strong) NSMutableArray *mainInsertedRowIndexPaths;
@property (nonatomic, strong) NSMutableArray *mainUpdatedRowIndexPaths;
@property (nonatomic, strong) NSMutableIndexSet *searchDeletedSectionIndexes;
@property (nonatomic, strong) NSMutableIndexSet *searchInsertedSectionIndexes;
@property (nonatomic, strong) NSMutableArray *searchDeletedRowIndexPaths;
@property (nonatomic, strong) NSMutableArray *searchInsertedRowIndexPaths;
@property (nonatomic, strong) NSMutableArray *searchUpdatedRowIndexPaths;

// Notification Handlers


// UI Response Methods
- (void)trashButtonPressed:(UIBarButtonItem *)button;
- (void)addButtonPressed:(UIBarButtonItem *)button;
- (void)upgradeButtonPressed:(id)sender;
- (void)filterButtonPressed:(UIBarButtonItem *)button;
- (void)actionButtonPressed:(UIBarButtonItem *)button;

// Misc Methods
- (void)handleSearchForTerm:(NSString *)searchTerm;
- (void)evaluateButtonStatus;
- (void)populateToolbar;
- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView;
- (NSString *)listExport;
- (void)emailListExport;
- (void)printListExport;

@end

@implementation AllPersonsViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;

// Private
@synthesize fetchedResultsController = ivFetchedResultsController;
@synthesize searchFetchedResultsController = ivSearchFetchedResultsController;
@synthesize trashButton = ivTrashButton;
@synthesize addButton = ivAddButton;
@synthesize upgradeButton = ivUpgradeButton;
@synthesize actionButton = ivActionButton;
@synthesize savedSearchTerm = ivSavedSearchTerm;
@synthesize activeActionSheet = ivActiveActionSheet;
@synthesize mainDeletedSectionIndexes = ivMainDeletedSectionIndexes;
@synthesize mainInsertedSectionIndexes = ivMainInsertedSectionIndexes;
@synthesize mainDeletedRowIndexPaths = ivMainDeletedRowIndexPaths;
@synthesize mainInsertedRowIndexPaths = ivMainInsertedRowIndexPaths;
@synthesize mainUpdatedRowIndexPaths = ivMainUpdatedRowIndexPaths;
@synthesize searchDeletedSectionIndexes = ivSearchDeletedSectionIndexes;
@synthesize searchInsertedSectionIndexes = ivSearchInsertedSectionIndexes;
@synthesize searchDeletedRowIndexPaths = ivSearchDeletedRowIndexPaths;
@synthesize searchInsertedRowIndexPaths = ivSearchInsertedRowIndexPaths;
@synthesize searchUpdatedRowIndexPaths = ivSearchUpdatedRowIndexPaths;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	
	// Public Properties
	[self setMainTableView:nil];
	
	
	// Private Properties
    [self setFetchedResultsController:nil];
    [self setSearchFetchedResultsController:nil];
	[self setTrashButton:nil];
    [self setAddButton:nil];
    [self setUpgradeButton:nil];
	[self setActionButton:nil];
    [self setSavedSearchTerm:nil];
	[self setActiveActionSheet:nil];
	[self setMainDeletedSectionIndexes:nil];
	[self setMainInsertedSectionIndexes:nil];
	[self setMainDeletedRowIndexPaths:nil];
	[self setMainInsertedRowIndexPaths:nil];
	[self setMainUpdatedRowIndexPaths:nil];
	[self setSearchDeletedSectionIndexes:nil];
	[self setSearchInsertedSectionIndexes:nil];
	[self setSearchDeletedRowIndexPaths:nil];
	[self setSearchInsertedRowIndexPaths:nil];
	[self setSearchUpdatedRowIndexPaths:nil];

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

- (void)didReceiveMemoryWarning
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super didReceiveMemoryWarning];
	
	for (Person *person in [[self fetchedResultsController] fetchedObjects])
	{
		[[person largeThumbnailMediaInfo] setImage:nil];
		[[person smallThumbnailMediaInfo] setImage:nil];
	}
	
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
		
//		[fetchRequest setFetchBatchSize:30];
		
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
			
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"meetsFilterCriteria == %@", [NSNumber numberWithBool:YES]]];
		
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
			NSPredicate *firstNamePredicate = [NSPredicate predicateWithFormat:@"firstName CONTAINS[c] %@", [self savedSearchTerm]];
			NSPredicate *lastNamePredicate = [NSPredicate predicateWithFormat:@"lastName CONTAINS[c] %@", [self savedSearchTerm]];
			NSPredicate *detailsPredicate = [NSPredicate predicateWithFormat:@"ANY personDetailValues.name CONTAINS[c] %@", [self savedSearchTerm]];
			
			[searchFetchRequest setPredicate:[NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:firstNamePredicate, lastNamePredicate, detailsPredicate, nil]]];
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

- (NSMutableIndexSet *)mainDeletedSectionIndexes
{
	if (ivMainDeletedSectionIndexes == nil)
	{
		ivMainDeletedSectionIndexes = [[NSMutableIndexSet alloc] init];
	}
	
	return ivMainDeletedSectionIndexes;
}

- (NSMutableIndexSet *)mainInsertedSectionIndexes
{
	if (ivMainInsertedSectionIndexes == nil)
	{
		ivMainInsertedSectionIndexes = [[NSMutableIndexSet alloc] init];
	}
	
	return ivMainInsertedSectionIndexes;
}

- (NSMutableArray *)mainDeletedRowIndexPaths
{
	if (ivMainDeletedRowIndexPaths == nil)
	{
		ivMainDeletedRowIndexPaths = [[NSMutableArray alloc] init];
	}
	
	return ivMainDeletedRowIndexPaths;
}

- (NSMutableArray *)mainInsertedRowIndexPaths
{
	if (ivMainInsertedRowIndexPaths == nil)
	{
		ivMainInsertedRowIndexPaths = [[NSMutableArray alloc] init];
	}
	
	return ivMainInsertedRowIndexPaths;
}

- (NSMutableArray *)mainUpdatedRowIndexPaths
{
	if (ivMainUpdatedRowIndexPaths == nil)
	{
		ivMainUpdatedRowIndexPaths = [[NSMutableArray alloc] init];
	}
	
	return ivMainUpdatedRowIndexPaths;
}

- (NSMutableIndexSet *)searchDeletedSectionIndexes
{
	if (ivSearchDeletedSectionIndexes == nil)
	{
		ivSearchDeletedSectionIndexes = [[NSMutableIndexSet alloc] init];
	}
	
	return ivSearchDeletedSectionIndexes;
}

- (NSMutableIndexSet *)searchInsertedSectionIndexes
{
	if (ivSearchInsertedSectionIndexes == nil)
	{
		ivSearchInsertedSectionIndexes = [[NSMutableIndexSet alloc] init];
	}
	
	return ivSearchInsertedSectionIndexes;
}

- (NSMutableArray *)searchDeletedRowIndexPaths
{
	if (ivSearchDeletedRowIndexPaths == nil)
	{
		ivSearchDeletedRowIndexPaths = [[NSMutableArray alloc] init];
	}
	
	return ivSearchDeletedRowIndexPaths;
}

- (NSMutableArray *)searchInsertedRowIndexPaths
{
	if (ivSearchInsertedRowIndexPaths == nil)
	{
		ivSearchInsertedRowIndexPaths = [[NSMutableArray alloc] init];
	}
	
	return ivSearchInsertedRowIndexPaths;
}

- (NSMutableArray *)searchUpdatedRowIndexPaths
{
	if (ivSearchUpdatedRowIndexPaths == nil)
	{
		ivSearchUpdatedRowIndexPaths = [[NSMutableArray alloc] init];
	}
	
	return ivSearchUpdatedRowIndexPaths;
}

#pragma mark - Initialization and UI Creation Methods


#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidLoad];
	
	UIBarButtonItem *trash = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
																		   target:self
																		   action:@selector(trashButtonPressed:)];
	[trash setStyle:UIBarButtonItemStyleBordered];
	[self setTrashButton:trash];
	[trash release], trash = nil;
	
	UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																		 target:self
																		 action:@selector(addButtonPressed:)];
	[self setAddButton:add];
	[add release], add = nil;
	
	[[self navigationItem] setRightBarButtonItem:[self addButton]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self navigationController] setToolbarHidden:NO animated:YES];
	
	DataController *dataController = [DataController sharedDataController];
	
	[self populateToolbar];
	[self evaluateButtonStatus];
		
	[dataController filterPersons];
	
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
	
	if ([[self activeActionSheet] isVisible])
	{
		[[self activeActionSheet] dismissWithClickedButtonIndex:[[self activeActionSheet] cancelButtonIndex] animated:NO];
	}
	
	[NSObject cancelPreviousPerformRequestsWithTarget:[self mainTableView] selector:@selector(reloadData) object:nil];

	[ivSearchFetchedResultsController setDelegate:nil];
	[ivFetchedResultsController setDelegate:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidDisappear:animated];
	
	[self setSearchFetchedResultsController:nil];
	[self setFetchedResultsController:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)setEditing:(BOOL)editing
		  animated:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super setEditing:editing animated:animated];
	
	[[self mainTableView] setEditing:editing animated:animated];
	
	if (editing)
	{
		[[self navigationItem] setRightBarButtonItem:nil animated:YES];
	}
	else
	{
		[self evaluateButtonStatus];
	}
	
	[self populateToolbar];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Notification Handlers



#pragma mark - UI Response Methods

- (void)trashButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Clear All Students"
													   delegate:self
											  cancelButtonTitle:@"Cancel"
										 destructiveButtonTitle:@"Clear All"
											  otherButtonTitles:nil];
	[sheet setActionSheetStyle:UIActionSheetStyleDefault];
	[sheet setTag:kClearAllStudentsActionSheetTag];
	
	[sheet showFromToolbar:[[self navigationController] toolbar]];
	
	[sheet release], sheet = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)addButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self activeActionSheet] dismissWithClickedButtonIndex:[[self activeActionSheet] cancelButtonIndex] animated:NO];
	
	DataController *dataController = [DataController sharedDataController];
	
	NSString *personString = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Add %@", personString]
													   delegate:self
											  cancelButtonTitle:@"Cancel"
										 destructiveButtonTitle:nil
											  otherButtonTitles:@"From Contacts", @"Manually", nil];
	[sheet setTag:kAddStudentActionSheetTag];
	[self setActiveActionSheet:sheet];
	
	if ([dataController isIPadVersion])
	{
		if ( ([[self splitViewController] interfaceOrientation] == UIInterfaceOrientationLandscapeLeft) || ([[self splitViewController] interfaceOrientation] == UIInterfaceOrientationLandscapeRight) )
		{
			[sheet showFromBarButtonItem:button animated:YES];
		}
		else
		{
			[sheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
			[sheet showInView:[[self splitViewController] view]];
		}
	}
	else
	{
		[sheet showFromToolbar:[[self navigationController] toolbar]];
	}
	[sheet release], sheet = nil;
		
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

- (void)filterButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	PersonFilterViewController *nextViewController = [[PersonFilterViewController alloc] init];
	
	[[self navigationController] pushViewController:nextViewController animated:YES];
	
	[nextViewController release], nextViewController = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)actionButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self activeActionSheet] dismissWithClickedButtonIndex:[[self activeActionSheet] cancelButtonIndex] animated:NO];
	
	DataController *dataController = [DataController sharedDataController];
	
	RIButtonItem *cancelItem = nil;
	if (![dataController isIPadVersion])
	{
		cancelItem = [RIButtonItem item];
		[cancelItem setLabel:@"Cancel"];
	}
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
													 cancelButtonItem:nil
												destructiveButtonItem:nil
													 otherButtonItems:nil];
	
	if ([MFMailComposeViewController canSendMail])
	{
		RIButtonItem *emailItem = [RIButtonItem item];
		[emailItem setLabel:@"Email List"];
		[emailItem setAction:^{
			
			[self emailListExport];
			
		}];
		
		[actionSheet addButtonItem:emailItem];
	}
	
	if ([UIPrintInteractionController isPrintingAvailable])
	{
		RIButtonItem *printItem = [RIButtonItem item];
		[printItem setLabel:@"Print List"];
		[printItem setAction:^{
			
			[self printListExport];
			
		}];
		
		[actionSheet addButtonItem:printItem];
	}
	
	if (cancelItem != nil)
	{
		NSInteger cancelIndex = [actionSheet numberOfButtons];
		[actionSheet addButtonItem:cancelItem];
		[actionSheet setCancelButtonIndex:cancelIndex];
	}
	
	[self setActiveActionSheet:actionSheet];
	
	if ([dataController isIPadVersion])
	{
		if ( ([[self splitViewController] interfaceOrientation] == UIInterfaceOrientationLandscapeLeft) || ([[self splitViewController] interfaceOrientation] == UIInterfaceOrientationLandscapeRight) )
		{
			[actionSheet showFromBarButtonItem:button animated:YES];
		}
		else
		{
			[actionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
			[actionSheet showInView:[[self splitViewController] view]];
		}
	}
	else
	{
		[actionSheet showFromToolbar:[[self navigationController] toolbar]];
	}
	
	[actionSheet release], actionSheet = nil;
	
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

- (void)evaluateButtonStatus
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	DataController *dataController = [DataController sharedDataController];
	
	if ([dataController isLiteVersion])
	{
		if ([dataController countOfPersons] >= kLiteVersionMaxNumberOfStudents)
		{
			[[self navigationItem] setRightBarButtonItem:[self upgradeButton] animated:YES];
		}
		else
		{
			[[self navigationItem] setRightBarButtonItem:[self addButton] animated:YES];
		}
	}
	else
	{
		[[self navigationItem] setRightBarButtonItem:[self addButton] animated:YES];
	}
	
	// Update navigation bar title with student count
	
	NSManagedObjectContext *context = [dataController managedObjectContext];
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	[fetchRequest setEntity:[Person entityDescriptionInContextBTI:context]];
	
	NSString *people = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
	NSInteger numberOfPeople = [context countForFetchRequest:fetchRequest error:nil];
	
	[self setTitle:[NSString stringWithFormat:@"%@: %d", people, numberOfPeople]];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[self title] forKey:@"title"];
	[[NSNotificationCenter defaultCenter] postNotificationName:kSplitMasterTitleDidChangeNotification object:nil userInfo:userInfo];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)populateToolbar
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	DataController *dataController = [DataController sharedDataController];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
																 style:UIBarButtonItemStyleBordered
																target:self
																action:@selector(settingsButtonPressed:)];
	
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	
	NSString *filterTitle = @"Filter";
	
	if ( ([[[dataController filterAction] actionValues] count] > 0) || ([userDefaults pointFilterModeBTI] != BTIPointFilterModeOff) )
	{
		filterTitle = @"** Filtered **";
	}
	
	UIBarButtonItem *filter = [[UIBarButtonItem alloc] initWithTitle:filterTitle
															   style:UIBarButtonItemStyleBordered
															  target:self
															  action:@selector(filterButtonPressed:)];
	
	if ([self actionButton] == nil)
	{
		UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																					  target:self
																					  action:@selector(actionButtonPressed:)];
		[actionButton setStyle:UIBarButtonItemStyleBordered];
		[self setActionButton:actionButton];
		[actionButton release], actionButton = nil;
	}
	
	if ([dataController isLiteVersion])
	{
		UIBarButtonItem *upperUpgrade = [[UIBarButtonItem alloc] initWithTitle:@"Upgrade"
																		 style:UIBarButtonItemStyleBordered
																		target:self
																		action:@selector(upgradeButtonPressed:)];
		[self setUpgradeButton:upperUpgrade];
		[upperUpgrade release], upperUpgrade = nil;
		
		UIBarButtonItem *lowerUpgrade = [[UIBarButtonItem alloc] initWithTitle:@"Upgrade to Pro"
																		 style:UIBarButtonItemStyleBordered
																		target:self
																		action:@selector(upgradeButtonPressed:)];
		
		if ([self isEditing])
		{
			[self setToolbarItems:[NSArray arrayWithObjects:[self editButtonItem], flexItem, nil] animated:YES];
		}
		else
		{
			[self setToolbarItems:[NSArray arrayWithObjects:[self editButtonItem], flexItem, lowerUpgrade, flexItem, filter, [self actionButton], nil] animated:YES];
		}
		
		[lowerUpgrade release], lowerUpgrade = nil;
	}
	else
	{
		if ([self isEditing])
		{
			[self setToolbarItems:[NSArray arrayWithObjects:[self editButtonItem], flexItem, [self trashButton], nil] animated:YES];
		}
		else
		{
			[self setToolbarItems:[NSArray arrayWithObjects:[self editButtonItem], flexItem, filter, [self actionButton], nil] animated:YES];
		}
	}
	
	[settings release], settings = nil;
	[flexItem release], flexItem = nil;
	[filter release], filter = nil;
	
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

- (NSString *)listExport
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	DataController *dataController = [DataController sharedDataController];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSString *personPlural = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
	
	NSMutableString *stringToReturn = [[[NSMutableString alloc] init] autorelease];
	NSString *newLine = @"\n";
	
	[stringToReturn appendString:personPlural];
	[stringToReturn appendString:@":"];
	[stringToReturn appendString:newLine];
	
	for (Person *person in [[self fetchedResultsController] fetchedObjects])
	{
		NSString *personName = nil;
		
		switch ([userDefaults btiPersonDisplayMode]) {
			case BTIPersonSortModeFirstLast:
				personName = [person fullName];
				break;
			case BTIPersonSortModeLastFirst:
			{
				personName = [person reverseFullName];
			}
				break;
			default:
				break;
		}
		
		if (personName != nil)
		{
			[stringToReturn appendString:personName];
			[stringToReturn appendString:newLine];
		}
	}
	
	[stringToReturn appendString:newLine];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return stringToReturn;
}

- (void)emailListExport
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	MFMailComposeViewController *mailComposer = [[[MFMailComposeViewController alloc] init] autorelease];
	[mailComposer setMailComposeDelegate:self];
	
	[mailComposer setMessageBody:[self listExport] isHTML:NO];
	
	[self presentModalViewController:mailComposer animated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)printListExport
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
	[printController setDelegate:self];
	
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
	[printInfo setOutputType:UIPrintInfoOutputGeneral];
	[printInfo setJobName:@"Randomizer"];
	
	[printController setPrintInfo:printInfo];
	
	UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc] initWithText:[self listExport]];
	[textFormatter setStartPage:0];
	[textFormatter setContentInsets:UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0)]; // 1 inch margins
	[textFormatter setMaximumContentWidth:6 * 72.0];
	
	[printController setPrintFormatter:textFormatter];
	
	[textFormatter release], textFormatter = nil;
	
	[printController setShowsPageRange:YES];
	
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            NSLog(@"Printing could not complete because of error: %@", error);
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Print Error"
															message:@"Printing was not able to complete."
														   delegate:nil
												  cancelButtonTitle:@"Ok"
												  otherButtonTitles:nil];
			[alert show];
			[alert release], alert = nil;
        }
    };
	
	if ([[DataController sharedDataController] isIPadVersion])
	{
		[printController presentFromBarButtonItem:[self actionButton]
										 animated:YES
								completionHandler:completionHandler];
	}
	else
	{
		[printController presentAnimated:YES
					   completionHandler:completionHandler];
	}
	
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

//- (NSString *)tableView:(UITableView *)tableView
//titleForHeaderInSection:(NSInteger)section
//{
//	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
//	
//	NSString *header = nil;
//	
//	if (tableView == [self mainTableView])
//	{
//		header = [[[[self fetchedResultsControllerForTableView:tableView] sections] objectAtIndex:section] name];
//	}
//	
//	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
//	return header;
//}

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
		
		if ([dataController isIPadVersion])
        {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
        [cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
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
	
	NSMutableString *detailText = [[NSMutableString alloc] init];
	
	if ([person gradingPeriodActionTotal] == nil)
		[person calculateActionCountTotal];
	
//	[detailText appendString:[NSString stringWithFormat:@"%@: %d", [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierAction], [[person actions] count]]];
	[detailText appendString:[NSString stringWithFormat:@"%@: %d", [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierAction], [[person gradingPeriodActionTotal] integerValue]]];
	
	if ([userDefaults btiShouldShowColorPointValues])
	{
		if ([person colorLabelPointTotal] == nil)
			[person calculateColorLabelPointTotal];
		
		NSString *points = [NSNumberFormatter localizedStringFromNumber:[person colorLabelPointTotal] numberStyle:NSNumberFormatterDecimalStyle];
		[detailText appendString:[NSString stringWithFormat:@"     Points: %@", points]];
	}
	
	[[cell detailTextLabel] setText:detailText];
	
	[detailText release], detailText = nil;
	
	if ([userDefaults btiShouldShowPersonThumbnails])
	{
		[[cell imageView] setImage:[[person smallThumbnailMediaInfo] image]];
	}
	else
	{
		[[cell imageView] setImage:nil];
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
	
    DataController *dataController = [DataController sharedDataController];
    
    if ([dataController isIPadVersion])
    {
		NSLog(@"<<< Leaving %s >>> EARLY - iPad version", __PRETTY_FUNCTION__);
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

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		Person *person = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
		
		[[DataController sharedDataController] deletePerson:person];
		
		// Reload to get section index titles to update
		[[self mainTableView] performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
		[self evaluateButtonStatus];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	Person *person = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
	
	if ([tableView isEditing])
	{
		PersonInfoViewController *nextViewController = [[PersonInfoViewController alloc] init];
		[nextViewController setPerson:person];
		
		[[self navigationController] pushViewController:nextViewController animated:YES];
		
		[nextViewController release], nextViewController = nil;
	}
	else
	{
		PersonActionsViewController *nextViewController = [[PersonActionsViewController alloc] init];
		[nextViewController setPerson:person];
		
		[[self navigationController] pushViewController:nextViewController animated:YES];
		
		[nextViewController release], nextViewController = nil;
		
		NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:person, kNotificationPersonObjectKey, nil];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kShouldShowStudentDetailViewNotification object:dictionary];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


#pragma mark - NSFetchedResultsController Delegate Methods

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
	NSLog(@">>> Entering <%p> %s <<<", self, __PRETTY_FUNCTION__);
	
	NSInteger section = [indexPath section];
	NSInteger newSection = [newIndexPath section];
	
	if (controller == [self fetchedResultsController])
	{
		if (type == NSFetchedResultsChangeInsert)
		{
			if ([[self mainInsertedSectionIndexes] containsIndex:newSection])
			{
				// If we've already been told that we're adding a section for this inserted row we skip it since it will handled by the section insertion.
				return;
			}
			
			[[self mainInsertedRowIndexPaths] addObject:newIndexPath];
		}
		else if (type == NSFetchedResultsChangeDelete)
		{
			if ([[self mainDeletedSectionIndexes] containsIndex:section])
			{
				// If we've already been told that we're deleting a section for this deleted row we skip it since it will handled by the section deletion.
				return;
			}
			
			[[self mainDeletedRowIndexPaths] addObject:indexPath];
		}
		else if (type == NSFetchedResultsChangeMove)
		{
			if ([[self mainInsertedSectionIndexes] containsIndex:newSection] == NO)
			{
				[[self mainInsertedRowIndexPaths] addObject:newIndexPath];
			}
			
			if ([[self mainDeletedSectionIndexes] containsIndex:indexPath.section] == NO)
			{
				[[self mainDeletedRowIndexPaths] addObject:indexPath];
			}
		}
		else if (type == NSFetchedResultsChangeUpdate)
		{
			[[self mainUpdatedRowIndexPaths] addObject:indexPath];
		}
	}
	else
	{
		if (type == NSFetchedResultsChangeInsert)
		{
			if ([[self searchInsertedSectionIndexes] containsIndex:newSection])
			{
				// If we've already been told that we're adding a section for this inserted row we skip it since it will handled by the section insertion.
				return;
			}
			
			[[self searchInsertedRowIndexPaths] addObject:newIndexPath];
		}
		else if (type == NSFetchedResultsChangeDelete)
		{
			if ([[self searchDeletedSectionIndexes] containsIndex:section])
			{
				// If we've already been told that we're deleting a section for this deleted row we skip it since it will handled by the section deletion.
				return;
			}
			
			[[self searchDeletedRowIndexPaths] addObject:indexPath];
		}
		else if (type == NSFetchedResultsChangeMove)
		{
			if ([[self searchInsertedSectionIndexes] containsIndex:newSection] == NO)
			{
				[[self searchInsertedRowIndexPaths] addObject:newIndexPath];
			}
			
			if ([[self searchDeletedSectionIndexes] containsIndex:indexPath.section] == NO)
			{
				[[self searchDeletedRowIndexPaths] addObject:indexPath];
			}
		}
		else if (type == NSFetchedResultsChangeUpdate)
		{
			[[self searchUpdatedRowIndexPaths] addObject:indexPath];
		}
	}
	
	NSLog(@"<<< Leaving  <%p> %s >>>", self, __PRETTY_FUNCTION__);
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id )sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
	NSLog(@">>> Entering <%p> %s <<<", self, __PRETTY_FUNCTION__);
	
	if (controller == [self fetchedResultsController])
	{
		if (type == NSFetchedResultsChangeInsert)
		{
			[[self mainInsertedSectionIndexes] addIndex:sectionIndex];
		}
		else if (type == NSFetchedResultsChangeDelete)
		{
			[[self mainDeletedSectionIndexes] addIndex:sectionIndex];
		}
	}
	else
	{
		if (type == NSFetchedResultsChangeInsert)
		{
			[[self searchInsertedSectionIndexes] addIndex:sectionIndex];
		}
		else if (type == NSFetchedResultsChangeDelete)
		{
			[[self searchDeletedSectionIndexes] addIndex:sectionIndex];
		}
	}
	
	NSLog(@"<<< Leaving  <%p> %s >>>", self, __PRETTY_FUNCTION__);
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	NSLog(@">>> Entering <%p> %s <<<", self, __PRETTY_FUNCTION__);
	
	if (controller == [self fetchedResultsController])
	{
		UITableView *tableView = [self mainTableView];
		
		NSInteger totalChanges = [[self mainDeletedSectionIndexes] count] + [[self mainInsertedSectionIndexes] count] + [[self mainDeletedRowIndexPaths] count] + [[self mainInsertedRowIndexPaths] count] + [[self mainUpdatedRowIndexPaths] count];
		
		if (totalChanges > 50)
		{
			[self setMainInsertedSectionIndexes:nil];
			[self setMainDeletedSectionIndexes:nil];
			[self setMainDeletedRowIndexPaths:nil];
			[self setMainInsertedRowIndexPaths:nil];
			[self setMainUpdatedRowIndexPaths:nil];
			
			[tableView reloadData];
			
			NSLog(@"<<< Leaving  <%p> %s >>> EARLY - Bulk changes", self, __PRETTY_FUNCTION__);
			return;
		}
		
		[tableView beginUpdates];
		
		[tableView deleteSections:[self mainDeletedSectionIndexes] withRowAnimation:UITableViewRowAnimationLeft];
		[tableView insertSections:[self mainInsertedSectionIndexes] withRowAnimation:UITableViewRowAnimationRight];
		
		[tableView deleteRowsAtIndexPaths:[self mainDeletedRowIndexPaths] withRowAnimation:UITableViewRowAnimationLeft];
		[tableView insertRowsAtIndexPaths:[self mainInsertedRowIndexPaths] withRowAnimation:UITableViewRowAnimationRight];
		[tableView reloadRowsAtIndexPaths:[self mainUpdatedRowIndexPaths] withRowAnimation:UITableViewRowAnimationNone];
		
		[tableView endUpdates];
		
		[self setMainInsertedSectionIndexes:nil];
		[self setMainDeletedSectionIndexes:nil];
		[self setMainDeletedRowIndexPaths:nil];
		[self setMainInsertedRowIndexPaths:nil];
		[self setMainUpdatedRowIndexPaths:nil];
	}
	else
	{
		UITableView *tableView = [[self searchDisplayController] searchResultsTableView];
		
		NSInteger totalChanges = [[self searchDeletedSectionIndexes] count] + [[self searchInsertedSectionIndexes] count] + [[self searchDeletedRowIndexPaths] count] + [[self searchInsertedRowIndexPaths] count] + [[self searchUpdatedRowIndexPaths] count];
		
		if (totalChanges > 50)
		{
			[self setSearchInsertedSectionIndexes:nil];
			[self setSearchDeletedSectionIndexes:nil];
			[self setSearchDeletedRowIndexPaths:nil];
			[self setSearchInsertedRowIndexPaths:nil];
			[self setSearchUpdatedRowIndexPaths:nil];
			
			[tableView reloadData];
			
			NSLog(@"<<< Leaving  <%p> %s >>> EARLY - Bulk changes", self, __PRETTY_FUNCTION__);
			return;
		}
		
		[tableView beginUpdates];
		
		[tableView deleteSections:[self searchDeletedSectionIndexes] withRowAnimation:UITableViewRowAnimationLeft];
		[tableView insertSections:[self searchInsertedSectionIndexes] withRowAnimation:UITableViewRowAnimationRight];
		
		[tableView deleteRowsAtIndexPaths:[self searchDeletedRowIndexPaths] withRowAnimation:UITableViewRowAnimationLeft];
		[tableView insertRowsAtIndexPaths:[self searchInsertedRowIndexPaths] withRowAnimation:UITableViewRowAnimationRight];
		[tableView reloadRowsAtIndexPaths:[self searchUpdatedRowIndexPaths] withRowAnimation:UITableViewRowAnimationNone];
		
		[tableView endUpdates];
		
		[self setSearchInsertedSectionIndexes:nil];
		[self setSearchDeletedSectionIndexes:nil];
		[self setSearchDeletedRowIndexPaths:nil];
		[self setSearchInsertedRowIndexPaths:nil];
		[self setSearchUpdatedRowIndexPaths:nil];
	}
	
	NSLog(@"<<< Leaving  <%p> %s >>>", self, __PRETTY_FUNCTION__);
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

#pragma mark -
#pragma mark UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (buttonIndex != [actionSheet cancelButtonIndex])
	{
		if ([actionSheet tag] == kClearAllStudentsActionSheetTag)
		{
			if (buttonIndex == 0)
			{
				[[DataController sharedDataController] deleteAllPersons];
				
				[self setEditing:NO animated:YES];
				
				[[self mainTableView] performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
			} 
			else if (buttonIndex == 1)
			{
			}
		}
		else if ([actionSheet tag] == kAddStudentActionSheetTag)
		{
			NSLog(@"buttonIndex is: %d", buttonIndex);
			switch (buttonIndex) {
				case 0:		// Address Book
				{
					ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
					[peoplePicker setPeoplePickerDelegate:self];
					
					if ([[DataController sharedDataController] isIPadVersion])
					{
						[[self splitViewController] presentModalViewController:peoplePicker animated:YES];
						
						[[NSNotificationCenter defaultCenter] postNotificationName:kShouldHideMasterViewControllerNotification object:nil];
					}
					else
					{
						[self presentModalViewController:peoplePicker animated:YES];
					}
					
					[peoplePicker release], peoplePicker = nil;
				}	
					break;
				case 1:		// Manually
				{
					PersonInfoViewController *nextViewController = [[PersonInfoViewController alloc] init];
					
					[[self navigationController] pushViewController:nextViewController animated:YES];
					
					[nextViewController release], nextViewController = nil;
				}	
					break;	
				default:
					break;
			}
		}
	}
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate Methods

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [self dismissModalViewControllerAnimated:YES];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kShouldShowMasterViewControllerNotification object:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	CFStringRef firstNameRef = ABRecordCopyValue(person, kABPersonFirstNameProperty);
	CFStringRef lastNameRef = ABRecordCopyValue(person, kABPersonLastNameProperty);
	
	DataController *dataController = [DataController sharedDataController];
	NSManagedObjectContext *context = [dataController managedObjectContext];
	
	Person *aPerson = [Person managedObjectInContextBTI:context];
	[aPerson setFirstName:[(NSString *)firstNameRef stringByRemovingNull]];
	[aPerson setLastName:[(NSString *)lastNameRef stringByRemovingNull]];
	
	Parent *parent = [dataController makeParentInContext:context
								   fromAddressBookPerson:person
											withFullName:NO];
	
	[parent setStudent:aPerson];
	
	if (ABPersonHasImageData(person))
	{
		CFDataRef imageDataRef = ABPersonCopyImageData(person);
		UIImage *originalImage = [UIImage imageWithData:(NSData *)imageDataRef];
		UIImage *largeImage = [dataController largePersonThumbnailImageFromImage:originalImage];
		UIImage *smallImage = [dataController smallPersonThumbnailImageFromImage:largeImage];
		
		MediaInfo *largeMediaInfo = [MediaInfo managedObjectInContextBTI:context];
		[largeMediaInfo setType:[NSNumber numberWithInt:BTIMediaTypeImage]];
		[largeMediaInfo setImage:largeImage];
		
		MediaInfo *smallMediaInfo = [MediaInfo managedObjectInContextBTI:context];
		[smallMediaInfo setType:[NSNumber numberWithInt:BTIMediaTypeImage]];
		[smallMediaInfo setImage:smallImage];
		
		[dataController addFileForMediaInfo:largeMediaInfo];
		[dataController addFileForMediaInfo:smallMediaInfo];
		
		[aPerson setLargeThumbnailMediaInfo:largeMediaInfo];
		[aPerson setSmallThumbnailMediaInfo:smallMediaInfo];
				
		// Releasing a NULL object - which can happen if there is no data in the field - causes a crash
		if (imageDataRef != NULL)
			CFRelease(imageDataRef);
	}
	
	[dataController saveCoreDataContext];
	
	// Releasing a NULL object - which can happen if there is no data in the field - causes a crash
	if (firstNameRef != NULL)
		CFRelease(firstNameRef);
	if (lastNameRef != NULL)
		CFRelease(lastNameRef);
	
	[self dismissModalViewControllerAnimated:NO];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kShouldShowMasterViewControllerNotification object:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
    return NO;
}

#pragma mark - MFMailComposeViewControllerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError *)error
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
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
