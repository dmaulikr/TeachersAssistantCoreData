//
//  ParentEmailInfoViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/24/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ParentEmailInfoViewController.h"

// Models and other global

// Sub-controllers

// Views
#import "UICustomSwitch.h"

// Private Constants


@interface ParentEmailInfoViewController ()

// Private Properties


// Notification Handlers



// UI Response Methods
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)saveButtonPressed:(UIBarButtonItem *)button;


// Misc Methods

@end

@implementation ParentEmailInfoViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTextField = ivMainTextField;
@synthesize segmentedControl = ivSegmentedControl;
@synthesize customSwitch = ivCustomSwitch;
@synthesize scratchObjectContext = ivScratchObjectContext;
@synthesize scratchParent = ivScratchParent;
@synthesize scratchEmailAddress = ivScratchEmailAddress;


// Private


#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
    [self setMainTextField:nil];
    [self setSegmentedControl:nil];
    [self setCustomSwitch:nil];
    [self setScratchObjectContext:nil];
    [self setScratchParent:nil];
    [self setScratchEmailAddress:nil];
	
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
    [self setCustomSwitch:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

#pragma mark - Initialization and UI Creation Methods

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:@"Email"];
	
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
	
	// Adjust the switch
	
	CGPoint center = [[self customSwitch] center];
	
	CGRect bounds = [[self customSwitch] bounds];
	bounds.size.height = 27.0;
	[[self customSwitch] setBounds:bounds];
	
	[[self customSwitch] setCenter:center];
	
	[[[self customSwitch] leftLabel] setText:@"Yes"];
	[[[self customSwitch] rightLabel] setText:@"No"];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
		
	[[self segmentedControl] setTitle:kContactInfoTypeHome forSegmentAtIndex:0];
	[[self segmentedControl] setTitle:kContactInfoTypeWork forSegmentAtIndex:1];
	[[self segmentedControl] setTitle:kContactInfoTypeOther forSegmentAtIndex:2];
	
	if ([self scratchEmailAddress] == nil)
	{
		[[self mainTextField] setText:nil];
		[[self segmentedControl] setSelectedSegmentIndex:0];
		[[self customSwitch] setOn:NO];
	}
	else
	{
		[[self mainTextField] setText:[[self scratchEmailAddress] value]];
		[[self customSwitch] setOn:[[[self scratchEmailAddress] isDefault] boolValue]];
		
		NSString *identifier = [[self scratchEmailAddress] type];
		
		if ([identifier isEqualToString:kContactInfoTypeHome])
		{
			[[self segmentedControl] setSelectedSegmentIndex:0];
		}
		else if ([identifier isEqualToString:kContactInfoTypeWork])
		{
			[[self segmentedControl] setSelectedSegmentIndex:1];
		}
		else if ([identifier isEqualToString:kContactInfoTypeOther])
		{
			[[self segmentedControl] setSelectedSegmentIndex:2];
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

	NSString *email = [[self mainTextField] text];
	
	if ( (email == nil) || ([email length] < 3) )
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"You must provide an email address"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release], alert = nil;
		
		NSLog(@"<<< Leaving %s >>> EARLY - No email address", __PRETTY_FUNCTION__);
		return;
	}

	// TODO: Use if default is limited to one person
//	if ([[self customSwitch] isOn])
//	{
//		for (EmailAddress *emailAddress in [[self scratchParent] emailAddresses])
//		{
//			[emailAddress setIsDefault:[NSNumber numberWithBool:NO]];
//		}
//	}

	NSManagedObjectContext *context = [self scratchObjectContext];
	
	if ([self scratchEmailAddress] == nil)
	{
		EmailAddress *emailAddress = [EmailAddress managedObjectInContextBTI:context];
		[emailAddress setParent:[self scratchParent]];
		[emailAddress setSortOrder:[NSNumber numberWithInt:[[[self scratchParent] emailAddresses] count]]];
		
		[self setScratchEmailAddress:emailAddress];
	}
	
	[[self scratchEmailAddress] setValue:email];
	[[self scratchEmailAddress] setIsDefault:[NSNumber numberWithBool:[[self customSwitch] isOn]]];
	
	NSString *type = nil;
	
	switch ([[self segmentedControl] selectedSegmentIndex]) {
		case 0:
			type = kContactInfoTypeHome;
			break;
		case 1:
			type = kContactInfoTypeWork;
			break;
		case 2:
			type = kContactInfoTypeOther;
			break;
		default:
			break;
	}
	
	[[self scratchEmailAddress] setType:type];
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods




@end
