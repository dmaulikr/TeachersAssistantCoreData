//
//  NSNotificationCenter+BTIAdditions.h
//  SlickShopper2
//
//  Created by Brian Slick on 4/9/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSNotificationCenter (BTIAdditions)

- (void)postNotificationNameOnMainThreadBTI:(NSString *)notificationName;
- (void)postNotificationNameOnMainThreadBTI:(NSString *)notificationName userInfo:(NSDictionary *)userInfo;


@end
