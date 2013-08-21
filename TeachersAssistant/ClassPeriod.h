//
//  ClassPeriod.h
//  TeachersAssistant
//
//  Created by Brian Slick on 4/15/12.
//  Copyright (c) 2012 BriTer Ideas LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonAttributes.h"

@class Person, RandomizerInfo;

@interface ClassPeriod : CommonAttributes

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * groupMode;
@property (nonatomic, retain) NSNumber * groupSize;
@property (nonatomic, retain) NSNumber * numberOfGroups;
@property (nonatomic, retain) NSNumber * randomizerMode;
@property (nonatomic, retain) NSSet *persons;
@property (nonatomic, retain) NSSet *randomizerInfos;
@end

@interface ClassPeriod (CoreDataGeneratedAccessors)

- (void)addPersonsObject:(Person *)value;
- (void)removePersonsObject:(Person *)value;
- (void)addPersons:(NSSet *)values;
- (void)removePersons:(NSSet *)values;
- (void)addRandomizerInfosObject:(RandomizerInfo *)value;
- (void)removeRandomizerInfosObject:(RandomizerInfo *)value;
- (void)addRandomizerInfos:(NSSet *)values;
- (void)removeRandomizerInfos:(NSSet *)values;
@end
