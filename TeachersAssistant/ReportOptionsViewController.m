//
//  ReportOptionsViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 2/1/12.
//  Copyright 2012 BriTer Ideas LLC. All rights reserved.
//

#import "ReportOptionsViewController.h"

// Models and other global

// Sub-controllers
#import "ReportClassPickerViewController.h"

// Views

// Private Constants

typedef enum {
	BTIReportSectionPersonMode = 0,
	BTIReportSectionGradingPeriod,
	BTIReportSectionsCount,
} BTIReportSections;


@interface ReportOptionsViewController ()

// Private Properties
@property (nonatomic, retain) NSIndexPath *personModeIndexPath;
@property (nonatomic, retain) NSIndexPath *gradingPeriodIndexPath;

// Notification Handlers



// UI Response Methods
- (void)continueButtonPressed:(UIBarButtonItem *)button;


// Misc Methods

@end

@implementation ReportOptionsViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;

// Private
@synthesize personModeIndexPath = ivPersonModeIndexPath;
@synthesize gradingPeriodIndexPath = ivGradingPeriodIndexPath;


#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTableView:nil];
	
	
	// Private Properties
    [self setPersonModeIndexPath:nil];
    [self setGradingPeriodIndexPath:nil];
	
	
	
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
	
	[self setTitle:@"Report Options"];
	
	UIBarButtonItem *continueButton = [[UIBarButtonItem alloc] initWithTitle:@"Continue"
																	   style:UIBarButtonItemStyleBordered
																	  target:self
																	  action:@selector(continueButtonPressed:)];
	[[self navigationItem] setRightBarButtonItem:continueButton];
	[continueButton release], continueButton = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self navigationController] setToolbarHidden:YES animated:YES];
	
	if ([self personModeIndexPath] == nil)
	{
		[self setPersonModeIndexPath:[NSIndexPath indexPathForRow:0 inSection:BTIReportSectionPersonMode]];
	}
	
	if ([self gradingPeriodIndexPath] == nil)
	{
		[self setGradingPeriodIndexPath:[NSIndexPath indexPathForRow:0 inSection:BTIReportSectionGradingPeriod]];
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

- (void)continueButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	ReportClassPickerViewController *nextViewController = [[ReportClassPickerViewController alloc] init];
	[nextViewController setReportMode:[[self personModeIndexPath] row]];
	[nextViewController setGradingPeriod:[[[DataController sharedDataController] gradingPeriods] objectAtIndex:[[self gradingPeriodIndexPath] row]]];
	
	[[self navigationController] pushViewController:nextViewController
										   animated:YES];
	
	[nextViewController release], nextViewController = nil;

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods


#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger sections = BTIReportSectionsCount;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return sections;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSString *header = nil;
	
	DataController *dataController = [DataController sharedDataController];

	switch (section) {
		case BTIReportSectionPersonMode:
			header = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
			break;
		case BTIReportSectionGradingPeriod:
		{
			header = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierGradingPeriod];
		}
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return header;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger rows = 0;
	
	switch (section) {
		case BTIReportSectionPersonMode:
		{
			rows = BTIReportModeTotal;
		}
			break;
		case BTIReportSectionGradingPeriod:
		{
			rows = [[[DataController sharedDataController] gradingPeriods] count];
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
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	[cell setAccessoryType:( [indexPath isEqual:[self personModeIndexPath]] || [indexPath isEqual:[self gradingPeriodIndexPath]] ) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
	
	switch (section) {
		case BTIReportSectionPersonMode:
		{
			[[cell detailTextLabel] setText:nil];
			
			NSString *actions = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierAction];
			
			switch (row) {
				case BTIReportModeAllPersons:
				{
					[[cell textLabel] setText:[NSString stringWithFormat:@"With and Without %@", actions]];
				}
					break;
				case BTIReportModePersonsWithActions:
				{
					[[cell textLabel] setText:[NSString stringWithFormat:@"With %@ Only", actions]];
				}
					break;
				default:
					break;
			}
		}
			break;
		case BTIReportSectionGradingPeriod:
		{
			GradingPeriod *gradingPeriod = [[dataController gradingPeriods] objectAtIndex:row];
			
			[[cell textLabel] setText:[gradingPeriod name]];
			
			if (row == 0)
			{
				[[cell detailTextLabel] setText:nil];
			}
			else
			{
				NSString *startDateString = [NSDateFormatter localizedStringFromDate:[gradingPeriod startDate] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
				NSString *endDateString = [NSDateFormatter localizedStringFromDate:[gradingPeriod endDate] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
				[[cell detailTextLabel] setText:[NSString stringWithFormat:@"%@ - %@", startDateString, endDateString]];
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
	
	NSIndexPath *oldIndexPath = nil;
	
	switch ([indexPath section]) {
		case BTIReportSectionPersonMode:
		{
			oldIndexPath = [[[self personModeIndexPath] retain] autorelease];
			[self setPersonModeIndexPath:indexPath];
		}
			break;
		case BTIReportSectionGradingPeriod:
		{
			oldIndexPath = [[[self gradingPeriodIndexPath] retain] autorelease];
			[self setGradingPeriodIndexPath:indexPath];
		}
			break;
		default:
			break;
	}
	
	NSLog(@"oldIndexPath is: %@", [oldIndexPath description]);
	
	UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	[oldCell setAccessoryType:UITableViewCellAccessoryNone];
	[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
