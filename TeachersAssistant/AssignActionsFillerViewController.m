//
//  AssignActionsFillerViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/26/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "AssignActionsFillerViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface AssignActionsFillerViewController ()

// Private Properties


// Notification Handlers
- (void)shouldHideNotification:(NSNotification *)notification;


// UI Response Methods



// Misc Methods

@end

@implementation AssignActionsFillerViewController

#pragma mark - Synthesized Properties

// Public


// Private

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	
	
	// Private Properties
	
	
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

#pragma mark - Initialization and UI Creation Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldHideNotification:) name:kShouldHideActionDetailViewNotification object:nil];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return self;
}

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[[self navigationItem] setHidesBackButton:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidAppear:animated];
	
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillDisappear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillDisappear:animated];
	
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidDisappear:animated];
	
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Notification Handlers

- (void)shouldHideNotification:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[self navigationController] popToRootViewControllerAnimated:YES];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UI Response Methods



#pragma mark - Misc Methods




@end
