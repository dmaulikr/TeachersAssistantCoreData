//
//  ImportViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/30/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ImportViewController.h"

// Models and other global

// Sub-controllers
#import "DropboxImportViewController.h"

// Views

// Private Constants


@interface ImportViewController ()

// Private Properties
@property (nonatomic, retain) NSMutableArray *sectionKeys;
@property (nonatomic, retain) NSMutableDictionary *sectionContents;

// Notification Handlers
- (void)applicationDidEnterBackground:(NSNotification *)notification;


// UI Response Methods
- (void)templateButtonPressed:(UIBarButtonItem *)button;
- (void)dropboxButtonPressed:(UIBarButtonItem *)button;


// Misc Methods
- (void)buildPathList;
- (void)sendCSVTemplateEmail;

@end

@implementation ImportViewController

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
	
	[self setTitle:@"Import"];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																				  target:nil
																				  action:nil];
		
	UIBarButtonItem *templateButton = [[UIBarButtonItem alloc] initWithTitle:@"Email CSV Template"
																	   style:UIBarButtonItemStyleBordered
																	  target:self
																	  action:@selector(templateButtonPressed:)];
	
	UIBarButtonItem *dropboxButton = [[UIBarButtonItem alloc] initWithTitle:@"Dropbox"
																	  style:UIBarButtonItemStyleBordered
																	 target:self
																	 action:@selector(dropboxButtonPressed:)];
	
	NSMutableArray *items = [NSMutableArray array];
	
	if ([MFMailComposeViewController canSendMail])
	{
		[items addObject:flexItem];
		[items addObject:templateButton];
	}
	
	[items addObject:flexItem];
	[items addObject:dropboxButton];
	[items addObject:flexItem];
	
	[self setToolbarItems:items];
	
	[flexItem release], flexItem = nil;
	[templateButton release], templateButton = nil;
	[dropboxButton release], dropboxButton = nil;
	
	[[self navigationController] setToolbarHidden:NO animated:YES];
	
	[self buildPathList];
	
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

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if ([self modalViewController] != nil)
	{
		[self dismissModalViewControllerAnimated:NO];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UI Response Methods

- (void)templateButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self sendCSVTemplateEmail];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)dropboxButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if ([[DBSession sharedSession] isLinked])
	{
		DropboxImportViewController *nextViewController = [[DropboxImportViewController alloc] init];
		
		[[self navigationController] pushViewController:nextViewController animated:YES];
		
		[nextViewController release], nextViewController = nil;
	}
	else
	{
		[[DBSession sharedSession] link];
//		DBLoginController *loginController = [[DBLoginController new] autorelease];
//		[loginController setDelegate:self];
//		
//		if ([[DataController sharedDataController] isIPadVersion])
//		{
//			[loginController presentFromController:[self splitViewController]];
//		}
//		else
//		{
//			[loginController presentFromController:self];
//		}
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (void)buildPathList
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self sectionKeys] removeAllObjects];
	[[self sectionContents] removeAllObjects];
	
	NSMutableArray *idisciplineFiles = [[NSMutableArray alloc] init];
	NSMutableArray *csvFiles = [[NSMutableArray alloc] init];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	DataController *dataController = [DataController sharedDataController];
	
	NSArray *fileArray = [[fileManager contentsOfDirectoryAtPath:[dataController documentsDirectory] error:nil] pathsMatchingExtensions:[NSArray arrayWithObjects:kNativeFileExtension_OBSOLETE, [kNativeFileExtension_OBSOLETE uppercaseString], kNativeFileExtension, [kNativeFileExtension uppercaseString], nil]];
	
	for (NSString *fileName in fileArray)
	{
		[idisciplineFiles addObject:[[dataController documentsDirectory] stringByAppendingPathComponent:fileName]];
	}
	
	fileArray = [[fileManager contentsOfDirectoryAtPath:[dataController documentsDirectory] error:nil] pathsMatchingExtensions:[NSArray arrayWithObjects:kCommaSeparatedFileExtension, [kCommaSeparatedFileExtension uppercaseString], nil]];
	
	for (NSString *fileName in fileArray)
	{
		[csvFiles addObject:[[dataController documentsDirectory] stringByAppendingPathComponent:fileName]];
	}
	
	[[self sectionKeys] addObject:kNativeFileExtension_OBSOLETE];
	[[self sectionContents] setObject:idisciplineFiles forKey:kNativeFileExtension_OBSOLETE];
	
	[[self sectionKeys] addObject:kCommaSeparatedFileExtension];
	[[self sectionContents] setObject:csvFiles forKey:kCommaSeparatedFileExtension];
	
	[idisciplineFiles release], idisciplineFiles = nil;
	[csvFiles release], csvFiles = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)sendCSVTemplateEmail
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationDidEnterBackground:)
												 name:UIApplicationDidEnterBackgroundNotification 
											   object:nil];

	[ImportCSVViewController emailTemplateCSVFileFromViewController:self];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

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
	
	NSString *header = nil;
	
	NSString *sectionKey = [[self sectionKeys] objectAtIndex:section];
	
	if ([sectionKey isEqualToString:kNativeFileExtension_OBSOLETE])
	{
		header = @"Teacher's Assistant Files";
	}
	else if ([sectionKey isEqualToString:kCommaSeparatedFileExtension])
	{
		header = @"CSV Files";
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return header;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *sectionKey = [[self sectionKeys] objectAtIndex:section];
	NSMutableArray *contents = [[self sectionContents] objectForKey:sectionKey];
	
	NSInteger rows = [contents count];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *sectionKey = [[self sectionKeys] objectAtIndex:[indexPath section]];
	NSMutableArray *contents = [[self sectionContents] objectForKey:sectionKey];
	
	NSString *path = [contents objectAtIndex:[indexPath row]];
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[[cell textLabel] setMinimumFontSize:12.0];
		[[cell textLabel] setAdjustsFontSizeToFitWidth:YES];
	}
	
	NSArray *pathComponents = [path pathComponents];
	NSString *fileName = [pathComponents lastObject];
	NSString *extension = @"";
	
	if ([sectionKey isEqualToString:kNativeFileExtension_OBSOLETE])
	{
		extension = [NSString stringWithFormat:@".%@", kNativeFileExtension_OBSOLETE];
	}
	else if ([sectionKey isEqualToString:kCommaSeparatedFileExtension])
	{
		extension = [NSString stringWithFormat:@".%@", kCommaSeparatedFileExtension];
	}
	else if ([sectionKey isEqualToString:kNativeFileExtension])
	{
		extension = [NSString stringWithFormat:@".%@", kNativeFileExtension];
	}
	
	fileName = [fileName stringByReplacingOccurrencesOfString:extension withString:@""];
	
	[[cell textLabel] setText:fileName];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSString *sectionKey = [[self sectionKeys] objectAtIndex:[indexPath section]];
	NSMutableArray *contents = [[self sectionContents] objectForKey:sectionKey];
	
	NSString *path = [contents objectAtIndex:[indexPath row]];
	
	[[DataController sharedDataController] processImportedFileAtPath:path];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark MFMailComposeViewController Delegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError *)error 
{   
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    switch (result)
    {
		case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
		default:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Error"
															message:@"Unknown error. Your mail was not sent."
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
			[alert release], alert = nil;
		}
			break;
    }
	
    [self dismissModalViewControllerAnimated:YES];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIApplicationDidEnterBackgroundNotification 
												  object:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - DBLoginControllerDelegate Methods

//- (void)loginControllerDidLogin:(DBLoginController *)controller
//{
//	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
//	
//	DropboxImportViewController *nextViewController = [[DropboxImportViewController alloc] init];
//	
//	[[self navigationController] pushViewController:nextViewController animated:YES];
//	
//	[nextViewController release], nextViewController = nil;
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
//	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
//}


@end
