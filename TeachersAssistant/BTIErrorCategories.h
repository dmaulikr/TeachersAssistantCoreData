//
//  BTIErrorCategories.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/21/12.
//  Copyright (c) 2012 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#pragma mark - NSFetchedResultsController Categories

@interface NSFetchedResultsController (BTIErrorAdditions)

- (BOOL)performFetchBTI;

@end

#pragma mark - NSFileManager Categories

@interface NSFileManager (BTIErrorAdditions)

- (NSArray *)contentsOfDirectoryAtPathBTI:(NSString *)path;
- (BOOL)createDirectoryAtPathBTI:(NSString *)path withIntermediateDirectories:(BOOL)createIntermediates attributes:(NSDictionary *)attributes;
- (BOOL)removeItemAtPathBTI:(NSString *)path;
- (BOOL)setAttributesBTI:(NSDictionary *)attributes ofItemAtPath:(NSString *)path;

@end

#pragma mark - NSManagedObjectContext Categories

@interface NSManagedObjectContext (BTIErrorAdditions)

- (NSUInteger)countForFetchRequestBTI:(NSFetchRequest *)fetchRequest;
- (NSArray *)executeFetchRequestBTI:(NSFetchRequest *)fetchRequest;
- (BOOL)saveBTI;

@end

#pragma mark - NSPersistentStoreCoordinator Categories

@interface NSPersistentStoreCoordinator (BTIErrorAdditions)

- (NSPersistentStore *)addPersistentStoreWithTypeBTI:(NSString *)storeType configuration:(NSString *)configuration URL:(NSURL *)storeURL options:(NSDictionary *)options;
- (BOOL)removePersistentStoreBTI:(NSPersistentStore *)store;

@end
