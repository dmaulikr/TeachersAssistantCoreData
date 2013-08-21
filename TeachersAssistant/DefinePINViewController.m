//
//  DefinePINViewController.m
//  infraction
//
//  Created by Brian Slick on 3/8/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "DefinePINViewController.h"


// Models and other global
#import "DataController.h"
#import "Constants.h"

// Sub-controllers

@implementation DefinePINViewController

#pragma mark - Synthesized Properties

@synthesize promptLabel = ivPromptLabel;
@synthesize entryTextField = ivEntryTextField;
@synthesize pinLabel1 = ivPinLabel1;
@synthesize pinLabel2 = ivPinLabel2;
@synthesize pinLabel3 = ivPinLabel3;
@synthesize pinLabel4 = ivPinLabel4;
@synthesize firstPass = ivFirstPass;
@synthesize password = ivPassword;


#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [ivPromptLabel release], ivPromptLabel = nil;
    [ivEntryTextField release], ivEntryTextField = nil;
    [ivPinLabel1 release], ivPinLabel1 = nil;
    [ivPinLabel2 release], ivPinLabel2 = nil;
    [ivPinLabel3 release], ivPinLabel3 = nil;
    [ivPinLabel4 release], ivPinLabel4 = nil;
    [ivPassword release], ivPassword = nil;
	
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

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:@"Create PIN"];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																				  target:self
																				  action:@selector(cancelButtonPressed:)];
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	[cancelButton release], cancelButton = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
	
	[[self promptLabel] setText:@"Enter PIN"];
	
	[self setFirstPass:YES];
	
	[self updateLabels];
	
	[[self entryTextField] becomeFirstResponder];
	
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
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidDisappear:animated];
	
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Notification Handlers

- (void)textFieldDidChangeNotification:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[self updateLabels];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UI Response Methods

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[self navigationController] popViewControllerAnimated:YES];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (void)updateLabels
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSArray *labelArray = [NSArray arrayWithObjects:[self pinLabel1], [self pinLabel2], [self pinLabel3], [self pinLabel4], nil];
	[[self pinLabel1] setText:nil];
	[[self pinLabel2] setText:nil];
	[[self pinLabel3] setText:nil];
	[[self pinLabel4] setText:nil];
	
	NSString *entry = [[self entryTextField] text];
	NSInteger length = [entry length];
	
	for (int index = 0; index < length; index++)
	{
		UILabel *label = (UILabel *)[labelArray objectAtIndex:index];
//		[label setText:@"@"];
		[label setText:[NSString stringWithUTF8String:"\u2022"]];
	}

	if (length == 4)
	{
		if ([self isFirstPass])
		{
			[self setPassword:entry];
			[self beginSecondPass];
		}
		else
		{
			if ([entry isEqualToString:[self password]])
			{
				NSLog(@"Match!");
				NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
				[userDefaults btiSetScreenLockEnabled:YES];
				[userDefaults btiSetScreenLockPin:entry];
				
				[[self navigationController] popViewControllerAnimated:YES];
			}
			else
			{
				NSLog(@"NO MATCH!");
				[[self promptLabel] setText:@"PIN did not match, try again:"];
				[self setFirstPass:YES];
				[[self entryTextField] setText:nil];
				[self updateLabels];
			}
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)beginSecondPass
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[self promptLabel] setText:@"Re-enter PIN"];
	[self setFirstPass:NO];
	[[self entryTextField] setText:nil];
	
	[[self pinLabel1] setText:nil];
	[[self pinLabel2] setText:nil];
	[[self pinLabel3] setText:nil];
	[[self pinLabel4] setText:nil];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return NO;
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	BOOL shouldReplace = YES;

	NSString *newString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
	
	if ( [newString length] < [[textField text] length] )
	{
		shouldReplace = NO;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return shouldReplace;
}

@end
