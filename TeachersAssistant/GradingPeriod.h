//
//  GradingPeriod.h
//  TeachersAssistant
//
//  Created by Brian Slick on 1/31/12.
//  Copyright 2012 BriTer Ideas LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

// Public Constants
#define kGradingPeriodNameKey					@"name"
#define kGradingPeriodStartDateKey				@"startDate"
#define kGradingPeriodEndDateKey				@"endDate"
#define kGradingPeriodSortOrderKey				@"sortOrder"
#define kGradingPeriodSelectedKey				@"selected"

@interface GradingPeriod : NSObject <NSCopying>
{    
}

// Public Properties
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic, copy) NSNumber *sortOrder;
@property (nonatomic, assign, getter = isSelected) BOOL selected;

// Saving and reloading methods
- (id)attributes;
- (id)initWithAttributes:(id)attributes;


// Other Public Methods
- (BOOL)isDateInRange:(NSDate *)date;

@end
