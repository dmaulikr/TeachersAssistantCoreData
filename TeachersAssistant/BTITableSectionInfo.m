//
//  BTITableSectionInfo.h
//  SlickShopper2
//
//  Created by Brian Slick on 4/12/11.
//  Copyright 2010 BriTer Ideas LLC. All rights reserved.
//

#import "BTITableSectionInfo.h"

@interface BTITableSectionInfo ()

@property (nonatomic, retain) NSMutableArray *contents;

@end


@implementation BTITableSectionInfo

#pragma mark -
#pragma mark Synthesized Properties

@synthesize name;
@synthesize indexTitle;
@synthesize numberOfObjects;
@synthesize objects;
@synthesize sectionIdentifier;
@synthesize sectionName;
@synthesize sectionIndexTitle;
@synthesize contents;

#pragma mark -
#pragma mark Dealloc and Memory Management

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [self setSectionIdentifier:nil];
    [self setSectionName:nil];
    [self setSectionIndexTitle:nil];
    [self setContents:nil];
	
	[super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark Custom Getters and Setters

- (NSString *)name
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self sectionName];
}

- (NSString *)indexTitle
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self sectionIndexTitle];
}

- (NSUInteger)numberOfObjects
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [[self contents] count];
}

- (NSArray *)objects
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self contents];
}

- (NSMutableArray *)contents
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (contents == nil)
	{
		contents = [[NSMutableArray alloc] init];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return contents;
}

#pragma mark -
#pragma mark Initialization

- (id)init
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (self = [super init])
	{
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return self;
}

#pragma mark -
#pragma mark Misc Methods

- (void)resetAllValues
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self setSectionIdentifier:nil];
	[self setSectionName:nil];
	[self setSectionIndexTitle:nil];
	[[self contents] removeAllObjects];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark Content Methods

- (void)addObjectToContents:(id)newObject
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (![[self contents] containsObject:newObject])
	{
		[[self contents] addObject:newObject];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)addObjectsToContents:(NSSet *)newObjects
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	for (id object in newObjects)
	{
		if (![[self contents] containsObject:object])
		{
			[[self contents] addObject:object];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)insertObjectInContents:(id)newObject
					   atIndex:(NSUInteger)index;
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self contents] insertObject:newObject atIndex:index];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)removeObjectFromContents:(id)oldObject
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self contents] removeObject:oldObject];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)moveObjectInContentsFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	id retainObject = [[[self contents] objectAtIndex:fromIndex] retain];
	
	[[self contents] removeObjectAtIndex:fromIndex];
	[[self contents] insertObject:retainObject atIndex:toIndex];

	[retainObject release], retainObject = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)removeAllObjectsInContents
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self contents] removeAllObjects];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSUInteger)countOfContents
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [[self contents] count];
}

- (NSUInteger)indexOfObjectInContents:(id)object
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [[self contents] indexOfObject:object];
}

- (NSEnumerator *)contentsEnumerator
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [[self contents] objectEnumerator];
}

- (id)objectInContentsAtIndex:(NSUInteger)index
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [[self contents] objectAtIndex:index];
}

- (BOOL)contentsContainsObject:(id)anObject
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ([[self contents] containsObject:anObject]);
}

- (void)sortContentsUsingDescriptors:(NSArray *)descriptors
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[self contents] sortUsingDescriptors:descriptors];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark Misc Methods

- (NSString *)description
{
	NSMutableString *string = [NSMutableString stringWithString:@"\n\nBTI_TableSectionInfo object has the following properties\n"];
	
	[string appendString:[NSString stringWithFormat:@"sectionIdentifier: %@", [self sectionIdentifier]]];
	[string appendString:[NSString stringWithFormat:@"name: %@", [self name]]];
	[string appendString:[NSString stringWithFormat:@"indexTitle: %@", [self indexTitle]]];
	[string appendString:[NSString stringWithFormat:@"contents: %@", [[self contents] description]]];
	
	return string;
}

@end
