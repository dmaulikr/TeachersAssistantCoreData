//
//  UpgradeViewController_iPad.m
//  infraction
//
//  Created by Brian Slick on 10/6/10.
//  Copyright 2010 BriTer Ideas LLC. All rights reserved.
//

#import "UpgradeViewController_iPad.h"


// Models and other global
#import "DataController.h"
#import "Constants.h"

// Sub-controllers

@implementation UpgradeViewController_iPad

#pragma mark - Synthesized Properties

@synthesize exportButton = ivExportButton;


#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [ivExportButton release], ivExportButton = nil;
	
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
	
	[self setTitle:@"Upgrade"];
	
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
	
	NSString *urlString = [NSString stringWithFormat:@"%@://", kNativeFileExtension];
	[[self exportButton] setEnabled:[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]];
	
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

- (IBAction)downloadButtonPressed:(UIButton *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	//http://itunes.apple.com/us/app/idiscipline-the-tool-for-teachers/id391643755?mt=8
	NSString *stringURL = @"http://itunes.apple.com/us/app/teachers-assistant-pro-track/id391643755?mt=8";			//@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=317154259&mt=8";
	NSURL *url = [NSURL URLWithString:stringURL];
	[[UIApplication sharedApplication] openURL:url];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (IBAction)exportButtonPressed:(UIButton *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[UIApplication sharedApplication] openURL:[[DataController sharedDataController] urlForFullVersionExport]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods



@end
