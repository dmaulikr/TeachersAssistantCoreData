//
//  CommonAttributes+BTIAdditions.m
//  TeachersAssistant
//
//  Created by Brian Slick on 10/7/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "CommonAttributes+BTIAdditions.h"

@implementation CommonAttributes (CommonAttributes_BTIAdditions)

- (NSDictionary *)exchangeAttributes
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	// Subclasses should call super, and add this dictionary's contents to their own
	
	NSMutableDictionary *returnAttributes = [NSMutableDictionary dictionary];

	[returnAttributes setObject:[self exchangeIdentifier] forKey:kEXCHANGE_IDENTIFIER];
	
	if ([self sortOrder] != nil)
		[returnAttributes setObject:[self sortOrder] forKey:kSORT_ORDER];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return returnAttributes;
}

- (void)populateAttributesWithExchangeAttributes:(NSDictionary *)attributes
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self setExchangeIdentifier:[attributes objectForKey:kEXCHANGE_IDENTIFIER]];
	
	[self setSortOrder:[attributes objectForKey:kSORT_ORDER]];
	
	// Subclasses should handle individual attributes
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)populateChildRelationshipsWithExchangeAttributes:(NSDictionary *)attributes
										   rootPredicate:(NSPredicate *)predicate
											fetchRequest:(NSFetchRequest *)fetchRequest
											   variables:(NSMutableDictionary *)variables
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Default does nothing, subclasses should override.
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
