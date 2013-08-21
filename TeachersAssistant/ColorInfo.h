//
//  ColorInfo.h
//  TeachersAssistant
//
//  Created by Brian Slick on 4/12/12.
//  Copyright (c) 2012 BriTer Ideas LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonAttributes.h"

@class ActionValue, PickerValue;

@interface ColorInfo : CommonAttributes

@property (nonatomic, retain) id color;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * pointValue;
@property (nonatomic, retain) NSSet *actionValues;
@property (nonatomic, retain) NSSet *pickerValues;
@end

@interface ColorInfo (CoreDataGeneratedAccessors)

- (void)addActionValuesObject:(ActionValue *)value;
- (void)removeActionValuesObject:(ActionValue *)value;
- (void)addActionValues:(NSSet *)values;
- (void)removeActionValues:(NSSet *)values;
- (void)addPickerValuesObject:(PickerValue *)value;
- (void)removePickerValuesObject:(PickerValue *)value;
- (void)addPickerValues:(NSSet *)values;
- (void)removePickerValues:(NSSet *)values;
@end
