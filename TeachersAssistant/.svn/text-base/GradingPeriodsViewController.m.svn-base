//
//  GradingPeriodsViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 1/31/12.
//  Copyright 2012 BriTer Ideas LLC. All rights reserved.
//

#import "GradingPeriodsViewController.h"

// Models and other global

// Sub-controllers
#import "GradingPeriodDetailViewController.h"

// Views

// Private Constants


@interface GradingPeriodsViewController ()

// Private Properties

// Notification Handlers



// UI Response Methods
- (void)addButtonPressed:(UIBarButtonItem *)button;


// Misc Methods

@end

@implementation GradingPeriodsViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;

// Private

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTableView:nil];
	
	
	// Private Properties
	
	
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

#pragma mark - Initialization and UI Creation Methods

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:[[DataController sharedDataController] pluralNameForTermInfoIndentifier:kTermInfoIdentifierGradingPeriod]];
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																			   target:self
																			   action:@selector(addButtonPressed:)];
	[[self navigationItem] setRightBarButtonItem:addButton];
	[addButton release], addButton = nil;
	
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	
	[self setToolbarItems:[NSArray arrayWithObjects:flexItem, [self editButtonItem], nil] animated:NO];
	
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
	
	[[DataController sharedDataController] resetPointTotalsForAllPersons];
	[[DataController sharedDataController] resetGradingPeriodActionTotalForAllPersons];
	
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



#pragma mark - UI Response Methods

- (void)addButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	GradingPeriodDetailViewController *nextViewController = [[GradingPeriodDetailViewController alloc] init];
	
	[[self navigationController] pushViewController:nextViewController animated:YES];
	
	[nextViewController release], nextViewController = nil;

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods


#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger sections = 1;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return sections;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger rows = [[[DataController sharedDataController] gradingPeriods] count];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		[cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	
	GradingPeriod *gradingPeriod = [[[DataController sharedDataController] gradingPeriods] objectAtIndex:[indexPath row]];
	
	[[cell textLabel] setText:[gradingPeriod name]];
	
	[cell setAccessoryType:([gradingPeriod isSelected]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
	
	if ([indexPath row] == 0)
	{
		[[cell detailTextLabel] setText:nil];
	}
	else
	{
		NSString *startDateString = [NSDateFormatter localizedStringFromDate:[gradingPeriod startDate] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
		NSString *endDateString = [NSDateFormatter localizedStringFromDate:[gradingPeriod endDate] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
		[[cell detailTextLabel] setText:[NSString stringWithFormat:@"%@ - %@", startDateString, endDateString]];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	// Assume "All Dates" is always the first row

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ([indexPath row] != 0);
}

- (BOOL)tableView:(UITableView *)tableView 
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Assume "All Dates" is always the first row
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ([indexPath row] != 0);
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		DataController *dataController = [DataController sharedDataController];
		
		GradingPeriod *periodToDelete = [[dataController gradingPeriods] objectAtIndex:[indexPath row]];
		
		if ([periodToDelete isEqual:[dataController activeGradingPeriod]])
		{
			GradingPeriod *allDatesPeriod = [[dataController gradingPeriods] objectAtIndex:0];
			[dataController setActiveGradingPeriod:allDatesPeriod];
			
			NSIndexPath *allDatesIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
			UITableViewCell *allDatesCell = [tableView cellForRowAtIndexPath:allDatesIndexPath];
			
			[allDatesCell setAccessoryType:UITableViewCellAccessoryCheckmark];
		}
		
		[[dataController gradingPeriods] removeObject:periodToDelete];
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		[dataController saveAllData];
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
	  toIndexPath:(NSIndexPath *)toIndexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	DataController *dataController = [DataController sharedDataController];
	
	GradingPeriod *movingPeriod = [[[dataController gradingPeriods] objectAtIndex:[fromIndexPath row]] retain];
	
	[[dataController gradingPeriods] removeObject:movingPeriod];
	[[dataController gradingPeriods] insertObject:movingPeriod atIndex:[toIndexPath row]];
	
	[movingPeriod release], movingPeriod = nil;
	
	[[dataController gradingPeriods] enumerateObjectsUsingBlock:^(GradingPeriod *gradingPeriod, NSUInteger index, BOOL *stop) {
		
		[gradingPeriod setSortOrder:[NSNumber numberWithInt:index]];
		
	}];
	
	[dataController saveAllData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UITableView Delegate Methods

- (NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
	   toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSIndexPath *pathToReturn = proposedDestinationIndexPath;

	if ([proposedDestinationIndexPath row] == 0)
	{
		pathToReturn = [NSIndexPath indexPathForRow:1 inSection:0];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return pathToReturn;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	DataController *dataController = [DataController sharedDataController];
	GradingPeriod *selectedGradingPeriod = [[dataController gradingPeriods] objectAtIndex:[indexPath row]];
	
	if ([self isEditing])
	{
		GradingPeriodDetailViewController *nextViewController = [[GradingPeriodDetailViewController alloc] init];
		[nextViewController setGradingPeriod:selectedGradingPeriod];
		
		[[self navigationController] pushViewController:nextViewController animated:YES];
		
		[nextViewController release], nextViewController = nil;
	}
	else
	{
		// Look for previously-selected GradingPeriod
		__block NSInteger oldRow = NSNotFound;
		[[dataController gradingPeriods] enumerateObjectsUsingBlock:^(GradingPeriod *gradingPeriod, NSUInteger index, BOOL *stop) {
			
			if ([gradingPeriod isSelected])
			{
				[gradingPeriod setSelected:NO];
				oldRow = index;
			}
			
		}];
		
		if (oldRow != NSNotFound)
		{
			NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldRow inSection:0];
			UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
			[oldCell setAccessoryType:UITableViewCellAccessoryNone];
		}
		
		DataController *dataController = [DataController sharedDataController];
		
		[dataController setActiveGradingPeriod:selectedGradingPeriod];
		
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
		
		[dataController saveAllData];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
