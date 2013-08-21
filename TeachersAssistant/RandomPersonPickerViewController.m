//
//  RandomPersonPickerViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 4/10/12.
//  Copyright 2012 BriTer Ideas LLC. All rights reserved.
//

#import "RandomPersonPickerViewController.h"

// Models and other global
#import "BTITableSectionInfo.h"

// Sub-controllers

// Views

// Private Constants

@interface RandomPersonPickerViewController ()

// Private Properties
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSMutableArray *contents;
@property (nonatomic, retain) UIActionSheet *activeActionSheet;
@property (nonatomic, retain) UIBarButtonItem *actionButton;

// Notification Handlers



// UI Response Methods
- (void)sortButtonPressed:(UIBarButtonItem *)button;
- (void)randomButtonPressed:(UIBarButtonItem *)button;
- (void)clearButtonPressed:(UIBarButtonItem *)button;
- (void)actionButtonPressed:(UIBarButtonItem *)button;


// Misc Methods
- (void)populateRandomizerInfos;
- (void)randomizeContents;
- (void)groupContents;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (NSString *)listExport;
- (void)emailListExport;
- (void)printListExport;

@end

@implementation RandomPersonPickerViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize groupSizeLabel = ivGroupSizeLabel;
@synthesize minusButton = ivMinusButton;
@synthesize plusButton = ivPlusButton;
@synthesize classPeriod = ivClassPeriod;
@synthesize modeSegmentedControl = ivModeSegmentedControl;

// Private
@synthesize fetchedResultsController = ivFetchedResultsController;
@synthesize contents = ivContents;
@synthesize activeActionSheet = ivActiveActionSheet;
@synthesize actionButton = ivActionButton;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
    [self setMainTableView:nil];
    [self setGroupSizeLabel:nil];
    [self setMinusButton:nil];
    [self setPlusButton:nil];
	[self setClassPeriod:nil];
	
	// Private Properties
	[self setFetchedResultsController:nil];
	[self setContents:nil];
	[self setActiveActionSheet:nil];
	[self setActionButton:nil];
	
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
    [self setGroupSizeLabel:nil];
    [self setMinusButton:nil];
    [self setPlusButton:nil];
	[self setActionButton:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

- (NSFetchedResultsController *)fetchedResultsController
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivFetchedResultsController == nil)
	{
		DataController *dataController = [DataController sharedDataController];
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		NSManagedObjectContext *context = [dataController managedObjectContext];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		[fetchRequest setEntity:[RandomizerInfo entityDescriptionInContextBTI:context]];
		
		switch ([[[self classPeriod] randomizerMode] intValue]) {
			case BTIRandomizerModeSorted:
			{
				NSString *firstNameKeyPath = [NSString stringWithFormat:@"%@.%@", kPERSON, kFIRST_NAME];
				NSString *firstLetterKeyPath = [NSString stringWithFormat:@"%@.%@", kPERSON, kFIRST_LETTER_OF_FIRST_NAME];
				NSString *lastNameKeyPath = [NSString stringWithFormat:@"%@.%@", kPERSON, kLAST_NAME];
				NSString *lastLetterKeyPath = [NSString stringWithFormat:@"%@.%@", kPERSON, kFIRST_LETTER_OF_LAST_NAME];
				
				NSSortDescriptor *firstLetterDescriptor = [[[NSSortDescriptor alloc] initWithKey:firstLetterKeyPath ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
				NSSortDescriptor *firstNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:firstNameKeyPath ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
				NSSortDescriptor *lastLetterDescriptor = [[[NSSortDescriptor alloc] initWithKey:lastLetterKeyPath ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
				NSSortDescriptor *lastNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:lastNameKeyPath ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
				
				switch ([userDefaults btiPersonSortMode]) {
					case BTIPersonSortModeFirstLast:
					{
						[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:firstLetterDescriptor, firstNameDescriptor, nil]];
					}
						break;
					case BTIPersonSortModeLastFirst:
					{
						[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:lastLetterDescriptor, lastNameDescriptor, nil]];
					}
						break;
					default:
						break;
				}
			}
				break;
			case BTIRandomizerModeRandom:
			{
				[fetchRequest setSortDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
			}
				break;
			default:
				break;
		}
		
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"classPeriod == %@", [self classPeriod]]];
		
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

- (NSMutableArray *)contents
{
	if (ivContents == nil)
	{
		ivContents = [[NSMutableArray alloc] init];
	}
	return ivContents;
}

#pragma mark - Initialization and UI Creation Methods


#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:[[DataController sharedDataController] singularNameForTermInfoIndentifier:kTermInfoIdentifierRandomizer]];
	
	UIBarButtonItem *sortButton = [[UIBarButtonItem alloc] initWithTitle:@"Sort"
																   style:UIBarButtonItemStyleBordered
																  target:self
																  action:@selector(sortButtonPressed:)];
	
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	
	UIBarButtonItem *randomButton = [[UIBarButtonItem alloc] initWithTitle:@"Random"
																	 style:UIBarButtonItemStyleBordered
																	target:self
																	action:@selector(randomButtonPressed:)];
	
	UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																				  target:self
																				  action:@selector(actionButtonPressed:)];
	[actionButton setStyle:UIBarButtonItemStyleBordered];
	[self setActionButton:actionButton];
	
	UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear Marks"
																	style:UIBarButtonItemStyleBordered
																   target:self
																   action:@selector(clearButtonPressed:)];
	
	[self setToolbarItems:[NSArray arrayWithObjects:sortButton, flexItem, randomButton, actionButton, nil]];
	[[self navigationItem] setRightBarButtonItem:clearButton];
	
	[sortButton release], sortButton = nil;
	[flexItem release], flexItem = nil;
	[randomButton release], randomButton = nil;
	[actionButton release], actionButton = nil;
	[clearButton release], clearButton = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self navigationController] setToolbarHidden:NO animated:YES];
	
	ClassPeriod *classPeriod = [self classPeriod];
	
	if ([classPeriod groupMode] == nil)
		[classPeriod setGroupMode:[NSNumber numberWithInt:BTIRandomizerGroupModeGroupSize]];
	
	if ([classPeriod groupSize] == nil)
		[classPeriod setGroupSize:[NSNumber numberWithInt:1]];
	
	if ([classPeriod numberOfGroups] == nil)
		[classPeriod setNumberOfGroups:[NSNumber numberWithInt:1]];
	
	switch ([[classPeriod groupMode] integerValue]) {
		case BTIRandomizerGroupModeGroupSize:
		{
			[[self groupSizeLabel] setText:[NSString stringWithFormat:@"%d", [[[self classPeriod] groupSize] intValue]]];
			
			[[self modeSegmentedControl] setSelectedSegmentIndex:0];
		}
			break;
		case BTIRandomizerGroupModeNumberOfGroups:
		{
			[[self groupSizeLabel] setText:[NSString stringWithFormat:@"%d", [[[self classPeriod] numberOfGroups] intValue]]];
			
			[[self modeSegmentedControl] setSelectedSegmentIndex:1];
		}
			break;
		default:
			break;
	}
	
	[self populateRandomizerInfos];
	
	[self groupContents];
	
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
	
	[[DataController sharedDataController] saveCoreDataContext];
	
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

- (void)sortButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[self classPeriod] setRandomizerMode:[NSNumber numberWithInt:BTIRandomizerModeSorted]];
	
	[self setFetchedResultsController:nil];
	
	[self groupContents];
	
	[[self mainTableView] reloadData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)randomButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self classPeriod] setRandomizerMode:[NSNumber numberWithInt:BTIRandomizerModeRandom]];
	
	[self randomizeContents];
	
	[self setFetchedResultsController:nil];
	
	[self groupContents];
	
	[[self mainTableView] reloadData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)clearButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	for (RandomizerInfo *randomInfo in [[self classPeriod] randomizerInfos])
	{
		[randomInfo setCheckmarkMode:[NSNumber numberWithInt:BTIRandomizerCheckMarkModeNone]];
	}
	
	[[self mainTableView] reloadData];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)actionButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[self activeActionSheet] dismissWithClickedButtonIndex:[[self activeActionSheet] cancelButtonIndex] animated:NO];

	DataController *dataController = [DataController sharedDataController];
	
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
		[emailItem setLabel:@"Email List"];
		[emailItem setAction:^{
			
			[self emailListExport];
			
		}];
		
		[actionSheet addButtonItem:emailItem];
	}
	
	if ([UIPrintInteractionController isPrintingAvailable])
	{
		RIButtonItem *printItem = [RIButtonItem item];
		[printItem setLabel:@"Print List"];
		[printItem setAction:^{
			
			[self printListExport];
			
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

- (IBAction)groupSizeButtonPressed:(UIButton *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	ClassPeriod *classPeriod = [self classPeriod];
	
	switch ([[classPeriod groupMode] integerValue]) {
		case BTIRandomizerGroupModeGroupSize:
		{
			NSInteger groupSize = [[[self classPeriod] groupSize] intValue];
			
			if (button == [self minusButton])
			{
				groupSize--;
			}
			else
			{
				groupSize++;
			}
			
			if (groupSize < 1)
				groupSize = 1;
			
			[[self classPeriod] setGroupSize:[NSNumber numberWithInt:groupSize]];
			[[self groupSizeLabel] setText:[NSString stringWithFormat:@"%d", groupSize]];
		}
			break;
		case BTIRandomizerGroupModeNumberOfGroups:
		{
			NSInteger groupCount = [[[self classPeriod] numberOfGroups] intValue];
			
			if (button == [self minusButton])
			{
				groupCount--;
			}
			else
			{
				groupCount++;
			}
			
			if (groupCount < 1)
				groupCount = 1;
			
			[[self classPeriod] setNumberOfGroups:[NSNumber numberWithInt:groupCount]];
			[[self groupSizeLabel] setText:[NSString stringWithFormat:@"%d", groupCount]];
		}
			break;
		default:
			break;
	}
	
	[self groupContents];
		
	[[self mainTableView] reloadData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (IBAction)modeSegmentedControlValueChanged:(UISegmentedControl *)control
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	ClassPeriod *classPeriod = [self classPeriod];
	
	switch ([control selectedSegmentIndex]) {
		case 0:
		{
			[classPeriod setGroupMode:[NSNumber numberWithInt:BTIRandomizerGroupModeGroupSize]];
			[[self groupSizeLabel] setText:[NSString stringWithFormat:@"%d", [[classPeriod groupSize] intValue]]];
		}
			break;
		case 1:
		{
			[classPeriod setGroupMode:[NSNumber numberWithInt:BTIRandomizerGroupModeNumberOfGroups]];
			[[self groupSizeLabel] setText:[NSString stringWithFormat:@"%d", [[classPeriod numberOfGroups] intValue]]];
		}
			break;
		default:
			break;
	}
	
	[self groupContents];
	
	[[self mainTableView] reloadData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (void)populateRandomizerInfos
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	DataController *dataController = [DataController sharedDataController];
	NSManagedObjectContext *context = [dataController managedObjectContext];
	
	if ([[[self classPeriod] name] isEqualToString:kAllStudentsClassName])
	{
		NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
		[fetchRequest setEntity:[Person entityDescriptionInContextBTI:context]];
		
		NSArray *persons = [context executeFetchRequest:fetchRequest error:nil];
		
		[[self classPeriod] addPersons:[NSSet setWithArray:persons]];
	}
	
	for (Person *person in [[self classPeriod] persons])
	{
		NSLog(@"Person is: %@", [person fullName]);
		RandomizerInfo *randomInfo = [[self classPeriod] randomizerInfoForPerson:person];
		if (randomInfo == nil)		// Check to see if the person has one
		{
			randomInfo = [person randomizerInfoForClassPeriod:[self classPeriod]];
			
			if (randomInfo != nil)	// There is one, fix the connection
			{
				[[self classPeriod] addRandomizerInfosObject:randomInfo];
			}
		}
		
		if (randomInfo == nil)		// Need to create one
		{
			randomInfo = [RandomizerInfo managedObjectInContextBTI:context];
			[randomInfo setCheckmarkMode:[NSNumber numberWithInt:BTIRandomizerCheckMarkModeNone]];
			[randomInfo setPerson:person];
			[randomInfo setClassPeriod:[self classPeriod]];
		}
	}

	NSMutableSet *randomizerInfosToDelete = [NSMutableSet set];
	
	for (RandomizerInfo *randomizerInfo in [[self classPeriod] randomizerInfos])
	{
		if ([randomizerInfo person] == nil)		// Student was deleted
		{
			[randomizerInfosToDelete addObject:randomizerInfo];
			continue;
		}
		
		if (![[[self classPeriod] persons] containsObject:[randomizerInfo person]])		// Student removed from class
		{
			[randomizerInfosToDelete addObject:randomizerInfo];
			continue;
		}
	}
	
	for (RandomizerInfo *randomizerInfo in randomizerInfosToDelete)
	{
		[context deleteObject:randomizerInfo];
	}
	
	[dataController saveCoreDataContext];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)randomizeContents
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSArray *sortedInfos = [[self fetchedResultsController] fetchedObjects];
	
	NSMutableArray *sortedInfoList = [NSMutableArray array];
	
	[sortedInfoList addObjectsFromArray:sortedInfos];
	
	// http://stackoverflow.com/questions/56648/whats-the-best-way-to-shuffle-an-nsmutablearray
	NSUInteger count = [sortedInfoList count];
	for (NSUInteger i = 0; i < count; ++i)
	{
		// Select a random element between i and end of array to swap with.
		int nElements = count - i;
		int n = (arc4random() % nElements) + i;
		[sortedInfoList exchangeObjectAtIndex:i withObjectAtIndex:n];
	}
	
	[sortedInfoList enumerateObjectsUsingBlock:^(RandomizerInfo *randomInfo, NSUInteger index, BOOL *stop) {
		
		[randomInfo setSortOrder:[NSNumber numberWithInt:index]];
		
	}];
	
	[[DataController sharedDataController] saveCoreDataContext];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)groupContents
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self contents] removeAllObjects];
	
	NSArray *sortedInfos = [[self fetchedResultsController] fetchedObjects];

	ClassPeriod *classPeriod = [self classPeriod];
	NSInteger groupMode = [[classPeriod groupMode] integerValue];
	NSInteger groupSize = [[classPeriod groupSize] integerValue];
	NSInteger numberOfGroups = [[classPeriod numberOfGroups] integerValue];
	
	switch (groupMode) {
		case BTIRandomizerGroupModeGroupSize:
		{
			NSInteger groupCounter = 0;
			
			BTITableSectionInfo *currentSection = nil;
			
			for (RandomizerInfo *randomInfo in sortedInfos)
			{
				if (groupCounter == 0)
				{
					currentSection = [[BTITableSectionInfo alloc] init];
					[[self contents] addObject:currentSection];
					[currentSection release];		// Don't set to nil, still using it.
					[currentSection setSectionName:(groupSize == 1) ? nil : [NSString stringWithFormat:@"Group %d", [[self contents] count]]];
				}
				
				[currentSection addObjectToContents:randomInfo];
				
				groupCounter++;
				
				if (groupCounter == groupSize)
					groupCounter = 0;
			}
		}
			break;
		case BTIRandomizerGroupModeNumberOfGroups:
		{
			NSInteger numberOfStudents = [sortedInfos count];
			NSInteger minimumGroupSize = numberOfStudents / numberOfGroups;
			NSInteger leftoverStudents = numberOfStudents % numberOfGroups;
			
			BOOL shouldMakeNewGroup = YES;
			
			BTITableSectionInfo *currentSection = nil;
			
			for (RandomizerInfo *randomInfo in sortedInfos)
			{
				if (shouldMakeNewGroup)	
				{
					shouldMakeNewGroup = NO;
					currentSection = [[BTITableSectionInfo alloc] init];
					[[self contents] addObject:currentSection];
					[currentSection release];		// Don't set to nil, still using it.
					[currentSection setSectionName:(numberOfGroups == 1) ? nil : [NSString stringWithFormat:@"Group %d", [[self contents] count]]];
				}
				
				[currentSection addObjectToContents:randomInfo];
				
				if ([[self contents] count] < leftoverStudents + 1)
				{
					if ([currentSection countOfContents] == minimumGroupSize + 1)
						shouldMakeNewGroup = YES;
				}
				else
				{
					if ([currentSection countOfContents] == minimumGroupSize)
						shouldMakeNewGroup = YES;
				}
			}
		}
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)configureCell:(UITableViewCell *)cell
		  atIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	BTITableSectionInfo *sectionInfo = [[self contents] objectAtIndex:[indexPath section]];
	
	RandomizerInfo *randomInfo = [sectionInfo objectInContentsAtIndex:[indexPath row]];
	Person *person = [randomInfo person];

	switch ([userDefaults btiPersonDisplayMode]) {
		case BTIPersonSortModeFirstLast:
			[[cell textLabel] setText:[person fullName]];
			break;
		case BTIPersonSortModeLastFirst:
		{
			[[cell textLabel] setText:[person reverseFullName]];
		}
			break;
		default:
			break;
	}
	
	if ([userDefaults btiShouldShowPersonThumbnails])
	{
		[[cell imageView] setImage:[[person smallThumbnailMediaInfo] image]];
	}
	else
	{
		[[cell imageView] setImage:nil];
	}
	
	UIImageView *accessoryImageView = (UIImageView *)[cell accessoryView];
	
	switch ([[randomInfo checkmarkMode] intValue]) {
		case BTIRandomizerCheckMarkModeNone:
			[accessoryImageView setImage:nil];
			break;
		case BTIRandomizerCheckMarkModeGreenCheck:
			[accessoryImageView setImage:[UIImage imageNamed:@"greenCheck.png"]];
			break;
		case BTIRandomizerCheckMarkModeRedX:
			[accessoryImageView setImage:[UIImage imageNamed:@"redX.png"]];
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSString *)listExport
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableString *stringToReturn = [[[NSMutableString alloc] init] autorelease];
	NSString *newLine = @"\n";
	
	for (BTITableSectionInfo *sectionInfo in [self contents])
	{
		NSString *sectionName = [sectionInfo name];
		if (sectionName != nil)
		{
			[stringToReturn appendString:sectionName];
			[stringToReturn appendString:newLine];
		}
		
		for (RandomizerInfo *randomInfo in [sectionInfo contentsEnumerator])
		{
			Person *person = [randomInfo person];
			
			NSString *personName = nil;
			
			switch ([userDefaults btiPersonDisplayMode]) {
				case BTIPersonSortModeFirstLast:
					personName = [person fullName];
					break;
				case BTIPersonSortModeLastFirst:
				{
					personName = [person reverseFullName];
				}
					break;
				default:
					break;
			}
			
			if (personName != nil)
			{
				[stringToReturn appendString:personName];
				[stringToReturn appendString:newLine];
			}
		}
		
		[stringToReturn appendString:newLine];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return stringToReturn;
}

- (void)emailListExport
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	MFMailComposeViewController *mailComposer = [[[MFMailComposeViewController alloc] init] autorelease];
	[mailComposer setMailComposeDelegate:self];
	
	[mailComposer setMessageBody:[self listExport] isHTML:NO];
	
	[self presentModalViewController:mailComposer animated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)printListExport
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
	[printController setDelegate:self];
	
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
	[printInfo setOutputType:UIPrintInfoOutputGeneral];
	[printInfo setJobName:@"Randomizer"];
	
	[printController setPrintInfo:printInfo];
	
	UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc] initWithText:[self listExport]];
	[textFormatter setStartPage:0];
	[textFormatter setContentInsets:UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0)]; // 1 inch margins
	[textFormatter setMaximumContentWidth:6 * 72.0];
	
	[printController setPrintFormatter:textFormatter];
	
	[textFormatter release], textFormatter = nil;
	
	[printController setShowsPageRange:YES];
	
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
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
    };
	
	if ([[DataController sharedDataController] isIPadVersion])
	{
		[printController presentFromBarButtonItem:[self actionButton]
										 animated:YES
								completionHandler:completionHandler];
	}
	else
	{
		[printController presentAnimated:YES
					   completionHandler:completionHandler];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger sections = [[self contents] count];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return sections;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	BTITableSectionInfo *sectionInfo = [[self contents] objectAtIndex:section];
	
	NSString *header = [sectionInfo name];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return header;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	BTITableSectionInfo *sectionInfo = [[self contents] objectAtIndex:section];
	
	NSInteger rows = [sectionInfo countOfContents];
	
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
		
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
		[cell setAccessoryView:imageView];
		[imageView release], imageView = nil;
	}
	
	[self configureCell:cell atIndexPath:indexPath];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	BTITableSectionInfo *sectionInfo = [[self contents] objectAtIndex:[indexPath section]];
	
	RandomizerInfo *randomInfo = [sectionInfo objectInContentsAtIndex:[indexPath row]];
	
	NSInteger checkmarkMode = [[randomInfo checkmarkMode] intValue];
	
	checkmarkMode++;
	
	if (checkmarkMode > BTIRandomizerCheckMarkModeRedX)
	{
		checkmarkMode = BTIRandomizerCheckMarkModeNone;
	}
	
	[randomInfo setCheckmarkMode:[NSNumber numberWithInt:checkmarkMode]];
	
	[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - MFMailComposeViewControllerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError *)error
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
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
