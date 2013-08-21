//
//  PickerInfoViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/18/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "PickerInfoViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface PickerInfoViewController ()

// Private Properties
@property (nonatomic, retain) NSMutableArray *colorContents;
@property (nonatomic, retain) ColorInfo *selectedColorInfo;

// Notification Handlers



// UI Response Methods
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)saveButtonPressed:(UIBarButtonItem *)button;


// Misc Methods

@end

@implementation PickerInfoViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTextField = ivMainTextField;
@synthesize mainTableView = ivMainTableView;
@synthesize colorLabel = ivColorLabel;
@synthesize delegate = ivDelegate;
@synthesize actionFieldInfo = ivActionFieldInfo;
@synthesize pickerValue = ivPickerValue;


// Private
@synthesize colorContents = ivColorContents;
@synthesize selectedColorInfo = ivSelectedColorInfo;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
    [self setMainTextField:nil];
	[self setMainTableView:nil];
	[self setColorLabel:nil];
    [self setActionFieldInfo:nil];
    [self setPickerValue:nil];
	
	
	// Private Properties
	[self setColorContents:nil];
	[self setSelectedColorInfo:nil];
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	[self setMainTextField:nil];
	[self setMainTableView:nil];
	[self setColorLabel:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

- (NSMutableArray *)colorContents
{
	if (ivColorContents == nil)
	{
		ivColorContents = [[NSMutableArray alloc] init];
	}
	return ivColorContents;
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
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self navigationController] setToolbarHidden:YES animated:YES];
	
	DataController *dataController = [DataController sharedDataController];
	
	[self setTitle:[dataController singularNameForTermInfo:[[self actionFieldInfo] termInfo]]];
	
	[[self mainTextField] setText:[[self pickerValue] name]];
	
	[self setSelectedColorInfo:[[self pickerValue] colorInfo]];
	
	if (![dataController isIPadVersion])
	{
		CGRect frame = [[self mainTableView] frame];
		frame.size.height = frame.size.height - 216.0;
		[[self mainTableView] setFrame:frame];
	}
	
	if ( ([[[self actionFieldInfo] identifier] isEqualToString:kTermInfoIdentifierAction]) && ([[NSUserDefaults standardUserDefaults] btiShouldShowColorPointValues]) )
	{
		[[self colorContents] removeAllObjects];
		
		NSManagedObjectContext *context = [[self actionFieldInfo] managedObjectContext];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		[fetchRequest setEntity:[ColorInfo entityDescriptionInContextBTI:context]];
		
		[fetchRequest setSortDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
		
		NSArray *colors = [context executeFetchRequest:fetchRequest error:nil];
		
		[[self colorContents] addObjectsFromArray:colors];
		
		[fetchRequest release], fetchRequest = nil;
		
		[[self mainTableView] reloadData];
	}
	else
	{
		[[self mainTableView] setDelegate:nil];
		[[self mainTableView] setDataSource:nil];
		[[self mainTableView] removeFromSuperview];
		[self setMainTableView:nil];
		
		[[self colorLabel] removeFromSuperview];
		[self setColorLabel:nil];
	}
	
	[[self mainTextField] becomeFirstResponder];
	
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
	
	NSString *text = [[self mainTextField] text];
	
	if ([text length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
														message:@"You must provide a name"
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release], alert = nil;
		
		NSLog(@"<<< Leaving %s >>> EARLY - No value", __PRETTY_FUNCTION__);
		return;
	}
	
	DataController *dataController = [DataController sharedDataController];
	NSManagedObjectContext *context = [dataController managedObjectContext];
	
	if ([self pickerValue] == nil)
	{
		PickerValue *newPickerValue = [PickerValue managedObjectInContextBTI:context];
		[newPickerValue setSortOrder:[NSNumber numberWithInt:[[[self actionFieldInfo] pickerValues] count]]];
		[newPickerValue setActionFieldInfo:(ActionFieldInfo *)[context objectWithID:[[self actionFieldInfo] objectID]]];
		
		[self setPickerValue:newPickerValue];
	}

	[[self pickerValue] setName:text];
	[[self pickerValue] setColorInfo:[self selectedColorInfo]];
	
	if ([[self delegate] respondsToSelector:@selector(addPickerValueToSelection:)])
	{
		[[self delegate] performSelector:@selector(addPickerValueToSelection:) withObject:[self pickerValue]];
	}
	
	[dataController saveCoreDataContext];
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods


#pragma mark - UITableViewDataSource Methods

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
	
	NSInteger rows = [[self colorContents] count] + 1;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger row = [indexPath row];
	
	
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	if (row == 0)
	{
		[[cell textLabel] setText:@"None"];
		[[cell imageView] setImage:nil];
		[cell setAccessoryType:([self selectedColorInfo] == nil) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
	}
	else
	{	
		ColorInfo *colorInfo = [[self colorContents] objectAtIndex:row - 1];
		
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
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSInteger row = [indexPath row];
	NSInteger oldRow = 0;
	
	if ([self selectedColorInfo] != nil)
	{
		oldRow = [[self colorContents] indexOfObject:[self selectedColorInfo]] + 1;
	}
	
	UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:oldRow inSection:0]];
	[oldCell setAccessoryType:UITableViewCellAccessoryNone];
	
	if (row == 0)
	{
		[self setSelectedColorInfo:nil];
	}
	else
	{
		ColorInfo *colorInfo = [[self colorContents] objectAtIndex:row - 1];
		
		[self setSelectedColorInfo:colorInfo];
	}
	
	UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
	[newCell setAccessoryType:UITableViewCellAccessoryCheckmark];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
