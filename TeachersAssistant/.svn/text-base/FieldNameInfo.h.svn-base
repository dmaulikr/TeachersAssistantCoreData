//
//  FieldNameInfo.h
//  infraction
//
//  Created by Brian Slick on 3/5/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFieldNameInfoInternalSingularKey				@"internalNameSingular"
#define kFieldNameInfoInternalPluralKey					@"internalNamePlural"
#define kFieldNameInfoUserSingularKey					@"userNameSingular"
#define kFieldNameInfoUserPluralKey						@"userNamePlural"
#define kFieldNameInfoSortOrderKey						@"sortOrder"

@interface FieldNameInfo : NSObject <NSCopying>
{
	NSString *ivInternalNameSingular;
	NSString *ivInternalNamePlural;
	NSString *ivUserNameSingular;
	NSString *ivUserNamePlural;
	
	NSNumber *ivSortOrder;
}

// Properties
@property (nonatomic, copy) NSString *internalNameSingular;
@property (nonatomic, copy) NSString *internalNamePlural;
@property (nonatomic, copy) NSString *userNameSingular;
@property (nonatomic, copy) NSString *userNamePlural;
@property (nonatomic, copy) NSNumber *sortOrder;


// Saving and reloading methods
- (id)attributes;
- (id)initWithAttributes:(id)attributes;


// Misc Methods
- (NSString *)singularName;
- (NSString *)pluralName;

@end
