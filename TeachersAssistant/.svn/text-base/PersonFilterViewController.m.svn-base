//
//  PersonFilterViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/23/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "PersonFilterViewController.h"

// Models and other global

// Sub-controllers
#import "PersonFilterPickerInfoViewController.h"
#import "PersonFilterDateViewController.h"
#import "PersonFilterBooleanViewController.h"
#import "PersonFilterColorViewController.h"
#import "BTIPersonFilterPointsViewController.h"

// Views

// Private Constants
#define kFilterSectionKeyActions						@"kFilterSectionKeyActions"
#define kFilterSectionKeyPoints							@"kFilterSectionKeyPoints"

#define kFilterRowKeyPoints								@"kFilterRowKeyPoints"

@interface PersonFilterViewController ()

// Private Properties
@property (nonatomic, retain) NSMutableArray *sectionKeys;
@property (nonatomic, retain) NSMutableDictionary *sectionContents;

// Notification Handlers



// UI Response Methods
- (void)clearButtonPressed:(UIBarButtonItem *)button;


// Misc Methods

@end

@implementation PersonFilterViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;

// Private
@synthesize sectionKeys = ivSectionKeys;
@synthesize sectionContents = ivSectionContents;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTableView:nil];
	
	
	// Private Properties
    [self setSectionKeys:nil];
    [self setSectionContents:nil];
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	[self setMainTableView:nil];
	[self setSectionContents:nil];
	[self setSectionKeys:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

- (NSMutableArray *)sectionKeys
{
	if (ivSectionKeys == nil)
	{
		ivSectionKeys = [[NSMutableArray alloc] init];
	}
	return ivSectionKeys;
}

- (NSMutableDictionary *)sectionContents
{
	if (ivSectionContents == nil)
	{
		ivSectionContents = [[NSMutableDictionary alloc] init];
	}
	return ivSectionContents;
}

#pragma mark - Initialization and UI Creation Methods

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:@"Filter"];
	
	UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
																	style:UIBarButtonItemStyleBordered
																   target:self
																   action:@selector(clearButtonPressed:)];
	[[self navigationItem] setRightBarButtonItem:clearButton];
	[clearButton release], clearButton = nil;
	
	[[self sectionKeys] removeAllObjects];
	[[self sectionContents] removeAllObjects];
	
	[[self sectionKeys] addObject:kFilterSectionKeyActions];
	[[self sectionKeys] addObject:kFilterSectionKeyPoints];
	
	// Populate action field infos
	
	DataController *dataController = [DataController sharedDataController];
	NSManagedObjectContext *context = [dataController managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	[fetchRequest setEntity:[ActionFieldInfo entityDescriptionInContextBTI:context]];
	
	[fetchRequest setSortDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
	
	{{
		NSPredicate *visiblePredicate = [NSPredicate predicateWithFormat:@"(isHidden == %@)", [NSNumber numberWithBool:NO]];
		
		NSPredicate *pickerPredicate = [NSPredicate predicateWithFormat:@"(type == %@)", [NSNumber numberWithInt:BTIActionFieldValueTypePicker]];
		NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"(type == %@)", [NSNumber numberWithInt:BTIActionFieldValueTypeDate]];
		NSPredicate *booleanPredicate = [NSPredicate predicateWithFormat:@"(type == %@)", [NSNumber numberWithInt:BTIActionFieldValueTypeBoolean]];
		NSPredicate *colorPredicate = [NSPredicate predicateWithFormat:@"(type == %@)", [NSNumber numberWithInt:BTIActionFieldValueTypeColor]];
		
		NSPredicate *typePredicate = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:pickerPredicate, datePredicate, booleanPredicate, colorPredicate, nil]];
		
		[fetchRequest setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:visiblePredicate, typePredicate, nil]]];
	}}
									
	NSArray *actionFieldInfos = [context executeFetchRequest:fetchRequest error:nil];
	
	[[self sectionContents] setObject:[NSArray arrayWithArray:actionFieldInfos] forKey:kFilterSectionKeyActions];
	
	// Points
	
	if ([[NSUserDefaults standardUserDefaults] btiShouldShowColorPointValues])
	{
		[[self sectionContents] setObject:[NSArray arrayWithObject:kFilterRowKeyPoints] forKey:kFilterSectionKeyPoints];
	}
	
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

- (void)clearButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	DataController *dataController = [DataController sharedDataController];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	[userDefaults setPointFilterModeBTI:BTIPointFilterModeOff];
	[userDefaults setPointFilterValueBTI:nil];
	
	Action *action = [dataController filterAction];
	
	NSArray *actionValuesToDelete = [[action actionValues] allObjects];
	
	for (ActionValue *actionValue in actionValuesToDelete)
	{
		[[dataController managedObjectContext] deleteObject:actionValue];
	}
	
	[dataController filterPersons];
	
	[dataController saveCoreDataContext];
	
	[[self mainTableView] reloadData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods


#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger sections = [[self sectionKeys] count];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return sections;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *key = [[self sectionKeys] objectAtIndex:section];
	NSArray *contents = [[self sectionContents] objectForKey:key];
	
	NSInteger rows = [contents count];
	
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
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		[[cell textLabel] setFont:[UIFont boldSystemFontOfSize:16]];
		[[cell textLabel] setAdjustsFontSizeToFitWidth:YES];
		[[cell textLabel] setMinimumFontSize:12.0];
		
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	
	NSString *key = [[self sectionKeys] objectAtIndex:[indexPath section]];
	NSArray *contents = [[self sectionContents] objectForKey:key];
	
	if ([key isEqualToString:kFilterSectionKeyActions])
	{
		DataController *dataController = [DataController sharedDataController];
		ActionFieldInfo *actionFieldInfo = [contents objectAtIndex:[indexPath row]];
		ActionValue *actionValue = [[dataController filterAction] actionValueForActionFieldInfo:actionFieldInfo];
		TermInfo *termInfo = [actionFieldInfo termInfo];
		
		[[cell textLabel] setText:[dataController singularNameForTermInfo:termInfo]];
		[[cell detailTextLabel] setText:[actionValue filterLabelText]];
	}
	else if ([key isEqualToString:kFilterSectionKeyPoints])
	{
		[[cell textLabel] setText:@"Point Value"];
		
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		NSInteger pointMode = [userDefaults pointFilterModeBTI];
		NSNumber *pointValue = [userDefaults pointFilterValueBTI];
		
		if (pointMode == BTIPointFilterModeOff)
		{
			[[cell detailTextLabel] setText:nil];
		}
		else
		{
			NSString *pointString = [NSNumberFormatter localizedStringFromNumber:pointValue numberStyle:NSNumberFormatterDecimalStyle];
			
			if (pointMode == BTIPointFilterModeGreaterThan)
			{
				[[cell detailTextLabel] setText:[NSString stringWithFormat:@"> %@", pointString]];
			}
			else if (pointMode == BTIPointFilterModeLessThan)
			{
				[[cell detailTextLabel] setText:[NSString stringWithFormat:@"< %@", pointString]];
			}
			else if (pointMode == BTIPointFilterModeEqualTo)
			{
				[[cell detailTextLabel] setText:[NSString stringWithFormat:@"= %@", pointString]];
			}
		}
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
	
	NSString *key = [[self sectionKeys] objectAtIndex:[indexPath section]];
	NSArray *contents = [[self sectionContents] objectForKey:key];
	
	if ([key isEqualToString:kFilterSectionKeyActions])
	{
		DataController *dataController = [DataController sharedDataController];
		ActionFieldInfo *actionFieldInfo = [contents objectAtIndex:[indexPath row]];
		ActionValue *actionValue = [[dataController filterAction] actionValueForActionFieldInfo:actionFieldInfo];
		NSInteger fieldType = [[actionFieldInfo type] integerValue];
		
		switch (fieldType) {
			case BTIActionFieldValueTypeDate:
			{
				PersonFilterDateViewController *nextViewController = [[PersonFilterDateViewController alloc] init];
				[nextViewController setActionFieldInfo:actionFieldInfo];
				[nextViewController setActionValue:actionValue];
				
				[[self navigationController] pushViewController:nextViewController animated:YES];
				
				[nextViewController release], nextViewController = nil;
			}
				break;
			case BTIActionFieldValueTypePicker:
			{
				PersonFilterPickerInfoViewController *nextViewController = [[PersonFilterPickerInfoViewController alloc] init];
				[nextViewController setActionFieldInfo:actionFieldInfo];
				[nextViewController setActionValue:actionValue];
				
				[[self navigationController] pushViewController:nextViewController animated:YES];
				
				[nextViewController release], nextViewController = nil;
			}
				break;
			case BTIActionFieldValueTypeLongText:
			{
				
			}
				break;
			case BTIActionFieldValueTypeBoolean:
			{
				PersonFilterBooleanViewController *nextViewController = [[PersonFilterBooleanViewController alloc] init];
				[nextViewController setActionFieldInfo:actionFieldInfo];
				[nextViewController setActionValue:actionValue];
				
				[[self navigationController] pushViewController:nextViewController animated:YES];
				
				[nextViewController release], nextViewController = nil;
			}
				break;
			case BTIActionFieldValueTypeImage:
			{
				
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
				PersonFilterColorViewController *nextViewController = [[PersonFilterColorViewController alloc] init];
				[nextViewController setActionFieldInfo:actionFieldInfo];
				[nextViewController setActionValue:actionValue];
				
				[[self navigationController] pushViewController:nextViewController animated:YES];
				
				[nextViewController release], nextViewController = nil;
			}
				break;
			default:
				break;
		}
	}
	else if ([key isEqualToString:kFilterSectionKeyPoints])
	{
		BTIPersonFilterPointsViewController *nextViewController = [[BTIPersonFilterPointsViewController alloc] init];
		
		[[self navigationController] pushViewController:nextViewController animated:YES];
		
		[nextViewController release], nextViewController = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
