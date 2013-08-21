//
//  ActionValue+BTIAdditions.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/15/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ActionValue+BTIAdditions.h"

//@interface ActionValue ()
//
//- (NSString *)textValueFromDate;
//- (NSString *)textValueFromPickerValues;
//
//@end

@implementation ActionValue (ActionValue_BTIAdditions)

- (NSString *)labelText
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSString *textToReturn = nil;

	NSInteger valueType = [[[self actionFieldInfo] type] intValue];
	
	switch (valueType) {
		case BTIActionFieldValueTypeDate:
		{
			textToReturn = [self textValueFromDate];
		}
			break;
		case BTIActionFieldValueTypePicker:
		{
			textToReturn = [self textValueFromPickerValues];
		}
			break;
		case BTIActionFieldValueTypeLongText:
		{
			textToReturn = [self longText];
		}
			break;
		case BTIActionFieldValueTypeBoolean:
		{
			textToReturn = ([[self boolean] boolValue]) ? @"Yes" : @"No";
		}
			break;
		case BTIActionFieldValueTypeColor:
		{
			textToReturn = [[self colorInfo] name];
		}
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return textToReturn;
}

- (NSString *)filterLabelText
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *textToReturn = nil;
	
	NSInteger valueType = [[[self actionFieldInfo] type] intValue];
	
	switch (valueType) {
		case BTIActionFieldValueTypeDate:
		{
			NSString *fromDateString = [NSDateFormatter localizedStringFromDate:[self filterFromDate] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
			NSString *toDateString = [NSDateFormatter localizedStringFromDate:[self filterToDate] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
			textToReturn = [NSString stringWithFormat:@"%@ - %@", fromDateString, toDateString];
		}
			break;
		case BTIActionFieldValueTypePicker:
		{
			textToReturn = [self labelText];
		}
			break;
		case BTIActionFieldValueTypeLongText:
		{
			textToReturn = [self labelText];
		}
			break;
		case BTIActionFieldValueTypeBoolean:
		{
			textToReturn = [self labelText];
		}
			break;
		case BTIActionFieldValueTypeColor:
		{
			textToReturn = [self labelText];
		}
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return textToReturn;
}

- (NSString *)textValueFromDate
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);


	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [NSDateFormatter localizedStringFromDate:[self date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *)textValueFromPickerValues
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSArray *sortedPickerValues = [[self pickerValues] sortedArrayUsingDescriptors:[[DataController sharedDataController] descriptorArrayForNameAlphabeticSort]];
	
	NSArray *names = [sortedPickerValues valueForKey:@"name"];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [names componentsJoinedByString:kValueDelimiter];
}

- (NSString *)summaryStringForEmail
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	DataController *dataController = [DataController sharedDataController];
	
	NSInteger type = [[[self actionFieldInfo] type] integerValue];
	
	if ( (type == BTIActionFieldValueTypeAudio) || (type == BTIActionFieldValueTypeImage) || (type == BTIActionFieldValueTypeVideo) )
	{
		NSLog(@"<<< Leaving %s >>> EARLY - not a supported data type", __PRETTY_FUNCTION__);
		return nil;
	}
	
	if ( (type == BTIActionFieldValueTypeColor) && ([self colorInfo] == nil) )
	{
		NSLog(@"<<< Leaving %s >>> EARLY - there is no color", __PRETTY_FUNCTION__);
		return nil;
	}
	
	NSMutableString *string = [NSMutableString string];
	
	NSString *description = [dataController singularNameForTermInfo:[[self actionFieldInfo] termInfo]];
	
	if (type == BTIActionFieldValueTypePicker)
	{
		if ([[self pickerValues] count] == 0)
		{
			NSLog(@"<<< Leaving %s >>> EARLY - No values", __PRETTY_FUNCTION__);
			return nil;
		}
		
		if ([[self pickerValues] count] > 1)
		{
			description = [dataController pluralNameForTermInfo:[[self actionFieldInfo] termInfo]];
		}
	}
	else if (type == BTIActionFieldValueTypeLongText)
	{
		if ( ([self longText] == nil) || ([[self longText] length] == 0) )
		{
			NSLog(@"<<< Leaving %s >>> EARLY - No text", __PRETTY_FUNCTION__);
			return nil;
		}
	}

	[string appendString:description];
	[string appendString:@": "];
	
	if (type == BTIActionFieldValueTypePicker)
	{
		NSArray *sortedPickerValues = [[self pickerValues] sortedArrayUsingDescriptors:[[DataController sharedDataController] descriptorArrayForNameAlphabeticSort]];
		
		NSMutableArray *values = [NSMutableArray array];
		
		for (PickerValue *pickerValue in sortedPickerValues)
		{
			NSMutableString *text = [NSMutableString string];
			
			NSString *name = [pickerValue name];
			if (name != nil)
			{
				[text appendString:name];
			}
			
			ColorInfo *colorInfo = [pickerValue colorInfo];
			if (colorInfo != nil)
			{
				[text appendString:@" ("];
				
				NSNumber *pointValue = [colorInfo pointValue];
				NSString *points = [NSNumberFormatter localizedStringFromNumber:pointValue numberStyle:NSNumberFormatterDecimalStyle];
				
				if ( ([pointValue integerValue] == 1) || ([pointValue integerValue] == -1) )
				{
					[text appendFormat:@"%@ point", points];
				}
				else
				{
					[text appendFormat:@"%@ points", points];
				}
				
				NSString *colorName = [colorInfo name];
				if (colorName == nil)
				{
					[text appendString:@")"];
				}
				else
				{
					[text appendFormat:@", %@)", colorName];
				}
			}
			
			[values addObject:text];
		}
		
		[string appendString:[values componentsJoinedByString:kValueDelimiter]];
	}
	else
	{
		NSString *text = [self labelText];
		if (text != nil)
		{
			[string appendString:text];
		}
	}
	
	[string appendString:@"\n"];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return string;
}

- (NSString *)summaryStringForPrinting
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);


	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [[self summaryStringForEmail] stringByAppendingString:@"\n"];
}

- (NSDictionary *)exchangeAttributes
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSMutableDictionary *returnAttributes = [NSMutableDictionary dictionary];
	
	NSLog(@"Internal attributes: \n\n%@\n\n", [[self entity] attributesByName]);
	NSLog(@"Internal relationships: \n\n%@\n\n", [[self entity] relationshipsByName]);
	
	[returnAttributes addEntriesFromDictionary:[super exchangeAttributes]];
	
	if ([self filterToDate] != nil)
		[returnAttributes setObject:[self filterToDate] forKey:kFILTER_TO_DATE];
	
	if ([self longText] != nil)
		[returnAttributes setObject:[self longText] forKey:kLONG_TEXT];
	
	if ([self filterFromDate] != nil)
		[returnAttributes setObject:[self filterFromDate] forKey:kFILTER_FROM_DATE];
	
	if ([self date] != nil)
		[returnAttributes setObject:[self date] forKey:kDATE];
	
	if ([self boolean] != nil)
		[returnAttributes setObject:[self boolean] forKey:kBOOLEAN];
	
	if ([self imageMediaInfo] != nil)
		[returnAttributes setObject:[[self imageMediaInfo] exchangeIdentifier] forKey:kIMAGE_MEDIA_INFO];
	
	if ([self actionFieldInfo] != nil)
		[returnAttributes setObject:[[self actionFieldInfo] exchangeIdentifier] forKey:kACTION_FIELD_INFO];
	
	if ([self videoMediaInfo] != nil)
		[returnAttributes setObject:[[self videoMediaInfo] exchangeIdentifier] forKey:kVIDEO_MEDIA_INFO];
	
	if ([self action] != nil)
		[returnAttributes setObject:[[self action] exchangeIdentifier] forKey:kACTION];
	
	if ([self colorInfo] != nil)
		[returnAttributes setObject:[[self colorInfo] exchangeIdentifier] forKey:kCOLOR_INFO];
	
	if ([self audioMediaInfo] != nil)
		[returnAttributes setObject:[[self audioMediaInfo] exchangeIdentifier] forKey:kAUDIO_MEDIA_INFO];
		
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
	
	[self setFilterToDate:[attributes objectForKey:kFILTER_TO_DATE]];
	
	[self setLongText:[attributes objectForKey:kLONG_TEXT]];
	
	[self setFilterFromDate:[attributes objectForKey:kFILTER_FROM_DATE]];
	
	[self setDate:[attributes objectForKey:kDATE]];
	
	[self setBoolean:[attributes objectForKey:kBOOLEAN]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)populateChildRelationshipsWithExchangeAttributes:(NSDictionary *)attributes
										   rootPredicate:(NSPredicate *)predicate
											fetchRequest:(NSFetchRequest *)fetchRequest
											   variables:(NSMutableDictionary *)variables
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSNumber *imageMediaInfoIdentifier = [attributes objectForKey:kIMAGE_MEDIA_INFO];
	if (imageMediaInfoIdentifier != nil)
	{
		[fetchRequest setEntity:[MediaInfo entityDescriptionInContextBTI:context]];
		
		[variables setObject:imageMediaInfoIdentifier forKey:kEXCHANGE_IDENTIFIER];
		NSPredicate *localPredicate = [predicate predicateWithSubstitutionVariables:variables];
		[fetchRequest setPredicate:localPredicate];
		
		[self setImageMediaInfo:[[context executeFetchRequest:fetchRequest error:nil] lastObject]];
	}
	
	if ([self actionFieldInfo] == nil)
	{
		NSNumber *actionFieldInfoIdentier = [attributes objectForKey:kACTION_FIELD_INFO];
		if (actionFieldInfoIdentier != nil)
		{
			[fetchRequest setEntity:[ActionFieldInfo entityDescriptionInContextBTI:context]];
			
			[variables setObject:actionFieldInfoIdentier forKey:kEXCHANGE_IDENTIFIER];
			NSPredicate *localPredicate = [predicate predicateWithSubstitutionVariables:variables];
			[fetchRequest setPredicate:localPredicate];
			
			[self setActionFieldInfo:[[context executeFetchRequest:fetchRequest error:nil] lastObject]];
		}
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
	
	NSNumber *colorInfoIdentifier = [attributes objectForKey:kCOLOR_INFO];
	if (colorInfoIdentifier != nil)
	{
		[fetchRequest setEntity:[ColorInfo entityDescriptionInContextBTI:context]];
		
		[variables setObject:colorInfoIdentifier forKey:kEXCHANGE_IDENTIFIER];
		NSPredicate *localPredicate = [predicate predicateWithSubstitutionVariables:variables];
		[fetchRequest setPredicate:localPredicate];
		
		[self setColorInfo:[[context executeFetchRequest:fetchRequest error:nil] lastObject]];
	}
	
	NSNumber *thumbnailMediaInfoIdentifier = [attributes objectForKey:kTHUMBNAIL_IMAGE_MEDIA_INFO];
	if (thumbnailMediaInfoIdentifier != nil)
	{
		[fetchRequest setEntity:[MediaInfo entityDescriptionInContextBTI:context]];
		
		[variables setObject:thumbnailMediaInfoIdentifier forKey:kEXCHANGE_IDENTIFIER];
		NSPredicate *localPredicate = [predicate predicateWithSubstitutionVariables:variables];
		[fetchRequest setPredicate:localPredicate];
		
		[self setThumbnailImageMediaInfo:[[context executeFetchRequest:fetchRequest error:nil] lastObject]];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
