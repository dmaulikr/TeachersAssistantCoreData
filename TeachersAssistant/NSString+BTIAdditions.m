//
//  NSString+BTIAdditions.m
//  TeachersAssistant
//
//  Created by Brian Slick on 10/3/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "NSString+BTIAdditions.h"

@implementation NSString (NSString_BTIAdditions)

- (NSString *)stringByRemovingNull
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
}

@end
