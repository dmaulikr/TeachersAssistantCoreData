//
//  DiagnosticViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/28/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "DiagnosticViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants

typedef enum {
	BTIDiagnosticSectionImages = 0,
	BTIDiagnosticSectionAudio,
	BTIDiagnosticSectionVideo,
	BTIDiagnosticSectionEntities,
	BTIDiagnosticSectionTotal
} BTIDiagnosticSection;

@interface DiagnosticViewController ()

// Private Properties


// Notification Handlers



// UI Response Methods



// Misc Methods

@end

@implementation DiagnosticViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;

// Private

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTableView:nil];
	
	
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
	
	[self setTitle:@"Diagnostics"];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	
	
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
	
	NSInteger sections = BTIDiagnosticSectionTotal;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return sections;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger rows = 1;
	
	if (section == BTIDiagnosticSectionEntities)
	{
		rows = [[[[DataController sharedDataController] managedObjectModel] entities] count];
	}
	
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
	}
	
	DataController *dataController = [DataController sharedDataController];
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	
	switch (section) {
		case BTIDiagnosticSectionEntities:
		{
			NSArray *entities = [[dataController managedObjectModel] entities];
			NSEntityDescription *entity = [entities objectAtIndex:row];
			
			[[cell textLabel] setText:[entity name]];
			
			NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
			[fetchRequest setEntity:entity];
			NSInteger numberOfEntities = [[dataController managedObjectContext] countForFetchRequest:fetchRequest error:nil];
			[[cell detailTextLabel] setText:[NSString stringWithFormat:@"%d", numberOfEntities]];
		}
			break;
		case BTIDiagnosticSectionImages:
		{
			[[cell textLabel] setText:@"Image Files"];
			
			NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[dataController imageDirectory] error:nil];
			NSArray *imageFiles = [files pathsMatchingExtensions:[NSArray arrayWithObject:@"jpg"]];
			[[cell detailTextLabel] setText:[NSString stringWithFormat:@"%d", [imageFiles count]]];
		}
			break;
		case BTIDiagnosticSectionAudio:
		{
			[[cell textLabel] setText:@"Audio Files"];
			
			NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[dataController audioDirectory] error:nil];
			[[cell detailTextLabel] setText:[NSString stringWithFormat:@"%d", [files count]]];
		}
			break;
		case BTIDiagnosticSectionVideo:
		{
			[[cell textLabel] setText:@"Video Files"];
			
			NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[dataController videoDirectory] error:nil];
			[[cell detailTextLabel] setText:[NSString stringWithFormat:@"%d", [files count]]];
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
	
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
