//
//  ActionFieldInfo+BTIAdditions.h
//  TeachersAssistant
//
//  Created by Brian Slick on 10/2/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ActionFieldInfo.h"
@class PickerValue;

@interface ActionFieldInfo (ActionFieldInfo_BTIAdditions)

- (PickerValue *)pickerValueWithName:(NSString *)name;

@end
