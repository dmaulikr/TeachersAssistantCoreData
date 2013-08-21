//
//  PersonFilterColorViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 10/3/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "PersonFilterColorViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface PersonFilterColorViewController ()

// Private Properties
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) ColorInfo *selectedColorInfo;

// Notification Handlers



// UI Response Methods
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)saveButtonPressed:(UIBarButtonItem *)button;


// Misc Methods

@end

@implementation PersonFilterColorViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize actionFieldInfo = ivActionFieldInfo;
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
	[self setActionFieldInfo:nil];
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
		
//		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"actionFieldInfo == %@", [self actionFieldInfo]]];
		
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
	
	NSLog(@"selectedColorInfo is: %@", [self selectedColorInfo]);
	
	DataController *dataController = [DataController sharedDataController];
	NSManagedObjectContext *context = [dataController managedObjectContext];
	
	if ([self actionValue] == nil)
	{
		ActionValue *newActionValue = [ActionValue managedObjectInContextBTI:context];
		[newActionValue setActionFieldInfo:[self actionFieldInfo]];
		[newActionValue setAction:[dataController filterAction]];
			
		[newActionValue setColorInfo:[self selectedColorInfo]];
		
		[self setActionValue:newActionValue];
	}
	
	NSLog(@"actionValue is: %@", [self actionValue]);
	NSLog(@"selectedColorInfo is: %@", [self selectedColorInfo]);
	
	if ([self selectedColorInfo] != nil)
	{
		NSLog(@"Save it");
		[[self actionValue] setColorInfo:[self selectedColorInfo]];
	}
	else
	{
		NSLog(@"Delete it");
		[[dataController managedObjectContext] deleteObject:[self actionValue]];
	}
		
	[dataController saveCoreDataContext];
	
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
		colorText = [colorText stringByAppendingString:[NSString stringWithFormat:@" (%d)", [[colorInfo pointValue] intValue]]];
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
		UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
		[newCell setAccessoryType:UITableViewCellAccessoryCheckmark];
		
		[self setSelectedColorInfo:colorInfo];
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
