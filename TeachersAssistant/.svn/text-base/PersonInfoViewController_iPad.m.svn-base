//
//  PersonInfoViewController_iPad.m
//  TeachersAssistant
//
//  Created by Brian Slick on 6/3/12.
//  Copyright 2012 BriTer Ideas LLC. All rights reserved.
//

#import "PersonInfoViewController_iPad.h"

// Models and other global

// Sub-controllers
#import "HomeDetailViewController_iPad.h"

// Views

// Private Constants


@interface PersonInfoViewController_iPad ()

// Private Properties


// Notification Handlers



// UI Response Methods



// Misc Methods

@end

@implementation PersonInfoViewController_iPad

#pragma mark - Synthesized Properties

// Public

// Private

#pragma mark - Dealloc and Memory Methods

#pragma mark - Custom Getters and Setters

#pragma mark - Initialization and UI Creation Methods

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setToolbarItems:nil];
	
	[[self navigationItem] setLeftBarButtonItem:nil];
	[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
	[[self navigationItem] setHidesBackButton:YES];
	
	HomeDetailViewController_iPad *homeViewController = (HomeDetailViewController_iPad *)[[self splitViewController] delegate];
	[[self navigationItem] setLeftBarButtonItem:[homeViewController masterPopoverBarButtonItem]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self navigationController] setToolbarHidden:YES animated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidAppear:animated];
	
	HomeDetailViewController_iPad *homeViewController = (HomeDetailViewController_iPad *)[[self splitViewController] delegate];
	[[self navigationItem] setLeftBarButtonItem:[homeViewController masterPopoverBarButtonItem]];
	
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	HomeDetailViewController_iPad *homeViewController = (HomeDetailViewController_iPad *)[[self splitViewController] delegate];
	[[self navigationItem] setLeftBarButtonItem:[homeViewController masterPopoverBarButtonItem] animated:YES];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Notification Handlers



#pragma mark - UI Response Methods



#pragma mark - Misc Methods


#pragma mark - UITableView Datasource Methods



#pragma mark - UITableView Delegate Methods

//- (void)tableView:(UITableView *)tableView
//didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
//	
//	[tableView deselectRowAtIndexPath:indexPath animated:YES];
//	
//	
//	
//	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
//}


@end
