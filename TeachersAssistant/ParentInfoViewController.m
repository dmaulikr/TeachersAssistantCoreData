//
//  ParentInfoViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/15/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ParentInfoViewController.h"

// Models and other global

// Sub-controllers
#import "ParentEmailInfoViewController.h"
#import "ParentPhoneInfoViewController.h"

// Views
#import "PersonInfoCell.h"

// Private Constants
typedef enum {
	BTIParentInfoSectionName = 0,
	BTIParentInfoSectionEmail,
	BTIParentInfoSectionPhone,
	BTIParentInfoSectionsCount
} BTIParentInfoSection;

@interface ParentInfoViewController ()

// Private Properties
@property (nonatomic, retain) NSFetchedResultsController *emailAddressesResultsController;
@property (nonatomic, retain) NSFetchedResultsController *phoneNumbersResultsController;
@property (nonatomic, retain) UITextField *activeTextField;
@property (nonatomic, retain) NSIndexPath *activeIndexPath;
@property (nonatomic, retain) Parent *tempParent;
@property (nonatomic, assign) BOOL canSendMail;
@property (nonatomic, assign) BOOL canMakeCall;

// Notification Handlers
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;


// UI Response Methods
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)saveButtonPressed:(UIBarButtonItem *)button;


// Misc Methods
- (void)saveDataInTextField:(UITextField *)textField;

@end

@implementation ParentInfoViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize personInfoCell = ivPersonInfoCell;
@synthesize scratchPerson = ivScratchPerson;
@synthesize scratchParent = ivScratchParent;

// Private
@synthesize emailAddressesResultsController = ivEmailAddressesResultsController;
@synthesize phoneNumbersResultsController = ivPhoneNumbersResultsController;
@synthesize scratchObjectContext = ivScratchObjectContext;
@synthesize activeTextField = ivActiveTextField;
@synthesize activeIndexPath = ivActiveIndexPath;
@synthesize tempParent = ivTempParent;
@synthesize canSendMail = ivCanSendMail;
@synthesize canMakeCall = ivCanMakeCall;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTableView:nil];
	[self setPersonInfoCell:nil];
	[self setScratchObjectContext:nil];
	[self setScratchPerson:nil];
	[self setScratchParent:nil];
	
	// Private Properties
	[self setEmailAddressesResultsController:nil];
	[self setPhoneNumbersResultsController:nil];
	[self setActiveTextField:nil];
    [self setActiveIndexPath:nil];
    [self setTempParent:nil];
	
	
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

- (void)setScratchParent:(Parent *)scratchParent
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[scratchParent retain];
	[ivScratchParent release];
	ivScratchParent = scratchParent;

	[self setTempParent:scratchParent];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSFetchedResultsController *)emailAddressesResultsController
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivEmailAddressesResultsController == nil)
	{
		DataController *dataController = [DataController sharedDataController];
		NSManagedObjectContext *context = [self scratchObjectContext];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		[fetchRequest setEntity:[EmailAddress entityDescriptionInContextBTI:context]];
		
		[fetchRequest setSortDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
		
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"parent == %@", [self tempParent]]];
		
		ivEmailAddressesResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																		 managedObjectContext:context
																		   sectionNameKeyPath:nil
																					cacheName:nil];
		[ivEmailAddressesResultsController setDelegate:self];
		
		[ivEmailAddressesResultsController performFetchBTI];
		
		[fetchRequest release], fetchRequest = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivEmailAddressesResultsController;
}

- (NSFetchedResultsController *)phoneNumbersResultsController
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivPhoneNumbersResultsController == nil)
	{
		DataController *dataController = [DataController sharedDataController];
		NSManagedObjectContext *context = [self scratchObjectContext];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		[fetchRequest setEntity:[PhoneNumber entityDescriptionInContextBTI:context]];
		
		[fetchRequest setSortDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
		
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"parent == %@", [self tempParent]]];
		
		ivPhoneNumbersResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																				managedObjectContext:context
																				  sectionNameKeyPath:nil
																						   cacheName:nil];
		[ivPhoneNumbersResultsController setDelegate:self];
		
		[ivPhoneNumbersResultsController performFetchBTI];
		
		[fetchRequest release], fetchRequest = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivPhoneNumbersResultsController;
}

#pragma mark - Initialization and UI Creation Methods

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	DataController *dataController = [DataController sharedDataController];
	NSString *parent = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierParent];
	
	if ([self scratchParent] == nil)
	{
		[self setTitle:[NSString stringWithFormat:@"Add %@", parent]];
	}
	else
	{
		[self setTitle:[NSString stringWithFormat:@"Edit %@", parent]];
	}
	
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
	
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	
	[self setToolbarItems:[NSArray arrayWithObjects:flexItem, [self editButtonItem], nil]];
	
	[flexItem release], flexItem = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self navigationController] setToolbarHidden:NO animated:YES];
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	NSManagedObjectContext *context = [self scratchObjectContext];
	
	if ([self tempParent] == nil)
	{
		Parent *aParent = [Parent managedObjectInContextBTI:context];
		[self setTempParent:aParent];
	}
	
//	[[self emailAddressesResultsController] performFetchBTI];
//	[[self phoneNumbersResultsController] performFetchBTI];
	
	[self setCanSendMail:[MFMailComposeViewController canSendMail]];
	
	NSURL *url = [NSURL URLWithString:@"tel:"];
	[self setCanMakeCall:[[UIApplication sharedApplication] canOpenURL:url]];

	[self setEmailAddressesResultsController:nil];
	[self setPhoneNumbersResultsController:nil];
	
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
	
	UITextField *activeTextField = [self activeTextField];
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[notificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];

	[activeTextField resignFirstResponder];
	[self setActiveTextField:nil];
	
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

- (void)keyboardWillShow:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0.0, 0.0, 370.0, 0.0);
	[[self mainTableView] setContentInset:edgeInsets];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self mainTableView] setContentInset:UIEdgeInsetsZero];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UI Response Methods

- (void)cancelButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if ([self scratchParent] == nil)
	{
		[[self scratchObjectContext] deleteObject:[self tempParent]];
	}
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)saveButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self saveDataInTextField:[self activeTextField]];
	
//	if ([[self tempParent] managedObjectContext] == nil)
//	{
//		[[[self person] managedObjectContext] insertObject:[self tempParent]];
//	}
	
	if ([self scratchParent] == nil)
	{
		[[self tempParent] setSortOrder:[NSNumber numberWithInt:[[[self scratchPerson] parents] count]]];
		[[self scratchPerson] addParentsObject:[self tempParent]];
	}
//	else
//	{
//		[[self parent] setName:[[self tempParent] name]];
//		[[self parent] setEmail:[[self tempParent] email]];
//		[[self parent] setPhoneNumber:[[self tempParent] phoneNumber]];
//	}
	
	[[self navigationController] popViewControllerAnimated:YES];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (void)saveDataInTextField:(UITextField *)textField
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (textField == nil)
	{
		NSLog(@"<<< Leaving %s >>> EARLY - No text field", __PRETTY_FUNCTION__);
		return;
	}
	
	NSIndexPath *indexPath = [[self mainTableView] mdIndexPathForRowContainingView:textField];
	
	if (indexPath == nil)
	{
		NSLog(@"Using stored index path");
		indexPath = [self activeIndexPath];
	}
	
	NSString *text = [[textField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	NSInteger section = [indexPath section];
	
	if (section == BTIParentInfoSectionName)
	{
		[[self tempParent] setName:text];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger sections = BTIParentInfoSectionsCount;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return sections;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section 
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *header = nil;
	
	switch (section) {
		case BTIParentInfoSectionName:
			break;
		case BTIParentInfoSectionEmail:
		{
			header = @"Email";
		}
			break;
		case BTIParentInfoSectionPhone:
		{
			header = @"Phone";
		}
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return header;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger rows = 0;
	
	switch (section) {
		case BTIParentInfoSectionName:
			rows = 1;
			break;
		case BTIParentInfoSectionEmail:
		{
			id <NSFetchedResultsSectionInfo> sectionInfo = [[[self emailAddressesResultsController] sections] objectAtIndex:0];
			rows = [[sectionInfo objects] count] + 1;		// Allow for add row
		}
			break;
		case BTIParentInfoSectionPhone:
		{
			id <NSFetchedResultsSectionInfo> sectionInfo = [[[self phoneNumbersResultsController] sections] objectAtIndex:0];
			rows = [[sectionInfo objects] count] + 1;		// Allow for add row
		}
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	static NSString *plainCellIdentifier = @"plainCellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:plainCellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:plainCellIdentifier] autorelease];
	}
	
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	
	switch (section) {
		case BTIParentInfoSectionName:
		{
			[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PersonInfoCell class]) owner:self options:nil];
			PersonInfoCell *textFieldCell = [self personInfoCell];
			[self setPersonInfoCell:nil];
			
			[[textFieldCell label] setText:@"Name"];
			[[textFieldCell textField] setPlaceholder:@"Name"];
			[[textFieldCell textField] setText:[[self tempParent] name]];
			
			cell = textFieldCell;
		}
			break;
		case BTIParentInfoSectionEmail:
		{
			if (row == [[[self emailAddressesResultsController] fetchedObjects] count])
			{
				[[cell textLabel] setText:@"Add Email Address"];
				[[cell detailTextLabel] setText:nil];
				
				[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			}
			else
			{
				NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:[indexPath row] inSection:0];
				EmailAddress *emailAddress = [[self emailAddressesResultsController] objectAtIndexPath:adjustedIndexPath];
				
				[[cell textLabel] setText:[emailAddress type]];
				[[cell detailTextLabel] setText:[emailAddress value]];
				
				[cell setAccessoryType:([self canSendMail]) ? UITableViewCellAccessoryDetailDisclosureButton : UITableViewCellAccessoryNone];
			}
		}
			break;
		case BTIParentInfoSectionPhone:
		{
			if (row == [[[self phoneNumbersResultsController] fetchedObjects] count])
			{
				[[cell textLabel] setText:@"Add Phone Number"];
				[[cell detailTextLabel] setText:nil];
				
				[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			}
			else
			{
				NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:[indexPath row] inSection:0];
				PhoneNumber *phoneNumber = [[self phoneNumbersResultsController] objectAtIndexPath:adjustedIndexPath];
				
				[[cell textLabel] setText:[phoneNumber type]];
				[[cell detailTextLabel] setText:[phoneNumber value]];
				
				[cell setAccessoryType:([self canMakeCall]) ? UITableViewCellAccessoryDetailDisclosureButton : UITableViewCellAccessoryNone];
			}
		}
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	BOOL canEdit = YES;
	
	switch ([indexPath section]) {
		case BTIParentInfoSectionName:
			canEdit = NO;
			break;
		case BTIParentInfoSectionEmail:
			canEdit = ([indexPath row] != [[[self emailAddressesResultsController] fetchedObjects] count]);
			break;
		case BTIParentInfoSectionPhone:
			canEdit = ([indexPath row] != [[[self phoneNumbersResultsController] fetchedObjects] count]);
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return canEdit;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:[indexPath row] inSection:0];
		
		switch ([indexPath section]) {
			case BTIParentInfoSectionEmail:
			{
				EmailAddress *email = [[self emailAddressesResultsController] objectAtIndexPath:adjustedIndexPath];
				
				[[self scratchObjectContext] deleteObject:email];
			}
				break;
			case BTIParentInfoSectionPhone:
			{
				PhoneNumber *phone = [[self phoneNumbersResultsController] objectAtIndexPath:adjustedIndexPath];
				
				[[self scratchObjectContext] deleteObject:phone];

			}
				break;
			default:
				break;
		}
	}
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	BOOL canMove = YES;
	
	switch ([indexPath section]) {
		case BTIParentInfoSectionName:
			canMove = NO;
			break;
		case BTIParentInfoSectionEmail:
			canMove = ([indexPath row] != [[[self emailAddressesResultsController] fetchedObjects] count]);
			break;
		case BTIParentInfoSectionPhone:
			canMove = ([indexPath row] != [[[self phoneNumbersResultsController] fetchedObjects] count]);
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return canMove;
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
	  toIndexPath:(NSIndexPath *)toIndexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	switch ([fromIndexPath section]) {
		case BTIParentInfoSectionEmail:
		{
			NSMutableArray *emails = [NSMutableArray arrayWithArray:[[self emailAddressesResultsController] fetchedObjects]];
			
			EmailAddress *email = [emails objectAtIndex:[fromIndexPath row]];
			[emails removeObjectAtIndex:[fromIndexPath row]];
			[emails insertObject:email atIndex:[toIndexPath row]];
			
			[[self emailAddressesResultsController] setDelegate:nil];
			
			[emails enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
				EmailAddress *emailAddress = (EmailAddress *)object;
				[emailAddress setSortOrder:[NSNumber numberWithInt:index]];
			}];
			
			[[self emailAddressesResultsController] setDelegate:self];
			[[self emailAddressesResultsController] performFetchBTI];
		}
			break;
		case BTIParentInfoSectionPhone:
		{
			NSMutableArray *phones = [NSMutableArray arrayWithArray:[[self phoneNumbersResultsController] fetchedObjects]];
			
			PhoneNumber *phone = [phones objectAtIndex:[fromIndexPath row]];
			[phones removeObjectAtIndex:[fromIndexPath row]];
			[phones insertObject:phone atIndex:[toIndexPath row]];
			
			[[self phoneNumbersResultsController] setDelegate:nil];
			
			[phones enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
				PhoneNumber *phoneNumber = (PhoneNumber *)object;
				[phoneNumber setSortOrder:[NSNumber numberWithInt:index]];
			}];
			
			[[self phoneNumbersResultsController] setDelegate:self];
			[[self phoneNumbersResultsController] performFetchBTI];
		}
			break;	
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	
	switch (section) {
		case BTIParentInfoSectionName:
		{
			PersonInfoCell *cell = (PersonInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
			
			[[cell textField] becomeFirstResponder];
		}
			break;
		case BTIParentInfoSectionEmail:
		{
			ParentEmailInfoViewController *nextViewController = [[ParentEmailInfoViewController alloc] init];
			[nextViewController setScratchObjectContext:[self scratchObjectContext]];
			[nextViewController setScratchParent:[self tempParent]];
			
			if (row != [[[self emailAddressesResultsController] fetchedObjects] count])
			{
				NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:[indexPath row] inSection:0];
				EmailAddress *emailAddress = [[self emailAddressesResultsController] objectAtIndexPath:adjustedIndexPath];
				[nextViewController setScratchEmailAddress:emailAddress];
			}
			
			[[self navigationController] pushViewController:nextViewController animated:YES];
			
			[nextViewController release], nextViewController = nil;
		}
			break;
		case BTIParentInfoSectionPhone:
		{
			ParentPhoneInfoViewController *nextViewController = [[ParentPhoneInfoViewController alloc] init];
			[nextViewController setScratchObjectContext:[self scratchObjectContext]];
			[nextViewController setScratchParent:[self tempParent]];
			
			if (row != [[[self phoneNumbersResultsController] fetchedObjects] count])
			{
				NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:[indexPath row] inSection:0];
				PhoneNumber *phoneNumber = [[self phoneNumbersResultsController] objectAtIndexPath:adjustedIndexPath];
				[nextViewController setScratchPhoneNumber:phoneNumber];
			}
			
			[[self navigationController] pushViewController:nextViewController animated:YES];
			
			[nextViewController release], nextViewController = nil;
		}
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
	   toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger sourceSection = [sourceIndexPath section];
	NSInteger destinationSection = [proposedDestinationIndexPath section];
	NSInteger destinationRow = [proposedDestinationIndexPath row];
	
	if (sourceSection != destinationSection)
	{
		if ( (sourceSection == BTIParentInfoSectionEmail) && (destinationSection == BTIParentInfoSectionName) )
		{
			proposedDestinationIndexPath = [NSIndexPath indexPathForRow:0 inSection:BTIParentInfoSectionEmail];
		}
		else if ( (sourceSection == BTIParentInfoSectionEmail) && (destinationSection == BTIParentInfoSectionPhone) )
		{
			proposedDestinationIndexPath = [NSIndexPath indexPathForRow:[[[self emailAddressesResultsController] fetchedObjects] count] - 1 inSection:BTIParentInfoSectionEmail];
		}
		else if (sourceSection == BTIParentInfoSectionPhone)
		{
			proposedDestinationIndexPath = [NSIndexPath indexPathForRow:0 inSection:BTIParentInfoSectionPhone];
		}
	}
	else
	{
		if (sourceSection == BTIParentInfoSectionEmail)
		{
			if (destinationRow == [[[self emailAddressesResultsController] fetchedObjects] count])
			{
				proposedDestinationIndexPath = [NSIndexPath indexPathForRow:destinationRow - 1 inSection:destinationSection];
			}
		}
		else if (sourceSection == BTIParentInfoSectionPhone)
		{
			if (destinationRow == [[[self phoneNumbersResultsController] fetchedObjects] count])
			{
				proposedDestinationIndexPath = [NSIndexPath indexPathForRow:destinationRow - 1 inSection:destinationSection];
			}
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:[indexPath row] inSection:0];
	
	switch ([indexPath section]) {
		case BTIParentInfoSectionEmail:
		{
			EmailAddress *emailAddress = [[self emailAddressesResultsController] objectAtIndexPath:adjustedIndexPath];
			
			MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
			[mailComposer setMailComposeDelegate:self];
			
			[mailComposer setToRecipients:[NSArray arrayWithObjects:[emailAddress value], nil]];
			
			[self presentModalViewController:mailComposer animated:YES];
		}
			break;
		case BTIParentInfoSectionPhone:
		{
			PhoneNumber *phone = [[self phoneNumbersResultsController] objectAtIndexPath:adjustedIndexPath];
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
		}
			break;	
		default:
			break;
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UITextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0.0, 0.0, 370.0, 0.0);
	[[self mainTableView] setContentInset:edgeInsets];
	
	PersonInfoCell *cell = (PersonInfoCell *)[[textField superview] superview];
	NSIndexPath *indexPath = [[self mainTableView] indexPathForCell:cell];
	
	[self setActiveTextField:textField];
	[self setActiveIndexPath:indexPath];
	
	[[self mainTableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self saveDataInTextField:textField];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[textField resignFirstResponder];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return YES;
}

#pragma mark - NSFetchedResultsController Delegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self mainTableView] beginUpdates];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self mainTableView] endUpdates];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSIndexPath *adjustedNewIndexPath = newIndexPath;
	NSIndexPath *adjustedIndexPath = indexPath;
	
	if (controller == [self emailAddressesResultsController])
	{
		adjustedIndexPath = [NSIndexPath indexPathForRow:[indexPath row] inSection:BTIParentInfoSectionEmail];
		adjustedNewIndexPath = [NSIndexPath indexPathForRow:[newIndexPath row] inSection:BTIParentInfoSectionEmail];
	}
	else if (controller == [self phoneNumbersResultsController])
	{
		adjustedIndexPath = [NSIndexPath indexPathForRow:[indexPath row] inSection:BTIParentInfoSectionPhone];
		adjustedNewIndexPath = [NSIndexPath indexPathForRow:[newIndexPath row] inSection:BTIParentInfoSectionPhone];
	}
	
	switch (type)
	{
		case NSFetchedResultsChangeInsert:
			NSLog(@"insert");
			[[self mainTableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:adjustedNewIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			NSLog(@"delete");
			[[self mainTableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:adjustedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate:
			NSLog(@"update");
			//			[self configureCell:(CategoryCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
		case NSFetchedResultsChangeMove:
			NSLog(@"move");
			[[self mainTableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:adjustedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			[[self mainTableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:adjustedNewIndexPath] withRowAnimation:UITableViewRowAnimationFade];
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (controller == [self emailAddressesResultsController])
	{
		sectionIndex = BTIParentInfoSectionEmail;
	}
	else if (controller == [self phoneNumbersResultsController])
	{
		sectionIndex = BTIParentInfoSectionPhone;
	}
	
	switch (type)
	{
		case NSFetchedResultsChangeInsert:
			NSLog(@"insert");
			[[self mainTableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			NSLog(@"delete");
			[[self mainTableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		default:
			NSLog(@"There was some other option!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - MFMailComposeViewControllerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController*)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError*)error
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self dismissModalViewControllerAnimated:YES];
	
	if (result == MFMailComposeResultFailed)
	{
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can not send mail"
														message:@"Sorry, we were unable to send the email."
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release], alert = nil;
	}
	
	[controller release], controller = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
