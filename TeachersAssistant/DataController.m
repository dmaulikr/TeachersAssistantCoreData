//
//  DataController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/14/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//


#import "DataController.h"

// Models and other global
#import "ObsoleteDataController.h"
#import "GTMBase64.h"
#import "ZipFile.h"
#import "ZipWriteStream.h"
#import "ZipReadStream.h"
#import "FileInZipInfo.h"
#import "BTILoadingHelper.h"
#import "ASIFormDataRequest.h"
#import "NSData+Base64.h"

// Private Constants

#define kAlertViewTagOldDataImport					100
#define kAlertViewTagNewDataImport					200
#define kAlertViewConfirmOverwriteDropboxTag			300

@interface DataController ()

// Private Properties

#pragma mark - Directories
@property (nonatomic, copy) NSString *documentsDirectory;
@property (nonatomic, copy) NSString *libraryDirectory;
@property (nonatomic, copy) NSString *libraryApplicationSupportDirectory;
@property (nonatomic, copy) NSString *imageDirectory;
@property (nonatomic, copy) NSString *audioDirectory;
@property (nonatomic, copy) NSString *videoDirectory;

#pragma mark - Core Data
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSPredicate *identifierRootPredicate;
@property (nonatomic, retain) NSMutableDictionary *identifierPredicateVariables;
@property (nonatomic, retain) NSFetchRequest *identifierFetchRequest;

#pragma mark - Helpers
@property (nonatomic, assign, getter=isLiteVersion) BOOL liteVersion;
@property (nonatomic, assign, getter=isIPadVersion) BOOL iPadVersion;
@property (nonatomic, retain) NSSortDescriptor *firstNameAlphabeticSortDescriptor;
@property (nonatomic, retain) NSSortDescriptor *firstLetterFirstNameAlphabeticSortDescriptor;
@property (nonatomic, retain) NSArray *descriptorArrayForFirstNameAlphabeticSort;
@property (nonatomic, retain) NSSortDescriptor *lastNameAlphabeticSortDescriptor;
@property (nonatomic, retain) NSSortDescriptor *firstLetterLastNameAlphabeticSortDescriptor;
@property (nonatomic, retain) NSArray *descriptorArrayForLastNameAlphabeticSort;
@property (nonatomic, retain) NSSortDescriptor *manualSortOrderSortDescriptor;
@property (nonatomic, retain) NSArray *descriptorArrayForManualSortOrderSort;
@property (nonatomic, retain) NSSortDescriptor *nameAlphabeticSortDescriptor;
@property (nonatomic, retain) NSArray *descriptorArrayForNameAlphabeticSort;


#pragma mark - Misc
@property (nonatomic, retain) Action *defaultAction;
@property (nonatomic, retain) Action *filterAction;
@property (nonatomic, retain) UIAlertView *processingAlertView;
@property (nonatomic, retain) UIAlertView *progressAlertView;
@property (nonatomic, assign) UIViewController *presentingViewController;

#pragma mark - Dropbox Support
@property (nonatomic, retain) DBRestClient *restClient;
@property (nonatomic, retain) DBRestClient *restFolderClient;
@property (nonatomic, assign, getter=isDropboxWorking) BOOL dropboxWorking;
@property (nonatomic, assign, getter=isDropboxDestinationFolderCreated) BOOL dropboxDestinationFolderCreated;
@property (nonatomic, copy) NSString *dropboxUploadFilePath;

// Notification Handlers
- (void)didReceiveMemoryWarning:(NSNotification *)notification;
- (void)managedObjectContextDidSave:(NSNotification *)notification;

// Misc Methods
- (void)loadTestData;
- (void)loadDefaultColorInfo;

- (void)loadDefaultRandomizerInfo;
- (void)addObsoleteDataFromImportedFileWithReplace:(NSNumber *)shouldReplace;
//- (void)addDataFromImportedFileWithReplace:(NSNumber *)shouldReplace;
- (void)restoreFromModernBackupFile;		// .tappro format
- (void)restoreFromLegacyBackupFile;		// .idiscipline format
- (void)saveBackgroundThreadManagedObjectContext:(NSManagedObjectContext *)backgroundContext;

//Dropbox upload
- (void)checkForDropboxDestinationFolder;
- (void)createDropboxDestinationFolder;
- (void)downloadDropboxMetadata;
- (void)downloadDropboxDestinationFolderMetadata;
- (void)uploadDropboxFile;
- (void)displayDropboxUploadError;

- (void)showProgressAlertWithTitle:(NSString *)title;
- (void)updateProgressViewWithProgress:(NSNumber *)progress;

- (void)migratePersonOtherFieldToPersonDetailInfo;


@end

#pragma mark -

@implementation DataController

#pragma mark - Synthesized Properties

// Public
@synthesize imageCleanupEnabled = ivImageCleanupEnabled;
@synthesize actionActionFieldInfoInMainContext = ivActionActionFieldInfoInMainContext;
@synthesize dateActionFieldInfoInMainContext = ivDateActionFieldInfoInMainContext;
@synthesize allSortedActionFieldInfosInMainContext = ivAllSortedActionFieldInfosInMainContext;

// Private
@synthesize documentsDirectory = ivDocumentsDirectory;
@synthesize libraryDirectory = ivLibraryDirectory;
@synthesize libraryApplicationSupportDirectory = ivLibraryApplicationSupportDirectory;
@synthesize imageDirectory = ivImageDirectory;
@synthesize audioDirectory = ivAudioDirectory;
@synthesize videoDirectory = ivVideoDirectory;
@synthesize managedObjectContext = ivManagedObjectContext;
@synthesize managedObjectModel = ivManagedObjectModel;
@synthesize persistentStoreCoordinator = ivPersistentStoreCoordinator;
@synthesize identifierRootPredicate = ivIdentifierRootPredicate;
@synthesize identifierPredicateVariables = ivIdentifierPredicateVariables;
@synthesize identifierFetchRequest = ivIdentifierFetchRequest;
@synthesize liteVersion = ivLiteVersion;
@synthesize iPadVersion = iviPadVersion;
@synthesize firstNameAlphabeticSortDescriptor = ivFirstNameAlphabeticSortDescriptor;
@synthesize firstLetterFirstNameAlphabeticSortDescriptor = ivFirstLetterFirstNameAlphabeticSortDescriptor;
@synthesize descriptorArrayForFirstNameAlphabeticSort = ivDescriptorArrayForFirstNameAlphabeticSort;
@synthesize lastNameAlphabeticSortDescriptor = ivLastNameAlphabeticSortDescriptor;
@synthesize firstLetterLastNameAlphabeticSortDescriptor = ivFirstLetterLastNameAlphabeticSortDescriptor;
@synthesize descriptorArrayForLastNameAlphabeticSort = ivDescriptorArrayForLastNameAlphabeticSort;
@synthesize manualSortOrderSortDescriptor = ivManualSortOrderSortDescriptor;
@synthesize descriptorArrayForManualSortOrderSort = ivDescriptorArrayForManualSortOrderSort;
@synthesize nameAlphabeticSortDescriptor = ivNameAlphabeticSortDescriptor;
@synthesize descriptorArrayForNameAlphabeticSort = ivDescriptorArrayForNameAlphabeticSort;
@synthesize defaultAction = ivDefaultAction;
@synthesize filterAction = ivFilterAction;
@synthesize processingAlertView = ivProcessingAlertView;
@synthesize progressAlertView = ivProgressAlertView;
@synthesize presentingViewController = ivPresentingViewController;
@synthesize importedUpgradeData = ivImportedUpgradeData;
@synthesize importedFilePath = ivImportedFilePath;
@synthesize obsoleteDataController = ivObsoleteDataController;
@synthesize activeGradingPeriod = ivActiveGradingPeriod;
@synthesize gradingPeriods = ivGradingPeriods;
@synthesize restClient = ivRestClient;
@synthesize restFolderClient = ivRestFolderClient;
@synthesize dropboxWorking = ivDropboxWorking;
@synthesize dropboxDestinationFolderCreated = ivDropboxDestinationFolderCreated;
@synthesize dropboxUploadFilePath = ivDropboxUploadFilePath;

#pragma mark - Dealloc and Memory Management

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// Public Properties
	[self setActionActionFieldInfoInMainContext:nil];
	
	// Private Properties
    [self setDocumentsDirectory:nil];
    [self setLibraryDirectory:nil];
    [self setLibraryApplicationSupportDirectory:nil];
    [self setImageDirectory:nil];
    [self setAudioDirectory:nil];
    [self setVideoDirectory:nil];
    [self setManagedObjectContext:nil];
    [self setManagedObjectModel:nil];
    [self setPersistentStoreCoordinator:nil];
    [self setIdentifierRootPredicate:nil];
    [self setIdentifierPredicateVariables:nil];
	[self setIdentifierFetchRequest:nil];
    [self setFirstNameAlphabeticSortDescriptor:nil];
    [self setFirstLetterFirstNameAlphabeticSortDescriptor:nil];
    [self setDescriptorArrayForFirstNameAlphabeticSort:nil];
    [self setLastNameAlphabeticSortDescriptor:nil];
    [self setFirstLetterLastNameAlphabeticSortDescriptor:nil];
    [self setDescriptorArrayForLastNameAlphabeticSort:nil];
    [self setManualSortOrderSortDescriptor:nil];
    [self setDescriptorArrayForManualSortOrderSort:nil];
	[self setNameAlphabeticSortDescriptor:nil];
	[self setDescriptorArrayForNameAlphabeticSort:nil];
	[self setDefaultAction:nil];
	[self setFilterAction:nil];
	[self setProcessingAlertView:nil];
	[self setProgressAlertView:nil];
	[self setPresentingViewController:nil];
	[self setImportedUpgradeData:nil];
	[self setImportedFilePath:nil];
	[self setObsoleteDataController:nil];
    [self setActiveGradingPeriod:nil];
	[self setGradingPeriods:nil];
    [self setRestClient:nil];
    [self setRestFolderClient:nil];
    [self setDropboxUploadFilePath:nil];
	
	[super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

- (NSString *)documentsDirectory
{
	if (ivDocumentsDirectory == nil)
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		ivDocumentsDirectory = [[paths objectAtIndex:0] copy];
	}
	return ivDocumentsDirectory;
}

- (NSString *)libraryDirectory
{
	if (ivLibraryDirectory == nil)
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
		ivLibraryDirectory = [[paths objectAtIndex:0] copy];
	}
	return ivLibraryDirectory;
}

- (NSString *)libraryApplicationSupportDirectory
{
	if (ivLibraryApplicationSupportDirectory == nil)
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
		NSString *path = [paths objectAtIndex:0];
		
		NSFileManager *fileManager = [[NSFileManager alloc] init];
		
		if (![fileManager fileExistsAtPath:path])
		{
			[fileManager createDirectoryAtPathBTI:path
					  withIntermediateDirectories:YES
									   attributes:nil];
		}
		
		ivLibraryApplicationSupportDirectory = [path copy];
		
		[fileManager release], fileManager = nil;
	}
	return ivLibraryApplicationSupportDirectory;
}

- (NSString *)imageDirectory
{
	if (ivImageDirectory == nil)
	{
		NSString *path = [[self libraryApplicationSupportDirectory] stringByAppendingPathComponent:@"Images"];
		
		NSFileManager *fileManager = [[NSFileManager alloc] init];
		
		if (![fileManager fileExistsAtPath:path])
		{
			[fileManager createDirectoryAtPathBTI:path
					  withIntermediateDirectories:YES
									   attributes:nil];
		}
		
		ivImageDirectory = [path copy];
		
		[fileManager release], fileManager = nil;
	}
	return ivImageDirectory;
}

- (NSString *)audioDirectory
{
	if (ivAudioDirectory == nil)
	{
		NSString *path = [[self libraryApplicationSupportDirectory] stringByAppendingPathComponent:@"Audio"];
		
		NSFileManager *fileManager = [[NSFileManager alloc] init];
		
		if (![fileManager fileExistsAtPath:path])
		{
			[fileManager createDirectoryAtPathBTI:path
					  withIntermediateDirectories:YES
									   attributes:nil];
		}
		
		ivAudioDirectory = [path copy];
		
		[fileManager release], fileManager = nil;
	}
	return ivAudioDirectory;
}

- (NSString *)videoDirectory
{
	if (ivVideoDirectory == nil)
	{
		NSString *path = [[self libraryApplicationSupportDirectory] stringByAppendingPathComponent:@"Videos"];
		
		NSFileManager *fileManager = [[NSFileManager alloc] init];
		
		if (![fileManager fileExistsAtPath:path])
		{
			[fileManager createDirectoryAtPathBTI:path
					  withIntermediateDirectories:YES
									   attributes:nil];
		}
		
		ivVideoDirectory = [path copy];
		
		[fileManager release], fileManager = nil;
	}
	return ivVideoDirectory;
}

- (NSSortDescriptor *)firstNameAlphabeticSortDescriptor
{
	if (ivFirstNameAlphabeticSortDescriptor == nil)
	{
		ivFirstNameAlphabeticSortDescriptor = [[NSSortDescriptor alloc] initWithKey:kFIRST_NAME ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
	}
	return ivFirstNameAlphabeticSortDescriptor;
}

- (NSSortDescriptor *)firstLetterFirstNameAlphabeticSortDescriptor
{
	if (ivFirstLetterFirstNameAlphabeticSortDescriptor == nil)
	{
		ivFirstLetterFirstNameAlphabeticSortDescriptor = [[NSSortDescriptor alloc] initWithKey:kFIRST_LETTER_OF_FIRST_NAME ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
	}
	return ivFirstLetterFirstNameAlphabeticSortDescriptor;
}

- (NSArray *)descriptorArrayForFirstNameAlphabeticSort
{
	if (ivDescriptorArrayForFirstNameAlphabeticSort == nil)
	{
		ivDescriptorArrayForFirstNameAlphabeticSort = [[NSArray alloc] initWithObjects:[self firstLetterFirstNameAlphabeticSortDescriptor], [self firstNameAlphabeticSortDescriptor], nil];
	}
	return ivDescriptorArrayForFirstNameAlphabeticSort;
}

- (NSSortDescriptor *)lastNameAlphabeticSortDescriptor
{
	if (ivLastNameAlphabeticSortDescriptor == nil)
	{
		ivLastNameAlphabeticSortDescriptor = [[NSSortDescriptor alloc] initWithKey:kLAST_NAME ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
	}
	return ivLastNameAlphabeticSortDescriptor;
}

- (NSSortDescriptor *)firstLetterLastNameAlphabeticSortDescriptor
{
	if (ivFirstLetterLastNameAlphabeticSortDescriptor == nil)
	{
		ivFirstLetterLastNameAlphabeticSortDescriptor = [[NSSortDescriptor alloc] initWithKey:kFIRST_LETTER_OF_LAST_NAME ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
	}
	return ivFirstLetterLastNameAlphabeticSortDescriptor;
}

- (NSArray *)descriptorArrayForLastNameAlphabeticSort
{
	if (ivDescriptorArrayForLastNameAlphabeticSort == nil)
	{
		ivDescriptorArrayForLastNameAlphabeticSort = [[NSArray alloc] initWithObjects:[self firstLetterLastNameAlphabeticSortDescriptor], [self lastNameAlphabeticSortDescriptor], nil];
	}
	return ivDescriptorArrayForLastNameAlphabeticSort;
}

- (NSSortDescriptor *)manualSortOrderSortDescriptor
{
	if (ivManualSortOrderSortDescriptor == nil)
	{
		ivManualSortOrderSortDescriptor = [[NSSortDescriptor alloc] initWithKey:kSORT_ORDER ascending:YES selector:@selector(compare:)];
	}
	return ivManualSortOrderSortDescriptor;
}

- (NSArray *)descriptorArrayForManualSortOrderSort
{
	if (ivDescriptorArrayForManualSortOrderSort == nil)
	{
		ivDescriptorArrayForManualSortOrderSort = [[NSArray alloc] initWithObjects:[self manualSortOrderSortDescriptor], nil];
	}
	return ivDescriptorArrayForManualSortOrderSort;
}

- (NSSortDescriptor *)nameAlphabeticSortDescriptor
{
	if (ivNameAlphabeticSortDescriptor == nil)
	{
		ivNameAlphabeticSortDescriptor = [[NSSortDescriptor alloc] initWithKey:kNAME ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
	}
	return ivNameAlphabeticSortDescriptor;
}

- (NSArray *)descriptorArrayForNameAlphabeticSort
{
	if (ivDescriptorArrayForNameAlphabeticSort == nil)
	{
		ivDescriptorArrayForNameAlphabeticSort = [[NSArray alloc] initWithObjects:[self nameAlphabeticSortDescriptor], nil];
	}
	return ivDescriptorArrayForNameAlphabeticSort;
}

- (Action *)defaultAction
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if (ivDefaultAction == nil)
	{
		NSManagedObjectContext *context = [self managedObjectContext];
		
		NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
		[fetchRequest setEntity:[Action entityDescriptionInContextBTI:context]];
		
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", kDefaultActionIdentifier]];

		ivDefaultAction = [[[[self managedObjectContext] executeFetchRequestBTI:fetchRequest] lastObject] retain];
		
		if (ivDefaultAction == nil)
		{
			ivDefaultAction = [[Action managedObjectInContextBTI:context] retain];
			[ivDefaultAction setIdentifier:kDefaultActionIdentifier];
		}
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivDefaultAction;
}

- (Action *)filterAction
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivFilterAction == nil)
	{
		NSManagedObjectContext *context = [self managedObjectContext];
		
		NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
		[fetchRequest setEntity:[Action entityDescriptionInContextBTI:context]];
		
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", kPersonFilterActionIdentifier]];
		
		ivFilterAction = [[[[self managedObjectContext] executeFetchRequestBTI:fetchRequest] lastObject] retain];
		
		if (ivFilterAction == nil)
		{
			ivFilterAction = [[Action managedObjectInContextBTI:context] retain];
			[ivFilterAction setIdentifier:kPersonFilterActionIdentifier];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivFilterAction;
}

- (ObsoleteDataController *)obsoleteDataController
{
	if (ivObsoleteDataController == nil)
	{
		ivObsoleteDataController = [[ObsoleteDataController alloc] init];
	}
	return ivObsoleteDataController;
}

- (void)setActiveGradingPeriod:(GradingPeriod *)activeGradingPeriod
{
	[activeGradingPeriod setSelected:YES];
	
	if (ivActiveGradingPeriod != activeGradingPeriod)
	{
		[ivActiveGradingPeriod setSelected:NO];
		
		[activeGradingPeriod retain];
		[ivActiveGradingPeriod release];
		ivActiveGradingPeriod = activeGradingPeriod;
	}
}

- (NSMutableArray *)gradingPeriods
{
	if (ivGradingPeriods == nil)
	{
		ivGradingPeriods = [[NSMutableArray alloc] init];
	}
	return ivGradingPeriods;
}

- (ActionFieldInfo *)actionActionFieldInfoInMainContext
{
	if (ivActionActionFieldInfoInMainContext == nil)
	{
		ivActionActionFieldInfoInMainContext = [[self actionFieldInfoForIdentifier:kTermInfoIdentifierAction inContext:[self managedObjectContext]] retain];
	}
	
	return ivActionActionFieldInfoInMainContext;
}

- (ActionFieldInfo *)dateActionFieldInfoInMainContext
{
	if (ivDateActionFieldInfoInMainContext == nil)
	{
		ivDateActionFieldInfoInMainContext = [[self actionFieldInfoForIdentifier:kTermInfoIdentifierDate inContext:[self managedObjectContext]] retain];
	}
	
	return ivDateActionFieldInfoInMainContext;
}

- (NSArray *)allSortedActionFieldInfosInMainContext
{
	if (ivAllSortedActionFieldInfosInMainContext == nil)
	{
		NSManagedObjectContext *context = [self managedObjectContext];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		[fetchRequest setEntity:[ActionFieldInfo entityDescriptionInContextBTI:context]];
		
		[fetchRequest setSortDescriptors:[self descriptorArrayForManualSortOrderSort]];

		ivAllSortedActionFieldInfosInMainContext = [[NSArray arrayWithArray:[context executeFetchRequestBTI:fetchRequest]] retain];
		
		[fetchRequest release], fetchRequest = nil;
	}
	
	return ivAllSortedActionFieldInfosInMainContext;
}

#pragma mark Core Data

- (NSManagedObjectModel *)managedObjectModel
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivManagedObjectModel == nil)
	{
		NSString *path = [[NSBundle mainBundle] pathForResource:@"TeachersAssistant" ofType:@"momd"];
		NSLog(@"path is: %@", path);
		NSURL *url = [NSURL fileURLWithPath:path];
		ivManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivManagedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivPersistentStoreCoordinator == nil)
	{
		NSString *storePath = [[self libraryApplicationSupportDirectory] stringByAppendingPathComponent:kDatabaseFileName];
		
		// Only enable this if you want the database to be deleted each time
		// ************ ALERT ************* ALERT **************** ALERT ***************** ALERT ****************
		NSFileManager *fileManager = [NSFileManager defaultManager];
//		[fileManager removeItemAtPath:storePath error:nil];
		
		NSURL *storeURL = [NSURL fileURLWithPath:storePath];
		
		ivPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
		
		NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
								 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
								 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
		
		[ivPersistentStoreCoordinator addPersistentStoreWithTypeBTI:NSSQLiteStoreType
													  configuration:nil
																URL:storeURL
															options:options];
		
		// Encrypt file
		// https://nickharris.wordpress.com/2010/07/14/core-data-and-enterprise-iphone-applications-protecting-your-data/
		NSDictionary *fileAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
		
		[fileManager setAttributesBTI:fileAttributes
						 ofItemAtPath:storePath];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivPersistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
	if (ivManagedObjectContext == nil)
	{
		NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
		if (coordinator != nil)
		{
			ivManagedObjectContext = [[NSManagedObjectContext alloc] init];
			[ivManagedObjectContext setPersistentStoreCoordinator:coordinator];
		}
	}
	
	return ivManagedObjectContext;
}

- (NSPredicate *)identifierRootPredicate
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if (ivIdentifierRootPredicate == nil)
	{
		NSString *predicateFormat = [NSString stringWithFormat:@"identifier == $identifier"];
		ivIdentifierRootPredicate = [[NSPredicate predicateWithFormat:predicateFormat] retain];
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivIdentifierRootPredicate;
}

- (NSMutableDictionary *)identifierPredicateVariables
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if (ivIdentifierPredicateVariables == nil)
	{
		ivIdentifierPredicateVariables = [[NSMutableDictionary alloc] init];
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivIdentifierPredicateVariables;
}

- (NSFetchRequest *)identifierFetchRequest
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if (ivIdentifierFetchRequest == nil)
	{
		ivIdentifierFetchRequest = [[NSFetchRequest alloc] init];
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivIdentifierFetchRequest;
}

- (DBRestClient *)restClient
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    if (ivRestClient == nil)
	{
    	ivRestClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
		[ivRestClient setDelegate:self];
    }
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
    return ivRestClient;
}

- (DBRestClient *)restFolderClient
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    if (ivRestFolderClient == nil)
	{
    	ivRestFolderClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
		[ivRestFolderClient setDelegate:self];
    }
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
    return ivRestFolderClient;
}

#pragma mark - Initialization

- (id)init
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	self = [super init];
	if (self)
	{
#ifdef LITE_VERSION
		[self setLiteVersion:YES];
#else
		[self setLiteVersion:NO];
#endif
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			[self setIPadVersion:YES];
		}
		else
		{
			[self setIPadVersion:NO];
		}
		
		[self setImageCleanupEnabled:YES];
		
		NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
		
		[defaultCenter addObserver:self selector:@selector(didReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
		
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return self;
}

#pragma mark - Saving and Loading Methods

- (void)loadAllData
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	UIColorTransformer *transformer = [[[UIColorTransformer alloc] init] autorelease];
	[UIColorTransformer setValueTransformer:transformer forName:@"UIColorTransformerName"];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults btiInitializeDefaults];
    
	if (![userDefaults btiIsOldDataMigrated])
	{
		// There could be a partially-loaded database file.  Blow it away.
		NSString *storePath = [[self libraryApplicationSupportDirectory] stringByAppendingPathComponent:kDatabaseFileName];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		if ([fileManager fileExistsAtPath:storePath])
		{
			[self setManagedObjectModel:nil];
			[self setManagedObjectContext:nil];
			[self setPersistentStoreCoordinator:nil];
			
			[fileManager removeItemAtPathBTI:storePath];
		}
	}
	
	[self loadDefaultTermInfo];
	[self loadDefaultActionFieldInfo];
	[self loadDefaultColorInfo];
	[self loadDefaultGradingPeriods];
	[self loadDefaultClassPeriods];
	[self loadDefaultRandomizerInfo];
	
	//[self loadTestData];
	
	[self migratePersonOtherFieldToPersonDetailInfo];
	
	if (![userDefaults btiIsOldDataMigrated])
	{
		[self showProcessingAlertWithTitle:@"Migrating Data..."];

		[[self obsoleteDataController] performSelector:@selector(loadAllObsoleteData) withObject:nil afterDelay:0.3];
	}
	
	[self resetPointTotalsForAllPersons];
	[self resetGradingPeriodActionTotalForAllPersons];
	
	[[NSNotificationCenter defaultCenter] postNotificationNameOnMainThreadBTI:kDidImportDataNotification];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)saveAllData
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	[userDefaults btiSetGradingPeriods:[self gradingPeriods]];
	
	[userDefaults synchronize];
	
	[self saveCoreDataContext];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)saveCoreDataContext
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSManagedObjectContext *context = [self managedObjectContext];
	
	if ([context hasChanges])
	{
		[context saveBTI];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)saveManagedObjectContext:(NSManagedObjectContext *)context
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:context];
	
	[context saveBTI];
	
	[notificationCenter removeObserver:self name:NSManagedObjectContextDidSaveNotification object:context];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)migratePersonOtherFieldToPersonDetailInfo
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	TermInfo *otherTermInfo = [self termInfoForIdentifier:kTermInfoIdentifierOther];
	if (otherTermInfo == nil)
	{
		NSLog(@"<<< Leaving %s >>> EARLY - Already migrated", __PRETTY_FUNCTION__);
		return;
	}
	
	NSManagedObjectContext *context = [self managedObjectContext];
	
	PersonDetailInfo *detailInfo = [PersonDetailInfo managedObjectInContextBTI:context];
	[detailInfo setName:[self singularNameForTermInfo:otherTermInfo]];
	[detailInfo setSortOrder:[NSNumber numberWithInt:0]];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	[fetchRequest setEntity:[Person entityDescriptionInContextBTI:context]];
	
	NSArray *allPersons = [context executeFetchRequestBTI:fetchRequest];
	
	for (Person *person in allPersons)
	{
		NSString *otherValue = [person other];
		if ([otherValue length] > 0)
		{
			PersonDetailValue *detailValue = [PersonDetailValue managedObjectInContextBTI:context];
			[detailValue setName:otherValue];
			
			[detailValue setPersonDetailInfo:detailInfo];
			[detailValue setPerson:person];
		}
	}
	
	[context deleteObject:otherTermInfo];
	
	[self saveCoreDataContext];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Data Exchange Methods

- (NSString *)createBackupDataFile			// Return value is path to file
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self purgeUnusedMediaInfos];
	
	[self saveCoreDataContext];
	
	NSManagedObjectContext *context = [self managedObjectContext];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	// Convert native data to dictionary
	NSString *storePath = [[self libraryApplicationSupportDirectory] stringByAppendingPathComponent:kDatabaseFileName];
	
	NSData *databaseData = nil;
	
	if ([fileManager fileExistsAtPath:storePath])
	{
		databaseData = [NSData dataWithContentsOfFile:storePath];
	}
	
	NSMutableData *preferencesData = [NSMutableData data];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:preferencesData];
	[archiver encodeObject:[userDefaults attributesForBackup] forKey:kZipFilePreferencesKey];
	[archiver finishEncoding];
	[archiver release], archiver = nil;
	
	NSString *zipPath = [[self documentsDirectory] stringByAppendingPathComponent:[self validNativeFileName]];
	
	ZipFile *zipFile = [[ZipFile alloc] initWithFileName:zipPath mode:ZipFileModeCreate];
	
	NSString *modelFilePathInZipFile = [kZipFileContainerFolder stringByAppendingPathComponent:kZipFileModelFileName];
	ZipWriteStream *stream = [zipFile writeFileInZipWithName:modelFilePathInZipFile compressionLevel:ZipCompressionLevelBest];
	[stream writeData:databaseData];
	[stream finishedWriting];
	
	modelFilePathInZipFile = [kZipFileContainerFolder stringByAppendingPathComponent:kZipFilePreferencesFileName];
	stream = [zipFile writeFileInZipWithName:modelFilePathInZipFile compressionLevel:ZipCompressionLevelBest];
	[stream writeData:preferencesData];
	[stream finishedWriting];
	
	// TODO: Export audio
	// TODO: Export video
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[MediaInfo entityDescriptionInContextBTI:context]];
	NSArray *mediaInfos = [context executeFetchRequestBTI:fetchRequest];
	for (MediaInfo *mediaInfo in mediaInfos)
	{
		NSString *fileName = [mediaInfo fileName];
		
		if (fileName == nil)
			continue;
		
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		switch ([[mediaInfo type] intValue]) {
			case BTIMediaTypeImage:
			{
				NSString *sourcePath = [[self imageDirectory] stringByAppendingPathComponent:fileName];
				UIImage *image = [[UIImage alloc] initWithContentsOfFile:sourcePath];
				//				NSData *imageData = UIImagePNGRepresentation(image);
				
				// TODO: Verify that image quality doesn't constantly degrade
				NSData *imageData = UIImageJPEGRepresentation(image, kJPEGImageQuality);
				
				NSString *pathInZipFile = [[kZipFileContainerFolder stringByAppendingPathComponent:kZipFileImageFolder] stringByAppendingPathComponent:fileName];
				ZipWriteStream *stream = [zipFile writeFileInZipWithName:pathInZipFile compressionLevel:ZipCompressionLevelBest];
				[stream writeData:imageData];
				[stream finishedWriting];
				
				[image release], image = nil;
			}
				break;
			case BTIMediaTypeAudio:
			{
				
			}
				break;
			case BTIMediaTypeVideo:
			{
				
			}
				break;
			default:
				break;
		}
		
		[pool drain], pool = nil;
	}
	
	[fetchRequest release], fetchRequest = nil;
	
	[zipFile close];
	[zipFile release], zipFile = nil;
	
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:zipPath forKey:kNotificationFilePathKey];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kDidCreateExportFileNotification object:nil userInfo:userInfo];
	
	[self performSelector:@selector(hideProcessingAlert) withObject:nil afterDelay:0.0];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return zipPath;
}

- (NSURL *)urlForFullVersionExport
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *zipFilePath = [self createBackupDataFile];
	
	NSData *exportData = [[NSData alloc] initWithContentsOfFile:zipFilePath];
	
	NSString *attachment = [GTMBase64 stringByWebSafeEncodingData:exportData padded:YES];
	
	[exportData release], exportData = nil;
	
	[[NSFileManager defaultManager] removeItemAtPathBTI:zipFilePath];
	
	NSString *urlAsString = [[NSString stringWithFormat:@"%@://importData?", kNativeFileExtension] stringByAppendingString:attachment];
	
	NSURL *url = [[NSURL alloc] initWithString:urlAsString];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [url autorelease];
}

#pragma mark - Misc Methods

- (void)loadTestData
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSManagedObjectContext *context = [self managedObjectContext];
		
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity:[ClassPeriod entityDescriptionInContextBTI:context]];
	
	if ([context countForFetchRequestBTI:fetchRequest] > 0)
	{
		NSLog(@"<<< Leaving %s >>> EARLY - already loaded", __PRETTY_FUNCTION__);
		return;
	}
	
	
	// Classes
	
	NSInteger sortOrder = 0;
	
	ClassPeriod *classPeriod = [ClassPeriod managedObjectInContextBTI:context];
	[classPeriod setName:@"Math"];
	[classPeriod setSortOrder:[NSNumber numberWithInt:sortOrder]];
	
	sortOrder++;
	
	classPeriod = [ClassPeriod managedObjectInContextBTI:context];
	[classPeriod setName:@"English"];
	[classPeriod setSortOrder:[NSNumber numberWithInt:sortOrder]];
	
	sortOrder++;
	
	classPeriod = [ClassPeriod managedObjectInContextBTI:context];
	[classPeriod setName:@"Science"];
	[classPeriod setSortOrder:[NSNumber numberWithInt:sortOrder]];
	
	sortOrder++;
	
	// Students and parents
	
	Person *person1 = [Person managedObjectInContextBTI:context];
	[person1 setFirstName:@"Bobby"];
	[person1 setLastName:@"Smith"];
	[person1 addClassPeriodsObject:[self classPeriodWithName:@"Math"]];
	
	Parent *parent = [Parent managedObjectInContextBTI:context];
	[parent setSortOrder:[NSNumber numberWithInt:0]];
	[parent setName:@"Mrs. Smith"];
	
	[person1 addParentsObject:parent];
	
	parent = [Parent managedObjectInContextBTI:context];
	[parent setSortOrder:[NSNumber numberWithInt:1]];
	[parent setName:@"Mr. Smith"];
	
	[person1 addParentsObject:parent];
	
	Person *person2 = [Person managedObjectInContextBTI:context];
	[person2 setFirstName:@"Susie"];
	[person2 setLastName:@"Jones"];
	[person2 addClassPeriodsObject:[self classPeriodWithName:@"English"]];
	
	parent = [Parent managedObjectInContextBTI:context];
	[parent setSortOrder:[NSNumber numberWithInt:0]];
	[parent setName:@"Mr. Jones"];
	
	[person2 addParentsObject:parent];
	
	Person *person3 = [Person managedObjectInContextBTI:context];
	[person3 setFirstName:@"Katie"];
	[person3 setLastName:@"Hoffman"];
	[person3 addClassPeriodsObject:[self classPeriodWithName:@"Science"]];

	parent = [Parent managedObjectInContextBTI:context];
	[parent setSortOrder:[NSNumber numberWithInt:0]];
	[parent setName:@"Mrs. Hoffman"];
	
	[person3 addParentsObject:parent];
	
	// Actions
	
	ActionFieldInfo *actionFieldInfo = [self actionFieldInfoForIdentifier:kTermInfoIdentifierAction];
	ActionFieldInfo *dateFieldInfo = [self actionFieldInfoForIdentifier:kTermInfoIdentifierDate];
	ActionFieldInfo *descriptionFieldInfo = [self actionFieldInfoForIdentifier:kTermInfoIdentifierDescription];
	ActionFieldInfo *locationFieldInfo = [self actionFieldInfoForIdentifier:kTermInfoIdentifierLocation];
	ActionFieldInfo *teacherResponseFieldInfo = [self actionFieldInfoForIdentifier:kTermInfoIdentifierTeacherResponse];
		
	ActionValue *actionValue1 = [ActionValue managedObjectInContextBTI:context];
	
	PickerValue *pickerValue1 = [PickerValue managedObjectInContextBTI:context];
	[pickerValue1 setName:@"Late To Class"];
	[pickerValue1 setActionFieldInfo:actionFieldInfo];
	[pickerValue1 setSortOrder:[NSNumber numberWithInt:0]];
	
	PickerValue *pickerValue2 = [PickerValue managedObjectInContextBTI:context];
	[pickerValue2 setName:@"Made a loud noise"];
	[pickerValue2 setActionFieldInfo:actionFieldInfo];
	[pickerValue2 setSortOrder:[NSNumber numberWithInt:1]];
	
	PickerValue *pickerValue3 = [PickerValue managedObjectInContextBTI:context];
	[pickerValue3 setName:@"Didn't pay attention"];
	[pickerValue3 setActionFieldInfo:actionFieldInfo];
	[pickerValue3 setSortOrder:[NSNumber numberWithInt:2]];
	
	PickerValue *pickerValue4 = [PickerValue managedObjectInContextBTI:context];
	[pickerValue4 setName:@"Forgot homework"];
	[pickerValue4 setActionFieldInfo:actionFieldInfo];
	[pickerValue4 setSortOrder:[NSNumber numberWithInt:3]];
	
	[actionValue1 addPickerValuesObject:pickerValue1];
	[actionValue1 addPickerValuesObject:pickerValue2];
	
	[actionValue1 setActionFieldInfo:actionFieldInfo];
//	[actionValue1 setAction:action1];
	
	ActionValue *dateValue = [ActionValue managedObjectInContextBTI:context];
	[dateValue setDate:[NSDate date]];
	
	[dateValue setActionFieldInfo:dateFieldInfo];
//	[dateValue setAction:action1];
	
	ActionValue *descriptionValue = [ActionValue managedObjectInContextBTI:context];
	[descriptionValue setLongText:@"This is a long description"];
	
	[descriptionValue setActionFieldInfo:descriptionFieldInfo];
//	[descriptionValue setAction:action1];
	
//	[person1 addActionsObject:action1];
	
	PickerValue *pickerValue = [PickerValue managedObjectInContextBTI:context];
	[pickerValue setName:@"Location 1"];
	[pickerValue setActionFieldInfo:locationFieldInfo];
	[pickerValue setSortOrder:[NSNumber numberWithInt:0]];
	
	pickerValue = [PickerValue managedObjectInContextBTI:context];
	[pickerValue setName:@"Location 2"];
	[pickerValue setActionFieldInfo:locationFieldInfo];
	[pickerValue setSortOrder:[NSNumber numberWithInt:1]];
	
	pickerValue = [PickerValue managedObjectInContextBTI:context];
	[pickerValue setName:@"Location 3"];
	[pickerValue setActionFieldInfo:locationFieldInfo];
	[pickerValue setSortOrder:[NSNumber numberWithInt:2]];
	
	pickerValue = [PickerValue managedObjectInContextBTI:context];
	[pickerValue setName:@"Location 4"];
	[pickerValue setActionFieldInfo:locationFieldInfo];
	[pickerValue setSortOrder:[NSNumber numberWithInt:3]];
	
	pickerValue = [PickerValue managedObjectInContextBTI:context];
	[pickerValue setName:@"Location 5"];
	[pickerValue setActionFieldInfo:locationFieldInfo];
	[pickerValue setSortOrder:[NSNumber numberWithInt:4]];
	
	
	pickerValue = [PickerValue managedObjectInContextBTI:context];
	[pickerValue setName:@"Teacher Response 1"];
	[pickerValue setActionFieldInfo:teacherResponseFieldInfo];
	[pickerValue setSortOrder:[NSNumber numberWithInt:0]];
	
	pickerValue = [PickerValue managedObjectInContextBTI:context];
	[pickerValue setName:@"Teacher Response 2"];
	[pickerValue setActionFieldInfo:teacherResponseFieldInfo];
	[pickerValue setSortOrder:[NSNumber numberWithInt:1]];
	
	pickerValue = [PickerValue managedObjectInContextBTI:context];
	[pickerValue setName:@"Teacher Response 3"];
	[pickerValue setActionFieldInfo:teacherResponseFieldInfo];
	[pickerValue setSortOrder:[NSNumber numberWithInt:2]];
	
	pickerValue = [PickerValue managedObjectInContextBTI:context];
	[pickerValue setName:@"Teacher Response 4"];
	[pickerValue setActionFieldInfo:teacherResponseFieldInfo];
	[pickerValue setSortOrder:[NSNumber numberWithInt:3]];
	
	pickerValue = [PickerValue managedObjectInContextBTI:context];
	[pickerValue setName:@"Teacher Response 5"];
	[pickerValue setActionFieldInfo:teacherResponseFieldInfo];
	[pickerValue setSortOrder:[NSNumber numberWithInt:4]];
	
	
	[self saveCoreDataContext];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)deleteAllData
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSManagedObjectContext *context = [self managedObjectContext];
	
#warning Make sure all Core Data properties are cleared
	
	[self setDefaultAction:nil];
	[self setFilterAction:nil];
	[self setActionActionFieldInfoInMainContext:nil];
	[self setAllSortedActionFieldInfosInMainContext:nil];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	[fetchRequest setEntity:[MediaInfo entityDescriptionInContextBTI:context]];
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSArray *mediaInfos = [context executeFetchRequestBTI:fetchRequest];
	for (MediaInfo *mediaInfo in mediaInfos)
	{
		[self removeFileForMediaInfo:mediaInfo];
	}

//	[context saveBTI];
	
	[pool drain];
//	pool = [[NSAutoreleasePool alloc] init];
//	
//	[fetchRequest setEntity:[CommonAttributes entityDescriptionInContextBTI:context]];
//	[fetchRequest setIncludesPropertyValues:NO];
//	
//	NSArray *commonAttributes = [context executeFetchRequestBTI:fetchRequest];
//	for (CommonAttributes *attributes in commonAttributes)
//	{
//		[context deleteObject:attributes];
//	}
//	
//	[context saveBTI];
//		
//	[pool drain];
	
	[fetchRequest release], fetchRequest = nil;
	context = nil;
	
//	[[NSUserDefaults standardUserDefaults] btiSetImageFileNameIndex:1];
		
	NSString *storePath = [[self libraryApplicationSupportDirectory] stringByAppendingPathComponent:kDatabaseFileName];

	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	NSArray *persistentStores = [coordinator persistentStores];
	
	for (NSPersistentStore *store in persistentStores)
	{
		[coordinator removePersistentStoreBTI:store];
	}
		
	[self setManagedObjectContext:nil];
	[self setManagedObjectModel:nil];
	[self setPersistentStoreCoordinator:nil];
	
	[[NSFileManager defaultManager] removeItemAtPathBTI:storePath];
	
//	[self loadAllData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)deleteAllUserData
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[self deleteAllPersons];
	[self deleteAllActions];
	[self deleteAllPickerValues];
	[self deleteAllClassPeriods];

	[self saveCoreDataContext];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)deleteAllPersons
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	[fetchRequest setEntity:[Person entityDescriptionInContextBTI:context]];
	
	NSArray *persons = [context executeFetchRequestBTI:fetchRequest];
	
	for (Person *person in persons)
	{
		[self deletePerson:person];
	}
	
	[self saveCoreDataContext];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)deleteAllActions
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	[fetchRequest setEntity:[Action entityDescriptionInContextBTI:context]];
	
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"identifier == nil"]];
	
	NSArray *actions = [context executeFetchRequestBTI:fetchRequest];
	for (Action *action in actions)
	{
		[self deleteAction:action];
	}
	
	[self saveCoreDataContext];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)deleteAllPickerValues
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	[fetchRequest setEntity:[PickerValue entityDescriptionInContextBTI:context]];
	
	NSArray *pickerValues = [context executeFetchRequestBTI:fetchRequest];
	
	for (PickerValue *pickerValue in pickerValues)
	{
		[context deleteObject:pickerValue];
	}
	
	[self saveCoreDataContext];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)processImportedFileAtPath:(NSString *)path
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self setImportedFilePath:path];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:path])
	{
		[self setImportedFilePath:nil];
		
		NSLog(@"<<< Leaving %s >>> EARLY - No file at path", __PRETTY_FUNCTION__);
		return;
	}
	
	NSString *extension = [[path pathExtension] lowercaseString];
	
	RIButtonItem *cancelButton = [RIButtonItem item];
	[cancelButton setLabel:@"Cancel"];
	
	RIButtonItem *replaceButton = [RIButtonItem item];
	[replaceButton setLabel:@"Replace"];
	
	RIButtonItem *addButton = [RIButtonItem item];
	[addButton setLabel:@"Add"];
	
	if ([extension isEqualToString:kNativeFileExtension_OBSOLETE])
	{
		[replaceButton setLabel:@"Restore"];
		[replaceButton setAction:^{
			
			[self showProcessingAlertWithTitle:@"Loading..."];
			
			[self performSelector:@selector(restoreFromLegacyBackupFile) withObject:nil afterDelay:0.0];
		}];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restore Backup Data"
														message:@"Your current data will be replaced (deleted) with the data in this file. Do you wish to proceed?"
											   cancelButtonItem:cancelButton
											   otherButtonItems:replaceButton, nil];
		[alert show];
		[alert release], alert = nil;
	}
	else if ([extension isEqualToString:kNativeFileExtension])
	{
		[replaceButton setLabel:@"Restore"];
		[replaceButton setAction:^{
			
			[self showProgressAlertWithTitle:@"Loading..."];
			
			[self performSelectorInBackground:@selector(restoreFromModernBackupFile) withObject:nil];
		}];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restore Backup Data"
														message:@"Your current data will be replaced (deleted) with the data in this file. Do you wish to proceed?"
											   cancelButtonItem:cancelButton
											   otherButtonItems:replaceButton, nil];
		[alert show];
		[alert release], alert = nil;
	}
	else if ([extension isEqualToString:kCommaSeparatedFileExtension])
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:kShouldShowCSVImportNotification object:nil];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)addObsoleteDataFromImportedFileWithReplace:(NSNumber *)shouldReplace
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if ([shouldReplace boolValue])
	{
		[self deleteAllUserData];
		[self saveCoreDataContext];
	}

	[[self obsoleteDataController] setImportedFilePath:[self importedFilePath]];
	
	[[self obsoleteDataController] addDataFromImportedFile];
	
	[self setObsoleteDataController:nil];
	
	// Determine if the source file should be deleted
	BOOL shouldDelete = NO;
	NSArray *pathComponents = [[self importedFilePath] pathComponents];
	
	for (NSString *component in pathComponents)
	{
		if ([component isEqualToString:@"Inbox"])
			shouldDelete = YES;
	}
	
	if (shouldDelete)
	{
		[[NSFileManager defaultManager] removeItemAtPathBTI:[self importedFilePath]];
	}
	
	[self setImportedFilePath:nil];
	
	[self performSelector:@selector(hideProcessingAlert) withObject:nil afterDelay:0.0];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)restoreFromModernBackupFile			// .tappro format
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	__block CGFloat progress = 0.0;
	
	NSAutoreleasePool *mainPool = [[NSAutoreleasePool alloc] init];
	NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
	
	// Clear out existing Core Data information
	
	[self performSelectorOnMainThread:@selector(deleteAllData) withObject:nil waitUntilDone:YES];

	NSArray *persistentStores = [[self persistentStoreCoordinator] persistentStores];
	NSLog(@"persistentStores: %@", [persistentStores description]);
	
	for (NSPersistentStore *persistentStore in persistentStores)
	{
		[[self persistentStoreCoordinator] removePersistentStoreBTI:persistentStore];
	}
	
	[self setManagedObjectContext:nil];
    [self setManagedObjectModel:nil];
    [self setPersistentStoreCoordinator:nil];
	
	NSString *storePath = [[self libraryApplicationSupportDirectory] stringByAppendingPathComponent:kDatabaseFileName];
	
	if ([fileManager fileExistsAtPath:storePath])
	{
		[fileManager removeItemAtPathBTI:storePath];
	}
	
	// Load zip contents
	
	ZipFile *unzipFile = [[ZipFile alloc] initWithFileName:[self importedFilePath] mode:ZipFileModeUnzip];
	
	// Database
	
	NSString *modelDataName = [kZipFileContainerFolder stringByAppendingPathComponent:kZipFileAllModelsKey];
	[unzipFile locateFileInZip:modelDataName];
	
	FileInZipInfo *fileInfo = [unzipFile getCurrentFileInZipInfo];
	
	ZipReadStream *read = [unzipFile readCurrentFileInZip];
	NSMutableData *databaseData = [[NSMutableData alloc] initWithLength:[fileInfo length]];
	[read readDataWithBuffer:databaseData];
	[read finishedReading];
	
	[databaseData writeToFile:storePath atomically:YES];
	
	[databaseData release], databaseData = nil;
	
	progress = 0.1;
	[self performSelectorOnMainThread:@selector(updateProgressViewWithProgress:) withObject:[NSNumber numberWithFloat:progress] waitUntilDone:YES];
	
	NSString *preferencesName = [kZipFileContainerFolder stringByAppendingPathComponent:kZipFilePreferencesFileName];
	[unzipFile locateFileInZip:preferencesName];
	
	fileInfo = [unzipFile getCurrentFileInZipInfo];
	
	read = [unzipFile readCurrentFileInZip];
	
	NSMutableData *preferencesData = [[NSMutableData alloc] initWithLength:[fileInfo length]];
	[read readDataWithBuffer:preferencesData];
	[read finishedReading];
	
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:preferencesData];
	NSDictionary *preferencesDictionary = [unarchiver decodeObjectForKey:kZipFilePreferencesKey];
	[unarchiver release], unarchiver = nil;
	[preferencesData release], preferencesData = nil;
	
	[[NSUserDefaults standardUserDefaults] performSelectorOnMainThread:@selector(loadFromBackUpAttributes:) withObject:preferencesDictionary waitUntilDone:NO];
	
	progress = 0.15;
	[self performSelectorOnMainThread:@selector(updateProgressViewWithProgress:) withObject:[NSNumber numberWithFloat:progress] waitUntilDone:YES];
	
	// Extract media files
	
	NSArray *zipFileContents = [unzipFile listFileInZipInfos];
	
	// Remaining contents will be 80% of the total
	NSInteger numberOfFiles = [zipFileContents count];
	
	float progressIncrease = 0.1;
	if (numberOfFiles != 0)
	{
		progressIncrease = (80.0 / (float)numberOfFiles) / 100.0;
	}
	NSLog(@"progressIncrease: %f", progressIncrease);
	
	[zipFileContents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		FileInZipInfo *fileInfo = (FileInZipInfo *)obj;

		progress = progress + progressIncrease;
		[self performSelectorOnMainThread:@selector(updateProgressViewWithProgress:) withObject:[NSNumber numberWithFloat:progress] waitUntilDone:YES];
		
		NSString *fileNameInZip = [fileInfo name];
		NSLog(@"fileNameInZip is: %@", fileNameInZip);
		
		[unzipFile locateFileInZip:fileNameInZip];
		
		if ([fileNameInZip hasPrefix:[kZipFileContainerFolder stringByAppendingPathComponent:kZipFileAudioFolder]])
		{
			// Future TODO: Handle audio files
			return;
		}
		else if ([fileNameInZip hasPrefix:[kZipFileContainerFolder stringByAppendingPathComponent:kZipFileImageFolder]])
		{
			FileInZipInfo *imageFileInfo = [unzipFile getCurrentFileInZipInfo];
			
			ZipReadStream *read = [unzipFile readCurrentFileInZip];
			NSMutableData *imageData = [[NSMutableData alloc] initWithLength:[imageFileInfo length]];
			[read readDataWithBuffer:imageData];
			[read finishedReading];
			
			NSString *newPath = [[self imageDirectory] stringByAppendingPathComponent:[[fileNameInZip pathComponents] lastObject]];
			
			UIImage *image = [[UIImage alloc] initWithData:imageData];
			[imageData release], imageData = nil;
			
			NSData *newImageData = UIImageJPEGRepresentation(image, kJPEGImageQuality);
			
			[newImageData writeToFile:newPath atomically:YES];
			
			[image release], image = nil;
		}
		else if ([fileNameInZip hasPrefix:[kZipFileContainerFolder stringByAppendingPathComponent:kZipFileVideoFolder]])
		{
			// Future TODO: Handle audio files
			return;
		}	
	}];
	
	[unzipFile close];
	[unzipFile release], unzipFile = nil;
	
	[self performSelectorOnMainThread:@selector(updateProgressViewWithProgress:) withObject:[NSNumber numberWithFloat:0.95] waitUntilDone:YES];
	
	[self performSelectorOnMainThread:@selector(loadAllData) withObject:nil waitUntilDone:YES];
	
	[self setImportedFilePath:nil];
	
	[self performSelectorOnMainThread:@selector(updateProgressViewWithProgress:) withObject:[NSNumber numberWithFloat:1.0] waitUntilDone:YES];
	[self performSelectorOnMainThread:@selector(hideProgressAlert) withObject:nil waitUntilDone:NO];
		
	[mainPool drain], mainPool = nil;
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
	
	[[NSNotificationCenter defaultCenter] postNotificationNameOnMainThreadBTI:kDidImportDataNotification];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)restoreFromLegacyBackupFile			// .idiscipline format
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self deleteAllUserData];
	[self saveCoreDataContext];
		
	[[self obsoleteDataController] setImportedFilePath:[self importedFilePath]];
	
	[[self obsoleteDataController] addDataFromImportedFile];
	
	[self setObsoleteDataController:nil];
	
	// Determine if the source file should be deleted
	BOOL shouldDelete = NO;
	NSArray *pathComponents = [[self importedFilePath] pathComponents];
	
	for (NSString *component in pathComponents)
	{
		if ([component isEqualToString:@"Inbox"])
			shouldDelete = YES;
	}
	
	if (shouldDelete)
	{
		[[NSFileManager defaultManager] removeItemAtPathBTI:[self importedFilePath]];
	}
	
	[self setImportedFilePath:nil];
	
	[self performSelector:@selector(hideProcessingAlert) withObject:nil afterDelay:0.0];
	
	[[NSNotificationCenter defaultCenter] postNotificationNameOnMainThreadBTI:kDidImportDataNotification];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)showProcessingAlertWithTitle:(NSString *)title
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:@"\n"
												   delegate:nil
										  cancelButtonTitle:nil
										  otherButtonTitles:nil];
	
	UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

	[activityView setCenter:CGPointMake(139.0, 88.0)];
	[alert addSubview:activityView];
	[activityView startAnimating];
	[activityView release], activityView = nil;
	
	[self setProcessingAlertView:alert];
	
	[alert show];
	
	[alert release], alert = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)hideProcessingAlert
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if ([self processingAlertView] != nil)
	{
		[[self processingAlertView] dismissWithClickedButtonIndex:[[self processingAlertView] cancelButtonIndex] animated:YES];

		[self setProcessingAlertView:nil];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)showProgressAlertWithTitle:(NSString *)title
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:@"\n"
												   delegate:nil
										  cancelButtonTitle:nil
										  otherButtonTitles:nil];
	
	UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
	[progressView setFrame:CGRectMake(0.0, 0.0, 220.0, 9.0)];
	[progressView setCenter:CGPointMake(139.0, 88.0)];
	[progressView setProgress:0.0];
	[progressView setTag:999];
	
	[alert addSubview:progressView];
	
	[self setProgressAlertView:alert];
	
	[alert show];
	
	[progressView release], progressView = nil;
	[alert release], alert = nil;

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)updateProgressViewWithProgress:(NSNumber *)progress
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	UIProgressView *progressView = (UIProgressView *)[[self progressAlertView] viewWithTag:999];
	
	[progressView setProgress:[progress floatValue]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)hideProgressAlert
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if ([self progressAlertView] != nil)
	{
		[[self progressAlertView] dismissWithClickedButtonIndex:[[self progressAlertView] cancelButtonIndex] animated:YES];
		
		[self setProgressAlertView:nil];
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)saveBackgroundThreadManagedObjectContext:(NSManagedObjectContext *)backgroundContext
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:backgroundContext];
	
	[backgroundContext saveBTI];
	
	[notificationCenter removeObserver:self name:NSManagedObjectContextDidSaveNotification object:backgroundContext];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)sendSupportEmailFromViewController:(id)parentViewController
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[self setPresentingViewController:parentViewController];

	if ([MFMailComposeViewController canSendMail])
	{
		// Obtain version number
		NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
		NSString *versionNumber = [infoDictionary objectForKey:(NSString *)kCFBundleVersionKey];
		
		MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
		[mailController setMailComposeDelegate:self];
		
		NSString *versionType = nil;
		
		if ([self isLiteVersion])
		{
			versionType = @"Lite";
		}
		else
		{
			versionType = @"Pro";
		}
		
		[mailController setSubject:[NSString stringWithFormat:@"Teacher's Assistant %@ V%@", versionType, versionNumber]];
		
		[mailController setToRecipients:[NSArray arrayWithObject:@"chris@cleveriosapps.com"]];
		
		[parentViewController presentModalViewController:mailController animated:YES];
		
		[mailController release], mailController = nil;
	}
	else
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Mail Not Configured"
															message:@"Your device must be configured for sending email to use this feature. Please go to Settings > Mail to set up email."
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release], alertView = nil;;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - File Methods

- (NSString *)validImageFileName
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSString *fileNameToReturn = nil;

//	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSInteger documentCounter = 1;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyyMMddkkmmss"];
	
	BOOL isValidName = NO;
	
	while (!isValidName)
	{
		fileNameToReturn = [NSString stringWithFormat:@"%@_%d.jpg", [dateFormatter stringFromDate:[NSDate date]], documentCounter];
		documentCounter++;
		
		NSString *path = [[self imageDirectory] stringByAppendingPathComponent:fileNameToReturn];
		
		isValidName = ![fileManager fileExistsAtPath:path];
	}
	
	[dateFormatter release], dateFormatter = nil;
	
//	NSInteger fileIndex = [userDefaults btiImageFileNameIndex];
//	
//	while (fileNameToReturn == nil)
//	{
//		NSString *fileName = [NSString stringWithFormat:@"%d.jpg", fileIndex];
//		NSString *path = [[self imageDirectory] stringByAppendingPathComponent:fileName];
//		
//		if (![fileManager fileExistsAtPath:path])
//		{
//			fileNameToReturn = fileName;
//		}
//		fileIndex++;
//	}
//	
//	[userDefaults btiSetImageFileNameIndex:fileIndex];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return fileNameToReturn;
}

- (NSString *)validNativeFileName
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSDate *date = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEE_MMM_dd_yyyy"];
	NSString *dateString = [dateFormatter stringFromDate:date];
	
	NSString *fileNameToReturn = [NSString stringWithFormat:@"Data_%@.%@", dateString, kNativeFileExtension];
	
	NSString *path = [[self documentsDirectory] stringByAppendingPathComponent:fileNameToReturn];
	NSInteger counter = 2;
	
	BOOL badName = [fileManager fileExistsAtPath:path];
	
	while (badName)
	{
		fileNameToReturn = [NSString stringWithFormat:@"Data_%@_%d.%@", dateString, counter, kNativeFileExtension];
		
		path = [[self documentsDirectory] stringByAppendingPathComponent:fileNameToReturn];
		
		badName = [fileManager fileExistsAtPath:path];
		
		counter++;
	}

	[dateFormatter release], dateFormatter = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return fileNameToReturn;
}

#pragma mark - Notification Handlers

- (void)managedObjectContextDidSave:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSManagedObjectContext *context = [self managedObjectContext];
	
	// Merging changes causes the fetched results controller to update its results
	[context mergeChangesFromContextDidSaveNotification:notification];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)didReceiveMemoryWarning:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

    [self setDocumentsDirectory:nil];
    [self setLibraryDirectory:nil];
    [self setLibraryApplicationSupportDirectory:nil];
    [self setImageDirectory:nil];
    [self setAudioDirectory:nil];
    [self setVideoDirectory:nil];
	
    [self setIdentifierRootPredicate:nil];
    [self setIdentifierPredicateVariables:nil];
	[self setIdentifierFetchRequest:nil];
	
    [self setFirstNameAlphabeticSortDescriptor:nil];
    [self setFirstLetterFirstNameAlphabeticSortDescriptor:nil];
    [self setDescriptorArrayForFirstNameAlphabeticSort:nil];
    [self setLastNameAlphabeticSortDescriptor:nil];
    [self setFirstLetterLastNameAlphabeticSortDescriptor:nil];
    [self setDescriptorArrayForLastNameAlphabeticSort:nil];
    [self setManualSortOrderSortDescriptor:nil];
    [self setDescriptorArrayForManualSortOrderSort:nil];
    [self setNameAlphabeticSortDescriptor:nil];
    [self setDescriptorArrayForNameAlphabeticSort:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Person Methods

- (NSInteger)countOfPersons
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	[fetchRequest setEntity:[Person entityDescriptionInContextBTI:context]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [context countForFetchRequestBTI:fetchRequest];
}

- (void)deletePerson:(Person *)person
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[self removeMediaInfoForPerson:person];
	
	for (RandomizerInfo *randomizerInfo in [person randomizerInfos])
	{
		[[self managedObjectContext] deleteObject:randomizerInfo];
	}
	
	[[self managedObjectContext] deleteObject:person];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)deleteAllActionsInPerson:(Person *)person
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	for (Action *action in [person actions])
	{
		[self deleteAction:action];
	}

	[self saveCoreDataContext];
	
	[person calculateColorLabelPointTotal];
	[person calculateActionCountTotal];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)filterPersons
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSInteger pointFilterMode = [userDefaults pointFilterModeBTI];
	NSManagedObjectContext *context = [self managedObjectContext];
	
	[fetchRequest setEntity:[Person entityDescriptionInContextBTI:context]];
		
	NSArray *allPersons = [context executeFetchRequestBTI:fetchRequest];
	
	NSMutableSet *eligiblePeople = [NSMutableSet set];
	
	if ([[[self filterAction] actionValues] count] > 0)
	{
		[fetchRequest setEntity:[Action entityDescriptionInContextBTI:context]];
		
		NSArray *actions = [context executeFetchRequestBTI:fetchRequest];
		
		NSSet *matchingActions = [self actionsPassingFilterTestFromActions:[NSSet setWithArray:actions]];
		
		for (Action *action in matchingActions)
		{
			[eligiblePeople addObject:[action person]];
		}
	}
	else
	{
		[eligiblePeople addObjectsFromArray:allPersons];
	}
	
	if (pointFilterMode != BTIPointFilterModeOff)
	{
		NSMutableSet *actionMatchingPeople = [NSMutableSet setWithSet:eligiblePeople];
		[eligiblePeople removeAllObjects];
		
		NSNumber *referencePointValue = [userDefaults pointFilterValueBTI];
		CGFloat referenceValue = [referencePointValue floatValue];
		
		for (Person *person in actionMatchingPeople)
		{
			if ([person colorLabelPointTotal] == nil)
			{
//				[person calculateColorLabelPointTotal];
				
				[person setColorLabelPointTotal:[self colorLabelPointTotalForPerson:person inGradingPeriod:[self activeGradingPeriod]]];
			}
			
			NSNumber *pointValue = [person colorLabelPointTotal];
			CGFloat currentValue = [pointValue floatValue];
						
			switch (pointFilterMode) {
				case BTIPointFilterModeGreaterThan:
				{
					if (currentValue > referenceValue)
					{
						NSLog(@"Match greater than");
						[eligiblePeople addObject:person];
					}
				}
					break;
				case BTIPointFilterModeLessThan:
				{
					if (currentValue < referenceValue)
					{
						NSLog(@"Match less than");
						[eligiblePeople addObject:person];
					}
				}
					break;
				case BTIPointFilterModeEqualTo:
				{
					if (currentValue == referenceValue)
					{
						NSLog(@"Match equal");
						[eligiblePeople addObject:person];
					}
				}
					break;
				default:
					break;
			}
		}
		
		[context saveBTI];
	}
		
	NSMutableSet *nonEligiblePeople = [NSMutableSet setWithArray:allPersons];
	[nonEligiblePeople minusSet:eligiblePeople];
	
	[eligiblePeople makeObjectsPerformSelector:@selector(setMeetsFilterCriteria:) withObject:[NSNumber numberWithBool:YES]];
	[nonEligiblePeople makeObjectsPerformSelector:@selector(setMeetsFilterCriteria:) withObject:[NSNumber numberWithBool:NO]];
		
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

//- (void)addMediaInfoForPerson:(Person *)person
//{
//	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
//
////	if ([person thumbnailImage] != nil)
////	{
////		NSData *data = UIImagePNGRepresentation([person thumbnailImage]);
////		
////		NSString *fileName = [self validImageFileName];
////		NSString *path = [[self imageDirectory] stringByAppendingPathComponent:fileName];
////		
////		[data writeToFile:path atomically:YES];
////		
////		[person setThumbnailImageFileName:fileName];
////	}
//
//	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
//}

- (void)removeMediaInfoForPerson:(Person *)person;
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self deleteMediaInfo:[person largeThumbnailMediaInfo]];
	[self deleteMediaInfo:[person smallThumbnailMediaInfo]];
	
	[person setLargeThumbnailMediaInfo:nil];
	[person setSmallThumbnailMediaInfo:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (UIImage *)largePersonThumbnailImageFromImage:(UIImage *)originalImage
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	UIImage *imageToReturn = nil;

	CGSize originalImageSize = [originalImage size];
	CGFloat originalImageWidth = originalImageSize.width;
	CGFloat originalImageHeight = originalImageSize.height;
	
	CGFloat targetEdgeLength = 120.0;
	
	if ([TeachersAssistantAppDelegate isRetinaDisplay])
	{
		targetEdgeLength = targetEdgeLength * 2.0;
	}
	
	if ( (originalImageWidth <= targetEdgeLength) && (originalImageHeight <= targetEdgeLength) )
	{
		NSLog(@"<<< Leaving %s >>> EARLY - Image is smaller than target", __PRETTY_FUNCTION__);
		return originalImage;
	}
	
	// Redraw the image to remove the direction information
	
	CGRect newRect = CGRectMake(0.0, 0.0, originalImageWidth, originalImageHeight);
	UIGraphicsBeginImageContext(newRect.size);
	[originalImage drawInRect:newRect];
	originalImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	// Crop the image to be a square
	
	CGRect croppedFrame = CGRectZero;
	CGFloat originalSquareEdgeLength = 0.0;
	
	if (originalImageWidth > originalImageHeight)		// Landscape
	{
		CGFloat trimBorderWidth = (originalImageWidth - originalImageHeight) / 2.0;
		
		croppedFrame = CGRectMake(trimBorderWidth, 0.0, originalImageHeight, originalImageHeight);
		originalSquareEdgeLength = originalImageHeight;
	}
	else if (originalImageWidth < originalImageHeight)	// Portrait
	{
		CGFloat trimBorderWidth = (originalImageHeight - originalImageWidth) / 2.0;
		
		croppedFrame = CGRectMake(0.0, trimBorderWidth, originalImageWidth, originalImageWidth);
		originalSquareEdgeLength = originalImageWidth;
	}
	else												// Square
	{
		croppedFrame = CGRectMake(0.0, 0.0, originalImageWidth, originalImageWidth);
		originalSquareEdgeLength = originalImageWidth;
	}
	
	originalImage = [originalImage croppedImage:croppedFrame];
	
	// Resize the image
	
	CGFloat scaleRatio = targetEdgeLength / originalSquareEdgeLength;
	
	CGRect rect = CGRectMake(0.0, 0.0, scaleRatio * originalSquareEdgeLength, scaleRatio * originalSquareEdgeLength);
	
	UIGraphicsBeginImageContext(rect.size);
	[originalImage drawInRect:rect];
	imageToReturn = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return imageToReturn;
}

- (UIImage *)smallPersonThumbnailImageFromImage:(UIImage *)originalImage
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	UIImage *imageToReturn = originalImage;
	
	CGSize originalImageSize = [originalImage size];
	CGFloat originalImageWidth = originalImageSize.width;
	CGFloat originalImageHeight = originalImageSize.height;
	
	CGFloat targetEdgeLength = kThumbnailMaxHeightiPhone;
	
	if ([TeachersAssistantAppDelegate isRetinaDisplay])
	{
		targetEdgeLength = targetEdgeLength * 2.0;
	}
	
	if ( (originalImageWidth <= targetEdgeLength) && (originalImageHeight <= targetEdgeLength) )
	{
		NSLog(@"<<< Leaving %s >>> EARLY - Image is smaller than target", __PRETTY_FUNCTION__);
		return originalImage;
	}
	
	// Redraw the image to remove the direction information
	
	CGRect newRect = CGRectMake(0.0, 0.0, originalImageWidth, originalImageHeight);
	UIGraphicsBeginImageContext(newRect.size);
	[originalImage drawInRect:newRect];
	originalImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	// Crop the image to be a square
	
	CGRect croppedFrame = CGRectZero;
	CGFloat originalSquareEdgeLength = 0.0;
	
	if (originalImageWidth > originalImageHeight)	// Landscape
	{
		CGFloat trimBorderWidth = (originalImageWidth - originalImageHeight) / 2.0;
		
		croppedFrame = CGRectMake(trimBorderWidth, 0.0, originalImageHeight, originalImageHeight);
		originalSquareEdgeLength = originalImageHeight;
	}
	else if (originalImageWidth < originalImageHeight)	// Portrait
	{
		CGFloat trimBorderWidth = (originalImageHeight - originalImageWidth) / 2.0;
		
		croppedFrame = CGRectMake(0.0, trimBorderWidth, originalImageWidth, originalImageWidth);
		originalSquareEdgeLength = originalImageWidth;
	}
	else												// Square
	{
		croppedFrame = CGRectMake(0.0, 0.0, originalImageWidth, originalImageWidth);
		originalSquareEdgeLength = originalImageWidth;
	}
	
	originalImage = [originalImage croppedImage:croppedFrame];
	
	// Resize the image
	
	CGFloat scaleRatio = targetEdgeLength / originalSquareEdgeLength;
	
	CGRect rect = CGRectMake(0.0, 0.0, scaleRatio * originalSquareEdgeLength, scaleRatio * originalSquareEdgeLength);
	
	UIGraphicsBeginImageContext(rect.size);
	[originalImage drawInRect:rect];
	imageToReturn = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return imageToReturn;
}

- (void)resetPointTotalsForAllPersons
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity:[Person entityDescriptionInContextBTI:context]];
	
	NSArray *persons = [context executeFetchRequestBTI:fetchRequest];
	
	for (Person *person in persons)
	{
		[person setColorLabelPointTotal:nil];
	}
		
	[self saveCoreDataContext];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)resetGradingPeriodActionTotalForAllPersons
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity:[Person entityDescriptionInContextBTI:context]];
	
	NSArray *persons = [context executeFetchRequestBTI:fetchRequest];
	
	for (Person *person in persons)
	{
		[person setGradingPeriodActionTotal:nil];
	}
	
	[self saveCoreDataContext];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSNumber *)colorLabelPointTotalForPerson:(Person *)person
							inGradingPeriod:(GradingPeriod *)gradingPeriod
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
		
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSManagedObjectContext *scratchContext = [[NSManagedObjectContext alloc] init];
	[scratchContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
	
	Person *scratchPerson = (Person *)[scratchContext existingObjectWithID:[person objectID] error:nil];
	
	NSMutableSet *eligibleActions = [NSMutableSet set];

	for (Action *action in [scratchPerson actions])
	{
		if ([gradingPeriod isDateInRange:[action defaultSortDate]])
		{
			[eligibleActions addObject:action];
		}
	}

//	NSSet *eligibleActions = [scratchPerson actionsInGradingPeriod:gradingPeriod];
//	NSLog(@"eligibleActions is: %@", eligibleActions);

	NSNumber *totalToReturn = [[eligibleActions valueForKeyPath:@"@sum.colorLabelPointValue"] copy];
		
	[scratchContext release], scratchContext = nil;

	[pool drain];
	
//	NSLog(@"totalToReturn: %@", totalToReturn);
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [totalToReturn autorelease];
}

#pragma mark - Parent Methods

- (Parent *)makeParentInContext:(NSManagedObjectContext *)context
		  fromAddressBookPerson:(ABRecordRef)personRef
				   withFullName:(BOOL)isFullName
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	Parent *parentToReturn = nil;

	CFStringRef firstNameRef = ABRecordCopyValue(personRef, kABPersonFirstNameProperty);
	CFStringRef lastNameRef = ABRecordCopyValue(personRef, kABPersonLastNameProperty);
	
	ABMultiValueRef phoneMulti = ABRecordCopyValue(personRef, kABPersonPhoneProperty);
	
	NSString *homePhoneNumber = nil;
	NSString *workPhoneNumber = nil;
	NSString *mobilePhoneNumber = nil;
	NSString *otherPhoneNumber = nil;
	
	if (phoneMulti != NULL)
	{
		for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++)
		{
			CFStringRef labelRef = ABMultiValueCopyLabelAtIndex(phoneMulti, i);
			CFStringRef	valueRef = ABMultiValueCopyValueAtIndex(phoneMulti, i);
						
			if ( (labelRef != NULL) && (valueRef != NULL) )
			{
				if (CFStringCompare(labelRef, kABHomeLabel, 0) == kCFCompareEqualTo)
				{
					NSLog(@"Found the home phone number: %@", (NSString *)valueRef);
					homePhoneNumber = [[[(NSString *)valueRef copy] autorelease] stringByRemovingNull];
					if ([homePhoneNumber length] == 0)
					{
						homePhoneNumber = nil;
					}
				}
				else if (CFStringCompare(labelRef, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo)
				{
					NSLog(@"Found the mobile phone number: %@", (NSString *)valueRef);
					mobilePhoneNumber = [[[(NSString *)valueRef copy] autorelease] stringByRemovingNull];
					if ([mobilePhoneNumber length] == 0)
					{
						mobilePhoneNumber = nil;
					}
				}
				else if (CFStringCompare(labelRef, kABWorkLabel, 0) == kCFCompareEqualTo)
				{
					NSLog(@"Found the work phone number: %@", (NSString *)valueRef);
					workPhoneNumber = [[[(NSString *)valueRef copy] autorelease] stringByRemovingNull];
					if ([workPhoneNumber length] == 0)
					{
						workPhoneNumber = nil;
					}
				}
				else if (CFStringCompare(labelRef, kABOtherLabel, 0) == kCFCompareEqualTo)
				{
					NSLog(@"Found the other phone number: %@", (NSString *)valueRef);
					otherPhoneNumber = [[[(NSString *)valueRef copy] autorelease] stringByRemovingNull];
					if ([otherPhoneNumber length] == 0)
					{
						otherPhoneNumber = nil;
					}
				}
			}
			else if ( (labelRef == NULL) && (valueRef != NULL) )
			{
				NSLog(@"No label found, assigning value to Other: %@", (NSString *)valueRef);
				otherPhoneNumber = [[[(NSString *)valueRef copy] autorelease] stringByRemovingNull];
				if ([otherPhoneNumber length] == 0)
				{
					otherPhoneNumber = nil;
				}
			}
			
			if (labelRef != NULL)
				CFRelease(labelRef);
			if (valueRef != NULL)
				CFRelease(valueRef);
		}
	}
	
	ABMultiValueRef emailMulti = ABRecordCopyValue(personRef, kABPersonEmailProperty);
		
	NSString *homeEmail = nil;
	NSString *workEmail = nil;
	NSString *otherEmail = nil;
	
	if (emailMulti != NULL)
	{
		for (int i = 0; i < ABMultiValueGetCount(emailMulti); i++)
		{
			CFStringRef labelRef = ABMultiValueCopyLabelAtIndex(emailMulti, i);
			CFStringRef	valueRef = ABMultiValueCopyValueAtIndex(emailMulti, i);
						
			if ( (labelRef != NULL) && (valueRef != NULL) )
			{
				if (CFStringCompare(labelRef, kABHomeLabel, 0) == kCFCompareEqualTo)
				{
					NSLog(@"Found the home email: %@", (NSString *)valueRef);
					homeEmail = [[[(NSString *)valueRef copy] autorelease] stringByRemovingNull];
					if ([homeEmail length] == 0)
					{
						homeEmail = nil;
					}
				}
				else if (CFStringCompare(labelRef, kABWorkLabel, 0) == kCFCompareEqualTo)
				{
					NSLog(@"Found the work email: %@", (NSString *)valueRef);
					workEmail = [[[(NSString *)valueRef copy] autorelease] stringByRemovingNull];
					if ([workEmail length] == 0)
					{
						workEmail = nil;
					}
				}
				else if (CFStringCompare(labelRef, kABOtherLabel, 0) == kCFCompareEqualTo)
				{
					NSLog(@"Found the other email: %@", (NSString *)valueRef);
					otherEmail = [[[(NSString *)valueRef copy] autorelease] stringByRemovingNull];
					if ([otherEmail length] == 0)
					{
						otherEmail = nil;
					}
				}
			}
			else if ( (labelRef == NULL) && (valueRef != NULL) )
			{
				NSLog(@"No label found, assigning value to Other: %@", (NSString *)valueRef);
				otherEmail = [[[(NSString *)valueRef copy] autorelease] stringByRemovingNull];
				if ([otherEmail length] == 0)
				{
					otherEmail = nil;
				}
			}
			
			if (labelRef != NULL)
				CFRelease(labelRef);
			if (valueRef != NULL)
				CFRelease(valueRef);
		}
	}
	
	BOOL thereIsAPhoneNumber = ( (homePhoneNumber != nil) || (workPhoneNumber != nil) || (mobilePhoneNumber != nil) || (otherPhoneNumber != nil) || (homeEmail != nil) );
	BOOL thereIsAnEmail = ( (homeEmail != nil) || (workEmail != nil) || (otherEmail != nil) );
	
	if (isFullName)			// Full name means create a parent no matter what
	{
		parentToReturn = [Parent managedObjectInContextBTI:context];
		[parentToReturn setName:[[NSString stringWithFormat:@"%@ %@", (NSString *)firstNameRef, (NSString *)lastNameRef] stringByRemovingNull]];
	}
	else					// Not full name means create a parent only if there is phone and/or email data, and use only the last name
	{
		if (thereIsAPhoneNumber || thereIsAnEmail)
		{
			parentToReturn = [Parent managedObjectInContextBTI:context];
			[parentToReturn setName:[(NSString *)lastNameRef stringByRemovingNull]];
		}
	}
	
	NSInteger sortOrder = 0;
	
	if (homePhoneNumber != nil)
	{
		PhoneNumber *phoneNumber = [PhoneNumber managedObjectInContextBTI:context];
		[phoneNumber setType:kContactInfoTypeHome];
		[phoneNumber setValue:homePhoneNumber];
		[phoneNumber setSortOrder:[NSNumber numberWithInt:sortOrder]];
		sortOrder++;
		
		[parentToReturn addPhoneNumbersObject:phoneNumber];
	}
	
	if (mobilePhoneNumber != nil)
	{
		PhoneNumber *phoneNumber = [PhoneNumber managedObjectInContextBTI:context];
		[phoneNumber setType:kContactInfoTypeMobile];
		[phoneNumber setValue:mobilePhoneNumber];
		[phoneNumber setSortOrder:[NSNumber numberWithInt:sortOrder]];
		sortOrder++;
		
		[parentToReturn addPhoneNumbersObject:phoneNumber];
	}
	
	if (otherPhoneNumber != nil)
	{
		PhoneNumber *phoneNumber = [PhoneNumber managedObjectInContextBTI:context];
		[phoneNumber setType:kContactInfoTypeOther];
		[phoneNumber setValue:otherPhoneNumber];
		[phoneNumber setSortOrder:[NSNumber numberWithInt:sortOrder]];
		sortOrder++;
		
		[parentToReturn addPhoneNumbersObject:phoneNumber];
	}
	
	if (workPhoneNumber != nil)
	{
		PhoneNumber *phoneNumber = [PhoneNumber managedObjectInContextBTI:context];
		[phoneNumber setType:kContactInfoTypeWork];
		[phoneNumber setValue:workPhoneNumber];
		[phoneNumber setSortOrder:[NSNumber numberWithInt:sortOrder]];
		sortOrder++;
		
		[parentToReturn addPhoneNumbersObject:phoneNumber];
	}
	
	sortOrder = 0;
	
	if (homeEmail != nil)
	{
		EmailAddress *emailAddress = [EmailAddress managedObjectInContextBTI:context];
		[emailAddress setType:kContactInfoTypeHome];
		[emailAddress setValue:homeEmail];
		[emailAddress setSortOrder:[NSNumber numberWithInt:sortOrder]];
		sortOrder++;
		
		[parentToReturn addEmailAddressesObject:emailAddress];
	}
	
	if (otherEmail != nil)
	{
		EmailAddress *emailAddress = [EmailAddress managedObjectInContextBTI:context];
		[emailAddress setType:kContactInfoTypeOther];
		[emailAddress setValue:otherEmail];
		[emailAddress setSortOrder:[NSNumber numberWithInt:sortOrder]];
		sortOrder++;
		
		[parentToReturn addEmailAddressesObject:emailAddress];
	}
	
	if (workEmail != nil)
	{
		EmailAddress *emailAddress = [EmailAddress managedObjectInContextBTI:context];
		[emailAddress setType:kContactInfoTypeWork];
		[emailAddress setValue:workEmail];
		[emailAddress setSortOrder:[NSNumber numberWithInt:sortOrder]];
		sortOrder++;
		
		[parentToReturn addEmailAddressesObject:emailAddress];
	}

	// Releasing a NULL object - which can happen if there is no data in the field - causes a crash
	if (firstNameRef != NULL)
		CFRelease(firstNameRef);
	if (lastNameRef != NULL)
		CFRelease(lastNameRef);
	if (phoneMulti != NULL)
		CFRelease(phoneMulti);
	if (emailMulti != NULL)
		CFRelease(emailMulti);
		
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return parentToReturn;
}

#pragma mark - ClassPeriod Methods

- (NSInteger)countOfClassPeriods
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	[fetchRequest setEntity:[ClassPeriod entityDescriptionInContextBTI:context]];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"sortOrder >= %@", [NSNumber numberWithInt:0]]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [context countForFetchRequestBTI:fetchRequest];
}

- (void)deleteAllClassPeriods
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	[fetchRequest setEntity:[ClassPeriod entityDescriptionInContextBTI:context]];
	
	NSArray *classes = [context executeFetchRequestBTI:fetchRequest];
	
	for (ClassPeriod *class in classes)
	{
		[context deleteObject:class];
	}
	
	[self loadDefaultClassPeriods];
	
	[self saveCoreDataContext];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (ClassPeriod *)classPeriodWithName:(NSString *)name;
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	[fetchRequest setEntity:[ClassPeriod entityDescriptionInContextBTI:context]];
	
	// Case-insensitive search of the name property
	NSExpression *nameExpression = [NSExpression expressionForKeyPath:@"name"];
	NSExpression *nameValue = [NSExpression expressionForConstantValue:name];
	NSPredicate *predicate = [NSComparisonPredicate predicateWithLeftExpression:nameExpression
																rightExpression:nameValue
																	   modifier:NSDirectPredicateModifier
																		   type:NSEqualToPredicateOperatorType
																		options:NSCaseInsensitivePredicateOption];
	[fetchRequest setPredicate:predicate];
	
	ClassPeriod *classPeriod = [[context executeFetchRequestBTI:fetchRequest] lastObject];
	
	if ( (classPeriod == nil) && ([name isEqualToString:kAllStudentsClassName]) )
	{
		classPeriod = [ClassPeriod managedObjectInContextBTI:context];
		[classPeriod setName:kAllStudentsClassName];
		[classPeriod setSortOrder:[NSNumber numberWithInt:-1]];
		
		[self saveCoreDataContext];
	}
	
	[fetchRequest release], fetchRequest = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return classPeriod;
}

- (void)loadDefaultClassPeriods
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSManagedObjectContext *context = [self managedObjectContext];
	
	ClassPeriod *allStudentsClass = [self classPeriodWithName:kAllStudentsClassName];
	if (allStudentsClass == nil)
	{
		allStudentsClass = [ClassPeriod managedObjectInContextBTI:context];
		[allStudentsClass setName:kAllStudentsClassName];
		[allStudentsClass setSortOrder:[NSNumber numberWithInt:-1]];
		
		[self saveCoreDataContext];
	}

	// Pre-populate randomizer data if necessary
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	[fetchRequest setEntity:[ClassPeriod entityDescriptionInContextBTI:context]];
	
	NSArray *classes = [[self managedObjectContext] executeFetchRequestBTI:fetchRequest];
	
	for (ClassPeriod *class in classes)
	{
        if ([class groupSize] == nil)
		{
			[class setGroupSize:[NSNumber numberWithInt:1]];
		}
		
		if ([class randomizerMode] == nil)
		{
			[class setRandomizerMode:BTIRandomizerModeSorted];
		}
	}
	
	[self saveCoreDataContext];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Action Methods

- (void)deleteAction:(Action *)action
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[NSNotificationCenter defaultCenter] postNotificationName:kDidDeleteActionNotification object:action];
	
	for (ActionValue *actionValue in [action actionValues])
	{
		[self removeFileForMediaInfo:[actionValue imageMediaInfo]];
		[self removeFileForMediaInfo:[actionValue thumbnailImageMediaInfo]];
		[self removeFileForMediaInfo:[actionValue audioMediaInfo]];
		[self removeFileForMediaInfo:[actionValue videoMediaInfo]];
	}
	
	[[self managedObjectContext] deleteObject:action];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSFetchRequest *)actionFetchRequestForPerson:(Person *)person
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];

	[fetchRequest setEntity:[Action entityDescriptionInContextBTI:[self managedObjectContext]]];
	
	NSLog(@"activeGradingPeriod is: %@", [self activeGradingPeriod]);
	NSDate *startDate = [[self activeGradingPeriod] startDate];
	NSDate *endDate = [[self activeGradingPeriod] endDate];
	
	NSPredicate *personPredicate = [NSPredicate predicateWithFormat:@"(person == %@)", person];
	NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"(meetsFilterCriteria == %@)", [NSNumber numberWithBool:YES]];
	NSPredicate *startDatePredicate = [NSPredicate predicateWithFormat:@"(defaultSortDate >= %@)", startDate];
	NSPredicate *endDatePredicate = [NSPredicate predicateWithFormat:@"(defaultSortDate <= %@)", endDate];
	
	[fetchRequest setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:personPredicate, filterPredicate, startDatePredicate, endDatePredicate, nil]]];
	
	NSSortDescriptor *dateDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"defaultSortDate" ascending:[[NSUserDefaults standardUserDefaults] isActionsSortAscendingBTI]] autorelease];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:dateDescriptor]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return fetchRequest;
}

- (void)filterActions:(NSSet *)actions
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSSet *matchingActions = [self actionsPassingFilterTestFromActions:actions];
	
	NSMutableSet *nonMatchingActions = [NSMutableSet setWithSet:actions];
	[nonMatchingActions minusSet:matchingActions];
		
	[matchingActions makeObjectsPerformSelector:@selector(setMeetsFilterCriteria:) withObject:[NSNumber numberWithBool:YES]];
	[nonMatchingActions makeObjectsPerformSelector:@selector(setMeetsFilterCriteria:) withObject:[NSNumber numberWithBool:NO]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSSet *)actionsPassingFilterTestFromActions:(NSSet *)actions
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSSet *matchingActions = [actions objectsPassingTest:^BOOL(Action *action, BOOL *stop) {
		
		if ([action isEqual:[self filterAction]])
			return NO;
		
		if ([action isEqual:[self defaultAction]])
			return NO;
		
		for (ActionValue *filterActionValue in [[self filterAction] actionValues])
		{
			ActionFieldInfo *filterActionFieldInfo = [filterActionValue actionFieldInfo];
			ActionValue *actionValue = [action actionValueForActionFieldInfo:filterActionFieldInfo];

			NSInteger fieldType = [[filterActionFieldInfo type] integerValue];
			
			if (actionValue == nil)
			{
				if (fieldType == BTIActionFieldValueTypeBoolean)
				{
					BOOL filterBoolValue = [[filterActionValue boolean] boolValue];
					return !filterBoolValue;
				}
				else if (fieldType == BTIActionFieldValueTypeDate)
				{
//					ActionFieldInfo *dateFieldInfo = [self actionFieldInfoForIdentifier:kTermInfoIdentifierDate];
					ActionFieldInfo *dateFieldInfo = [self dateActionFieldInfoInContext:[filterActionValue managedObjectContext]];

					if ([dateFieldInfo isEqual:filterActionFieldInfo])
					{
						// This is the default date field, but there is no action value.  Possibly the action was created
						// when the date field was turned off.  In this case, use the dateCreated instead.
						
						NSDate *fromDate = [filterActionValue filterFromDate];
						NSDate *toDate = [filterActionValue filterToDate];
						
						NSDate *date = [action dateCreated];
						
						return !( ([fromDate timeIntervalSinceDate:date] > 0) || ([date timeIntervalSinceDate:toDate] > 0) );
					}
				}
				else
				{
					return NO;
				}
			}
			
			
			// If a test doesn't pass, return NO to go to the next action.
			// If the action lives until the end of the method, then it meets the criteria
			switch (fieldType) {
				case BTIActionFieldValueTypeDate:
				{
					if ([actionValue date] == nil)
						return NO;
					
					NSDate *fromDate = [filterActionValue filterFromDate];
					NSDate *toDate = [filterActionValue filterToDate];
					
					NSDate *date = [actionValue date];
					
					if ( ([fromDate timeIntervalSinceDate:date] > 0) || ([date timeIntervalSinceDate:toDate] > 0) )
					{
						return NO;
					}
				}
					break;
				case BTIActionFieldValueTypePicker:
				{
					if ([actionValue pickerValues] == nil)
						return NO;
					
					if (![[filterActionValue pickerValues] isSubsetOfSet:[actionValue pickerValues]])
						return NO;
				}
					break;
				case BTIActionFieldValueTypeBoolean:
				{
					if ([actionValue boolean] == nil)			// Treat nil as equivalent to NO
					{
						BOOL filterBoolValue = [[filterActionValue boolean] boolValue];
						if (filterBoolValue)
							return NO;
						else
							return YES;
					}
					
					if (![[filterActionValue boolean] isEqualToNumber:[actionValue boolean]])
						return NO;
				}
					break;
				case BTIActionFieldValueTypeColor:
				{
					if ([actionValue colorInfo] == nil)
						return NO;
					
					if ([[actionValue colorInfo] color] == nil)
						return NO;
					
					if (![[[filterActionValue colorInfo] color] isEqual:[[actionValue colorInfo] color]])
						return NO;
				}
					break;
				default:
					break;
			}
		}
		
		// Object passed all filters
		return YES;
	}];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return matchingActions;
}

#pragma mark - Action Value Methods

- (UIImage *)removeOrientationFromImage:(UIImage *)originalImage
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	UIImage *imageToReturn = nil;
	
	CGSize originalImageSize = [originalImage size];
	CGFloat originalImageWidth = originalImageSize.width;
	CGFloat originalImageHeight = originalImageSize.height;
	
	CGRect newRect = CGRectMake(0.0, 0.0, originalImageWidth, originalImageHeight);
	UIGraphicsBeginImageContext(newRect.size);
	[originalImage drawInRect:newRect];
	imageToReturn = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return imageToReturn;
}

- (UIImage *)largeActionValueImageFromImage:(UIImage *)originalImage
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	UIImage *imageToReturn = nil;
	
	CGSize originalImageSize = [originalImage size];
	CGFloat originalImageWidth = originalImageSize.width;
	CGFloat originalImageHeight = originalImageSize.height;
	
	CGFloat maximumEdgeLength = 480.0;
	if ([self isIPadVersion])
	{
		maximumEdgeLength = 1024.0;
	}
	
	if ([TeachersAssistantAppDelegate isRetinaDisplay])
	{
		maximumEdgeLength = maximumEdgeLength * 2.0;
	}
	
	if ( (originalImageWidth <= maximumEdgeLength) && (originalImageHeight <= maximumEdgeLength) )
	{
		NSLog(@"<<< Leaving %s >>> EARLY - Image is smaller than target", __PRETTY_FUNCTION__);
		return originalImage;
	}
	
	// Redraw the image to remove the direction information
	
	originalImage = [self removeOrientationFromImage:originalImage];
	
	// Resize the image
	
	CGFloat scaleRatio = 1.0;
	
	if (originalImageHeight > originalImageWidth)			// Portrait
	{
		scaleRatio = maximumEdgeLength / originalImageHeight;
	}
	else		// Landscape or square
	{
		scaleRatio = maximumEdgeLength / originalImageWidth;
	}
	
	CGRect rect = CGRectMake(0.0, 0.0, scaleRatio * originalImageWidth, scaleRatio * originalImageHeight);
	
	UIGraphicsBeginImageContext(rect.size);
	[originalImage drawInRect:rect];
	imageToReturn = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return imageToReturn;
}

- (UIImage *)smallActionValueImageFromImage:(UIImage *)originalImage
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	UIImage *imageToReturn = nil;
	
	CGSize originalImageSize = [originalImage size];
	CGFloat originalImageWidth = originalImageSize.width;
	CGFloat originalImageHeight = originalImageSize.height;
	
	CGFloat maximumHeight = kThumbnailMaxHeightiPhone;
	CGFloat maximumWidth = kThumbnailMaxHeightiPhone;
	
	if ([self isIPadVersion])
	{
		maximumHeight = kThumbnailMaxHeightiPad;
		maximumWidth = kThumbnailMaxHeightiPad * 2.0;
	}
	
	if ([TeachersAssistantAppDelegate isRetinaDisplay])
	{
		maximumHeight = maximumHeight * 2.0;
	}
	
	if ( (originalImageWidth <= maximumWidth) && (originalImageHeight <= maximumHeight) )
	{
		NSLog(@"<<< Leaving %s >>> EARLY - Image is smaller than target", __PRETTY_FUNCTION__);
		return originalImage;
	}
	
	// Redraw the image to remove the direction information
	
	originalImage = [self removeOrientationFromImage:originalImage];
	
	// Resize the image
	
	CGFloat scaleRatio = 1.0;
	
	if (originalImageHeight > originalImageWidth)			// Portrait
	{
		scaleRatio = maximumHeight / originalImageHeight;
	}
	else		// Landscape or square
	{
		scaleRatio = maximumWidth / originalImageWidth;
	}
	
	CGRect rect = CGRectMake(0.0, 0.0, scaleRatio * originalImageWidth, scaleRatio * originalImageHeight);
	
	UIGraphicsBeginImageContext(rect.size);
	[originalImage drawInRect:rect];
	imageToReturn = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return imageToReturn;
}

#pragma mark - ActionFieldInfo Methods

- (void)loadDefaultActionFieldInfo
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSInteger sortOrder = 0;
	
	ActionFieldInfo *actionFieldInfo = [self actionFieldInfoForIdentifier:kTermInfoIdentifierAction];
	if (actionFieldInfo == nil)
	{
		actionFieldInfo = [ActionFieldInfo managedObjectInContextBTI:context];
		[actionFieldInfo setIdentifier:kTermInfoIdentifierAction];
		[actionFieldInfo setTermInfo:[self termInfoForIdentifier:[actionFieldInfo identifier]]];
		[actionFieldInfo setIsUserCreated:[NSNumber numberWithBool:NO]];
		[actionFieldInfo setIsHidden:[NSNumber numberWithBool:NO]];
		[actionFieldInfo setType:[NSNumber numberWithInt:BTIActionFieldValueTypePicker]];
		[actionFieldInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
	}
	
	sortOrder++;
	
	ActionFieldInfo *dateFieldInfo = [self actionFieldInfoForIdentifier:kTermInfoIdentifierDate];
	if (dateFieldInfo == nil)
	{
		dateFieldInfo = [ActionFieldInfo managedObjectInContextBTI:context];
		[dateFieldInfo setIdentifier:kTermInfoIdentifierDate];
		[dateFieldInfo setTermInfo:[self termInfoForIdentifier:[dateFieldInfo identifier]]];
		[dateFieldInfo setIsUserCreated:[NSNumber numberWithBool:NO]];
		[dateFieldInfo setIsHidden:[NSNumber numberWithBool:NO]];
		[dateFieldInfo setType:[NSNumber numberWithInt:BTIActionFieldValueTypeDate]];
		[dateFieldInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
	}
	
	sortOrder++;
	
	ActionFieldInfo *teacherResponseFieldInfo = [self actionFieldInfoForIdentifier:kTermInfoIdentifierTeacherResponse];
	if (teacherResponseFieldInfo == nil)
	{
		teacherResponseFieldInfo = [ActionFieldInfo managedObjectInContextBTI:context];
		[teacherResponseFieldInfo setIdentifier:kTermInfoIdentifierTeacherResponse];
		[teacherResponseFieldInfo setTermInfo:[self termInfoForIdentifier:[teacherResponseFieldInfo identifier]]];
		[teacherResponseFieldInfo setIsUserCreated:[NSNumber numberWithBool:NO]];
		[teacherResponseFieldInfo setIsHidden:[NSNumber numberWithBool:NO]];
		[teacherResponseFieldInfo setType:[NSNumber numberWithInt:BTIActionFieldValueTypePicker]];
		[teacherResponseFieldInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
	}
	
	sortOrder++;
	
	ActionFieldInfo *locationFieldInfo = [self actionFieldInfoForIdentifier:kTermInfoIdentifierLocation];
	if (locationFieldInfo == nil)
	{
		locationFieldInfo = [ActionFieldInfo managedObjectInContextBTI:context];
		[locationFieldInfo setIdentifier:kTermInfoIdentifierLocation];
		[locationFieldInfo setTermInfo:[self termInfoForIdentifier:[locationFieldInfo identifier]]];
		[locationFieldInfo setIsUserCreated:[NSNumber numberWithBool:NO]];
		[locationFieldInfo setIsHidden:[NSNumber numberWithBool:NO]];
		[locationFieldInfo setType:[NSNumber numberWithInt:BTIActionFieldValueTypePicker]];
		[locationFieldInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
	}
	
	sortOrder++;
	
	ActionFieldInfo *optionalFieldInfo = [self actionFieldInfoForIdentifier:kTermInfoIdentifierOptional];
	if (optionalFieldInfo == nil)
	{
		optionalFieldInfo = [ActionFieldInfo managedObjectInContextBTI:context];
		[optionalFieldInfo setIdentifier:kTermInfoIdentifierOptional];
		[optionalFieldInfo setTermInfo:[self termInfoForIdentifier:[optionalFieldInfo identifier]]];
		[optionalFieldInfo setIsUserCreated:[NSNumber numberWithBool:NO]];
		[optionalFieldInfo setIsHidden:[NSNumber numberWithBool:NO]];
		[optionalFieldInfo setType:[NSNumber numberWithInt:BTIActionFieldValueTypePicker]];
		[optionalFieldInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
	}
	
	sortOrder++;
	
	ActionFieldInfo *responseOccurredFieldInfo = [self actionFieldInfoForIdentifier:kTermInfoIdentifierTeacherResponseOccurred];
	if (responseOccurredFieldInfo == nil)
	{
		responseOccurredFieldInfo = [ActionFieldInfo managedObjectInContextBTI:context];
		[responseOccurredFieldInfo setIdentifier:kTermInfoIdentifierTeacherResponseOccurred];
		[responseOccurredFieldInfo setTermInfo:[self termInfoForIdentifier:[responseOccurredFieldInfo identifier]]];
		[responseOccurredFieldInfo setIsUserCreated:[NSNumber numberWithBool:NO]];
		[responseOccurredFieldInfo setIsHidden:[NSNumber numberWithBool:NO]];
		[responseOccurredFieldInfo setType:[NSNumber numberWithInt:BTIActionFieldValueTypeBoolean]];
		[responseOccurredFieldInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
	}
	
	sortOrder++;
	
	ActionFieldInfo *notifiedFieldInfo = [self actionFieldInfoForIdentifier:kTermInfoIdentifierParentNotified];
	if (notifiedFieldInfo == nil)
	{
		notifiedFieldInfo = [ActionFieldInfo managedObjectInContextBTI:context];
		[notifiedFieldInfo setIdentifier:kTermInfoIdentifierParentNotified];
		[notifiedFieldInfo setTermInfo:[self termInfoForIdentifier:[notifiedFieldInfo identifier]]];
		[notifiedFieldInfo setIsUserCreated:[NSNumber numberWithBool:NO]];
		[notifiedFieldInfo setIsHidden:[NSNumber numberWithBool:NO]];
		[notifiedFieldInfo setType:[NSNumber numberWithInt:BTIActionFieldValueTypeBoolean]];
		[notifiedFieldInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
	}
	
	sortOrder++;
	
	ActionFieldInfo *colorLabelFieldInfo = [self actionFieldInfoForIdentifier:kTermInfoIdentifierColorLabel];
	if (colorLabelFieldInfo == nil)
	{
		colorLabelFieldInfo = [ActionFieldInfo managedObjectInContextBTI:context];
		[colorLabelFieldInfo setIdentifier:kTermInfoIdentifierColorLabel];
		[colorLabelFieldInfo setTermInfo:[self termInfoForIdentifier:[colorLabelFieldInfo identifier]]];
		[colorLabelFieldInfo setIsUserCreated:[NSNumber numberWithBool:NO]];
		[colorLabelFieldInfo setIsHidden:[NSNumber numberWithBool:NO]];
		[colorLabelFieldInfo setType:[NSNumber numberWithInt:BTIActionFieldValueTypeColor]];
		[colorLabelFieldInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
	}
	
	sortOrder++;
	
	ActionFieldInfo *descriptionFieldInfo = [self actionFieldInfoForIdentifier:kTermInfoIdentifierDescription];
	if (descriptionFieldInfo == nil)
	{
		descriptionFieldInfo = [ActionFieldInfo managedObjectInContextBTI:context];
		[descriptionFieldInfo setIdentifier:kTermInfoIdentifierDescription];
		[descriptionFieldInfo setTermInfo:[self termInfoForIdentifier:[descriptionFieldInfo identifier]]];
		[descriptionFieldInfo setIsUserCreated:[NSNumber numberWithBool:NO]];
		[descriptionFieldInfo setIsHidden:[NSNumber numberWithBool:NO]];
		[descriptionFieldInfo setType:[NSNumber numberWithInt:BTIActionFieldValueTypeLongText]];
		[descriptionFieldInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
	}
	
	sortOrder++;
	
	ActionFieldInfo *noteFieldInfo = [self actionFieldInfoForIdentifier:kTermInfoIdentifierNote];
	if (noteFieldInfo == nil)
	{
		ActionFieldInfo *noteFieldInfo = [ActionFieldInfo managedObjectInContextBTI:context];
		[noteFieldInfo setIdentifier:kTermInfoIdentifierNote];
		[noteFieldInfo setTermInfo:[self termInfoForIdentifier:[noteFieldInfo identifier]]];
		[noteFieldInfo setIsUserCreated:[NSNumber numberWithBool:NO]];
		[noteFieldInfo setIsHidden:[NSNumber numberWithBool:NO]];
		[noteFieldInfo setType:[NSNumber numberWithInt:BTIActionFieldValueTypeLongText]];
		[noteFieldInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
	}
	
	sortOrder++;
	
	ActionFieldInfo *imageFieldInfo = [self actionFieldInfoForIdentifier:kTermInfoIdentifierImage];
	if (imageFieldInfo == nil)
	{
		imageFieldInfo = [ActionFieldInfo managedObjectInContextBTI:context];
		[imageFieldInfo setIdentifier:kTermInfoIdentifierImage];
		[imageFieldInfo setTermInfo:[self termInfoForIdentifier:[imageFieldInfo identifier]]];
		[imageFieldInfo setIsUserCreated:[NSNumber numberWithBool:NO]];
		[imageFieldInfo setIsHidden:[NSNumber numberWithBool:NO]];
		[imageFieldInfo setType:[NSNumber numberWithInt:BTIActionFieldValueTypeImage]];
		[imageFieldInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
	}
	
	sortOrder++;

	// TODO: Audio
//	ActionFieldInfo *audioFieldInfo = [self actionFieldInfoForIdentifier:kTermInfoIdentifierAudio];
//	if (audioFieldInfo == nil)
//	{
//		audioFieldInfo = [ActionFieldInfo managedObjectInContextBTI:context];
//		[audioFieldInfo setIdentifier:kTermInfoIdentifierAudio];
//		[audioFieldInfo setTermInfo:[self termInfoForIdentifier:[audioFieldInfo identifier]]];
//		[audioFieldInfo setIsUserCreated:[NSNumber numberWithBool:NO]];
//		[audioFieldInfo setIsHidden:[NSNumber numberWithBool:NO]];
//		[audioFieldInfo setType:[NSNumber numberWithInt:BTIActionFieldValueTypeAudio]];
//		[audioFieldInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
//	}
//	
//	sortOrder++;

	// TODO: Video
//	ActionFieldInfo *videoFieldInfo = [self actionFieldInfoForIdentifier:kTermInfoIdentifierVideo];
//	if (videoFieldInfo == nil)
//	{
//		videoFieldInfo = [ActionFieldInfo managedObjectInContextBTI:context];
//		[videoFieldInfo setIdentifier:kTermInfoIdentifierVideo];
//		[videoFieldInfo setTermInfo:[self termInfoForIdentifier:[videoFieldInfo identifier]]];
//		[videoFieldInfo setIsUserCreated:[NSNumber numberWithBool:NO]];
//		[videoFieldInfo setIsHidden:[NSNumber numberWithBool:NO]];
//		[videoFieldInfo setType:[NSNumber numberWithInt:BTIActionFieldValueTypeVideo]];
//		[videoFieldInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
//	}
//	sortOrder++;
	
	// TODO: Determine if device is capable of audio and video
	
	[self saveCoreDataContext];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSInteger)countOfActionFieldInfos
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	[fetchRequest setEntity:[ActionFieldInfo entityDescriptionInContextBTI:context]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [context countForFetchRequestBTI:fetchRequest];
}

- (ActionFieldInfo *)actionFieldInfoForIdentifier:(NSString *)identifier
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (identifier == nil)
	{
		NSLog(@"<<< Leaving %s >>> EARLY - No identifier", __PRETTY_FUNCTION__);
		return nil;
	}	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self actionFieldInfoForIdentifier:identifier inContext:[self managedObjectContext]];
}

- (ActionFieldInfo *)actionFieldInfoForIdentifier:(NSString *)identifier
										inContext:(NSManagedObjectContext *)context
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (identifier == nil)
	{
		NSLog(@"<<< Leaving %s >>> EARLY - No identifier", __PRETTY_FUNCTION__);
		return nil;
	}
		
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	NSDictionary *variables = [NSDictionary dictionaryWithObject:identifier forKey:kIDENTIFIER];
	NSPredicate *predicate = [self identifierRootPredicate];
	
	[fetchRequest setEntity:[ActionFieldInfo entityDescriptionInContextBTI:context]];
	
	[fetchRequest setPredicate:[predicate predicateWithSubstitutionVariables:variables]];
	
	NSArray *actionFieldInfos = [context executeFetchRequestBTI:fetchRequest];
	
	ActionFieldInfo *infoToReturn = [actionFieldInfos lastObject];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return infoToReturn;
}

- (NSArray *)allSortedActionFieldInfosInContext:(NSManagedObjectContext *)context
{
//	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSArray *arrayToReturn = nil;
	NSArray *sortedActionFieldInfos = [self allSortedActionFieldInfosInMainContext];
	
	if (context == [self managedObjectContext])
	{
		arrayToReturn = sortedActionFieldInfos;
	}
	else
	{
		NSMutableArray *array = [[NSMutableArray alloc] init];
		
		for (ActionFieldInfo *fieldInfo in sortedActionFieldInfos)
		{
			ActionFieldInfo *scratchFieldInfo = (ActionFieldInfo *)[context existingObjectWithID:[fieldInfo objectID] error:nil];
			
			if (scratchFieldInfo != nil)
			{
				[array addObject:scratchFieldInfo];
			}
		}
		
		arrayToReturn = [NSArray arrayWithArray:array];
		
		[array release], array = nil;
	}

//	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return arrayToReturn;
}

- (ActionFieldInfo *)actionActionFieldInfoInContext:(NSManagedObjectContext *)context
{
//	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	ActionFieldInfo *actionFieldInfoToReturn = nil;
	ActionFieldInfo *actionFieldInfo = [self actionActionFieldInfoInMainContext];

	if (context == [self managedObjectContext])
	{
		actionFieldInfoToReturn = actionFieldInfo;
	}
	else
	{
		actionFieldInfoToReturn = (ActionFieldInfo *)[context existingObjectWithID:[actionFieldInfo objectID] error:nil];
	}
	
//	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return actionFieldInfoToReturn;
}

- (ActionFieldInfo *)dateActionFieldInfoInContext:(NSManagedObjectContext *)context
{
//	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	ActionFieldInfo *actionFieldInfoToReturn = nil;
	ActionFieldInfo *actionFieldInfo = [self dateActionFieldInfoInMainContext];
	
	if (context == [self managedObjectContext])
	{
		actionFieldInfoToReturn = actionFieldInfo;
	}
	else
	{
		actionFieldInfoToReturn = (ActionFieldInfo *)[context existingObjectWithID:[actionFieldInfo objectID] error:nil];
	}
	
//	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return actionFieldInfoToReturn;
}

#pragma mark - ColorInfo Methods

- (void)loadDefaultColorInfo
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity:[ColorInfo entityDescriptionInContextBTI:context]];
	
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", kColorIdentifierRed]];

	NSInteger sortOrder = 0;
	
	ColorInfo *colorInfo = [[context executeFetchRequestBTI:fetchRequest] lastObject];
	if (colorInfo == nil)
	{
		colorInfo = [ColorInfo managedObjectInContextBTI:context];
		[colorInfo setIdentifier:kColorIdentifierRed];
		[colorInfo setName:@"Red"];
		[colorInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		[colorInfo setColor:[UIColor redColor]];
		[colorInfo setPointValue:[NSNumber numberWithInt:-2]];
	}
	
	sortOrder++;
	
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", kColorIdentifierYellow]];
	
	colorInfo = [[context executeFetchRequestBTI:fetchRequest] lastObject];
	if (colorInfo == nil)
	{
		colorInfo = [ColorInfo managedObjectInContextBTI:context];
		[colorInfo setIdentifier:kColorIdentifierYellow];
		[colorInfo setName:@"Yellow"];
		[colorInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		[colorInfo setColor:[UIColor yellowColor]];
		[colorInfo setPointValue:[NSNumber numberWithInt:-1]];
	}
	
	sortOrder++;
	
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", kColorIdentifierGreen]];
	
	colorInfo = [[context executeFetchRequestBTI:fetchRequest] lastObject];
	if (colorInfo == nil)
	{
		colorInfo = [ColorInfo managedObjectInContextBTI:context];
		[colorInfo setIdentifier:kColorIdentifierGreen];
		[colorInfo setName:@"Green"];
		[colorInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		[colorInfo setColor:[UIColor greenColor]];
		[colorInfo setPointValue:[NSNumber numberWithInt:1]];
	}
	
	sortOrder++;
	
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", kColorIdentifierBlue]];
	
	colorInfo = [[context executeFetchRequestBTI:fetchRequest] lastObject];
	if (colorInfo == nil)
	{
		colorInfo = [ColorInfo managedObjectInContextBTI:context];
		[colorInfo setIdentifier:kColorIdentifierBlue];
		[colorInfo setName:@"Blue"];
		[colorInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		[colorInfo setColor:[UIColor blueColor]];
		[colorInfo setPointValue:[NSNumber numberWithInt:2]];
	}
	
	[self saveCoreDataContext];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (UIImage *)thumbnailImageForColorInfo:(ColorInfo *)colorInfo
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if (colorInfo == nil)
	{
		NSLog(@"<<< Leaving %s >>> EARLY - No color", __PRETTY_FUNCTION__);
		return nil;
	}
	
	UIColor *color = [colorInfo color];
	
	CGFloat targetEdgeLength = 44.0;
	
	if ([TeachersAssistantAppDelegate isRetinaDisplay])
	{
		targetEdgeLength = targetEdgeLength * 2.0;
	}
	
	CGRect rect = CGRectMake(0.0f, 0.0f, targetEdgeLength, targetEdgeLength);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
	
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return image;
}

#pragma mark - MediaInfo Methods

- (void)addFileForMediaInfo:(MediaInfo *)mediaInfo
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSInteger mediaType = [[mediaInfo type] integerValue];
	
	switch (mediaType) {
		case BTIMediaTypeAudio:
		{
			// TODO: Handle audio file type
		}
			break;
		case BTIMediaTypeImage:
		{
			if ([mediaInfo image] != nil)
			{
				NSData *data = UIImageJPEGRepresentation([mediaInfo image], kJPEGImageQuality);
				
				NSString *fileName = [self validImageFileName];
				NSString *path = [[self imageDirectory] stringByAppendingPathComponent:fileName];
				
				[data writeToFile:path atomically:YES];
				
				[mediaInfo setFileName:fileName];
			}
		}
			break;
		case BTIMediaTypeVideo:
		{
			// TODO: Handle video file type
		}
			break;
		default:
		{
			NSLog(@"\n\n******ALERT*******\n\nUnsupported media type\n\n");
		}
			break;
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)removeFileForMediaInfo:(MediaInfo *)mediaInfo
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (mediaInfo == nil)
		return;
	
	NSInteger mediaType = [[mediaInfo type] integerValue];
	
	switch (mediaType) {
		case BTIMediaTypeAudio:
		{
			// TODO: Handle audio file type
		}
			break;
		case BTIMediaTypeImage:
		{
			NSString *imageFileName = [mediaInfo fileName];
			if (imageFileName != nil)
			{
//				NSString *path = [[self imageDirectory] stringByAppendingPathComponent:imageFileName];
//				NSFileManager *fileManager = [NSFileManager defaultManager];
//				if ([fileManager fileExistsAtPath:path])
//				{
//					[fileManager removeItemAtPathBTI:path];
//				} 
				
				[mediaInfo setImage:nil];
				[mediaInfo setFileName:nil];
			}
		}
			break;
		case BTIMediaTypeVideo:
		{
			// TODO: Handle video file type
		}
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)purgeUnusedMediaInfos
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	[fetchRequest setEntity:[MediaInfo entityDescriptionInContextBTI:context]];
	
	// TODO: Audio and Video
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"actionValueImage == nil AND personLarge == nil AND personSmall == nil AND actionValueThumbnail == nil"]];
	
	NSArray *mediaInfos = [context executeFetchRequestBTI:fetchRequest];
	
	for (MediaInfo *mediaInfo in mediaInfos)
	{
		[self deleteMediaInfo:mediaInfo];
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)deleteMediaInfo:(MediaInfo *)mediaInfo
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (mediaInfo != nil)
	{
		[self removeFileForMediaInfo:mediaInfo];
		
		[[self managedObjectContext] deleteObject:mediaInfo];
		
		[self saveCoreDataContext];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - TermInfo Methods

- (void)loadDefaultTermInfo
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSInteger sortOrder = -1;
	
	TermInfo *termInfo = nil;	
	
	{{
		sortOrder++;
		
		termInfo = [self termInfoForIdentifier:kTermInfoIdentifierAction];
		if (termInfo == nil)
		{
			termInfo = [TermInfo managedObjectInContextBTI:context];
			[termInfo setIdentifier:kTermInfoIdentifierAction];
			[termInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		}
		[termInfo setDefaultNameSingular:@"Action"];
		[termInfo setDefaultNamePlural:@"Actions"];
	}}
		
	{{
		sortOrder++;
		
		termInfo = [self termInfoForIdentifier:kTermInfoIdentifierClass];
		if (termInfo == nil)
		{
			termInfo = [TermInfo managedObjectInContextBTI:context];
			[termInfo setIdentifier:kTermInfoIdentifierClass];
			[termInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		}
		[termInfo setDefaultNameSingular:@"Class"];
		[termInfo setDefaultNamePlural:@"Classes"];
	}}
	
	{{
		sortOrder++;
		
		termInfo = [self termInfoForIdentifier:kTermInfoIdentifierColorLabel];
		if (termInfo == nil)
		{
			termInfo = [TermInfo managedObjectInContextBTI:context];
			[termInfo setIdentifier:kTermInfoIdentifierColorLabel];
			[termInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		}
		[termInfo setDefaultNameSingular:@"Color Label"];
		[termInfo setDefaultNamePlural:@"Color Labels"];
	}}
	
	{{
		sortOrder++;
		
		termInfo = [self termInfoForIdentifier:kTermInfoIdentifierDate];
		if (termInfo == nil)
		{
			termInfo = [TermInfo managedObjectInContextBTI:context];
			[termInfo setIdentifier:kTermInfoIdentifierDate];
			[termInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		}
		[termInfo setDefaultNameSingular:@"Date"];
		[termInfo setDefaultNamePlural:@"Dates"];
	}}
	
	{{
		sortOrder++;
		
		termInfo = [self termInfoForIdentifier:kTermInfoIdentifierGradingPeriod];
		if (termInfo == nil)
		{
			termInfo = [TermInfo managedObjectInContextBTI:context];
			[termInfo setIdentifier:kTermInfoIdentifierGradingPeriod];
			[termInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		}
		[termInfo setDefaultNameSingular:@"Date Range"];
		[termInfo setDefaultNamePlural:@"Date Ranges"];
	}}
	
	{{
		sortOrder++;
		
		termInfo = [self termInfoForIdentifier:kTermInfoIdentifierDescription];
		if (termInfo == nil)
		{
			termInfo = [TermInfo managedObjectInContextBTI:context];
			[termInfo setIdentifier:kTermInfoIdentifierDescription];
			[termInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		}
		[termInfo setDefaultNameSingular:@"Description"];
		[termInfo setDefaultNamePlural:@"Descriptions"];
	}}
	
	{{
		sortOrder++;
		
		termInfo = [self termInfoForIdentifier:kTermInfoIdentifierImage];
		if (termInfo == nil)
		{
			termInfo = [TermInfo managedObjectInContextBTI:context];
			[termInfo setIdentifier:kTermInfoIdentifierImage];
			[termInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		}
		[termInfo setDefaultNameSingular:@"Image"];
		[termInfo setDefaultNamePlural:@"Images"];
	}}
	
	{{
		sortOrder++;
		
		termInfo = [self termInfoForIdentifier:kTermInfoIdentifierLocation];
		if (termInfo == nil)
		{
			termInfo = [TermInfo managedObjectInContextBTI:context];
			[termInfo setIdentifier:kTermInfoIdentifierLocation];
			[termInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		}
		[termInfo setDefaultNameSingular:@"Location"];
		[termInfo setDefaultNamePlural:@"Locations"];
	}}

	{{
		sortOrder++;
		
		termInfo = [self termInfoForIdentifier:kTermInfoIdentifierNote];
		if (termInfo == nil)
		{
			termInfo = [TermInfo managedObjectInContextBTI:context];
			[termInfo setIdentifier:kTermInfoIdentifierNote];
			[termInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		}
		[termInfo setDefaultNameSingular:@"Note"];
		[termInfo setDefaultNamePlural:@"Notes"];
	}}
	
	{{
		sortOrder++;
		
		termInfo = [self termInfoForIdentifier:kTermInfoIdentifierOptional];
		if (termInfo == nil)
		{
			termInfo = [TermInfo managedObjectInContextBTI:context];
			[termInfo setIdentifier:kTermInfoIdentifierOptional];
			[termInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		}
		[termInfo setDefaultNameSingular:@"Optional"];
		[termInfo setDefaultNamePlural:@"Optionals"];
	}}

//	{{
//		sortOrder++;
//		
//		termInfo = [self termInfoForIdentifier:kTermInfoIdentifierOther];
//		if (termInfo == nil)
//		{
//			termInfo = [[[TermInfo alloc] initWithEntity:[self termInfoEntity] insertIntoManagedObjectContext:context] autorelease];
//			[termInfo setIdentifier:kTermInfoIdentifierOther];
//			[termInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
//		}
//		[termInfo setDefaultNameSingular:@"Other"];
//		[termInfo setDefaultNamePlural:@"Others"];
//	}}
	
	{{
		sortOrder++;
		
		termInfo = [self termInfoForIdentifier:kTermInfoIdentifierParent];
		if (termInfo == nil)
		{
			termInfo = [TermInfo managedObjectInContextBTI:context];
			[termInfo setIdentifier:kTermInfoIdentifierParent];
			[termInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		}
		[termInfo setDefaultNameSingular:@"Parent"];
		[termInfo setDefaultNamePlural:@"Parents"];
	}}

	{{
		sortOrder++;
		
		termInfo = [self termInfoForIdentifier:kTermInfoIdentifierParentNotified];
		if (termInfo == nil)
		{
			termInfo = [TermInfo managedObjectInContextBTI:context];
			[termInfo setIdentifier:kTermInfoIdentifierParentNotified];
			[termInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		}
		[termInfo setDefaultNameSingular:@"Parent Notified"];
		[termInfo setDefaultNamePlural:@"Parents Notified"];
	}}
	
	{{
		sortOrder++;
		
		termInfo = [self termInfoForIdentifier:kTermInfoIdentifierPerson];
		if (termInfo == nil)
		{
			termInfo = [TermInfo managedObjectInContextBTI:context];
			[termInfo setIdentifier:kTermInfoIdentifierPerson];
			[termInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		}
		[termInfo setDefaultNameSingular:@"Student"];
		[termInfo setDefaultNamePlural:@"Students"];
	}}

	{{
		sortOrder++;
		
		termInfo = [self termInfoForIdentifier:kTermInfoIdentifierRandomizer];
		if (termInfo == nil)
		{
			termInfo = [TermInfo managedObjectInContextBTI:context];
			[termInfo setIdentifier:kTermInfoIdentifierRandomizer];
			[termInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		}
		[termInfo setDefaultNameSingular:@"Randomizer"];
		[termInfo setDefaultNamePlural:@"Randomizers"];
	}}
	
	{{
		sortOrder++;
		
		termInfo = [self termInfoForIdentifier:kTermInfoIdentifierSummary];
		if (termInfo == nil)
		{
			termInfo = [TermInfo managedObjectInContextBTI:context];
			[termInfo setIdentifier:kTermInfoIdentifierSummary];
			[termInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		}
		[termInfo setDefaultNameSingular:@"Summary"];
		[termInfo setDefaultNamePlural:@"Summaries"];
	}}

	{{
		sortOrder++;
		
		termInfo = [self termInfoForIdentifier:kTermInfoIdentifierTeacherResponse];
		if (termInfo == nil)
		{
			termInfo = [TermInfo managedObjectInContextBTI:context];
			[termInfo setIdentifier:kTermInfoIdentifierTeacherResponse];
			[termInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		}
		[termInfo setDefaultNameSingular:@"Teacher Response"];
		[termInfo setDefaultNamePlural:@"Teacher Responses"];
	}}

	{{
		sortOrder++;
		
		termInfo = [self termInfoForIdentifier:kTermInfoIdentifierTeacherResponseOccurred];
		if (termInfo == nil)
		{
			termInfo = [TermInfo managedObjectInContextBTI:context];
			[termInfo setIdentifier:kTermInfoIdentifierTeacherResponseOccurred];
			[termInfo setSortOrder:[NSNumber numberWithInt:sortOrder]];
		}
		[termInfo setDefaultNameSingular:@"Teacher Response Occurred"];
		[termInfo setDefaultNamePlural:@"Teacher Responses Occurred"];
	}}

	[self saveCoreDataContext];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (TermInfo *)termInfoForIdentifier:(NSString *)identifier
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSManagedObjectContext *context = [self managedObjectContext];

	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];

	NSDictionary *variables = [NSDictionary dictionaryWithObject:identifier forKey:kIDENTIFIER];
	NSPredicate *predicate = [self identifierRootPredicate];
	
	[fetchRequest setEntity:[TermInfo entityDescriptionInContextBTI:context]];
	
	[fetchRequest setPredicate:[predicate predicateWithSubstitutionVariables:variables]];
	
	NSArray *actionFieldInfos = [context executeFetchRequestBTI:fetchRequest];
	
	TermInfo *infoToReturn = [actionFieldInfos lastObject];
	
	NSLog(@"TermInfo is: %@", [infoToReturn description]);
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return infoToReturn;
}

- (NSString *)singularNameForTermInfo:(TermInfo *)termInfo
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *nameToReturn = [termInfo userNameSingular];
	
	if ( (nameToReturn == nil) || ([nameToReturn length] == 0) )
	{
		nameToReturn = [termInfo defaultNameSingular];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return nameToReturn;
}

- (NSString *)singularNameForTermInfoIndentifier:(NSString *)identifier
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self singularNameForTermInfo:[self termInfoForIdentifier:identifier]];
}

- (NSString *)pluralNameForTermInfo:(TermInfo *)termInfo
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *nameToReturn = [termInfo userNamePlural];
	
	if ( (nameToReturn == nil) || ([nameToReturn length] == 0) )
	{
		nameToReturn = [termInfo defaultNamePlural];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return nameToReturn;
}

- (NSString *)pluralNameForTermInfoIndentifier:(NSString *)identifier
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self pluralNameForTermInfo:[self termInfoForIdentifier:identifier]];
}

- (void)resetAllTermInfosToDefault
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	[fetchRequest setEntity:[TermInfo entityDescriptionInContextBTI:context]];
	
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"identifier != nil"]];
	
	NSArray *termInfos = [context executeFetchRequestBTI:fetchRequest];
	
	for (TermInfo *termInfo in termInfos)
	{
		[termInfo setUserNameSingular:nil];
		[termInfo setUserNamePlural:nil];
	}

	[self saveCoreDataContext];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - GradingPeriod Methods

- (void)loadDefaultGradingPeriods
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[self gradingPeriods] removeAllObjects];
	[self setActiveGradingPeriod:nil];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *allDatesName = @"All Dates";
	
	NSMutableArray *gradingPeriods = [NSMutableArray arrayWithArray:[userDefaults btiGradingPeriods]];
	
	if ([gradingPeriods count] == 0)
	{
		GradingPeriod *gradingPeriod = [[GradingPeriod alloc] init];
		[gradingPeriod setName:allDatesName];
		[gradingPeriod setStartDate:[NSDate distantPast]];
		[gradingPeriod setEndDate:[NSDate distantFuture]];
		[gradingPeriod setSortOrder:[NSNumber numberWithInt:0]];
		
		[self setActiveGradingPeriod:gradingPeriod];
		
		[gradingPeriods addObject:gradingPeriod];
		
		[gradingPeriod release], gradingPeriod = nil;
	}

	for (GradingPeriod *gradingPeriod in gradingPeriods)
	{
		if ([gradingPeriod isSelected])
		{
			[self setActiveGradingPeriod:gradingPeriod];
			break;
		}
	}
	
	if ([self activeGradingPeriod] == nil)		// If it wasn't found, use the default by name
	{
		for (GradingPeriod *gradingPeriod in gradingPeriods)
		{
			if ([[gradingPeriod name] isEqualToString:allDatesName])
			{
				[self setActiveGradingPeriod:gradingPeriod];
				break;
			}
		}
	}
	
	[self setGradingPeriods:gradingPeriods];
	[userDefaults btiSetGradingPeriods:gradingPeriods];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - RandomizerInfo Methods

- (void)loadDefaultRandomizerInfo
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - PersonDetailInfo Methods

- (void)deleteAllPersonDetailInfos
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	[fetchRequest setEntity:[PersonDetailInfo entityDescriptionInContextBTI:context]];

	NSArray *detailInfos = [context executeFetchRequestBTI:fetchRequest];
	
	for (PersonDetailInfo *detailInfo in detailInfos)
	{
		[context deleteObject:detailInfo];
	}
	
	[self saveCoreDataContext];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Dropbox Support

- (void)checkForDropboxDestinationFolder
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self downloadDropboxMetadata];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)createDropboxDestinationFolder
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self setDropboxWorking:YES];
	
	[[self restFolderClient] createFolder:kDropboxDestinationFolderName];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)prepareUploadToDropbox:(NSString *)sourcePath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[self setDropboxWorking:YES];

	[self setDropboxUploadFilePath:sourcePath];
	
	if ([self isDropboxDestinationFolderCreated])
	{
		[self downloadDropboxDestinationFolderMetadata];
	}
	else
	{
		[self checkForDropboxDestinationFolder];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)downloadDropboxMetadata
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self restFolderClient] loadMetadata:@"/"];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)downloadDropboxDestinationFolderMetadata
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self restClient] loadMetadata:[NSString stringWithFormat:@"/%@/", kDropboxDestinationFolderName]];				//@"/TeachersAssistant/"
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)uploadDropboxFile
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *fromPath = [self dropboxUploadFilePath];
	NSString *fileName = [fromPath lastPathComponent];
	//	NSString *toPath = @"/";
	NSString *toPath = [NSString stringWithFormat:@"/%@/", kDropboxDestinationFolderName];
	
//	[[self restClient] uploadFile:fileName toPath:toPath fromPath:fromPath];
	// TODO: Verify behavior
	[[self restClient] uploadFile:fileName toPath:toPath withParentRev:nil fromPath:fromPath];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)displayDropboxUploadError 
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [[[[UIAlertView alloc] initWithTitle:@"Error Uploading"
								 message:@"There was an error uploading your file."
								delegate:nil
					   cancelButtonTitle:@"OK"
					   otherButtonTitles:nil] autorelease] show];
	
	[self setDropboxWorking:NO];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Back to server support methods
- (void)prepareUploadToServer:(NSString *)sourcePath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    NSString* fileName  = [sourcePath lastPathComponent];
    
	UIDevice *myDevice	= [UIDevice currentDevice];
	NSString *udid		= [myDevice uniqueIdentifier]; //@"ba903d60338e6f4b2731e6733dbe15b4999c8362";//[myDevice uniqueIdentifier];
    
    // write code to uplaod it to server
	NSURL *url                  = [NSURL URLWithString:@"http://hdchief.com/api/do.php"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSData *exportData = [[NSData alloc] initWithContentsOfFile:sourcePath];
	NSString *base64String = [exportData base64EncodedString]; 
    
    [request addPostValue:base64String forKey:@"data"];
	[request addPostValue:udid forKey:@"device"];
	[request addPostValue:fileName forKey:@"data_file_name"];
	[request setTimeOutSeconds:60];
    
	[request addRequestHeader:@"device" value:udid];
	
    //[request setUploadProgressDelegate:myProgressIndicator];
    
	[request startSynchronous];
	NSError *error = [request error];
	NSString *strData;
    if (!error) {
		strData = [request responseString];
		NSLog(@"Backup upload response:%@", strData);
	}
    
    RIButtonItem *cancelButton = [RIButtonItem item];
    [cancelButton setLabel:@"OK"];

    UIAlertView *alert;
    if (strData!=nil && [strData isEqualToString:@"1"] ) {
        alert = [[UIAlertView alloc] initWithTitle:@"Succeed!!"
                                     message:@"Your device backup data has been uploaded to our server successfully. Kindly use TAP Pro 2 to import same."
                            cancelButtonItem:cancelButton
                            otherButtonItems:nil, nil];
    } else {
        alert = [[UIAlertView alloc] initWithTitle:@"Failed!"
                                           message:@"Sorry, We could not upload your backup data due to some technical difficulties. Please try again later"
                                  cancelButtonItem:cancelButton
                                  otherButtonItems:nil, nil];
    }
    [alert show];
    [alert release],
    alert = nil;
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


#pragma mark - DBRestClientDelegate methods

- (void)restClient:(DBRestClient *)client
	loadedMetadata:(DBMetadata *)metadata
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (client == [self restClient])			// Regular file stuff
	{
		NSMutableArray *possibleConflictPaths = [[NSMutableArray alloc] init];
		
		NSArray *validExtensions = [NSArray arrayWithObjects:kNativeFileExtension, [kNativeFileExtension uppercaseString], nil];
		
		for (DBMetadata *child in [metadata contents])
		{
			NSString *extension = [[[child path] pathExtension] lowercaseString];
			if ( (![child isDirectory]) && ([validExtensions containsObject:extension]) )
			{
				[possibleConflictPaths addObject:[child path]];
			}
		}
		
		NSLog(@"possibleConflictPaths: %@", possibleConflictPaths);
		
		BOOL thereIsAConflict = NO;
		NSString *uploadFileName = [[self dropboxUploadFilePath] lastPathComponent];
		
		for (NSString *fullDropboxPath in possibleConflictPaths)
		{
			NSString *dropboxFileName = [fullDropboxPath lastPathComponent];
			
			NSLog(@"Comparing file names\n local:   %@\n Dropbox: %@\n", uploadFileName, dropboxFileName);
			
			if ([uploadFileName localizedCaseInsensitiveCompare:dropboxFileName] == NSOrderedSame)
			{
				thereIsAConflict = YES;
				break;
			}
		}
		
		if (thereIsAConflict)
		{
			NSLog(@"The file already exists on Dropbox");
			
			RIButtonItem *cancelButton = [RIButtonItem item];
			[cancelButton setLabel:@"Cancel"];
			[cancelButton setAction:^{
				[self setDropboxWorking:NO];
			}];
			
			RIButtonItem *replaceButton = [RIButtonItem item];
			[replaceButton setLabel:@"Replace"];
			[replaceButton setAction:^{
				[self uploadDropboxFile];
			}];
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Existing File"
															message:@"An item with this name already exists in Dropbox. Do you want to replace it with the one you're uploading?"
												   cancelButtonItem:cancelButton
												   otherButtonItems:replaceButton, nil];
						
			[alert show];
			
			[alert release], alert = nil;
		}
		else
		{
			NSLog(@"The file doesn't exist on Dropbox");
			
			[self uploadDropboxFile];
		}
		
		[possibleConflictPaths release], possibleConflictPaths = nil;
	}
	else			// Looking for the TeachersAssistant folder
	{
		BOOL foundDestinationFolder = NO;
		
		for (DBMetadata *child in [metadata contents])
		{
			if ([child isDirectory])
			{
				NSLog(@"path is: %@", [child path]);
				if ([[child path] hasSuffix:kDropboxDestinationFolderName])
				{
					foundDestinationFolder = YES;
				}
			}
		}
		
		if (foundDestinationFolder)
		{
			[self setDropboxDestinationFolderCreated:YES];
			
			if ([self dropboxUploadFilePath] != nil)
			{
				[self uploadDropboxFile];
			}
		}
		else
		{
			[self setDropboxDestinationFolderCreated:NO];
			
			[self createDropboxDestinationFolder];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dropbox Error"
													message:[NSString stringWithFormat:@"TAP issue: Could not read Dropbox data\n\nDropbox error message: %@", [error localizedDescription]]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	//    [self displayDropboxUploadError];
    [self setDropboxWorking:NO];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Dropbox DBRestClientDelegate Methods

- (void)restClient:(DBRestClient *)client
	 createdFolder:(DBMetadata *)folder
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self setDropboxDestinationFolderCreated:YES];
	
	if ([self dropboxUploadFilePath] != nil)
	{
		[self uploadDropboxFile];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)restClient:(DBRestClient *)client
createFolderFailedWithError:(NSError *)error
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// [error userInfo] contains the sourcePath
    NSLog(@"restClient:createFolderFailedWithError: %@", [error localizedDescription]);
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dropbox Error"
													message:[NSString stringWithFormat:@"TAP issue: Could not create app folder\n\nDropbox error message: %@", [error localizedDescription]]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
//    [self displayDropboxUploadError];
    [self setDropboxWorking:NO];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)restClient:(DBRestClient *)client
	  uploadedFile:(NSString *)destPath
			  from:(NSString *)srcPath;
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSLog(@"destinationPath is: %@", destPath);
	NSLog(@"sourcePath is: %@", srcPath);
		
	[self setDropboxWorking:NO];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)restClient:(DBRestClient *)client
	uploadProgress:(CGFloat)progress 
		   forFile:(NSString *)destPath
			  from:(NSString *)srcPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)restClient:(DBRestClient*)client
uploadFileFailedWithError:(NSError*)error
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// [error userInfo] contains the sourcePath
    NSLog(@"restClient:loadMetadataFailedWithError: %@", [error localizedDescription]);
	
	NSDictionary *userInfo = [error userInfo];
	NSString *srcPath = [userInfo objectForKey:@"sourcePath"];
	NSLog(@"sourcePath is: %@", srcPath);
	
	[[NSFileManager defaultManager] removeItemAtPath:srcPath error:nil];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dropbox Error"
													message:[NSString stringWithFormat:@"TAP issue: Could not upload file\n\nDropbox error message: %@", [error localizedDescription]]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
//    [self displayDropboxUploadError];
    [self setDropboxWorking:NO];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - MFMailComposeViewController Delegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError *)error
{   
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSLog(@"Parent controller is: %@", NSStringFromClass([[self presentingViewController] class]));
	
    // Notifies users about errors associated with the interface
	// message is only queued in the Mail application outbox. This allows you to generate emails even in situations where the user does not have network access, such as in airplane mode.
    switch (result)
    {
			// The user cancelled the operation. No email message was queued.
        case MFMailComposeResultCancelled:
            // mailResult = @"Result: canceled";
            break;
			// The email message was saved in the user’s Drafts folder.
        case MFMailComposeResultSaved:
			// mailResult = @"Result: saved";
            break;
			// The email message was queued in the user’s outbox. It is ready to send the next time the user connects to email.
        case MFMailComposeResultSent:
            // mailResult = @"Result: sent";
            break;
			// The email message was not saved or queued, possibly due to an error.
        case MFMailComposeResultFailed:
            // mailResult = @"Result: failed";
            break;
			
		default:
		{
			// NSString *messageBody = [[NSString alloc] initWithFormat:@"Sending Failed - %@", mailResult];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Error"
								  // message:messageBody
															message:@"Unknown error. Your mail was not sent."
														   delegate:self
												  cancelButtonTitle:@"OK"
												  otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
			break;
    }
	
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
	
	[self setPresentingViewController:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Singleton Methods
// http://cocoasamurai.blogspot.com/2011/04/singletons-your-doing-them-wrong.html

+ (DataController *)sharedDataController
{
	static dispatch_once_t pred;
	static DataController *shared = nil;
	
	dispatch_once(&pred, ^{
		shared = [[DataController alloc] init];
	});
	
	return shared;
}

@end
