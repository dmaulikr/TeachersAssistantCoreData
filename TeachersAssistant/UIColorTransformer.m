//
//  UIColorTransformer.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/29/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "UIColorTransformer.h"

@implementation UIColorTransformer

+ (BOOL)allowsReverseTransformation
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return YES;
}

+ (Class)transformedValueClass
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);


	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [NSData class];
}

- (id)transformedValue:(id)value
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	UIColor *color = (UIColor *)value;
	const CGFloat *components = CGColorGetComponents(color.CGColor);
	
	NSString *result = [NSString stringWithFormat:@"%f,%f,%f", components[0], components[1], components[2]];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [result dataUsingEncoding:[NSString defaultCStringEncoding]];
}

- (id)reverseTransformedValue:(id)value
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSString *string = [[NSString alloc] initWithData:value encoding:[NSString defaultCStringEncoding]];
	
	NSArray *components = [string componentsSeparatedByString:@","];
	CGFloat red = [[components objectAtIndex:0] floatValue];
	CGFloat green = [[components objectAtIndex:1] floatValue];
	CGFloat blue = [[components objectAtIndex:2] floatValue];
	
	[string release], string = nil;

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
