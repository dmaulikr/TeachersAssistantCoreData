//
//  MediaInfo+BTIAdditions.m
//  TeachersAssistant
//
//  Created by Brian Slick on 10/6/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "MediaInfo+BTIAdditions.h"

@interface MediaInfo (PrimitiveAccessors)

- (id)primitiveImage;
- (void)setPrimitiveImage:(id)newPrimitiveImage;

@end

@implementation MediaInfo (MediaInfo_BTIAdditions)

#pragma mark - Transient Properties

- (void)setImage:(UIImage *)anImage
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self willChangeValueForKey:kIMAGE];
    [self setPrimitiveImage:anImage];
    [self didChangeValueForKey:kIMAGE];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (UIImage *)image
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self willAccessValueForKey:kIMAGE];
	UIImage *anImage = (UIImage *)[self primitiveImage];
    [self didAccessValueForKey:kIMAGE];
	
    if (anImage == nil) 
	{
		if ([self fileName] != nil)
		{
			NSString *path = [[[DataController sharedDataController] imageDirectory] stringByAppendingPathComponent:[self fileName]];
			
			anImage = [UIImage imageWithContentsOfFile:path];
			[self setPrimitiveImage:anImage];
		}
    }
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return anImage;
}

- (NSDictionary *)exchangeAttributes
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSMutableDictionary *returnAttributes = [NSMutableDictionary dictionary];
	
	[returnAttributes addEntriesFromDictionary:[super exchangeAttributes]];
	
	if ([self type] != nil)
		[returnAttributes setObject:[self type] forKey:kTYPE];
	
	if ([self fileName] != nil)
		[returnAttributes setObject:[self fileName] forKey:kFILE_NAME];
	
	if ([self actionValueAudio] != nil)
		[returnAttributes setObject:[[self actionValueAudio] exchangeIdentifier] forKey:kACTION_VALUE_AUDIO];
	
	if ([self actionValueImage] != nil)
		[returnAttributes setObject:[[self actionValueImage] exchangeIdentifier] forKey:kACTION_VALUE_IMAGE];
	
	if ([self actionValueVideo] != nil)
		[returnAttributes setObject:[[self actionValueVideo] exchangeIdentifier] forKey:kACTION_VALUE_VIDEO];
	
	if ([self personLarge] != nil)
		[returnAttributes setObject:[[self personLarge] exchangeIdentifier] forKey:kPERSON_LARGE];
	
	if ([self personSmall] != nil)
		[returnAttributes setObject:[[self personSmall] exchangeIdentifier] forKey:kPERSON_SMALL];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return returnAttributes;
}

- (void)populateAttributesWithExchangeAttributes:(NSDictionary *)attributes
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super populateAttributesWithExchangeAttributes:attributes];
	
	[self setType:[attributes objectForKey:kTYPE]];
	
	[self setFileName:[attributes objectForKey:kFILE_NAME]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)populateChildRelationshipsWithExchangeAttributes:(NSDictionary *)attributes
										   rootPredicate:(NSPredicate *)predicate
											fetchRequest:(NSFetchRequest *)fetchRequest
											   variables:(NSMutableDictionary *)variables
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// There are no child relationships
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
