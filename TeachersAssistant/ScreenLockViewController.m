//
//  ScreenLockViewController.m
//  infraction
//
//  Created by Brian Slick on 3/8/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ScreenLockViewController.h"


// Models and other global


// Sub-controllers

@implementation ScreenLockViewController

#pragma mark - Synthesized Properties

@synthesize promptLabel = ivPromptLabel;
@synthesize entryTextField = ivEntryTextField;
@synthesize pinLabel1 = ivPinLabel1;
@synthesize pinLabel2 = ivPinLabel2;
@synthesize pinLabel3 = ivPinLabel3;
@synthesize pinLabel4 = ivPinLabel4;
@synthesize password = ivPassword;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
    [self setPromptLabel:nil];
    [self setEntryTextField:nil];
    [self setPinLabel1:nil];
    [self setPinLabel2:nil];
    [self setPinLabel3:nil];
    [self setPinLabel4:nil];
    [self setPassword:nil];
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	[self setPromptLabel:nil];
    [self setEntryTextField:nil];
    [self setPinLabel1:nil];
    [self setPinLabel2:nil];
    [self setPinLabel3:nil];
    [self setPinLabel4:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

#pragma mark - Initialization and UI Creation Methods

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	// Table view color workaround
	
	UIView *mainView = [self view];
	UITableView *tableView = [[UITableView alloc] initWithFrame:[mainView bounds] style:UITableViewStyleGrouped];
	[tableView setAutoresizingMask:[mainView autoresizingMask]];
	
	[mainView addSubview:tableView];
	[mainView sendSubviewToBack:tableView];
	
	[tableView release], tableView = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
	
	[self setPassword:[[NSUserDefaults standardUserDefaults] btiScreenLockPin]];
	
	[[self promptLabel] setText:@"Enter PIN"];
	
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

- (IBAction)resumeButtonPressed:(UIButton *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[self entryTextField] becomeFirstResponder];

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
		[label setText:[NSString stringWithUTF8String:"\u2022"]];
	}
	
	if (length == 4)
	{
		if ([entry isEqualToString:[self password]])
		{
			NSLog(@"Match!");
			[[self parentViewController] dismissModalViewControllerAnimated:YES];
		}
		else
		{
			NSLog(@"NO MATCH!");
			[[self promptLabel] setText:@"PIN did not match, try again:"];
			[[self entryTextField] setText:nil];
			[self updateLabels];
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
