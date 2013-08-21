//
//  ParentDialerViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/25/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ParentDialerViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface ParentDialerViewController ()

// Private Properties
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

// Notification Handlers



// UI Response Methods



// Misc Methods

@end

@implementation ParentDialerViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize person = ivPerson;

// Private
@synthesize fetchedResultsController = ivFetchedResultsController;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTableView:nil];
	[self setPerson:nil];
	
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
		
		[fetchRequest setEntity:[Parent entityDescriptionInContextBTI:context]];
		
		[fetchRequest setSortDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
		
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"student == %@", [self person]]];
		
		ivFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																		 managedObjectContext:context
																		   sectionNameKeyPath:nil
																					cacheName:nil];
		
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
	
	[self setTitle:@"Call"];
	
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



#pragma mark - Misc Methods


#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger sections = [[[self fetchedResultsController] fetchedObjects] count];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return sections;
}

- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:section inSection:0];
	Parent *parent = [[self fetchedResultsController] objectAtIndexPath:adjustedIndexPath];
	
	NSString *header = [parent name];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return header;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:section inSection:0];
	Parent *parent = [[self fetchedResultsController] objectAtIndexPath:adjustedIndexPath];
	
	NSInteger rows = [[parent phoneNumbers] count];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:[indexPath section] inSection:0];
	Parent *parent = [[self fetchedResultsController] objectAtIndexPath:adjustedIndexPath];
	
	DataController *dataController = [DataController sharedDataController];
	
	NSArray *sortedPhoneNumbers = [[parent phoneNumbers] sortedArrayUsingDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
	PhoneNumber *phoneNumber = [sortedPhoneNumbers objectAtIndex:[indexPath row]];
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		
		NSURL *url = [NSURL URLWithString:@"tel:"];
		BOOL canMakeCall = [[UIApplication sharedApplication] canOpenURL:url];
		[cell setAccessoryType:(canMakeCall) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone];
		[cell setSelectionStyle:(canMakeCall) ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone];
	}
	
	[[cell textLabel] setText:[phoneNumber type]];
	[[cell detailTextLabel] setText:[phoneNumber value]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return cell;
}

#pragma mark - UITableView Delegate Methods

- (NSIndexPath *)tableView:(UITableView *)tableView 
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSIndexPath *indexPathToReturn = nil;
	
	NSURL *url = [NSURL URLWithString:@"tel:"];
	BOOL canMakeCall = [[UIApplication sharedApplication] canOpenURL:url];
	
	if (canMakeCall)
		indexPathToReturn = indexPath;

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return indexPathToReturn;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:[indexPath section] inSection:0];
	Parent *parent = [[self fetchedResultsController] objectAtIndexPath:adjustedIndexPath];
	
	DataController *dataController = [DataController sharedDataController];
	
	NSArray *sortedPhoneNumbers = [[parent phoneNumbers] sortedArrayUsingDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
	PhoneNumber *phone = [sortedPhoneNumbers objectAtIndex:[indexPath row]];
	
	NSString *phoneNumber = [phone value];
	
	if ([phoneNumber length] > 0)
	{
		phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
		phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
		phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
		phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
		phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
		NSLog(@"phoneNumber is: %@", phoneNumber);        
        
		NSString *dialerURL = [@"tel:" stringByAppendingString:phoneNumber];
		
		NSURL *urlToDial = [[NSURL alloc] initWithString:dialerURL];
		
		[[UIApplication sharedApplication] openURL:urlToDial];
		
		[urlToDial release], urlToDial = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
