//
//  PersonFilterBooleanViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/23/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "PersonFilterBooleanViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface PersonFilterBooleanViewController ()

// Private Properties


// Notification Handlers



// UI Response Methods
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)button;
- (IBAction)saveButtonPressed:(UIBarButtonItem *)button;


// Misc Methods

@end

@implementation PersonFilterBooleanViewController

#pragma mark - Synthesized Properties

// Public
@synthesize titleLabel = ivTitleLabel;
@synthesize segmentedControl = ivSegmentedControl;
@synthesize actionFieldInfo = ivActionFieldInfo;
@synthesize actionValue = ivActionValue;

// Private

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setTitleLabel:nil];
	[self setSegmentedControl:nil];
	[self setActionFieldInfo:nil];
	[self setActionValue:nil];
	
	// Private Properties
	
	
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	[self setSegmentedControl:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

#pragma mark - Initialization and UI Creation Methods

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	DataController *dataController = [DataController sharedDataController];
	[[self titleLabel] setText:[dataController singularNameForTermInfo:[[self actionFieldInfo] termInfo]]];
	
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
	
	if ([self actionValue] == nil)
	{
		[[self segmentedControl] setSelectedSegmentIndex:UISegmentedControlNoSegment];
	}
	else
	{
		[[self segmentedControl] setSelectedSegmentIndex:([[[self actionValue] boolean] boolValue]) ? 0 : 1];
	}
	
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

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger segmentIndex = [[self segmentedControl] selectedSegmentIndex];
	if (segmentIndex == UISegmentedControlNoSegment)
		segmentIndex = 1;
	
	DataController *dataController = [DataController sharedDataController];
	NSManagedObjectContext *context = [dataController managedObjectContext];
	
	if ([self actionValue] == nil)
	{
		ActionValue *newActionValue = [ActionValue managedObjectInContextBTI:context];
		[newActionValue setActionFieldInfo:[self actionFieldInfo]];
		[newActionValue setAction:[dataController filterAction]];
		
		[self setActionValue:newActionValue];
	}
	
	switch (segmentIndex) {
		case 0:
			[[self actionValue] setBoolean:[NSNumber numberWithBool:YES]];
			break;
		case 1:
			[[self actionValue] setBoolean:[NSNumber numberWithBool:NO]];
			break;
		default:
			break;
	}
	
	[dataController saveCoreDataContext];
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


#pragma mark - Misc Methods




@end
