//
//  NSObject+PWObject.m
//
//
// http://forrst.com/posts/Delayed_Blocks_in_Objective_C-0Fn

#import "NSObject+PWObject.h"

@implementation NSObject (PWObject)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	int64_t delta = (int64_t)(1.0e9 * delay);
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), block);

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
