//
//  BTILoadingHelper.m
//  TeachersAssistant
//
//  Created by Brian Slick on 10/31/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "BTILoadingHelper.h"

// Models and other global

// Private Constants

@interface BTILoadingHelper ()

// Private Properties


// Misc Methods

@end

@implementation BTILoadingHelper

#pragma mark - Synthesized Properties

// Public
@synthesize commonAttributes = ivCommonAttributes;
@synthesize attributes = ivAttributes;


// Private

#pragma mark - Dealloc and Memory Management

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// Public Properties
    [self setCommonAttributes:nil];
    [self setAttributes:nil];
	
	
	// Private Properties
	
	
	[super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

- (NSString *)description
{
	NSMutableString *string = [NSMutableString string];
	
	[string appendString:@"\nBTILoadingHelper object has the following properties:\n"];
	
	[string appendString:[NSString stringWithFormat:@"commonAttributes: %@\n", [self commonAttributes]]];
	[string appendString:[NSString stringWithFormat:@"attributes: %@\n", [self attributes]]];

	return string;                                                          
}

#pragma mark - Initialization

- (id)init
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	self = [super init];
	if (self)
	{
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return self;
}

#pragma mark - Saving and Loading Methods


#pragma mark - Misc Methods




@end
