//
//  ActionDetailViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/16/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ActionDetailViewController.h"

// Models and other global

// Sub-controllers
#import "ActionPickerValuesViewController.h"
#import "DateDetailViewController.h"
#import "LongTextDetailViewController.h"
#import "AssignActionsClassPickerViewController.h"
#import "ColorInfoPickerViewController.h"
#import "ActionImageViewController.h"

// Views
#import "UICustomSwitch.h"

// Private Constants


@interface ActionDetailViewController ()

// Private Properties
@property (nonatomic, retain) NSManagedObjectContext *scratchObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) Person *scratchPerson;
@property (nonatomic, retain) Action *scratchAction;


// Notification Handlers



// UI Response Methods


// Misc Methods


@end

@implementation ActionDetailViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize person = ivPerson;
@synthesize action = ivAction;
@synthesize imagePickerController = ivImagePickerController;
@synthesize imagePickerTitles = ivImagePickerTitles;
@synthesize scratchActiveImageActionValue = ivScratchActiveImageActionValue;
@synthesize contentOffset = ivContentOffset;

// Private
@synthesize scratchObjectContext = ivScratchObjectContext;
@synthesize fetchedResultsController = ivFetchedResultsController;
@synthesize scratchPerson = ivScratchPerson;
@synthesize scratchAction = ivScratchAction;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTableView:nil];
	[self setPerson:nil];
	[self setAction:nil];
	[self setImagePickerController:nil];
	[self setImagePickerTitles:nil];
	[self setScratchActiveImageActionValue:nil];
	
	// Private Properties
	[self setScratchObjectContext:nil];
	[self setFetchedResultsController:nil];
	[self setScratchAction:nil];
	
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

- (void)setAction:(Action *)action
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[action retain];
	[ivAction release];
	ivAction = action;
	
	if (action != nil)
	{
		[self setScratchAction:(Action *)[[self scratchObjectContext] existingObjectWithID:[action objectID] error:nil]];
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSManagedObjectContext *)scratchObjectContext
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivScratchObjectContext == nil)
	{
		DataController *dataController = [DataController sharedDataController];
		NSPersistentStoreCoordinator *coordinator = [[DataController sharedDataController] persistentStoreCoordinator];
		if (coordinator != nil)
		{
			ivScratchObjectContext = [[NSManagedObjectContext alloc] init];
			[ivScratchObjectContext setPersistentStoreCoordinator:coordinator];
			
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:[dataController managedObjectContext]];
		}
		
		NSLog(@"scratchObjectContext is created: %@", ivScratchObjectContext);
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivScratchObjectContext;
}

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
		
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isHidden == %@", [NSNumber numberWithBool:NO]]];
		
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
		[self setContentOffset:CGPointZero];
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
	NSString *singular = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierAction];
	
	if ([self action] != nil)
	{
		[self setTitle:[NSString stringWithFormat:@"Edit %@", singular]];
	}
	else
	{
		[self setTitle:[NSString stringWithFormat:@"Add %@", singular]];
	}
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
																   style:UIBarButtonItemStyleBordered
																  target:nil
																  action:nil];
	[[self navigationItem] setBackBarButtonItem:backButton];
	[backButton release], backButton = nil;
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																				  target:self
																				  action:@selector(cancelButtonPressed:)];
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	[cancelButton release], cancelButton = nil;
	
	if ([self person] != nil)
	{
		UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																					target:self
																					action:@selector(saveButtonPressed:)];
		[[self navigationItem] setRightBarButtonItem:saveButton];
		[saveButton release], saveButton = nil;
	}
	else
	{
		UIBarButtonItem *personsButton = [[UIBarButtonItem alloc] initWithTitle:[dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierPerson]
																		  style:UIBarButtonItemStyleBordered
																		 target:self
																		 action:@selector(personsButtonPressed:)];
		[[self navigationItem] setRightBarButtonItem:personsButton];
		[personsButton release], personsButton = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self navigationController] setToolbarHidden:YES animated:YES];
	
	DataController *dataController = [DataController sharedDataController];
	NSManagedObjectContext *mainContext = [dataController managedObjectContext];
	NSManagedObjectContext *scratchContext = [self scratchObjectContext];

	[dataController setImageCleanupEnabled:NO];
	
	if ([self scratchAction] == nil)
	{
//		Action *newAction = [[[Action alloc] initInManagedObjectContext:scratchContext] autorelease];
		Action *newAction = [Action managedObjectInContextBTI:scratchContext];
		[newAction setDateCreated:[NSDate date]];
		
		[self setScratchAction:newAction];
		
		[self addMissingActionValues];
		[self preloadScratchActionFromDefaultValues];
	}
	
	[self addMissingActionValues];
	
	// Generate thumbnails if necessary
	
	[[self fetchedResultsController] setDelegate:nil];		// To avoid extra updates
	
	for (ActionFieldInfo *actionFieldInfo in [[self fetchedResultsController] fetchedObjects])
	{
		if ([[actionFieldInfo type] intValue] != BTIActionFieldValueTypeImage)
			continue;
		
		ActionFieldInfo *scratchActionFieldInfo = (ActionFieldInfo *)[scratchContext existingObjectWithID:[actionFieldInfo objectID] error:nil];
		ActionValue *scratchActionValue = [[self scratchAction] actionValueForActionFieldInfo:scratchActionFieldInfo];
		
		if ([scratchActionValue imageMediaInfo] != nil)
		{
			if ([scratchActionValue thumbnailImageMediaInfo] == nil)
			{
				[self setScratchActiveImageActionValue:scratchActionValue];
								
				MediaInfo *mediaInfo = [MediaInfo managedObjectInContextBTI:mainContext];
				[mediaInfo setType:[NSNumber numberWithInt:BTIMediaTypeImage]];
				[mediaInfo setImage:[dataController smallActionValueImageFromImage:[[scratchActionValue imageMediaInfo] image]]];
				[dataController addFileForMediaInfo:mediaInfo];
				
				[dataController saveCoreDataContext];
				
				MediaInfo *scratchMediaInfo = (MediaInfo *)[scratchContext existingObjectWithID:[mediaInfo objectID] error:nil];
		
				[[self scratchActiveImageActionValue] setThumbnailImageMediaInfo:scratchMediaInfo];
				
				[self setScratchActiveImageActionValue:nil];
			}
		}
	}
	
	[[self fetchedResultsController] setDelegate:self];		// Due to nil above
	
	[[self mainTableView] reloadData];
	
//	[[self mainTableView] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	
	[[self mainTableView] setContentOffset:[self contentOffset]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidAppear:animated];
	
	DataController *dataController = [DataController sharedDataController];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	if (![userDefaults btiDidShowActionTip])
	{
		NSString *actionText = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierAction];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip"
														message:[NSString stringWithFormat:@"You can hide, rename, or add your own custom fields by going to Settings, then Customize %@ Fields", actionText]
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release], alert = nil;
		
		[userDefaults btiSetDidShowActionTip:YES];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillDisappear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillDisappear:animated];
	
	[self setContentOffset:[[self mainTableView] contentOffset]];
	
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
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kShouldHideActionDetailViewNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kInfractionDetailViewDidFinishNotification object:nil];
	
	[[DataController sharedDataController] setImageCleanupEnabled:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)saveButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	DataController *dataController = [DataController sharedDataController];
	
	if ([self action] == nil)
	{
		[[self scratchPerson] addActionsObject:[self scratchAction]];
	}
	
	[[self scratchAction] setDateModified:[NSDate date]];
	
	[dataController saveManagedObjectContext:[self scratchObjectContext]];
	
	[[self person] calculateColorLabelPointTotal];
	[[self person] calculateActionCountTotal];
	
	[dataController saveCoreDataContext];
	
	[dataController setImageCleanupEnabled:YES];
		
	BOOL shouldAnimatePop = YES;
	if (button == nil)
		shouldAnimatePop = NO;
	
	[[self navigationController] popViewControllerAnimated:shouldAnimatePop];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)personsButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	AssignActionsClassPickerViewController *nextViewController = [[AssignActionsClassPickerViewController alloc] init];
	[nextViewController setScratchObjectContext:[self scratchObjectContext]];
	[nextViewController setScratchAction:[self scratchAction]];
	
	[[self navigationController] pushViewController:nextViewController animated:YES];
	
	[nextViewController release], nextViewController = nil;

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (IBAction)switchValueChanged:(UICustomSwitch *)customSwitch
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSIndexPath *indexPath = [[self mainTableView] mdIndexPathForRowContainingView:customSwitch];
	
	ActionFieldInfo *actionFieldInfo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	ActionFieldInfo *scratchActionFieldInfo = (ActionFieldInfo *)[[self scratchObjectContext] existingObjectWithID:[actionFieldInfo objectID] error:nil];

	ActionValue *scratchActionValue = [[self scratchAction] actionValueForActionFieldInfo:scratchActionFieldInfo];
	
	[scratchActionValue setBoolean:[NSNumber numberWithBool:[customSwitch isOn]]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (void)addMissingActionValues
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSManagedObjectContext *context = [self scratchObjectContext];
	
	// Make sure there is an ActionValue for each ActionFieldInfo
	for (ActionFieldInfo *actionFieldInfo in [[self fetchedResultsController] fetchedObjects])
	{
		ActionFieldInfo *scratchActionFieldInfo = (ActionFieldInfo *)[context existingObjectWithID:[actionFieldInfo objectID] error:nil];
		
		ActionValue *scratchActionValue = [[self scratchAction] actionValueForActionFieldInfo:scratchActionFieldInfo];
		
		if (scratchActionValue == nil)
		{
			scratchActionValue = [ActionValue managedObjectInContextBTI:context];
			[scratchActionValue setActionFieldInfo:scratchActionFieldInfo];
			[scratchActionValue setAction:[self scratchAction]];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)preloadScratchActionFromDefaultValues
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	DataController *dataController = [DataController sharedDataController];
	
	Action *defaultAction = [dataController defaultAction];
	
	for (ActionFieldInfo *actionFieldInfo in [[self fetchedResultsController] fetchedObjects])
	{
		ActionFieldInfo *scratchActionFieldInfo = (ActionFieldInfo *)[[self scratchObjectContext] existingObjectWithID:[actionFieldInfo objectID] error:nil];
		ActionValue *scratchActionValue = [[self scratchAction] actionValueForActionFieldInfo:scratchActionFieldInfo];
		
		ActionValue *defaultActionValue = [defaultAction actionValueForActionFieldInfo:actionFieldInfo];
		
		if ([[actionFieldInfo identifier] isEqualToString:kTermInfoIdentifierDate])
		{
			if ( (defaultActionValue == nil) || ([defaultActionValue date] == nil) )
			{
				[scratchActionValue setDate:[NSDate date]];
			}
			else
			{
				[scratchActionValue setDate:[defaultActionValue date]];
			}
		}
		
		[scratchActionValue setBoolean:[defaultActionValue boolean]];
		[scratchActionValue setLongText:[defaultActionValue longText]];
		
		ColorInfo *colorInfo = [defaultActionValue colorInfo];
		if (colorInfo != nil)
		{
			ColorInfo *scratchColorInfo = (ColorInfo *)[[self scratchObjectContext] existingObjectWithID:[colorInfo objectID] error:nil];
			[scratchActionValue setColorInfo:scratchColorInfo];
		}
		
		for (PickerValue *pickerValue in [defaultActionValue pickerValues])
		{
			PickerValue *scratchPickerValue = (PickerValue *)[[self scratchObjectContext] existingObjectWithID:[pickerValue objectID] error:nil];
			
			[scratchActionValue addPickerValuesObject:scratchPickerValue];
		}
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
	
	static NSString *plainCellIdentifier = @"plainCellIdentifier";
	static NSString *switchCellIdentifier = @"switchCellIdentifier";
	
	UITableViewCell *plainCell = [tableView dequeueReusableCellWithIdentifier:plainCellIdentifier];
	if (plainCell == nil)
	{
		plainCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:plainCellIdentifier] autorelease];
		[[plainCell textLabel] setAdjustsFontSizeToFitWidth:YES];
		[[plainCell textLabel] setMinimumFontSize:12.0];
		
		
	}
	
	[plainCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	[[plainCell imageView] setImage:nil];
	
	UITableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:switchCellIdentifier];
	if (switchCell == nil)
	{
		switchCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:switchCellIdentifier] autorelease];
		[[switchCell textLabel] setAdjustsFontSizeToFitWidth:YES];
		[[switchCell textLabel] setMinimumFontSize:12.0];
		
		UICustomSwitch *customSwitch = [[UICustomSwitch alloc] init];
		[[customSwitch leftLabel] setText:@"Yes"];
		[[customSwitch rightLabel] setText:@"No"];
		[customSwitch setTag:555];
		[customSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
		
		[switchCell setAccessoryView:customSwitch];
		
		[customSwitch release], customSwitch = nil;
	}
	
	DataController *dataController = [DataController sharedDataController];
	ActionFieldInfo *actionFieldInfo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	ActionFieldInfo *scratchActionFieldInfo = (ActionFieldInfo *)[[self scratchObjectContext] existingObjectWithID:[actionFieldInfo objectID] error:nil];
	NSInteger fieldType = [[scratchActionFieldInfo type] integerValue];
	TermInfo *termInfo = [actionFieldInfo termInfo];
	ActionValue *scratchActionValue = [[self scratchAction] actionValueForActionFieldInfo:scratchActionFieldInfo];
	
	NSString *singularName = [dataController singularNameForTermInfo:termInfo];
	NSString *pluralName = [dataController pluralNameForTermInfo:termInfo];
	
	UITableViewCell *cell = nil;
	
	switch (fieldType) {
		case BTIActionFieldValueTypeDate:
		{
			cell = plainCell;
			
			[[cell textLabel] setText:singularName];
			[[cell detailTextLabel] setText:[scratchActionValue labelText]];
		}
			break;
		case BTIActionFieldValueTypePicker:
		{
			cell = plainCell;
			
			NSInteger numberOfPickerValues = [[scratchActionValue pickerValues] count];
			if (numberOfPickerValues > 1)
			{
				[[cell textLabel] setText:pluralName];
			}
			else
			{			
				[[cell textLabel] setText:singularName];
			}
			
			[[cell detailTextLabel] setText:[scratchActionValue labelText]];
		}
			break;
		case BTIActionFieldValueTypeLongText:
		{
			cell = plainCell;
			
			[[cell textLabel] setText:singularName];
			[[cell detailTextLabel] setText:[scratchActionValue labelText]];
		}
			break;
		case BTIActionFieldValueTypeBoolean:
		{
			cell = switchCell;
			
			[[cell textLabel] setText:singularName];
			[(UICustomSwitch *)[cell accessoryView] setOn:[[scratchActionValue boolean] boolValue] animated:NO];
		}
			break;
		case BTIActionFieldValueTypeImage:
		{
			cell = plainCell;
			
			[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
			
			[[cell imageView] setImage:[[scratchActionValue thumbnailImageMediaInfo] image]];
			
			[[cell textLabel] setText:singularName];
		}
			break;
		case BTIActionFieldValueTypeAudio:
		{
			cell = plainCell;
			
			[[cell textLabel] setText:singularName];
			[[cell detailTextLabel] setText:[scratchActionValue labelText]];
		}
			break;
		case BTIActionFieldValueTypeVideo:
		{
			cell = plainCell;
			
			[[cell textLabel] setText:singularName];
			[[cell detailTextLabel] setText:[scratchActionValue labelText]];
		}
			break;
		case BTIActionFieldValueTypeColor:
		{
			cell = plainCell;
			
			[[cell textLabel] setText:singularName];
			
			ColorInfo *colorInfo = [scratchActionValue colorInfo];
			
			if (colorInfo == nil)
			{
				[[cell imageView] setImage:nil];
				[[cell detailTextLabel] setText:nil];
			}
			else
			{
				[[cell imageView] setImage:[dataController thumbnailImageForColorInfo:colorInfo]];
				
				NSString *colorText = [colorInfo name];
				
				if ([[NSUserDefaults standardUserDefaults] btiShouldShowColorPointValues])
				{
					NSString *points = [NSNumberFormatter localizedStringFromNumber:[colorInfo pointValue] numberStyle:NSNumberFormatterDecimalStyle];
					colorText = [colorText stringByAppendingString:[NSString stringWithFormat:@" (%@)", points]];
				}
				
				[[cell detailTextLabel] setText:colorText];
			}
		}
			break;
		default:
			break;
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
	
	ActionFieldInfo *actionFieldInfo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	ActionFieldInfo *scratchActionFieldInfo = (ActionFieldInfo *)[[self scratchObjectContext] existingObjectWithID:[actionFieldInfo objectID] error:nil];
	NSInteger fieldType = [[actionFieldInfo type] integerValue];
	ActionValue *scratchActionValue = [[self scratchAction] actionValueForActionFieldInfo:scratchActionFieldInfo];
	
	switch (fieldType) {
		case BTIActionFieldValueTypeDate:
		{
			DateDetailViewController *nextViewController = [[DateDetailViewController alloc] init];
			[nextViewController setScratchActionValue:scratchActionValue];
			
			[[self navigationController] pushViewController:nextViewController animated:YES];
			
			[nextViewController release], nextViewController = nil;
		}
			break;
		case BTIActionFieldValueTypePicker:
		{
			ActionPickerValuesViewController *nextViewController = [[ActionPickerValuesViewController alloc] init];
			[nextViewController setScratchObjectContext:[self scratchObjectContext]];
			[nextViewController setActionFieldInfo:actionFieldInfo];
			[nextViewController setScratchActionValue:scratchActionValue];
			
			[[self navigationController] pushViewController:nextViewController animated:YES];
			
			[nextViewController release], nextViewController = nil;
		}
			break;
		case BTIActionFieldValueTypeLongText:
		{
			LongTextDetailViewController *nextViewController = [[LongTextDetailViewController alloc] init];
			[nextViewController setScratchActionValue:scratchActionValue];
			
			[[self navigationController] pushViewController:nextViewController animated:YES];
			
			[nextViewController release], nextViewController = nil;
		}
			break;
		case BTIActionFieldValueTypeBoolean:
		{

		}
			break;
		case BTIActionFieldValueTypeImage:
		{
			if ([[scratchActionValue imageMediaInfo] image] == nil)
			{
				[self tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
			}
			else
			{
				ActionImageViewController *nextViewController = [[ActionImageViewController alloc] init];
				[nextViewController setScratchObjectContext:[self scratchObjectContext]];
				[nextViewController setScratchActionValue:scratchActionValue];
				
				[[self navigationController] pushViewController:nextViewController animated:YES];
				
				[nextViewController release], nextViewController = nil;
			}
		}
			break;
		case BTIActionFieldValueTypeAudio:
		{

		}
			break;
		case BTIActionFieldValueTypeVideo:
		{

		}
			break;
		case BTIActionFieldValueTypeColor:
		{
			ColorInfoPickerViewController *nextViewController = [[ColorInfoPickerViewController alloc] init];
			[nextViewController setScratchObjectContext:[self scratchObjectContext]];
			[nextViewController setActionFieldInfo:actionFieldInfo];
			[nextViewController setScratchActionValue:scratchActionValue];
			
			[[self navigationController] pushViewController:nextViewController animated:YES];
			
			[nextViewController release], nextViewController = nil;
		}
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)tableView:(UITableView *)tableView 
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	ActionFieldInfo *actionFieldInfo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	ActionFieldInfo *scratchActionFieldInfo = (ActionFieldInfo *)[[self scratchObjectContext] existingObjectWithID:[actionFieldInfo objectID] error:nil];
	NSInteger fieldType = [[actionFieldInfo type] integerValue];
	ActionValue *scratchActionValue = [[self scratchAction] actionValueForActionFieldInfo:scratchActionFieldInfo];

	switch (fieldType) {
		case BTIActionFieldValueTypeDate:
			break;
		case BTIActionFieldValueTypePicker:
			break;
		case BTIActionFieldValueTypeLongText:
			break;
		case BTIActionFieldValueTypeBoolean:
			break;
		case BTIActionFieldValueTypeImage:
		{
			[self setScratchActiveImageActionValue:scratchActionValue];
			
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
			
			if ([scratchActionValue imageMediaInfo] != nil)
			{
				[sheet addButtonWithTitle:kImagePickerTitleDelete];
				[[self imagePickerTitles] addObject:kImagePickerTitleDelete];
			}
			
			[sheet setCancelButtonIndex:[sheet addButtonWithTitle:@"Cancel"]];
			
//			[sheet showFromToolbar:[[self navigationController] toolbar]];
			[sheet showInView:[self view]];
					
			[sheet release], sheet = nil;
		}
			break;
		case BTIActionFieldValueTypeAudio:
			break;
		case BTIActionFieldValueTypeVideo:
			break;
		case BTIActionFieldValueTypeColor:
			break;
		default:
			break;
	}
	
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
	NSManagedObjectContext *context = [dataController managedObjectContext];
		
//	UIImage *largeImage = [dataController removeOrientationFromImage:selectedImage];
	UIImage *largeImage = [dataController largeActionValueImageFromImage:selectedImage];
	UIImage *smallImage = [dataController smallActionValueImageFromImage:largeImage];
	
	MediaInfo *largeMediaInfo = [MediaInfo managedObjectInContextBTI:context];
	[largeMediaInfo setType:[NSNumber numberWithInt:BTIMediaTypeImage]];
	[largeMediaInfo setImage:largeImage];
	
	MediaInfo *smallMediaInfo = [MediaInfo managedObjectInContextBTI:context];
	[smallMediaInfo setType:[NSNumber numberWithInt:BTIMediaTypeImage]];
	[smallMediaInfo setImage:smallImage];
	
	[dataController addFileForMediaInfo:largeMediaInfo];
	[dataController addFileForMediaInfo:smallMediaInfo];
	
	[dataController saveCoreDataContext];
	
	MediaInfo *scratchLargeMediaInfo = (MediaInfo *)[[self scratchObjectContext] existingObjectWithID:[largeMediaInfo objectID] error:nil];
	MediaInfo *scratchSmallMediaInfo = (MediaInfo *)[[self scratchObjectContext] existingObjectWithID:[smallMediaInfo objectID] error:nil];
	
	[[self scratchActiveImageActionValue] setImageMediaInfo:scratchLargeMediaInfo];
	[[self scratchActiveImageActionValue] setThumbnailImageMediaInfo:scratchSmallMediaInfo];
	
	[scratchLargeMediaInfo setImage:nil];		// Just to reduce memory
	
	[[self mainTableView] reloadData];
	
	[self dismissModalViewControllerAnimated:YES];
	
	[self setImagePickerController:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self dismissModalViewControllerAnimated:YES];
	
	[self setImagePickerController:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (buttonIndex != [actionSheet cancelButtonIndex])
	{
		NSString *rowTitle = [[self imagePickerTitles] objectAtIndex:buttonIndex];
		
		if ([rowTitle isEqualToString:kImagePickerTitleDelete])
		{
			[[self scratchActiveImageActionValue] setImageMediaInfo:nil];
			[[self scratchActiveImageActionValue] setThumbnailImageMediaInfo:nil];
			
			[self setScratchActiveImageActionValue:nil];
			
			[[self mainTableView] reloadData];
		}
		else
		{			
			UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
			[self setImagePickerController:imagePicker];
			[imagePicker setMediaTypes:[NSArray arrayWithObject:(NSString *)kUTTypeImage]];
			[imagePicker setDelegate:self];
			
			NSLog(@"rowTitle is: %@", rowTitle);
			
			if ([rowTitle isEqualToString:kImagePickerTitleChoose])
			{
				[imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
			}
			else
			{
				[imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
			}
			
			[self presentModalViewController:imagePicker animated:YES];
			
			[imagePicker release], imagePicker = nil;
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
