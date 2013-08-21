//
//  TeachersAssistantAppDelegate.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/14/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "TeachersAssistantAppDelegate.h"

#import "GTMBase64.h"

@interface TeachersAssistantAppDelegate ()

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@end

@implementation TeachersAssistantAppDelegate

#pragma mark - Synthesized Properties

// Public
@synthesize window = ivWindow;
@synthesize homeViewController = ivHomeViewController;

// Private
@synthesize backgroundTaskIdentifier = ivBackgroundTaskIdentifier;

#pragma mark - Dealloc and Memory Management

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// Public Properties
	[self setWindow:nil];
	[self setHomeViewController:nil];
	
    [super dealloc];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[DataController sharedDataController] saveAllData];
	
	// TODO:
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//													message:@"Low Memory"
//												   delegate:nil
//										  cancelButtonTitle:@"Ok"
//										  otherButtonTitles:nil];
//	[alert show];
//	[alert release], alert = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UIApplication Delegate Methods

- (BOOL)application:(UIApplication *)application 
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldShowCSVImporter:) name:kShouldShowCSVImportNotification object:nil];
	
//	[[DataController sharedDataController] performSelector:@selector(loadAllData) withObject:nil afterDelay:0.0];
	[[DataController sharedDataController] loadAllData];
	
	[[self window] setFrame:[[UIScreen mainScreen] bounds]];
	[[self window] makeKeyAndVisible];

//	if (launchOptions != nil)
//	{
//		NSURL *launchURL = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
//		
//		if (launchURL != nil)
//		{
//			[self processLaunchURL:launchURL];
//		}
//	}
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if ([userDefaults btiIsScreenLockEnabled])
	{
		[self showScreenLock];
	}
	
	// START Dropbox
	
	DBSession *dbSession = [[[DBSession alloc] initWithAppKey:kDropboxAppKey
													appSecret:kDropboxAppSecret
														 root:kDBRootDropbox] // either kDBRootAppFolder or kDBRootDropbox
							autorelease];
	[DBSession setSharedSession:dbSession];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);



	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if ([userDefaults btiIsScreenLockEnabled])
	{
		[self showScreenLock];
	}
	
	DataController *dataController = [DataController sharedDataController];
	
	if ([dataController isImageCleanupEnabled])
	{
		[dataController purgeUnusedMediaInfos];
	
		[dataController saveAllData];
		
		ivBackgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^{
			// Clean up any unfinished task business by marking where you.
			// stopped or ending the task outright.
			[application endBackgroundTask:ivBackgroundTaskIdentifier];
			ivBackgroundTaskIdentifier = UIBackgroundTaskInvalid;
		}];
		
		// Start the long-running task and return immediately.
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			
			// Do the work associated with the task, preferably in chunks.
			NSFileManager *fileManager = [[NSFileManager alloc] init];
			
			NSSet *protectedImageNames = [NSSet setWithObjects:kUserLogoImageFileName, nil];
			
			NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
			[context setPersistentStoreCoordinator:[dataController persistentStoreCoordinator]];
			
			NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
			[fetchRequest setEntity:[MediaInfo entityDescriptionInContextBTI:context]];
			
			NSString *imageDirectory = [dataController imageDirectory];
			
			NSArray *imageFiles = [fileManager contentsOfDirectoryAtPathBTI:imageDirectory];
			NSArray *matchingImageFileNames = [imageFiles pathsMatchingExtensions:[NSArray arrayWithObject:@"jpg"]];
			
			for (NSString *fileName in matchingImageFileNames)
			{
				if ([protectedImageNames containsObject:fileName])
					continue;
				
				[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"fileName == %@", fileName]];
				
				NSArray *mediaInfos = [context executeFetchRequestBTI:fetchRequest];
				
				if ( (mediaInfos == nil) || ([mediaInfos count] != 0) )
					continue;
				
				NSString *path = [imageDirectory stringByAppendingPathComponent:fileName];
				NSLog(@"path is: %@", path);
				
				if ([fileManager fileExistsAtPath:path])
				{
					[fileManager removeItemAtPathBTI:path];
				}
			}
			
			[context release], context = nil;
			[fetchRequest release], fetchRequest = nil;
			[fileManager release], fileManager = nil;
			
			[application endBackgroundTask:ivBackgroundTaskIdentifier];
			ivBackgroundTaskIdentifier = UIBackgroundTaskInvalid;
		});
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if ([userDefaults btiIsScreenLockEnabled])
	{
		[self showScreenLock];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Notification Handlers

- (void)shouldShowCSVImporter:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	// Deliberately blank.  Subclasses should override

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (void)processLaunchURL:(NSURL *)url
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (!url) 
	{
		NSLog(@"<<< Leaving %s >>> Early: no URL", __PRETTY_FUNCTION__);
		return; 
	}
	
	// On iPhone 4 (OS 4?) if the app is newly launched (not already running) via an email attachment, both didFinishLaunching AND handleOpenURL fire.
	// The first pass will delete the file, so check to see if the file is still there before attempting to process.
	if ([url isFileURL])						
	{
		NSString *launchFilePath = [url path];
		NSLog(@"launchFilePath is: %@", launchFilePath);
		
		DataController *dataController = [DataController sharedDataController];
		
		if ([dataController importedFilePath] == nil)
		{
			[dataController processImportedFileAtPath:launchFilePath];
		}
		
		NSLog(@"<<< Leaving %s >>> EARLY - File from email", __PRETTY_FUNCTION__);
		return;
	}
	
	if ( (![[url scheme] isEqualToString:kNativeFileExtension]) && (![[url scheme] isEqualToString:kNativeFileExtension_OBSOLETE]) )
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Format Error"
														message:@"Something is wrong with this file. Make sure you have updated both the Lite app and Pro app to the latest version."
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release], alert = nil;
		
		NSLog(@"<<< Leaving %s >>> Early: wrong URL", __PRETTY_FUNCTION__);
		return; 
	}
	
	NSLog(@"absoluteString is: %@", [url absoluteString]);
	NSLog(@"parameterString is: %@", [url parameterString]);
	NSLog(@"baseURL is: %@", [url baseURL]);
	NSLog(@"fragment is: %@", [url fragment]);
	NSLog(@"scheme is: %@", [url scheme]); // This should be "idiscipline"
	NSLog(@"path is: %@", [url path]);
	NSLog(@"query is: %@", [url query]);
	
	DataController *dataController = [DataController sharedDataController];
	
	NSString *query = [url query];
	NSData *importUrlData = [GTMBase64 webSafeDecodeString:query];
	
	NSString *extension = nil;
	if ([[url scheme] isEqualToString:kNativeFileExtension])
		extension = kNativeFileExtension;
	else if ([[url scheme] isEqualToString:kNativeFileExtension_OBSOLETE])
		extension = kNativeFileExtension_OBSOLETE;
	
	NSString *path = [[dataController documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"upgrade_data.%@", extension]];
	[importUrlData writeToFile:path atomically:YES];
	
	[dataController processImportedFileAtPath:path];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)showScreenLock
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Deliberately blank.  Subclasses should override
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

// http://blog.mugunthkumar.com/coding/iphone-tutorial-better-way-to-check-capabilities-of-ios-devices/
+ (BOOL)isRetinaDisplay
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	BOOL isRetina = NO;
	
	int scale = 1.0;
	UIScreen *screen = [UIScreen mainScreen];
	if([screen respondsToSelector:@selector(scale)])
		scale = screen.scale;
	
	if (scale == 2.0f)
	{
		isRetina = YES;
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return isRetina;
}

- (void)jumpButtonPressed
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Deliberately blank.  Subclasses should override
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)emailBlastButtonPressed
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Deliberately blank.  Subclasses should override
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
