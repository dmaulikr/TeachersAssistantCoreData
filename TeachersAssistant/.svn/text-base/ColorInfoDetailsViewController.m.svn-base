//
//  ColorInfoDetailsViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/29/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ColorInfoDetailsViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface ColorInfoDetailsViewController ()

// Private Properties
@property (nonatomic, retain) UIColor *currentColor;
@property (nonatomic, retain) NSNumberFormatter *numberFormatter;

// Notification Handlers



// UI Response Methods
- (void)cancelButtonPressed:(UIBarButtonItem *)button;
- (void)saveButtonPressed:(UIBarButtonItem *)button;


// Misc Methods
- (void)updateColorView;

@end

@implementation ColorInfoDetailsViewController

#pragma mark - Synthesized Properties

// Public
@synthesize nameTextField = ivNameTextField;
@synthesize pointTextField = ivPointTextField;
@synthesize colorView = ivColorView;
@synthesize redSlider = ivRedSlider;
@synthesize greenSlider = ivGreenSlider;
@synthesize blueSlider = ivBlueSlider;
@synthesize colorInfo = ivColorInfo;


// Private
@synthesize currentColor = ivCurrentColor;
@synthesize numberFormatter = ivNumberFormatter;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
    [self setNameTextField:nil];
    [self setPointTextField:nil];
    [self setColorView:nil];
    [self setRedSlider:nil];
    [self setGreenSlider:nil];
    [self setBlueSlider:nil];
    [self setColorInfo:nil];
	
	
	// Private Properties
	[self setCurrentColor:nil];
	[self setNumberFormatter:nil];
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	[self setNameTextField:nil];
    [self setPointTextField:nil];
    [self setColorView:nil];
    [self setRedSlider:nil];
    [self setGreenSlider:nil];
    [self setBlueSlider:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

#pragma mark - Initialization and UI Creation Methods

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:[[DataController sharedDataController] singularNameForTermInfoIndentifier:kTermInfoIdentifierColorLabel]];
	
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
	
	// Number Formatter
	
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setLocale:[NSLocale currentLocale]];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[formatter setMaximumFractionDigits:2];
	
	[self setNumberFormatter:formatter];
	
	[formatter release], formatter = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self navigationController] setToolbarHidden:YES animated:YES];
	
	[[self nameTextField] setText:[[self colorInfo] name]];
	
	NSString *points = [NSNumberFormatter localizedStringFromNumber:[[self colorInfo] pointValue] numberStyle:NSNumberFormatterDecimalStyle];
	[[self pointTextField] setText:points];
	
	if (![[NSUserDefaults standardUserDefaults] btiShouldShowColorPointValues])
	{
		[[self pointTextField] setHidden:YES];
		
		CGRect frame = [[self nameTextField] frame];
		frame.size.width = 280.0;
		[[self nameTextField] setFrame:frame];
	}
	
	if ([self colorInfo] != nil)
	{
		const CGFloat *components = CGColorGetComponents([[[self colorInfo] color] CGColor]);
		
		[[self redSlider] setValue:components[0]];
		[[self greenSlider] setValue:components[1]];
		[[self blueSlider] setValue:components[2]];
	}
	else
	{
		[[self redSlider] setValue:0.5];
		[[self greenSlider] setValue:0.5];
		[[self blueSlider] setValue:0.5];
	}
	
	[self updateColorView];
	
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

- (void)cancelButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[self navigationController] popViewControllerAnimated:YES];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)saveButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	DataController *dataController = [DataController sharedDataController];
	NSManagedObjectContext *context = [dataController managedObjectContext];
	
	if ([self colorInfo] == nil)
	{
		ColorInfo *newColorInfo = [ColorInfo managedObjectInContextBTI:context];
		[self setColorInfo:newColorInfo];
		
		NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
		[fetchRequest setEntity:[ColorInfo entityDescriptionInContextBTI:context]];
		
		[newColorInfo setSortOrder:[NSNumber numberWithInt:[context countForFetchRequest:fetchRequest error:nil]]];
	}
	
	[[self colorInfo] setColor:[self currentColor]];
	[[self colorInfo] setName:[[self nameTextField] text]];
	[[self colorInfo] setPointValue:[[self numberFormatter] numberFromString:[[self pointTextField] text]]];
	
	[dataController saveCoreDataContext];
	
	[dataController resetPointTotalsForAllPersons];
	[dataController resetGradingPeriodActionTotalForAllPersons];
	
	[[self navigationController] popViewControllerAnimated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (IBAction)sliderValueChanged:(UISlider *)slider
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[self updateColorView];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

- (void)updateColorView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	CGFloat red = [[self redSlider] value];
	CGFloat green = [[self greenSlider] value];
	CGFloat blue = [[self blueSlider] value];
	
	UIColor *newColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
	
	[[self colorView] setBackgroundColor:newColor];
	
	[self setCurrentColor:newColor];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UITextFieldDelegate Methods

// http://stackoverflow.com/questions/8076160/limiting-text-field-entry-to-only-one-decimal-point
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	BOOL shouldReplace = YES;
	
	NSString *newString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
	
	NSArray *components = [newString componentsSeparatedByString:[[self numberFormatter] decimalSeparator]];
	
	if ([components count] > 2)
	{
		shouldReplace = NO;
	}
	else if ([components count] == 2)
	{
		NSString *fractionString = [components objectAtIndex:1];
		shouldReplace = !([fractionString length] > 2);
		
		if ( (shouldReplace) && ([fractionString length] > 0) )
		{
			NSNumber *testNumber = [[self numberFormatter] numberFromString:fractionString];
			if (testNumber == nil)
			{
				shouldReplace = NO;
			}
		}
	}

	if (shouldReplace)
	{
		
		NSNumber *testNumber = [[self numberFormatter] numberFromString:newString];
		
		if (testNumber == nil)
		{
			if ([newString length] == 0)
			{
				shouldReplace = YES;
			}
			else if ( ([newString hasPrefix:[[self numberFormatter] decimalSeparator]]) || ([newString hasPrefix:[[self numberFormatter] negativePrefix]]) )
			{
				shouldReplace = YES;
			}
			else
			{
				shouldReplace = NO;
			}
		}
		else
		{
			shouldReplace = YES;
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return shouldReplace;
}


@end
