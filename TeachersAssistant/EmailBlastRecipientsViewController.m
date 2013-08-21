//
//  EmailBlastRecipientsViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 12/17/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "EmailBlastRecipientsViewController.h"

// Models and other global
#import "BTITableSectionInfo.h"

// Sub-controllers
#import "PersonInfoViewController.h"

// Views

// Private Constants


@interface EmailBlastRecipientsViewController ()

// Private Properties
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSMutableArray *sections;

// Notification Handlers



// UI Response Methods
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)saveButtonPressed:(UIBarButtonItem *)button;
- (void)allButtonPressed:(UIBarButtonItem *)button;
- (void)noneButtonPressed:(UIBarButtonItem *)button;

// Misc Methods

@end

@implementation EmailBlastRecipientsViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize classPeriod = ivClassPeriod;

// Private
@synthesize fetchedResultsController = ivFetchedResultsController;
@synthesize sections = ivSections;

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
	[self setSections:nil];
	
	
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
		
//		NSString *sectionNameKeyPath = nil;
		
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
		
		if ([self classPeriod] != nil)
		{
			[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"ANY classPeriods == %@", [self classPeriod]]];
		}
		
		ivFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																		 managedObjectContext:context
																		   sectionNameKeyPath:nil		//sectionNameKeyPath
																					cacheName:nil];
		
		[ivFetchedResultsController performFetchBTI];
		
		[fetchRequest release], fetchRequest = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivFetchedResultsController;
}

- (NSMutableArray *)sections
{
	if (ivSections == nil)
	{
		ivSections = [[NSMutableArray alloc] init];
	}
	return ivSections;
}

#pragma mark - Initialization and UI Creation Methods


#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:@"Recipients"];
	
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
	
	UIBarButtonItem *allButton = [[UIBarButtonItem alloc] initWithTitle:@"Select All"
																  style:UIBarButtonItemStyleBordered
																 target:self
																 action:@selector(allButtonPressed:)];
	
	UIBarButtonItem *noneButton = [[UIBarButtonItem alloc] initWithTitle:@"Select None"
																   style:UIBarButtonItemStyleBordered
																  target:self
																  action:@selector(noneButtonPressed:)];
	
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	
	[self setToolbarItems:[NSArray arrayWithObjects:noneButton, flexItem, allButton, nil]];
	
	[allButton release], allButton = nil;
	[noneButton release], noneButton = nil;
	[flexItem release], flexItem = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self navigationController] setToolbarHidden:NO animated:YES];
	
	[self setEditing:YES animated:NO];
	
	// Fetch students
	
	[[self sections] removeAllObjects];
	
	DataController *dataController = [DataController sharedDataController];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	[[[self fetchedResultsController] fetchedObjects] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		
		Person *person = (Person *)obj;
		
		BTITableSectionInfo *sectionInfo = [[BTITableSectionInfo alloc] init];
		
		switch ([userDefaults btiPersonDisplayMode]) {
			case BTIPersonSortModeFirstLast:
				[sectionInfo setSectionName:[person fullName]];
				break;
			case BTIPersonSortModeLastFirst:
				[sectionInfo setSectionName:[person reverseFullName]];
				break;
			default:
				break;
		}
		
		for (Parent *parent in [person parents])
		{
			[sectionInfo addObjectsToContents:[parent emailAddresses]];
		}
		
		[sectionInfo sortContentsUsingDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
		
		[[self sections] addObject:sectionInfo];
		
		[sectionInfo release], sectionInfo = nil;
		
	}];
	
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
	
	[[DataController sharedDataController] saveCoreDataContext];
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)allButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	for (BTITableSectionInfo *sectionInfo in [self sections])
	{
		for (EmailAddress *emailAddress in [sectionInfo contentsEnumerator])
		{
			[emailAddress setIsDefault:[NSNumber numberWithBool:YES]];
		}
	}
	
	[[self mainTableView] reloadData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)noneButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	for (BTITableSectionInfo *sectionInfo in [self sections])
	{
		for (EmailAddress *emailAddress in [sectionInfo contentsEnumerator])
		{
			[emailAddress setIsDefault:[NSNumber numberWithBool:NO]];
		}
	}
	
	[[self mainTableView] reloadData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods


#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger sections = [[self sections] count];;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return sections;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	BTITableSectionInfo *sectionInfo = [[self sections] objectAtIndex:section];
	
	NSString *header = [sectionInfo name];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return header;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	BTITableSectionInfo *sectionInfo = [[self sections] objectAtIndex:section];
	
	NSInteger rows = [sectionInfo countOfContents] + 1;
	
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
	}
	
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	
	BTITableSectionInfo *sectionInfo = [[self sections] objectAtIndex:section];
	
	if (row == [sectionInfo countOfContents])
	{
		NSString *parent = [[DataController sharedDataController] singularNameForTermInfoIndentifier:kTermInfoIdentifierParent];
		[[cell textLabel] setText:[NSString stringWithFormat:@"Add %@/Email Address", parent]];
		[[cell detailTextLabel] setText:nil];
		
		[cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	else
	{
		EmailAddress *emailAddress = [sectionInfo objectInContentsAtIndex:row];
		Parent *parent = [emailAddress parent];
		
		[[cell textLabel] setText:[parent name]];
		[[cell detailTextLabel] setText:[NSString stringWithFormat:@"   (%@) %@", [emailAddress type], [emailAddress value]]];
		
		[cell setEditingAccessoryType:([[emailAddress isDefault] boolValue]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
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
	
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	
	BTITableSectionInfo *sectionInfo = [[self sections] objectAtIndex:section];
	
	if (row == [sectionInfo countOfContents])
	{
		NSIndexPath *personIndexPath = [NSIndexPath indexPathForRow:section inSection:0];
		Person *person = [[self fetchedResultsController] objectAtIndexPath:personIndexPath];
		
		PersonInfoViewController *nextViewController = [[PersonInfoViewController alloc] init];
		[nextViewController setPerson:person];
		
		[[self navigationController] pushViewController:nextViewController animated:YES];
		
		[nextViewController release], nextViewController = nil;
	}
	else
	{
		EmailAddress *emailAddress = [sectionInfo objectInContentsAtIndex:[indexPath row]];
		
		[emailAddress setIsDefault:[NSNumber numberWithBool:![[emailAddress isDefault] boolValue]]];
		
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		
		[cell setEditingAccessoryType:([[emailAddress isDefault] boolValue]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
		   editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;

	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	
	BTITableSectionInfo *sectionInfo = [[self sections] objectAtIndex:section];
	
	if (row == [sectionInfo countOfContents])
	{
		style = UITableViewCellEditingStyleInsert;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return style;
}

- (BOOL)tableView:(UITableView *)tableView
shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return NO;
}


@end
