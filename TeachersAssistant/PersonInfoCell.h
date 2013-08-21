//
//  PersonInfoCell.h
//  TeachersAssistant
//
//  Created by Brian Slick on 9/15/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

// Public Constants

@interface PersonInfoCell : UITableViewCell
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UITextField *textField;

// Other Public Properties


// IBActions


// Other Public Methods
+ (NSString *)reuseIdentifier;

@end
