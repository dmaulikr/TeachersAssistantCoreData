//
//  DefaultActionValuesViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/20/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "DefaultActionValuesViewController.h"

// Models and other global

// Sub-controllers
#import "ActionPickerValuesViewController.h"
#import "DateDetailViewController.h"
#import "LongTextDetailViewController.h"
#import "ColorInfoPickerViewController.h"

// Views
#import "UICustomSwitch.h"

// Private Constants


@interface DefaultActionValuesViewController ()

// Private Properties
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

// Notification Handlers



// UI Response Methods
- (void)switchValueChanged:(UICustomSwitch *)customSwitch;
- (void)clearButtonPressed:(UIBarButtonItem *)button;

// Misc Methods

@end

@implementation DefaultActionValuesViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;

// Private
@synthesize fetchedResultsController = ivFetchedResultsController;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTableView:nil];
	
	
	// Private Properties
	[self setFetchedResultsController:nil];
	
	
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
		NSManagedObjectContext *context = [dataController managedObjectContext];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		[fetchRequest setEntity:[ActionFieldInfo entityDescriptionInContextBTI:context]];
		
		[fetchRequest setSortDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
		
		NSPredicate *hiddenPredicate = [NSPredicate predicateWithFormat:@"isHidden == %@", [NSNumber numberWithBool:NO]];
		
		NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"(type != %@) && (type != %@) && (type != %@)", [NSNumber numberWithInt:BTIActionFieldValueTypeImage], [NSNumber numberWithInt:BTIActionFieldValueTypeAudio], [NSNumber numberWithInt:BTIActionFieldValueTypeVideo]];
		
		[fetchRequest setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:hiddenPredicate, typePredicate, nil]]];
		
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

#pragma mark - Initialization and UI Creation Methods

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:@"Default Values"];
	
	UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
																	style:UIBarButtonItemStyleBordered
																   target:self
																   action:@selector(clearButtonPressed:)];
	[[self navigationItem] setRightBarButtonItem:clearButton];
	[clearButton release], clearButton = nil;
	
	// Create Action Values as needed
	
	DataController *dataController = [DataController sharedDataController];
	NSManagedObjectContext *context = [dataController managedObjectContext];
	Action *action = [dataController defaultAction];
	
	for (ActionFieldInfo *actionFieldInfo in [[self fetchedResultsController] fetchedObjects])
	{
		ActionValue *actionValue = [action actionValueForActionFieldInfo:actionFieldInfo];
		
		if (actionValue == nil)
		{
			actionValue = [ActionValue managedObjectInContextBTI:context];
			[actionValue setActionFieldInfo:actionFieldInfo];
			[actionValue setAction:action];
		}
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
	
	[[DataController sharedDataController] saveCoreDataContext];
	
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

- (void)switchValueChanged:(UICustomSwitch *)customSwitch
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	UITableViewCell *cell = (UITableViewCell *)[customSwitch superview];
	NSIndexPath *indexPath = [[self mainTableView] indexPathForCell:cell];
	NSLog(@"cell is: %@", [cell description]);
	NSLog(@"indexPath is: %@", [indexPath description]);
	
	ActionFieldInfo *actionFieldInfo = [[self fetchedResultsController] objectAtIndexPath:indexPath];

	ActionValue	*actionValue = [[[DataController sharedDataController] defaultAction] actionValueForActionFieldInfo:actionFieldInfo];
	
	[actionValue setBoolean:[NSNumber numberWithBool:[customSwitch isOn]]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)clearButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	DataController *dataController = [DataController sharedDataController];
	
	Action *action = [dataController defaultAction];
	
	for (ActionValue *actionValue in [action actionValues])
	{
		[actionValue setLongText:nil];
		[actionValue setDate:nil];
		[actionValue setBoolean:[NSNumber numberWithBool:NO]];
		[actionValue setImageMediaInfo:nil];
		[actionValue setPickerValues:nil];
		[actionValue setColorInfo:nil];
		[actionValue setAudioMediaInfo:nil];
		[actionValue setThumbnailImageMediaInfo:nil];
	}
	
	[[self mainTableView] reloadData];
	
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
	
	static NSString *plainCellIdentifier = @"plainCellIdentifier";
	static NSString *switchCellIdentifier = @"switchCellIdentifier";
	
	UITableViewCell *plainCell = [tableView dequeueReusableCellWithIdentifier:plainCellIdentifier];
	if (plainCell == nil)
	{
		plainCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:plainCellIdentifier] autorelease];
		
		[plainCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	
	UITableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:switchCellIdentifier];
	if (switchCell == nil)
	{
		switchCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:switchCellIdentifier] autorelease];
		[[switchCell textLabel] setAdjustsFontSizeToFitWidth:YES];
		[[switchCell textLabel] setMinimumFontSize:12.0];
		
		UICustomSwitch *customSwitch = [[UICustomSwitch alloc] init];
		[[customSwitch leftLabel] setText:@"Yes"];
		[[customSwitch rightLabel] setText:@"No"];
		[customSwitch setTag:555];
		[customSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
		
		[switchCell setAccessoryView:customSwitch];
		
		[customSwitch release], customSwitch = nil;
	}
	
	DataController *dataController = [DataController sharedDataController];
	ActionFieldInfo *actionFieldInfo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	NSInteger fieldType = [[actionFieldInfo type] integerValue];
	TermInfo *termInfo = [actionFieldInfo termInfo];
	ActionValue *actionValue = [[dataController defaultAction] actionValueForActionFieldInfo:actionFieldInfo];
	
	UITableViewCell *cell = nil;
	
	switch (fieldType) {
		case BTIActionFieldValueTypeDate:
		{
			cell = plainCell;
			
			[[cell textLabel] setText:[dataController singularNameForTermInfo:termInfo]];
			[[cell detailTextLabel] setText:[actionValue labelText]];
		}
			break;
		case BTIActionFieldValueTypePicker:
		{
			NSLog(@"actionValue is: %@", [actionValue description]);
			
			cell = plainCell;
			
			[[cell textLabel] setText:[dataController singularNameForTermInfo:termInfo]];
			[[cell detailTextLabel] setText:[actionValue labelText]];
		}
			break;
		case BTIActionFieldValueTypeLongText:
		{
			cell = plainCell;
			
			[[cell textLabel] setText:[dataController singularNameForTermInfo:termInfo]];
			[[cell detailTextLabel] setText:[actionValue labelText]];
		}
			break;
		case BTIActionFieldValueTypeBoolean:
		{
			cell = switchCell;
			
			[[cell textLabel] setText:[dataController singularNameForTermInfo:termInfo]];
			[(UICustomSwitch *)[cell accessoryView] setOn:[[actionValue boolean] boolValue] animated:NO];
		}
			break;
		case BTIActionFieldValueTypeImage:
		{
			cell = plainCell;
			
			[[cell textLabel] setText:[dataController singularNameForTermInfo:termInfo]];
			[[cell detailTextLabel] setText:[actionValue labelText]];
		}
			break;
		case BTIActionFieldValueTypeAudio:
		{
			cell = plainCell;
			
			[[cell textLabel] setText:[dataController singularNameForTermInfo:termInfo]];
			[[cell detailTextLabel] setText:[actionValue labelText]];
		}
			break;
		case BTIActionFieldValueTypeVideo:
		{
			cell = plainCell;
			
			[[cell textLabel] setText:[dataController singularNameForTermInfo:termInfo]];
			[[cell detailTextLabel] setText:[actionValue labelText]];
		}
			break;
		case BTIActionFieldValueTypeColor:
		{
			cell = plainCell;
			
			[[cell textLabel] setText:[dataController singularNameForTermInfo:termInfo]];
//			[[cell detailTextLabel] setText:[actionValue labelText]];
			
			ColorInfo *colorInfo = [actionValue colorInfo];
			
			NSString *colorText = [colorInfo name];
			
			if ([[NSUserDefaults standardUserDefaults] btiShouldShowColorPointValues])
			{
				colorText = [colorText stringByAppendingString:[NSString stringWithFormat:@" (%d)", [[colorInfo pointValue] intValue]]];
			}
			
			[[cell detailTextLabel] setText:colorText];
			
			if ([actionValue colorInfo] == nil)
			{
				[[cell imageView] setImage:nil];
			}
			else
			{
				[[cell imageView] setImage:[dataController thumbnailImageForColorInfo:[actionValue colorInfo]]];
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
	
	ActionFieldInfo *actionFieldInfo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	NSInteger fieldType = [[actionFieldInfo type] integerValue];
	ActionValue *actionValue = [[[DataController sharedDataController] defaultAction] actionValueForActionFieldInfo:actionFieldInfo];
	
	switch (fieldType) {
		case BTIActionFieldValueTypeDate:
		{
			DateDetailViewController *nextViewController = [[DateDetailViewController alloc] init];
			[nextViewController setScratchActionValue:actionValue];
			
			[[self navigationController] pushViewController:nextViewController animated:YES];
			
			[nextViewController release], nextViewController = nil;
		}
			break;
		case BTIActionFieldValueTypePicker:
		{
			ActionPickerValuesViewController *nextViewController = [[ActionPickerValuesViewController alloc] init];
			[nextViewController setActionFieldInfo:actionFieldInfo];
			[nextViewController setActionValue:actionValue];
			
			[[self navigationController] pushViewController:nextViewController animated:YES];
			
			[nextViewController release], nextViewController = nil;
		}
			break;
		case BTIActionFieldValueTypeLongText:
		{
			LongTextDetailViewController *nextViewController = [[LongTextDetailViewController alloc] init];
			[nextViewController setScratchActionValue:actionValue];
			
			[[self navigationController] pushViewController:nextViewController animated:YES];
			
			[nextViewController release], nextViewController = nil;
		}
			break;
		case BTIActionFieldValueTypeBoolean:
		{
			
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
			ColorInfoPickerViewController *nextViewController = [[ColorInfoPickerViewController alloc] init];
			[nextViewController setActionFieldInfo:actionFieldInfo];
			[nextViewController setActionValue:actionValue];
			
			[[self navigationController] pushViewController:nextViewController animated:YES];
			
			[nextViewController release], nextViewController = nil;
		}
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
