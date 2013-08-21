//
//  ActionDetailLongTextCell.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/22/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ActionDetailLongTextCell.h"

// Models and other global

// Private Constants


@interface ActionDetailLongTextCell ()

// Private Properties


// Notification Handlers



// UI Response Methods



// Misc Methods

@end

@implementation ActionDetailLongTextCell

#pragma mark - Synthesized Properties

// Public
@synthesize contextTextView = ivContextTextView;
@synthesize paperBackgroundView = ivPaperBackgroundView;

// Private

#pragma mark - Dealloc and Memory Management

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Public
	[self setContextTextView:nil];
	[self setPaperBackgroundView:nil];
	
	// Private
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters



#pragma mark - Initialization and UI Creation Methods

- (void)awakeFromNib
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[super awakeFromNib];

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
	
	[[self paperBackgroundView] setContentMode:contentMode];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UITableViewCell Methods



#pragma mark - Misc Methods



@end
