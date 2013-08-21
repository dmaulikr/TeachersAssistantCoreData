//
//  ActionFieldInfo.h
//  TeachersAssistant
//
//  Created by Brian Slick on 10/7/11.
//  Copyright (c) 2011 BriTer Ideas LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonAttributes.h"

@class ActionValue, PickerValue, TermInfo;

@interface ActionFieldInfo : CommonAttributes {
@private
}
@property (nonatomic, retain) NSNumber * isHidden;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * isUserCreated;
@property (nonatomic, retain) NSSet *actionValues;
@property (nonatomic, retain) NSSet *pickerValues;
@property (nonatomic, retain) TermInfo *termInfo;
@end

@interface ActionFieldInfo (CoreDataGeneratedAccessors)

- (void)addActionValuesObject:(ActionValue *)value;
- (void)removeActionValuesObject:(ActionValue *)value;
- (void)addActionValues:(NSSet *)values;
- (void)removeActionValues:(NSSet *)values;
- (void)addPickerValuesObject:(PickerValue *)value;
- (void)removePickerValuesObject:(PickerValue *)value;
- (void)addPickerValues:(NSSet *)values;
- (void)removePickerValues:(NSSet *)values;
@end
