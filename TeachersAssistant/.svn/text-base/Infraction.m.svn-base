//
//  Infraction.m
//  infraction
//
//  Created by will strimling on 8/10/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "Infraction.h"

// Constants
#import "Student.h"

@implementation Infraction

#pragma mark -
#pragma mark Synthesized Properties

@synthesize date = ivDate;
@synthesize studentActionString = ivStudentActionString;
@synthesize studentActions = ivStudentActions;
@synthesize teacherResponseString = ivTeacherResponseString;
@synthesize teacherResponses = ivTeacherResponses;
@synthesize locationString = ivLocationString;
@synthesize locations = ivLocations;
@synthesize periodString = ivPeriodString;
@synthesize periods = ivPeriods;
@synthesize optionalString = ivOptionalString;
@synthesize optionals = ivOptionals;
@synthesize infractionDescription = ivInfractionDescription;
@synthesize note = ivNote;
@synthesize parentNotified = ivParentNotified;
@synthesize punished = ivPunished;
@synthesize student = ivStudent;


#pragma mark -
#pragma mark Dealloc and Memory Management

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self setDate:nil];
	[self setStudentActionString:nil];
	[self setStudentActions:nil];
	[self setTeacherResponseString:nil];
	[self setTeacherResponses:nil];
	[self setLocationString:nil];
	[self setLocations:nil];
	[self setPeriodString:nil];
	[self setPeriods:nil];
	[self setOptionalString:nil];
	[self setOptionals:nil];
	[self setInfractionDescription:nil];
	[self setNote:nil];
	[self setStudent:nil];
	
	[super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark Custom Getters and Setters

- (NSString *)description
{
    NSMutableString *string = [NSMutableString string];
    
    [string appendString:@"Infraction object has the following properties:\n"];
    
    [string appendString:[NSString stringWithFormat:@" date: %@\n", [self date]]];
    [string appendString:[NSString stringWithFormat:@" studentActionString: %@\n", [self studentActionString]]];
    [string appendString:[NSString stringWithFormat:@" studentActions: %@\n", [self studentActions]]];
    [string appendString:[NSString stringWithFormat:@" teacherResponseString: %@\n", [self teacherResponseString]]];
    [string appendString:[NSString stringWithFormat:@" teacherResponses: %@\n", [self teacherResponses]]];
    [string appendString:[NSString stringWithFormat:@" locationString: %@\n", [self locationString]]];
    [string appendString:[NSString stringWithFormat:@" locations: %@\n", [self locations]]];
//  [string appendString:[NSString stringWithFormat:@" periodString: %@\n", [self periodString]]];
//  [string appendString:[NSString stringWithFormat:@" periods: %@\n", [self periods]]];
    [string appendString:[NSString stringWithFormat:@" optionalString: %@\n", [self optionalString]]];
    [string appendString:[NSString stringWithFormat:@" optionals: %@\n", [self optionals]]];
    [string appendString:[NSString stringWithFormat:@" infractionDescription: %@\n", [self infractionDescription]]];
    [string appendString:[NSString stringWithFormat:@" note: %@\n", [self note]]];
    [string appendString:[NSString stringWithFormat:@" parentNotified: %@\n", ([self isParentNotified]) ? @"YES" : @"NO"]];
    [string appendString:[NSString stringWithFormat:@" punished: %@\n", ([self isPunished]) ? @"YES" : @"NO"]];
    
	return string;
}

- (NSString *)studentActionString
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivStudentActionString == nil)
	{
		if ([[self studentActions] count] > 0)
		{
			ivStudentActionString = [[[self studentActions] componentsJoinedByString:kValueDelimiter] retain];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivStudentActionString;
}

- (NSMutableArray *)studentActions
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivStudentActions == nil)
	{
		ivStudentActions = [[NSMutableArray alloc] init];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivStudentActions;
}

- (NSString *)teacherResponseString
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivTeacherResponseString == nil)
	{
		if ([[self teacherResponses] count] > 0)
		{
			ivTeacherResponseString = [[[self teacherResponses] componentsJoinedByString:kValueDelimiter] retain];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivTeacherResponseString;
}

- (NSMutableArray *)teacherResponses
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivTeacherResponses == nil)
	{
		ivTeacherResponses = [[NSMutableArray alloc] init];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivTeacherResponses;
}

- (NSString *)locationString
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivLocationString == nil)
	{
		if ([[self locations] count] > 0)
		{
			ivLocationString = [[[self locations] componentsJoinedByString:kValueDelimiter] retain];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivLocationString;
}

- (NSMutableArray *)locations
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivLocations == nil)
	{
		ivLocations = [[NSMutableArray alloc] init];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivLocations;
}

- (NSString *)periodString
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivPeriodString == nil)
	{
		if ([[self periods] count] > 0)
		{
			ivPeriodString = [[[self periods] componentsJoinedByString:kValueDelimiter] retain];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivPeriodString;
}

- (NSMutableArray *)periods
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivPeriods == nil)
	{
		ivPeriods = [[NSMutableArray alloc] init];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivPeriods;
}

- (NSString *)optionalString
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivOptionalString == nil)
	{
		if ([[self optionals] count] > 0)
		{
			ivOptionalString = [[[self optionals] componentsJoinedByString:kValueDelimiter] retain];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivOptionalString;
}

- (NSMutableArray *)optionals
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (ivOptionals == nil)
	{
		ivOptionals = [[NSMutableArray alloc] init];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivOptionals;
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
	
	Infraction *reportCopy = [[[self class] allocWithZone:zone] init];
	
	[reportCopy setDate:[self date]];
	
	NSMutableArray *copyOfArray = [[NSMutableArray alloc] initWithArray:[self studentActions] copyItems:YES];
	[reportCopy setStudentActions:copyOfArray];
	[copyOfArray release], copyOfArray = nil;
	
	copyOfArray = [[NSMutableArray alloc] initWithArray:[self teacherResponses] copyItems:YES];
	[reportCopy setTeacherResponses:copyOfArray];
	[copyOfArray release], copyOfArray = nil;
	
	copyOfArray = [[NSMutableArray alloc] initWithArray:[self locations] copyItems:YES];
	[reportCopy setLocations:copyOfArray];
	[copyOfArray release], copyOfArray = nil;
	
//	copyOfArray = [[NSMutableArray alloc] initWithArray:[self periods] copyItems:YES];
//	[reportCopy setPeriods:copyOfArray];
//	[copyOfArray release], copyOfArray = nil;
	
	copyOfArray = [[NSMutableArray alloc] initWithArray:[self optionals] copyItems:YES];
	[reportCopy setOptionals:copyOfArray];
	[copyOfArray release], copyOfArray = nil;
	
	[reportCopy setInfractionDescription:[self infractionDescription]];
	[reportCopy setNote:[self note]];
	[reportCopy setParentNotified:[self isParentNotified]];
	[reportCopy setPunished:[self isPunished]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return reportCopy;
}

#pragma mark -
#pragma mark NSCoder Methods

- (void)encodeWithCoder:(NSCoder *)encoder
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[encoder encodeObject:[self date] forKey:kInfractionDateKey];	
	[encoder encodeObject:[self studentActions] forKey:kInfractionStudentActionKey];
	[encoder encodeObject:[self teacherResponses] forKey:kInfractionTeacherResponseKey];
	[encoder encodeObject:[self locations] forKey:kInfractionLocationKey];
//	[encoder encodeObject:[self periods] forKey:kInfractionPeriodKey];
	[encoder encodeObject:[self optionals] forKey:kInfractionOptionalKey];
	[encoder encodeObject:[self infractionDescription] forKey:kInfractionDescriptionKey];
	[encoder encodeObject:[self note] forKey:kInfractionNoteKey];
	[encoder encodeBool:[self isParentNotified] forKey:kInfractionParentNotifiedKey];
	[encoder encodeBool:[self isPunished] forKey:kInfractionPunishedKey];
	
//	[encoder encodeObject:[self dateAsString] forKey:kInfractionTimeStampKey_Old];	
//	[encoder encodeObject:[self punishment] forKey:kInfractionPunishmentKey_Old];
//	[encoder encodeObject:[self infractionName] forKey:kInfractionInfractionNameKey_Old];
//	[encoder encodeObject:[self locationPlace] forKey:kInfractionLocationPlaceKey_Old];
//	[encoder encodeObject:[self classPeriod] forKey:kInfractionClassPeriodKey_Old];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (id)initWithCoder:(NSCoder *)decoder
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	self = [self init];
	
	if (self)
	{
		if ([decoder containsValueForKey:kInfractionDateKey])
		{
			[self setDate:[decoder decodeObjectForKey:kInfractionDateKey]];
		}
		else if ([decoder containsValueForKey:kInfractionTimeStampKey_Old])
		{
			NSString *loadOldDateString = [decoder decodeObjectForKey:kInfractionTimeStampKey_Old];
			if (loadOldDateString != nil)
			{
				[self setDate:[[[ObsoleteDataController sharedDataController] oldDateFormatter_DoNotUseForNewStuff] dateFromString:loadOldDateString]];
			}
		}
		
		if ([decoder containsValueForKey:kInfractionStudentActionKey])
		{
			[self setStudentActions:[decoder decodeObjectForKey:kInfractionStudentActionKey]];
		}
		else if ([decoder containsValueForKey:kInfractionInfractionNameKey_Old])
		{
			NSString *actions = [decoder decodeObjectForKey:kInfractionInfractionNameKey_Old];
			
			NSArray *loadActions = [actions componentsSeparatedByString:kValueDelimiter];
			[[self studentActions] addObjectsFromArray:loadActions];
		}
		
		if ([decoder containsValueForKey:kInfractionTeacherResponseKey])
		{
			[self setTeacherResponses:[decoder decodeObjectForKey:kInfractionTeacherResponseKey]];
		}
		else if ([decoder containsValueForKey:kInfractionPunishmentKey_Old])
		{
			NSString *responses = [decoder decodeObjectForKey:kInfractionPunishmentKey_Old];
			
			NSArray *loadResponses = [responses componentsSeparatedByString:kValueDelimiter];
			[[self teacherResponses] addObjectsFromArray:loadResponses];
		}

		if ([decoder containsValueForKey:kInfractionLocationKey])
		{
			[self setLocations:[decoder decodeObjectForKey:kInfractionLocationKey]];
		}
		else if ([decoder containsValueForKey:kInfractionLocationPlaceKey_Old])
		{
			NSString *locationPlaces = [decoder decodeObjectForKey:kInfractionLocationPlaceKey_Old];
			
			NSArray *loadPlaces = [locationPlaces componentsSeparatedByString:kValueDelimiter];
			[[self locations] addObjectsFromArray:loadPlaces];
		}

		if ([decoder containsValueForKey:kInfractionPeriodKey])
		{
			[self setPeriods:[decoder decodeObjectForKey:kInfractionPeriodKey]];
		}
		else if ([decoder containsValueForKey:kInfractionClassPeriodKey_Old])
		{
			NSString *classes = [decoder decodeObjectForKey:kInfractionClassPeriodKey_Old];
			
			NSArray *loadClasses = [classes componentsSeparatedByString:kValueDelimiter];
			[[self periods] addObjectsFromArray:loadClasses];
		}
		
		[self setOptionals:[decoder decodeObjectForKey:kInfractionOptionalKey]];
		[self setInfractionDescription:[decoder decodeObjectForKey:kInfractionDescriptionKey]];
		[self setNote:[decoder decodeObjectForKey:kInfractionNoteKey]];
		[self setParentNotified:[decoder decodeBoolForKey:kInfractionParentNotifiedKey]];
		[self setPunished:[decoder decodeBoolForKey:kInfractionPunishedKey]];
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
	
	if ([self date] != nil)
		[dictionary setObject:[self date] forKey:kInfractionDateKey];
	
	if ([self studentActions] != nil)
		[dictionary setObject:[self studentActions] forKey:kInfractionStudentActionKey];
	
	if ([self teacherResponses] != nil)
		[dictionary setObject:[self teacherResponses] forKey:kInfractionTeacherResponseKey];
	
	if ([self locations] != nil)
		[dictionary setObject:[self locations] forKey:kInfractionLocationKey];
	
//	if ([self periods] != nil)
//		[dictionary setObject:[self periods] forKey:kInfractionPeriodKey];
	
	if ([self optionals] != nil)
		[dictionary setObject:[self optionals] forKey:kInfractionOptionalKey];
	
	if ([self infractionDescription] != nil)
		[dictionary setObject:[self infractionDescription] forKey:kInfractionDescriptionKey];
	
	if ([self note] != nil)
		[dictionary setObject:[self note] forKey:kInfractionNoteKey];
	
	[dictionary setObject:[NSNumber numberWithBool:[self isParentNotified]] forKey:kInfractionParentNotifiedKey];
	
	[dictionary setObject:[NSNumber numberWithBool:[self isPunished]] forKey:kInfractionPunishedKey];
	
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
		
		NSDate *loadDate = [dictionary objectForKey:kInfractionDateKey];
		if (loadDate != nil)
		{
			[self setDate:loadDate];
		}
		else
		{
			NSString *loadOldDate = [dictionary objectForKey:kInfractionTimeStampKey_Old];
			if (loadOldDate != nil)
			{
				[self setDate:[[[ObsoleteDataController sharedDataController] oldDateFormatter_DoNotUseForNewStuff] dateFromString:loadOldDate]];
			}
		}
		
		NSArray *loadStudentActions = [dictionary objectForKey:kInfractionStudentActionKey];
		if (loadStudentActions != nil)
		{
			[[self studentActions] addObjectsFromArray:loadStudentActions];
		}
		else
		{
			NSString *infractions = [dictionary objectForKey:kInfractionInfractionNameKey_Old];
			
			NSArray *loadInfractions = [infractions componentsSeparatedByString:kValueDelimiter];
			[[self studentActions] addObjectsFromArray:loadInfractions];
		}

		NSArray *loadTeacherResponses = [dictionary objectForKey:kInfractionTeacherResponseKey];
		if (loadTeacherResponses != nil)
		{
			[[self teacherResponses] addObjectsFromArray:loadTeacherResponses];
		}
		else
		{
			NSString *punishments = [dictionary objectForKey:kInfractionPunishmentKey_Old];
			
			NSArray *loadPunishments = [punishments componentsSeparatedByString:kValueDelimiter];
			[[self teacherResponses] addObjectsFromArray:loadPunishments];
		}

		NSArray *loadLocations = [dictionary objectForKey:kInfractionLocationKey];
		if (loadLocations != nil)
		{
			[[self locations] addObjectsFromArray:loadLocations];
		}
		else
		{
			NSString *places = [dictionary objectForKey:kInfractionLocationPlaceKey_Old];
			
			NSArray *loadPlaces = [places componentsSeparatedByString:kValueDelimiter];
			[[self locations] addObjectsFromArray:loadPlaces];
		}

		NSArray *loadPeriods = [dictionary objectForKey:kInfractionPeriodKey];
		if (loadPeriods != nil)
		{
			[[self periods] addObjectsFromArray:loadPeriods];
		}
		else
		{
			NSString *classes = [dictionary objectForKey:kInfractionClassPeriodKey_Old];
			
			NSArray *loadClasses = [classes componentsSeparatedByString:kValueDelimiter];
			[[self periods] addObjectsFromArray:loadClasses];
		}
		
		NSArray *loadOptionals = [dictionary objectForKey:kInfractionOptionalKey];
		if (loadOptionals != nil)
		{
			[[self optionals] addObjectsFromArray:loadOptionals];
		}
		
		NSString *loadDescription = [dictionary objectForKey:kInfractionDescriptionKey];
		if (loadDescription != nil)
			[self setInfractionDescription:loadDescription];
		
		NSString *loadNote = [dictionary objectForKey:kInfractionNoteKey];
		if (loadNote != nil)
			[self setNote:loadNote];
		
		NSNumber *loadNotified = [dictionary objectForKey:kInfractionParentNotifiedKey];
		if (loadNotified != nil)
			[self setParentNotified:[loadNotified boolValue]];
		
		NSNumber *loadPunished = [dictionary objectForKey:kInfractionPunishedKey];
		if (loadPunished != nil)
			[self setPunished:[loadPunished boolValue]];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return self;
}

#pragma mark -
#pragma mark Misc Methods

//- (NSString *)summaryStringForEmail
//{
//	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
//
//	ObsoleteDataController *dataController = [ObsoleteDataController sharedDataController];
//	
//	NSString *action = nil;
//	NSString *teacherResponse = nil;
//	NSString *location = nil;
////	NSString *period = nil;
//	NSString *optional = nil;
//	
//	if ([[self studentActions] count] > 1)
//	{
//		action = [dataController pluralNameForFieldInfoType:kFieldNameAction];
//	}
//	else
//	{
//		action = [dataController singularNameForFieldInfoType:kFieldNameAction];
//	}
//	
//	if ([[self teacherResponses] count] > 1)
//	{
//		teacherResponse = [dataController pluralNameForFieldInfoType:kFieldNameTeacherResponse];
//	}
//	else
//	{
//		teacherResponse = [dataController singularNameForFieldInfoType:kFieldNameTeacherResponse];
//	}
//	
//	if ([[self locations] count] > 1)
//	{
//		location = [dataController pluralNameForFieldInfoType:kFieldNameLocation];
//	}
//	else
//	{
//		location = [dataController singularNameForFieldInfoType:kFieldNameLocation];
//	}
//	
////	if ([[self periods] count] > 1)
////	{
////		period = [dataController pluralNameForFieldInfoType:kFieldNameClass];
////	}
////	else
////	{
////		period = [dataController singularNameForFieldInfoType:kFieldNameClass];
////	}
//	
//	if ([[self optionals] count] > 1)
//	{
//		optional = [dataController pluralNameForFieldInfoType:kFieldNameOptional];
//	}
//	else
//	{
//		optional = [dataController singularNameForFieldInfoType:kFieldNameOptional];
//	}
//	
//	NSString *punishmentOccurred = [dataController singularNameForFieldInfoType:kFieldNameTeacherResponseOccurred];
//	NSString *description = [dataController singularNameForFieldInfoType:kFieldNameDescription];
//	NSString *notes = [dataController pluralNameForFieldInfoType:kFieldNameNote];
//	NSString *parentNotified = [dataController singularNameForFieldInfoType:kFieldNameParentNotified];
//	NSString *dateLabel = [dataController singularNameForFieldInfoType:kFieldNameDate];
//	NSString *dateValue = [NSDateFormatter localizedStringFromDate:[self date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
//	
//    NSMutableString *fullEmailString = [NSMutableString string];
//    
//    [fullEmailString appendString:@"\n\n"];
//    [fullEmailString appendString:[NSString stringWithFormat:@"%@: %@\n", action, [self studentActionString]]];
//    [fullEmailString appendString:[NSString stringWithFormat:@"%@: %@\n", dateLabel, dateValue]];
//    [fullEmailString appendString:[NSString stringWithFormat:@"%@: %@\n", teacherResponse, [self teacherResponseString]]];
//    [fullEmailString appendString:[NSString stringWithFormat:@"%@: %@\n", location, [self locationString]]];
//    [fullEmailString appendString:[NSString stringWithFormat:@"%@: %@\n", optional, [self optionalString]]];
//    [fullEmailString appendString:[NSString stringWithFormat:@"%@: %@\n", punishmentOccurred, ([self isPunished] ? @"Yes" : @"No")]];
//    [fullEmailString appendString:[NSString stringWithFormat:@"%@: %@\n", parentNotified, ([self isParentNotified] ? @"Yes" : @"No")]];
//    [fullEmailString appendString:[NSString stringWithFormat:@"%@: %@\n", description, [self infractionDescription]]];
//    [fullEmailString appendString:[NSString stringWithFormat:@"%@: %@\n", notes, [self note]]];
//    
//    [fullEmailString replaceOccurrencesOfString:@"(null)" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [fullEmailString length])];
//    
////	NSString *fullEmailString = [NSString stringWithFormat:@"\n\n%@: %@\n %@: %@\n %@: %@\n %@: %@\n %@: %@\n %@: %@\n %@: %@\n %@: %@\n %@: %@\n %@: %@\n", action, [self studentActionString], dateLabel, dateValue, teacherResponse, [self teacherResponseString], location, [self locationString],  period, [self periodString], optional, [self optionalString], punishmentOccurred, ([self isPunished] ? @"Yes" : @"No"), parentNotified, ([self isParentNotified] ? @"Yes" : @"No"), description, [self infractionDescription], notes, [self note]];
//	
////	fullEmailString = [fullEmailString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
//	
//	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
//	return fullEmailString;
//}

@end
