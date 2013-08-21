//
//  PersonFilterPickerInfoViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/23/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "PersonFilterPickerInfoViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface PersonFilterPickerInfoViewController ()

// Private Properties
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSMutableSet *selectionSet;

// Notification Handlers



// UI Response Methods
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)saveButtonPressed:(UIBarButtonItem *)button;


// Misc Methods

@end

@implementation PersonFilterPickerInfoViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize actionFieldInfo = ivActionFieldInfo;
@synthesize actionValue = ivActionValue;

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
	[self setActionFieldInfo:nil];
	[self setActionValue:nil];
	
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

- (void)setActionValue:(ActionValue *)actionValue
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[actionValue retain];
	[ivActionValue release];
	ivActionValue = actionValue;
	
	if (actionValue != nil)
	{
		for (PickerValue *pickerValue in [actionValue pickerValues])
		{
			[[self selectionSet] addObject:pickerValue];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSFetchedResultsController *)fetchedResultsController
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivFetchedResultsController == nil)
	{
		DataController *dataController = [DataController sharedDataController];
		NSManagedObjectContext *context = [dataController managedObjectContext];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		[fetchRequest setEntity:[PickerValue entityDescriptionInContextBTI:context]];
		
		[fetchRequest setSortDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
		
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"actionFieldInfo == %@", [self actionFieldInfo]]];
		
		ivFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																		 managedObjectContext:context
																		   sectionNameKeyPath:nil
																					cacheName:nil];
		
		[ivFetchedResultsController performFetchBTI];
		
		[fetchRequest release], fetchRequest = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivFetchedResultsController;
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
	
	DataController *dataController = [DataController sharedDataController];
	
	[self setTitle:[dataController singularNameForTermInfo:[[self actionFieldInfo] termInfo]]];
	
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
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kPopoverShouldFinishNotification object:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)saveButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	DataController *dataController = [DataController sharedDataController];
	NSManagedObjectContext *context = [dataController managedObjectContext];
	
	if ([[self selectionSet] count] > 0)
	{
		if ([self actionValue] == nil)
		{
			ActionValue *newActionValue = [ActionValue managedObjectInContextBTI:context];
			[newActionValue setActionFieldInfo:[self actionFieldInfo]];
			[newActionValue setAction:[dataController filterAction]];
			
			[self setActionValue:newActionValue];
		}
		
		[[self actionValue] removePickerValues:[[self actionValue] pickerValues]];
	
		[[self actionValue] addPickerValues:[self selectionSet]];
	}
	else
	{
		if ([self actionValue] != nil)
		{
			[[dataController managedObjectContext] deleteObject:[self actionValue]];
		}
	}
	
	NSLog(@"filterAction is: %@", [[dataController filterAction] description]);
	
	[dataController saveCoreDataContext];
	
	NSLog(@"filterAction is: %@", [[dataController filterAction] description]);
	
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
	
	PickerValue *pickerValue = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	
	[[cell textLabel] setText:[pickerValue name]];
	
	if ([[self selectionSet] containsObject:pickerValue])
	{
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	}
	else
	{
		[cell setAccessoryType:UITableViewCellAccessoryNone];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	PickerValue *pickerValue = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	if ([[self selectionSet] containsObject:pickerValue])
	{
		[[self selectionSet] removeObject:pickerValue];
		[cell setAccessoryType:UITableViewCellAccessoryNone];
	}
	else
	{
		[[self selectionSet] addObject:pickerValue];
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
