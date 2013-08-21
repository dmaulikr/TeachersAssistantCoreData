//
//  MediaInfo.h
//  TeachersAssistant
//
//  Created by Brian Slick on 10/7/11.
//  Copyright (c) 2011 BriTer Ideas LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonAttributes.h"

@class ActionValue, Person;

@interface MediaInfo : CommonAttributes {
@private
}
@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) Person *personLarge;
@property (nonatomic, retain) ActionValue *actionValueAudio;
@property (nonatomic, retain) Person *personSmall;
@property (nonatomic, retain) ActionValue *actionValueImage;
@property (nonatomic, retain) ActionValue *actionValueThumbnail;
@property (nonatomic, retain) ActionValue *actionValueVideo;

@end
