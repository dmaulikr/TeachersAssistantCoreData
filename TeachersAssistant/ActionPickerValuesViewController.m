//
//  ActionPickerValuesViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/18/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ActionPickerValuesViewController.h"

// Models and other global

// Sub-controllers
#import "PickerInfoViewController.h"

// Views

// Private Constants


@interface ActionPickerValuesViewController ()

// Private Properties
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSMutableSet *selectionSet;

// Notification Handlers



// UI Response Methods
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)saveButtonPressed:(UIBarButtonItem *)button;
- (void)addButtonPressed:(UIBarButtonItem *)button;


// Misc Methods

@end

@implementation ActionPickerValuesViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize scratchObjectContext = ivScratchObjectContext;
@synthesize actionFieldInfo = ivActionFieldInfo;
@synthesize scratchActionValue = ivScratchActionValue;
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
    [self setScratchObjectContext:nil];
    [self setActionFieldInfo:nil];
    [self setScratchActionValue:nil];
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

- (void)setScratchActionValue:(ActionValue *)scratchActionValue
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[scratchActionValue retain];
	[ivScratchActionValue release];
	ivScratchActionValue = scratchActionValue;
	
	if (scratchActionValue != nil)
	{
		DataController *dataController = [DataController sharedDataController];
		NSManagedObjectContext *context = [dataController managedObjectContext];
		
		NSLog(@"scratchActionValue is: %@", [[self scratchActionValue] description]);
		
		for (PickerValue *scratchPickerValue in [scratchActionValue pickerValues])
		{
			PickerValue *pickerValue = (PickerValue *)[context existingObjectWithID:[scratchPickerValue objectID] error:nil];
			NSLog(@"scratchPickerValue is: %@", [scratchPickerValue description]);
			NSLog(@"pickerValue is: %@", [pickerValue description]);
			
			[[self selectionSet] addObject:pickerValue];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

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
		[ivFetchedResultsController setDelegate:self];
		
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
	
	[[self mainTableView] setAllowsSelectionDuringEditing:YES];
	
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
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																			   target:self
																			   action:@selector(addButtonPressed:)];
	[addButton setStyle:UIBarButtonItemStyleBordered];
	
	NSArray *items = [NSArray arrayWithObjects:[self editButtonItem], flexItem, addButton, nil];
	
	[self setToolbarItems:items];
	
	[flexItem release], flexItem = nil;
	[addButton release], addButton = nil;
	
    DataController *dataController = [DataController sharedDataController];
	
	[self setTitle:[dataController singularNameForTermInfo:[[self actionFieldInfo] termInfo]]];
	
	NSInteger numberOfRows = MAX(6, [[[self fetchedResultsController] fetchedObjects] count] + 1);
    
    [self setContentSizeForViewInPopover:CGSizeMake(320.0, [[self mainTableView] rowHeight] * numberOfRows)];

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

	NSLog(@"scratchActionValue is: %@", [[self scratchActionValue] description]);
	
	if ([self actionValue] != nil)
	{
		[[self actionValue] removePickerValues:[[self actionValue] pickerValues]];
		
		[[self actionValue] addPickerValues:[self selectionSet]];
	}
	else
	{
		[[self scratchActionValue] removePickerValues:[[self scratchActionValue] pickerValues]];
		
		for (PickerValue *pickerValue in [self selectionSet])
		{
			PickerValue *scratchPickerValue = (PickerValue *)[[self scratchObjectContext] existingObjectWithID:[pickerValue objectID] error:nil];
			
			[[self scratchActionValue] addPickerValuesObject:scratchPickerValue];
		}
	}
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kPopoverShouldFinishNotification object:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)addButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	PickerInfoViewController *nextViewController = [[PickerInfoViewController alloc] init];
	[nextViewController setDelegate:self];
	[nextViewController setActionFieldInfo:[self actionFieldInfo]];
	
	[[self navigationController] pushViewController:nextViewController animated:YES];
	
	[nextViewController release], nextViewController = nil;
	
	NSLog(@"scratchActionValue is: %@", [[self scratchActionValue] description]);
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (void)addPickerValueToSelection:(PickerValue *)pickerValue
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if (![[self selectionSet] containsObject:pickerValue])
	{
		[[self selectionSet] addObject:pickerValue];
	}
	
	NSLog(@"pickerValue is: %@", [pickerValue description]);
	
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
	
	PickerValue *pickerValue = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		[cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	
	[[cell textLabel] setText:[pickerValue name]];
	
	ColorInfo *colorInfo = [pickerValue colorInfo];
	
	[[cell imageView] setImage:[[DataController sharedDataController] thumbnailImageForColorInfo:colorInfo]];
	
	if ([[NSUserDefaults standardUserDefaults] btiShouldShowColorPointValues])
	{
		[[cell detailTextLabel] setText:[NSNumberFormatter localizedStringFromNumber:[colorInfo pointValue] numberStyle:NSNumberFormatterDecimalStyle]];
	}
	
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

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
	  toIndexPath:(NSIndexPath *)toIndexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	NSMutableArray *pickerValues = [NSMutableArray arrayWithArray:[[self fetchedResultsController] fetchedObjects]];
	
	PickerValue *pickerValue = [pickerValues objectAtIndex:[fromIndexPath row]];
	[pickerValues removeObjectAtIndex:[fromIndexPath row]];
	[pickerValues insertObject:pickerValue atIndex:[toIndexPath row]];
	
	[[self fetchedResultsController] setDelegate:nil];
	
	[pickerValues enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		PickerValue *pickerValue = (PickerValue *)object;
		[pickerValue setSortOrder:[NSNumber numberWithInt:index]];
		
	}];
    
	[[DataController sharedDataController] saveCoreDataContext];
	
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
		PickerValue *pickerValue = [[self fetchedResultsController] objectAtIndexPath:indexPath];
		
		DataController *dataController = [DataController sharedDataController];
		NSManagedObjectContext *context = [dataController managedObjectContext];
		
		PickerValue *scratchPickerValue = (PickerValue *)[[self scratchObjectContext] existingObjectWithID:[pickerValue objectID] error:nil];

		[[self selectionSet] removeObject:pickerValue];
		
		[[self scratchObjectContext] deleteObject:scratchPickerValue];
		[context deleteObject:pickerValue];
		
		[dataController saveCoreDataContext];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	PickerValue *pickerValue = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	if ([tableView isEditing])
	{
		PickerInfoViewController *nextViewController = [[PickerInfoViewController alloc] init];
		[nextViewController setDelegate:self];
		[nextViewController setActionFieldInfo:[self actionFieldInfo]];
		[nextViewController setPickerValue:pickerValue];
		
		[[self navigationController] pushViewController:nextViewController animated:YES];
		
		[nextViewController release], nextViewController = nil;
		
		NSLog(@"scratchActionValue is: %@", [[self scratchActionValue] description]);
	}
	else
	{
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
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
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
			//			[self configureCell:(CategoryCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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


@end
