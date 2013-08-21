//
//  EmailActionPickerViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/21/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "EmailActionPickerViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface EmailActionPickerViewController ()

// Private Properties
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSMutableSet *selectionSet;

// Notification Handlers



// UI Response Methods
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)sendButtonPressed:(UIBarButtonItem *)button;

// Misc Methods
- (void)evaluateButtonStatus;




@end

@implementation EmailActionPickerViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize person = ivPerson;

// Private
@synthesize fetchedResultsController = ivFetchedResultsController;
@synthesize selectionSet = ivSelectionSet;

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
	[self setSelectionSet:nil];
	
	
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
		
		ivFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[dataController actionFetchRequestForPerson:[self person]]
																		 managedObjectContext:context
																		   sectionNameKeyPath:nil
																					cacheName:nil];
		
		[ivFetchedResultsController performFetchBTI];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivFetchedResultsController;
}

- (NSMutableSet *)selectionSet
{
	if (ivSelectionSet == nil)
	{
		ivSelectionSet = [[NSMutableSet alloc] init];
	}
	return ivSelectionSet;
}

#pragma mark - Initialization and UI Creation Methods


#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:[NSString stringWithFormat:@"Choose %@", [[DataController sharedDataController] pluralNameForTermInfoIndentifier:kTermInfoIdentifierAction]]];
	
	UIBarButtonItem	*cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																				  target:self
																				  action:@selector(cancelButtonPressed:)];
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	[cancelButton release], cancelButton = nil;
	
	UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send"
																   style:UIBarButtonItemStyleBordered
																  target:self
																  action:@selector(sendButtonPressed:)];
	[[self navigationItem] setRightBarButtonItem:sendButton];
	[sendButton release], sendButton = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self navigationController] setToolbarHidden:YES animated:YES];
	
	[[self mainTableView] reloadData];
	
	[self evaluateButtonStatus];
	
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

- (void)sendButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSMutableArray *sortedIndexPaths = [NSMutableArray arrayWithArray:[[self selectionSet] allObjects]];
	[sortedIndexPaths sortUsingSelector:@selector(compare:)];
	
	NSMutableString *body = [[NSMutableString alloc] init];
	[body appendString:[[self person] fullName]];
	[body appendString:@"\n"];
	
	for (NSIndexPath *indexPath in sortedIndexPaths)
	{
		Action *action = [[self fetchedResultsController] objectAtIndexPath:indexPath];
		
		[body appendString:[action summaryStringForEmail]];
		
		[body appendString:@" \n\n"];
	}
	
	MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
	[mailComposer setMailComposeDelegate:self];
	
	DataController *dataController = [DataController sharedDataController];
	
	NSString *subject = [NSString stringWithFormat:@"%@ %@: %@", [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierPerson], [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierSummary], [[self person] fullName]];
	[mailComposer setSubject:subject];
	
	NSArray *parents = [[self person] parentsWithValidEmailAddresses];
	NSArray *recipients = [parents valueForKey:@"email"];
    [mailComposer setToRecipients:recipients];
    
	[mailComposer setMessageBody:body isHTML:NO];   
	
	[self presentModalViewController:mailComposer animated:YES];
	
	[body release], body = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (void)evaluateButtonStatus
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[[self navigationItem] rightBarButtonItem] setEnabled:([[self selectionSet] count] > 0)];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger sections = [[[self fetchedResultsController] sections] count];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return sections;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
	
	NSInteger rows = [sectionInfo numberOfObjects];
	
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
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	DataController *dataController = [DataController sharedDataController];
	
	Action *action = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	ActionFieldInfo *actionInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierAction];
	ActionFieldInfo *dateInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierDate];
	
	ActionValue *actionValue = [action actionValueForActionFieldInfo:actionInfo];
	ActionValue *dateValue = [action actionValueForActionFieldInfo:dateInfo];
	
	[[cell textLabel] setText:[actionValue labelText]];
	[[cell detailTextLabel] setText:[dateValue labelText]];
	
	if ([[self selectionSet] containsObject:indexPath])
	{
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	}
	else
	{
		[cell setAccessoryType:UITableViewCellAccessoryNone];
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
	
	UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
	
	if ([[self selectionSet] containsObject:indexPath])
	{
		[[self selectionSet] removeObject:indexPath];
		[currentCell setAccessoryType:UITableViewCellAccessoryNone];
	}
	else
	{
		[currentCell setAccessoryType:UITableViewCellAccessoryCheckmark];
		[[self selectionSet] addObject:indexPath];
	}
	
	[self evaluateButtonStatus];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - MFMailComposeViewControllerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController*)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError*)error
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self dismissModalViewControllerAnimated:NO];
	[[self navigationController] popViewControllerAnimated:YES];
	
	if (result == MFMailComposeResultFailed)
	{
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can not send mail"
														message:@"Sorry, we were unable to send the email."
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	[controller release], controller = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
