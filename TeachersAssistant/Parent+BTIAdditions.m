//
//  Parent+BTIAdditions.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/25/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "Parent+BTIAdditions.h"

@implementation Parent (Parent_BTIAdditions)

- (EmailAddress *)primaryEmailAddress
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSArray *sortedEmails = [[self emailAddresses] sortedArrayUsingDescriptors:[[DataController sharedDataController] descriptorArrayForManualSortOrderSort]];
	
	EmailAddress *addressToReturn = nil;
	
	if ([sortedEmails count] > 0)
	{
		for (EmailAddress *emailAddress in sortedEmails)
		{
			if ([[emailAddress isDefault] boolValue])
			{
				addressToReturn = emailAddress;
				break;
			}
		}
		
		if (addressToReturn == nil)
		{
			addressToReturn = [sortedEmails objectAtIndex:0];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return addressToReturn;
}

- (PhoneNumber *)primaryPhoneNumber
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSArray *sortedPhoneNumbers = [[self phoneNumbers] sortedArrayUsingDescriptors:[[DataController sharedDataController] descriptorArrayForManualSortOrderSort]];
	
	PhoneNumber *phoneNumberToReturn = nil;
	
	if ([sortedPhoneNumbers count] > 0)
	{
		phoneNumberToReturn = [sortedPhoneNumbers objectAtIndex:0];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return phoneNumberToReturn;
}

- (NSDictionary *)exchangeAttributes
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSMutableDictionary *returnAttributes = [NSMutableDictionary dictionary];
	
	[returnAttributes addEntriesFromDictionary:[super exchangeAttributes]];
	
	if ([self name] != nil)
		[returnAttributes setObject:[self name] forKey:kNAME];
	
	if ([self student] != nil)
		[returnAttributes setObject:[[self student] exchangeIdentifier] forKey:kSTUDENT];
	
	NSMutableArray *emailAddressIdentifiers = [NSMutableArray array];
	for (PhoneNumber *emailAddress in [self emailAddresses])
	{
		[emailAddressIdentifiers addObject:[emailAddress exchangeIdentifier]];
	}
	[returnAttributes setObject:emailAddressIdentifiers forKey:kEMAIL_ADDRESSES];
	
	NSMutableArray *phoneNumberIdentifiers = [NSMutableArray array];
	for (PhoneNumber *phoneNumber in [self phoneNumbers])
	{
		[phoneNumberIdentifiers addObject:[phoneNumber exchangeIdentifier]];
	}
	[returnAttributes setObject:phoneNumberIdentifiers forKey:kPHONE_NUMBERS];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return returnAttributes;
}

- (void)populateAttributesWithExchangeAttributes:(NSDictionary *)attributes
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super populateAttributesWithExchangeAttributes:attributes];
	
	[self setName:[attributes objectForKey:kNAME]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)populateChildRelationshipsWithExchangeAttributes:(NSDictionary *)attributes
										   rootPredicate:(NSPredicate *)predicate
											fetchRequest:(NSFetchRequest *)fetchRequest
											   variables:(NSMutableDictionary *)variables
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSArray *emailAddressIdentifiers = [attributes objectForKey:kEMAIL_ADDRESSES];
	[fetchRequest setEntity:[EmailAddress entityDescriptionInContextBTI:context]];
	for (NSNumber *emailAddressIdentifier in emailAddressIdentifiers)
	{
		[variables setObject:emailAddressIdentifier forKey:kEXCHANGE_IDENTIFIER];
		NSPredicate *localPredicate = [predicate predicateWithSubstitutionVariables:variables];
		[fetchRequest setPredicate:localPredicate];
		
		[self addEmailAddressesObject:[[context executeFetchRequest:fetchRequest error:nil] lastObject]];
	}
	
	NSArray *phoneNumberIdentifiers = [attributes objectForKey:kPHONE_NUMBERS];
	[fetchRequest setEntity:[PhoneNumber entityDescriptionInContextBTI:context]];
	for (NSNumber *phoneNumberIdentifier in phoneNumberIdentifiers)
	{
		[variables setObject:phoneNumberIdentifier forKey:kEXCHANGE_IDENTIFIER];
		NSPredicate *localPredicate = [predicate predicateWithSubstitutionVariables:variables];
		[fetchRequest setPredicate:localPredicate];
		
		[self addPhoneNumbersObject:[[context executeFetchRequest:fetchRequest error:nil] lastObject]];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
