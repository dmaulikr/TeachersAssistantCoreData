//
//  BTIErrorCategories.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/21/12.
//  Copyright (c) 2012 BriTer Ideas LLC. All rights reserved.
//

#import "BTIErrorCategories.h"

#pragma mark - NSFetchedResultsController Categories

@implementation NSFetchedResultsController (BTIErrorAdditions)

- (BOOL)performFetchBTI
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSError *error;
	BOOL isFetchSuccessful = [self performFetch:&error];
	if (!isFetchSuccessful)
	{
		NSLog(@"ERROR: Perform Fetch: %@", [error localizedDescription]);
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return isFetchSuccessful;
}

@end

#pragma mark - NSFileManager Categories

@implementation NSFileManager (BTIErrorAdditions)

- (NSArray *)contentsOfDirectoryAtPathBTI:(NSString *)path
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSError *error;
	NSArray *contents = [self contentsOfDirectoryAtPath:path error:&error];
	if (contents == nil)
	{
		NSLog(@"ERROR: Contens of directory: %@", [error localizedDescription]);
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return contents;
}

- (BOOL)createDirectoryAtPathBTI:(NSString *)path
	 withIntermediateDirectories:(BOOL)createIntermediates
					  attributes:(NSDictionary *)attributes
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSError *error;
	BOOL isCreateSuccessful = [self createDirectoryAtPath:path
							  withIntermediateDirectories:YES
											   attributes:nil
													error:&error];
	if (!isCreateSuccessful)
	{
		NSLog(@"ERROR: Create directory: %@", [error localizedDescription]);
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return isCreateSuccessful;
}

- (BOOL)removeItemAtPathBTI:(NSString *)path
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSError *error;
	BOOL isRemoveSuccessful = [self removeItemAtPath:path error:&error];
	if (!isRemoveSuccessful)
	{
		NSLog(@"ERROR: Remove Item: %@", [error localizedDescription]);
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return isRemoveSuccessful;
}

- (BOOL)setAttributesBTI:(NSDictionary *)attributes
			ofItemAtPath:(NSString *)path
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSError *error;
	BOOL isAttributeSuccessful = [self setAttributes:attributes
										ofItemAtPath:path
											   error:&error];
	if (!isAttributeSuccessful)
	{
		NSLog(@"ERROR: Add file attributes: %@", [error localizedDescription]);
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return isAttributeSuccessful;
}

@end

#pragma mark - NSManagedObjectContext Categories

@implementation NSManagedObjectContext (BTIErrorAdditions)

- (NSUInteger)countForFetchRequestBTI:(NSFetchRequest *)fetchRequest
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSError *error;
	NSUInteger count = [self countForFetchRequest:fetchRequest error:&error];
	if (count == NSNotFound)
	{
		NSLog(@"ERROR: Fetch Request Count: %@", [error localizedDescription]);
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return count;
}

- (NSArray *)executeFetchRequestBTI:(NSFetchRequest *)fetchRequest
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSError *error;
	NSArray *objects = [self executeFetchRequest:fetchRequest error:&error];
	if (objects == nil)
	{
		NSLog(@"ERROR: Fetch Request: %@", [error localizedDescription]);
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return objects;
}

- (BOOL)saveBTI
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	// http://stackoverflow.com/questions/1283960/iphone-core-data-unresolved-error-while-saving
	
	NSError *error;
	BOOL isSaveSuccessful = [self save:&error];
	if (!isSaveSuccessful)
	{
		NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
		NSArray *detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
		if (detailedErrors != nil && [detailedErrors count] > 0)
		{
			for (NSError *detailedError in detailedErrors)
			{
				NSLog(@"  DetailedError: %@", [detailedError userInfo]);
			}
		}
		else
		{
			NSLog(@"  %@", [error userInfo]);
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return isSaveSuccessful;
}

@end

#pragma mark - NSPersistentStoreCoordinator Categories

@implementation NSPersistentStoreCoordinator (BTIErrorAdditions)

- (NSPersistentStore *)addPersistentStoreWithTypeBTI:(NSString *)storeType
									   configuration:(NSString *)configuration
												 URL:(NSURL *)storeURL
											 options:(NSDictionary *)options
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSError *error;
	NSPersistentStore *store = [self addPersistentStoreWithType:storeType
												  configuration:configuration
															URL:storeURL
														options:options
														  error:&error];
	if (store == nil)
	{
		NSLog(@"ERROR: Add persistent store: %@", [error localizedDescription]);
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return store;
}

- (BOOL)removePersistentStoreBTI:(NSPersistentStore *)store
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSError *error;
	BOOL isRemoveSuccessful = [self removePersistentStore:store error:&error];
	if (!isRemoveSuccessful)
	{
		NSLog(@"ERROR: Remove persistent store: %@", [error localizedDescription]);
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return isRemoveSuccessful;
}

@end
