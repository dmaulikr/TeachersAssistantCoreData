//
//  LongTextDetailViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/20/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "LongTextDetailViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface LongTextDetailViewController ()

// Private Properties
@property (nonatomic, copy) NSString *temporaryContents;

// Notification Handlers
- (void)applicationWillResignActive:(NSNotification *)notification;


// UI Response Methods
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)saveButtonPressed:(UIBarButtonItem *)button;


// Misc Methods

@end

@implementation LongTextDetailViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTextView = ivMainTextView;
@synthesize scratchActionValue = ivScratchActionValue;

// Private
@synthesize temporaryContents = ivTemporaryContents;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTextView:nil];
	[self setScratchActionValue:nil];
	
	// Private Properties
	[self setTemporaryContents:nil];
	
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	[self setMainTextView:nil];
	
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
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
	
	[[self mainTextView] setText:[[self scratchActionValue] longText]];
	
	if ([self temporaryContents] != nil)
	{
		[[self mainTextView] setText:[self temporaryContents]];
		[self setTemporaryContents:nil];
	}
	
	[[self mainTextView] becomeFirstResponder];
	
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
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Notification Handlers

- (void)applicationWillResignActive:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self setTemporaryContents:[[self mainTextView] text]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UI Response Methods

- (void)cancelButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)saveButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *text = [[self mainTextView] text];
	
	[[self scratchActionValue] setLongText:text];
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods




@end
