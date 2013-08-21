//
//  ActionValue.h
//  TeachersAssistant
//
//  Created by Brian Slick on 10/7/11.
//  Copyright (c) 2011 BriTer Ideas LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonAttributes.h"

@class Action, ActionFieldInfo, ColorInfo, MediaInfo, PickerValue;

@interface ActionValue : CommonAttributes {
@private
}
@property (nonatomic, retain) NSDate * filterToDate;
@property (nonatomic, retain) NSString * longText;
@property (nonatomic, retain) NSDate * filterFromDate;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * boolean;
@property (nonatomic, retain) MediaInfo *imageMediaInfo;
@property (nonatomic, retain) ActionFieldInfo *actionFieldInfo;
@property (nonatomic, retain) MediaInfo *videoMediaInfo;
@property (nonatomic, retain) Action *action;
@property (nonatomic, retain) NSSet *pickerValues;
@property (nonatomic, retain) ColorInfo *colorInfo;
@property (nonatomic, retain) MediaInfo *audioMediaInfo;
@property (nonatomic, retain) MediaInfo *thumbnailImageMediaInfo;
@end

@interface ActionValue (CoreDataGeneratedAccessors)

- (void)addPickerValuesObject:(PickerValue *)value;
- (void)removePickerValuesObject:(PickerValue *)value;
- (void)addPickerValues:(NSSet *)values;
- (void)removePickerValues:(NSSet *)values;
@end
