//
//  BTIPersonFilterPointsViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 8/8/12.
//  Copyright 2012 BriTer Ideas LLC. All rights reserved.
//

#import "BTIPersonFilterPointsViewController.h"

// Models and other global

// Sub-controllers

// Views
#import "PersonInfoCell.h"

// Private Constants
#define kPointValueSectionKey								@"kPointValueSectionKey"
#define kComparisonSectionKey								@"kComparisonSectionKey"

@interface BTIPersonFilterPointsViewController ()

// Private Properties
@property (nonatomic, retain) UINib *personInfoCellNib;
@property (nonatomic, retain) NSMutableArray *sectionKeys;
@property (nonatomic, retain) NSMutableDictionary *sectionContents;
@property (nonatomic, assign) NSInteger filterMode;

// Notification Handlers



// UI Response Methods
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)saveButtonPressed:(UIBarButtonItem *)button;


// Misc Methods

@end

@implementation BTIPersonFilterPointsViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize personInfoCell = ivPersonInfoCell;

// Private
@synthesize personInfoCellNib = ivPersonInfoCellNib;
@synthesize sectionKeys = ivSectionKeys;
@synthesize sectionContents = ivSectionContents;
@synthesize filterMode = ivFilterMode;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTableView:nil];
	[self setPersonInfoCell:nil];
	
	// Private Properties
    [self setPersonInfoCellNib:nil];
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
	[self setPersonInfoCell:nil];
	
	[self setSectionKeys:nil];
    [self setSectionContents:nil];
	
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

- (UINib *)personInfoCellNib
{
	if (ivPersonInfoCellNib == nil)
	{
		ivPersonInfoCellNib = [[UINib nibWithNibName:NSStringFromClass([PersonInfoCell class]) bundle:nil] retain];
	}
	return ivPersonInfoCellNib;
}

#pragma mark - Initialization and UI Creation Methods


#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:@"Points Filter"];
	
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
	
	[[self sectionKeys] removeAllObjects];
	[[self sectionContents] removeAllObjects];
	
	[[self sectionKeys] addObject:kPointValueSectionKey];
	[[self sectionKeys] addObject:kComparisonSectionKey];
	
	[[self sectionContents] setObject:[NSArray arrayWithObject:[NSNull null]] forKey:kPointValueSectionKey];
	
	NSMutableArray *comparisonKeys = [NSMutableArray array];
	[comparisonKeys addObject:[NSNumber numberWithInteger:BTIPointFilterModeGreaterThan]];
	[comparisonKeys addObject:[NSNumber numberWithInteger:BTIPointFilterModeLessThan]];
	[comparisonKeys addObject:[NSNumber numberWithInteger:BTIPointFilterModeEqualTo]];
	
	[[self sectionContents] setObject:comparisonKeys forKey:kComparisonSectionKey];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	if ([userDefaults pointFilterModeBTI] != BTIPointFilterModeOff)
	{
		[self setFilterMode:[userDefaults pointFilterModeBTI]];
	}
	else
	{
		[[[self navigationItem] rightBarButtonItem] setEnabled:NO];
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

- (void)cancelButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[self navigationController] popViewControllerAnimated:YES];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)saveButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *pointString = [[[self personInfoCell] textField] text];
	NSNumber *pointValue = [NSNumber numberWithFloat:[pointString floatValue]];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	[userDefaults setPointFilterModeBTI:[self filterMode]];
	[userDefaults setPointFilterValueBTI:pointValue];
	
	[[self navigationController] popViewControllerAnimated:YES];
	
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
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSString *key = [[self sectionKeys] objectAtIndex:[indexPath section]];
	
	UITableViewCell *cell = nil;
	
	if ([key isEqualToString:kPointValueSectionKey])
	{
		[[self personInfoCellNib] instantiateWithOwner:self options:nil];
		
		[[[self personInfoCell] textField] setKeyboardType:UIKeyboardTypeDecimalPad];
		
		[[[self personInfoCell] label] setText:@"Points"];
		[[[self personInfoCell] textField] setText:[NSNumberFormatter localizedStringFromNumber:[userDefaults pointFilterValueBTI] numberStyle:NSNumberFormatterDecimalStyle]];
		[[[self personInfoCell] textField] becomeFirstResponder];
		
		cell = [self personInfoCell];
//		[self setPersonInfoCell:nil];
	}
	else if ([key isEqualToString:kComparisonSectionKey])
	{
		static NSString *CellIdentifier = @"CellIdentifier";
		
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		NSArray *contents = [[self sectionContents] objectForKey:key];
		NSInteger rowMode = [(NSNumber *)[contents objectAtIndex:[indexPath row]] integerValue];
		
		if (rowMode == BTIPointFilterModeGreaterThan)
		{
			[[cell textLabel] setText:@"Greater than"];
		}
		else if (rowMode == BTIPointFilterModeLessThan)
		{
			[[cell textLabel] setText:@"Less than"];
		}
		else if (rowMode == BTIPointFilterModeEqualTo)
		{
			[[cell textLabel] setText:@"Equal to"];
		}
		
		[cell setAccessoryType:(rowMode == [self filterMode]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
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
	
	if ([key isEqualToString:kPointValueSectionKey])
	{
		// Probably don't need to do anything.
	}
	else if ([key isEqualToString:kComparisonSectionKey])
	{
		[[[self navigationItem] rightBarButtonItem] setEnabled:YES];
		
		NSArray *contents = [[self sectionContents] objectForKey:key];
		NSInteger rowMode = [(NSNumber *)[contents objectAtIndex:[indexPath row]] integerValue];
		
		[self setFilterMode:rowMode];
		
		[tableView reloadSections:[NSIndexSet indexSetWithIndex:[indexPath section]] withRowAnimation:UITableViewRowAnimationNone];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
