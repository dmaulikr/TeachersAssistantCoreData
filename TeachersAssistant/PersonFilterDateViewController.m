//
//  PersonFilterDateViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/23/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "PersonFilterDateViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface PersonFilterDateViewController ()

// Private Properties
@property (nonatomic, copy) NSDate *fromDate;
@property (nonatomic, copy) NSDate *toDate;

// Notification Handlers



// UI Response Methods
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)button;
- (IBAction)saveButtonPressed:(UIBarButtonItem *)button;


// Misc Methods

@end

@implementation PersonFilterDateViewController

#pragma mark - Synthesized Properties

// Public
@synthesize segmentedControl = ivSegmentedControl;
@synthesize datePicker = ivDatePicker;
@synthesize actionFieldInfo = ivActionFieldInfo;
@synthesize actionValue = ivActionValue;

// Private
@synthesize fromDate = ivFromDate;
@synthesize toDate = ivToDate;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setSegmentedControl:nil];
	[self setDatePicker:nil];
	[self setActionFieldInfo:nil];
	[self setActionValue:nil];
	
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
	
	[self setSegmentedControl:nil];
	[self setDatePicker:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

#pragma mark - Initialization and UI Creation Methods


#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:@"Date Range"];
	
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
	
	NSDate *from = [[self actionValue] filterFromDate];
	NSDate *to = [[self actionValue] filterToDate];
	
	if (from == nil)
		from = [NSDate date];
	if (to == nil)
		to = [NSDate date];
	
	[self setFromDate:from];
	[self setToDate:to];
	
	[[self datePicker] setDate:[self fromDate] animated:NO];
	
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

- (IBAction)quickButtonPressed:(UIButton *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger tag = [button tag];
	NSInteger index = [[self segmentedControl] selectedSegmentIndex];
	
	NSDate *rightNow = [NSDate date];
	
	switch (tag)
	{
		case 1:				// Today
		{
			[self setToDate:rightNow];
			[self setFromDate:rightNow];
			break;
		}
		case 2:				// Yesterday
		{
			NSCalendar *calendar = [NSCalendar currentCalendar];
			
			NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit fromDate:rightNow];
			[dateComponents setWeekday:[dateComponents weekday] - 1];
			NSDate *date = [calendar dateFromComponents:dateComponents];
			
			[self setToDate:date];
			[self setFromDate:date];
			break;
		}
		case 3:				// Last 7 Days
		{
			NSCalendar *calendar = [NSCalendar currentCalendar];
			
			NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit |NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:rightNow];
			[dateComponents setDay:[dateComponents day] - 7];
			NSDate *from = [calendar dateFromComponents:dateComponents];
			
			[self setToDate:rightNow];
			[self setFromDate:from];
			break;
		}
		default:
			break;
	}
	
	switch (index)
	{
		case 0:
			[[self datePicker] setDate:[self fromDate] animated:YES];
			break;
		case 1:
			[[self datePicker] setDate:[self toDate] animated:YES];
			break;
		default:
			break;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)button
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
	NSManagedObjectContext *context = [dataController managedObjectContext];
	
	if ([self actionValue] == nil)
	{
		ActionValue *newActionValue = [ActionValue managedObjectInContextBTI:context];
		[newActionValue setActionFieldInfo:[self actionFieldInfo]];
		[newActionValue setAction:[dataController filterAction]];
		
		[self setActionValue:newActionValue];
	}
	
	[[self actionValue] setFilterFromDate:from];
	[[self actionValue] setFilterToDate:to];
	
	[dataController saveCoreDataContext];
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods




@end
