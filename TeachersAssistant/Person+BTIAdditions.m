//
//  Person+BTIAdditions.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/14/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "Person+BTIAdditions.h"
#import "Person.h"

@interface Person (PrimitiveAccessors)

- (NSString *)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString *)newFirstName;
- (NSString *)primitiveLastName;
- (void)setPrimitiveLastName:(NSString *)newLastName;
- (NSMutableSet*)primitiveActions;
- (void)setPrimitiveActions:(NSMutableSet*)value;

@end

@implementation Person (Person_BTIAdditions)

#pragma mark - Custom Getters and Setters

- (void)setFirstName:(NSString *)newName
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [self willChangeValueForKey:kFIRST_NAME];
	
    NSString *newNameCopy = [newName copy];
    [self setPrimitiveFirstName:newNameCopy];
    [newNameCopy release];
	
    [self didChangeValueForKey:kFIRST_NAME];
	
	if ([newName length] >=1)
	{
		[self setFirstLetterOfFirstName:[[newName substringToIndex:1] uppercaseString]];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)setLastName:(NSString *)newName
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [self willChangeValueForKey:kLAST_NAME];
	
    NSString *newNameCopy = [newName copy];
    [self setPrimitiveLastName:newNameCopy];
    [newNameCopy release];
	
    [self didChangeValueForKey:kLAST_NAME];
	
	if ([newName length] >=1)
	{
		[self setFirstLetterOfLastName:[[newName substringToIndex:1] uppercaseString]];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)addActionsObject:(Action *)value
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
	
    [self willChangeValueForKey:kACTIONS
				withSetMutation:NSKeyValueUnionSetMutation
				   usingObjects:changedObjects];
	
    [[self primitiveActions] addObject:value];
	
    [self didChangeValueForKey:kACTIONS
			   withSetMutation:NSKeyValueUnionSetMutation
				  usingObjects:changedObjects];
	
    [changedObjects release], changedObjects = nil;

	[self setColorLabelPointTotal:nil];
	[self setGradingPeriodActionTotal:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)removeActionsObject:(Action *)value
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
	
    [self willChangeValueForKey:kACTIONS
				withSetMutation:NSKeyValueMinusSetMutation
				   usingObjects:changedObjects];
	
    [[self primitiveActions] removeObject:value];
	
    [self didChangeValueForKey:kACTIONS
			   withSetMutation:NSKeyValueMinusSetMutation
				  usingObjects:changedObjects];
	
	[changedObjects release], changedObjects = nil;
	
	[self setColorLabelPointTotal:nil];
	[self setGradingPeriodActionTotal:nil];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)addActions:(NSSet *)values
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

    [self willChangeValueForKey:kACTIONS
				withSetMutation:NSKeyValueUnionSetMutation
				   usingObjects:values];
	
    [[self primitiveActions] unionSet:values];
	
    [self didChangeValueForKey:kACTIONS
			   withSetMutation:NSKeyValueUnionSetMutation
				  usingObjects:values];

	[self setColorLabelPointTotal:nil];
	[self setGradingPeriodActionTotal:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)removeActions:(NSSet *)values
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

    [self willChangeValueForKey:kACTIONS
				withSetMutation:NSKeyValueMinusSetMutation
				   usingObjects:values];
	
    [[self primitiveActions] minusSet:values];
	
    [self didChangeValueForKey:kACTIONS
			   withSetMutation:NSKeyValueMinusSetMutation
				  usingObjects:values];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (NSString *)fullName
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
		
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [NSString stringWithFormat:@"%@ %@", [self firstName], [self lastName]];
}

- (NSString *)reverseFullName
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [NSString stringWithFormat:@"%@, %@", [self lastName], [self firstName]];
}

- (NSString *)classNames
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSArray *sortedClassValues = [[self classPeriods] sortedArrayUsingDescriptors:[[DataController sharedDataController] descriptorArrayForNameAlphabeticSort]];
	
	// Remove All Students class
	
	NSMutableArray *classes = [NSMutableArray array];
	
	for (ClassPeriod *class in sortedClassValues)
	{
		if (![[class name] isEqualToString:kAllStudentsClassName])
		{
			[classes addObject:class];
		}
	}
	
	NSArray *names = [classes valueForKey:@"name"];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [names componentsJoinedByString:kValueDelimiter];
}

- (NSArray *)parentsWithValidEmailAddresses
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSArray *sortedParents = [[self parents] sortedArrayUsingDescriptors:[[DataController sharedDataController] descriptorArrayForManualSortOrderSort]];
	
	NSMutableArray *array = [NSMutableArray array];
	
	for (Parent *parent in sortedParents)
	{
		if ([[parent emailAddresses] count] > 0)
		{
			[array addObject:parent];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [NSArray arrayWithArray:array];
}

- (NSArray *)parentsWithValidPhoneNumbers
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSArray *sortedParents = [[self parents] sortedArrayUsingDescriptors:[[DataController sharedDataController] descriptorArrayForManualSortOrderSort]];
	
	NSMutableArray *array = [NSMutableArray array];
	
	for (Parent *parent in sortedParents)
	{
		if ([[parent phoneNumbers] count] > 0)
		{
			[array addObject:parent];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [NSArray arrayWithArray:array];
}

- (NSString *)summaryStringForEmail
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSMutableString *fullEmailString = [NSMutableString string];

	DataController *dataController = [DataController sharedDataController];
	NSString *summary = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierSummary];
	NSString *person = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
//	NSString *other = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierOther];
	
	NSManagedObjectContext *context = [self managedObjectContext];
	
	[fullEmailString appendString:[NSString stringWithFormat:@"%@ %@: %@\n", person, summary, [self fullName]]];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity:[PersonDetailInfo entityDescriptionInContextBTI:context]];
	[fetchRequest setSortDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
	
	NSArray *detailInfos = [context executeFetchRequest:fetchRequest error:nil];
	NSLog(@"detailInfos is: %@", [detailInfos description]);
	
	for (PersonDetailInfo *detailInfo in detailInfos)
	{
		PersonDetailValue *detailValue = [self detailValueForPersonDetailInfo:detailInfo];
		NSLog(@"detailValue is: %@", [detailValue description]);
		
		if ([[detailValue name] length] > 0)
		{
			[fullEmailString appendString:[NSString stringWithFormat:@"%@: %@\n", [detailInfo name], [detailValue name]]];
		}
	}
	
//	if ( ([self other] != nil) && ([[self other] length] > 0) )
//	{
//		[fullEmailString appendString:[NSString stringWithFormat:@"%@: %@\n", other, [self other]]];
//	}
	
	fetchRequest = [dataController actionFetchRequestForPerson:self];
	NSArray *sortedActions = [[self actions] sortedArrayUsingDescriptors:[fetchRequest sortDescriptors]];
	
	for (Action *action in sortedActions)
	{
		[fullEmailString appendString:[action summaryStringForEmail]];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return fullEmailString;
}

- (NSArray *)emailBlastEmailAddresses
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSMutableArray *addressesToReturn = [NSMutableArray array];

	for (Parent *parent in [self parents])
	{
		for (EmailAddress *emailAddress in [parent emailAddresses])
		{
			if ([[emailAddress isDefault] boolValue])
			{
				[addressesToReturn addObject:[emailAddress value]];
			}
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return addressesToReturn;
}

- (void)calculateColorLabelPointTotal
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	DataController *dataController = [DataController sharedDataController];
	GradingPeriod *gradingPeriod = [dataController activeGradingPeriod];
	
	NSSet *eligibleActions = [self actionsInGradingPeriod:gradingPeriod];
	
//	[self setColorLabelPointTotal:[[self actions] valueForKeyPath:@"@sum.colorLabelPointValue"]];
	[self setColorLabelPointTotal:[eligibleActions valueForKeyPath:@"@sum.colorLabelPointValue"]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)calculateActionCountTotal
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	DataController *dataController = [DataController sharedDataController];
	GradingPeriod *gradingPeriod = [dataController activeGradingPeriod];
	
	NSSet *eligibleActions = [self actionsInGradingPeriod:gradingPeriod];
	
	[self setGradingPeriodActionTotal:[NSNumber numberWithInt:[eligibleActions count]]];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

//- (NSNumber *)gradingPeriodActionTotal
//{
//	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
//
//	DataController *dataController = [DataController sharedDataController];
//	GradingPeriod *gradingPeriod = [dataController activeGradingPeriod];
//	
//	NSSet *eligibleActions = [self actionsInGradingPeriod:gradingPeriod];
//
//	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
//	return [NSNumber numberWithInt:[eligibleActions count]];
//}

- (NSSet *)actionsInGradingPeriod:(GradingPeriod *)gradingPeriod
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSMutableSet *eligibleActions = [NSMutableSet set];
	
	for (Action *action in [self actions])
	{
		if ([gradingPeriod isDateInRange:[action defaultSortDate]])
		{
			[eligibleActions addObject:action];
		}
	}
	
//	__block NSMutableSet *eligibleActions = [NSMutableSet set];
//	
//	[[self actions] enumerateObjectsUsingBlock:^(Action *action, BOOL *stop) {
//		
//		if ([gradingPeriod isDateInRange:[action defaultSortDate]])
//		{
//			[eligibleActions addObject:action];
//		}
//
//	}];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [NSSet setWithSet:eligibleActions];
}

- (NSString *)summaryStringForReportEmailInGradingPeriod:(GradingPeriod *)gradingPeriod
											  reportMode:(NSInteger)reportMode
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSSet *elibigleActions = [self actionsInGradingPeriod:gradingPeriod];
	
	if ( ([elibigleActions count] == 0) && (reportMode == BTIReportModePersonsWithActions) )
	{
		NSLog(@"<<< Leaving %s >>> EARLY - Person does not have actions in grading period", __PRETTY_FUNCTION__);
		return @"";
	}

	NSMutableString *fullEmailString = [NSMutableString string];
	
	DataController *dataController = [DataController sharedDataController];
	NSString *summary = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierSummary];
	NSString *person = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierPerson];
//	NSString *other = [dataController singularNameForTermInfoIndentifier:kTermInfoIdentifierOther];
	
	NSManagedObjectContext *context = [self managedObjectContext];
	
	[fullEmailString appendString:[NSString stringWithFormat:@"%@ %@: %@\n", person, summary, [self fullName]]];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity:[PersonDetailInfo entityDescriptionInContextBTI:context]];
	[fetchRequest setSortDescriptors:[dataController descriptorArrayForManualSortOrderSort]];
	
	NSArray *detailInfos = [context executeFetchRequest:fetchRequest error:nil];
	NSLog(@"detailInfos is: %@", [detailInfos description]);
	
	for (PersonDetailInfo *detailInfo in detailInfos)
	{
		PersonDetailValue *detailValue = [self detailValueForPersonDetailInfo:detailInfo];
		NSLog(@"detailValue is: %@", [detailValue description]);
		
		if ([[detailValue name] length] > 0)
		{
			[fullEmailString appendString:[NSString stringWithFormat:@"%@: %@\n", [detailInfo name], [detailValue name]]];
		}
	}
	
//	if ( ([self other] != nil) && ([[self other] length] > 0) )
//	{
//		[fullEmailString appendString:[NSString stringWithFormat:@"%@: %@\n", other, [self other]]];
//	}
	
	fetchRequest = [dataController actionFetchRequestForPerson:self];
	NSArray *sortedActions = [elibigleActions sortedArrayUsingDescriptors:[fetchRequest sortDescriptors]];
	
	for (Action *action in sortedActions)
	{
		[fullEmailString appendString:[action summaryStringForEmail]];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return fullEmailString;
}

- (RandomizerInfo *)randomizerInfoForClassPeriod:(ClassPeriod *)classPeriod
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	RandomizerInfo *valueToReturn = nil;
	
	if (classPeriod != nil)
	{
		for (RandomizerInfo *randomizerInfo in [self randomizerInfos])
		{
			if ([classPeriod isEqual:[randomizerInfo classPeriod]])
			{
				valueToReturn = randomizerInfo;
				break;
			}
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return valueToReturn;
}

- (PersonDetailValue *)detailValueForPersonDetailInfo:(PersonDetailInfo *)detailInfo
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	PersonDetailValue *valueToReturn = nil;
	
	if (detailInfo != nil)
	{
		for (PersonDetailValue *detailValue in [self personDetailValues])
		{
			if ([detailInfo isEqual:[detailValue personDetailInfo]])
			{
				valueToReturn = detailValue;
				break;
			}
		}
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return valueToReturn;
}

@end
