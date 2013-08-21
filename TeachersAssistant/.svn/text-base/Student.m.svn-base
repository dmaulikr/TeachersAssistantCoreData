//
//  Student.m
//  infraction
//
//  Created by Brian Slick on 7/18/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "Student.h"
#import "Infraction.h"

@interface Student ()

//@property (nonatomic, retain) NSMutableArray *infractions;
//@property (nonatomic, retain) NSMutableSet *periodNames;

@end


@implementation Student

#pragma mark -
#pragma mark Synthesized Properties

// Public
@synthesize firstName = ivFirstName;
@synthesize lastName = ivLastName;
@synthesize other = ivOther;
@synthesize parentName = ivParentName;
@synthesize parentEmail = ivParentEmail;
@synthesize parentPhone = ivParentPhone;
@synthesize parentName2 = ivParentName2;
@synthesize parentEmail2 = ivParentEmail2;
@synthesize parentPhone2 = ivParentPhone2;
@synthesize csvImportClassName = ivCsvImportClassName;


// Private
@synthesize infractions = ivInfractions;
@synthesize periodNames = ivPeriodNames;

#pragma mark -
#pragma mark Dealloc and Memory Management

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	// Public
    [self setFirstName:nil];
    [self setLastName:nil];
    [self setOther:nil];
    [self setParentName:nil];
    [self setParentEmail:nil];
    [self setParentPhone:nil];
    [self setParentName2:nil];
    [self setParentEmail2:nil];
    [self setParentPhone2:nil];
    [self setCsvImportClassName:nil];
	
	// Private
	[self setInfractions:nil];
	[self setPeriodNames:nil];
	
	[super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark Custom Getters and Setters

- (NSString *)description
{
    NSMutableString *string = [NSMutableString string];
    
    [string appendString:@"Student object has the following properties:\n"];
    
    [string appendString:[NSString stringWithFormat:@" firstName: %@\n", [self firstName]]];
    [string appendString:[NSString stringWithFormat:@" lastName: %@\n", [self lastName]]];
	[string appendString:[NSString stringWithFormat:@" other: %@\n", [self other]]];
	[string appendString:[NSString stringWithFormat:@" parentName: %@\n", [self parentName]]];
    [string appendString:[NSString stringWithFormat:@" parentEmail: %@\n", [self parentEmail]]];
    [string appendString:[NSString stringWithFormat:@" parentPhone: %@\n", [self parentPhone]]];
	[string appendString:[NSString stringWithFormat:@" parentName2: %@\n", [self parentName2]]];
    [string appendString:[NSString stringWithFormat:@" parentEmail2: %@\n", [self parentEmail2]]];
    [string appendString:[NSString stringWithFormat:@" parentPhone2: %@\n", [self parentPhone2]]];
    [string appendString:[NSString stringWithFormat:@" infractions: %@\n", [self infractions]]];
    [string appendString:[NSString stringWithFormat:@" periodNames: %@\n", [self periodNames]]];
    
	return string;
}

- (NSMutableArray *)infractions
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if (ivInfractions == nil)
	{
		ivInfractions = [[NSMutableArray alloc] init];
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivInfractions;
}

- (NSMutableSet *)periodNames
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivPeriodNames == nil)
	{
		ivPeriodNames = [[NSMutableSet alloc] init];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivPeriodNames;
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

#pragma mark -
#pragma mark NSCopying Methods

- (id)copyWithZone:(NSZone *)zone
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
//	ObsoleteDataController *dataController = [ObsoleteDataController sharedDataController];
	
	Student *copyOfStudent = [[[self class] allocWithZone:zone] init];
	
//	[copyOfStudent setFirstName:[self firstName]];
//	[copyOfStudent setLastName:[self lastName]];
//	[copyOfStudent setOther:[self other]];
//	[copyOfStudent setParentName:[self parentName]];
//	[copyOfStudent setParentEmail:[self parentEmail]];
//    [copyOfStudent setParentPhone:[self parentPhone]];
//	[copyOfStudent setParentName2:[self parentName2]];
//	[copyOfStudent setParentEmail2:[self parentEmail2]];
//    [copyOfStudent setParentPhone2:[self parentPhone2]];
//	
//	NSMutableArray *copyOfInfractions = [[NSMutableArray alloc] initWithArray:[self infractions] copyItems:YES];
//	for (Infraction *infraction in copyOfInfractions)
//	{
//		[copyOfStudent addInfraction:infraction];
//	}
//	[copyOfInfractions release], copyOfInfractions = nil;
//	
//	for (NSString *periodName in [self periodNames])
//	{
//		Period *period = [dataController periodWithName:periodName];
//		[copyOfStudent addPeriod:period];
//	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return copyOfStudent;
}

#pragma mark -
#pragma mark NSCoder Methods

- (void)encodeWithCoder:(NSCoder *)encoder
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	// Public
	[encoder encodeObject:[self firstName] forKey:kStudentFirstNameKey];
	[encoder encodeObject:[self lastName] forKey:kStudentLastNameKey];
	[encoder encodeObject:[self other] forKey:kStudentOtherKey];
	[encoder encodeObject:[self parentName] forKey:kStudentParentNameKey];
	[encoder encodeObject:[self parentEmail] forKey:kStudentParentEmailKey];
    [encoder encodeObject:[self parentPhone] forKey:kStudentParentPhoneKey];
	[encoder encodeObject:[self parentName2] forKey:kStudentParentName2Key];
	[encoder encodeObject:[self parentEmail2] forKey:kStudentParentEmail2Key];
    [encoder encodeObject:[self parentPhone2] forKey:kStudentParentPhone2Key];

	// Private
	[encoder encodeObject:[self infractions] forKey:kStudentInfractionsKey];
	[encoder encodeObject:[self periodNames] forKey:kStudentPeriodNamesKey];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (id)initWithCoder:(NSCoder *)decoder
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	self = [super init];
	if (self)
	{
		// Public
		[self setFirstName:[decoder decodeObjectForKey:kStudentFirstNameKey]];
		[self setLastName:[decoder decodeObjectForKey:kStudentLastNameKey]];
		[self setOther:[decoder decodeObjectForKey:kStudentOtherKey]];
		
		[self setParentName:[decoder decodeObjectForKey:kStudentParentNameKey]];
		[self setParentEmail:[decoder decodeObjectForKey:kStudentParentEmailKey]];
        [self setParentPhone:[decoder decodeObjectForKey:kStudentParentPhoneKey]];
		
		[self setParentName2:[decoder decodeObjectForKey:kStudentParentName2Key]];
		[self setParentEmail2:[decoder decodeObjectForKey:kStudentParentEmail2Key]];
        [self setParentPhone2:[decoder decodeObjectForKey:kStudentParentPhone2Key]];
		
		// Private
        [self setPeriodNames:[decoder decodeObjectForKey:kStudentPeriodNamesKey]];
		[self setInfractions:[decoder decodeObjectForKey:kStudentInfractionsKey]];
        
//        ObsoleteDataController *dataController = [ObsoleteDataController sharedDataController];
        
//		for (Infraction *infraction in [self infractions])
//        {
//            if ([[infraction periods] count] > 0)
//            {
//                for (NSString *periodName in [infraction periods])
//                {
//                    Period *period = [dataController periodWithName:periodName];
//                    if (period == nil)
//                    {
//                        period = [dataController createPeriodWithName:periodName];
//                    }
//                    [self addPeriod:period];
//                }
//                
//                [infraction setPeriods:nil];
//                [infraction setPeriodString:nil];
//            }
//        }
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return self;
}

#pragma mark -
#pragma mark Attribute saving and reloading methods

- (id)attributes
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
	
	if ([self firstName] != nil)
		[dictionary setObject:[self firstName] forKey:kStudentFirstNameKey];
	
	if ([self lastName] != nil)
		[dictionary setObject:[self lastName] forKey:kStudentLastNameKey];
	
	if ([self other] != nil)
		[dictionary setObject:[self other] forKey:kStudentOtherKey];
	
	if ([self parentName] != nil)
		[dictionary setObject:[self parentName] forKey:kStudentParentNameKey];
	
	if ([self parentEmail] != nil)
		[dictionary setObject:[self parentEmail] forKey:kStudentParentEmailKey];
    
    if ([self parentPhone] != nil)
        [dictionary setObject:[self parentPhone] forKey:kStudentParentPhoneKey];
	
	if ([self parentName2] != nil)
		[dictionary setObject:[self parentName2] forKey:kStudentParentName2Key];
	
	if ([self parentEmail2] != nil)
		[dictionary setObject:[self parentEmail2] forKey:kStudentParentEmail2Key];
    
    if ([self parentPhone2] != nil)
        [dictionary setObject:[self parentPhone2] forKey:kStudentParentPhone2Key];
	
	NSMutableArray *infractionAttributes = [[NSMutableArray alloc] init];
	
	for (Infraction *infraction in [self infractions])
	{
		[infractionAttributes addObject:[infraction attributes]];
	}
	
	[dictionary setObject:infractionAttributes forKey:kStudentInfractionsKey];
	
	[infractionAttributes release], infractionAttributes = nil;
	
	if ([self periodNames] != nil)
		[dictionary setObject:[self periodNames] forKey:kStudentPeriodNamesKey];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [dictionary autorelease];
}

- (id)initWithAttributes:(id)attributes
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	self = [self init];
	if (self)
	{
//		ObsoleteDataController *dataController = [ObsoleteDataController sharedDataController];
		NSDictionary *dictionary = (NSDictionary *)attributes;
		
		NSString *loadFirst = [dictionary objectForKey:kStudentFirstNameKey];
		if (loadFirst != nil)
			[self setFirstName:loadFirst];
		
		NSString *loadLast = [dictionary objectForKey:kStudentLastNameKey];
		if (loadLast != nil)
			[self setLastName:loadLast];
		
		NSString *loadOther = [dictionary objectForKey:kStudentOtherKey];
		if (loadOther != nil)
			[self setOther:loadOther];
		
		NSString *loadName = [dictionary objectForKey:kStudentParentNameKey];
		if (loadName != nil)
			[self setParentName:loadName];
		
		NSString *loadEmail = [dictionary objectForKey:kStudentParentEmailKey];
		if (loadEmail != nil)
			[self setParentEmail:loadEmail];
        
        NSString *loadPhone = [dictionary objectForKey:kStudentParentPhoneKey];
        if (loadPhone != nil)
            [self setParentPhone:loadPhone];
		
		NSString *loadName2 = [dictionary objectForKey:kStudentParentName2Key];
		if (loadName2 != nil)
			[self setParentName2:loadName2];
		
		NSString *loadEmail2 = [dictionary objectForKey:kStudentParentEmail2Key];
		if (loadEmail2 != nil)
			[self setParentEmail2:loadEmail2];
        
        NSString *loadPhone2 = [dictionary objectForKey:kStudentParentPhone2Key];
        if (loadPhone2 != nil)
            [self setParentPhone2:loadPhone2];
		
		NSArray *loadInfractions = [dictionary objectForKey:kStudentInfractionsKey];
		if (loadInfractions != nil)
		{
			[self removeAllInfractions];
			
			for (NSDictionary *attributes in loadInfractions)
			{
				Infraction *infraction = [[Infraction alloc] initWithAttributes:attributes];
				
//				if ([[infraction periods] count] > 0)
//				{
//					for (NSString *periodName in [infraction periods])
//					{
//						Period *period = [dataController periodWithName:periodName];
//						if (period == nil)
//						{
//							period = [dataController createPeriodWithName:periodName];
//						}
//						[self addPeriod:period];
//					}
//
//					[infraction setPeriods:nil];
//					[infraction setPeriodString:nil];
//				}
				
				[self addInfraction:infraction];
				[infraction release], infraction = nil;
			}
		}
		
//		NSArray *loadPeriodNames = [dictionary objectForKey:kStudentPeriodNamesKey];
//		if (loadPeriodNames != nil)
//		{
//			for (NSString *periodName in loadPeriodNames)
//			{
//				Period *period = [dataController periodWithName:periodName];
//				if (period == nil)
//				{
//					period = [dataController createPeriodWithName:periodName];
//				}
//				[self addPeriod:period];
//			}
//		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return self;
}

#pragma mark -
#pragma mark Infractions Methods

- (NSInteger)countOfInfractions
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [[self infractions] count];
}

- (Infraction *)infractionAtIndex:(NSInteger)index
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [[self infractions] objectAtIndex:index];
}

- (void)removeInfraction:(Infraction *)oldInfraction
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

//	[[NSNotificationCenter defaultCenter] postNotificationName:kDidDeleteInfractionNotification object:oldInfraction];
	
	[[self infractions] removeObject:oldInfraction];
	[oldInfraction setStudent:nil];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)removeInfractionAtIndex:(NSInteger)index
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	Infraction *infraction = [[self infractions] objectAtIndex:index];
	
	[self removeInfraction:infraction];
	
//	[[self infractions] removeObjectAtIndex:index];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)removeAllInfractions
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSArray *tempArray = [NSArray arrayWithArray:[self infractions]];
	
	for (Infraction *infraction in tempArray)
	{
		[self removeInfraction:infraction];
	}
	
//	[[self infractions] removeAllObjects];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)addInfraction:(Infraction *)newInfraction
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self infractions] addObject:newInfraction];
	[newInfraction setStudent:self];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSEnumerator *)infractionsObjectEnumerator
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [[self infractions] objectEnumerator];
}

- (Infraction *)mostRecentInfraction
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [[self infractions] lastObject];
}

#pragma mark -
#pragma mark Period Methods

- (void)addPeriod:(Period *)period
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

    if (period == nil)
        return;
    
    NSString *name = [period name];
    
    if (name == nil)
        return;
    
	if (![[self periodNames] containsObject:name])
	{
		[[self periodNames] addObject:name];
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)removePeriod:(Period *)period
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	[[self periodNames] removeObject:[period name]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (BOOL)containsPeriod:(Period *)period
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	BOOL doesContainPeriod = NO;

	for (NSString *name in [self periodNames])
	{
		if ([[period name] isEqualToString:name])
		{
			doesContainPeriod = YES;
			break;
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return doesContainPeriod;
}

- (NSUInteger)countOfPeriods
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [[self periodNames] count];
}

- (NSString *)periodString
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSString *returnString = nil;

	NSArray *array = [[self periodNames] allObjects];
	
	array = [array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	
	returnString = [array componentsJoinedByString:kValueDelimiter];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return returnString;
}

- (NSEnumerator *)periodObjectEnumerator
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

//	ObsoleteDataController *dataController = [ObsoleteDataController sharedDataController];
	
	NSMutableSet *periodSet = [NSMutableSet set];
	
//	for (NSString *periodName in [self periodNames])
//	{
//		[periodSet addObject:[dataController periodWithName:periodName]];
//	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [periodSet objectEnumerator];
}

- (void)removeAllPeriods
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[self periodNames] removeAllObjects];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark Misc Methods

//- (NSString *)summaryStringForEmail
//{
//	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
//
//	NSString *heading = [NSString stringWithFormat:@"Summary for student: %@ \n", [self fullName]];
//	
//	if ( ([self other] != nil) && ([[self other] length] > 0) )
//	{
//		heading = [heading stringByAppendingString:[NSString stringWithFormat:@"Other: %@\n", [self other]]];
//	}
//	
////	NSString *subHeading = @"Actions: ";
//	NSString *subHeading = [NSString stringWithFormat:@"%@: ", [[ObsoleteDataController sharedDataController] pluralNameForFieldInfoType:kFieldNameAction]];
//	
//	NSMutableString *content = [[[NSMutableString alloc] init] autorelease];
//	
//	for (Infraction *infraction in [self infractions])
//	{
//		[content appendString:[infraction summaryStringForEmail]];
//		[content appendString:@" \n\n"];
//	}
//
//	NSString *fullEmailString = [NSString stringWithFormat:@"%@ %@ %@", heading, subHeading, content];
//	
//	fullEmailString = [fullEmailString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
//	
//	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
//	return fullEmailString;
//}

- (NSString *)fullName
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [NSString stringWithFormat:@"%@ %@", [self firstName], [self lastName]];
}


@end
