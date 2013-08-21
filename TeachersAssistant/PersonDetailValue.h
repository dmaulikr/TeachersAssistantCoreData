//
//  PersonDetailValue.h
//  TeachersAssistant
//
//  Created by Brian Slick on 6/3/12.
//  Copyright (c) 2012 BriTer Ideas LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonAttributes.h"

@class Person, PersonDetailInfo;

@interface PersonDetailValue : CommonAttributes

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) PersonDetailInfo *personDetailInfo;
@property (nonatomic, retain) Person *person;

@end
