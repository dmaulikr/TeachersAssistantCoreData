//
//  EmailAddress+BTIAdditions.m
//  TeachersAssistant
//
//  Created by Brian Slick on 10/6/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "EmailAddress+BTIAdditions.h"

@implementation EmailAddress (EmailAddress_BTIAdditions)

- (NSDictionary *)exchangeAttributes
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSMutableDictionary *returnAttributes = [NSMutableDictionary dictionary];
	
	[returnAttributes addEntriesFromDictionary:[super exchangeAttributes]];

	if ([self type] != nil)
		[returnAttributes setObject:[self type] forKey:kTYPE];
	
	if ([self value] != nil)
		[returnAttributes setObject:[self value] forKey:kVALUE];
	
	if ([self isDefault] != nil)
		[returnAttributes setObject:[self isDefault] forKey:kIS_DEFAULT];
	
	if ([self parent] != nil)
		[returnAttributes setObject:[[self parent] exchangeIdentifier] forKey:kPARENT];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return returnAttributes;
}

- (void)populateAttributesWithExchangeAttributes:(NSDictionary *)attributes
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super populateAttributesWithExchangeAttributes:attributes];
	
	[self setType:[attributes objectForKey:kTYPE]];
	
	[self setValue:[attributes objectForKey:kVALUE]];
	
	[self setIsDefault:[attributes objectForKey:kIS_DEFAULT]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)populateChildRelationshipsWithExchangeAttributes:(NSDictionary *)attributes
										   rootPredicate:(NSPredicate *)predicate
											fetchRequest:(NSFetchRequest *)fetchRequest
											   variables:(NSMutableDictionary *)variables
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// There are no child relationships
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
