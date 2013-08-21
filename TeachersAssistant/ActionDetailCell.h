//
//  ActionDetailCell.h
//  TeachersAssistant
//
//  Created by Brian Slick on 10/6/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

// Public Constants

@interface ActionDetailCell : UITableViewCell
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIButton *detailButton;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;

// Other Public Properties


// IBActions


// Other Public Methods
+ (NSString *)reuseIdentifier;

@end
