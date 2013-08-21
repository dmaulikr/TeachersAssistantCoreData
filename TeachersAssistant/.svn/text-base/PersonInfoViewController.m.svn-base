//
//  PersonInfoViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/15/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "PersonInfoViewController.h"

// Models and other global

// Sub-controllers
#import "ParentInfoViewController.h"
#import "PersonClassPeriodPickerViewController.h"

// Views
#import "PersonInfoCell.h"
#import "PersonInfoParentCell.h"

// Private Constants
typedef enum {
	BTIPersonInfoPersonSection = 0,
	BTIPersonInfoOtherDetailsSection,
	BTIPersonInfoParentSection,
	BTIPersonInfoNumberOfSections
} BTIPersonInfoSections;

#define kPersonFirstNameRowKey							@"kPersonFirstNameRowKey"
#define kPersonLastNameRowKey							@"kPersonLastNameRowKey"
//#define kPersonOtherRowKey								@"kPersonOtherRowKey"
#define kPersonClassRowKey								@"kPersonClassRowKey"

#define kAddressBookActionSheetTag						100
#define kImageActionSheetTag							200

@interface PersonInfoViewController ()

// Private Properties
@property (nonatomic, retain) NSFetchedResultsController *scratchParentsFetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *scratchPersonDetailInfoFetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *scratchObjectContext;
@property (nonatomic, retain) UITextField *activeTextField;
@property (nonatomic, retain) NSIndexPath *activeIndexPath;
@property (nonatomic, retain) Person *scratchPerson;
@property (nonatomic, retain) NSArray *personRowContents;
@property (nonatomic, retain) UIPopoverController *personalizePopover;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;
@property (nonatomic, retain) NSMutableArray *imagePickerTitles;
@property (nonatomic, assign) CGFloat personInfoCellHeight;
@property (nonatomic, assign) CGFloat personInfoParentCellHeight;

// Notification Handlers
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)shouldSaveData:(NSNotification *)notification;

// UI Response Methods
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)saveButtonPressed:(UIBarButtonItem *)button;


// Misc Methods
- (void)saveDataInTextField:(UITextField *)textField;

@end

@implementation PersonInfoViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize personInfoCell = ivPersonInfoCell;
@synthesize personInfoParentCell = ivPersonInfoParentCell;
@synthesize imageButton = ivImageButton;
@synthesize person = ivPerson;


// Private
@synthesize scratchParentsFetchedResultsController = ivScratchParentsFetchedResultsController;
@synthesize scratchPersonDetailInfoFetchedResultsController = ivScratchPersonDetailInfoFetchedResultsController;
@synthesize scratchObjectContext = ivScratchObjectContext;
@synthesize activeTextField = ivActiveTextField;
@synthesize activeIndexPath = ivActiveIndexPath;
@synthesize scratchPerson = ivScratchPerson;
@synthesize personRowContents = ivPersonRowContents;
@synthesize personalizePopover = ivPersonalizePopover;
@synthesize imagePickerController = ivImagePickerController;
@synthesize imagePickerTitles = ivImagePickerTitles;
@synthesize personInfoCellHeight = ivPersonInfoCellHeight;
@synthesize personInfoParentCellHeight = ivPersonInfoParentCellHeight;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTableView:nil];
	[self setPersonInfoCell:nil];
	[self setPersonInfoParentCell:nil];
	[self setImageButton:nil];
	[self setPerson:nil];
	
	// Private Properties
	[self setScratchParentsFetchedResultsController:nil];
	[self setScratchPersonDetailInfoFetchedResultsController:nil];
	[self setScratchObjectContext:nil];
    [self setActiveTextField:nil];
    [self setActiveIndexPath:nil];
    [self setScratchPerson:nil];
	[self setPersonRowContents:nil];
	[self setPersonalizePopover:nil];
	[self setImagePickerController:nil];
	[self setImagePickerTitles:nil];
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	[self setMainTableView:nil];
	[self setImageButton:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

- (void)setPerson:(Person *)person
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[person retain];
	[ivPerson release];
	ivPerson = person;

	if (person != nil)
	{
		[self setScratchPerson:(Person *)[[self scratchObjectContext] existingObjectWithID:[person objectID] error:nil]];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSManagedObjectContext *)scratchObjectContext
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivScratchObjectContext == nil)
	{
		NSPersistentStoreCoordinator *coordinator = [[DataController sharedDataController] persistentStoreCoordinator];
		if (coordinator != nil)
		{
			ivScratchObjectContext = [[NSManagedObjectContext alloc] init];
			[ivScratchObjectContext setPersistentStoreCoordinator:coordinator];
			
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:[[DataController sharedDataController] managedObjectContext]];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivScratchObjectContext;
}

- (NSFetchedResultsController *)scratchParentsFetchedResultsController
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivScratchParentsFetchedResultsController == nil)
	{
		DataController *dataController = [DataController sharedDataController];
		NSManagedObjectContext *context = [self scratchObjectContext];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		[fetchRequest setEntity:[Parent entityDescriptionInContextBTI:context]];
		
		[fetchRequest setSortDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
		
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"student == %@", [self scratchPerson]]];
		
		ivScratchParentsFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																					   managedObjectContext:context
																						 sectionNameKeyPath:nil
																								  cacheName:nil];
		[ivScratchParentsFetchedResultsController setDelegate:self];
		
		[ivScratchParentsFetchedResultsController performFetchBTI];
		
		[fetchRequest release], fetchRequest = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivScratchParentsFetchedResultsController;
}

- (NSFetchedResultsController *)scratchPersonDetailInfoFetchedResultsController
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivScratchPersonDetailInfoFetchedResultsController == nil)
	{
		DataController *dataController = [DataController sharedDataController];
		NSManagedObjectContext *context = [self scratchObjectContext];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		[fetchRequest setEntity:[PersonDetailInfo entityDescriptionInContextBTI:context]];
		
		[fetchRequest setSortDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
		
		ivScratchPersonDetailInfoFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																								managedObjectContext:context
																								  sectionNameKeyPath:nil
																										   cacheName:nil];
		
		[ivScratchPersonDetailInfoFetchedResultsController performFetchBTI];
		
		[fetchRequest release], fetchRequest = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivScratchPersonDetailInfoFetchedResultsController;
}

- (NSMutableArray *)imagePickerTitles
{
	if (ivImagePickerTitles == nil)
	{
		ivImagePickerTitles = [[NSMutableArray alloc] init];
	}
	return ivImagePickerTitles;
}

#pragma mark - Initialization and UI Creation Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(shouldSaveData:)
													 name:kShouldHideStudentDetailViewNotification
												   object:nil];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return self;
}

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	DataController *dataController = [DataController sharedDataController];
	NSString *personString = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
	
	if (![[NSUserDefaults standardUserDefaults] btiShouldShowPersonThumbnails])
	{
		[[self mainTableView] setTableHeaderView:nil];
	}
	
	if ([self person] == nil)
	{
		[self setTitle:[NSString stringWithFormat:@"Add %@", personString]];
	}
	else
	{
		[self setTitle:[NSString stringWithFormat:@"Edit %@", personString]];
	}
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																				  target:self
																				  action:@selector(cancelButtonPressed:)];
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	[cancelButton release], cancelButton = nil;
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																				target:self
																				action:@selector(saveButtonPressed:)];
	[[self navigationItem] setRightBarButtonItem:saveButton];
	[saveButton release], saveButton = nil;
	
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
		
	[self setToolbarItems:[NSArray arrayWithObjects:flexItem, [self editButtonItem], nil]];
	
	[flexItem release], flexItem = nil;
	
	[self setPersonRowContents:[NSArray arrayWithObjects:kPersonFirstNameRowKey, kPersonLastNameRowKey, kPersonClassRowKey, nil]];
	
	// Load row heights
	[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PersonInfoCell class]) owner:self options:nil];
	[self setPersonInfoCellHeight:[[self personInfoCell] frame].size.height];
	[self setPersonInfoCell:nil];
	
	[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PersonInfoParentCell class]) owner:self options:nil];
	[self setPersonInfoParentCellHeight:[[self personInfoParentCell] frame].size.height];
	[self setPersonInfoParentCell:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self navigationController] setToolbarHidden:NO animated:YES];
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	NSManagedObjectContext *context = [self scratchObjectContext];
	
	if ([self scratchPerson] == nil)
	{
		DataController *dataController = [DataController sharedDataController];
		
		Person *aPerson = [Person managedObjectInContextBTI:context];
		[self setScratchPerson:aPerson];
		
		ClassPeriod *allStudentsClass = [dataController classPeriodWithName:kAllStudentsClassName];
		ClassPeriod *scratchClass = (ClassPeriod *)[[self scratchObjectContext] existingObjectWithID:[allStudentsClass objectID] error:nil];
		
		[aPerson addClassPeriodsObject:scratchClass];
	}
	
	UIImage *thumbnail = [[[self scratchPerson] largeThumbnailMediaInfo] image];
	
	if (thumbnail == nil)
	{
		[[self imageButton] setImage:kPersonPlaceholderImage forState:UIControlStateNormal];
	}
	else
	{
		[[self imageButton] setImage:thumbnail forState:UIControlStateNormal];
	}
	
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
	
	UITextField *activeTextField = [self activeTextField];
	
	[self saveDataInTextField:activeTextField];
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[notificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];

	if ([[self personalizePopover] isPopoverVisible])
	{
		[[self personalizePopover] setDelegate:nil];
		[[self personalizePopover] dismissPopoverAnimated:YES];
		[self setPersonalizePopover:nil];
	}
	
	[activeTextField resignFirstResponder];
	[self setActiveTextField:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidDisappear:animated];
	
	
	
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

- (void)keyboardWillShow:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0.0, 0.0, 370.0, 0.0);
	[[self mainTableView] setContentInset:edgeInsets];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self mainTableView] setContentInset:UIEdgeInsetsZero];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)shouldSaveData:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[self saveDataInTextField:[self activeTextField]];
	
	DataController *dataController = [DataController sharedDataController];
	
	MediaInfo *largeMediaInfo = [[self scratchPerson] largeThumbnailMediaInfo];
	MediaInfo *smallMediaInfo = [[self scratchPerson] smallThumbnailMediaInfo];
	
	if ( (largeMediaInfo != nil) && ([largeMediaInfo fileName] == nil) )
	{
		[dataController addFileForMediaInfo:largeMediaInfo];
		[dataController addFileForMediaInfo:smallMediaInfo];
	}
	
	[dataController saveManagedObjectContext:[self scratchObjectContext]];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)managedObjectContextDidSave:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSManagedObjectContext *context = [self scratchObjectContext];
	
	// Merging changes causes the fetched results controller to update its results
	[context mergeChangesFromContextDidSaveNotification:notification];
	
	//	NSLog(@"registered objects: %@", [[context registeredObjects] description]);
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UI Response Methods

- (void)cancelButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)saveButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self saveDataInTextField:[self activeTextField]];
	
	NSString *firstName = [[self scratchPerson] firstName];
	NSString *lastName = [[self scratchPerson] lastName];
	
	DataController *dataController = [DataController sharedDataController];
	
	if ( ([firstName length] == 0) || ([lastName length] == 0) )
	{
		NSString *personString = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:[NSString stringWithFormat:@"You must fill in both the %@'s first name and last name", personString]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release], alert = nil;
	}
	else
	{
		MediaInfo *largeMediaInfo = [[self scratchPerson] largeThumbnailMediaInfo];
		MediaInfo *smallMediaInfo = [[self scratchPerson] smallThumbnailMediaInfo];
		
		if ( (largeMediaInfo != nil) && ([largeMediaInfo fileName] == nil) )
		{
			[dataController addFileForMediaInfo:largeMediaInfo];
			[dataController addFileForMediaInfo:smallMediaInfo];
		}
		
		[dataController saveManagedObjectContext:[self scratchObjectContext]];
		
		[[self navigationController] popViewControllerAnimated:YES];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)contactButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	ParentInfoViewController *nextViewController = [[ParentInfoViewController alloc] init];
	[nextViewController setScratchObjectContext:[self scratchObjectContext]];
	[nextViewController setScratchPerson:[self scratchPerson]];
	
	[[self navigationController] pushViewController:nextViewController animated:YES];
	
	[nextViewController release], nextViewController = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (IBAction)imageButtonPressed:(UIButton *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[self imagePickerTitles] removeAllObjects];
	
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
													   delegate:self
											  cancelButtonTitle:nil
										 destructiveButtonTitle:nil
											  otherButtonTitles:nil];
	
	[sheet addButtonWithTitle:kImagePickerTitleChoose];
	[[self imagePickerTitles] addObject:kImagePickerTitleChoose];
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		[sheet addButtonWithTitle:kImagePickerTitleTake];
		[[self imagePickerTitles] addObject:kImagePickerTitleTake];
	}
	
	if ([[self scratchPerson] largeThumbnailMediaInfo] != nil)
	{
		[sheet addButtonWithTitle:kImagePickerTitleDelete];
		[[self imagePickerTitles] addObject:kImagePickerTitleDelete];
	}
	
	[sheet setCancelButtonIndex:[sheet addButtonWithTitle:@"Cancel"]];
	
	[sheet setTag:kImageActionSheetTag];
	
	if ([[DataController sharedDataController] isIPadVersion])
	{
		[sheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
		[sheet showInView:[[self splitViewController] view]];
	}
	else
	{
		[sheet showFromToolbar:[[self navigationController] toolbar]];
	}
	
	[sheet release], sheet = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (void)saveDataInTextField:(UITextField *)textField
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (textField == nil)
	{
		NSLog(@"<<< Leaving %s >>> EARLY - No text field", __PRETTY_FUNCTION__);
		return;
	}
	
	NSManagedObjectContext *context = [self scratchObjectContext];
	
	PersonInfoCell *cell = (PersonInfoCell *)[[textField superview] superview];
	NSIndexPath *indexPath = [[self mainTableView] indexPathForCell:cell];
	
	if (indexPath == nil)
	{
		NSLog(@"Using stored index path");
		indexPath = [self activeIndexPath];
	}
	
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	
	NSString *text = [[textField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if (section == BTIPersonInfoPersonSection)
	{
		NSString *rowKey = [[self personRowContents] objectAtIndex:row];
		
		if ([rowKey isEqualToString:kPersonFirstNameRowKey])
		{
			[[self scratchPerson] setFirstName:text];
		}
		else if ([rowKey isEqualToString:kPersonLastNameRowKey])
		{
			[[self scratchPerson] setLastName:text];
		}
	}
	else if (section == BTIPersonInfoOtherDetailsSection)
	{
		NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
		PersonDetailInfo *scratchPersonDetailInfo = [[self scratchPersonDetailInfoFetchedResultsController] objectAtIndexPath:adjustedIndexPath];
		PersonDetailValue *scratchPersonDetailValue = [[self scratchPerson] detailValueForPersonDetailInfo:scratchPersonDetailInfo];
		if (scratchPersonDetailValue == nil)
		{
			scratchPersonDetailValue = [PersonDetailValue managedObjectInContextBTI:context];
			[scratchPersonDetailValue setPersonDetailInfo:scratchPersonDetailInfo];
			[scratchPersonDetailValue setPerson:[self scratchPerson]];
		}
		
		[scratchPersonDetailValue setName:text];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger sections = BTIPersonInfoNumberOfSections;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
    return sections;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *header = nil;
	
	if (section == BTIPersonInfoParentSection)
	{
		header = [[DataController sharedDataController] pluralNameForTermInfoIndentifier:kTermInfoIdentifierParent];
	}
	else if (section == BTIPersonInfoOtherDetailsSection)
	{
		header = @"Details";
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return header;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	CGFloat height = 0.0;
	
	switch ([indexPath section]) {
		case BTIPersonInfoPersonSection:
			height = [self personInfoCellHeight];
			break;
		case BTIPersonInfoOtherDetailsSection:
			height = [self personInfoCellHeight];
			break;
		case BTIPersonInfoParentSection:
		{
			if ([indexPath row] == [[[self scratchParentsFetchedResultsController] fetchedObjects] count])
				height = [self personInfoCellHeight];
			else
				height = [self personInfoParentCellHeight];
		}
			break;
		default:
			break;
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return height;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger rows = 0;
	
	switch (section) {
		case BTIPersonInfoPersonSection:
			rows = [[self personRowContents] count];
			break;
		case BTIPersonInfoOtherDetailsSection:
			rows = [[[self scratchPersonDetailInfoFetchedResultsController] fetchedObjects] count];
			break;
		case BTIPersonInfoParentSection:
		{
			rows = [[[self scratchParentsFetchedResultsController] fetchedObjects] count] + 1;
		}
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	DataController *dataController = [DataController sharedDataController];
	
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	
	if (section == BTIPersonInfoPersonSection)
	{
		NSString *rowKey = [[self personRowContents] objectAtIndex:row];
		
		if ([rowKey isEqualToString:kPersonClassRowKey])
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"] autorelease];
			
			NSMutableSet *eligibleClasses = [NSMutableSet setWithSet:[[self scratchPerson] classPeriods]];
			
			for (ClassPeriod *classPeriod in [[self scratchPerson] classPeriods])
			{
				if ([[classPeriod name] isEqualToString:kAllStudentsClassName])
				{
					[eligibleClasses removeObject:classPeriod];
					break;
				}
			}
			
			if ([eligibleClasses count] > 1)
			{
				[[cell textLabel] setText:[dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierClass]];
			}
			else
			{
				[[cell textLabel] setText:[dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierClass]];
			}
			
			[[cell detailTextLabel] setText:[[self scratchPerson] classNames]];
			
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			
			NSLog(@"<<< Leaving %s >>> EARLY - Class row", __PRETTY_FUNCTION__);
			return cell;
		}
		else
		{
			[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PersonInfoCell class]) owner:self options:nil];
			PersonInfoCell *textCell = [self personInfoCell];
			[self setPersonInfoCell:nil];
			
			NSString *person = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
			
			if ([rowKey isEqualToString:kPersonFirstNameRowKey])
			{
				[[textCell label] setText:@"First"];
				[[textCell textField] setPlaceholder:[NSString stringWithFormat:@"%@'s first name", person]];
				[[textCell textField] setText:[[self scratchPerson] firstName]];
			}
			else if ([rowKey isEqualToString:kPersonLastNameRowKey])
			{
				[[textCell label] setText:@"Last"];
				[[textCell textField] setPlaceholder:[NSString stringWithFormat:@"%@'s last name", person]];
				[[textCell textField] setText:[[self scratchPerson] lastName]];
			}
			
			return textCell;
		}
	}
	else if (section == BTIPersonInfoOtherDetailsSection)
	{
		[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PersonInfoCell class]) owner:self options:nil];
		PersonInfoCell *textCell = [self personInfoCell];
		[self setPersonInfoCell:nil];
		
		NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
		PersonDetailInfo *detailInfo = [[self scratchPersonDetailInfoFetchedResultsController] objectAtIndexPath:adjustedIndexPath];
		PersonDetailValue *detailValue = [[self scratchPerson] detailValueForPersonDetailInfo:detailInfo];
		
		[[textCell label] setText:[detailInfo name]];
		[[textCell textField] setText:[detailValue name]];
		
		return textCell;
	}
	else if (section == BTIPersonInfoParentSection)
	{
		if (row == [[[self scratchParentsFetchedResultsController] fetchedObjects] count])
		{
			[[cell textLabel] setText:[NSString stringWithFormat:@"Add %@", [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierParent]]];
		}
		else
		{
			NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
			Parent *parent = [[self scratchParentsFetchedResultsController] objectAtIndexPath:adjustedIndexPath];
			EmailAddress *emailAddress = [parent primaryEmailAddress];
			PhoneNumber *phoneNumber = [parent primaryPhoneNumber];
		
			[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PersonInfoParentCell class]) owner:self options:nil];
			PersonInfoParentCell *parentCell = [self personInfoParentCell];
			[self setPersonInfoParentCell:nil];
			
			[[parentCell nameLabel] setText:[parent name]];
			
			if (emailAddress == nil)
			{
				[[parentCell emailLabel] setText:@"Email:"];
			}
			else
			{
				[[parentCell emailLabel] setText:[NSString stringWithFormat:@"%@: %@", [emailAddress type], [emailAddress value]]];
			}
			
			if (phoneNumber == nil)
			{
				[[parentCell phoneLabel] setText:@"Phone Number:"];
			}
			else
			{
				[[parentCell phoneLabel] setText:[NSString stringWithFormat:@"%@: %@", [phoneNumber type], [phoneNumber value]]];
			}
			
			return parentCell;
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	BOOL canEdit = YES;
	
	switch ([indexPath section]) {
		case BTIPersonInfoPersonSection:
			canEdit = NO;
			break;
		case BTIPersonInfoOtherDetailsSection:
			canEdit = NO;
			break;
		case BTIPersonInfoParentSection:
			canEdit = ([indexPath row] != [[[self scratchParentsFetchedResultsController] fetchedObjects] count]);
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return  canEdit;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:[indexPath row] inSection:0];
		Parent *scratchParent = [[self scratchParentsFetchedResultsController] objectAtIndexPath:adjustedIndexPath];
		
		[[self scratchObjectContext] deleteObject:scratchParent];
	}
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	BOOL canMove = YES;

	switch ([indexPath section]) {
		case BTIPersonInfoPersonSection:
			canMove = NO;
			break;
		case BTIPersonInfoOtherDetailsSection:
			canMove = NO;
			break;
		case BTIPersonInfoParentSection:
			canMove = ([indexPath row] != [[[self scratchParentsFetchedResultsController] fetchedObjects] count]);
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return  canMove;
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
	  toIndexPath:(NSIndexPath *)toIndexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	NSMutableArray *parents = [NSMutableArray arrayWithArray:[[self scratchParentsFetchedResultsController] fetchedObjects]];
	
	Parent *parent = [parents objectAtIndex:[fromIndexPath row]];
	[parents removeObjectAtIndex:[fromIndexPath row]];
	[parents insertObject:parent atIndex:[toIndexPath row]];
	
	[[self scratchParentsFetchedResultsController] setDelegate:nil];
	
	[parents enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		Parent *parent = (Parent *)object;
		[parent setSortOrder:[NSNumber numberWithInt:index]];
		
	}];
    
	[[self scratchParentsFetchedResultsController] setDelegate:self];
	[[self scratchParentsFetchedResultsController] performFetchBTI];
	
//	[[self mainTableView] performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	
	if (section == BTIPersonInfoPersonSection)
	{
		NSString *rowKey = [[self personRowContents] objectAtIndex:row];
		
		if ([rowKey isEqualToString:kPersonClassRowKey])
		{
			PersonClassPeriodPickerViewController *nextViewController = [[PersonClassPeriodPickerViewController alloc] init];
			[nextViewController setScratchObjectContext:[self scratchObjectContext]];
			[nextViewController setScratchPerson:[self scratchPerson]];
			
			[[self navigationController] pushViewController:nextViewController animated:YES];
			
			[nextViewController release], nextViewController = nil;			
		}
		else
		{
			PersonInfoCell *cell = (PersonInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
			
			[[cell textField] becomeFirstResponder];
		}
	}
	else if (section == BTIPersonInfoOtherDetailsSection)
	{
		PersonInfoCell *cell = (PersonInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
		
		[[cell textField] becomeFirstResponder];
	}
	else if (section == BTIPersonInfoParentSection)
	{
		if (row == [[[self scratchParentsFetchedResultsController] fetchedObjects] count])
		{
			DataController *dataController = [DataController sharedDataController];
			NSString *parentString = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierParent];
			UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Add %@", parentString]
															   delegate:self
													  cancelButtonTitle:@"Cancel"
												 destructiveButtonTitle:nil
													  otherButtonTitles:@"From Contacts", @"Manually", nil];
			[sheet setTag:kAddressBookActionSheetTag];
			if ([dataController isIPadVersion])
			{
//				PersonInfoCell *cell = (PersonInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
//				[sheet showFromRect:[cell bounds] inView:cell animated:YES];
				[sheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
				[sheet showInView:[[self splitViewController] view]];
			}
			else
			{
				[sheet showFromToolbar:[[self navigationController] toolbar]];
			}
			
			[sheet release], sheet = nil;
		}
		else
		{
			ParentInfoViewController *nextViewController = [[ParentInfoViewController alloc] init];
			[nextViewController setScratchObjectContext:[self scratchObjectContext]];
			[nextViewController setScratchPerson:[self scratchPerson]];
			
			NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
			Parent *parent = [[self scratchParentsFetchedResultsController] objectAtIndexPath:adjustedIndexPath];
			[nextViewController setScratchParent:parent];
			
			[[self navigationController] pushViewController:nextViewController animated:YES];
			
			[nextViewController release], nextViewController = nil;
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
	   toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSInteger destinationSection = [proposedDestinationIndexPath section];
	NSInteger destinationRow = [proposedDestinationIndexPath row];
	
	switch (destinationSection) {
		case BTIPersonInfoPersonSection:
			proposedDestinationIndexPath = [NSIndexPath indexPathForRow:0 inSection:BTIPersonInfoParentSection];
			break;
		case BTIPersonInfoOtherDetailsSection:
			proposedDestinationIndexPath = [NSIndexPath indexPathForRow:0 inSection:BTIPersonInfoParentSection];
			break;
		case BTIPersonInfoParentSection:
		{
			if (destinationRow == [[[self scratchParentsFetchedResultsController] fetchedObjects] count])
			{
				proposedDestinationIndexPath = [NSIndexPath indexPathForRow:destinationRow - 1 inSection:destinationSection];
			}
		}
			break;
		default:
			break;
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return proposedDestinationIndexPath;
}

#pragma mark - UITextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0.0, 0.0, 370.0, 0.0);
	[[self mainTableView] setContentInset:edgeInsets];
	
	PersonInfoCell *cell = (PersonInfoCell *)[[textField superview] superview];
	NSIndexPath *indexPath = [[self mainTableView] indexPathForCell:cell];
	
	[self setActiveTextField:textField];
	[self setActiveIndexPath:indexPath];
	
	[[self mainTableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self saveDataInTextField:textField];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[textField resignFirstResponder];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return YES;
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
	
	NSIndexPath *adjustedNewIndexPath = [NSIndexPath indexPathForRow:[newIndexPath row] inSection:BTIPersonInfoParentSection];
	NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:[indexPath row] inSection:BTIPersonInfoParentSection];
	
	switch (type)
	{
		case NSFetchedResultsChangeInsert:
			NSLog(@"insert");
			[[self mainTableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:adjustedNewIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			NSLog(@"delete");
			[[self mainTableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:adjustedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate:
			NSLog(@"update");
			//			[self configureCell:(CategoryCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
		case NSFetchedResultsChangeMove:
			NSLog(@"move");
			[[self mainTableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:adjustedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			[[self mainTableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:adjustedNewIndexPath] withRowAnimation:UITableViewRowAnimationFade];
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
			[[self mainTableView] insertSections:[NSIndexSet indexSetWithIndex:BTIPersonInfoParentSection] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			NSLog(@"delete");
			[[self mainTableView] deleteSections:[NSIndexSet indexSetWithIndex:BTIPersonInfoParentSection] withRowAnimation:UITableViewRowAnimationFade];
			break;
		default:
			NSLog(@"There was some other option!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (buttonIndex != [actionSheet cancelButtonIndex])
	{
		NSLog(@"buttonIndex is: %d", buttonIndex);
		if ([actionSheet tag] == kAddressBookActionSheetTag)
		{
			switch (buttonIndex) {
				case 0:		// Address Book
				{
					ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
					[peoplePicker setPeoplePickerDelegate:self];
					
					if ([[DataController sharedDataController] isIPadVersion])
					{
						[[NSNotificationCenter defaultCenter] postNotificationName:kShouldHideMasterViewControllerNotification object:nil];
						
						[[self splitViewController] presentModalViewController:peoplePicker animated:YES];
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
					ParentInfoViewController *nextViewController = [[ParentInfoViewController alloc] init];
					[nextViewController setScratchObjectContext:[self scratchObjectContext]];
					[nextViewController setScratchPerson:[self scratchPerson]];
					
					[[self navigationController] pushViewController:nextViewController animated:YES];
					
					[nextViewController release], nextViewController = nil;
				}	
					break;	
				default:
					break;
			}
		}
		else if ([actionSheet tag] == kImageActionSheetTag)
		{
			NSString *rowTitle = [[self imagePickerTitles] objectAtIndex:buttonIndex];
			
			if ([rowTitle isEqualToString:kImagePickerTitleDelete])
			{
				[[self scratchPerson] setLargeThumbnailMediaInfo:nil];
				[[self scratchPerson] setSmallThumbnailMediaInfo:nil];
				
				[[self imageButton] setImage:kPersonPlaceholderImage forState:UIControlStateNormal];
			}
			else
			{			
				UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
				[self setImagePickerController:imagePicker];
				[imagePicker setMediaTypes:[NSArray arrayWithObject:(NSString *)kUTTypeImage]];
				[imagePicker setDelegate:self];
				
				if ([rowTitle isEqualToString:kImagePickerTitleChoose])
				{
					[imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
				}
				else
				{
					[imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
				}
				
				if ([[DataController sharedDataController] isIPadVersion])
				{
					UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
					[self setPersonalizePopover:popover];
					[popover setDelegate:self];
					
					[popover presentPopoverFromRect:[[self imageButton] bounds] inView:[self imageButton] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
					
					[popover release], popover = nil;
				}
				else
				{
					[self presentModalViewController:imagePicker animated:YES];
				}
				
				[imagePicker release], imagePicker = nil;
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
	
	DataController *dataController = [DataController sharedDataController];
	NSManagedObjectContext *context = [self scratchObjectContext];
		
	Parent *parent = [dataController makeParentInContext:context
								   fromAddressBookPerson:person
											withFullName:YES];
	
	[parent setSortOrder:[NSNumber numberWithInt:[[[self scratchPerson] parents] count]]];
	[parent setStudent:[self scratchPerson]];
	
	[self dismissModalViewControllerAnimated:YES];
	
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

#pragma mark - UIPopoverController Delegate Methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self setPersonalizePopover:nil];
	[self setImagePickerController:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	UIImage *selectedImage = nil;
	if ([info objectForKey:UIImagePickerControllerEditedImage] != nil)
		selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
	else
		selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];

	DataController *dataController = [DataController sharedDataController];
	NSManagedObjectContext *context = [self scratchObjectContext];
	
	UIImage *largeImage = [dataController largePersonThumbnailImageFromImage:selectedImage];
	UIImage *smallImage = [dataController smallPersonThumbnailImageFromImage:largeImage];
	
	MediaInfo *largeMediaInfo = [MediaInfo managedObjectInContextBTI:context];
	[largeMediaInfo setType:[NSNumber numberWithInt:BTIMediaTypeImage]];
	[largeMediaInfo setImage:largeImage];
	
	MediaInfo *smallMediaInfo = [MediaInfo managedObjectInContextBTI:context];
	[smallMediaInfo setType:[NSNumber numberWithInt:BTIMediaTypeImage]];
	[smallMediaInfo setImage:smallImage];

	[[self scratchPerson] setLargeThumbnailMediaInfo:largeMediaInfo];
	[[self scratchPerson] setSmallThumbnailMediaInfo:smallMediaInfo];
	
	[[self imageButton] setImage:largeImage forState:UIControlStateNormal];
	
	if (![dataController isIPadVersion])
	{
		[self dismissModalViewControllerAnimated:YES];
	}
	
	if ([[self personalizePopover] isPopoverVisible])
	{
		[[self personalizePopover] setDelegate:nil];
		[[self personalizePopover] dismissPopoverAnimated:YES];
		[self setPersonalizePopover:nil];
	}
	
	[self setImagePickerController:nil];
	
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
	
	if (![[DataController sharedDataController] isIPadVersion])
	{
		[self dismissModalViewControllerAnimated:YES];
	}
	
	[self setImagePickerController:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
