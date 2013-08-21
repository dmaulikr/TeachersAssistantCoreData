//
//  PersonInfoCell.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/15/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "PersonInfoCell.h"

// Models and other global

// Private Constants


@interface PersonInfoCell ()

// Private Properties


// Notification Handlers



// UI Response Methods



// Misc Methods

@end

@implementation PersonInfoCell

#pragma mark - Synthesized Properties

// Public
@synthesize label = ivLabel;
@synthesize textField = ivTextField;

// Private

#pragma mark - Dealloc and Memory Management

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Public
	[self setLabel:nil];
	[self setTextField:nil];
	
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

@end
