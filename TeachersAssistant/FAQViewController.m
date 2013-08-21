//
//  FAQViewController.m
//  infraction
//
//  Created by Brian Slick on 8/14/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "FAQViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface FAQViewController ()

// Private Properties


// Notification Handlers



// UI Response Methods
- (void)refreshButtonPressed:(UIBarButtonItem *)button;
- (void)doneButtonPressed:(UIBarButtonItem *)button;

// Misc Methods
- (void)refreshWebView;

@end

@implementation FAQViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainWebView = ivMainWebView;

// Private

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainWebView:nil];
	
	
	// Private Properties
	
	
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	[self setMainWebView:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

#pragma mark - Initialization and UI Creation Methods

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:@"FAQ"];
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																				target:self
																				action:@selector(doneButtonPressed:)];
	[[self navigationItem] setLeftBarButtonItem:doneButton];
	[doneButton release], doneButton = nil;
	
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																				   target:self
																				   action:@selector(refreshButtonPressed:)];
	[[self navigationItem] setRightBarButtonItem:refreshButton];
	[refreshButton release], refreshButton = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[self refreshWebView];
	
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
	
	[[self mainWebView] setDelegate:nil];
	
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

- (void)refreshButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[self refreshWebView];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)doneButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[self parentViewController] dismissModalViewControllerAnimated:YES];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (void)refreshWebView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSString *urlString = @"http://www.teachersassistantpro.com/Teachers_Assistant_Pro_iPad_iPhone_App/FAQ.html";
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	[[self mainWebView] loadRequest:request];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UIWebView Delegate Methods

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)webView:(UIWebView *)webView 
didFailLoadWithError:(NSError *)error
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSLog(@"The error is: %@", error);
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Load Error"
													message:@"Unable to load FAQ. Verify Internet connection."
												   delegate:nil
										  cancelButtonTitle:@"Ok"
										  otherButtonTitles:nil];
	[alert show];
	[alert release], alert = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
