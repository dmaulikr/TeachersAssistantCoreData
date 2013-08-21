//
//  ActionFieldInfo+BTIAdditions.m
//  TeachersAssistant
//
//  Created by Brian Slick on 10/2/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ActionFieldInfo+BTIAdditions.h"

@implementation ActionFieldInfo (ActionFieldInfo_BTIAdditions)

- (PickerValue *)pickerValueWithName:(NSString *)name
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	PickerValue *pickerValueToReturn = nil;

	for (PickerValue *pickerValue in [self pickerValues])
	{
		if ([name isEqualToString:[pickerValue name]])
		{
			pickerValueToReturn = pickerValue;
			break;
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return pickerValueToReturn;
}

- (NSDictionary *)exchangeAttributes
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSMutableDictionary *returnAttributes = [NSMutableDictionary dictionary];
	
	[returnAttributes addEntriesFromDictionary:[super exchangeAttributes]];
	
	if ([self isHidden] != nil)
		[returnAttributes setObject:[self isHidden] forKey:kIS_HIDDEN];
	
	if ([self identifier] != nil)
		[returnAttributes setObject:[self identifier] forKey:kIDENTIFIER];
	
	if ([self type] != nil)
		[returnAttributes setObject:[self type] forKey:kTYPE];
	
	if ([self isUserCreated] != nil)
		[returnAttributes setObject:[self isUserCreated] forKey:kIS_USER_CREATED];
	
	if ([self termInfo] != nil)
		[returnAttributes setObject:[[self termInfo] exchangeIdentifier] forKey:kTERM_INFO];
	
	NSMutableArray *actionValueIdentifiers = [NSMutableArray array];
	for (ActionValue *actionValue in [self actionValues])
	{
		[actionValueIdentifiers addObject:[actionValue exchangeIdentifier]];
	}
	[returnAttributes setObject:actionValueIdentifiers forKey:kACTION_VALUES];
	
	NSMutableArray *pickerValueIdentifiers = [NSMutableArray array];
	for (PickerValue *pickerValue in [self pickerValues])
	{
		[pickerValueIdentifiers addObject:[pickerValue exchangeIdentifier]];
	}
	[returnAttributes setObject:pickerValueIdentifiers forKey:kPICKER_VALUES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return returnAttributes;
}

- (void)populateAttributesWithExchangeAttributes:(NSDictionary *)attributes
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super populateAttributesWithExchangeAttributes:attributes];
	
	[self setIsHidden:[attributes objectForKey:kIS_HIDDEN]];
	
	NSString *loadIdentifer = [attributes objectForKey:kIDENTIFIER];
	if (loadIdentifer != nil)
		[self setIdentifier:loadIdentifer];
	
	[self setType:[attributes objectForKey:kTYPE]];
	
	[self setIsUserCreated:[attributes objectForKey:kIS_USER_CREATED]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)populateChildRelationshipsWithExchangeAttributes:(NSDictionary *)attributes
										   rootPredicate:(NSPredicate *)predicate
											fetchRequest:(NSFetchRequest *)fetchRequest
											   variables:(NSMutableDictionary *)variables
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSArray *actionValueIdentifiers = [attributes objectForKey:kACTION_VALUES];
	[fetchRequest setEntity:[ActionValue entityDescriptionInContextBTI:context]];
	for (NSNumber *actionValueIdentifier in actionValueIdentifiers)
	{
		[variables setObject:actionValueIdentifier forKey:kEXCHANGE_IDENTIFIER];
		NSPredicate *localPredicate = [predicate predicateWithSubstitutionVariables:variables];
		[fetchRequest setPredicate:localPredicate];
		
		[self addActionValuesObject:[[context executeFetchRequest:fetchRequest error:nil] lastObject]];
	}
	
	NSArray *pickerValueIdentifiers = [attributes objectForKey:kPICKER_VALUES];
	[fetchRequest setEntity:[PickerValue entityDescriptionInContextBTI:context]];
	for (NSNumber *pickerValueIdentifier in pickerValueIdentifiers)
	{
		[variables setObject:pickerValueIdentifier forKey:kEXCHANGE_IDENTIFIER];
		NSPredicate *localPredicate = [predicate predicateWithSubstitutionVariables:variables];
		[fetchRequest setPredicate:localPredicate];
		
		[self addPickerValuesObject:[[context executeFetchRequest:fetchRequest error:nil] lastObject]];
	}
	
	NSNumber *termInfoIdentifier = [attributes objectForKey:kTERM_INFO];
	if (termInfoIdentifier != nil)
	{
		[fetchRequest setEntity:[TermInfo entityDescriptionInContextBTI:context]];
		
		[variables setObject:termInfoIdentifier forKey:kEXCHANGE_IDENTIFIER];
		NSPredicate *localPredicate = [predicate predicateWithSubstitutionVariables:variables];
		[fetchRequest setPredicate:localPredicate];
		
		[self setTermInfo:[[context executeFetchRequest:fetchRequest error:nil] lastObject]];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
