//
//  BTIViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/22/12.
//  Copyright (c) 2012 BriTer Ideas LLC. All rights reserved.
//

#import "BTIViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants

@interface BTIViewController ()

// Private Properties

// Notification Handlers

// UI Response Methods

// Misc Methods

@end

@implementation BTIViewController

#pragma mark - Synthesized Properties

// Public


// Private

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// Public Properties
	
	// Private Properties
	
	[super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)didReceiveMemoryWarning
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super didReceiveMemoryWarning];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Initialization and UI Creation Methods

- (id)init
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	self = [self initWithNibName:nil
						  bundle:nil];
	if (self)
	{
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return self;
}

#pragma mark - Custom Getters and Setters


#pragma mark - UIViewController Overrides

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	BOOL shouldRotate = YES;
	
	if (![[DataController sharedDataController] isIPadVersion])
	{
		shouldRotate = (interfaceOrientation == UIInterfaceOrientationPortrait);
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return shouldRotate;
}

#pragma mark - Notification Handlers


#pragma mark - UI Response Methods


#pragma mark - Misc Methods
@end
