//
//  PersonActionsCell.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/15/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "PersonActionsCell.h"

// Models and other global

// Private Constants


@interface PersonActionsCell ()

// Private Properties


// Notification Handlers



// UI Response Methods



// Misc Methods

@end

@implementation PersonActionsCell

#pragma mark - Synthesized Properties

// Public
@synthesize actionLabel = ivActionLabel;
@synthesize descriptionLabel = ivDescriptionLabel;
@synthesize dateLabel = ivDateLabel;
@synthesize colorView1 = ivColorView1;
@synthesize colorView2 = ivColorView2;
@synthesize colorView3 = ivColorView3;
@synthesize colorView4 = ivColorView4;
@synthesize colorView5 = ivColorView5;


// Private

#pragma mark - Dealloc and Memory Management

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Public
    [self setActionLabel:nil];
    [self setDescriptionLabel:nil];
    [self setDateLabel:nil];
    [self setColorView1:nil];
    [self setColorView2:nil];
    [self setColorView3:nil];
    [self setColorView4:nil];
    [self setColorView5:nil];
	
	
	// Private
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

- (NSString *)reuseIdentifier
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
    return [[self class] reuseIdentifier];
}

#pragma mark - Initialization and UI Creation Methods

- (id)initWithStyle:(UITableViewCellStyle)style
	reuseIdentifier:(NSString *)reuseIdentifier
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
	{
        // Initialization code
    }
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
    return self;
}

- (void)awakeFromNib
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UITableViewCell Methods

- (void)setSelected:(BOOL)selected
		   animated:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods

+ (NSString *)reuseIdentifier
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return NSStringFromClass([self class]);
}

- (void)setColorForBackground:(UIColor *)color
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	if (color == nil)
	{
		color = [UIColor whiteColor];
	}

	[[self actionLabel] setBackgroundColor:color];
	[[self descriptionLabel] setBackgroundColor:color];
	[[self dateLabel] setBackgroundColor:color];
	[self setBackgroundColor:color];
//	[[self contentView] setBackgroundColor:color];
//	[[self backgroundView] setBackgroundColor:color];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
