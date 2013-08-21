//
//  NSManagedObject+BTIAdditions.m
//  DeskWalkerMac
//
//  Created by Brian Slick on 8/28/12.
//  Copyright (c) 2012 BriTer Ideas LLC. All rights reserved.
//

#import "NSManagedObject+BTIAdditions.h"

@implementation NSManagedObject (BTIAdditions)

+ (NSEntityDescription *)entityDescriptionInContextBTI:(NSManagedObjectContext *)context
{
	//NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);


	//NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
}

+ (id)managedObjectInContextBTI:(NSManagedObjectContext *)context
{
	//NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSEntityDescription *entity = [[self class] entityDescriptionInContextBTI:context];

	//NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [[[[self class] alloc] initWithEntity:entity insertIntoManagedObjectContext:context] autorelease];
}

@end
