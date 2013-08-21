//
//  ActionDetailCell.m
//  TeachersAssistant
//
//  Created by Brian Slick on 10/6/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ActionDetailCell.h"

// Models and other global

// Private Constants


@interface ActionDetailCell ()

// Private Properties


// Notification Handlers



// UI Response Methods



// Misc Methods

@end

@implementation ActionDetailCell

#pragma mark - Synthesized Properties

// Public
@synthesize titleLabel = ivTitleLabel;
@synthesize detailButton = ivDetailButton;
@synthesize backgroundImageView = ivBackgroundImageView;

// Private

#pragma mark - Dealloc and Memory Management

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Public
	[self setTitleLabel:nil];
    [self setDetailButton:nil];
	[self setBackgroundImageView:nil];
	
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
	
	[self setSelectionStyle:UITableViewCellSelectionStyleNone];
	
	UIViewContentMode contentMode = UIViewContentModeCenter;
	
	switch (arc4random() % 9) {
		case 0:
			contentMode = UIViewContentModeTop;
			break;
		case 1:
			contentMode = UIViewContentModeBottom;
			break;
		case 2:
			contentMode = UIViewContentModeLeft;
			break;
		case 3:
			contentMode = UIViewContentModeRight;
			break;
		case 4:
			contentMode = UIViewContentModeTopLeft;
			break;
		case 5:
			contentMode = UIViewContentModeTopRight;
			break;
		case 6:
			contentMode = UIViewContentModeBottomLeft;
			break;
		case 7:
			contentMode = UIViewContentModeBottomRight;
			break;
		default:
			break;
	}
	
	[[self backgroundImageView] setContentMode:contentMode];
	
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
