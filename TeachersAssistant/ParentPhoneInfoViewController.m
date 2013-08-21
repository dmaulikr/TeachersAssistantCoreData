//
//  ParentPhoneInfoViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/24/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ParentPhoneInfoViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface ParentPhoneInfoViewController ()

// Private Properties


// Notification Handlers



// UI Response Methods
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)saveButtonPressed:(UIBarButtonItem *)button;


// Misc Methods

@end

@implementation ParentPhoneInfoViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTextField = ivMainTextField;
@synthesize segmentedControl = ivSegmentedControl;
@synthesize scratchObjectContext = ivScratchObjectContext;
@synthesize scratchParent = ivScratchParent;
@synthesize scratchPhoneNumber = ivScratchPhoneNumber;

// Private

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTextField:nil];
    [self setSegmentedControl:nil];
    [self setScratchObjectContext:nil];
    [self setScratchParent:nil];
	[self setScratchPhoneNumber:nil];
	
	// Private Properties
	
	
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	[self setMainTextField:nil];
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
	
	[self setTitle:@"Phone"];
	
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
		
	[[self segmentedControl] setTitle:kContactInfoTypeHome forSegmentAtIndex:0];
	[[self segmentedControl] setTitle:kContactInfoTypeWork forSegmentAtIndex:1];
	[[self segmentedControl] setTitle:kContactInfoTypeMobile forSegmentAtIndex:2];
	[[self segmentedControl] setTitle:kContactInfoTypeOther forSegmentAtIndex:3];
	
	
	if ([self scratchPhoneNumber] == nil)
	{
		[[self mainTextField] setText:nil];
		[[self segmentedControl] setSelectedSegmentIndex:0];
	}
	else
	{
		[[self mainTextField] setText:[[self scratchPhoneNumber] value]];
		
		NSString *identifier = [[self scratchPhoneNumber] type];
		
		if ([identifier isEqualToString:kContactInfoTypeHome])
		{
			[[self segmentedControl] setSelectedSegmentIndex:0];
		}
		else if ([identifier isEqualToString:kContactInfoTypeWork])
		{
			[[self segmentedControl] setSelectedSegmentIndex:1];
		}
		else if ([identifier isEqualToString:kContactInfoTypeMobile])
		{
			[[self segmentedControl] setSelectedSegmentIndex:2];
		}
		else if ([identifier isEqualToString:kContactInfoTypeOther])
		{
			[[self segmentedControl] setSelectedSegmentIndex:3];
		}
	}
	
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
	
	[[self mainTextField] resignFirstResponder];
	
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
	
	NSString *phone = [[self mainTextField] text];
	
	if ( (phone == nil) || ([phone length] < 2) )
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"You must provide a phone number"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release], alert = nil;
		
		NSLog(@"<<< Leaving %s >>> EARLY - No phone number", __PRETTY_FUNCTION__);
		return;
	}
	
	NSManagedObjectContext *context = [self scratchObjectContext];
	
	if ([self scratchPhoneNumber] == nil)
	{
		PhoneNumber *phoneNumber = [PhoneNumber managedObjectInContextBTI:context];
		[phoneNumber setParent:[self scratchParent]];
		[phoneNumber setSortOrder:[NSNumber numberWithInt:[[[self scratchParent] phoneNumbers] count]]];
		
		[self setScratchPhoneNumber:phoneNumber];
	}
	
	[[self scratchPhoneNumber] setValue:phone];
	
	NSString *type = nil;
	
	switch ([[self segmentedControl] selectedSegmentIndex]) {
		case 0:
			type = kContactInfoTypeHome;
			break;
		case 1:
			type = kContactInfoTypeWork;
			break;
		case 2:
			type = kContactInfoTypeMobile;
			break;
		case 3:
			type = kContactInfoTypeOther;
			break;
		default:
			break;
	}
	
	[[self scratchPhoneNumber] setType:type];
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


#pragma mark - Misc Methods




@end
