//
//  Parent.h
//  TeachersAssistant
//
//  Created by Brian Slick on 10/7/11.
//  Copyright (c) 2011 BriTer Ideas LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonAttributes.h"

@class EmailAddress, Person, PhoneNumber;

@interface Parent : CommonAttributes {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *emailAddresses;
@property (nonatomic, retain) NSSet *phoneNumbers;
@property (nonatomic, retain) Person *student;
@end

@interface Parent (CoreDataGeneratedAccessors)

- (void)addEmailAddressesObject:(EmailAddress *)value;
- (void)removeEmailAddressesObject:(EmailAddress *)value;
- (void)addEmailAddresses:(NSSet *)values;
- (void)removeEmailAddresses:(NSSet *)values;
- (void)addPhoneNumbersObject:(PhoneNumber *)value;
- (void)removePhoneNumbersObject:(PhoneNumber *)value;
- (void)addPhoneNumbers:(NSSet *)values;
- (void)removePhoneNumbers:(NSSet *)values;
@end
