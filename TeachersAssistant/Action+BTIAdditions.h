//
//  Action+BTIAdditions.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/15/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "Action.h"
@class ActionValue;
@class ActionFieldInfo;
@class GradingPeriod;

@interface Action (Action_BTIAdditions)

- (ActionValue *)actionValueForActionFieldInfo:(ActionFieldInfo *)anActionFieldInfo;
- (NSString *)summaryStringForEmail;
- (NSString *)summaryStringForPrinting;
- (NSNumber *)colorLabelPointValue;
- (NSArray *)activeColorInfos;


@end
