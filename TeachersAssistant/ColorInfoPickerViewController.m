//
//  ColorInfoPickerViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/29/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ColorInfoPickerViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface ColorInfoPickerViewController ()

// Private Properties
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) ColorInfo *selectedColorInfo;

// Notification Handlers



// UI Response Methods
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)saveButtonPressed:(UIBarButtonItem *)button;


// Misc Methods

@end

@implementation ColorInfoPickerViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize scratchObjectContext = ivScratchObjectContext;
@synthesize actionFieldInfo = ivActionFieldInfo;
@synthesize scratchActionValue = ivScratchActionValue;
@synthesize actionValue = ivActionValue;

// Private
@synthesize fetchedResultsController = ivFetchedResultsController;
@synthesize selectedColorInfo = ivSelectedColorInfo;

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
	[self setSelectedColorInfo:nil];
	
	
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
		[self setSelectedColorInfo:[actionValue colorInfo]];
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)setScratchActionValue:(ActionValue *)scratchActionValue
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[scratchActionValue retain];
	[ivScratchActionValue release];
	ivScratchActionValue = scratchActionValue;
	
	if (scratchActionValue != nil)
	{
		ColorInfo *scratchColorInfo = [scratchActionValue colorInfo];
		if (scratchColorInfo != nil)
		{
			DataController *dataController = [DataController sharedDataController];
			NSManagedObjectContext *context = [dataController managedObjectContext];
			
			ColorInfo *colorInfo = (ColorInfo *)[context existingObjectWithID:[scratchColorInfo objectID] error:nil];
			[self setSelectedColorInfo:colorInfo];
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
		
		[fetchRequest setEntity:[ColorInfo entityDescriptionInContextBTI:context]];
		
		[fetchRequest setSortDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
			
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

#pragma mark - Initialization and UI Creation Methods

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	DataController *dataController = [DataController sharedDataController];
	
	[self setTitle:[dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierColorLabel]];
	
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
	
	NSInteger numberOfRows = MAX(4, [[[self fetchedResultsController] fetchedObjects] count]);
    
    [self setContentSizeForViewInPopover:CGSizeMake(320.0, [[self mainTableView] rowHeight] * numberOfRows)];

	
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
	
	NSLog(@"scratchActionValue is: %@", [[self scratchActionValue] description]);
	
	if ([self actionValue] != nil)
	{
		[[self actionValue] setColorInfo:[self selectedColorInfo]];
	}
	else
	{
		if ([self selectedColorInfo] == nil)
		{
			[[self scratchActionValue] setColorInfo:nil];
		}
		else
		{
			ColorInfo *scratchColorInfo = (ColorInfo *)[[self scratchObjectContext] existingObjectWithID:[[self selectedColorInfo] objectID] error:nil];
			[[self scratchActionValue] setColorInfo:scratchColorInfo];
		}
	}
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kPopoverShouldFinishNotification object:nil];
	
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
	
	ColorInfo *colorInfo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	[[cell imageView] setImage:[[DataController sharedDataController] thumbnailImageForColorInfo:colorInfo]];
	
	NSString *colorText = [colorInfo name];
	
	if ([[NSUserDefaults standardUserDefaults] btiShouldShowColorPointValues])
	{
		NSString *points = [NSNumberFormatter localizedStringFromNumber:[colorInfo pointValue] numberStyle:NSNumberFormatterDecimalStyle];
		colorText = [colorText stringByAppendingString:[NSString stringWithFormat:@" (%@)", points]];
	}
	
	[[cell textLabel] setText:colorText];
	
	if ([colorInfo isEqual:[self selectedColorInfo]])
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
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	ColorInfo *colorInfo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	if ([self selectedColorInfo] == nil)
	{
		[self setSelectedColorInfo:colorInfo];
		UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
		[newCell setAccessoryType:UITableViewCellAccessoryCheckmark];
	}
	else
	{
		if ([[self selectedColorInfo] isEqual:colorInfo])
		{
			UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:indexPath];
			[oldCell setAccessoryType:UITableViewCellAccessoryNone];
			[self setSelectedColorInfo:nil];
		}
		else
		{
			NSIndexPath *oldIndexPath = [[self fetchedResultsController] indexPathForObject:[self selectedColorInfo]];
			UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
			[oldCell setAccessoryType:UITableViewCellAccessoryNone];
			
			UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
			[newCell setAccessoryType:UITableViewCellAccessoryCheckmark];
			
			[self setSelectedColorInfo:colorInfo];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
