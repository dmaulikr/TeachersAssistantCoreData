//
//  PersonActionsCell.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/15/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//


// Public Constants

@interface PersonActionsCell : UITableViewCell
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UILabel *actionLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UIView *colorView1;
@property (nonatomic, retain) IBOutlet UIView *colorView2;
@property (nonatomic, retain) IBOutlet UIView *colorView3;
@property (nonatomic, retain) IBOutlet UIView *colorView4;
@property (nonatomic, retain) IBOutlet UIView *colorView5;

// Other Public Properties


// IBActions


// Other Public Methods
+ (NSString *)reuseIdentifier;
- (void)setColorForBackground:(UIColor *)color;

@end
