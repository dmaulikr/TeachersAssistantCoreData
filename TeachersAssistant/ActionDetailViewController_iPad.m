//
//  ActionDetailViewController_iPad.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/22/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ActionDetailViewController_iPad.h"

// Models and other global

// Sub-controllers
#import "ActionPickerValuesViewController.h"
#import "DateDetailViewController.h"
#import "LongTextDetailViewController.h"
#import "AssignActionsClassPickerViewController.h"
#import "UpgradeViewController.h"
#import "ColorInfoPickerViewController.h"
#import "ActionImageViewController.h"

// Views
#import "UICustomSwitch.h"
#import "ActionDetailPickerCell.h"
#import "ActionDetailBooleanCell.h"
#import "ActionDetailLongTextCell.h"
#import "ActionDetailColorCell.h"
#import "ActionDetailImageCell.h"

// Private Constants


@interface ActionDetailViewController_iPad ()

// Private Properties
@property (nonatomic, retain) UITextView *activeTextView;
@property (nonatomic, retain) NSIndexPath *activeIndexPath;
@property (nonatomic, retain) UIPopoverController *detailPopover;
@property (nonatomic, retain) NSMutableDictionary *rowHeights;
@property (nonatomic, retain) UINib *actionDetailPickerCellNib;
@property (nonatomic, retain) UINib *actionDetailBooleanCellNib;
@property (nonatomic, retain) UINib *actionDetailLongTextCellNib;
@property (nonatomic, retain) UINib *actionDetailColorCellNib;
@property (nonatomic, retain) UINib *actionDetailImageCellNib;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, retain) UIImageView *headerBackgroundView;
@property (nonatomic, retain) UIImageView *footerBackgroundView;

// Notification Handlers
- (void)popoverShouldFinish:(NSNotification *)notification;
- (void)actionWasDeleted:(NSNotification *)notification;


// UI Response Methods
- (void)upgradeButtonPressed:(id)sender;


// Misc Methods

@end

@implementation ActionDetailViewController_iPad

#pragma mark - Synthesized Properties

// Public
@synthesize actionDetailPickerCell = ivActionDetailPickerCell;
@synthesize actionDetailBooleanCell = ivActionDetailBooleanCell;
@synthesize actionDetailLongTextCell = ivActionDetailLongTextCell;
@synthesize actionDetailColorCell = ivActionDetailColorCell;
@synthesize actionDetailImageCell = ivActionDetailImageCell;

// Private
@synthesize activeTextView = ivActiveTextView;
@synthesize activeIndexPath = ivActiveIndexPath;
@synthesize detailPopover = ivDetailPopover;
@synthesize rowHeights = ivRowHeights;
@synthesize actionDetailPickerCellNib = ivActionDetailPickerCellNib;
@synthesize actionDetailBooleanCellNib = ivActionDetailBooleanCellNib;
@synthesize actionDetailLongTextCellNib = ivActionDetailLongTextCellNib;
@synthesize actionDetailColorCellNib = ivActionDetailColorCellNib;
@synthesize actionDetailImageCellNib = ivActionDetailImageCellNib;
@synthesize keyboardHeight = ivKeyboardHeight;
@synthesize headerBackgroundView = ivHeaderBackgroundView;
@synthesize footerBackgroundView = ivFooterBackgroundView;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	[[self activeTextView] setDelegate:nil];
	
	// Public Properties
	[self setActionDetailPickerCell:nil];
	[self setActionDetailBooleanCell:nil];
	[self setActionDetailLongTextCell:nil];
	[self setActionDetailColorCell:nil];
	[self setActionDetailImageCell:nil];
	
	// Private Properties
	[self setActiveTextView:nil];
	[self setActiveIndexPath:nil];
	[self setRowHeights:nil];
	[self setActionDetailPickerCellNib:nil];
	[self setActionDetailBooleanCellNib:nil];
	[self setActionDetailLongTextCellNib:nil];
	[self setActionDetailColorCellNib:nil];
	[self setActionDetailImageCellNib:nil];
	[self setHeaderBackgroundView:nil];
	[self setFooterBackgroundView:nil];
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	[self setActionDetailPickerCellNib:nil];
	[self setActionDetailBooleanCellNib:nil];
	[self setActionDetailLongTextCellNib:nil];
	[self setActionDetailColorCellNib:nil];
	[self setActionDetailImageCellNib:nil];
	[self setFooterBackgroundView:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)didReceiveMemoryWarning
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super didReceiveMemoryWarning];
	
	[[self headerBackgroundView] removeFromSuperview];
	[[self footerBackgroundView] removeFromSuperview];
	
	[self setHeaderBackgroundView:nil];
	[self setFooterBackgroundView:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

- (NSMutableDictionary *)rowHeights
{
	if (ivRowHeights == nil)
	{
		ivRowHeights = [[NSMutableDictionary alloc] init];
	}
	return ivRowHeights;
}

- (UINib *)actionDetailPickerCellNib
{
	if (ivActionDetailPickerCellNib == nil)
	{
		ivActionDetailPickerCellNib = [[UINib nibWithNibName:NSStringFromClass([ActionDetailPickerCell class]) bundle:nil] retain];
	}
	return ivActionDetailPickerCellNib;
}

- (UINib *)actionDetailBooleanCellNib
{
	if (ivActionDetailBooleanCellNib == nil)
	{
		ivActionDetailBooleanCellNib = [[UINib nibWithNibName:NSStringFromClass([ActionDetailBooleanCell class]) bundle:nil] retain];
	}
	return ivActionDetailBooleanCellNib;
}

- (UINib *)actionDetailLongTextCellNib
{
	if (ivActionDetailLongTextCellNib == nil)
	{
		ivActionDetailLongTextCellNib = [[UINib nibWithNibName:NSStringFromClass([ActionDetailLongTextCell class]) bundle:nil] retain];
	}
	return ivActionDetailLongTextCellNib;
}

- (UINib *)actionDetailColorCellNib
{
	if (ivActionDetailColorCellNib == nil)
	{
		ivActionDetailColorCellNib = [[UINib nibWithNibName:NSStringFromClass([ActionDetailColorCell class]) bundle:nil] retain];
	}
	return ivActionDetailColorCellNib;
}

- (UINib *)actionDetailImageCellNib
{
	if (ivActionDetailImageCellNib == nil)
	{
		ivActionDetailImageCellNib = [[UINib nibWithNibName:NSStringFromClass([ActionDetailImageCell class]) bundle:nil] retain];
	}
	return ivActionDetailImageCellNib;
}

#pragma mark - Initialization and UI Creation Methods



#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Deliberately not calling super
	
	DataController *dataController = [DataController sharedDataController];
	
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																				  target:self
																				  action:@selector(cancelButtonPressed:)];
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	[cancelButton release], cancelButton = nil;
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																				target:self
																				action:@selector(saveButtonPressed:)];
	
	UIBarButtonItem *personsButton = [[UIBarButtonItem alloc] initWithTitle:[dataController pluralNameForTermInfoIndentifier:kTermInfoIdentifierPerson]
																	  style:UIBarButtonItemStyleBordered
																	 target:self
																	 action:@selector(personsButtonPressed:)];
	
	if ([dataController isLiteVersion])
	{
		UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 228.0, 44.0)];
		UINavigationItem *navItem = [[UINavigationItem alloc] init];
		
		
		
		UIBarButtonItem *upgradeButton = [[UIBarButtonItem alloc] initWithTitle:@"Upgrade to Pro"
																		  style:UIBarButtonItemStyleBordered
																		 target:self
																		 action:@selector(upgradeButtonPressed:)];
		
		[navItem setLeftBarButtonItem:upgradeButton];
		
		if ([self person] != nil)
		{
			[navItem setRightBarButtonItem:saveButton];
		}
		else
		{
			[navItem setRightBarButtonItem:personsButton];
		}
		
		[navBar setItems:[NSArray arrayWithObjects:navItem, nil]];
		
		UIBarButtonItem *special = [[UIBarButtonItem alloc] initWithCustomView:navBar];
		
		[[self navigationItem] setRightBarButtonItem:special];
		
		[navBar release], navBar = nil;
		[navItem release], navItem = nil;
		[upgradeButton release], upgradeButton = nil;
		[special release], special = nil;
	}
	else
	{
		if ([self person] != nil)
		{
			[[self navigationItem] setRightBarButtonItem:saveButton];
		}
		else
		{
			[[self navigationItem] setRightBarButtonItem:personsButton];
		}
	}
	
	[personsButton release], personsButton = nil;
	[saveButton release], saveButton = nil;
	
	// Calculate row heights for each kind of cell
	
	// Picker and Date use the same cell
	[[self actionDetailPickerCellNib] instantiateWithOwner:self options:nil];
	CGFloat height = [[self actionDetailPickerCell] frame].size.height;
	[self setActionDetailPickerCell:nil];
	
	[[self rowHeights] setObject:[NSNumber numberWithFloat:height] forKey:[NSNumber numberWithInt:BTIActionFieldValueTypePicker]];
	[[self rowHeights] setObject:[NSNumber numberWithFloat:height] forKey:[NSNumber numberWithInt:BTIActionFieldValueTypeDate]];
	
	
	// Boolean
	[[self actionDetailBooleanCellNib] instantiateWithOwner:self options:nil];
	height = [[self actionDetailBooleanCell] frame].size.height;
	[self setActionDetailBooleanCell:nil];
	
	[[self rowHeights] setObject:[NSNumber numberWithFloat:height] forKey:[NSNumber numberWithInt:BTIActionFieldValueTypeBoolean]];
	
	// Long Text
	[[self actionDetailLongTextCellNib] instantiateWithOwner:self options:nil];
	height = [[self actionDetailLongTextCell] frame].size.height;
	[self setActionDetailLongTextCell:nil];
	
	[[self rowHeights] setObject:[NSNumber numberWithFloat:height] forKey:[NSNumber numberWithInt:BTIActionFieldValueTypeLongText]];
	
	// Color Label
	[[self actionDetailColorCellNib] instantiateWithOwner:self options:nil];
	height = [[self actionDetailColorCell] frame].size.height;
	[self setActionDetailColorCell:nil];
	
	[[self rowHeights] setObject:[NSNumber numberWithFloat:height] forKey:[NSNumber numberWithInt:BTIActionFieldValueTypeColor]];
	
	// Image
	[[self actionDetailImageCellNib] instantiateWithOwner:self options:nil];
	height = [[self actionDetailImageCell] frame].size.height;
	[self setActionDetailImageCell:nil];
	
	[[self rowHeights] setObject:[NSNumber numberWithFloat:height] forKey:[NSNumber numberWithInt:BTIActionFieldValueTypeImage]];
	
	// TODO: Handle audio row
	// TODO: Handle video row
	[[self rowHeights] setObject:[NSNumber numberWithFloat:40.0] forKey:[NSNumber numberWithInt:BTIActionFieldValueTypeAudio]];
	[[self rowHeights] setObject:[NSNumber numberWithFloat:40.0] forKey:[NSNumber numberWithInt:BTIActionFieldValueTypeVideo]];
	
	UIImage *backgroundImage = [UIImage imageNamed:@"paper_background_320x768.png"];
	
	UIImageView *header = [[UIImageView alloc] initWithImage:backgroundImage];
	UIImageView *footer = [[UIImageView alloc] initWithImage:backgroundImage];
	
	[self setHeaderBackgroundView:header];
	[self setFooterBackgroundView:footer];
	
	[header setFrame:CGRectMake(0.0, -[backgroundImage size].height, [backgroundImage size].width, [backgroundImage size].height)];
	[[self mainTableView] addSubview:header];
	
	[header release], header = nil;
	[footer release], footer = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	// Remove existing notifications to avoid duplicates
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter removeObserver:self name:kPopoverShouldFinishNotification object:nil];
	[notificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[notificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[notificationCenter removeObserver:self name:UIKeyboardDidHideNotification object:nil];
	[notificationCenter removeObserver:self name:kDidDeleteActionNotification object:nil];
//	[notificationCenter removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];

	[notificationCenter addObserver:self selector:@selector(popoverShouldFinish:) name:kPopoverShouldFinishNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(actionWasDeleted:) name:kDidDeleteActionNotification object:nil];
//	[notificationCenter addObserver:self selector:@selector(popoverShouldFinish:) name:UIApplicationDidEnterBackgroundNotification object:nil];
	
	CGSize size = [[[self footerBackgroundView] image] size];
	[[self footerBackgroundView] setFrame:CGRectMake(0.0, [[self mainTableView] contentSize].height, size.width, size.height)];
	[[self mainTableView] addSubview:[self footerBackgroundView]];
	
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

	[[self activeTextView] resignFirstResponder];
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter removeObserver:self name:kPopoverShouldFinishNotification object:nil];
	[notificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[notificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[notificationCenter removeObserver:self name:UIKeyboardDidHideNotification object:nil];
	[notificationCenter removeObserver:self name:kDidDeleteActionNotification object:nil];
	
	[self popoverShouldFinish:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidDisappear:animated];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Notification Handlers

- (void)popoverShouldFinish:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[self detailPopover] dismissPopoverAnimated:YES];
	[self setDetailPopover:nil];

	[[self mainTableView] reloadData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)keyboardWillShow:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSDictionary *userInfo = (NSDictionary *)[notification userInfo];
	
	CGRect keyboardFrame = [(NSValue *)[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	NSLog(@"keyboardFrame is: %@", NSStringFromCGRect(keyboardFrame));
	
	CGRect convertedKeyboardFrame = [[self view] convertRect:keyboardFrame fromView:nil];
	NSLog(@"convertedKeyboardFrame is: %@", NSStringFromCGRect(convertedKeyboardFrame));
	
	[self setKeyboardHeight:convertedKeyboardFrame.size.height];
	
	CGSize contentSize = [[self mainTableView] contentSize];
	contentSize.height = contentSize.height + [self keyboardHeight];
	[[self mainTableView] setContentSize:contentSize];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSDictionary *userInfo = (NSDictionary *)[notification userInfo];
	
	CGRect keyboardFrame = [(NSValue *)[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
	NSLog(@"keyboardFrame is: %@", NSStringFromCGRect(keyboardFrame));
	
	CGRect convertedKeyboardFrame = [[self view] convertRect:keyboardFrame fromView:nil];
	NSLog(@"convertedKeyboardFrame is: %@", NSStringFromCGRect(convertedKeyboardFrame));
	
	CGSize contentSize = [[self mainTableView] contentSize];
	contentSize.height = contentSize.height - convertedKeyboardFrame.size.height;
	[[self mainTableView] setContentSize:contentSize];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)keyboardDidHide:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);


	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)actionWasDeleted:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	Action *action = (Action *)[notification object];
	
	if ([action isEqual:[self action]])
	{
		[self cancelButtonPressed:nil];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	UITextView *textView = [self activeTextView];
	
	if (textView != nil)
	{
		NSIndexPath *indexPath = [[self mainTableView] mdIndexPathForRowContainingView:textView];
		ActionFieldInfo *actionFieldInfo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
		ActionFieldInfo *scratchActionFieldInfo = (ActionFieldInfo *)[[self scratchObjectContext] existingObjectWithID:[actionFieldInfo objectID] error:nil];
		ActionValue *scratchActionValue = [[self scratchAction] actionValueForActionFieldInfo:scratchActionFieldInfo];
		
		[scratchActionValue setLongText:[textView text]];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UI Response Methods

- (void)saveButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if ([self detailPopover] != nil)
	{
		[[self detailPopover] setDelegate:nil];
		[[self detailPopover] dismissPopoverAnimated:NO];
	}
	
	[[self activeTextView] resignFirstResponder];
	
	[super saveButtonPressed:button];

	[[NSNotificationCenter defaultCenter] postNotificationName:kInfractionDetailViewDidFinishNotification object:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (IBAction)detailButtonPressed:(UIButton *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if ([self detailPopover] != nil)
	{
		[[self detailPopover] setDelegate:nil];
		[[self detailPopover] dismissPopoverAnimated:NO];
	}
	
	NSIndexPath *indexPath = [[self mainTableView] mdIndexPathForRowContainingView:button];
	ActionFieldInfo *actionFieldInfo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	ActionFieldInfo *scratchActionFieldInfo = (ActionFieldInfo *)[[self scratchObjectContext] existingObjectWithID:[actionFieldInfo objectID] error:nil];
	NSInteger fieldType = [[actionFieldInfo type] integerValue];
	ActionValue *scratchActionValue = [[self scratchAction] actionValueForActionFieldInfo:scratchActionFieldInfo];
	
	UIViewController *nextViewController = nil;
	
	switch (fieldType) {
		case BTIActionFieldValueTypeDate:
		{
			nextViewController = [[[DateDetailViewController alloc] init] autorelease];
			[(DateDetailViewController *)nextViewController setScratchActionValue:scratchActionValue];
			[nextViewController setContentSizeForViewInPopover:CGSizeMake(320.0, 216.0)];
		}
			break;
		case BTIActionFieldValueTypePicker:
		{
			nextViewController = [[[ActionPickerValuesViewController alloc] init] autorelease];
			[(ActionPickerValuesViewController *)nextViewController setScratchObjectContext:[self scratchObjectContext]];
			[(ActionPickerValuesViewController *)nextViewController setActionFieldInfo:actionFieldInfo];
			[(ActionPickerValuesViewController *)nextViewController setScratchActionValue:scratchActionValue];
		}
			break;
		case BTIActionFieldValueTypeLongText:
		{
		}
			break;
		case BTIActionFieldValueTypeBoolean:
		{
		}
			break;
		case BTIActionFieldValueTypeImage:
		{
			[self setScratchActiveImageActionValue:scratchActionValue];
			
			[[self imagePickerTitles] removeAllObjects];
			
			UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
															   delegate:self
													  cancelButtonTitle:nil
												 destructiveButtonTitle:nil
													  otherButtonTitles:nil];
			
			[sheet addButtonWithTitle:kImagePickerTitleChoose];
			[[self imagePickerTitles] addObject:kImagePickerTitleChoose];
			
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
			{
				[sheet addButtonWithTitle:kImagePickerTitleTake];
				[[self imagePickerTitles] addObject:kImagePickerTitleTake];
			}
			
			if ([scratchActionValue imageMediaInfo] != nil)
			{
				[sheet addButtonWithTitle:kImagePickerTitleDelete];
				[[self imagePickerTitles] addObject:kImagePickerTitleDelete];
			}
			
			[sheet setCancelButtonIndex:[sheet addButtonWithTitle:@"Cancel"]];
			
			[sheet showFromRect:[button bounds] inView:button animated:YES];
			
			[sheet release], sheet = nil;
			
			NSLog(@"<<< Leaving %s >>> EARLY - Action Sheet", __PRETTY_FUNCTION__);
			return;
		}
			break;
		case BTIActionFieldValueTypeAudio:
		{
		}
			break;
		case BTIActionFieldValueTypeVideo:
		{
		}
			break;
		case BTIActionFieldValueTypeColor:
		{
			nextViewController = [[[ColorInfoPickerViewController alloc] init] autorelease];
			[(ColorInfoPickerViewController *)nextViewController setScratchObjectContext:[self scratchObjectContext]];
			[(ColorInfoPickerViewController *)nextViewController setActionFieldInfo:actionFieldInfo];
			[(ColorInfoPickerViewController *)nextViewController setScratchActionValue:scratchActionValue];
		}
			break;
		default:
			break;
	}
	
	if (nextViewController != nil)
	{
//		[nextViewController setContentSizeForViewInPopover:CGSizeMake(320.0, 320.0)];
		
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:nextViewController];
		
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navController];
		[popover setDelegate:self];
		[self setDetailPopover:popover];
		
		[popover presentPopoverFromRect:[button bounds] inView:button permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
		
		[popover release], popover = nil;
		[navController release], navController = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)upgradeButtonPressed:(id)sender
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[self applicationWillResignActive:nil];

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

- (IBAction)switchValueChanged:(UICustomSwitch *)customSwitch
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSIndexPath *indexPath = [[self mainTableView] mdIndexPathForRowContainingView:customSwitch];
	
	ActionFieldInfo *actionFieldInfo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	ActionFieldInfo *scratchActionFieldInfo = (ActionFieldInfo *)[[self scratchObjectContext] existingObjectWithID:[actionFieldInfo objectID] error:nil];
	
	ActionValue *scratchActionValue = [[self scratchAction] actionValueForActionFieldInfo:scratchActionFieldInfo];
	
	[scratchActionValue setBoolean:[NSNumber numberWithBool:[customSwitch isOn]]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (IBAction)imageButtonPressed:(UIButton *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSIndexPath *indexPath = [[self mainTableView] mdIndexPathForRowContainingView:button];
	
	ActionFieldInfo *actionFieldInfo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	ActionFieldInfo *scratchActionFieldInfo = (ActionFieldInfo *)[[self scratchObjectContext] existingObjectWithID:[actionFieldInfo objectID] error:nil];
	
	ActionValue *scratchActionValue = [[self scratchAction] actionValueForActionFieldInfo:scratchActionFieldInfo];
	
	ActionImageViewController *nextViewController = [[ActionImageViewController alloc] init];
	[nextViewController setScratchObjectContext:[self scratchObjectContext]];
	[nextViewController setScratchActionValue:scratchActionValue];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:nextViewController];
	
	[self presentModalViewController:navController animated:YES];
	
	[navController release], navController = nil;
	[nextViewController release], nextViewController = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)personsButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if ([self detailPopover] != nil)
	{
		[[self detailPopover] setDelegate:nil];
		[[self detailPopover] dismissPopoverAnimated:NO];
	}

	[[self activeTextView] resignFirstResponder];
	
	AssignActionsClassPickerViewController *nextViewController = [[AssignActionsClassPickerViewController alloc] init];
	[nextViewController setScratchObjectContext:[self scratchObjectContext]];
	[nextViewController setScratchAction:[self scratchAction]];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:nextViewController];
	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navController];
	[popover setDelegate:self];
	[self setDetailPopover:popover];
	
	[popover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
	[popover release], popover = nil;
	[navController release], navController = nil;
	[nextViewController release], nextViewController = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods


#pragma mark - UITableViewDataSource Methods

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	ActionFieldInfo *actionFieldInfo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	CGFloat height = [[[self rowHeights] objectForKey:[actionFieldInfo type]] floatValue];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return height;
}

// TODO: Handle audio cell
// TODO: Handle video cell
- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	DataController *dataController = [DataController sharedDataController];
	ActionFieldInfo *actionFieldInfo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	ActionFieldInfo *scratchActionFieldInfo = (ActionFieldInfo *)[[self scratchObjectContext] existingObjectWithID:[actionFieldInfo objectID] error:nil];
	NSInteger fieldType = [[scratchActionFieldInfo type] integerValue];
	TermInfo *termInfo = [actionFieldInfo termInfo];
	ActionValue *scratchActionValue = [[self scratchAction] actionValueForActionFieldInfo:scratchActionFieldInfo];
	
	NSString *singularName = [dataController singularNameForTermInfo:termInfo];
	NSString *pluralName = [dataController pluralNameForTermInfo:termInfo];
	
	switch (fieldType) {
		case BTIActionFieldValueTypeDate:
		{
			ActionDetailPickerCell *pickerCell = (ActionDetailPickerCell *)[tableView dequeueReusableCellWithIdentifier:[ActionDetailPickerCell reuseIdentifier]];
			if (pickerCell == nil)
			{
				[[self actionDetailPickerCellNib] instantiateWithOwner:self options:nil];
				pickerCell = [self actionDetailPickerCell];
				[self setActionDetailPickerCell:nil];
			}
			
			[[pickerCell titleLabel] setText:singularName];
			[[pickerCell contentLabel] setText:[scratchActionValue labelText]];
			
			cell = pickerCell;
		}
			break;
		case BTIActionFieldValueTypePicker:
		{
			ActionDetailPickerCell *pickerCell = (ActionDetailPickerCell *)[tableView dequeueReusableCellWithIdentifier:[ActionDetailPickerCell reuseIdentifier]];
			if (pickerCell == nil)
			{
				[[self actionDetailPickerCellNib] instantiateWithOwner:self options:nil];
				pickerCell = [self actionDetailPickerCell];
				[self setActionDetailPickerCell:nil];
			}
			
			NSInteger numberOfPickerValues = [[scratchActionValue pickerValues] count];
			if (numberOfPickerValues > 1)
			{
				[[pickerCell titleLabel] setText:pluralName];
			}
			else
			{			
				[[pickerCell titleLabel] setText:singularName];
			}
			
			[[pickerCell contentLabel] setText:[scratchActionValue labelText]];
			
			cell = pickerCell;
		}
			break;
		case BTIActionFieldValueTypeLongText:
		{
			ActionDetailLongTextCell *longTextCell = (ActionDetailLongTextCell *)[tableView dequeueReusableCellWithIdentifier:[ActionDetailLongTextCell reuseIdentifier]];
			if (longTextCell == nil)
			{
				[[self actionDetailLongTextCellNib] instantiateWithOwner:self options:nil];
				longTextCell = [self actionDetailLongTextCell];
				[self setActionDetailLongTextCell:nil];
			}
			
			[[longTextCell titleLabel] setText:singularName];
			[[longTextCell contextTextView] setText:[scratchActionValue labelText]];
			
			cell = longTextCell;
		}
			break;
		case BTIActionFieldValueTypeBoolean:
		{
			ActionDetailBooleanCell *booleanCell = (ActionDetailBooleanCell *)[tableView dequeueReusableCellWithIdentifier:[ActionDetailBooleanCell reuseIdentifier]];
			if (booleanCell == nil)
			{
				[[self actionDetailBooleanCellNib] instantiateWithOwner:self options:nil];
				booleanCell = [self actionDetailBooleanCell];
				[self setActionDetailBooleanCell:nil];
				
				[[[booleanCell customSwitch] leftLabel] setText:@"Yes"];
				[[[booleanCell customSwitch] rightLabel] setText:@"No"];
			}
			
			[[booleanCell titleLabel] setText:singularName];
			[[booleanCell customSwitch] setOn:[[scratchActionValue boolean] boolValue] animated:NO];
			
			cell = booleanCell;
		}
			break;
		case BTIActionFieldValueTypeImage:
		{
			ActionDetailImageCell *imageCell = (ActionDetailImageCell *)[tableView dequeueReusableCellWithIdentifier:[ActionDetailImageCell reuseIdentifier]];
			if (imageCell == nil)
			{
				[[self actionDetailImageCellNib] instantiateWithOwner:self options:nil];
				imageCell = [self actionDetailImageCell];
				[self setActionDetailImageCell:nil];
			}
			
			UIImage *image = [[scratchActionValue thumbnailImageMediaInfo] image];
			
			[[imageCell titleLabel] setText:singularName];
			
			if (image != nil)
			{
				[[imageCell contentImageView] setImage:image];
				[[imageCell imageButton] setHidden:NO];
			}
			else
			{
				[[imageCell contentImageView] setImage:nil];
				[[imageCell imageButton] setHidden:YES];
			}
			
			cell = imageCell;
		}
			break;
		case BTIActionFieldValueTypeAudio:
		{
			[[cell textLabel] setText:singularName];
			[[cell detailTextLabel] setText:[scratchActionValue labelText]];
		}
			break;
		case BTIActionFieldValueTypeVideo:
		{
			[[cell textLabel] setText:singularName];
			[[cell detailTextLabel] setText:[scratchActionValue labelText]];
		}
			break;
		case BTIActionFieldValueTypeColor:
		{
			ColorInfo *colorInfo = [scratchActionValue colorInfo];
			
			ActionDetailColorCell *colorCell = (ActionDetailColorCell *)[tableView dequeueReusableCellWithIdentifier:[ActionDetailColorCell reuseIdentifier]];
			if (colorCell == nil)
			{
				[[self actionDetailColorCellNib] instantiateWithOwner:self options:nil];
				colorCell = [self actionDetailColorCell];
				[self setActionDetailColorCell:nil];
			}
			
			[[colorCell titleLabel] setText:singularName];
			[[colorCell contentLabel] setText:[scratchActionValue labelText]];
			
			if (colorInfo == nil)
			{
				[[colorCell colorView] setHidden:YES];
				
				[[colorCell pointLabel] setText:nil];
			}
			else
			{
				[[colorCell colorView] setHidden:NO];
				[[colorCell colorView] setBackgroundColor:[colorInfo color]];
				
				NSString *points = [NSNumberFormatter localizedStringFromNumber:[colorInfo pointValue] numberStyle:NSNumberFormatterDecimalStyle];
				[[colorCell pointLabel] setText:([[NSUserDefaults standardUserDefaults] btiShouldShowColorPointValues]) ? points : nil];
			}
			
			cell = colorCell;
		}
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return cell;
}

#pragma mark - UITableViewDelegate Methods

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	ActionDetailCell *cell = (ActionDetailCell *)[tableView cellForRowAtIndexPath:indexPath];
	
	NSIndexPath *pathToReturn = nil;
	
	if ([cell detailButton] != nil)
	{
		pathToReturn = indexPath;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return pathToReturn;
}

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	ActionDetailCell *cell = (ActionDetailCell *)[tableView cellForRowAtIndexPath:indexPath];

	if ([cell detailButton] != nil)
	{
		[self detailButtonPressed:[cell detailButton]];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UITextViewDelegate Methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSIndexPath *indexPath = [[self mainTableView] mdIndexPathForRowContainingView:textView];
	
	[self setActiveTextView:textView];
	[self setActiveIndexPath:indexPath];	
	
	UITableViewCell	*cell = [[self mainTableView] cellForRowAtIndexPath:indexPath];
	CGRect cellFrame = [cell frame];
	NSLog(@"cellFrame is: %@", NSStringFromCGRect(cellFrame));
	CGRect adjustedFrame = [[self mainTableView] convertRect:cellFrame toView:[self view]];
	NSLog(@"adjustedFrame is: %@", NSStringFromCGRect(adjustedFrame));
	CGPoint adjustedFrameOrigin = adjustedFrame.origin;
	
	CGFloat viewHeight = [[self view] frame].size.height;
	NSLog(@"viewHeight is: %f", viewHeight);
	
	CGFloat doNotScrollMaximumY = viewHeight - [self keyboardHeight] - cellFrame.size.height;
	NSLog(@"doNotScrollMaximumY is: %f", doNotScrollMaximumY);
	
	if ( (adjustedFrameOrigin.y >= 0) && (adjustedFrameOrigin.y <= doNotScrollMaximumY) )
	{
		// Do Nothing, view is visible
	}
	else
	{
		if (adjustedFrameOrigin.y < 0)
		{
			[[self mainTableView] setContentOffset:cellFrame.origin animated:YES];
		}
		else
		{
			CGFloat delta = adjustedFrameOrigin.y - doNotScrollMaximumY;
			
			CGPoint contentOffset = [[self mainTableView] contentOffset];
			contentOffset.y = contentOffset.y + delta;
			[[self mainTableView] setContentOffset:contentOffset animated:YES];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSIndexPath *indexPath = [[self mainTableView] mdIndexPathForRowContainingView:textView];
	if (indexPath == nil)
	{
		indexPath = [self activeIndexPath];
	}
//	NSLog(@"indexPath is: %@", indexPath);
	ActionFieldInfo *actionFieldInfo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
//	NSLog(@"actionFieldInfo is: %@", actionFieldInfo);
	ActionFieldInfo *scratchActionFieldInfo = (ActionFieldInfo *)[[self scratchObjectContext] existingObjectWithID:[actionFieldInfo objectID] error:nil];
	ActionValue *scratchActionValue = [[self scratchAction] actionValueForActionFieldInfo:scratchActionFieldInfo];
	
	[scratchActionValue setLongText:[textView text]];
	
	[self setActiveIndexPath:nil];
	[self setActiveTextView:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (buttonIndex != [actionSheet cancelButtonIndex])
	{
		NSString *rowTitle = [[self imagePickerTitles] objectAtIndex:buttonIndex];
		
		if ([rowTitle isEqualToString:kImagePickerTitleDelete])
		{
			[super actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
		}
		else
		{			
			UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
			[self setImagePickerController:imagePicker];
			[imagePicker setMediaTypes:[NSArray arrayWithObject:(NSString *)kUTTypeImage]];
			[imagePicker setDelegate:self];
			
			NSLog(@"rowTitle is: %@", rowTitle);
			
			if ([rowTitle isEqualToString:kImagePickerTitleChoose])		// Image picker must be in a popover
			{
				[imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
				
				UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
				[self setDetailPopover:popover];
				[popover setDelegate:self];
				
				ActionFieldInfo *scratchActionFieldInfo = [[self scratchActiveImageActionValue] actionFieldInfo];
				ActionFieldInfo *actionFieldInfo = (ActionFieldInfo *)[[[DataController sharedDataController] managedObjectContext] existingObjectWithID:[scratchActionFieldInfo objectID] error:nil];
				NSIndexPath *indexPath = [[self fetchedResultsController] indexPathForObject:actionFieldInfo];
				ActionDetailImageCell *cell = (ActionDetailImageCell *)[[self mainTableView] cellForRowAtIndexPath:indexPath];
				
				[popover presentPopoverFromRect:[[cell detailButton] bounds] inView:[cell detailButton] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
				
				[popover release], popover = nil;

			}
			else if ([rowTitle isEqualToString:kImagePickerTitleTake])	// Can present full-screen camera
			{
				[imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
				
				[self presentModalViewController:imagePicker animated:YES];
			}
			
			[imagePicker release], imagePicker = nil;
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
//	UIImage *selectedImage = nil;
//	if ([info objectForKey:UIImagePickerControllerEditedImage] != nil)
//		selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
//	else
//		selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	
	[super imagePickerController:picker didFinishPickingMediaWithInfo:info];
	
	if ([self detailPopover] != nil)
	{
		[[self detailPopover] setDelegate:nil];
		[[self detailPopover] dismissPopoverAnimated:NO];
		
		[self setDetailPopover:nil];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super imagePickerControllerDidCancel:picker];
	
	if ([self detailPopover] != nil)
	{
		[[self detailPopover] setDelegate:nil];
		[[self detailPopover] dismissPopoverAnimated:NO];
		
		[self setDetailPopover:nil];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if ([self activeIndexPath] == nil)
	{
		NSLog(@"<<< Leaving %s >>> EARLY - No index path, don't care", __PRETTY_FUNCTION__);
		return;
	}

	NSArray *visibleIndexPaths = [[self mainTableView] indexPathsForVisibleRows];
	
	if (![visibleIndexPaths containsObject:[self activeIndexPath]])
	{
		NSLog(@"<<< Leaving %s >>> EARLY - Active index path not visible, assume already saved", __PRETTY_FUNCTION__);
		return;
	}
	
	ActionFieldInfo *actionFieldInfo = [[self fetchedResultsController] objectAtIndexPath:[self activeIndexPath]];
//	NSLog(@"actionFieldInfo is: %@", actionFieldInfo);
	ActionFieldInfo *scratchActionFieldInfo = (ActionFieldInfo *)[[self scratchObjectContext] existingObjectWithID:[actionFieldInfo objectID] error:nil];
	ActionValue *scratchActionValue = [[self scratchAction] actionValueForActionFieldInfo:scratchActionFieldInfo];
	
	NSLog(@"Capturing text: %@", [[self activeTextView] text]);
	[scratchActionValue setLongText:[[self activeTextView] text]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
