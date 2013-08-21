//
//  Action.h
//  TeachersAssistant
//
//  Created by Brian Slick on 10/7/11.
//  Copyright (c) 2011 BriTer Ideas LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonAttributes.h"

@class ActionValue, Person;

@interface Action : CommonAttributes {
@private
}
@property (nonatomic, retain) NSNumber * meetsFilterCriteria;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * defaultSortDate;
@property (nonatomic, retain) NSDate * dateModified;
@property (nonatomic, retain) Person *person;
@property (nonatomic, retain) NSSet *actionValues;
@end

@interface Action (CoreDataGeneratedAccessors)

- (void)addActionValuesObject:(ActionValue *)value;
- (void)removeActionValuesObject:(ActionValue *)value;
- (void)addActionValues:(NSSet *)values;
- (void)removeActionValues:(NSSet *)values;
@end
