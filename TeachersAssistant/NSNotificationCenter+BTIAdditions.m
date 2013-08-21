//
//  NSNotificationCenter+BTIAdditions.m
//  SlickShopper2
//
//  Created by Brian Slick on 4/9/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "NSNotificationCenter+BTIAdditions.h"


@implementation NSNotificationCenter (BTIAdditions)

- (void)postNotificationNameOnMainThreadBTI:(NSString *)notificationName
{
	//NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSNotification *notification = [NSNotification notificationWithName:notificationName object:nil];
	
	[self performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
	
	//NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)postNotificationNameOnMainThreadBTI:(NSString *)notificationName
								   userInfo:(NSDictionary *)userInfo
{
	//NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSNotification *notification = [NSNotification notificationWithName:notificationName object:nil userInfo:userInfo];
	
	[self performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
	
	//NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
