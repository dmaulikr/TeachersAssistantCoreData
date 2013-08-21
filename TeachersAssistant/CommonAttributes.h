//
//  CommonAttributes.h
//  TeachersAssistant
//
//  Created by Brian Slick on 10/7/11.
//  Copyright (c) 2011 BriTer Ideas LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CommonAttributes : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) NSNumber * exchangeIdentifier;

@end
