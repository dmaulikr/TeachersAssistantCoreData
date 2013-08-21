//
//  UITableView+MDAdditions.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/22/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//
//  Take from the book iOS Recipes by Matt Drance

#import "UITableView+MDAdditions.h"

@implementation UITableView (UITableView_MDAdditions)

- (NSIndexPath *)mdIndexPathForRowContainingView:(UIView *)view
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	CGPoint correctedPoint = [view convertPoint:[view bounds].origin toView:self];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self indexPathForRowAtPoint:correctedPoint];
}

@end
