//
//  TermInfo+BTIAdditions.m
//  TeachersAssistant
//
//  Created by Brian Slick on 10/6/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "TermInfo+BTIAdditions.h"

@implementation TermInfo (TermInfo_BTIAdditions)

- (NSDictionary *)exchangeAttributes
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSMutableDictionary *returnAttributes = [NSMutableDictionary dictionary];
	
	[returnAttributes addEntriesFromDictionary:[super exchangeAttributes]];
	
	if ([self identifier] != nil)
		[returnAttributes setObject:[self identifier] forKey:kIDENTIFIER];
	
	if ([self defaultNameSingular] != nil)
		[returnAttributes setObject:[self defaultNameSingular] forKey:kDEFAULT_NAME_SINGULAR];
	
	if ([self defaultNamePlural] != nil)
		[returnAttributes setObject:[self defaultNamePlural] forKey:kDEFAULT_NAME_PLURAL];
	
	if ([self userNameSingular] != nil)
		[returnAttributes setObject:[self userNameSingular] forKey:kUSER_NAME_SINGULAR];
	
	if ([self userNamePlural] != nil)
		[returnAttributes setObject:[self userNamePlural] forKey:kUSER_NAME_PLURAL];
	
	if ([self actionFieldInfo] != nil)
		[returnAttributes setObject:[[self actionFieldInfo] exchangeIdentifier] forKey:kACTION_FIELD_INFO];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return returnAttributes;
}

- (void)populateAttributesWithExchangeAttributes:(NSDictionary *)attributes
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super populateAttributesWithExchangeAttributes:attributes];
	
	NSString *loadIdentifer = [attributes objectForKey:kIDENTIFIER];
	if (loadIdentifer != nil)
		[self setIdentifier:loadIdentifer];
	
	[self setDefaultNameSingular:[attributes objectForKey:kDEFAULT_NAME_SINGULAR]];
	
	[self setDefaultNamePlural:[attributes objectForKey:kDEFAULT_NAME_PLURAL]];
	
	[self setUserNameSingular:[attributes objectForKey:kUSER_NAME_SINGULAR]];
	
	[self setUserNamePlural:[attributes objectForKey:kUSER_NAME_PLURAL]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)populateChildRelationshipsWithExchangeAttributes:(NSDictionary *)attributes
										   rootPredicate:(NSPredicate *)predicate
											fetchRequest:(NSFetchRequest *)fetchRequest
											   variables:(NSMutableDictionary *)variables
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// No child relationships
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
