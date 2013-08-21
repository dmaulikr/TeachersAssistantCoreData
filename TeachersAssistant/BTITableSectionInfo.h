//
//  BTITableSectionInfo.h
//  SlickShopper2
//
//  Created by Brian Slick on 4/12/11.
//  Copyright 2010 BriTer Ideas LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BTITableSectionInfo : NSObject <NSFetchedResultsSectionInfo>
{
}

// Properties
// NSFetchedResultsSectionInfo Protocol
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *indexTitle;
@property (nonatomic, readonly) NSUInteger numberOfObjects;
@property (nonatomic, readonly) NSArray *objects;

// Custom Public Properties
@property (nonatomic, copy) NSString *sectionIdentifier;
@property (nonatomic, copy) NSString *sectionName;
@property (nonatomic, copy) NSString *sectionIndexTitle;

// Misc Methods
- (void)resetAllValues;

// Content Methods
- (void)addObjectToContents:(id)newObject;
- (void)addObjectsToContents:(NSSet *)newObjects;
- (void)insertObjectInContents:(id)newObject atIndex:(NSUInteger)index;
- (void)removeObjectFromContents:(id)oldObject;
- (void)moveObjectInContentsFromIndex:(NSUInteger)fromIndex
							  toIndex:(NSUInteger)toIndex;
- (void)removeAllObjectsInContents;
- (NSUInteger)countOfContents;
- (NSUInteger)indexOfObjectInContents:(id)object;
- (NSEnumerator *)contentsEnumerator;
- (id)objectInContentsAtIndex:(NSUInteger)index;
- (BOOL)contentsContainsObject:(id)anObject;
- (void)sortContentsUsingDescriptors:(NSArray *)descriptors;

@end
