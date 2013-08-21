//
//  SettingsViewController.m
//  infraction
//
//  Created by Brian Slick on 3/5/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "SettingsViewController.h"


// Models and other global

// Sub-controllers
#import "ScreenLockSettingsViewController.h"
#import "StudentOrderChooserViewController.h"
#import "TermInfoViewController.h"
#import "ActionFieldInfoViewController.h"
#import "DefaultActionValuesViewController.h"
#import "ColorInfoViewController.h"
#import "ImportViewController.h"
#import "ExportChooserViewController.h"
#import "JumpChooserViewController.h"
#import "EmailBlastClassPickerViewController.h"
#import "EmailBlastToAddressViewController.h"
#import "GradingPeriodsViewController.h"
#import "StudentDetailsListViewController.h"

// Views
#import "UICustomSwitch.h"

// Private Constants
#define kPersonOrderSectionKey				@"kPersonOrderSectionKey"
#define kPersonSortOrderRowKey				@"Sort Order"
#define kPersonDisplayOrderRowKey			@"Display Order"
#define kPersonThumbnailRowKey				@"Show Thumbnail Images"
#define kPersonDetailsRowKey				@"Customize Detail Fields"

#define kGradingPeriodsSectionKey			@"kGradingPeriodsSectionKey"
#define kGradingPeriodsRowKey				@"Grading Periods"

#define kJumpButtonSectionKey				@"kJumpButtonSectionKey"
#define kJumpButtonRowKey					@"Quick Jump Button"

#define kTermInfoSectionKey					@"kTermInfoSectionKey"
#define kTermInfoRowKey						@"Customize Terminology"

#define kActionFieldInfoSectionKey			@"kActionFieldInfoSectionKey"
#define kActionFieldInfoRowKey				@"Customize Actions"

#define kColorInfoSectionKey				@"kColorInfoSectionKey"
#define kColorInfoRowKey					@"Customize Color Labels"
#define kColorInfoPointValuesRowKey			@"Show Point Values"

#define kDefaultValuesSectionKey            @"kDefaultValuesSectionKey"
#define kDefaultValuesRowKey                @"Default Values"

#define kEmailBlastSectionKey				@"kEmailBlastSectionKey"
#define kEmailBlastToRowKey					@"To: Teacher Email"
#define kEmailBlastRecipientsRowKey			@"Parent Recipients"

#define kDropboxSectionKey					@"kDropboxSectionKey"
#define kDropboxRowKey						@"Dropbox enabled"

#define kDataExchangeSectionKey				@"kDataExchangeSectionKey"
#define kImportRowKey						@"Import"
#define kExportRowKey						@"Export"

#define kScreenLockSectionKey				@"kScreenLockSectionKey"
#define kScreenLockRowKey					@"Screen Lock"

#define kDeleteDataSectionKey				@"kDeleteDataSectionKey"
#define kDeletePersonsRowKey				@"Delete All Students"
#define kDeleteActionsRowKey                @"Delete All Actions"
#define kDeleteAllDataRowKey                @"Delete All Data"
#define kDeleteResetDataRowKey				@"Reset To Default"

#define kResetLogoSectionKey				@"kResetLogoSectionKey"
#define kResetLogoRowKey					@"Restore Default Logo"



#define kAlertViewTagDeleteStudents             100
#define kAlertViewTagDeleteActions              200
#define kAlertViewTagDeleteAllData              300

@interface SettingsViewController ()

// Private Properties
@property (nonatomic, retain) NSMutableArray *sectionKeys;
@property (nonatomic, retain) NSMutableDictionary *sectionContents;

// Notification Handlers



// UI Response Methods
- (void)switchValueChanged:(UICustomSwitch *)customSwitch;


// Misc Methods

@end

@implementation SettingsViewController

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
	
    // Public
    [self setMainTableView:nil];
    
    // Private
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
	
	[self setTitle:@"Settings"];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self navigationController] setToolbarHidden:YES animated:YES];
	
	DataController *dataController = [DataController sharedDataController];
	
	[[self sectionKeys] removeAllObjects];
	[[self sectionContents] removeAllObjects];
	
	[[self sectionKeys] addObject:kPersonOrderSectionKey];
	[[self sectionKeys] addObject:kGradingPeriodsSectionKey];
	[[self sectionKeys] addObject:kJumpButtonSectionKey];
	[[self sectionKeys] addObject:kTermInfoSectionKey];
	[[self sectionKeys] addObject:kActionFieldInfoSectionKey];
	[[self sectionKeys] addObject:kColorInfoSectionKey];
	[[self sectionKeys] addObject:kDefaultValuesSectionKey];
	[[self sectionKeys] addObject:kEmailBlastSectionKey];
	if (![dataController isLiteVersion])
	{	
		[[self sectionKeys] addObject:kDropboxSectionKey];
		[[self sectionKeys] addObject:kDataExchangeSectionKey];
	}
	[[self sectionKeys] addObject:kScreenLockSectionKey];
	[[self sectionKeys] addObject:kDeleteDataSectionKey];
	if ([dataController isIPadVersion])
	{
		[[self sectionKeys] addObject:kResetLogoSectionKey];
	}
	
	[[self sectionContents] setObject:[NSArray arrayWithObjects:kDropboxRowKey, nil] forKey:kDropboxSectionKey];
	[[self sectionContents] setObject:[NSArray arrayWithObjects:kJumpButtonRowKey, nil] forKey:kJumpButtonSectionKey];
	[[self sectionContents] setObject:[NSArray arrayWithObjects:kPersonSortOrderRowKey, kPersonDisplayOrderRowKey, kPersonThumbnailRowKey, kPersonDetailsRowKey, nil] forKey:kPersonOrderSectionKey];
	[[self sectionContents] setObject:[NSArray arrayWithObjects:kTermInfoRowKey, nil] forKey:kTermInfoSectionKey];
	[[self sectionContents] setObject:[NSArray arrayWithObjects:kActionFieldInfoRowKey, nil] forKey:kActionFieldInfoSectionKey];
	[[self sectionContents] setObject:[NSArray arrayWithObjects:kColorInfoRowKey, kColorInfoPointValuesRowKey, nil] forKey:kColorInfoSectionKey];
    [[self sectionContents] setObject:[NSArray arrayWithObjects:kDefaultValuesRowKey, nil] forKey:kDefaultValuesSectionKey];
	[[self sectionContents] setObject:[NSArray arrayWithObjects:kImportRowKey, kExportRowKey, nil] forKey:kDataExchangeSectionKey];
	[[self sectionContents] setObject:[NSArray arrayWithObjects:kScreenLockRowKey, nil] forKey:kScreenLockSectionKey];
	[[self sectionContents] setObject:[NSArray arrayWithObjects:kResetLogoRowKey, nil] forKey:kResetLogoSectionKey];
	[[self sectionContents] setObject:[NSArray arrayWithObjects:kDeletePersonsRowKey, kDeleteActionsRowKey, kDeleteAllDataRowKey, kDeleteResetDataRowKey, nil] forKey:kDeleteDataSectionKey];
	[[self sectionContents] setObject:[NSArray arrayWithObjects:kEmailBlastToRowKey, kEmailBlastRecipientsRowKey, nil] forKey:kEmailBlastSectionKey];
	[[self sectionContents] setObject:[NSArray arrayWithObjects:kGradingPeriodsRowKey, nil] forKey:kGradingPeriodsSectionKey];
	
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

- (void)switchValueChanged:(UICustomSwitch *)customSwitch
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	BOOL isSwitchOn = [customSwitch isOn];
	
	NSIndexPath *indexPath = [[self mainTableView] mdIndexPathForRowContainingView:customSwitch];
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	NSString *sectionKey = [[self sectionKeys] objectAtIndex:section];
	NSArray *contents = [[self sectionContents] objectForKey:sectionKey];
	NSString *rowKey = [contents objectAtIndex:row];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	if ([rowKey isEqualToString:kPersonThumbnailRowKey])
	{
		[userDefaults btiSetShouldShowPersonThumbnails:isSwitchOn];
	}
	else if ([rowKey isEqualToString:kColorInfoPointValuesRowKey])
	{
		[userDefaults btiSetShouldShowColorPointValues:isSwitchOn];
		
		if (!isSwitchOn)
		{
			[userDefaults setPointFilterModeBTI:BTIPointFilterModeOff];
			[userDefaults setPointFilterValueBTI:nil];
		}
	}
	else if ([rowKey isEqualToString:kDropboxRowKey])
	{
		if (isSwitchOn)
		{
			if (![[DBSession sharedSession] isLinked])
			{
				[[DBSession sharedSession] link];
			}
		}
		else
		{
			[[DBSession sharedSession] unlinkAll];
		}
	}

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

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *sectionKey = [[self sectionKeys] objectAtIndex:section];
	NSString *title = nil;
	
	DataController *dataController = [DataController sharedDataController];
	
	if ([sectionKey isEqualToString:kPersonOrderSectionKey])
	{
		title = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
	}
	else if ([sectionKey isEqualToString:kColorInfoSectionKey])
    {
        title = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierColorLabel];
    }
    else if ([sectionKey isEqualToString:kDeleteDataSectionKey])
    {
        title = @"Delete";
    }
	else if ([sectionKey isEqualToString:kEmailBlastSectionKey])
	{
		title = @"Email Blast";
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return title;
}

- (NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *sectionKey = [[self sectionKeys] objectAtIndex:section];
	NSArray *contents = [[self sectionContents] objectForKey:sectionKey];
	NSInteger rows = [contents count];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	DataController *dataController = [DataController sharedDataController];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	NSString *sectionKey = [[self sectionKeys] objectAtIndex:section];
	NSArray *contents = [[self sectionContents] objectForKey:sectionKey];
	NSString *rowKey = [contents objectAtIndex:row];
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		[[cell textLabel] setAdjustsFontSizeToFitWidth:YES];
		[[cell textLabel] setMinimumFontSize:12.0];
	}
	
	[cell setAccessoryView:nil];
	[[cell detailTextLabel] setText:nil];
	
	if ([sectionKey isEqualToString:kPersonOrderSectionKey])
	{
		[[cell textLabel] setText:rowKey];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		
		if ([rowKey isEqualToString:kPersonSortOrderRowKey])
		{
			switch ([userDefaults btiPersonSortMode]) {
				case BTIPersonSortModeFirstLast:
					[[cell detailTextLabel] setText:@"First, Last"];
					break;
				case BTIPersonSortModeLastFirst:
					[[cell detailTextLabel] setText:@"Last, First"];
					break;
				default:
					break;
			}
		}
		else if ([rowKey isEqualToString:kPersonDisplayOrderRowKey])
		{
			switch ([userDefaults btiPersonDisplayMode]) {
				case BTIPersonSortModeFirstLast:
					[[cell detailTextLabel] setText:@"First, Last"];
					break;
				case BTIPersonSortModeLastFirst:
					[[cell detailTextLabel] setText:@"Last, First"];
					break;
				default:
					break;
			}
		}
		else if ([rowKey isEqualToString:kPersonThumbnailRowKey])
		{
			UICustomSwitch *customSwitch = [[UICustomSwitch alloc] init];
			[[customSwitch leftLabel] setText:@"Yes"];
			[[customSwitch rightLabel] setText:@"No"];
			[customSwitch setTag:555];
			
			[customSwitch setOn:[userDefaults btiShouldShowPersonThumbnails] animated:NO];
			[customSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
			
			[cell setAccessoryView:customSwitch];
			
			[customSwitch release], customSwitch = nil;
			
			[[cell textLabel] setText:rowKey];
			[[cell detailTextLabel] setText:nil];
			
			[cell setAccessoryType:UITableViewCellAccessoryNone];
		}
		else if ([rowKey isEqualToString:kPersonDetailsRowKey])
		{
			[[cell textLabel] setText:rowKey];
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
	}
	else if ([sectionKey isEqualToString:kTermInfoSectionKey])
	{
		[[cell textLabel] setText:rowKey];
		[[cell detailTextLabel] setText:nil];
		
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	else if ([sectionKey isEqualToString:kActionFieldInfoSectionKey])
	{
		NSString *string = [NSString stringWithFormat:@"Customize %@ Fields", [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierAction]];
		[[cell textLabel] setText:string];
		[[cell detailTextLabel] setText:nil];
		
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
    else if ([sectionKey isEqualToString:kDefaultValuesSectionKey])
	{
		NSString *string = [NSString stringWithFormat:@"Default %@ Values", [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierAction]];
		[[cell textLabel] setText:string];
		[[cell detailTextLabel] setText:nil];
		
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	else if ([sectionKey isEqualToString:kDataExchangeSectionKey])
	{
		[[cell textLabel] setText:rowKey];
		[[cell detailTextLabel] setText:nil];
		
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	else if ([sectionKey isEqualToString:kScreenLockSectionKey])
	{
		[[cell textLabel] setText:rowKey];
		[[cell detailTextLabel] setText:nil];
		
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		
		if ([userDefaults btiIsScreenLockEnabled])
		{
			[[cell detailTextLabel] setText:@"ON"];
		}
		else
		{
			[[cell detailTextLabel] setText:nil];
		}
	}
	else if ([sectionKey isEqualToString:kResetLogoSectionKey])
	{
		[[cell textLabel] setText:rowKey];
		[[cell detailTextLabel] setText:nil];
		
		[cell setAccessoryType:UITableViewCellAccessoryNone];
	}
	else if ([sectionKey isEqualToString:kDeleteDataSectionKey])
	{
		if ([rowKey isEqualToString:kDeletePersonsRowKey])
        {
            NSString *string = [NSString stringWithFormat:@"Delete All %@", [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierPerson]];
            [[cell textLabel] setText:string];
		}
        else if ([rowKey isEqualToString:kDeleteActionsRowKey])
        {
            NSString *string = [NSString stringWithFormat:@"Delete All %@", [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierAction]];
            [[cell textLabel] setText:string];
		}
        else
        {
            [[cell textLabel] setText:rowKey];
        }
		[[cell detailTextLabel] setText:nil];
		[cell setAccessoryType:UITableViewCellAccessoryNone];
	}
	else if ([sectionKey isEqualToString:kColorInfoSectionKey])
	{
		if ([rowKey isEqualToString:kColorInfoRowKey])
		{
			NSString *string = [NSString stringWithFormat:@"Customize %@", [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierColorLabel]];
			[[cell textLabel] setText:string];
			[[cell detailTextLabel] setText:nil];
			
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
		else if ([rowKey isEqualToString:kColorInfoPointValuesRowKey])
		{
			UICustomSwitch *customSwitch = [[UICustomSwitch alloc] init];
			[[customSwitch leftLabel] setText:@"Yes"];
			[[customSwitch rightLabel] setText:@"No"];
			[customSwitch setTag:555];
			
			[customSwitch setOn:[userDefaults btiShouldShowColorPointValues] animated:NO];
			[customSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
			
			[cell setAccessoryView:customSwitch];
			
			[customSwitch release], customSwitch = nil;
			
			[[cell textLabel] setText:rowKey];
			[[cell detailTextLabel] setText:nil];
			
			[cell setAccessoryType:UITableViewCellAccessoryNone];
		}
	}
	else if ([sectionKey isEqualToString:kJumpButtonSectionKey])
	{
		[[cell textLabel] setText:rowKey];
		NSString *jumpTitle = nil;
		switch ([userDefaults btiJumpButtonMode]) {
			case BTIJumpButtonModeHome:
				jumpTitle = @"Home";
				break;
			case BTIJumpButtonModeClasses:
				jumpTitle = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierClass];
				break;
			case BTIJumpButtonModeStudents:
				jumpTitle = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
				break;
			default:
				break;
		}
		[[cell detailTextLabel] setText:jumpTitle];
		
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	else if ([sectionKey isEqualToString:kDropboxSectionKey])
	{
		UICustomSwitch *customSwitch = [[UICustomSwitch alloc] init];
		[[customSwitch leftLabel] setText:@"Yes"];
		[[customSwitch rightLabel] setText:@"No"];
		[customSwitch setTag:555];
		
		
		[customSwitch setOn:[[DBSession sharedSession] isLinked] animated:NO];
		[customSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
		
		[cell setAccessoryView:customSwitch];
		
		[customSwitch release], customSwitch = nil;
		
		[[cell textLabel] setText:rowKey];
		[[cell detailTextLabel] setText:nil];
		
		[cell setAccessoryType:UITableViewCellAccessoryNone];
	}
	else if ([sectionKey isEqualToString:kEmailBlastSectionKey])
	{
		[[cell textLabel] setText:rowKey];
		[[cell detailTextLabel] setText:nil];
		
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	else if ([sectionKey isEqualToString:kGradingPeriodsSectionKey])
	{
		NSString *gradingPeriods = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierGradingPeriod];
		
		[[cell textLabel] setText:gradingPeriods];
		[[cell detailTextLabel] setText:nil];
		
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
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
	
	DataController *dataController = [DataController sharedDataController];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	NSString *sectionKey = [[self sectionKeys] objectAtIndex:section];
	NSArray *contents = [[self sectionContents] objectForKey:sectionKey];
	NSString *rowKey = [contents objectAtIndex:row];
	
	if ([sectionKey isEqualToString:kPersonOrderSectionKey])
	{
		id nextViewController = nil;
		
		if ([rowKey isEqualToString:kPersonSortOrderRowKey])
		{
			nextViewController = [[[StudentOrderChooserViewController alloc] init] autorelease];
			[nextViewController setSetting:kUserDefaultsStudentSortModeKey];
		}
		else if ([rowKey isEqualToString:kPersonDisplayOrderRowKey])
		{
			nextViewController = [[[StudentOrderChooserViewController alloc] init] autorelease];
			[nextViewController setSetting:kUserDefaultsStudentDisplayModeKey];
		}
		else if ([rowKey isEqualToString:kPersonDetailsRowKey])
		{
			nextViewController = [[[StudentDetailsListViewController alloc] init] autorelease];
		}
		
		if (nextViewController != nil)
		{
			[[self navigationController] pushViewController:nextViewController animated:YES];
		}
	}
	else if ([sectionKey isEqualToString:kDataExchangeSectionKey])
	{
		if ([rowKey isEqualToString:kExportRowKey])
		{
			ExportChooserViewController *ecvc = [[ExportChooserViewController alloc] init];
			
			[[self navigationController] pushViewController:ecvc animated:YES];
			
			[ecvc release], ecvc = nil;
		}
		else if ([rowKey isEqualToString:kImportRowKey])
		{
			ImportViewController *ivc = [[ImportViewController alloc] init];
			
			[[self navigationController] pushViewController:ivc animated:YES];
			
			[ivc release], ivc = nil;
		}
	}
	else if ([sectionKey isEqualToString:kTermInfoSectionKey])
	{
		TermInfoViewController *nextViewController = [[TermInfoViewController alloc] init];
		
		[[self navigationController] pushViewController:nextViewController animated:YES];
		
		[nextViewController release], nextViewController = nil;
	}
	else if ([sectionKey isEqualToString:kActionFieldInfoSectionKey])
	{
		ActionFieldInfoViewController *nextViewController = [[ActionFieldInfoViewController alloc] init];
		
		[[self navigationController] pushViewController:nextViewController animated:YES];
		
		[nextViewController release], nextViewController = nil;
	}
	else if ([sectionKey isEqualToString:kScreenLockSectionKey])
	{
		ScreenLockSettingsViewController *slsvc = [[ScreenLockSettingsViewController alloc] init];
		
		[[self navigationController] pushViewController:slsvc animated:YES];
		
		[slsvc release], slsvc = nil;
	}
	else if ([sectionKey isEqualToString:kResetLogoSectionKey])
	{
		NSString *path = [[dataController imageDirectory] stringByAppendingPathComponent:kUserLogoImageFileName];
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if ([fileManager fileExistsAtPath:path])
		{
			[fileManager removeItemAtPath:path error:nil];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:kLogoImageDidChangeNotification object:nil];
		}
	}
	else if ([sectionKey isEqualToString:kDeleteDataSectionKey])
	{
		NSString *studentsPlural = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
		NSString *actionsPlural = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierAction];
		
		RIButtonItem *cancelButton = [RIButtonItem item];
		[cancelButton setLabel:@"Cancel"];
		
		RIButtonItem *deleteButton = [RIButtonItem item];
		
		NSString *alertTitle = nil;
		NSString *alertMessage = nil;
		
		if ([rowKey isEqualToString:kDeletePersonsRowKey])
        {
			alertTitle = [NSString stringWithFormat:@"Delete All %@?", studentsPlural];
			alertMessage = [NSString stringWithFormat:@"All %@ will be deleted", studentsPlural];
			
			[deleteButton setLabel:@"Delete"];
			[deleteButton setAction:^{
				[dataController deleteAllPersons];
			}];
        }
        else if ([rowKey isEqualToString:kDeleteActionsRowKey])
        {
			alertTitle = [NSString stringWithFormat:@"Delete All %@?", actionsPlural];
			alertMessage = [NSString stringWithFormat:@"%@ will remain, but all %@ will be deleted", studentsPlural, actionsPlural];
			
			[deleteButton setLabel:@"Delete"];
			[deleteButton setAction:^{
				[dataController deleteAllActions];
			}];
        }
        else if ([rowKey isEqualToString:kDeleteAllDataRowKey])
        {
			alertTitle = @"Delete All Data?";
			alertMessage = [NSString stringWithFormat:@"All %@ and %@ will be deleted", studentsPlural, actionsPlural];
			
			[deleteButton setLabel:@"Delete All"];
			[deleteButton setAction:^{
				[dataController deleteAllUserData];
			}];
        }
		else if ([rowKey isEqualToString:kDeleteResetDataRowKey])
        {
			alertTitle = @"Reset To Default?";
			alertMessage = @"All data, including customizations, will be removed";
			
			[deleteButton setLabel:@"Reset"];
			[deleteButton setAction:^{
				[userDefaults btiResetDefaults];
				[dataController deleteAllData];
				[dataController loadAllData];
//				[dataController loadDefaultTermInfo];
//				[dataController loadDefaultActionFieldInfo];
				
				NSString *path = [[dataController imageDirectory] stringByAppendingPathComponent:kUserLogoImageFileName];
				
				NSFileManager *fileManager = [NSFileManager defaultManager];
				if ([fileManager fileExistsAtPath:path])
				{
					[fileManager removeItemAtPath:path error:nil];
					
					[[NSNotificationCenter defaultCenter] postNotificationName:kLogoImageDidChangeNotification object:nil];
				}
				
				[[self mainTableView] reloadData];
			}];
        }
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
														message:alertMessage
											   cancelButtonItem:cancelButton
											   otherButtonItems:deleteButton, nil];
		[alert show];
		[alert release], alert = nil;
		
//        if ([rowKey isEqualToString:kDeletePersonsRowKey])
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete All Students?"
//                                                            message:@"All students will be deleted"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"Cancel"
//                                                  otherButtonTitles:@"Delete", nil];
//            [alert setTag:kAlertViewTagDeleteStudents];
//            [alert show];
//            [alert release], alert = nil;
//        }
//        else if ([rowKey isEqualToString:kDeleteActionsRowKey])
//        {
//            DataController *dataController = [DataController sharedDataController];
//            NSString *actions = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierAction];
//
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Delete All %@?", actions]
//                                                            message:[NSString stringWithFormat:@"Students will remain, but all %@ will be deleted", actions]
//                                                           delegate:self
//                                                  cancelButtonTitle:@"Cancel"
//                                                  otherButtonTitles:@"Delete", nil];
//            [alert setTag:kAlertViewTagDeleteActions];
//            [alert show];
//            [alert release], alert = nil;
//        }
//        else if ([rowKey isEqualToString:kDeleteAllDataRowKey])
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete All Data?"
//                                                            message:@"All students and actions will be deleted"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"Cancel"
//                                                  otherButtonTitles:@"Delete All", nil];
//            [alert setTag:kAlertViewTagDeleteAllData];
//            [alert show];
//            [alert release], alert = nil;
//        }
    }
    else if ([sectionKey isEqualToString:kDefaultValuesSectionKey])
	{
		DefaultActionValuesViewController *nextViewController = [[DefaultActionValuesViewController alloc] init];
	
		[[self navigationController] pushViewController:nextViewController animated:YES];
		
		[nextViewController release], nextViewController = nil;
	}
    else if ([sectionKey isEqualToString:kColorInfoSectionKey])
	{
		ColorInfoViewController *nextViewController = [[ColorInfoViewController alloc] init];
		
		[[self navigationController] pushViewController:nextViewController animated:YES];
		
		[nextViewController release], nextViewController = nil;
	}
	else if ([sectionKey isEqualToString:kJumpButtonSectionKey])
	{
		JumpChooserViewController *nextViewController = [[JumpChooserViewController alloc] init];
		
		[[self navigationController] pushViewController:nextViewController animated:YES];
		
		[nextViewController release], nextViewController = nil;
	}
	else if ([sectionKey isEqualToString:kEmailBlastSectionKey])
	{
		if ([rowKey isEqualToString:kEmailBlastRecipientsRowKey])
		{
			EmailBlastClassPickerViewController *nextViewController = [[EmailBlastClassPickerViewController alloc] init];
			[nextViewController setFromSettings:YES];
			
			[[self navigationController] pushViewController:nextViewController animated:YES];
			
			[nextViewController release], nextViewController = nil;
		}
		else if ([rowKey isEqualToString:kEmailBlastToRowKey])
		{
			EmailBlastToAddressViewController *nextViewController = [[EmailBlastToAddressViewController alloc] init];
			
			[[self navigationController] pushViewController:nextViewController animated:YES];
			
			[nextViewController release], nextViewController = nil;
		}
	}
	else if ([sectionKey isEqualToString:kGradingPeriodsSectionKey])
	{
		GradingPeriodsViewController *nextViewController = [[GradingPeriodsViewController alloc] init];
		
		[[self navigationController] pushViewController:nextViewController animated:YES];
		
		[nextViewController release], nextViewController = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

//	if (buttonIndex != [alertView cancelButtonIndex])
//	{
//        DataController *dataController = [DataController sharedDataController];
//        
//        if ([alertView tag] == kAlertViewTagDeleteStudents)
//        {
//            [dataController deleteAllPersons];
//        }
//        else if ([alertView tag] == kAlertViewTagDeleteActions)
//        {
//            [dataController deleteAllActions];
//        }
//        else if ([alertView tag] == kAlertViewTagDeleteAllData)
//        {
//            [dataController deleteAllUserData];
//        }
//	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - DBLoginControllerDelegate Methods

//- (void)loginControllerDidLogin:(DBLoginController *)controller
//{
//	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
//	
//	[[self mainTableView] reloadData];
//	
//	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
//}
//
//- (void)loginControllerDidCancel:(DBLoginController *)controller
//{
//	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
//	
//	NSLog(@"Login cancelled.");
//	
//	[[self mainTableView] reloadData];
//	
//	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
//}


@end
