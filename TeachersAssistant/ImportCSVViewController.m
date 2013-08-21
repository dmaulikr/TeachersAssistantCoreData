//
//  ImportCSVViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/30/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ImportCSVViewController.h"

// Models and other global

// Sub-controllers

// Views
#import "CSVTableCell.h"

// Private Constants

#define kFirstNameKey						@"kFirstNameKey"
#define kLastNameKey						@"kLastNameKey"
#define kClassKey							@"kClassKey"
#define kOther1Key							@"kOther1Key"
#define kOther2Key							@"kOther2Key"
#define kOther3Key							@"kOther3Key"
#define kParent1NameKey						@"kParent1NameKey"
#define kParent1PhoneKey					@"kParent1PhoneKey"
#define kParent1EmailKey					@"kParent1EmailKey"
#define kParent2NameKey						@"kParent2NameKey"
#define kParent2PhoneKey					@"kParent2PhoneKey"
#define kParent2EmailKey					@"kParent2EmailKey"

typedef enum
{
	BTICSVComponentFirstName = 0,
	BTICSVComponentLastName,
	BTICSVComponentClass,
	BTICSVComponentOther1,
	BTICSVComponentOther2,
	BTICSVComponentOther3,
	BTICSVComponentParent1Name,
	BTICSVComponentParent1Phone,
	BTICSVComponentParent1Email,
	BTICSVComponentParent2Name,
	BTICSVComponentParent2Phone,
	BTICSVComponentParent2Email,
	BTICSVComponentTotalCount
} BTICSVComponent;

@interface ImportCSVViewController ()

// Private Properties
@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, retain) NSDictionary *headerPerson;
@property (nonatomic, assign, getter = isShowingHeader) BOOL showingHeader;
@property (nonatomic, retain) UIBarButtonItem *toggleButton;

// Notification Handlers



// UI Response Methods
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)importButtonPressed:(UIBarButtonItem *)button;
- (void)toggleButtonPressed:(UIBarButtonItem *)button;

// Misc Methods
- (void)addDataFromImportedFileWithReplace:(BOOL)shouldReplace;
- (void)toggleHeaderRow;
- (NSString *)keyForCSVComponent:(NSInteger)component;

@end

@implementation ImportCSVViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;
@synthesize csvTableCell = ivCsvTableCell;

// Private
@synthesize contentList = ivContentList;
@synthesize headerPerson = ivHeaderPerson;
@synthesize showingHeader = ivShowingHeader;
@synthesize toggleButton = ivToggleButton;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTableView:nil];
	[self setCsvTableCell:nil];
	
	// Private Properties
    [self setContentList:nil];
    [self setHeaderPerson:nil];
    [self setToggleButton:nil];
	
	
	
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

- (NSMutableArray *)contentList
{
	if (ivContentList == nil)
	{
		ivContentList = [[NSMutableArray alloc] init];
	}
	return ivContentList;
}

#pragma mark - Initialization and UI Creation Methods


#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:@"Import Preview"];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																				  target:self
																				  action:@selector(cancelButtonPressed:)];
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	[cancelButton release], cancelButton = nil;
	
	UIBarButtonItem *importButton = [[UIBarButtonItem alloc] initWithTitle:@"Import"
																	 style:UIBarButtonItemStyleBordered
																	target:self
																	action:@selector(importButtonPressed:)];
	[[self navigationItem] setRightBarButtonItem:importButton];
	[importButton release], importButton = nil;
	
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	
	UIBarButtonItem *toggle = [[UIBarButtonItem alloc] initWithTitle:@"Ignore Header Row"
															   style:UIBarButtonItemStyleBordered
															  target:self
															  action:@selector(toggleButtonPressed:)];
	[self setToggleButton:toggle];
	
	[self setToolbarItems:[NSArray arrayWithObjects:flexItem, toggle, flexItem, nil]];
	
	[toggle release], toggle = nil;
	[flexItem release], flexItem = nil;
	
	// Set table row height
	
	[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CSVTableCell class]) owner:self options:nil];
	[[self mainTableView] setRowHeight:[[self csvTableCell] frame].size.height];
	[self setCsvTableCell:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self navigationController] setToolbarHidden:NO animated:YES];
	
	[[self contentList] removeAllObjects];
	
	DataController *dataController = [DataController sharedDataController];
	
	NSString *path = [dataController importedFilePath];
	
	// Default to UTF-8
	NSLog(@"Default NSUTF8StringEncoding");
	NSMutableString *csvContents = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	
	if (csvContents == nil)
	{
		NSLog(@"Trying NSASCIIStringEncoding");
		csvContents = [NSMutableString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
	}
	
	if (csvContents == nil)
	{
		NSLog(@"Trying NSUTF16StringEncoding");
		csvContents = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF16StringEncoding error:nil];
	}
	
	if (csvContents == nil)
	{
		NSLog(@"Trying NSUTF32StringEncoding");
		csvContents = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF32StringEncoding error:nil];
	}
	
	if (csvContents == nil)
	{
		NSLog(@"Trying NSNonLossyASCIIStringEncoding");
		csvContents = [NSMutableString stringWithContentsOfFile:path encoding:NSNonLossyASCIIStringEncoding error:nil];
	}
	
	if (csvContents == nil)
	{
		NSLog(@"Trying NSISOLatin1StringEncoding");
		csvContents = [NSMutableString stringWithContentsOfFile:path encoding:NSISOLatin1StringEncoding error:nil];
	}
	
	if (csvContents == nil)
	{
		NSLog(@"Trying NSISOLatin2StringEncoding");
		csvContents = [NSMutableString stringWithContentsOfFile:path encoding:NSISOLatin2StringEncoding error:nil];
	}
	
	if (csvContents == nil)
	{
		NSLog(@"Trying NSUnicodeStringEncoding");
		csvContents = [NSMutableString stringWithContentsOfFile:path encoding:NSUnicodeStringEncoding error:nil];
	}
	
	if (csvContents == nil)
	{
		NSLog(@"Trying NSWindowsCP1252StringEncoding");
		csvContents = [NSMutableString stringWithContentsOfFile:path encoding:NSWindowsCP1252StringEncoding error:nil];
	}
	
	if (csvContents == nil)
	{
		NSLog(@"Trying NSWindowsCP1253StringEncoding");
		csvContents = [NSMutableString stringWithContentsOfFile:path encoding:NSWindowsCP1253StringEncoding error:nil];
	}
	
	if (csvContents == nil)
	{
		NSLog(@"Trying NSWindowsCP1254StringEncoding");
		csvContents = [NSMutableString stringWithContentsOfFile:path encoding:NSWindowsCP1254StringEncoding error:nil];
	}
	
	if (csvContents == nil)
	{
		NSLog(@"Trying NSWindowsCP1250StringEncoding");
		csvContents = [NSMutableString stringWithContentsOfFile:path encoding:NSWindowsCP1250StringEncoding error:nil];
	}
	
	if (csvContents == nil)
	{
		NSLog(@"Trying NSWindowsCP1250StringEncoding");
		csvContents = [NSMutableString stringWithContentsOfFile:path encoding:NSWindowsCP1250StringEncoding error:nil];
	}
	
	if (csvContents == nil)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unknown Encoding"
														message:@"This file has an unsupported text encoding. Verify that is it UTF-8 or ASCII. Unable to proceed."
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release], alert = nil;
		
		NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
		return;
	}
	
	// Clean up imported results
	
	// Newline
	[csvContents replaceOccurrencesOfString:@"\r" withString:@"\n" options:NSLiteralSearch range:NSMakeRange(0,[csvContents length])];
	
	// Double quote
	[csvContents replaceOccurrencesOfString:@"\"" withString:@"" options:NSLiteralSearch range:NSMakeRange(0,[csvContents length])];
	
	// Curly double quote
	[csvContents replaceOccurrencesOfString:[NSString stringWithUTF8String:"\u201C"] withString:@"" options:NSLiteralSearch range:NSMakeRange(0,[csvContents length])];
	[csvContents replaceOccurrencesOfString:[NSString stringWithUTF8String:"\u201D"] withString:@"" options:NSLiteralSearch range:NSMakeRange(0,[csvContents length])];
	
	// Curly single quote (replace with normal single quote)
	[csvContents replaceOccurrencesOfString:[NSString stringWithUTF8String:"\u2018"] withString:@"'" options:NSLiteralSearch range:NSMakeRange(0,[csvContents length])];
	[csvContents replaceOccurrencesOfString:[NSString stringWithUTF8String:"\u2019"] withString:@"'" options:NSLiteralSearch range:NSMakeRange(0,[csvContents length])];
	
	NSArray *lines = [csvContents componentsSeparatedByString:@"\n"];
	NSLog(@"lines is: %@", lines);
	
	[[self toggleButton] setEnabled:YES];
	
	// Process data
	
	[lines enumerateObjectsUsingBlock:^(id lineObject, NSUInteger lineIndex, BOOL *stop) {
		
		NSString *line = (NSString *)lineObject;
		NSLog(@"line is: %@", line);
		
		if ([line length] == 0)
			return;
		
		NSArray *values = [line componentsSeparatedByString:@","];
		
		__block NSMutableDictionary *personDictionary = [[NSMutableDictionary alloc] init];
		
		[values enumerateObjectsUsingBlock:^(id valueObject, NSUInteger valueIndex, BOOL *stop) {
			NSString *value = (NSString *)valueObject;
			
			if (valueIndex >= BTICSVComponentTotalCount)
				return;
			
			if ([value length] > 0)				// Prevent empty fields
			{
				[personDictionary setValue:value forKey:[self keyForCSVComponent:valueIndex]];
				NSLog(@"value is: %@", value);
			}
		}];
		
		if ([personDictionary count] > 0)		// Prevent blank lines
		{
			[[self contentList] addObject:personDictionary];
		}
		
		[personDictionary release], personDictionary = nil;
	}];
	
	if ([[self contentList] count] == 0)
	{
		NSMutableDictionary *personDictionary = [[NSMutableDictionary alloc] init];
		
		[personDictionary setValue:@"No Data" forKey:[self keyForCSVComponent:BTICSVComponentFirstName]];
		[personDictionary setValue:@"To Import" forKey:[self keyForCSVComponent:BTICSVComponentLastName]];
		
		[[self contentList] addObject:personDictionary];
		
		[personDictionary release], personDictionary = nil;
		
		[[[self navigationItem] rightBarButtonItem] setEnabled:NO];
		
		[[self toggleButton] setEnabled:NO];
	}
	
	[self setShowingHeader:YES];
	
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

	DataController *dataController = [DataController sharedDataController];
	
	NSString *path = [dataController importedFilePath];
	
	if ([path rangeOfString:@"Inbox" options:NSLiteralSearch].location != NSNotFound)		// Leave files added via iTunes
	{
		[[NSFileManager defaultManager] removeItemAtPath:[dataController importedFilePath] error:nil];
	}
	
	[dataController setImportedFilePath:nil];
	
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
	
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)importButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	DataController *dataController = [DataController sharedDataController];
	
	NSString *personSingular = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
	NSString *classSingular = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierClass];
	
	RIButtonItem *cancelButton = [RIButtonItem item];
	[cancelButton setLabel:@"Cancel"];
	
	RIButtonItem *replaceButton = [RIButtonItem item];
	[replaceButton setLabel:@"Replace"];
	[replaceButton setAction:^{
		[self addDataFromImportedFileWithReplace:YES];
	}];
	
	RIButtonItem *addButton = [RIButtonItem item];
	[addButton setLabel:@"Add"];
	[addButton setAction:^{
		[self addDataFromImportedFileWithReplace:NO];
	}];
	
	NSString *message = [NSString stringWithFormat:@"Do you want to replace (delete) your current %@/%@ data, or add new data?", personSingular, classSingular];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Import Data"
													message:message
										   cancelButtonItem:cancelButton
										   otherButtonItems:replaceButton, addButton, nil];
	
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Import Data"
//													message:@"Do you want to replace your existing data or add new data?"
//												   delegate:self
//										  cancelButtonTitle:@"Cancel"
//										  otherButtonTitles:@"Replace", @"Add", nil];
	[alert show];
	[alert release], alert = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)toggleButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self toggleHeaderRow];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (void)addDataFromImportedFileWithReplace:(BOOL)shouldReplace
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	DataController *dataController = [DataController sharedDataController];
	NSManagedObjectContext *context = [dataController managedObjectContext];
	
	if (shouldReplace)
	{
		[dataController deleteAllPersons];
		[dataController deleteAllClassPeriods];
		[dataController loadDefaultClassPeriods];
		[dataController deleteAllPersonDetailInfos];
	}
	
	PersonDetailInfo *other1Info = nil;
	PersonDetailInfo *other2Info = nil;
	PersonDetailInfo *other3Info = nil;
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	[fetchRequest setEntity:[PersonDetailInfo entityDescriptionInContextBTI:context]];
	[fetchRequest setSortDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
	
	NSArray *detailInfos = [context executeFetchRequest:fetchRequest error:nil];
	NSInteger numberOfInfos = [detailInfos count];
	
	if (numberOfInfos > 0)
	{
		other1Info = [detailInfos objectAtIndex:0];
	}
	else
	{
		other1Info = [PersonDetailInfo managedObjectInContextBTI:context];
		[other1Info setName:@"Other 1"];
		[other1Info setSortOrder:[NSNumber numberWithInt:numberOfInfos + 1]];
	}
	
	if (numberOfInfos > 1)
	{
		other2Info = [detailInfos objectAtIndex:1];
	}
	else
	{
		other2Info = [PersonDetailInfo managedObjectInContextBTI:context];
		[other2Info setName:@"Other 2"];
		[other2Info setSortOrder:[NSNumber numberWithInt:numberOfInfos + 2]];
	}
	
	if (numberOfInfos > 2)
	{
		other3Info = [detailInfos objectAtIndex:2];
	}
	else
	{
		other3Info = [PersonDetailInfo managedObjectInContextBTI:context];
		[other3Info setName:@"Other 3"];
		[other3Info setSortOrder:[NSNumber numberWithInt:numberOfInfos + 3]];
	}
	
	for (NSDictionary *personDictionary in [self contentList])
	{
		Person *person = [Person managedObjectInContextBTI:context];
		[person setFirstName:[personDictionary objectForKey:[self keyForCSVComponent:BTICSVComponentFirstName]]];
		[person setLastName:[personDictionary objectForKey:[self keyForCSVComponent:BTICSVComponentLastName]]];
		
		NSString *other1 = [personDictionary objectForKey:[self keyForCSVComponent:BTICSVComponentOther1]];
		NSString *other2 = [personDictionary objectForKey:[self keyForCSVComponent:BTICSVComponentOther2]];
		NSString *other3 = [personDictionary objectForKey:[self keyForCSVComponent:BTICSVComponentOther3]];
		
		if ( (other1 != nil) && ([other1 length] > 0) )
		{
			PersonDetailValue *otherValue1 = [PersonDetailValue managedObjectInContextBTI:context];
			[otherValue1 setName:other1];
			
			[otherValue1 setPerson:person];
			[otherValue1 setPersonDetailInfo:other1Info];
		}
		
		if ( (other2 != nil) && ([other2 length] > 0) )
		{
			PersonDetailValue *otherValue2 = [PersonDetailValue managedObjectInContextBTI:context];
			[otherValue2 setName:other2];
			
			[otherValue2 setPerson:person];
			[otherValue2 setPersonDetailInfo:other2Info];
		}
		
		if ( (other3 != nil) && ([other3 length] > 0) )
		{
			PersonDetailValue *otherValue3 = [PersonDetailValue managedObjectInContextBTI:context];
			[otherValue3 setName:other3];
			
			[otherValue3 setPerson:person];
			[otherValue3 setPersonDetailInfo:other3Info];
		}
		
		NSString *className = [personDictionary objectForKey:[self keyForCSVComponent:BTICSVComponentClass]];
		if (className != nil)
		{
			ClassPeriod *classPeriod = [dataController classPeriodWithName:className];
			if (classPeriod == nil)
			{
				classPeriod = [ClassPeriod managedObjectInContextBTI:context];
				[classPeriod setName:className];
				[classPeriod setSortOrder:[NSNumber numberWithInt:[dataController countOfClassPeriods]]];
			}
			
			[person addClassPeriodsObject:classPeriod];
		}
		
		NSString *parent1Name = [personDictionary objectForKey:[self keyForCSVComponent:BTICSVComponentParent1Name]];
		NSString *parent1Phone = [personDictionary objectForKey:[self keyForCSVComponent:BTICSVComponentParent1Phone]];
		NSString *parent1Email = [personDictionary objectForKey:[self keyForCSVComponent:BTICSVComponentParent1Email]];
		
		if ( (parent1Name != nil) || (parent1Phone != nil) || (parent1Email != nil) )
		{
			Parent *parent = [Parent managedObjectInContextBTI:context];
			[parent setName:parent1Name];
			
			if (parent1Phone != nil)
			{
				PhoneNumber *phoneNumber = [PhoneNumber managedObjectInContextBTI:context];
				[phoneNumber setType:kContactInfoTypeOther];
				[phoneNumber setValue:parent1Phone];
				[phoneNumber setSortOrder:[NSNumber numberWithInt:0]];
				
				[parent addPhoneNumbersObject:phoneNumber];
			}
			
			if (parent1Email != nil)
			{
				EmailAddress *emailAddress = [EmailAddress managedObjectInContextBTI:context];
				[emailAddress setType:kContactInfoTypeOther];
				[emailAddress setValue:parent1Email];
				[emailAddress setSortOrder:[NSNumber numberWithInt:0]];
				
				[parent addEmailAddressesObject:emailAddress];
			}
			
			[parent setSortOrder:[NSNumber numberWithInt:0]];
			[person addParentsObject:parent];
		}

		NSString *parent2Name = [personDictionary objectForKey:[self keyForCSVComponent:BTICSVComponentParent2Name]];
		NSString *parent2Phone = [personDictionary objectForKey:[self keyForCSVComponent:BTICSVComponentParent2Phone]];
		NSString *parent2Email = [personDictionary objectForKey:[self keyForCSVComponent:BTICSVComponentParent2Email]];
		
		if ( (parent2Name != nil) || (parent2Phone != nil) || (parent2Email != nil) )
		{
			Parent *parent = [Parent managedObjectInContextBTI:context];
			[parent setName:parent2Name];
			
			if (parent2Phone != nil)
			{
				PhoneNumber *phoneNumber = [PhoneNumber managedObjectInContextBTI:context];
				[phoneNumber setType:kContactInfoTypeOther];
				[phoneNumber setValue:parent2Phone];
				[phoneNumber setSortOrder:[NSNumber numberWithInt:0]];
				
				[parent addPhoneNumbersObject:phoneNumber];
			}
			
			if (parent2Email != nil)
			{
				EmailAddress *emailAddress = [EmailAddress managedObjectInContextBTI:context];
				[emailAddress setType:kContactInfoTypeOther];
				[emailAddress setValue:parent2Email];
				[emailAddress setSortOrder:[NSNumber numberWithInt:0]];
				
				[parent addEmailAddressesObject:emailAddress];
			}
			
			[parent setSortOrder:[NSNumber numberWithInt:[[person parents] count]]];
			[person addParentsObject:parent];
		}
	}
	
	[dataController saveCoreDataContext];
	
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)toggleHeaderRow
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self setShowingHeader:![self isShowingHeader]];
	
	[[self mainTableView] beginUpdates];
	
	if ([self isShowingHeader])
	{
		if ([self headerPerson] != nil)
		{
			[[self contentList] insertObject:[self headerPerson] atIndex:0];
			[self setHeaderPerson:nil];
			
			[[self mainTableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
		}
	}
	else
	{
		[self setHeaderPerson:[[self contentList] objectAtIndex:0]];
		
		[[self contentList] removeObjectAtIndex:0];
		[[self mainTableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
	}
	
	[[self mainTableView] endUpdates];
	
	
	if ([self isShowingHeader])
	{
		[[self toggleButton] setTitle:@"Ignore Header Row"];
	}
	else
	{
		[[self toggleButton] setTitle:@"Include Header Row"];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

+ (NSData *)templateFileForCSVImport
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSMutableArray *headerRow = [NSMutableArray array];
	NSMutableArray *sampleRow = [NSMutableArray array];
	
	[headerRow addObject:@"Student First Name"];
	[sampleRow addObject:@"John"];
	
	[headerRow addObject:@"Student Last Name"];
	[sampleRow addObject:@"Smith"];
	
	[headerRow addObject:@"Class Name"];
	[sampleRow addObject:@"3rd Period"];
	
	[headerRow addObject:@"Other 1"];
	[sampleRow addObject:@"ID 12345"];
	
	[headerRow addObject:@"Other 2"];
	[sampleRow addObject:@"ID 67890"];
	
	[headerRow addObject:@"Other 3"];
	[sampleRow addObject:@"ID 2468"];
	
	[headerRow addObject:@"Parent 1 Name"];
	[sampleRow addObject:@"Mr. Smith"];
	
	[headerRow addObject:@"Parent 1 Phone"];
	[sampleRow addObject:@"540-555-1212"];
	
	[headerRow addObject:@"Parent 1 Email"];
	[sampleRow addObject:@"email@sample.com"];
	
	[headerRow addObject:@"Parent 2 Name"];
	[sampleRow addObject:@"Mrs. Smith"];
	
	[headerRow addObject:@"Parent 2 Phone"];
	[sampleRow addObject:@"540-555-1212"];
	
	[headerRow addObject:@"Parent 2 Email"];
	[sampleRow addObject:@"email2@sample.com"];
	
	NSString *header = [headerRow componentsJoinedByString:@","];
	NSString *sample = [sampleRow componentsJoinedByString:@","];
	
	NSString *fullFileBody = [NSString stringWithFormat:@"%@\n%@", header, sample];
	NSLog(@"fullFileBody is: %@", fullFileBody);
	
	NSData *file = [fullFileBody dataUsingEncoding:NSASCIIStringEncoding];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return file;
}

+ (void)emailTemplateCSVFileFromViewController:(id)viewController
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
	[mailController setMailComposeDelegate:viewController];
	
	[mailController setSubject:@"Teacher's Assistant Pro CSV Template File"];
	
	NSMutableString *messageBody = [NSMutableString string];
	
	[messageBody appendString:@"Please use this CSV template attachment to get your students’ information into Teacher’s Assistant Pro with just a few clicks!\n\n"];
	[messageBody appendString:@"Step 1: Send this email to yourself by filling your address at the top of this screen and tapping \"Send\"\n\n"];
	[messageBody appendString:@"Step 2: Open the email on a desktop or laptop computer and then open the attachment in a spreadsheet program such as Excel or Numbers.\n\n"];
	[messageBody appendString:@"Step 3: Look at the first row (the header row) and fill in the information below the headers for your classes.  Do not use commas anywhere.\n\n"];
	[messageBody appendString:@"Step 4: Once you have filled in the data, \"Save As…\" a CSV format file (comma separated values).\n\n"];
	[messageBody appendString:@"Step 5: Email the file to yourself as an attachment and open it on your iPad or iPhone.\n\n"];
	[messageBody appendString:@"Step 6: Tap the attachment and choose \"Open in Teachers Asst\".  IMPORT WILL ONLY WORK IN THE PRO VERSION.\n\n"];
	[messageBody appendString:@"Step 7: Tap \"Ignore Header Row\" at the bottom of the screen.  Look thoroughly at the preview and make sure your data is labeled correctly.\n\n"];
	[messageBody appendString:@"Step 8: Tap \"Import\" and choose to either \"Add\" to your existing data or \"Replace\" your data.\n\n"];
	
	[messageBody appendString:@"That’s it!  Please see the “Frequently Asked Questions” under “Resources” or email chris@cleveriosapps.com for assistance."];
	
	[mailController setMessageBody:messageBody isHTML:NO];
	
	[mailController addAttachmentData:[ImportCSVViewController templateFileForCSVImport]
							 mimeType:@"text/csv"
							 fileName:@"TAP_CSV_Template.csv"];
	
	[viewController presentModalViewController:mailController animated:YES];
	
	[mailController release], mailController = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSString *)keyForCSVComponent:(NSInteger)component
{
//	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSString *key = @"";
	
	switch (component) {
		case BTICSVComponentFirstName:
			key = kFirstNameKey;
			break;
		case BTICSVComponentLastName:
			key = kLastNameKey;
			break;
		case BTICSVComponentClass:
			key = kClassKey;
			break;
		case BTICSVComponentOther1:
			key = kOther1Key;
			break;
		case BTICSVComponentOther2:
			key = kOther2Key;
			break;
		case BTICSVComponentOther3:
			key = kOther3Key;
			break;
		case BTICSVComponentParent1Name:
			key = kParent1NameKey;
			break;
		case BTICSVComponentParent1Phone:
			key = kParent1PhoneKey;
			break;
		case BTICSVComponentParent1Email:
			key = kParent1EmailKey;
			break;
		case BTICSVComponentParent2Name:
			key = kParent2NameKey;
			break;
		case BTICSVComponentParent2Phone:
			key = kParent2PhoneKey;
			break;
		case BTICSVComponentParent2Email:
			key = kParent2EmailKey;
			break;
		default:
			break;
	}

	NSLog(@"key is: %@", key);
//	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return key;
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger sections = 1;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return sections;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger rows = [[self contentList] count];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger row = [indexPath row];
	NSDictionary *person = [[self contentList] objectAtIndex:row];
	
	if ([[person objectForKey:[self keyForCSVComponent:BTICSVComponentFirstName]] isEqualToString:@"Invalid"])
	{
		static NSString *CellIdentifier = @"CellIdentifier";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil)
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		}
		
		[[cell textLabel] setTextAlignment:UITextAlignmentCenter];
		[[cell detailTextLabel] setTextAlignment:UITextAlignmentCenter];
		
		[[cell textLabel] setText:@"Invalid CSV Format."];
		[[cell detailTextLabel] setText:@"See tutorial for format instructions"];
		
		NSLog(@"<<< Leaving %s >>> EARLY - Bad CSV Format", __PRETTY_FUNCTION__);
		return cell;
	}
	
	CSVTableCell *cell = (CSVTableCell *)[tableView dequeueReusableCellWithIdentifier:[CSVTableCell reuseIdentifier]];
	
	if (cell == nil)
	{
		[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CSVTableCell class]) owner:self options:nil];
		cell = [self csvTableCell];
		[self setCsvTableCell:nil];
	}
	
	[[cell firstNameLabel] setText:[person objectForKey:[self keyForCSVComponent:BTICSVComponentFirstName]]];
	[[cell lastNameLabel] setText:[person objectForKey:[self keyForCSVComponent:BTICSVComponentLastName]]];
	[[cell other1Label] setText:[person objectForKey:[self keyForCSVComponent:BTICSVComponentOther1]]];
	[[cell other2Label] setText:[person objectForKey:[self keyForCSVComponent:BTICSVComponentOther2]]];
	[[cell other3Label] setText:[person objectForKey:[self keyForCSVComponent:BTICSVComponentOther3]]];
    [[cell classLabel] setText:[person objectForKey:[self keyForCSVComponent:BTICSVComponentClass]]];
	[[cell parent1NameLabel] setText:[person objectForKey:[self keyForCSVComponent:BTICSVComponentParent1Name]]];
	[[cell parent1EmailLabel] setText:[person objectForKey:[self keyForCSVComponent:BTICSVComponentParent1Email]]];
	[[cell parent1PhoneLabel] setText:[person objectForKey:[self keyForCSVComponent:BTICSVComponentParent1Phone]]];
	[[cell parent2NameLabel] setText:[person objectForKey:[self keyForCSVComponent:BTICSVComponentParent2Name]]];
	[[cell parent2EmailLabel] setText:[person objectForKey:[self keyForCSVComponent:BTICSVComponentParent2Email]]];
	[[cell parent2PhoneLabel] setText:[person objectForKey:[self keyForCSVComponent:BTICSVComponentParent2Phone]]];
	
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

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (buttonIndex != [alertView cancelButtonIndex])
	{
		if (buttonIndex == [alertView firstOtherButtonIndex])			// Replace
		{
			[self addDataFromImportedFileWithReplace:YES];
		}
		else															// Add
		{
			[self addDataFromImportedFileWithReplace:NO];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
