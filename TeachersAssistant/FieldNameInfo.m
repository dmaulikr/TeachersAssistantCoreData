//
//  FieldNameInfo.m
//  infraction
//
//  Created by Brian Slick on 3/5/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "FieldNameInfo.h"


@implementation FieldNameInfo

#pragma mark -
#pragma mark Synthesized Properties

@synthesize internalNameSingular = ivInternalNameSingular;
@synthesize internalNamePlural = ivInternalNamePlural;
@synthesize userNameSingular = ivUserNameSingular;
@synthesize userNamePlural = ivUserNamePlural;
@synthesize sortOrder = ivSortOrder;


#pragma mark -
#pragma mark Dealloc and Memory Management

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [ivInternalNameSingular release], ivInternalNameSingular = nil;
    [ivInternalNamePlural release], ivInternalNamePlural = nil;
    [ivUserNameSingular release], ivUserNameSingular = nil;
    [ivUserNamePlural release], ivUserNamePlural = nil;
    [ivSortOrder release], ivSortOrder = nil;
	
	[super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark Custom Getters and Setters

- (NSString *)description
{
	return [NSString stringWithFormat:@"\nFieldNameInfo object has the following properties\n InternalNameSingular: %@\n InternalNamePlural: %@\n UserNameSingular: %@\n UserNamePlural: %@\n SortOrder: %@\n", [self internalNameSingular], [self internalNamePlural], [self userNameSingular], [self userNamePlural], [self sortOrder]];                                                          
}

#pragma mark -
#pragma mark Initialization

- (id)init
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	self = [super init];
	if (self)
	{
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return self;
}

#pragma mark -
#pragma mark NSCopying Methods

- (id)copyWithZone:(NSZone *)zone
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	FieldNameInfo *copy = [[[self class] allocWithZone:zone] init];
	[copy setInternalNameSingular:[self internalNameSingular]];
	[copy setInternalNamePlural:[self internalNamePlural]];
	[copy setUserNameSingular:[self userNameSingular]];
	[copy setUserNamePlural:[self userNamePlural]];
	[copy setSortOrder:[self sortOrder]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return copy;
}

#pragma mark -
#pragma mark NSCoder Methods

- (void)encodeWithCoder:(NSCoder *)encoder
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[encoder encodeObject:[self internalNameSingular] forKey:kFieldNameInfoInternalSingularKey];
	[encoder encodeObject:[self internalNamePlural] forKey:kFieldNameInfoInternalPluralKey];
	[encoder encodeObject:[self userNameSingular] forKey:kFieldNameInfoUserSingularKey];
	[encoder encodeObject:[self userNamePlural] forKey:kFieldNameInfoUserPluralKey];
	[encoder encodeObject:[self sortOrder] forKey:kFieldNameInfoSortOrderKey];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (id)initWithCoder:(NSCoder *)decoder
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	self = [self init];
	
	if (self)
	{
		[self setInternalNameSingular:[decoder decodeObjectForKey:kFieldNameInfoInternalSingularKey]];
		[self setInternalNamePlural:[decoder decodeObjectForKey:kFieldNameInfoInternalPluralKey]];
		[self setUserNameSingular:[decoder decodeObjectForKey:kFieldNameInfoUserSingularKey]];
		[self setUserNamePlural:[decoder decodeObjectForKey:kFieldNameInfoUserPluralKey]];
		[self setSortOrder:[decoder decodeObjectForKey:kFieldNameInfoSortOrderKey]];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return self;
}

#pragma mark -
#pragma mark Saving and Loading Methods

- (id)attributes
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
	
	if ([self internalNameSingular] != nil)
		[dictionary setObject:[self internalNameSingular] forKey:kFieldNameInfoInternalSingularKey];
	
	if ([self internalNamePlural] != nil)
		[dictionary setObject:[self internalNamePlural] forKey:kFieldNameInfoInternalPluralKey];
	
	if ([self userNameSingular] != nil)
		[dictionary setObject:[self userNameSingular] forKey:kFieldNameInfoUserSingularKey];
	
	if ([self userNamePlural] != nil)
		[dictionary setObject:[self userNamePlural] forKey:kFieldNameInfoUserPluralKey];
	
	if ([self sortOrder] != nil)
		[dictionary setObject:[self sortOrder] forKey:kFieldNameInfoSortOrderKey];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [dictionary autorelease];
}

- (id)initWithAttributes:(id)attributes
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	self = [self init];
	if (self)
	{
		NSDictionary *dictionary = (NSDictionary *)attributes;
		
		NSString *loadInternalSingular = [dictionary objectForKey:kFieldNameInfoInternalSingularKey];
		if (loadInternalSingular != nil)
			[self setInternalNameSingular:loadInternalSingular];
		
		NSString *loadInternalPlural = [dictionary objectForKey:kFieldNameInfoInternalPluralKey];
		if (loadInternalPlural != nil)
			[self setInternalNamePlural:loadInternalPlural];
		
		NSString *loadUserSingular = [dictionary objectForKey:kFieldNameInfoUserSingularKey];
		if (loadUserSingular != nil)
			[self setUserNameSingular:loadUserSingular];
		
		NSString *loadUserPlural = [dictionary objectForKey:kFieldNameInfoUserPluralKey];
		if (loadUserPlural != nil)
			[self setUserNamePlural:loadUserPlural];
		
		NSNumber *loadSort = [dictionary objectForKey:kFieldNameInfoSortOrderKey];
		if (loadSort != nil)
			[self setSortOrder:loadSort];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return self;
}

#pragma mark -
#pragma mark Misc Methods

- (NSString *)singularName
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSString *singular = [self userNameSingular];
	
	if (singular == nil)
	{
		singular = [self internalNameSingular];
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return singular;
}

- (NSString *)pluralName
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *plural = [self userNamePlural];
	
	if (plural == nil)
	{
		plural = [self internalNamePlural];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return plural;
}

@end
