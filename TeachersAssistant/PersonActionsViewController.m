//
//  PersonActionsViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/15/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "PersonActionsViewController.h"

// Models and other global

// Sub-controllers
#import "ActionDetailViewController.h"
#import "PersonInfoViewController.h"
#import "ParentDialerViewController.h"
#import "ParentEmailerViewController.h"
#import "ParentMessagerViewController.h"
#import "UpgradeViewController.h"

// Views
#import "PersonActionsCell.h"

// Private Constants


typedef enum {
	BTIActionListDisplayModeNormal = 0,
	BTIActionListDisplayModeEdit,
	BTIActionListDisplayModeEmail,
	BTIActionListDisplayModePrint,
	BTIActionListDisplayModeMessage,
} BTIActionListDisplayMode;

@interface PersonActionsViewController ()

// Private Properties
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) UIBarButtonItem *addButton;
@property (nonatomic, retain) UIBarButtonItem *upgradeButton;
@property (nonatomic, retain) UIBarButtonItem *trashButton;
@property (nonatomic, retain) UIBarButtonItem *selectAllButton;
@property (nonatomic, retain) UIBarButtonItem *selectNoneButton;
@property (nonatomic, retain) UIBarButtonItem *mostRecentButton;
@property (nonatomic, retain) UIBarButtonItem *cancelButton;
@property (nonatomic, retain) UIBarButtonItem *flexItem;
@property (nonatomic, retain) UIBarButtonItem *continueButton;
@property (nonatomic, retain) UIBarButtonItem *actionButton;
@property (nonatomic, retain) UIBarButtonItem *jumpButton;
@property (nonatomic, retain) UIBarButtonItem *printButton;
@property (nonatomic, retain) UIBarButtonItem *sortButton;
@property (nonatomic, retain) NSMutableSet *selectionSet;
@property (nonatomic, assign) NSInteger displayMode;
@property (nonatomic, retain) UIActionSheet *activeActionSheet;

// Notification Handlers
- (void)ipadDetailViewDidFinish:(NSNotification *)notification;


// UI Response Methods
- (void)addButtonPressed:(UIBarButtonItem *)button;
- (void)trashButtonPressed:(UIBarButtonItem *)button;
- (void)upgradeButtonPressed:(UIBarButtonItem *)button;
- (void)selectAllButtonPressed:(UIBarButtonItem *)button;
- (void)selectNoneButtonPressed:(UIBarButtonItem *)button;
- (void)mostRecentButtonPressed:(UIBarButtonItem *)button;
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)continueButtonPressed:(UIBarButtonItem *)button;
- (void)actionButtonPressed:(UIBarButtonItem *)button;
- (void)jumpButtonPressed:(UIBarButtonItem *)button;
- (void)printButtonPressed:(UIBarButtonItem *)button;
- (void)sortButtonPressed:(UIBarButtonItem *)button;

// Misc Methods
- (void)refreshToolbars;
- (void)refreshButtonStatus;
- (void)reloadTableWithDeselect:(BOOL)shouldDeselect;

@end

@implementation PersonActionsViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize personActionsCell = ivPersonActionsCell;
@synthesize tableHeaderView = ivTableHeaderView;
@synthesize person = ivPerson;
@synthesize imageView = ivImageView;
@synthesize centeredHeaderView = ivCenteredHeaderView;
@synthesize centeredHeaderLabel = ivCenteredHeaderLabel;
@synthesize splitHeaderView = ivSplitHeaderView;
@synthesize leftHeaderLabel = ivLeftHeaderLabel;
@synthesize rightHeaderLabel = ivRightHeaderLabel;
@synthesize gradingPeriodLabel = ivGradingPeriodLabel;

// Private
@synthesize fetchedResultsController = ivFetchedResultsController;
@synthesize addButton = ivAddButton;
@synthesize upgradeButton = ivUpgradeButton;
@synthesize trashButton = ivTrashButton;
@synthesize selectAllButton = ivSelectAllButton;
@synthesize selectNoneButton = ivSelectNoneButton;
@synthesize mostRecentButton = ivMostRecentButton;
@synthesize cancelButton = ivCancelButton;
@synthesize flexItem = ivFlexItem;
@synthesize continueButton = ivContinueButton;
@synthesize actionButton = ivActionButton;
@synthesize jumpButton = ivJumpButton;
@synthesize printButton = ivPrintButton;
@synthesize sortButton = ivSortButton;
@synthesize selectionSet = ivSelectionSet;
@synthesize displayMode = ivDisplayMode;
@synthesize activeActionSheet = ivActiveActionSheet;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTableView:nil];
	[self setPersonActionsCell:nil];
	[self setTableHeaderView:nil];
	[self setPerson:nil];
	[self setImageView:nil];
    [self setCenteredHeaderView:nil];
    [self setCenteredHeaderLabel:nil];
    [self setSplitHeaderView:nil];
    [self setLeftHeaderLabel:nil];
    [self setRightHeaderLabel:nil];
	[self setGradingPeriodLabel:nil];
	
	// Private Properties
	[self setFetchedResultsController:nil];
	[self setAddButton:nil];
    [self setUpgradeButton:nil];
	[self setTrashButton:nil];
    [self setSelectAllButton:nil];
    [self setSelectNoneButton:nil];
    [self setMostRecentButton:nil];
    [self setCancelButton:nil];
	[self setFlexItem:nil];
	[self setContinueButton:nil];
	[self setActionButton:nil];
	[self setJumpButton:nil];
	[self setPrintButton:nil];
	[self setSortButton:nil];
	[self setSelectionSet:nil];
	[self setActiveActionSheet:nil];
	
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
	[self setTableHeaderView:nil];
    [self setCenteredHeaderView:nil];
    [self setCenteredHeaderLabel:nil];
    [self setSplitHeaderView:nil];
    [self setLeftHeaderLabel:nil];
    [self setRightHeaderLabel:nil];
	[self setGradingPeriodLabel:nil];
	[self setAddButton:nil];
    [self setUpgradeButton:nil];
	[self setTrashButton:nil];
    [self setSelectAllButton:nil];
    [self setSelectNoneButton:nil];
    [self setMostRecentButton:nil];
    [self setCancelButton:nil];
	[self setFlexItem:nil];
	[self setContinueButton:nil];
	[self setActionButton:nil];
	[self setJumpButton:nil];
	[self setPrintButton:nil];
	[self setSortButton:nil];
	[self setImageView:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

- (NSFetchedResultsController *)fetchedResultsController
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivFetchedResultsController == nil)
	{
		DataController *dataController = [DataController sharedDataController];
		
		[dataController filterActions:[[self person] actions]];
		
		NSManagedObjectContext *context = [dataController managedObjectContext];
		
		ivFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[dataController actionFetchRequestForPerson:[self person]]
																		 managedObjectContext:context
																		   sectionNameKeyPath:nil
																					cacheName:nil];
//		[NSFetchedResultsController deleteCacheWithName:[ivFetchedResultsController cacheName]];
		[ivFetchedResultsController setDelegate:self];
		
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

- (UIBarButtonItem *)addButton
{
	if (ivAddButton == nil)
	{
		ivAddButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																	target:self
																	action:@selector(addButtonPressed:)];
	}
	return ivAddButton;
}

- (UIBarButtonItem *)upgradeButton
{
	if (ivUpgradeButton == nil)
	{
		ivUpgradeButton = [[UIBarButtonItem alloc] initWithTitle:@"Upgrade"
														   style:UIBarButtonItemStyleBordered
														  target:self
														  action:@selector(upgradeButtonPressed:)];
	}
	return ivUpgradeButton;
}

- (UIBarButtonItem *)trashButton
{
	if (ivTrashButton == nil)
	{
		ivTrashButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
															  target:self
															  action:@selector(trashButtonPressed:)];
	}
	return ivTrashButton;
}

- (UIBarButtonItem *)actionButton
{
	if (ivActionButton == nil)
	{
		ivActionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																	   target:self
																	   action:@selector(actionButtonPressed:)];
		[ivActionButton setStyle:UIBarButtonItemStyleBordered];
	}
	return ivActionButton;
}

- (UIBarButtonItem *)jumpButton
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivJumpButton == nil)
	{
		DataController *dataController = [DataController sharedDataController];
		NSString *jumpTitle = nil;
		switch ([[NSUserDefaults standardUserDefaults] btiJumpButtonMode]) {
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
		
		ivJumpButton = [[UIBarButtonItem alloc] initWithTitle:jumpTitle
														style:UIBarButtonItemStyleBordered
													   target:self
													   action:@selector(jumpButtonPressed:)];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivJumpButton;
}

- (UIBarButtonItem *)selectAllButton
{
	if (ivSelectAllButton == nil)
	{
		ivSelectAllButton = [[UIBarButtonItem alloc] initWithTitle:@"Select All"
															 style:UIBarButtonItemStyleBordered
															target:self
															action:@selector(selectAllButtonPressed:)];
	}
	return ivSelectAllButton;
}

- (UIBarButtonItem *)selectNoneButton
{
	if (ivSelectNoneButton == nil)
	{
		ivSelectNoneButton = [[UIBarButtonItem alloc] initWithTitle:@"Select None"
															  style:UIBarButtonItemStyleBordered
															 target:self
															 action:@selector(selectNoneButtonPressed:)];
	}
	return ivSelectNoneButton;
}

- (UIBarButtonItem *)mostRecentButton
{
	if (ivMostRecentButton == nil)
	{
		ivMostRecentButton = [[UIBarButtonItem alloc] initWithTitle:@"Most Recent"
															  style:UIBarButtonItemStyleBordered
															 target:self
															 action:@selector(mostRecentButtonPressed:)];
	}
	return ivMostRecentButton;
}

- (UIBarButtonItem *)cancelButton
{
	if (ivCancelButton == nil)
	{
		ivCancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																	   target:self
																	   action:@selector(cancelButtonPressed:)];
	}
	return ivCancelButton;
}

- (UIBarButtonItem *)continueButton
{
	if (ivContinueButton == nil)
	{
		ivContinueButton = [[UIBarButtonItem alloc] initWithTitle:@"Continue"
															style:UIBarButtonItemStyleBordered
														   target:self
														   action:@selector(continueButtonPressed:)];
	}
	return ivContinueButton;
}

- (UIBarButtonItem *)printButton
{
	if (ivPrintButton == nil)
	{
		ivPrintButton = [[UIBarButtonItem alloc] initWithTitle:@"Print"
														 style:UIBarButtonItemStyleBordered
														target:self
														action:@selector(printButtonPressed:)];
	}
	return ivPrintButton;
}

- (UIBarButtonItem *)sortButton
{
	if (ivSortButton == nil)
	{
		ivSortButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reverse.png"]
														style:UIBarButtonItemStyleBordered
													   target:self
													   action:@selector(sortButtonPressed:)];
	}
	return ivSortButton;
}

- (UIBarButtonItem *)flexItem
{
	if (ivFlexItem == nil)
	{
		ivFlexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																   target:nil
																   action:nil];
	}
	return ivFlexItem;
}

#pragma mark - Initialization and UI Creation Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ipadDetailViewDidFinish:) name:kInfractionDetailViewDidFinishNotification object:nil];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return self;
}

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[[self navigationItem] setRightBarButtonItem:[self addButton]];
	
	// Set the table row height
	[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PersonActionsCell class]) owner:self options:nil];
	[[self mainTableView] setRowHeight:[[self personActionsCell] frame].size.height];
	[self setPersonActionsCell:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ipadDetailViewDidFinish:) name:kInfractionDetailViewDidFinishNotification object:nil];
	
	[self setEditing:NO animated:NO];
	
//	DataController *dataController = [DataController sharedDataController];
//	
//	[dataController filterActions:[[self person] actions]];
	
	[[self selectionSet] removeAllObjects];
	
	[self setDisplayMode:BTIActionListDisplayModeNormal];
	
	UIImage *thumbnail = [[[self person] largeThumbnailMediaInfo] image];
	
	if (thumbnail == nil)
	{
		[[self imageView] setImage:kPersonPlaceholderImage];
	}
	else
	{
		[[self imageView] setImage:thumbnail];
	}
	
	if (![[NSUserDefaults standardUserDefaults] btiShouldShowPersonThumbnails])
	{
		[[self mainTableView] setTableHeaderView:nil];
	}
	else if ([[self person] largeThumbnailMediaInfo] == nil)
	{
		[[self mainTableView] setTableHeaderView:nil];
	}
	else
	{
		[[self mainTableView] setTableHeaderView:[self tableHeaderView]];
	}
	
	if ([[self person] colorLabelPointTotal] == nil)
	{
		[[self person] calculateColorLabelPointTotal];
	}
	
//	[[self mainTableView] reloadData];
	[self reloadTableWithDeselect:NO];
	
	[[self navigationController] setToolbarHidden:NO animated:YES];
	
	[self refreshToolbars];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidAppear:animated];
	
	[[self navigationController] setDelegate:self];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillDisappear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillDisappear:animated];
	
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:kInfractionDetailViewDidFinishNotification object:nil];
	
	[[self fetchedResultsController] setDelegate:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidDisappear:animated];
	
	[[self navigationController] setDelegate:(TeachersAssistantAppDelegate *)[[UIApplication sharedApplication] delegate]];
	
	
	[self setFetchedResultsController:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	BOOL shouldRotate = YES;
	
	if (![[DataController sharedDataController] isIPadVersion])
	{
		shouldRotate = (interfaceOrientation == UIInterfaceOrientationPortrait);
	}
	else
	{
		[[self activeActionSheet] dismissWithClickedButtonIndex:[[self activeActionSheet] cancelButtonIndex] animated:NO];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return shouldRotate;
}

- (void)setEditing:(BOOL)editing
		  animated:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (editing)
	{
		DataController *dataController = [DataController sharedDataController];
		
		if ([dataController isIPadVersion])
		{
			[super setEditing:editing animated:animated];
			
			[[self mainTableView] setEditing:editing animated:animated];
			
			[self setDisplayMode:(editing) ? BTIActionListDisplayModeEdit : BTIActionListDisplayModeNormal];
			
			[self refreshToolbars];
		}
		else
		{
			NSString *pluralActions = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierAction];
			NSString *singularPerson = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
			
			RIButtonItem *actionsItem = [RIButtonItem item];
			[actionsItem setLabel:[NSString stringWithFormat:@"Edit %@", pluralActions]];
			[actionsItem setAction:^{
				[super setEditing:editing animated:animated];
				
				[[self mainTableView] setEditing:editing animated:animated];
				
				[self setDisplayMode:(editing) ? BTIActionListDisplayModeEdit : BTIActionListDisplayModeNormal];
				
				[self refreshToolbars];
			}];
			
			RIButtonItem *detailsItem = [RIButtonItem item];
			[detailsItem setLabel:[NSString stringWithFormat:@"Edit %@ Details", singularPerson]];
			[detailsItem setAction:^{
				PersonInfoViewController *nextViewController = [[PersonInfoViewController alloc] init];
				[nextViewController setPerson:[self person]];
				
				[[self navigationController] pushViewController:nextViewController animated:YES];
				
				[nextViewController release], nextViewController = nil;
			}];
			
			RIButtonItem *cancelItem = [RIButtonItem item];
			[cancelItem setLabel:@"Cancel"];
			
			if ([dataController isIPadVersion])
			{
				cancelItem = nil;
			}
			
			[[self activeActionSheet] dismissWithClickedButtonIndex:[[self activeActionSheet] cancelButtonIndex] animated:NO];
			
			UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
													   cancelButtonItem:nil
												  destructiveButtonItem:nil
													   otherButtonItems:actionsItem, detailsItem, cancelItem, nil];
			[sheet setCancelButtonIndex:2];
			[self setActiveActionSheet:sheet];
			
			if ([dataController isIPadVersion])
			{
				if ( ([[self splitViewController] interfaceOrientation] == UIInterfaceOrientationLandscapeLeft) || ([[self splitViewController] interfaceOrientation] == UIInterfaceOrientationLandscapeRight) )
				{
					[sheet showFromBarButtonItem:[self editButtonItem] animated:YES];
				}
				else
				{
					[sheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
					[sheet showInView:[[self splitViewController] view]];
				}
			}
			else
			{
				[sheet showFromToolbar:[[self navigationController] toolbar]];
			}
			
			[sheet release], sheet = nil;
		}
	}
	else
	{
		[super setEditing:editing animated:animated];
	
		[[self mainTableView] setEditing:editing animated:animated];
	
		[self setDisplayMode:(editing) ? BTIActionListDisplayModeEdit : BTIActionListDisplayModeNormal];
		
		[self refreshToolbars];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Notification Handlers

- (void)ipadDetailViewDidFinish:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

//	DataController *dataController = [DataController sharedDataController];
	
//	[dataController filterActions:[[self person] actions]];
	
	[self reloadTableWithDeselect:YES];
	
	[self refreshToolbars];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UI Response Methods

- (void)addButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if ([[DataController sharedDataController] isIPadVersion])
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:kShouldHideActionDetailViewNotification object:nil];
		
		NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[self person] forKey:kNotificationPersonObjectKey];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kShouldShowActionDetailViewNotification object:dictionary];
	}
	else
	{
		ActionDetailViewController *nextViewController = [[ActionDetailViewController alloc] init];
		[nextViewController setPerson:[self person]];
		
		[[self navigationController] pushViewController:nextViewController animated:YES];
		
		[nextViewController release], nextViewController = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)trashButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if ([[[self person] actions] count] != 0)
	{
		DataController *dataController = [DataController sharedDataController];
		NSString *plural = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierAction];
		NSString *message = [NSString stringWithFormat:@"Delete all %@ for: %@?", plural, [[self person] fullName]];
		
		RIButtonItem *cancelItem = [RIButtonItem item];
		[cancelItem setLabel:@"Cancel"];
		
		RIButtonItem *deleteItem = [RIButtonItem item];
		[deleteItem setLabel:@"Delete"];
		[deleteItem setAction:^{
			[dataController deleteAllActionsInPerson:[self person]];
			
			[[self mainTableView] reloadData];
			
			[self setEditing:NO animated:YES];
		}];
		
		[[self activeActionSheet] dismissWithClickedButtonIndex:[[self activeActionSheet] cancelButtonIndex] animated:NO];
		
		UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:message
												   cancelButtonItem:cancelItem
											  destructiveButtonItem:deleteItem
												   otherButtonItems:nil];
		
		[sheet showFromToolbar:[[self navigationController] toolbar]];
		
		[sheet release], sheet = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)upgradeButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if ([[DataController sharedDataController] isIPadVersion])
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:kShouldShowUpgradeViewNotification object:nil];
	}
	else
	{
		// Using a navigation controller seems to avoid parentViewController issue on iOS 5.  It is not otherwise necessary here.
		
		UpgradeViewController *uvc = [[UpgradeViewController alloc] init];
		
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:uvc];
		[navController setNavigationBarHidden:YES animated:NO];
		
		//		[self presentModalViewController:uvc animated:YES];
		[self presentModalViewController:navController animated:NO];
		
		[uvc release], uvc = nil;
		[navController release], navController = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)jumpButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[(TeachersAssistantAppDelegate *)[[UIApplication sharedApplication] delegate] jumpButtonPressed];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)actionButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self activeActionSheet] dismissWithClickedButtonIndex:[[self activeActionSheet] cancelButtonIndex] animated:NO];
	
	DataController *dataController = [DataController sharedDataController];
	NSString *pluralActions = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierAction];
	
	RIButtonItem *cancelItem = nil;
	if (![dataController isIPadVersion])
	{
		cancelItem = [RIButtonItem item];
		[cancelItem setLabel:@"Cancel"];
	}
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
													 cancelButtonItem:nil
												destructiveButtonItem:nil
													 otherButtonItems:nil];
	
	if ([MFMailComposeViewController canSendMail])
	{
		RIButtonItem *emailItem = [RIButtonItem item];
		[emailItem setLabel:@"Email"];
		[emailItem setAction:^{
			
			RIButtonItem *blankEmailItem = [RIButtonItem item];
			[blankEmailItem setLabel:@"Blank Email"];
			[blankEmailItem setAction:^{
				
				[self setDisplayMode:BTIActionListDisplayModeEmail];
				
				[self continueButtonPressed:nil];
				
			}];
			
			RIButtonItem *chooseItem = [RIButtonItem item];
			[chooseItem setLabel:[NSString stringWithFormat:@"Choose %@", pluralActions]];
			[chooseItem setAction:^{
				
				[self setDisplayMode:BTIActionListDisplayModeEmail];
				
				[self refreshToolbars];
				
				[[self mainTableView] reloadData];
				
			}];
			
			[[self activeActionSheet] dismissWithClickedButtonIndex:[[self activeActionSheet] cancelButtonIndex] animated:NO];
			
			UIActionSheet *emailSheet = [[UIActionSheet alloc] initWithTitle:@"Send"
															cancelButtonItem:nil
													   destructiveButtonItem:nil
															otherButtonItems:blankEmailItem, chooseItem, nil];
			
			if (cancelItem != nil)
			{
				NSInteger cancelIndex = [emailSheet numberOfButtons];
				[emailSheet addButtonItem:cancelItem];
				[emailSheet setCancelButtonIndex:cancelIndex];
			}
			
			[self setActiveActionSheet:emailSheet];
			
			if ([dataController isIPadVersion])
			{
				if (UIInterfaceOrientationIsLandscape([[self splitViewController] interfaceOrientation]))
//				if ( ([[self splitViewController] interfaceOrientation] == UIInterfaceOrientationLandscapeLeft) || ([[self splitViewController] interfaceOrientation] == UIInterfaceOrientationLandscapeRight) )
				{
					[emailSheet showFromBarButtonItem:button animated:YES];
				}
				else
				{
					[emailSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
					[emailSheet showInView:[[self splitViewController] view]];
				}
			}
			else
			{
				[emailSheet showFromToolbar:[[self navigationController] toolbar]];
			}
			
			[emailSheet release], emailSheet = nil;
		}];
		
		[actionSheet addButtonItem:emailItem];
	}
	
	if ([[[self person] parentsWithValidPhoneNumbers] count] > 0)
	{
		// Call
		NSString *title = @"Phone Numbers";
		
		RIButtonItem *phoneItem = [RIButtonItem item];
		[phoneItem setLabel:title];
		[phoneItem setAction:^{
			ParentDialerViewController *nextViewController = [[ParentDialerViewController alloc] init];
			[nextViewController setPerson:[self person]];
			
			[[self navigationController] pushViewController:nextViewController animated:YES];
			
			[nextViewController release], nextViewController = nil;
		}];
		
		[actionSheet addButtonItem:phoneItem];
		
		// Message
		if ([MFMessageComposeViewController canSendText])
		{
			if (![dataController isIPadVersion])
			{
				RIButtonItem *messageItem = [RIButtonItem item];
				[messageItem setLabel:@"Message"];
				[messageItem setAction:^{
					
					RIButtonItem *blankMessageItem = [RIButtonItem item];
					[blankMessageItem setLabel:@"Blank Message"];
					[blankMessageItem setAction:^{
						
						[self setDisplayMode:BTIActionListDisplayModeMessage];
						
						[self continueButtonPressed:nil];
						
					}];
					
					RIButtonItem *chooseItem = [RIButtonItem item];
					[chooseItem setLabel:[NSString stringWithFormat:@"Choose %@", pluralActions]];
					[chooseItem setAction:^{
						
						[self setDisplayMode:BTIActionListDisplayModeMessage];
						
						[self refreshToolbars];
						
						[[self mainTableView] reloadData];
						
					}];
					
					[[self activeActionSheet] dismissWithClickedButtonIndex:[[self activeActionSheet] cancelButtonIndex] animated:NO];
					
					UIActionSheet *messageSheet = [[UIActionSheet alloc] initWithTitle:@"Send"
																	cancelButtonItem:nil
															   destructiveButtonItem:nil
																	otherButtonItems:blankMessageItem, chooseItem, nil];
					
					if (cancelItem != nil)
					{
						NSInteger cancelIndex = [messageSheet numberOfButtons];
						[messageSheet addButtonItem:cancelItem];
						[messageSheet setCancelButtonIndex:cancelIndex];
					}
					
					[self setActiveActionSheet:messageSheet];
					
					if ([dataController isIPadVersion])
					{
						if (UIInterfaceOrientationIsLandscape([[self splitViewController] interfaceOrientation]))
//						if ( ([[self splitViewController] interfaceOrientation] == UIInterfaceOrientationLandscapeLeft) || ([[self splitViewController] interfaceOrientation] == UIInterfaceOrientationLandscapeRight) )
						{
							[messageSheet showFromBarButtonItem:button animated:YES];
						}
						else
						{
							[messageSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
							[messageSheet showInView:[[self splitViewController] view]];
						}
					}
					else
					{
						[messageSheet showFromToolbar:[[self navigationController] toolbar]];
					}
					
					[messageSheet release], messageSheet = nil;
				}];
				
				[actionSheet addButtonItem:messageItem];
			}
		}
	}
	
	NSLog(@"isPrintingAvailable: %@", ([UIPrintInteractionController isPrintingAvailable]) ? @"YES" : @"NO");
	
	if ([UIPrintInteractionController isPrintingAvailable])
	{
		RIButtonItem *printItem = [RIButtonItem item];
		[printItem setLabel:[NSString stringWithFormat:@"Print %@", pluralActions]];
		[printItem setAction:^{
			[self setDisplayMode:BTIActionListDisplayModePrint];
			
			[self refreshToolbars];
			
			[[self mainTableView] reloadData];
		}];
		
		[actionSheet addButtonItem:printItem];
	}
	
	if (cancelItem != nil)
	{
		NSInteger cancelIndex = [actionSheet numberOfButtons];
		[actionSheet addButtonItem:cancelItem];
		[actionSheet setCancelButtonIndex:cancelIndex];
	}
	
	[self setActiveActionSheet:actionSheet];
	
	if ([dataController isIPadVersion])
	{
		if ( ([[self splitViewController] interfaceOrientation] == UIInterfaceOrientationLandscapeLeft) || ([[self splitViewController] interfaceOrientation] == UIInterfaceOrientationLandscapeRight) )
		{
			[actionSheet showFromBarButtonItem:button animated:YES];
		}
		else
		{
			[actionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
			[actionSheet showInView:[[self splitViewController] view]];
		}
	}
	else
	{
		[actionSheet showFromToolbar:[[self navigationController] toolbar]];
	}
	
	[actionSheet release], actionSheet = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)selectAllButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self selectionSet] removeAllObjects];
	
	[[self selectionSet] addObjectsFromArray:[[self fetchedResultsController] fetchedObjects]];
	
	[[self mainTableView] reloadData];
	
	[self refreshButtonStatus];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)selectNoneButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self selectionSet] removeAllObjects];
	
	[[self mainTableView] reloadData];
	
	[self refreshButtonStatus];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)mostRecentButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	Action *action = [[[self fetchedResultsController] fetchedObjects] lastObject];
	
	if (action == nil)
	{
		NSLog(@"<<< Leaving %s >>> EARLY - No Action", __PRETTY_FUNCTION__);
		return;
	}
	
	NSIndexPath *indexPath = [[self fetchedResultsController] indexPathForObject:action];
	PersonActionsCell *cell = (PersonActionsCell *)[[self mainTableView] cellForRowAtIndexPath:indexPath];
	
	if (![[self selectionSet] containsObject:action])
	{
		[[self selectionSet] addObject:action];
	}
	
	[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	
	[[self mainTableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	
	[self refreshButtonStatus];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)cancelButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self selectionSet] removeAllObjects];
	
	[self setDisplayMode:BTIActionListDisplayModeNormal];
	
	[[self mainTableView] reloadData];
	
	[self refreshToolbars];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)continueButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	id nextViewController = nil;
	
	switch ([self displayMode]) {
		case BTIActionListDisplayModeEmail:
		{
			nextViewController = [[ParentEmailerViewController alloc] init];
			[nextViewController setPerson:[self person]];
			[nextViewController setActionSelectionSet:[self selectionSet]];
		}
			break;
		case BTIActionListDisplayModeMessage:
		{
			nextViewController = [[ParentMessagerViewController alloc] init];
			[nextViewController setPerson:[self person]];
			[nextViewController setActionSelectionSet:[self selectionSet]];
		}
			break;
		default:
			break;
	}
	
	if (nextViewController != nil)
	{
		[[self navigationController] pushViewController:nextViewController animated:YES];
	}
	
	[nextViewController release], nextViewController = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)printButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
	[printController setDelegate:self];
	
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
	[printInfo setOutputType:UIPrintInfoOutputGeneral];
	[printInfo setJobName:[[self person] fullName]];
	
	[printController setPrintInfo:printInfo];
	
	DataController *dataController = [DataController sharedDataController];
	NSString *summary = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierSummary];
	NSString *person = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
//	NSString *other = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierOther];
	
	NSManagedObjectContext *context = [[self person] managedObjectContext];
	
	// Prepare print contents
	
	NSSortDescriptor *dateDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"defaultSortDate" ascending:[[NSUserDefaults standardUserDefaults] isActionsSortAscendingBTI]] autorelease];
	
	NSArray *sortedActions = [[self selectionSet] sortedArrayUsingDescriptors:[NSArray arrayWithObject:dateDescriptor]];
	
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
	
//	if ( ([[self person] other] != nil) && ([[[self person] other] length] > 0) )
//	{
//		[fullEmailString appendString:[NSString stringWithFormat:@"%@: %@\n", other, [[self person] other]]];
//	}
	
	for (Action *action in sortedActions)
	{
		[fullEmailString appendString:[action summaryStringForPrinting]];
	}
	
	NSLog(@"fullEmailString is: %@", fullEmailString);
	
    UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc] initWithText:fullEmailString];
	[textFormatter setStartPage:0];
	[textFormatter setContentInsets:UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0)]; // 1 inch margins
	[textFormatter setMaximumContentWidth:6 * 72.0];
	
	[printController setPrintFormatter:textFormatter];
	
	[textFormatter release], textFormatter = nil;
	
	[printController setShowsPageRange:YES];
	
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            NSLog(@"Printing could not complete because of error: %@", error);
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Print Error"
															message:@"Printing was not able to complete."
														   delegate:nil
												  cancelButtonTitle:@"Ok"
												  otherButtonTitles:nil];
			[alert show];
			[alert release], alert = nil;
        }
		else
		{
			[self setDisplayMode:BTIActionListDisplayModeNormal];
			
			[[self mainTableView] reloadData];
			[self refreshToolbars];
		}
    };
	
	if ([dataController isIPadVersion])
	{
		[printController presentFromBarButtonItem:button animated:YES completionHandler:completionHandler];
	}
	else
	{
		[printController presentAnimated:YES completionHandler:completionHandler];
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)sortButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	[userDefaults setActionsSortAscendingBTI:![userDefaults isActionsSortAscendingBTI]];
	
	NSIndexPath *indexPath = [[self mainTableView] indexPathForSelectedRow];
	Action *selectedAction = nil;
	
	if (indexPath != nil)
	{
		selectedAction = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	}
	
	[[self fetchedResultsController] setDelegate:nil];
	[self setFetchedResultsController:nil];
	
	[[self mainTableView] reloadData];
	
	if (selectedAction != nil)
	{
		indexPath = [[self fetchedResultsController] indexPathForObject:selectedAction];
		
		if (indexPath != nil)
		{
			[[self mainTableView] selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
		}
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (void)refreshToolbars
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	DataController *dataController = [DataController sharedDataController];
	
	NSMutableArray *items = [[NSMutableArray alloc] init];
	
	switch ([self displayMode]) {
		case BTIActionListDisplayModeNormal:
		{
			// Navigation Bar
			if ([dataController isLiteVersion])
			{
				if ([[[self person] actions] count] >= kLiteVersionMaxNumberOfActions)
				{
					[[self navigationItem] setRightBarButtonItem:[self upgradeButton] animated:YES];
				}
				else
				{
					[[self navigationItem] setRightBarButtonItem:[self addButton] animated:YES];
				}
			}
			else
			{
				[[self navigationItem] setRightBarButtonItem:[self addButton] animated:NO];
			}
			
			[[self navigationItem] setLeftBarButtonItem:nil];
			
			[self setTitle:[[self person] fullName]];
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[self title] forKey:@"title"];
			[[NSNotificationCenter defaultCenter] postNotificationName:kSplitMasterTitleDidChangeNotification object:nil userInfo:userInfo];
			
			// Toolbar
			
			[items addObject:[self jumpButton]];
			[items addObject:[self flexItem]];
			[items addObject:[self editButtonItem]];
			[items addObject:[self flexItem]];
			[items addObject:[self sortButton]];
			[items addObject:[self flexItem]];
			[items addObject:[self actionButton]];
		}
			break;
		case BTIActionListDisplayModeEdit:
		{
			// Navigation Bar
			if ([dataController isLiteVersion])
			{
				if ([[[self person] actions] count] >= kLiteVersionMaxNumberOfActions)
				{
					[[self navigationItem] setRightBarButtonItem:[self upgradeButton] animated:YES];
				}
				else
				{
					[[self navigationItem] setRightBarButtonItem:[self addButton] animated:YES];
				}
			}
			else
			{
				[[self navigationItem] setRightBarButtonItem:[self addButton] animated:NO];
			}
			
			[[self navigationItem] setLeftBarButtonItem:nil];
			
			[self setTitle:[[self person] fullName]];
			
			// Toolbar
			
			[items addObject:[self editButtonItem]];
			[items addObject:[self flexItem]];
			[items addObject:[self trashButton]];
		}
			break;
		case BTIActionListDisplayModeEmail:
		case BTIActionListDisplayModeMessage:
		{
			[[self navigationItem] setRightBarButtonItem:[self continueButton]];
			[[self navigationItem] setLeftBarButtonItem:[self cancelButton]];
			
			[self setTitle:[NSString stringWithFormat:@"Choose %@", [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierAction]]];
			
			[items addObject:[self selectAllButton]];
			[items addObject:[self flexItem]];
			[items addObject:[self selectNoneButton]];
			[items addObject:[self flexItem]];
			[items addObject:[self mostRecentButton]];
		}
			break;
		case BTIActionListDisplayModePrint:
		{
			[[self navigationItem] setRightBarButtonItem:[self printButton]];
			[[self navigationItem] setLeftBarButtonItem:[self cancelButton]];
			
			[self setTitle:[NSString stringWithFormat:@"Choose %@", [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierAction]]];
			
			[items addObject:[self selectAllButton]];
			[items addObject:[self flexItem]];
			[items addObject:[self selectNoneButton]];
			[items addObject:[self flexItem]];
			[items addObject:[self mostRecentButton]];
		}
			break;
		default:
			break;
	}
	
	[self refreshButtonStatus];
	
	[self setToolbarItems:items animated:YES];
	
	[items release], items = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)refreshButtonStatus
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if ([[self selectionSet] count] > 0)
	{
		[[self continueButton] setEnabled:YES];
		[[self printButton] setEnabled:YES];
	}
	else
	{
		[[self continueButton] setEnabled:NO];
		[[self printButton] setEnabled:NO];
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)reloadTableWithDeselect:(BOOL)shouldDeselect
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	UITableView *tableView = [self mainTableView];
	NSIndexPath *selectedIndexPath = nil;
	
	if (!shouldDeselect)
	{
		selectedIndexPath = [tableView indexPathForSelectedRow];
	}
	
	[tableView reloadData];

	if (!shouldDeselect)
	{
		if (selectedIndexPath != nil)
		{
			[tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
		}
	}
	
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

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	DataController *dataController = [DataController sharedDataController];
	GradingPeriod *gradingPeriod = [dataController activeGradingPeriod];
	
	UIView *viewToReturn = nil;
	
	NSInteger totalNumberOfAllActions = [[[self person] actions] count];
	
	NSSet *activeActions = [[self person] actionsInGradingPeriod:gradingPeriod];
	NSInteger totalCountOfActiveActions = [activeActions count];
	
	if (totalNumberOfAllActions == 0)
	{
		NSString *singular = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierAction];
		[[self centeredHeaderLabel] setText:[NSString stringWithFormat:@"Add %@ To Get Started", singular]];
		
		viewToReturn = [self centeredHeaderView];
	}
	else
	{
		DataController *dataController = [DataController sharedDataController];
		NSString *plural = [dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierAction];
		
		NSString *header = [NSString stringWithFormat:@"%@: %d", plural, totalCountOfActiveActions];
		
//		if (numberOfActions > [[[self fetchedResultsController] fetchedObjects] count])
//		{
//			header = [header stringByAppendingString:@" ** Filtered **"];
//		}
		
		[[self leftHeaderLabel] setText:header];
		[[self gradingPeriodLabel] setText:[gradingPeriod name]];
		
		if ([[NSUserDefaults standardUserDefaults] btiShouldShowColorPointValues])
		{
			if ([[self person] colorLabelPointTotal] == nil)
				[[self person] calculateColorLabelPointTotal];
			
			[[self rightHeaderLabel] setHidden:NO];
//			NSString *points = [NSNumberFormatter localizedStringFromNumber:[[self person] colorLabelPointTotal] numberStyle:NSNumberFormatterDecimalStyle];
			NSString *points = [NSNumberFormatter localizedStringFromNumber:[activeActions valueForKeyPath:@"@sum.colorLabelPointValue"] numberStyle:NSNumberFormatterDecimalStyle];
			[[self rightHeaderLabel] setText:[NSString stringWithFormat:@"Points: %@", points]];
		}
		else
		{
			[[self rightHeaderLabel] setHidden:YES];
		}
		
		viewToReturn = [self splitHeaderView];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return viewToReturn;
}

- (CGFloat)tableView:(UITableView *)tableView 
heightForHeaderInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [[self splitHeaderView] frame].size.height;
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
	
	DataController *dataController = [DataController sharedDataController];
	
	Action *action = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	PersonActionsCell *cell = (PersonActionsCell *)[tableView dequeueReusableCellWithIdentifier:[PersonActionsCell reuseIdentifier]];
	if (cell == nil)
	{
		[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PersonActionsCell class]) owner:self options:nil];
		cell = [self personActionsCell];
		[self setPersonActionsCell:nil];
	}
	
	ActionFieldInfo *actionInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierAction];
	ActionFieldInfo *descriptionInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierDescription];
	ActionFieldInfo *dateInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierDate];
//	ActionFieldInfo *colorInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierColorLabel];
	
	ActionValue *actionValue = [action actionValueForActionFieldInfo:actionInfo];
	ActionValue *descriptionValue = [action actionValueForActionFieldInfo:descriptionInfo];
	ActionValue *dateValue = [action actionValueForActionFieldInfo:dateInfo];
//	ActionValue *colorValue = [action actionValueForActionFieldInfo:colorInfo];

	[[cell actionLabel] setText:[actionValue labelText]];
	[[cell descriptionLabel] setText:[descriptionValue labelText]];
	[[cell dateLabel] setText:[dateValue labelText]];
	
//	[cell setColorForBackground:[[colorValue colorInfo] color]];
	
	switch ([self displayMode]) {
		case BTIActionListDisplayModeNormal:
		case BTIActionListDisplayModeEdit:
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			break;
		case BTIActionListDisplayModeEmail:
		case BTIActionListDisplayModePrint:
		{
			[cell setAccessoryType:([[self selectionSet] containsObject:action]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
		}
			break;
		default:
			break;
	}
	
	// Populate color views
	
	NSArray *colorViews = [NSArray arrayWithObjects:[cell colorView1], [cell colorView2], [cell colorView3], [cell colorView4], [cell colorView5], nil];
	
	[colorViews makeObjectsPerformSelector:@selector(setBackgroundColor:) withObject:[UIColor whiteColor]];
	
	NSArray *activeColors = [action activeColorInfos];
	
	[colorViews enumerateObjectsUsingBlock:^(UIView *colorView, NSUInteger index, BOOL *stop) {
		
		if (index < [activeColors count])
		{
			ColorInfo *colorInfo = [activeColors objectAtIndex:index];
			
			[colorView setBackgroundColor:[colorInfo color]];
		}
		
	}];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return cell;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		Action *action = [[self fetchedResultsController] objectAtIndexPath:indexPath];
		
		DataController *dataController = [DataController sharedDataController];
		
		[dataController deleteAction:action];
		
		[dataController saveCoreDataContext];
		
		[[self person] calculateColorLabelPointTotal];
		[[self person] calculateActionCountTotal];
		
//		[[self person] performSelector:@selector(calculateColorLabelPointTotal) withObject:nil afterDelay:0.2];
		
		[tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
		
		[self refreshToolbars];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert)
	{
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UITableView Delegate Methods

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSIndexPath *indexPathToReturn = indexPath;
	
	if ([indexPath isEqual:[tableView indexPathForSelectedRow]])
	{
		indexPathToReturn = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return indexPathToReturn;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	Action *action = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	switch ([self displayMode]) {
		case BTIActionListDisplayModeNormal:
		case BTIActionListDisplayModeEdit:
		{
			if ([[DataController sharedDataController] isIPadVersion])
			{
				[[NSNotificationCenter defaultCenter] postNotificationName:kShouldHideActionDetailViewNotification object:nil];
				
				NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[self person], kNotificationPersonObjectKey, action, kNotificationActionObjectKey, nil];
				
				[[NSNotificationCenter defaultCenter] postNotificationName:kShouldShowActionDetailViewNotification object:dictionary];
				
				[(TeachersAssistantAppDelegate_iPad *)[[UIApplication sharedApplication] delegate] dismissMasterPopover];
				
				[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
			}
			else
			{
				[tableView deselectRowAtIndexPath:indexPath animated:YES];
				
				ActionDetailViewController *nextViewController = [[ActionDetailViewController alloc] init];
				[nextViewController setPerson:[self person]];
				[nextViewController setAction:action];
				
				[[self navigationController] pushViewController:nextViewController animated:YES];
				
				[nextViewController release], nextViewController = nil;
			}
		}
			break;
		case BTIActionListDisplayModeEmail:
		case BTIActionListDisplayModePrint:
		case BTIActionListDisplayModeMessage:
		{
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			
			PersonActionsCell *cell = (PersonActionsCell *)[tableView cellForRowAtIndexPath:indexPath];
			
			if ([[self selectionSet] containsObject:action])
			{
				[[self selectionSet] removeObject:action];
				[cell setAccessoryType:UITableViewCellAccessoryNone];
			}
			else
			{
				[[self selectionSet] addObject:action];
				[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
			}
			
			[self refreshButtonStatus];
		}
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
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
	
	// Reload to update the footer
	if ([[DataController sharedDataController] isIPadVersion])
	{
		[self performBlock:^{

			[self reloadTableWithDeselect:NO];
			
		}
				afterDelay:0.3];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	switch (type)
	{
		case NSFetchedResultsChangeInsert:
			NSLog(@"insert");
			[[self mainTableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			NSLog(@"delete");
			[[self mainTableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate:
			NSLog(@"update");
			//			[self configureCell:(CategoryCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
		case NSFetchedResultsChangeMove:
			NSLog(@"move");
			[[self mainTableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[[self mainTableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	
	
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

#pragma mark -
#pragma mark UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark UINavigationController Delegate Methods

- (void)navigationController:(UINavigationController *)navigationController
	  willShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	//	[navigationController setDelegate:nil];
	[navigationController setDelegate:(TeachersAssistantAppDelegate *)[[UIApplication sharedApplication] delegate]];
	
	NSArray *viewControllers = [navigationController viewControllers];
	NSLog(@"viewControllers: %@", [viewControllers description]);
	
	if (![viewControllers containsObject:self])
	{
		NSLog(@"Going backwards!");
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        
        [notificationCenter postNotificationName:kShouldHideActionDetailViewNotification object:nil];
		[notificationCenter postNotificationName:kShouldHideStudentDetailViewNotification object:nil];
		
	}
	else
	{
		NSLog(@"Going forwards!");
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)navigationController:(UINavigationController *)navigationController
	   didShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if ([[DataController sharedDataController] isIPadVersion])
	{
		[(TeachersAssistantAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController:navigationController
																				   didShowViewController:viewController
																								animated:animated];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
