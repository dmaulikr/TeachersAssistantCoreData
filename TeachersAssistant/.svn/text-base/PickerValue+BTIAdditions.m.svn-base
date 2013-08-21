//
//  PickerValue+BTIAdditions.m
//  TeachersAssistant
//
//  Created by Brian Slick on 10/7/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "PickerValue+BTIAdditions.h"

@interface PickerValue (PrimitiveAccessors)
- (ColorInfo *)primitiveColorInfo;
- (void)setPrimitiveColorInfo:(ColorInfo *)newColorInfo;
@end

@implementation PickerValue (PickerValue_BTIAdditions)

- (void)setColorInfo:(ColorInfo *)colorInfo
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[self willChangeValueForKey:kCOLOR_INFO];
	[self setPrimitiveColorInfo:colorInfo];
	[self didChangeValueForKey:kCOLOR_INFO];
	
	NSMutableSet *persons = [NSMutableSet set];
	
	for (ActionValue *actionValue in [self actionValues])
	{
		Action *action = [actionValue action];
		Person *person = [action person];

		if (person != nil)
		{
			[persons addObject:person];
		}
	}
	
	for (Person *person in persons)
	{
		[person setColorLabelPointTotal:nil];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
