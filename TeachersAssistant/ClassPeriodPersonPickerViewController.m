//
//  ClassPeriodPersonPickerViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/21/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ClassPeriodPersonPickerViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface ClassPeriodPersonPickerViewController ()

// Private Properties
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSMutableSet *selectionSet;

// Notification Handlers



// UI Response Methods
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)saveButtonPressed:(UIBarButtonItem *)button;


// Misc Methods

@end

@implementation ClassPeriodPersonPickerViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize classPeriod = ivClassPeriod;

// Private
@synthesize fetchedResultsController = ivFetchedResultsController;
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

- (void)setClassPeriod:(ClassPeriod *)classPeriod
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[classPeriod retain];
	[ivClassPeriod release];
	ivClassPeriod = classPeriod;
	
	[[self selectionSet] unionSet:[classPeriod persons]];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSMutableSet *)selectionSet
{
	if (ivSelectionSet == nil)
	{
		ivSelectionSet = [[NSMutableSet alloc] init];
	}
	return ivSelectionSet;
}

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

#pragma mark - Initialization and UI Creation Methods


#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:[[DataController sharedDataController] pluralNameForTermInfoIndentifier:kTermInfoIdentifierPerson]];
	
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
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self navigationController] setToolbarHidden:YES animated:YES];
	
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

- (void)cancelButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)saveButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self classPeriod] removePersons:[[self classPeriod] persons]];
	
	[[self classPeriod] addPersons:[self selectionSet]];
	
	[[DataController sharedDataController] saveCoreDataContext];
	
	[[self navigationController] popViewControllerAnimated:YES];
	
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

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
    NSString *header = [NSString stringWithFormat:@"Select %@ for %@", [[DataController sharedDataController] pluralNameForTermInfoIndentifier:kTermInfoIdentifierPerson], [[self classPeriod] name]];
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
    return header;
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
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	Person *person = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
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
	
	if ([[self selectionSet] containsObject:person])
	{
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
		[[cell textLabel] setTextColor:[UIColor blackColor]];
	}
	else
	{
		[cell setAccessoryType:UITableViewCellAccessoryNone];
        [[cell textLabel] setTextColor:[UIColor lightGrayColor]];
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
	
	Person *person = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	if ([[self selectionSet] containsObject:person])
	{
		[[self selectionSet] removeObject:person];
		[cell setAccessoryType:UITableViewCellAccessoryNone];
		[[cell textLabel] setTextColor:[UIColor lightGrayColor]];
	}
	else
	{
		[[self selectionSet] addObject:person];
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
		[[cell textLabel] setTextColor:[UIColor blackColor]];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
