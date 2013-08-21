//
//  ParentEmailerViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/25/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ParentEmailerViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface ParentEmailerViewController ()

// Private Properties
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSMutableSet *emailSelectionSet;
@property (nonatomic, assign, getter = isSkipMode) BOOL skipMode;

// Notification Handlers



// UI Response Methods
- (void)emailButtonPressed:(UIBarButtonItem *)button;


// Misc Methods


@end

@implementation ParentEmailerViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize person = ivPerson;
@synthesize actionSelectionSet = ivActionSelectionSet;

// Private
@synthesize fetchedResultsController = ivFetchedResultsController;
@synthesize emailSelectionSet = ivEmailSectionSet;
@synthesize skipMode = ivSkipMode;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTableView:nil];
	[self setPerson:nil];
	[self setActionSelectionSet:nil];
	
	// Private Properties
	[self setFetchedResultsController:nil];
	[self setEmailSelectionSet:nil];
	
	
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

- (NSMutableSet *)emailSelectionSet
{
	if (ivEmailSectionSet == nil)
	{
		ivEmailSectionSet = [[NSMutableSet alloc] init];
	}
	return ivEmailSectionSet;
}

#pragma mark - Initialization and UI Creation Methods

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:@"Choose Addresses"];
	
	UIBarButtonItem *emailButton = [[UIBarButtonItem alloc] initWithTitle:@"Email"
																	style:UIBarButtonItemStyleBordered
																   target:self
																   action:@selector(emailButtonPressed:)];
	[[self navigationItem] setRightBarButtonItem:emailButton];
	[emailButton release], emailButton = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	if ([[[self fetchedResultsController] fetchedObjects] count] == 0)
	{
		[self setSkipMode:YES];
		
		[self emailButtonPressed:nil];
	}
	else
	{
		NSInteger numberOfEmailAddresses = 0;
		
		for (Parent *parent in [[self fetchedResultsController] fetchedObjects])
		{
			numberOfEmailAddresses = numberOfEmailAddresses + [[parent emailAddresses] count];
		}
		
		if (numberOfEmailAddresses == 0)
		{
			[self setSkipMode:YES];
			
			[self emailButtonPressed:nil];
		}
	}
	
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

- (void)emailButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	DataController *dataController = [DataController sharedDataController];
	
	NSManagedObjectContext *context = [[self person] managedObjectContext];
	
	NSString *summary = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierSummary];
	NSString *person = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
//	NSString *other = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierOther];
	
	MFMailComposeViewController *mailComposer = [[[MFMailComposeViewController alloc] init] autorelease];
	[mailComposer setMailComposeDelegate:self];	
	
	NSString *subject = [NSString stringWithFormat:@"%@ %@: %@", person, summary, [[self person] fullName]];
	[mailComposer setSubject:subject];
	
	if ([[self emailSelectionSet] count] > 0)
	{
		NSArray *emailAddresses = [NSArray arrayWithArray:[[self emailSelectionSet] allObjects]];
		NSArray *recipients = [emailAddresses valueForKey:@"value"];
		[mailComposer setToRecipients:recipients];
	}
	
	if ([[self actionSelectionSet] count] > 0)
	{
		NSSortDescriptor *dateDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"defaultSortDate" ascending:[[NSUserDefaults standardUserDefaults] isActionsSortAscendingBTI]] autorelease];
		
		NSArray *sortedActions = [[self actionSelectionSet] sortedArrayUsingDescriptors:[NSArray arrayWithObject:dateDescriptor]];
		
		NSMutableString *fullEmailString = [NSMutableString string];
		
		[fullEmailString appendString:[NSString stringWithFormat:@"%@ %@: %@\n", person, summary, [[self person] fullName]]];
		
		NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
		[fetchRequest setEntity:[PersonDetailInfo entityDescriptionInContextBTI:context]];
		[fetchRequest setSortDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
		
		NSArray *detailInfos = [context executeFetchRequest:fetchRequest error:nil];
		NSLog(@"detailInfos is: %@", [detailInfos description]);
		
		for (PersonDetailInfo *detailInfo in detailInfos)
		{
			PersonDetailValue *detailValue = [[self person] detailValueForPersonDetailInfo:detailInfo];
			NSLog(@"detailValue is: %@", [detailValue description]);
			
			if ([[detailValue name] length] > 0)
			{
				[fullEmailString appendString:[NSString stringWithFormat:@"%@: %@\n", [detailInfo name], [detailValue name]]];
			}
		}
		
//		if ( ([[self person] other] != nil) && ([[[self person] other] length] > 0) )
//		{
//			[fullEmailString appendString:[NSString stringWithFormat:@"%@: %@\n", other, [[self person] other]]];
//		}
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyyy_MMMM_dd_hh_mm"];
		
		for (Action *action in sortedActions)
		{
			[fullEmailString appendString:[action summaryStringForEmail]];
			
			NSInteger imageCounter = 0;
			
			for (ActionValue *actionValue in [action actionValues])
			{
				if ([[[actionValue actionFieldInfo] type] intValue] != BTIActionFieldValueTypeImage)
					continue;
				
				if ([actionValue imageMediaInfo] == nil)
					continue;
				
				imageCounter++;
				
				NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
				
				// There is an image.
				NSString *fileName = [NSString stringWithFormat:@"%@_%d.jpg", [dateFormatter stringFromDate:[action dateCreated]], imageCounter];
				NSData *imageData = UIImageJPEGRepresentation([[actionValue imageMediaInfo] image], kJPEGImageQuality);
				
				[mailComposer addAttachmentData:imageData
									   mimeType:@"image/jpeg"
									   fileName:fileName];
				
				[pool drain], pool = nil;
			}
		}
		
		[dateFormatter release], dateFormatter = nil;
		
		[mailComposer setMessageBody:fullEmailString isHTML:NO];
	}
		
	[self presentModalViewController:mailComposer animated:YES];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

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
	
	NSInteger rows = [[parent emailAddresses] count];
	
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
	
	NSArray *sortedEmailAddresses = [[parent emailAddresses] sortedArrayUsingDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
	EmailAddress *emailAddress = [sortedEmailAddresses objectAtIndex:[indexPath row]];
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
	
	[[cell textLabel] setText:[emailAddress type]];
	[[cell detailTextLabel] setText:[emailAddress value]];
	
	[cell setAccessoryType:([[self emailSelectionSet] containsObject:emailAddress]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:[indexPath section] inSection:0];
	Parent *parent = [[self fetchedResultsController] objectAtIndexPath:adjustedIndexPath];
	
	DataController *dataController = [DataController sharedDataController];
	
	NSArray *sortedEmailAddresses = [[parent emailAddresses] sortedArrayUsingDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
	EmailAddress *emailAddress = [sortedEmailAddresses objectAtIndex:[indexPath row]];
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	if ([[self emailSelectionSet] containsObject:emailAddress])
	{
		[[self emailSelectionSet] removeObject:emailAddress];
		[cell setAccessoryType:UITableViewCellAccessoryNone];
	}
	else
	{
		[[self emailSelectionSet] addObject:emailAddress];
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - MFMailComposeViewControllerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController*)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError*)error
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[controller setDelegate:nil];
	
	if (result == MFMailComposeResultFailed)
	{
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can not send mail"
														message:@"Sorry, we were unable to send the email."
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release], alert = nil;
	}
	
	if ([self isSkipMode])
	{
		[self dismissModalViewControllerAnimated:YES];
		
		[[self mainTableView] setDelegate:nil];
		[[self mainTableView] setDataSource:nil];
		
		[[self navigationController] popViewControllerAnimated:YES];
	}
	else
	{
		[self dismissModalViewControllerAnimated:YES];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
