//
//  HomeViewController.m
//  infraction
//
//  Created by Brian Slick on 7/18/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "HomeViewController.h"

// Models and other global

// Sub-controllers
#import "AllPersonsViewController.h"
#import "AllClassPeriodsViewController.h"
#import "SettingsViewController.h"
#import "ActionDetailViewController.h"
#import "AssignActionsFillerViewController.h"
#import "DiagnosticViewController.h"
#import "ResourcesViewController.h"
#import "EmailBlastClassPickerViewController.h"
#import "RandomClassPickerViewController.h"

// Views

// Private Constants
#define kPersonsRow						@"Students"
#define kClassesRow						@"Classes"
#define kActionRow						@"Action"
#define kEmailBlastRow					@"Email Blast"
#define kSettingsRow					@"Settings"
#define kResourcesRow					@"Resources"
#define kDiagnosticsRow					@"Diagnostics"
#define kRandomizeRow					@"Randomizer"

@interface HomeViewController ()

// Private Properties
@property (nonatomic, retain) NSMutableArray *contents;

// Notification Handlers
- (void)dataWasImported:(NSNotification *)notification;


// UI Response Methods



// Misc Methods

@end

@implementation HomeViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize versionLabel = ivVersionLabel;

// Private
@synthesize contents = ivContents;

#pragma mark -
#pragma mark Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTableView:nil];
	[self setVersionLabel:nil];
	
	// Private Properties
	[self setContents:nil];
	
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	[self setMainTableView:nil];
	[self setVersionLabel:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

- (NSMutableArray *)contents
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if (ivContents == nil)
	{
		ivContents = [[NSMutableArray alloc] init];
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivContents;
}

#pragma mark - Initialization and UI Creation Methods


#pragma mark - UIViewController Overrides

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	if ([[DataController sharedDataController] isLiteVersion])
	{
		[self setTitle:@"Teacher's Assistant Lite"];
	}
	else
	{
		[self setTitle:@"Teacher's Assistant"];
	}
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home"
																   style:UIBarButtonItemStyleBordered
																  target:nil
																  action:nil];
	[[self navigationItem] setBackBarButtonItem:backButton];
	[backButton release], backButton = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self navigationController] setToolbarHidden:YES animated:YES];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataWasImported:) name:kDidImportDataNotification object:nil];
	
	// Obtain version number
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//	NSLog(@"infoDictionary: %@", [infoDictionary description]);
	NSString *version = [infoDictionary objectForKey:(NSString *)kCFBundleVersionKey];
//	NSLog(@"version is: %@", version);
	[[self versionLabel] setText:[NSString stringWithFormat:@"Version: %@", version]];	
	
	[[self contents] removeAllObjects];
	
	[[self contents] addObject:kPersonsRow];
	[[self contents] addObject:kClassesRow];
	[[self contents] addObject:kRandomizeRow];
	[[self contents] addObject:kActionRow];
	
	if ([MFMailComposeViewController canSendMail])
	{
		[[self contents] addObject:kEmailBlastRow];
	}
	
	[[self contents] addObject:kSettingsRow];
	[[self contents] addObject:kResourcesRow];
//	[[self contents] addObject:kDiagnosticsRow];
	
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
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kDidImportDataNotification object:nil];
	
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

- (void)dataWasImported:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[self mainTableView] reloadData];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UI Response Methods



#pragma mark - Misc Methods

- (void)pushToJumpDestination
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSString *targetSectionKey = nil;
	
	switch ([[NSUserDefaults standardUserDefaults] btiJumpButtonMode]) {
		case BTIJumpButtonModeClasses:
			targetSectionKey = kClassesRow;
			break;
		case BTIJumpButtonModeStudents:
			targetSectionKey = kPersonsRow;
			break;
		default:
			break;
	}

	if (targetSectionKey != nil)
	{
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[[self contents] indexOfObject:targetSectionKey]];
		[self tableView:[self mainTableView] didSelectRowAtIndexPath:indexPath];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)pushToEmailBlast
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *targetSectionKey = kEmailBlastRow;
	
	if (targetSectionKey != nil)
	{
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[[self contents] indexOfObject:targetSectionKey]];
		[self tableView:[self mainTableView] didSelectRowAtIndexPath:indexPath];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger sections = [[self contents] count];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return sections;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger rows = 1;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *sectionContent = [[self contents] objectAtIndex:[indexPath section]];
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	
	[[cell textLabel] setText:sectionContent];
 
	DataController *dataController = [DataController sharedDataController];
	NSManagedObjectContext *context = [dataController managedObjectContext];
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	if ([sectionContent isEqualToString:kClassesRow])
	{
		NSString *classes = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierClass];
		NSInteger numberOfClasses = [dataController countOfClassPeriods];
		
		[[cell textLabel] setText:[NSString stringWithFormat:@"%@: %d", classes, numberOfClasses]];
	}
	else if ([sectionContent isEqualToString:kPersonsRow])
	{
		[fetchRequest setEntity:[Person entityDescriptionInContextBTI:context]];
		
		NSString *people = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
		NSInteger numberOfPeople = [context countForFetchRequest:fetchRequest error:nil];
		
		[[cell textLabel] setText:[NSString stringWithFormat:@"%@: %d", people, numberOfPeople]];
	}
	else if ([sectionContent isEqualToString:kActionRow])
	{
		[[cell textLabel] setText:[NSString stringWithFormat:@"Add %@", [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierAction]]];
	}
	else if ([sectionContent isEqualToString:kRandomizeRow])
	{
		[[cell textLabel] setText:[dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierRandomizer]];
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
	
	NSString *sectionContent = [[self contents] objectAtIndex:[indexPath section]];
	
	id viewController = nil;
	
	if ([sectionContent isEqualToString:kPersonsRow])
	{
		viewController = [[[AllPersonsViewController alloc] init] autorelease];
	}
	else if ([sectionContent isEqualToString:kClassesRow])
	{
        viewController = [[[AllClassPeriodsViewController alloc] init] autorelease];
	}
	else if ([sectionContent isEqualToString:kSettingsRow])
	{
		viewController = [[[SettingsViewController alloc] init] autorelease];
	}
	else if ([sectionContent isEqualToString:kResourcesRow])
	{
		viewController = [[[ResourcesViewController alloc] init] autorelease];
	}
	else if ([sectionContent isEqualToString:kActionRow])
	{
		if ([[DataController sharedDataController] isIPadVersion])
		{
			[[NSNotificationCenter defaultCenter] postNotificationName:kShouldShowActionDetailViewNotification object:nil];
			viewController = [[[AssignActionsFillerViewController alloc] init] autorelease];
		}
		else
		{
			viewController = [[[ActionDetailViewController alloc] init] autorelease];
		}
	}
	else if ([sectionContent isEqualToString:kDiagnosticsRow])
	{
		viewController = [[[DiagnosticViewController alloc] init] autorelease];
	}
	else if ([sectionContent isEqualToString:kEmailBlastRow])
	{
		viewController = [[[EmailBlastClassPickerViewController alloc] init] autorelease];
	}
	else if ([sectionContent isEqualToString:kRandomizeRow])
	{
		viewController = [[[RandomClassPickerViewController alloc] init] autorelease];
	}
	
	if (viewController != nil)
	{
		[[self navigationController] pushViewController:viewController animated:YES];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
