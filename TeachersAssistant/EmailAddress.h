//
//  EmailAddress.h
//  TeachersAssistant
//
//  Created by Brian Slick on 10/7/11.
//  Copyright (c) 2011 BriTer Ideas LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonAttributes.h"

@class Parent;

@interface EmailAddress : CommonAttributes {
@private
}
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * isDefault;
@property (nonatomic, retain) Parent *parent;

@end
