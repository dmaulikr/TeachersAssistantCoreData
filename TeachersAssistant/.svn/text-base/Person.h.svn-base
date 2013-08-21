//
//  Person.h
//  TeachersAssistant
//
//  Created by Brian Slick on 6/3/12.
//  Copyright (c) 2012 BriTer Ideas LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonAttributes.h"

@class Action, ClassPeriod, MediaInfo, Parent, PersonDetailValue, RandomizerInfo;

@interface Person : CommonAttributes

@property (nonatomic, retain) NSString * other;
@property (nonatomic, retain) NSString * firstLetterOfFirstName;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * firstLetterOfLastName;
@property (nonatomic, retain) NSNumber * meetsFilterCriteria;
@property (nonatomic, retain) NSNumber * colorLabelPointTotal;
@property (nonatomic, retain) NSNumber * gradingPeriodActionTotal;
@property (nonatomic, retain) NSSet *randomizerInfos;
@property (nonatomic, retain) NSSet *parents;
@property (nonatomic, retain) MediaInfo *smallThumbnailMediaInfo;
@property (nonatomic, retain) NSSet *actions;
@property (nonatomic, retain) MediaInfo *largeThumbnailMediaInfo;
@property (nonatomic, retain) NSSet *classPeriods;
@property (nonatomic, retain) NSSet *personDetailValues;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addRandomizerInfosObject:(RandomizerInfo *)value;
- (void)removeRandomizerInfosObject:(RandomizerInfo *)value;
- (void)addRandomizerInfos:(NSSet *)values;
- (void)removeRandomizerInfos:(NSSet *)values;
- (void)addParentsObject:(Parent *)value;
- (void)removeParentsObject:(Parent *)value;
- (void)addParents:(NSSet *)values;
- (void)removeParents:(NSSet *)values;
- (void)addActionsObject:(Action *)value;
- (void)removeActionsObject:(Action *)value;
- (void)addActions:(NSSet *)values;
- (void)removeActions:(NSSet *)values;
- (void)addClassPeriodsObject:(ClassPeriod *)value;
- (void)removeClassPeriodsObject:(ClassPeriod *)value;
- (void)addClassPeriods:(NSSet *)values;
- (void)removeClassPeriods:(NSSet *)values;
- (void)addPersonDetailValuesObject:(PersonDetailValue *)value;
- (void)removePersonDetailValuesObject:(PersonDetailValue *)value;
- (void)addPersonDetailValues:(NSSet *)values;
- (void)removePersonDetailValues:(NSSet *)values;
@end
