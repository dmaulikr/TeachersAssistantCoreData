//
//  RandomizerInfo.h
//  TeachersAssistant
//
//  Created by Brian Slick on 4/15/12.
//  Copyright (c) 2012 BriTer Ideas LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonAttributes.h"

@class ClassPeriod, Person;

@interface RandomizerInfo : CommonAttributes

@property (nonatomic, retain) NSNumber * checkmarkMode;
@property (nonatomic, retain) Person *person;
@property (nonatomic, retain) ClassPeriod *classPeriod;

@end
