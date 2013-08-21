//
//  Student.h
//  infraction
//
//  Created by Brian Slick on 7/18/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Infraction;
@class Period;

#define kStudentFirstNameKey					@"firstName"
#define kStudentLastNameKey						@"lastName"
#define kStudentInfractionsKey					@"infractions"
#define kStudentOtherKey						@"other"
#define kStudentPeriodNamesKey					@"periodNames"
#define kStudentParentNameKey					@"parentName"
#define kStudentParentEmailKey					@"parentEmail"
#define kStudentParentPhoneKey                  @"parentPhone"
#define kStudentParentName2Key					@"parentName2"
#define kStudentParentEmail2Key					@"parentEmail2"
#define kStudentParentPhone2Key                 @"parentPhone2"

@interface Student : NSObject <NSCoding, NSCopying>
{
}

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *other;

@property (nonatomic, copy) NSString *parentName;
@property (nonatomic, copy) NSString *parentEmail;
@property (nonatomic, copy) NSString *parentPhone;

@property (nonatomic, copy) NSString *parentName2;
@property (nonatomic, copy) NSString *parentEmail2;
@property (nonatomic, copy) NSString *parentPhone2;

@property (nonatomic, copy) NSString *csvImportClassName;

@property (nonatomic, retain) NSMutableArray *infractions;
@property (nonatomic, retain) NSMutableSet *periodNames;

// Saving and reloading methods
- (id)attributes;
- (id)initWithAttributes:(id)attributes;

// Infractions Methods
- (NSInteger)countOfInfractions;
- (Infraction *)infractionAtIndex:(NSInteger)index;
- (void)removeInfraction:(Infraction *)oldInfraction;
- (void)removeInfractionAtIndex:(NSInteger)index;
- (void)removeAllInfractions;
- (void)addInfraction:(Infraction *)newInfraction;
- (NSEnumerator *)infractionsObjectEnumerator;
- (Infraction *)mostRecentInfraction;

// Period Methods
- (void)addPeriod:(Period *)period;
- (void)removePeriod:(Period *)period;
- (BOOL)containsPeriod:(Period *)period;
- (NSUInteger)countOfPeriods;
- (NSString *)periodString;
- (NSEnumerator *)periodObjectEnumerator;
- (void)removeAllPeriods;

// Misc Methods
//- (NSString *)summaryStringForEmail;
- (NSString *)fullName;

@end
