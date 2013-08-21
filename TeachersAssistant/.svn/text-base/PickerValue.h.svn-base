//
//  PickerValue.h
//  TeachersAssistant
//
//  Created by Brian Slick on 4/12/12.
//  Copyright (c) 2012 BriTer Ideas LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonAttributes.h"

@class ActionFieldInfo, ActionValue, ColorInfo;

@interface PickerValue : CommonAttributes

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) ActionFieldInfo *actionFieldInfo;
@property (nonatomic, retain) NSSet *actionValues;
@property (nonatomic, retain) ColorInfo *colorInfo;
@end

@interface PickerValue (CoreDataGeneratedAccessors)

- (void)addActionValuesObject:(ActionValue *)value;
- (void)removeActionValuesObject:(ActionValue *)value;
- (void)addActionValues:(NSSet *)values;
- (void)removeActionValues:(NSSet *)values;
@end
