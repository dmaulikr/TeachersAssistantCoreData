//
//  StudentOrderChooserViewController.h
//  infraction
//
//  Created by Brian Slick on 7/28/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

// Libraries
#import <UIKit/UIKit.h>

// Forward Declarations and Classes
#import "BTIViewController.h"

// Public Constants

// Protocols

@interface StudentOrderChooserViewController : BTIViewController <UITableViewDataSource, UITableViewDelegate>
{
}

// IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;


// Other Public Properties
@property (nonatomic, copy) NSString *setting;

// IBActions


// Other Public Methods


@end
