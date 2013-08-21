//
//  Action+BTIAdditions.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/15/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "Action+BTIAdditions.h"

@interface Action (PrimitiveAccessors)

- (NSDate *)primitiveDefaultSortDate;
- (void)setPrimitiveDefaultSortDate:(NSDate *)newDefaultSortDate;

@end

@implementation Action (Action_BTIAdditions)

- (NSDate *)defaultSortDate
{
//	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self willAccessValueForKey:kDEFAULT_SORT_DATE];
	
//	ActionFieldInfo *actionFieldInfo = [[DataController sharedDataController] actionFieldInfoForIdentifier:kTermInfoIdentifierDate];
	ActionFieldInfo *actionFieldInfo = [[DataController sharedDataController] dateActionFieldInfoInContext:[self managedObjectContext]];
	ActionValue *actionValue = [self actionValueForActionFieldInfo:actionFieldInfo];
	
	NSDate *dateToReturn = [actionValue date];
	
	if ( (dateToReturn == nil) || (actionFieldInfo == nil) || (actionValue == nil) )
	{
		dateToReturn = [self dateCreated];
	}
	
	[self didAccessValueForKey:kDEFAULT_SORT_DATE];
		
//	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return dateToReturn;		//[actionValue date];
}

- (ActionValue *)actionValueForActionFieldInfo:(ActionFieldInfo *)anActionFieldInfo
{
	//NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	ActionValue *valueToReturn = nil;
	
	if (anActionFieldInfo != nil)
	{
		for (ActionValue *actionValue in [self actionValues])
		{
			if ([anActionFieldInfo isEqual:[actionValue actionFieldInfo]])
			{
				valueToReturn = actionValue;
				break;
			}
		}
	}
	
	//NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return valueToReturn;
}

- (NSString *)summaryStringForEmail
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSMutableString *fullEmailString = [NSMutableString string];
    
    [fullEmailString appendString:@"\n\n"];
	
	NSArray *actionFieldInfos = [[DataController sharedDataController] allSortedActionFieldInfosInContext:[self managedObjectContext]];
	
	for (ActionFieldInfo *actionFieldInfo in actionFieldInfos)
	{
		if ([[actionFieldInfo isHidden] boolValue])
			continue;
		
		ActionValue *actionValue = [self actionValueForActionFieldInfo:actionFieldInfo];
		
		NSString *actionValueSummary = [actionValue summaryStringForEmail];
		if (actionValueSummary != nil)
		{
			[fullEmailString appendString:actionValueSummary];
		}
	}
	
	[fullEmailString replaceOccurrencesOfString:@"(null)" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [fullEmailString length])];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return fullEmailString;
}

- (NSString *)summaryStringForPrinting
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSMutableString *fullPrintString = [NSMutableString string];
    
    [fullPrintString appendString:@"\n\n"];
	
	NSArray *actionFieldInfos = [[DataController sharedDataController] allSortedActionFieldInfosInContext:[self managedObjectContext]];
	
	for (ActionFieldInfo *actionFieldInfo in actionFieldInfos)
	{
		if ([[actionFieldInfo isHidden] boolValue])
			continue;
		
		ActionValue *actionValue = [self actionValueForActionFieldInfo:actionFieldInfo];
		
		NSString *actionValueSummary = [actionValue summaryStringForPrinting];
		if (actionValueSummary != nil)
		{
			[fullPrintString appendString:actionValueSummary];
		}
	}
	
//	[fullPrintString appendString:@"\n\n"];
	
	[fullPrintString replaceOccurrencesOfString:@"(null)" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [fullPrintString length])];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return fullPrintString;
}

- (NSNumber *)colorLabelPointValue
{
//	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSNumber *pointValue = [[self activeColorInfos] valueForKeyPath:@"@sum.pointValue"];

//	ActionFieldInfo *colorLabelFieldInfo = [[DataController sharedDataController] actionFieldInfoForIdentifier:kTermInfoIdentifierColorLabel];
//	ActionValue *actionValue = [self actionValueForActionFieldInfo:colorLabelFieldInfo];
//	ColorInfo *colorInfo = [actionValue colorInfo];
//	
//	if (colorInfo != nil)
//	{
//		pointValue = [colorInfo pointValue];
//	}
	
//	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return pointValue;
}

- (NSArray *)activeColorInfos
{
//	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	DataController *dataController = [DataController sharedDataController];
	
	NSMutableArray *colorInfosToReturn = [NSMutableArray array];
	
	// Priority 1: Color Infos for picker values in Action field.

//	ActionFieldInfo *actionFieldInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierAction];
	ActionFieldInfo *actionFieldInfo = [dataController actionActionFieldInfoInContext:[self managedObjectContext]];
	ActionValue *actionValue = [self actionValueForActionFieldInfo:actionFieldInfo];
	
	NSArray *sortedPickerValues = [[actionValue pickerValues] sortedArrayUsingDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
	
	for (PickerValue *pickerValue in sortedPickerValues)
	{
		if ([pickerValue colorInfo] != nil)
		{
			[colorInfosToReturn addObject:[pickerValue colorInfo]];
		}
	}
	
	// Priority 2: Color Infos for any color field
	
	NSArray *sortedActionFieldInfos = [dataController allSortedActionFieldInfosInContext:[self managedObjectContext]];
	
	for (ActionFieldInfo *fieldInfo in sortedActionFieldInfos)
	{
		if ([[fieldInfo type] integerValue] == BTIActionFieldValueTypeColor)
		{
			ActionValue *actionValue = [self actionValueForActionFieldInfo:fieldInfo];
			
			if ([actionValue colorInfo] != nil)
			{
				[colorInfosToReturn addObject:[actionValue colorInfo]];
			}
		}
	}
	
//	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [NSArray arrayWithArray:colorInfosToReturn];
}

@end
