//
//  GradingPeriod.m
//  TeachersAssistant
//
//  Created by Brian Slick on 1/31/12.
//  Copyright 2012 BriTer Ideas LLC. All rights reserved.
//

#import "GradingPeriod.h"

// Models and other global

// Private Constants

@interface GradingPeriod ()

// Private Properties


// Misc Methods

@end

@implementation GradingPeriod

#pragma mark - Synthesized Properties

// Public
@synthesize name = ivName;
@synthesize startDate = ivStartDate;
@synthesize endDate = ivEndDate;
@synthesize sortOrder = ivSortOrder;
@synthesize selected = ivSelected;


// Private

#pragma mark - Dealloc and Memory Management

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// Public Properties
    [self setName:nil];
    [self setStartDate:nil];
    [self setEndDate:nil];
    [self setSortOrder:nil];
	
	
	// Private Properties
	
	
	[super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

- (NSString *)description
{
	NSMutableString *string = [NSMutableString string];
	
	[string appendString:@"\nGradingPeriod object has the following properties:\n"];
	
	[string appendFormat:@"sortOrder: %@\n", [self sortOrder]];
	[string appendFormat:@"startDate: %@\n", [self startDate]];
	[string appendFormat:@"endDate: %@\n", [self endDate]];
	[string appendFormat:@"name: %@\n", [self name]];
	
	return string;                                                          
}

#pragma mark - Initialization

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
	
	GradingPeriod *copy = [[[self class] allocWithZone:zone] init];
	//[copy setProperty: [self property]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return copy;
}

//- (BOOL)isEqual:(id)object
//{
//	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
//
//	GradingPeriod *comparisonPeriod = (GradingPeriod *)object;
//	
//	BOOL isNameEqual = [[self name] isEqualToString:[comparisonPeriod name]];
//	BOOL isStartEqual = [[self startDate] isEqualToDate:[comparisonPeriod startDate]];
//	BOOL isEndEqual = [[self endDate] isEqualToDate:[comparisonPeriod endDate]];
//	BOOL isSortEqual = [[self sortOrder] isEqualToNumber:[comparisonPeriod sortOrder]];
//	BOOL isSelectedEqual = ([self isSelected] == [comparisonPeriod isSelected]);
//
//	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
//	return (isNameEqual && isStartEqual && isEndEqual && isSortEqual && isSelectedEqual);
//}
//
//- (NSUInteger)hash
//{
//	return [[self name] hash] + [[self startDate] hash] + [[self endDate] hash];
//}

#pragma mark - Saving and Loading Methods

- (id)attributes
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
	
	if ([self name] != nil)
		[dictionary setObject:[self name] forKey:kGradingPeriodNameKey];
	
	if ([self startDate] != nil)
		[dictionary setObject:[self startDate] forKey:kGradingPeriodStartDateKey];
	
	if ([self endDate] != nil)
		[dictionary setObject:[self endDate] forKey:kGradingPeriodEndDateKey];
	
	if ([self sortOrder] != nil)
		[dictionary setObject:[self sortOrder] forKey:kGradingPeriodSortOrderKey];
	
	
	[dictionary setObject:[NSNumber numberWithBool:[self isSelected]] forKey:kGradingPeriodSelectedKey];
	
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
		
		NSString *loadName = [dictionary objectForKey:kGradingPeriodNameKey];
		if (loadName != nil)
			[self setName:loadName];
		
		NSDate *loadStart = [dictionary objectForKey:kGradingPeriodStartDateKey];
		if (loadStart != nil)
			[self setStartDate:loadStart];
		
		NSDate *loadEnd = [dictionary objectForKey:kGradingPeriodEndDateKey];
		if (loadEnd != nil)
			[self setEndDate:loadEnd];
		
		NSNumber *loadSort = [dictionary objectForKey:kGradingPeriodSortOrderKey];
		if (loadSort != nil)
			[self setSortOrder:loadSort];
		
		NSNumber *loadSelected = [dictionary objectForKey:kGradingPeriodSelectedKey];
		if (loadSelected != nil)
			[self setSelected:[loadSelected boolValue]];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return self;
}

#pragma mark - Misc Methods

- (BOOL)isDateInRange:(NSDate *)date
{
//	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);


//	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ( ([date compare:[self startDate]] != NSOrderedAscending) && ([date compare:[self endDate]] != NSOrderedDescending) );
}


@end
