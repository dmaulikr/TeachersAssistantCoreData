//
//  ActionFieldInfoDetailsViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/19/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ActionFieldInfoDetailsViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants
#define kContentLabelKey						@"kContentLabelKey"
#define kContentValueKey						@"kContentValueKey"

@interface ActionFieldInfoDetailsViewController ()

// Private Properties
@property (nonatomic, retain) NSMutableArray *contents;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
//@property (nonatomic, assign) NSInteger selectedType;

// Notification Handlers



// UI Response Methods
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)saveButtonPressed:(UIBarButtonItem *)button;


// Misc Methods
- (NSString *)nameForActionFieldValueType:(NSNumber *)fieldType;

@end

@implementation ActionFieldInfoDetailsViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize singularTextField = ivSingularTextField;
@synthesize pluralTextField = ivPluralTextField;
@synthesize dataTypeLabel = ivDataTypeLabel;
@synthesize visibleTitleLabel = ivVisibleTitleLabel;
@synthesize visibleSwitch = ivVisibleSwitch;
@synthesize actionFieldInfo = ivActionFieldInfo;

// Private
//@synthesize selectedType = ivSelectedType;
@synthesize contents = ivContents;
@synthesize selectedIndexPath = ivSelectedIndexPath;


#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
    [self setMainTableView:nil];
    [self setSingularTextField:nil];
    [self setPluralTextField:nil];
    [self setDataTypeLabel:nil];
    [self setVisibleTitleLabel:nil];
    [self setVisibleSwitch:nil];
    [self setActionFieldInfo:nil];
	
	
	// Private Properties
    [self setContents:nil];
    [self setSelectedIndexPath:nil];
	
	
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	[self setMainTableView:nil];
    [self setSingularTextField:nil];
    [self setPluralTextField:nil];
    [self setDataTypeLabel:nil];
    [self setVisibleTitleLabel:nil];
    [self setVisibleSwitch:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

- (NSMutableArray *)contents
{
	if (ivContents == nil)
	{
		ivContents = [[NSMutableArray alloc] init];
	}
	return ivContents;
}

#pragma mark - Initialization and UI Creation Methods

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
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
	
	[[self mainTableView] setBackgroundView:nil];
	[[self mainTableView] setBackgroundColor:[UIColor clearColor]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self navigationController] setToolbarHidden:YES animated:YES];
	
	[[self contents] removeAllObjects];
	
	[[self contents] addObject:[NSNumber numberWithInt:BTIActionFieldValueTypeDate]];
	[[self contents] addObject:[NSNumber numberWithInt:BTIActionFieldValueTypePicker]];
	[[self contents] addObject:[NSNumber numberWithInt:BTIActionFieldValueTypeLongText]];
	[[self contents] addObject:[NSNumber numberWithInt:BTIActionFieldValueTypeBoolean]];
	[[self contents] addObject:[NSNumber numberWithInt:BTIActionFieldValueTypeImage]];
//	[[self contents] addObject:[NSNumber numberWithInt:BTIActionFieldValueTypeColor]];
	
	if ([self actionFieldInfo] == nil)
	{
		[self setTitle:@"New Action Field"];
		
		[[self mainTableView] setHidden:NO];
		[[self visibleTitleLabel] setHidden:YES];
		[[self visibleSwitch] setHidden:YES];
		[[self dataTypeLabel] setHidden:YES];
		
		[[self mainTableView] reloadData];
	}
	else
	{
		[self setTitle:@"Edit Action Field"];
		
		TermInfo *termInfo = [[self actionFieldInfo] termInfo];
		
		[[self singularTextField] setText:[termInfo userNameSingular]];
		[[self singularTextField] setPlaceholder:[termInfo defaultNameSingular]];
		
		[[self pluralTextField] setText:[termInfo userNamePlural]];
		[[self pluralTextField] setPlaceholder:[termInfo defaultNamePlural]];
		
		[[self mainTableView] setHidden:YES];
		[[self visibleTitleLabel] setHidden:NO];
		[[self visibleSwitch] setHidden:NO];
		[[self dataTypeLabel] setHidden:NO];
		
		[[self dataTypeLabel] setText:[self nameForActionFieldValueType:[[self actionFieldInfo] type]]];
		
		NSInteger row = [[self contents] indexOfObject:[[self actionFieldInfo] type]];
		[self setSelectedIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
		
		[[self visibleSwitch] setOn:![[[self actionFieldInfo] isHidden] boolValue]];
	}
	
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

- (IBAction)visibleSwitchValueChanged:(UISwitch *)theSwitch
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	// No action necessary, value pulled in save method

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)cancelButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)saveButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	DataController *dataController = [DataController sharedDataController];
	NSManagedObjectContext *context = [dataController managedObjectContext];
	
	TermInfo *termInfo = nil;
	
	NSString *singular = [[self singularTextField] text];
	NSString *plural = [[self pluralTextField] text];
	
	if ([[self actionFieldInfo] identifier] == nil)		// User field
	{
		if ( (singular == nil) || ([singular length] == 0) || (plural == nil) || ([plural length] == 0) )
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
															message:@"You provide both a singular and plural description"
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
			[alert release], alert = nil;
			
			NSLog(@"<<< Leaving %s >>> EARLY - Missing value", __PRETTY_FUNCTION__);
			return;
		}
		
//		if ([self actionFieldInfo] == nil)		// User field
//		{
			if ([self selectedIndexPath] == nil)
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
																message:@"You must choose a field type"
															   delegate:nil
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
				[alert show];
				[alert release], alert = nil;
				
				NSLog(@"<<< Leaving %s >>> EARLY - Missing value", __PRETTY_FUNCTION__);
				return;
			}
//		}
	}
	
	if ([self actionFieldInfo] == nil)
	{
		ActionFieldInfo *actionFieldInfo = [ActionFieldInfo managedObjectInContextBTI:context];
		
		termInfo = [TermInfo managedObjectInContextBTI:context];
		
		[actionFieldInfo setTermInfo:termInfo];
		[actionFieldInfo setType:[[self contents] objectAtIndex:[[self selectedIndexPath] row]]];
		[actionFieldInfo setSortOrder:[NSNumber numberWithInteger:[dataController countOfActionFieldInfos]]];
		
		[self setActionFieldInfo:actionFieldInfo];
	}
	else
	{
		termInfo = [[self actionFieldInfo] termInfo];
	}
	
	[termInfo setUserNameSingular:singular];
	[termInfo setUserNamePlural:plural];
	
	[[self actionFieldInfo] setIsHidden:[NSNumber numberWithBool:![[self visibleSwitch] isOn]]];
	
	[dataController saveCoreDataContext];
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (NSString *)nameForActionFieldValueType:(NSNumber *)fieldType
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *name = nil;
	
	switch ([fieldType intValue]) {
		case BTIActionFieldValueTypeDate:
			name = @"Date";
			break;
		case BTIActionFieldValueTypePicker:
			name = @"Picker";
			break;
		case BTIActionFieldValueTypeLongText:
			name = @"Long Text";
			break;
		case BTIActionFieldValueTypeBoolean:
			name = @"Switch";
			break;
		case BTIActionFieldValueTypeImage:
			name = @"Image";
			break;
		case BTIActionFieldValueTypeAudio:
			name = @"Audio";
			break;
		case BTIActionFieldValueTypeVideo:
			name = @"Video";
			break;
		case BTIActionFieldValueTypeColor:
			name = @"Color";
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return name;
}

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
	
	NSInteger rows = [[self contents] count];
	
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
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSNumber *valueType = [[self contents] objectAtIndex:[indexPath row]];
	
	[[cell textLabel] setText:[self nameForActionFieldValueType:valueType]];
	
	[cell setAccessoryType:(indexPath == [self selectedIndexPath]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if ([self selectedIndexPath] != nil)
	{
		UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:[self selectedIndexPath]];
		
		[oldCell setAccessoryType:UITableViewCellAccessoryNone];
	}
		
	UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
	
	[newCell setAccessoryType:UITableViewCellAccessoryCheckmark];
	
	[self setSelectedIndexPath:indexPath];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[textField resignFirstResponder];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return YES;
}

@end
