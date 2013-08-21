//
//  CommonAttributes+BTIAdditions.h
//  TeachersAssistant
//
//  Created by Brian Slick on 10/7/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//



@interface CommonAttributes (CommonAttributes_BTIAdditions)

- (NSDictionary *)exchangeAttributes;
- (void)populateAttributesWithExchangeAttributes:(NSDictionary *)attributes;
- (void)populateChildRelationshipsWithExchangeAttributes:(NSDictionary *)attributes
										   rootPredicate:(NSPredicate *)predicate
											fetchRequest:(NSFetchRequest *)fetchRequest
											   variables:(NSMutableDictionary *)variables;

@end
