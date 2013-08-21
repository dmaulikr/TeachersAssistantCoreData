//
//  PersonDetailInfo.h
//  TeachersAssistant
//
//  Created by Brian Slick on 6/3/12.
//  Copyright (c) 2012 BriTer Ideas LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonAttributes.h"

@class PersonDetailValue;

@interface PersonDetailInfo : CommonAttributes

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *personDetailValues;
@end

@interface PersonDetailInfo (CoreDataGeneratedAccessors)

- (void)addPersonDetailValuesObject:(PersonDetailValue *)value;
- (void)removePersonDetailValuesObject:(PersonDetailValue *)value;
- (void)addPersonDetailValues:(NSSet *)values;
- (void)removePersonDetailValues:(NSSet *)values;
@end
