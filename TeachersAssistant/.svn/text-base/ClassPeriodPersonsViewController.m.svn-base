//
//  ClassPeriodPersonsViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/21/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ClassPeriodPersonsViewController.h"

// Models and other global

// Sub-controllers
#import "PersonActionsViewController.h"
#import "PersonInfoViewController.h"
#import "ClassPeriodPersonPickerViewController.h"
#import "PersonFilterViewController.h"

// Views

// Private Constants


@interface ClassPeriodPersonsViewController ()

// Private Properties
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) UIBarButtonItem *studentsButton;
@property (nonatomic, retain) UIBarButtonItem *actionButton;
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
- (void)addButtonPressed:(UIBarButtonItem *)button;
- (void)filterButtonPressed:(UIBarButtonItem *)button;
- (void)actionButtonPressed:(UIBarButtonItem *)button;

// Misc Methods
- (void)populateToolbar;
- (NSString *)listExport;
- (void)emailListExport;
- (void)printListExport;

@end

@implementation ClassPeriodPersonsViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize classPeriod = ivClassPeriod;

// Private
@synthesize fetchedResultsController = ivFetchedResultsController;
@synthesize studentsButton = ivStudentsButton;
@synthesize actionButton = ivActionButton;
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
	[self setClassPeriod:nil];
	
	// Private Properties
	[self setFetchedResultsController:nil];
	[self setStudentsButton:nil];
	[self setActionButton:nil];
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
		
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(ANY classPeriods == %@) AND (meetsFilterCriteria == %@)", [self classPeriod], [NSNumber numberWithBool:YES]]];
		
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
	
	[self setTitle:[[self classPeriod] name]];
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																			   target:self
																			   action:@selector(addButtonPressed:)];
	[[self navigationItem] setRightBarButtonItem:addButton];
	[addButton release], addButton = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self navigationController] setToolbarHidden:NO animated:YES];
	
	[self populateToolbar];
	
//	[[self fetchedResultsController] setDelegate:nil];		// To avoid extra updates
	
	DataController *dataController = [DataController sharedDataController];
	
	[dataController filterPersons];
	
//	[[self fetchedResultsController] setDelegate:self];		// Due to nil above
	
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
	
	[ivFetchedResultsController setDelegate:nil];
	
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

	ClassPeriodPersonPickerViewController *nextViewController = [[ClassPeriodPersonPickerViewController alloc] init];
	[nextViewController setClassPeriod:[self classPeriod]];
	
	[[self navigationController] pushViewController:nextViewController animated:YES];
	
	[nextViewController release], nextViewController = nil;
	
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

- (void)populateToolbar
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if ([self studentsButton] == nil)
	{
		UIBarButtonItem *studentButton = [[UIBarButtonItem alloc] initWithTitle:@"Students"
																		  style:UIBarButtonItemStylePlain
																		 target:nil
																		 action:nil];
		[self setStudentsButton:studentButton];
		[studentButton release], studentButton = nil;
	}
	
	if ([self actionButton] == nil)
	{
		UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																					  target:self
																					  action:@selector(actionButtonPressed:)];
		[actionButton setStyle:UIBarButtonItemStyleBordered];
		[self setActionButton:actionButton];
		[actionButton release], actionButton = nil;
	}

	
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	
	DataController *dataController = [DataController sharedDataController];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSString *personPlural = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
	
	[[self studentsButton] setTitle:[NSString stringWithFormat:@"%@: %d", personPlural, [[[self fetchedResultsController] fetchedObjects] count]]];
	
	NSString *filterTitle = @"Filter";
	
	if ( ([[[dataController filterAction] actionValues] count] > 0) || ([userDefaults pointFilterModeBTI] != BTIPointFilterModeOff) )
	{
		filterTitle = @"** Filtered **";
	}
	
	UIBarButtonItem *filter = [[UIBarButtonItem alloc] initWithTitle:filterTitle
															   style:UIBarButtonItemStyleBordered
															  target:self
															  action:@selector(filterButtonPressed:)];
	
	[self setToolbarItems:[NSArray arrayWithObjects:[self editButtonItem], flexItem, [self studentsButton], flexItem, filter, [self actionButton], nil] animated:YES];
	
	[filter release], filter = nil;
	[flexItem release], flexItem = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSString *)listExport
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		
	NSMutableString *stringToReturn = [[[NSMutableString alloc] init] autorelease];
	NSString *newLine = @"\n";
	
	NSString *className = [[self classPeriod] name];
	if (![className isEqualToString:kAllStudentsClassName])
	{
		if ([className length] > 0)
		{
			[stringToReturn appendString:className];
			[stringToReturn appendString:@":"];
			[stringToReturn appendString:newLine];
		}
	}
	
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
	
	DataController *dataController = [DataController sharedDataController];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	Person *person = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
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

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		Person *person = [[self fetchedResultsController] objectAtIndexPath:indexPath];
		
		[[self classPeriod] removePersonsObject:person];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert)
	{
        
    }   
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	Person *person = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
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
	
	NSLog(@"row change type: %d", type);

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
			NSLog(@"mainUpdatedRowIndexPaths: %@", [self mainUpdatedRowIndexPaths]);
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
	
	NSLog(@"section change type: %d", type);
	
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
		NSLog(@"Primary FRC");
		UITableView *tableView = [self mainTableView];
		
		NSInteger totalChanges = [[self mainDeletedSectionIndexes] count] + [[self mainInsertedSectionIndexes] count] + [[self mainDeletedRowIndexPaths] count] + [[self mainInsertedRowIndexPaths] count] + [[self mainUpdatedRowIndexPaths] count];
		
		NSLog(@"%d changes", totalChanges);
		
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
		
		NSLog(@"Beginning Updates");
		
		[tableView deleteSections:[self mainDeletedSectionIndexes] withRowAnimation:UITableViewRowAnimationLeft];
		[tableView insertSections:[self mainInsertedSectionIndexes] withRowAnimation:UITableViewRowAnimationRight];
		
		[tableView deleteRowsAtIndexPaths:[self mainDeletedRowIndexPaths] withRowAnimation:UITableViewRowAnimationLeft];
		[tableView insertRowsAtIndexPaths:[self mainInsertedRowIndexPaths] withRowAnimation:UITableViewRowAnimationRight];
		[tableView reloadRowsAtIndexPaths:[self mainUpdatedRowIndexPaths] withRowAnimation:UITableViewRowAnimationNone];
		
		NSLog(@"Finished Updates");
		
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
