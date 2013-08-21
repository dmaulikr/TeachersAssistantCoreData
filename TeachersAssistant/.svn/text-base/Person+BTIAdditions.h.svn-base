//
//  Person+BTIAdditions.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/14/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "Person.h"
@class ClassPeriod;
@class RandomizerInfo;
@class GradingPeriod;
@class PersonDetailValue;
@class PersonDetailInfo;

@interface Person (Person_BTIAdditions)

- (NSString *)fullName;
- (NSString *)reverseFullName;
- (NSString *)classNames;
- (NSArray *)parentsWithValidEmailAddresses;
- (NSArray *)parentsWithValidPhoneNumbers;
- (NSString *)summaryStringForEmail;
- (NSArray *)emailBlastEmailAddresses;
- (void)calculateColorLabelPointTotal;
- (void)calculateActionCountTotal;
//- (NSNumber *)gradingPeriodActionTotal;
- (NSSet *)actionsInGradingPeriod:(GradingPeriod *)gradingPeriod;
- (NSString *)summaryStringForReportEmailInGradingPeriod:(GradingPeriod *)gradingPeriod reportMode:(NSInteger)reportMode;
- (RandomizerInfo *)randomizerInfoForClassPeriod:(ClassPeriod *)classPeriod;
- (PersonDetailValue *)detailValueForPersonDetailInfo:(PersonDetailInfo *)detailInfo;

@end
