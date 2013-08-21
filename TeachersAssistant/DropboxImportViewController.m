//
//  DropboxImportViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 10/29/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "DropboxImportViewController.h"

// Models and other global
//#import "DBRestClient.h"

// Sub-controllers

// Views

// Private Constants


@interface DropboxImportViewController ()

// Private Properties
@property (nonatomic, retain) DBRestClient *restClient;
@property (nonatomic, retain) NSMutableArray *sectionKeys;
@property (nonatomic, retain) NSMutableDictionary *sectionContents;

// Notification Handlers



// UI Response Methods



// Misc Methods

@end

@implementation DropboxImportViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;

// Private
@synthesize restClient = ivRestClient;
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
	[self setRestClient:nil];
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

- (DBRestClient *)restClient
{
	if (ivRestClient == nil)
	{
		ivRestClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
		[ivRestClient setDelegate:self];
	}
	return ivRestClient;
}

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
	
	[self setTitle:@"Dropbox Files"];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self sectionKeys] removeAllObjects];
	[[self sectionContents] removeAllObjects];
	
	[[self sectionKeys] addObject:kNativeFileExtension];
	[[self sectionContents] setObject:[NSMutableArray array] forKey:kNativeFileExtension];
	
	[[self sectionKeys] addObject:kCommaSeparatedFileExtension];
	[[self sectionContents] setObject:[NSMutableArray array] forKey:kCommaSeparatedFileExtension];
	
//	[[self restClient] loadMetadata:@"/"];
//	[[self restClient] loadMetadata:@"/TeachersAssistant"];
	
	[[self mainTableView] reloadData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidAppear:animated];
	
	[[DataController sharedDataController] showProcessingAlertWithTitle:@"Scanning Dropbox..."];
	
	[[self restClient] loadMetadata:@"/"];
	[[self restClient] loadMetadata:@"/TeachersAssistant"];
	
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
	
	if ([sectionKey isEqualToString:kNativeFileExtension])
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
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[[cell textLabel] setAdjustsFontSizeToFitWidth:YES];
		[[cell textLabel] setMinimumFontSize:12.0];
	}
	
	NSString *sectionKey = [[self sectionKeys] objectAtIndex:[indexPath section]];
	NSMutableArray *contents = [[self sectionContents] objectForKey:sectionKey];
	NSString *path = [contents objectAtIndex:[indexPath row]];
	
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
	
	DataController *dataController = [DataController sharedDataController];
	
	NSString *sectionKey = [[self sectionKeys] objectAtIndex:[indexPath section]];
	NSMutableArray *contents = [[self sectionContents] objectForKey:sectionKey];
	NSString *path = [contents objectAtIndex:[indexPath row]];
	
	NSArray *pathComponents = [path pathComponents];
	NSString *fileName = [pathComponents lastObject];
	
	NSString *targetPath = [[dataController documentsDirectory] stringByAppendingPathComponent:fileName];
	
	[dataController showProcessingAlertWithTitle:@"Downloading..."];
	
	[[self restClient] loadFile:path intoPath:targetPath];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - DBRestClientDelegate methods

- (void)restClient:(DBRestClient *)client
	loadedMetadata:(DBMetadata *)metadata
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[DataController sharedDataController] hideProcessingAlert];
	
	NSLog(@"path: %@", [metadata path]);
	NSLog(@"contents: %@", [metadata contents]);
	NSLog(@"root: %@", [metadata root]);

	NSArray *validExtensions = [NSArray arrayWithObjects:kNativeFileExtension, kNativeFileExtension_OBSOLETE, kCommaSeparatedFileExtension, nil];
	
	for (DBMetadata *child in [metadata contents])
	{
		NSString *extension = [[[child path] pathExtension] lowercaseString];
		
		if ( (![child isDirectory]) && ([validExtensions containsObject:extension]) )
		{
			NSMutableArray *paths = nil;
			if ([extension isEqualToString:kCommaSeparatedFileExtension])
			{
				paths = [[self sectionContents] objectForKey:kCommaSeparatedFileExtension];
			}
			else
			{
				paths = [[self sectionContents] objectForKey:kNativeFileExtension];
			}
			
			[paths addObject:[child path]];
		}
		
		NSLog(@"Child path is: %@", [child path]);
	}
	
	[[self mainTableView] reloadData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)restClient:(DBRestClient *)client
metadataUnchangedAtPath:(NSString *)path 
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[DataController sharedDataController] hideProcessingAlert];
	
    NSLog(@"path: %@", path);

	[[self mainTableView] reloadData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[DataController sharedDataController] hideProcessingAlert];
	
    NSLog(@"restClient:loadMetadataFailedWithError: %@", [error localizedDescription]);

	[[self mainTableView] reloadData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)restClient:(DBRestClient *)client
		loadedFile:(NSString *)destPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	DataController *dataController = [DataController sharedDataController];
	
	[dataController hideProcessingAlert];
	
	[dataController processImportedFileAtPath:destPath];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)restClient:(DBRestClient *)client 
loadFileFailedWithError:(NSError *)error
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[DataController sharedDataController] hideProcessingAlert];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
													message:@"Could not download file. Verify connection and try again"
												   delegate:nil
										  cancelButtonTitle:@"Ok"
										  otherButtonTitles:nil];
	[alert show];
	[alert release], alert = nil;

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
