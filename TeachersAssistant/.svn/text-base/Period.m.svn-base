//
//  Period.m
//  infraction
//
//  Created by Brian Slick on 7/18/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "Period.h"

// Models and other global

// Private Constants

@interface Period ()

// Private Properties


// Misc Methods

@end

@implementation Period

#pragma mark -
#pragma mark Synthesized Properties

// Public
@synthesize name = ivName;
@synthesize sortOrder = ivSortOrder;

// Private

#pragma mark -
#pragma mark Dealloc and Memory Management

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// Public Properties
	[self setName:nil];
	[self setSortOrder:nil];
	
	// Private Properties
	
	
	[super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark Custom Getters and Setters

- (NSString *)description
{
	NSMutableString *string = [NSMutableString string];
	
	[string appendString:@"\nPeriod object has the following properties:\n"];
	
	[string appendString:[NSString stringWithFormat:@" name: %@\n", [self name]]];
	[string appendString:[NSString stringWithFormat:@" sortOrder: %@\n", [self sortOrder]]];

	return string;                                                          
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

- (id)copyWithZone:(NSZone *)zone
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	Period *copyOfPeriod = [[[self class] allocWithZone:zone] init];
	
	[copyOfPeriod setName:[self name]];
	[copyOfPeriod setSortOrder:[self sortOrder]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return copyOfPeriod;
}

#pragma mark -
#pragma mark NSCoder Methods

- (void)encodeWithCoder:(NSCoder *)encoder
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[encoder encodeObject:[self name] forKey:kPeriodNameKey];
	[encoder encodeObject:[self sortOrder] forKey:kPeriodSortOrderKey];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (id)initWithCoder:(NSCoder *)decoder
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	self = [super init];
	if (self)
	{
		[self setName:[decoder decodeObjectForKey:kPeriodNameKey]];
		[self setSortOrder:[decoder decodeObjectForKey:kPeriodSortOrderKey]];
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
	
	if ([self name] != nil)
		[dictionary setObject:[self name] forKey:kPeriodNameKey];
	
	if ([self sortOrder] != nil)
		[dictionary setObject:[self sortOrder] forKey:kPeriodSortOrderKey];
	
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
		
		NSString *loadName = [dictionary objectForKey:kPeriodNameKey];
		if (loadName != nil)
			[self setName:loadName];
		
		NSNumber *loadSortOrder = [dictionary objectForKey:kPeriodSortOrderKey];
		if (loadSortOrder != nil)
			[self setSortOrder:loadSortOrder];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return self;
}

#pragma mark -
#pragma mark Misc Methods




@end
