//
//  ScreenLockSettingsViewController.m
//  infraction
//
//  Created by Brian Slick on 3/8/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ScreenLockSettingsViewController.h"


// Models and other global
#import "DataController.h"
#import "Constants.h"

// Sub-controllers
#import "DefinePINViewController.h"

@implementation ScreenLockSettingsViewController

#pragma mark - Synthesized Properties

@synthesize mainTableView = ivMainTableView;
@synthesize lockSwitch = ivLockSwitch;
@synthesize lockEnabled = ivLockEnabled;
@synthesize contents = ivContents;


#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [self setMainTableView:nil];
    [self setLockSwitch:nil];
    [self setContents:nil];
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
    [self setMainTableView:nil];
    [self setLockSwitch:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

- (NSMutableArray *)contents;
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
	
	[self setTitle:@"Screen Lock"];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	if ( ([userDefaults btiIsScreenLockEnabled]) && ([userDefaults btiScreenLockPin] != nil) )
	{
		[self setLockEnabled:YES];
	}
	else
	{
		[self setLockEnabled:NO];
	}
	
	[[self contents] removeAllObjects];
	
	[[self contents] addObject:kScreenLockEnableSectionKey];
	
	if ([self isLockEnabled])
	{
		[[self contents] addObject:kScreenLockChangePinSectionKey];
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

#pragma mark - Notification Handlers



#pragma mark - UI Response Methods

- (IBAction)enabledSwitchValueChanged:(UISwitch *)theSwitch
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if ([theSwitch isOn])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are You Sure?"
														message:@"If you forget your PIN, you cannot recover your data"
													   delegate:self
											  cancelButtonTitle:@"Cancel"
											  otherButtonTitles:@"Proceed", nil];
		[alert show];
		[alert release], alert = nil;
	}
	else
	{
		[self setLockEnabled:NO];
		[self togglePinRow:NO];
		
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		[userDefaults btiSetScreenLockEnabled:NO];
		[userDefaults btiSetScreenLockPin:nil];
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (void)togglePinRow:(BOOL)shouldShow
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if (shouldShow)
	{
		[[self contents] addObject:kScreenLockChangePinSectionKey];
		
		[[self mainTableView] beginUpdates];
		
		[[self mainTableView] insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
		
		[[self mainTableView] endUpdates];
	}
	else
	{
		if ([[self contents] count] > 1)
		{
			[[self contents] removeObject:kScreenLockChangePinSectionKey];
			
			[[self mainTableView] beginUpdates];
			
			[[self mainTableView] deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
			
			[[self mainTableView] endUpdates];
		}
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
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = nil;
	
	switch ([indexPath section])
	{
		case 0:
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			
			UISwitch *theSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
			[theSwitch addTarget:self action:@selector(enabledSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
			[theSwitch setOn:[self isLockEnabled]];
			[self setLockSwitch:theSwitch];
			[cell setAccessoryView:theSwitch];
			[theSwitch release], theSwitch = nil;
			
			[[cell textLabel] setText:@"Screen Lock"];
			
			break;
		}
		case 1:
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			
			[[cell textLabel] setTextColor:[UIColor blackColor]];
			[[cell textLabel] setText:@"Change PIN"];
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			
			break;
		}
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
	
	if ([indexPath section] == 1)
	{
		DefinePINViewController *dpvc = [[DefinePINViewController alloc] init];
		
		[[self navigationController] pushViewController:dpvc animated:YES];
		
		[dpvc release], dpvc = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (buttonIndex == [alertView cancelButtonIndex])
	{
		[[self lockSwitch] setOn:NO];
	}
	else
	{
		DefinePINViewController *dpvc = [[DefinePINViewController alloc] init];
		
		[[self navigationController] pushViewController:dpvc animated:YES];
		
		[dpvc release], dpvc = nil;
	}
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
