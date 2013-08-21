//
//  ClassPeriod+BTIAdditions.m
//  TeachersAssistant
//
//  Created by Brian Slick on 10/6/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ClassPeriod+BTIAdditions.h"

@implementation ClassPeriod (ClassPeriod_BTIAdditions)

- (RandomizerInfo *)randomizerInfoForPerson:(Person *)person
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	RandomizerInfo *valueToReturn = nil;

	if (person != nil)
	{
		for (RandomizerInfo *randomizerInfo in [self randomizerInfos])
		{
			if ([person isEqual:[randomizerInfo person]])
			{
				valueToReturn = randomizerInfo;
				break;
			}
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return valueToReturn;
}

@end
