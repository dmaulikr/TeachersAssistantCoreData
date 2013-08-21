//
//  ActionDetailBooleanCell.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/22/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ActionDetailBooleanCell.h"

// Models and other global
#import "UICustomSwitch.h"

// Private Constants


@interface ActionDetailBooleanCell ()

// Private Properties


// Notification Handlers



// UI Response Methods



// Misc Methods

@end

@implementation ActionDetailBooleanCell

#pragma mark - Synthesized Properties

// Public
@synthesize customSwitch = ivCustomSwitch;

// Private

#pragma mark - Dealloc and Memory Management

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Public
	[self setCustomSwitch:nil];
	
	// Private
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters



#pragma mark - Initialization and UI Creation Methods

- (void)awakeFromNib
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super awakeFromNib];
	
	CGPoint center = [[self customSwitch] center];
	
	CGRect bounds = [[self customSwitch] bounds];
	bounds.size.height = 27.0;
	[[self customSwitch] setBounds:bounds];
	
	[[self customSwitch] setCenter:center];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UITableViewCell Methods

#pragma mark - Misc Methods


@end
