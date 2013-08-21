//
//  GradingPeriodDetailViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 1/31/12.
//  Copyright 2012 BriTer Ideas LLC. All rights reserved.
//

#import "GradingPeriodDetailViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface GradingPeriodDetailViewController ()

// Private Properties
@property (nonatomic, copy) NSDate *fromDate;
@property (nonatomic, copy) NSDate *toDate;

// Notification Handlers



// UI Response Methods
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)saveButtonPressed:(UIBarButtonItem *)button;


// Misc Methods

@end

@implementation GradingPeriodDetailViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTextField = ivMainTextField;
@synthesize segmentedControl = ivSegmentedControl;
@synthesize datePicker = ivDatePicker;
@synthesize gradingPeriod = ivGradingPeriod;


// Private
@synthesize fromDate = ivFromDate;
@synthesize toDate = ivToDate;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
    [self setMainTextField:nil];
    [self setSegmentedControl:nil];
    [self setDatePicker:nil];
    [self setGradingPeriod:nil];
	
	
	// Private Properties
	[self setFromDate:nil];
	[self setToDate:nil];
	
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	[self setMainTextField:nil];
    [self setSegmentedControl:nil];
    [self setDatePicker:nil];
    [self setGradingPeriod:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

#pragma mark - Initialization and UI Creation Methods

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:[[DataController sharedDataController] singularNameForTermInfoIndentifier:kTermInfoIdentifierGradingPeriod]];
	
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
	
	NSDate *from = [[self gradingPeriod] startDate];
	NSDate *to = [[self gradingPeriod] endDate];
	
	if (from == nil)
		from = [NSDate date];
	if (to == nil)
		to = [NSDate date];
	
	[self setFromDate:from];
	[self setToDate:to];
	
	[[self datePicker] setDate:[self fromDate] animated:NO];
	
	[[self mainTextField] setText:[[self gradingPeriod] name]];
	
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

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)control
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger segment = [control selectedSegmentIndex];
	
	switch (segment)
	{
		case 0:
			[self setToDate:[[self datePicker] date]];
			[[self datePicker] setDate:[self fromDate] animated:YES];
			break;
		case 1:
			[self setFromDate:[[self datePicker] date]];
			[[self datePicker] setDate:[self toDate] animated:YES];
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)cancelButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)saveButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if ([[self segmentedControl] selectedSegmentIndex] == 0)
	{
		[self setFromDate:[[self datePicker] date]];
	}
	else
	{
		[self setToDate:[[self datePicker] date]];
	}
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDateComponents *fromDateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[self fromDate]];
	[fromDateComponents setHour:0];
	[fromDateComponents setMinute:0];
	[fromDateComponents setSecond:0];
	NSDate *from = [calendar dateFromComponents:fromDateComponents];
	
	NSLog(@"fromDate is: %@", [from description]);
	
	NSDateComponents *toDateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[self toDate]];
	[toDateComponents setHour:23];
	[toDateComponents setMinute:59];
	[toDateComponents setSecond:59];
	NSDate *to = [calendar dateFromComponents:toDateComponents];
	
	NSLog(@"toDate is: %@", [to description]);
	
	DataController *dataController = [DataController sharedDataController];
	
	if ([self gradingPeriod] == nil)
	{
		GradingPeriod *period = [[GradingPeriod alloc] init];
//		[period setName:[[self mainTextField] text]];
		[period setSelected:YES];
		[period setSortOrder:[NSNumber numberWithInt:[[dataController gradingPeriods] count]]];
		
		[self setGradingPeriod:period];
		
		for (GradingPeriod *gradingPeriod in [dataController gradingPeriods])
		{
			[gradingPeriod setSelected:NO];
		}
		
		[[dataController gradingPeriods] addObject:period];
		
		[dataController setActiveGradingPeriod:period];
		
		[period release], period = nil;
	}
	
	[[self gradingPeriod] setStartDate:from];
	[[self gradingPeriod] setEndDate:to];
	[[self gradingPeriod] setName:[[self mainTextField] text]];
	
	[dataController resetPointTotalsForAllPersons];
	[dataController resetGradingPeriodActionTotalForAllPersons];
	
	[dataController saveAllData];
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[textField resignFirstResponder];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return YES;
}

@end
