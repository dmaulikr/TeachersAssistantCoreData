//
//  ColorInfo+BTIAdditions.m
//  TeachersAssistant
//
//  Created by Brian Slick on 10/6/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ColorInfo+BTIAdditions.h"
#import "UIColorTransformer.h"

@interface ColorInfo (PrimitiveAccessors)
- (NSNumber *)primitivePointValue;
- (void)setPrimitivePointValue:(NSNumber *)newPointValue;
@end

@implementation ColorInfo (ColorInfo_BTIAdditions)

- (void)setPointValue:(NSNumber *)pointValue
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[self willChangeValueForKey:kPOINT_VALUE];
    [self setPrimitivePointValue:[[pointValue copy] autorelease]];
    [self didChangeValueForKey:kPOINT_VALUE];

	// Nil out the point totals for any affected Persons
	
	NSMutableSet *persons = [NSMutableSet set];
	
	for (ActionValue *actionValue in [self actionValues])
	{
		Person *person = [[actionValue action] person];
		
		if (person != nil)
		{
			[persons addObject:person];
		}
	}
	
	for (PickerValue *pickerValue in [self pickerValues])
	{
		for (ActionValue *actionValue in [pickerValue actionValues])
		{
			Person *person = [[actionValue action] person];
			
			if (person != nil)
			{
				[persons addObject:person];
			}
		}
	}
	
	for (Person *person in persons)
	{
		[person setColorLabelPointTotal:nil];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
