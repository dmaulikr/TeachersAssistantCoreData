//
//  DateDetailViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/20/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "DateDetailViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface DateDetailViewController ()

// Private Properties


// Notification Handlers



// UI Response Methods
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)saveButtonPressed:(UIBarButtonItem *)button;


// Misc Methods

@end

@implementation DateDetailViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainDatePicker = ivMainDatePicker;
@synthesize scratchActionValue = ivScratchActionValue;

// Private

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainDatePicker:nil];
	[self setScratchActionValue:nil];
	
	// Private Properties
	
	
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	[self setMainDatePicker:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

#pragma mark - Initialization and UI Creation Methods

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	ActionFieldInfo *actionFieldInfo = [[self scratchActionValue] actionFieldInfo];
	TermInfo *termInfo = [actionFieldInfo termInfo];
	
	[self setTitle:[[DataController sharedDataController] singularNameForTermInfo:termInfo]];
	
	// Table view color workaround
	
	UIView *mainView = [self view];
	UITableView *tableView = [[UITableView alloc] initWithFrame:[mainView bounds] style:UITableViewStyleGrouped];
	[tableView setAutoresizingMask:[mainView autoresizingMask]];
	
	[mainView addSubview:tableView];
	[mainView sendSubviewToBack:tableView];
	
	[tableView release], tableView = nil;
	
	// Buttons
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																				  target:self
																				  action:@selector(cancelButtonPressed:)];
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	[cancelButton release], cancelButton = nil;
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																				target:self
																				action:@selector(saveButtonPressed:)];
	[[self navigationItem] setRightBarButtonItem:saveButton];
	[saveButton release], saveButton = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	NSLog(@"scratchActionValue is: %@", [self scratchActionValue]);
	NSDate *date = [[self scratchActionValue] date];
	NSLog(@"date is: %@", date);
	if (date == nil)
	{
		date = [NSDate date];	
	}
	
	[[self mainDatePicker] setDate:date animated:YES];
	
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



#pragma mark - UI Response Methods

- (void)cancelButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kPopoverShouldFinishNotification object:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)saveButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSDate *date = [[self mainDatePicker] date];
	
	[[self scratchActionValue] setDate:date];
		
	NSLog(@"scratchActionValue is: %@", [self scratchActionValue]);
	NSLog(@"date is: %@", date);
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kPopoverShouldFinishNotification object:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods




@end
