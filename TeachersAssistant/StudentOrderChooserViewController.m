//
//  StudentOrderChooserViewController.m
//  infraction
//
//  Created by Brian Slick on 7/28/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "StudentOrderChooserViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface StudentOrderChooserViewController ()

// Private Properties


// Notification Handlers



// UI Response Methods



// Misc Methods

@end

@implementation StudentOrderChooserViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize setting = ivSetting;

// Private

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTableView:nil];
	[self setSetting:nil];
	
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
	
	if ([[self setting] isEqualToString:kUserDefaultsStudentSortModeKey])
	{
		[self setTitle:@"Sort Order"];
	}
	else if ([[self setting] isEqualToString:kUserDefaultsStudentDisplayModeKey])
	{
		[self setTitle:@"Display Order"];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
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
	
	NSInteger rows = 2;
	
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
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSUInteger row = [indexPath row];
	
	switch (row) {
		case 0:
			[[cell textLabel] setText:@"First, Last"];
			break;
		case 1:
			[[cell textLabel] setText:@"Last, First"];
			break;
		default:
			break;
	}
	
	if ([[self setting] isEqualToString:kUserDefaultsStudentSortModeKey])
	{
		[cell setAccessoryType:(row == [userDefaults btiPersonSortMode] - 1) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
	}
	else if ([[self setting] isEqualToString:kUserDefaultsStudentDisplayModeKey])
	{
		[cell setAccessoryType:(row == [userDefaults btiPersonDisplayMode] - 1) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
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
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSInteger row = [indexPath row];
	NSInteger otherRow = NSNotFound;
	if (row == 1)
		otherRow = 0;
	else
		otherRow = 1;
	
	UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
	UITableViewCell *otherCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:otherRow inSection:0]];
	
	[currentCell setAccessoryType:UITableViewCellAccessoryCheckmark];
	[otherCell setAccessoryType:UITableViewCellAccessoryNone];
	
	if ([[self setting] isEqualToString:kUserDefaultsStudentSortModeKey])
	{
		[userDefaults btiSetPersonSortMode:row + 1];
	}
	else if ([[self setting] isEqualToString:kUserDefaultsStudentDisplayModeKey])
	{
		[userDefaults btiSetPersonDisplayMode:row + 1];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
