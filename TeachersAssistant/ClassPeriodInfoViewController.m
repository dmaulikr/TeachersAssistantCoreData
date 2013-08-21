//
//  ClassPeriodInfoViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/21/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ClassPeriodInfoViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface ClassPeriodInfoViewController ()

// Private Properties


// Notification Handlers



// UI Response Methods
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)saveButtonPressed:(UIBarButtonItem *)button;


// Misc Methods

@end

@implementation ClassPeriodInfoViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTextField = ivMainTextField;

// Private
@synthesize classPeriod = ivClassPeriod;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTextField:nil];
	[self setClassPeriod:nil];
	
	// Private Properties
	
	
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	[self setMainTextField:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

#pragma mark - Initialization and UI Creation Methods

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:[[DataController sharedDataController] singularNameForTermInfoIndentifier:kTermInfoIdentifierClass]];
	
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
	
	[[self navigationController] setToolbarHidden:YES animated:YES];
	
	[[self mainTextField] setText:[[self classPeriod] name]];
	
	[[self mainTextField] becomeFirstResponder];
	
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
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)saveButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *newName = [[self mainTextField] text];
	
	if ( (newName == nil) || ([newName length] == 0) )
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry"
														message:@"You must provide a name"
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release], alert = nil;
		
		NSLog(@"<<< Leaving %s >>> EARLY - Invalid name", __PRETTY_FUNCTION__);
		return;
	}
	
	DataController *dataController = [DataController sharedDataController];
	NSManagedObjectContext *context = [dataController managedObjectContext];
	
	ClassPeriod *oldPeriod = [dataController classPeriodWithName:newName];
	if (oldPeriod != nil)					// Name exists
	{
		if (oldPeriod != [self classPeriod])		// It is not the original period
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry"
															message:@"That name already exists"
														   delegate:nil
												  cancelButtonTitle:@"Ok"
												  otherButtonTitles:nil];
			[alert show];
			[alert release], alert = nil;
			
			NSLog(@"<<< Leaving %s >>> EARLY - Invalid name", __PRETTY_FUNCTION__);
			return;
		}
	}
	
	
	
	if ([self classPeriod] == nil)				// Creating a new period
	{
		ClassPeriod *newPeriod = [ClassPeriod managedObjectInContextBTI:context];
		[newPeriod setName:newName];
		[newPeriod setSortOrder:[NSNumber numberWithInt:[dataController countOfClassPeriods]]];
	}
	else
	{
		[[self classPeriod] setName:newName];
	}
	
	[dataController saveCoreDataContext];
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


#pragma mark - Misc Methods




@end
