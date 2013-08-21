//
//  NSManagedObject+BTIAdditions.h
//  DeskWalkerMac
//
//  Created by Brian Slick on 8/28/12.
//  Copyright (c) 2012 BriTer Ideas LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (BTIAdditions)

+ (NSEntityDescription *)entityDescriptionInContextBTI:(NSManagedObjectContext *)context;
+ (id)managedObjectInContextBTI:(NSManagedObjectContext *)context;

@end
