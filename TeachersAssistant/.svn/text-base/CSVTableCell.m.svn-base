//
//  CSVTableCell.m
//  infraction
//
//  Created by Brian Slick on 12/29/10.
//  Copyright 2010 BriTer Ideas LLC. All rights reserved.
//

#import "CSVTableCell.h"


@implementation CSVTableCell

@synthesize firstNameLabel = ivFirstNameLabel;
@synthesize lastNameLabel = ivLastNameLabel;
@synthesize other1Label = ivOther1Label;
@synthesize other2Label = ivOther2Label;
@synthesize other3Label = ivOther3Label;
@synthesize classLabel = ivClassLabel;
@synthesize parent1NameLabel = ivParent1NameLabel;
@synthesize parent1EmailLabel = ivParent1EmailLabel;
@synthesize parent1PhoneLabel = ivParent1PhoneLabel;
@synthesize parent2NameLabel = ivParent2NameLabel;
@synthesize parent2EmailLabel = ivParent2EmailLabel;
@synthesize parent2PhoneLabel = ivParent2PhoneLabel;


- (id)initWithStyle:(UITableViewCellStyle)style
	reuseIdentifier:(NSString *)reuseIdentifier
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
	{
        // Initialization code.
    }
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
    return self;
}

- (void)awakeFromNib
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)setSelected:(BOOL)selected
		   animated:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super setSelected:selected animated:animated];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

+ (NSString *)reuseIdentifier
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return NSStringFromClass([self class]);
}

- (NSString *)reuseIdentifier
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
    return [[self class] reuseIdentifier];
}

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [self setFirstNameLabel:nil];
    [self setLastNameLabel:nil];
    [self setOther1Label:nil];
    [self setOther2Label:nil];
    [self setOther3Label:nil];
    [self setClassLabel:nil];
    [self setParent1NameLabel:nil];
    [self setParent1EmailLabel:nil];
    [self setParent1PhoneLabel:nil];
    [self setParent2NameLabel:nil];
    [self setParent2EmailLabel:nil];
    [self setParent2PhoneLabel:nil];
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end