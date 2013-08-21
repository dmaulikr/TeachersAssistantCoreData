//
//  ObsoleteDataController.m
//  infraction
//
//  Created by Brian Slick on 9/26/10.
//  Copyright 2010 BriTer Ideas LLC. All rights reserved.
//

#import "ObsoleteDataController.h"

// TODO: Verify handling of existing installed (old) data

#import "Period.h"
#import "Constants.h"
#import "Student.h"
#import "Infraction.h"
#import "GTMBase64.h"
#import "FieldNameInfo.h"

@interface ObsoleteDataController ()

- (void)loadStudentData;
- (void)loadAllInfractionLists;
- (void)loadAllFieldNameInfo;
- (void)loadPeriodData;
- (void)addPersonFromStudent:(Student *)student;

@end

@implementation ObsoleteDataController

#pragma mark -
#pragma mark Synthesized Properties

@synthesize oldDateFormatter_DoNotUseForNewStuff = ivOldDateFormatter_DoNotUseForNewStuff;
@synthesize importedUpgradeData = ivImportedUpgradeData;
@synthesize importedFilePath = ivImportedFilePath;

#pragma mark -
#pragma mark Dealloc and Memory Management

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self setOldDateFormatter_DoNotUseForNewStuff:nil];
	[self setImportedUpgradeData:nil];
	[self setImportedFilePath:nil];
    
	[super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark Custom Getters and Setters

- (NSDateFormatter *)oldDateFormatter_DoNotUseForNewStuff
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if (ivOldDateFormatter_DoNotUseForNewStuff == nil)
	{
		ivOldDateFormatter_DoNotUseForNewStuff = [[NSDateFormatter alloc] init];
		[ivOldDateFormatter_DoNotUseForNewStuff setDateFormat:@"ccc MM/dd/yy hh:mm a"];
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return ivOldDateFormatter_DoNotUseForNewStuff;
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
#pragma mark Saving and Loading Methods

- (void)loadAllObsoleteData
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
	if ([userDefaults btiIsOldDataMigrated])
	{
		NSLog(@"<<< Leaving %s >>> EARLY - Already loaded old data", __PRETTY_FUNCTION__);
		return;
	}
	
	[self loadAllFieldNameInfo];
	[self loadPeriodData];
	[self loadAllInfractionLists];
	[self loadStudentData];

	[userDefaults btiSetOldDataMigrated:YES];
	[userDefaults synchronize];
	
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
	
	DataController *dataController = [DataController sharedDataController];
	[dataController hideProcessingAlert];
	[dataController setObsoleteDataController:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark Data Exchange Methods

- (void)processImportedFileAtPath:(NSString *)path
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[self setImportedFilePath:path];

	if (![[NSFileManager defaultManager] fileExistsAtPath:path])
	{
		[self setImportedFilePath:nil];
		
		NSLog(@"<<< Leaving %s >>> EARLY - No file at path", __PRETTY_FUNCTION__);
		return;
	}
	
	NSString *extension = [[path pathExtension] lowercaseString];
	
	if ([extension isEqualToString:kNativeFileExtension_OBSOLETE])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Import Data"
														message:@"Do you want to replace your existing data or add new data?"
													   delegate:self
											  cancelButtonTitle:@"Cancel"
											  otherButtonTitles:@"Replace", @"Add", nil];
		[alert show];
		[alert release], alert = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)addDataFromImportedFile
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	DataController *dataController = [DataController sharedDataController];
	NSManagedObjectContext *context = [dataController managedObjectContext];

	ActionFieldInfo *actionActionFieldInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierAction];
	ActionFieldInfo *teacherResponseFieldInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierTeacherResponse];
	ActionFieldInfo *locationFieldInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierLocation];
	ActionFieldInfo *optionalFieldInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierOptional];
	
	NSData *data = [[NSData alloc] initWithContentsOfFile:[self importedFilePath]];
//	NSLog(@"path: %@", [self importedFilePath]);
//	NSLog(@"data: %@", [data description]);
	
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	
	[data release], data = nil;
	
	// Periods
	NSMutableSet *oldPeriods = [unarchiver decodeObjectForKey:kExchangePeriodsKey];
	
	for (Period *oldPeriod in oldPeriods)
	{
		ClassPeriod *classPeriod = [dataController classPeriodWithName:[oldPeriod name]];
		if (classPeriod == nil)
		{
			classPeriod = [ClassPeriod managedObjectInContextBTI:context];
			[classPeriod setName:[oldPeriod name]];
		}
		[classPeriod setSortOrder:[oldPeriod sortOrder]];
	}
	
	// Names
	NSMutableArray *oldActionNames = [unarchiver decodeObjectForKey:kExchangeInfractionNamesKey];
	
	[oldActionNames enumerateObjectsUsingBlock:^(id name, NSUInteger index, BOOL *stop) {
		NSString *oldPickerName = (NSString *)name;
		
		PickerValue *pickerValue = [actionActionFieldInfo pickerValueWithName:oldPickerName];
		if (pickerValue == nil)
		{
			pickerValue = [PickerValue managedObjectInContextBTI:context];
			[pickerValue setName:oldPickerName];
			[pickerValue setActionFieldInfo:actionActionFieldInfo];
		}
		[pickerValue setSortOrder:[NSNumber numberWithInt:index]];
	}];
	
	// Teacher Response (Punishments ?)
	NSMutableArray *oldTeacherResponses = [unarchiver decodeObjectForKey:kExchangePunishmentsKey];
	
	[oldTeacherResponses enumerateObjectsUsingBlock:^(id name, NSUInteger index, BOOL *stop) {
		NSString *oldPickerName = (NSString *)name;
		
		PickerValue *pickerValue = [teacherResponseFieldInfo pickerValueWithName:oldPickerName];
		if (pickerValue == nil)
		{
			pickerValue = [PickerValue managedObjectInContextBTI:context];
			[pickerValue setName:oldPickerName];
			[pickerValue setActionFieldInfo:teacherResponseFieldInfo];
		}
		[pickerValue setSortOrder:[NSNumber numberWithInt:index]];
	}];

	// Locations
	NSMutableArray *oldLocations = [unarchiver decodeObjectForKey:kExchangeLocationsKey];
	
	[oldLocations enumerateObjectsUsingBlock:^(id name, NSUInteger index, BOOL *stop) {
		NSString *oldPickerName = (NSString *)name;
		
		PickerValue *pickerValue = [locationFieldInfo pickerValueWithName:oldPickerName];
		if (pickerValue == nil)
		{
			pickerValue = [PickerValue managedObjectInContextBTI:context];
			[pickerValue setName:oldPickerName];
			[pickerValue setActionFieldInfo:locationFieldInfo];
		}
		[pickerValue setSortOrder:[NSNumber numberWithInt:index]];
	}];
	
	// Optionals
	NSMutableArray *oldOptionals = [unarchiver decodeObjectForKey:kExchangeOptionalsKey];
	
	[oldOptionals enumerateObjectsUsingBlock:^(id name, NSUInteger index, BOOL *stop) {
		NSString *oldPickerName = (NSString *)name;
		
		PickerValue *pickerValue = [optionalFieldInfo pickerValueWithName:oldPickerName];
		if (pickerValue == nil)
		{
			pickerValue = [PickerValue managedObjectInContextBTI:context];
			[pickerValue setName:oldPickerName];
			[pickerValue setActionFieldInfo:optionalFieldInfo];
		}
		[pickerValue setSortOrder:[NSNumber numberWithInt:index]];
	}];
	
	// Term Infos (Field Names)
	
	NSMutableDictionary *loadFieldNames = [unarchiver decodeObjectForKey:kExchangeFieldNameInfoKey];
	if ([loadFieldNames count] > 0)
	{
		for (FieldNameInfo *savedFieldNameInfo in [loadFieldNames objectEnumerator])
		{
			NSString *internalName = [savedFieldNameInfo internalNameSingular];
			
			NSString *termInfoIdentifier = nil;
			
			if ( ([internalName isEqualToString:kFieldNamePeriod_Old]) || ([internalName isEqualToString:kFieldNameClass]) )
			{
				termInfoIdentifier = kTermInfoIdentifierClass;
			}
			else if ([internalName isEqualToString:kFieldNameAction])
			{
				termInfoIdentifier = kTermInfoIdentifierAction;
			}
			else if ([internalName isEqualToString:kFieldNameTeacherResponse])
			{
				termInfoIdentifier = kTermInfoIdentifierTeacherResponse;
			}
			else if ([internalName isEqualToString:kFieldNameLocation])
			{
				termInfoIdentifier = kTermInfoIdentifierLocation;
			}
			else if ([internalName isEqualToString:kFieldNameTeacherResponseOccurred])
			{
				termInfoIdentifier = kTermInfoIdentifierTeacherResponseOccurred;
			}
			else if ([internalName isEqualToString:kFieldNameDescription])
			{
				termInfoIdentifier = kTermInfoIdentifierDescription;
			}
			else if ([internalName isEqualToString:kFieldNameNote])
			{
				termInfoIdentifier = kTermInfoIdentifierNote;
			}
			else if ([internalName isEqualToString:kFieldNameParentNotified])
			{
				termInfoIdentifier = kTermInfoIdentifierParentNotified;
			}
			else if ([internalName isEqualToString:kFieldNameDate])
			{
				termInfoIdentifier = kTermInfoIdentifierDate;
			}
			else if ([internalName isEqualToString:kFieldNameOptional])
			{
				termInfoIdentifier = kTermInfoIdentifierOptional;
			}
			
			TermInfo *termInfo = [dataController termInfoForIdentifier:termInfoIdentifier];
			[termInfo setUserNameSingular:[savedFieldNameInfo userNameSingular]];
			[termInfo setUserNamePlural:[savedFieldNameInfo userNamePlural]];
		}
	}

	// Students
	NSMutableArray *oldStudents = [unarchiver decodeObjectForKey:kExchangeStudentsKey];
	
	for (Student *student in oldStudents)
	{
		[self addPersonFromStudent:student];
	}
	
	[unarchiver release], unarchiver = nil;
	
	[dataController saveCoreDataContext];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark All Students List Methods

- (void)loadStudentData
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	DataController *dataController = [DataController sharedDataController];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSString *oldPath = [[dataController documentsDirectory] stringByAppendingPathComponent:kStudentsFileName_OBSOLETE];
	NSString *newPath = [[dataController libraryApplicationSupportDirectory] stringByAppendingPathComponent:kStudentsFileName_OBSOLETE];
	
	if ([fileManager fileExistsAtPath:oldPath])
	{
		[fileManager moveItemAtPath:oldPath toPath:newPath error:nil];
	}
		
	NSMutableArray *loadStudents = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:newPath];

	for (Student *student in loadStudents)
	{
		[self addPersonFromStudent:student];
	}
	
	[dataController saveCoreDataContext];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)addPersonFromStudent:(Student *)student
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	@autoreleasepool
	{
		
		DataController *dataController = [DataController sharedDataController];
		NSManagedObjectContext *context = [dataController managedObjectContext];
		
		ActionFieldInfo *dateFieldInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierDate];
		ActionFieldInfo *actionActionFieldInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierAction];
		ActionFieldInfo *teacherResponseFieldInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierTeacherResponse];
		ActionFieldInfo *locationFieldInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierLocation];
		ActionFieldInfo *optionalFieldInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierOptional];
		ActionFieldInfo *descriptionFieldInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierDescription];
		ActionFieldInfo *noteFieldInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierNote];
		ActionFieldInfo *parentNotifiedFieldInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierParentNotified];
		ActionFieldInfo *responseOccurredFieldInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierTeacherResponseOccurred];
		
		Person *person = [Person managedObjectInContextBTI:context];
		[person setFirstName:[student firstName]];
		[person setLastName:[student lastName]];
		[person setOther:[student other]];
		
		for (NSString *oldPeriodName in [student periodNames])
		{
			ClassPeriod *classPeriod = [dataController classPeriodWithName:oldPeriodName];
			if (classPeriod == nil)
			{
				classPeriod = [ClassPeriod managedObjectInContextBTI:context];
				[classPeriod setName:oldPeriodName];
				[classPeriod setSortOrder:[NSNumber numberWithInt:[dataController countOfClassPeriods]]];
			}
			
			[person addClassPeriodsObject:classPeriod];
		}
		
		// Parent 1
		
		NSString *parent1Name = [student parentName];
		NSString *parent1Phone = [student parentPhone];
		NSString *parent1Email = [student parentEmail];
		
		BOOL isParentNameValid = ( (parent1Name != nil) && ([parent1Name length] != 0) );
		BOOL isParentPhoneValid = ( (parent1Phone != nil) && ([parent1Phone length] != 0) );
		BOOL isParentEmailValid = ( (parent1Email != nil) && ([parent1Email length] != 0) );
		
		if ( isParentNameValid || isParentPhoneValid || isParentEmailValid )
		{
			Parent *parent = [Parent managedObjectInContextBTI:context];
			[parent setName:parent1Name];
			
			if (isParentPhoneValid)
			{
				PhoneNumber *phoneNumber = [PhoneNumber managedObjectInContextBTI:context];
				[phoneNumber setType:kContactInfoTypeOther];
				[phoneNumber setValue:parent1Phone];
				[phoneNumber setSortOrder:[NSNumber numberWithInt:0]];
				
				[parent addPhoneNumbersObject:phoneNumber];
			}
			
			if (isParentEmailValid)
			{
				EmailAddress *emailAddress = [EmailAddress managedObjectInContextBTI:context];
				[emailAddress setType:kContactInfoTypeOther];
				[emailAddress setValue:parent1Email];
				[emailAddress setSortOrder:[NSNumber numberWithInt:0]];
				
				[parent addEmailAddressesObject:emailAddress];
			}
			
			[parent setSortOrder:[NSNumber numberWithInt:0]];
			[person addParentsObject:parent];
		}
		
		// Parent 2
		
		NSString *parent2Name = [student parentName2];
		NSString *parent2Phone = [student parentPhone2];
		NSString *parent2Email = [student parentEmail2];
		
		isParentNameValid = ( (parent2Name != nil) && ([parent2Name length] != 0) );
		isParentPhoneValid = ( (parent2Phone != nil) && ([parent2Phone length] != 0) );
		isParentEmailValid = ( (parent2Email != nil) && ([parent2Email length] != 0) );
		
		if ( isParentNameValid || isParentPhoneValid || isParentEmailValid )
		{
			Parent *parent = [Parent managedObjectInContextBTI:context];
			[parent setName:parent2Name];
			
			if (isParentPhoneValid)
			{
				PhoneNumber *phoneNumber = [PhoneNumber managedObjectInContextBTI:context];
				[phoneNumber setType:kContactInfoTypeOther];
				[phoneNumber setValue:parent2Phone];
				[phoneNumber setSortOrder:[NSNumber numberWithInt:0]];
				
				[parent addPhoneNumbersObject:phoneNumber];
			}
			
			if (isParentEmailValid)
			{
				EmailAddress *emailAddress = [EmailAddress managedObjectInContextBTI:context];
				[emailAddress setType:kContactInfoTypeOther];
				[emailAddress setValue:parent2Email];
				[emailAddress setSortOrder:[NSNumber numberWithInt:0]];
				
				[parent addEmailAddressesObject:emailAddress];
			}
			
			[parent setSortOrder:[NSNumber numberWithInt:[[person parents] count]]];
			[person addParentsObject:parent];
		}
		
		// Infractions
		
		for (Infraction *oldInfraction in [student infractions])
		{
			Action *action = [Action managedObjectInContextBTI:context];
			[action setDateCreated:[NSDate date]];
			[action setDateModified:[NSDate date]];
			
			[person addActionsObject:action];
			
			// Date
			{{
				ActionValue *dateActionValue = [ActionValue managedObjectInContextBTI:context];
				[dateActionValue setDate:[oldInfraction date]];
				
				[dateActionValue setActionFieldInfo:dateFieldInfo];
				[dateActionValue setAction:action];
			}}
			
			// Actions
			{{
				ActionValue *actionActionValue = [ActionValue managedObjectInContextBTI:context];
				
				[[oldInfraction studentActions] enumerateObjectsUsingBlock:^(id name, NSUInteger index, BOOL *stop) {
					NSString *oldPickerName = (NSString *)name;
					
					PickerValue *pickerValue = [actionActionFieldInfo pickerValueWithName:oldPickerName];
					if (pickerValue == nil)
					{
						pickerValue = [PickerValue managedObjectInContextBTI:context];
						[pickerValue setName:oldPickerName];
						[pickerValue setSortOrder:[NSNumber numberWithInt:index]];
						[pickerValue setActionFieldInfo:actionActionFieldInfo];
					}
					
					[actionActionValue addPickerValuesObject:pickerValue];
				}];
				
				[actionActionValue setActionFieldInfo:actionActionFieldInfo];
				[actionActionValue setAction:action];
			}}
			
			// Teacher Responses
			{{
				ActionValue *teacherResponseActionValue = [ActionValue managedObjectInContextBTI:context];
				
				[[oldInfraction teacherResponses] enumerateObjectsUsingBlock:^(id name, NSUInteger index, BOOL *stop) {
					NSString *oldPickerName = (NSString *)name;
					
					PickerValue *pickerValue = [teacherResponseFieldInfo pickerValueWithName:oldPickerName];
					if (pickerValue == nil)
					{
						pickerValue = [PickerValue managedObjectInContextBTI:context];
						[pickerValue setName:oldPickerName];
						[pickerValue setSortOrder:[NSNumber numberWithInt:index]];
						[pickerValue setActionFieldInfo:teacherResponseFieldInfo];
					}
					
					[teacherResponseActionValue addPickerValuesObject:pickerValue];
				}];
				
				[teacherResponseActionValue setActionFieldInfo:teacherResponseFieldInfo];
				[teacherResponseActionValue setAction:action];
			}}
			
			// Locations
			{{
				ActionValue *locationActionValue = [ActionValue managedObjectInContextBTI:context];
				
				[[oldInfraction locations] enumerateObjectsUsingBlock:^(id name, NSUInteger index, BOOL *stop) {
					NSString *oldPickerName = (NSString *)name;
					
					PickerValue *pickerValue = [locationFieldInfo pickerValueWithName:oldPickerName];
					if (pickerValue == nil)
					{
						pickerValue = [PickerValue managedObjectInContextBTI:context];
						[pickerValue setName:oldPickerName];
						[pickerValue setSortOrder:[NSNumber numberWithInt:index]];
						[pickerValue setActionFieldInfo:locationFieldInfo];
					}
					
					[locationActionValue addPickerValuesObject:pickerValue];
				}];
				
				[locationActionValue setActionFieldInfo:locationFieldInfo];
				[locationActionValue setAction:action];
			}}
			
			// Optional
			{{
				ActionValue *optionalActionValue = [ActionValue managedObjectInContextBTI:context];
				
				[[oldInfraction optionals] enumerateObjectsUsingBlock:^(id name, NSUInteger index, BOOL *stop) {
					NSString *oldPickerName = (NSString *)name;
					
					PickerValue *pickerValue = [optionalFieldInfo pickerValueWithName:oldPickerName];
					if (pickerValue == nil)
					{
						pickerValue = [PickerValue managedObjectInContextBTI:context];
						[pickerValue setName:oldPickerName];
						[pickerValue setSortOrder:[NSNumber numberWithInt:index]];
						[pickerValue setActionFieldInfo:optionalFieldInfo];
					}
					
					[optionalActionValue addPickerValuesObject:pickerValue];
				}];
				
				[optionalActionValue setActionFieldInfo:optionalFieldInfo];
				[optionalActionValue setAction:action];
			}}
			
			// Description
			{{
				ActionValue *descriptionActionValue = [ActionValue managedObjectInContextBTI:context];
				[descriptionActionValue setLongText:[oldInfraction infractionDescription]];
				
				[descriptionActionValue setActionFieldInfo:descriptionFieldInfo];
				[descriptionActionValue setAction:action];
			}}
			
			// Note
			{{
				ActionValue *noteActionValue = [ActionValue managedObjectInContextBTI:context];
				[noteActionValue setLongText:[oldInfraction note]];
				
				[noteActionValue setActionFieldInfo:noteFieldInfo];
				[noteActionValue setAction:action];
			}}
			
			// Parent Notified
			{{
				ActionValue *parentNotifiedActionValue = [ActionValue managedObjectInContextBTI:context];
				[parentNotifiedActionValue setBoolean:[NSNumber numberWithBool:[oldInfraction isParentNotified]]];
				
				[parentNotifiedActionValue setActionFieldInfo:parentNotifiedFieldInfo];
				[parentNotifiedActionValue setAction:action];
			}}
			
			// Teacher Response Occurred
			{{
				ActionValue *responseOccurredActionValue = [ActionValue managedObjectInContextBTI:context];
				[responseOccurredActionValue setBoolean:[NSNumber numberWithBool:[oldInfraction isPunished]]];
				
				[responseOccurredActionValue setActionFieldInfo:responseOccurredFieldInfo];
				[responseOccurredActionValue setAction:action];
			}}
		}
		
		[dataController saveCoreDataContext];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark Sorted Students List Methods


#pragma mark -
#pragma mark Infraction List Methods

- (void)loadAllInfractionLists
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	DataController *dataController = [DataController sharedDataController];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSManagedObjectContext *context = [dataController managedObjectContext];
	
	ActionFieldInfo *actionFieldInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierAction];
	NSArray *loadPickerNames = [defaults objectForKey:kUserDefaultsNamesKey];
	
	[loadPickerNames enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		NSString *actionName = (NSString *)object;
		
		PickerValue *pickerValue = [actionFieldInfo pickerValueWithName:actionName];
		if (pickerValue == nil)
		{
			pickerValue = [PickerValue managedObjectInContextBTI:context];
			[pickerValue setName:actionName];
			[pickerValue setSortOrder:[NSNumber numberWithInt:index]];
			
			[actionFieldInfo addPickerValuesObject:pickerValue];
		}

	}];
	
	ActionFieldInfo *responseFieldInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierTeacherResponse];
	NSArray *loadPunishments = [defaults objectForKey:kUserDefaultsPunishmentsKey];
	
	[loadPunishments enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		NSString *responseName = (NSString *)object;
		
		PickerValue *pickerValue = [responseFieldInfo pickerValueWithName:responseName];
		if (pickerValue == nil)
		{
			pickerValue = [PickerValue managedObjectInContextBTI:context];
			[pickerValue setName:responseName];
			[pickerValue setSortOrder:[NSNumber numberWithInt:index]];
			
			[responseFieldInfo addPickerValuesObject:pickerValue];
		}
		
	}];
	
	ActionFieldInfo *locationsFieldInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierLocation];
	NSArray *loadLocations = [defaults objectForKey:kUserDefaultsLocationsKey];
	
	[loadLocations enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		NSString *locationName = (NSString *)object;
		
		PickerValue *pickerValue = [locationsFieldInfo pickerValueWithName:locationName];
		if (pickerValue == nil)
		{
			pickerValue = [PickerValue managedObjectInContextBTI:context];
			[pickerValue setName:locationName];
			[pickerValue setSortOrder:[NSNumber numberWithInt:index]];
			
			[locationsFieldInfo addPickerValuesObject:pickerValue];
		}
		
	}];
	
	ActionFieldInfo *optionalFieldInfo = [dataController actionFieldInfoForIdentifier:kTermInfoIdentifierOptional];
	NSArray *loadOptionals = [defaults objectForKey:kUserDefaultsOptionalsKey];

	[loadOptionals enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		NSString *optionalName = (NSString *)object;
		
		PickerValue *pickerValue = [optionalFieldInfo pickerValueWithName:optionalName];
		if (pickerValue == nil)
		{
			pickerValue = [PickerValue managedObjectInContextBTI:context];
			[pickerValue setName:optionalName];
			[pickerValue setSortOrder:[NSNumber numberWithInt:index]];
			
			[optionalFieldInfo addPickerValuesObject:pickerValue];
		}
		
	}];
	
	[dataController saveCoreDataContext];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark Field Name Info Methods

- (void)loadAllFieldNameInfo
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	@autoreleasepool
	{
		
		DataController *dataController = [DataController sharedDataController];
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		
		NSArray *fieldNameAttributes = [userDefaults objectForKey:kUserDefaultsFieldNamesKey];
		
		for (NSDictionary *attributes in fieldNameAttributes)
		{
			FieldNameInfo *savedFieldNameInfo = [[[FieldNameInfo alloc] initWithAttributes:attributes] autorelease];
			NSString *oldInternalName = [savedFieldNameInfo	internalNameSingular];
			
			NSString *termInfoIdentifier = nil;
			
			if ([oldInternalName isEqualToString:kFieldNameAction])
			{
				termInfoIdentifier = kTermInfoIdentifierAction;
			}
			else if ([oldInternalName isEqualToString:kFieldNameTeacherResponse])
			{
				termInfoIdentifier = kTermInfoIdentifierTeacherResponse;
			}
			else if ([oldInternalName isEqualToString:kFieldNameLocation])
			{
				termInfoIdentifier = kTermInfoIdentifierLocation;
			}
			else if ([oldInternalName isEqualToString:kFieldNameClass])
			{
				termInfoIdentifier = kTermInfoIdentifierClass;
			}
			else if ([oldInternalName isEqualToString:kFieldNameTeacherResponseOccurred])
			{
				termInfoIdentifier = kTermInfoIdentifierTeacherResponseOccurred;
			}
			else if ([oldInternalName isEqualToString:kFieldNameDescription])
			{
				termInfoIdentifier = kTermInfoIdentifierDescription;
			}
			else if ([oldInternalName isEqualToString:kFieldNameNote])
			{
				termInfoIdentifier = kTermInfoIdentifierNote;
			}
			else if ([oldInternalName isEqualToString:kFieldNameParentNotified])
			{
				termInfoIdentifier = kTermInfoIdentifierParentNotified;
			}
			else if ([oldInternalName isEqualToString:kFieldNameDate])
			{
				termInfoIdentifier = kTermInfoIdentifierDate;
			}
			
			if (termInfoIdentifier == nil)
				continue;
			
			TermInfo *termInfo = [dataController termInfoForIdentifier:termInfoIdentifier];
			
			[termInfo setUserNameSingular:[savedFieldNameInfo userNameSingular]];
			[termInfo setUserNamePlural:[savedFieldNameInfo userNamePlural]];
			
//			[savedFieldNameInfo release], savedFieldNameInfo = nil;
		}
		
		[dataController saveCoreDataContext];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark Periods Methods

- (void)loadPeriodData
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	@autoreleasepool {
		
		DataController *dataController = [DataController sharedDataController];
		NSManagedObjectContext *context = [dataController managedObjectContext];
		
		NSString *path = [[dataController libraryApplicationSupportDirectory] stringByAppendingPathComponent:kPeriodsFileName_OBSOLETE];
		
		NSMutableSet *loadPeriods = (NSMutableSet *)[NSKeyedUnarchiver unarchiveObjectWithFile:path];
		
		for (Period *period in loadPeriods)
		{
			ClassPeriod *classPeriod = [ClassPeriod managedObjectInContextBTI:context];
			
			[classPeriod setName:[period name]];
			[classPeriod setSortOrder:[period sortOrder]];
		}
		
		[dataController saveCoreDataContext];
		
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark Sorted Periods List Methods


#pragma mark -
#pragma mark UIAlertView Delegate Methods


#pragma mark -
#pragma mark Singleton Methods

+ (ObsoleteDataController *)sharedDataController
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
    return [[DataController sharedDataController] obsoleteDataController];
}


@end
