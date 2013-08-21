//
//  Infraction.h
//  infraction
//
//  Created by will strimling on 8/10/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Student;

#define kInfractionTimeStampKey_Old				@"timestamp"
#define kInfractionDateKey						@"date"
#define kInfractionInfractionNameKey_Old		@"infractionName"
#define kInfractionStudentActionKey				@"studentActionArray"
#define kInfractionPunishmentKey_Old			@"punishment"
#define kInfractionTeacherResponseKey			@"teacherResponseArray"
#define kInfractionLocationPlaceKey_Old			@"locationPlace"
#define kInfractionLocationKey					@"locationArray"
#define kInfractionClassPeriodKey_Old			@"classPeriod"
#define kInfractionPeriodKey					@"periodArray"
#define kInfractionOptionalKey					@"optionalArray"
#define kInfractionDescriptionKey				@"description"
#define kInfractionNoteKey						@"note"
#define kInfractionParentNotifiedKey			@"notified"
#define kInfractionPunishedKey					@"punished"

@interface Infraction : NSObject <NSCoding, NSCopying>
{
}

// Properties
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *studentActionString;
@property (nonatomic, retain) NSMutableArray *studentActions;
@property (nonatomic, copy) NSString *teacherResponseString;
@property (nonatomic, retain) NSMutableArray *teacherResponses;
@property (nonatomic, copy) NSString *locationString;
@property (nonatomic, retain) NSMutableArray *locations;
@property (nonatomic, copy) NSString *periodString;
@property (nonatomic, retain) NSMutableArray *periods;
@property (nonatomic, copy) NSString *optionalString;
@property (nonatomic, retain) NSMutableArray *optionals;
@property (nonatomic, copy) NSString *infractionDescription;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, assign, getter=isParentNotified) BOOL parentNotified;
@property (nonatomic, assign, getter=isPunished) BOOL punished;
@property (nonatomic, assign) Student *student;


// Saving and reloading methods
- (id)attributes;
- (id)initWithAttributes:(id)attributes;

// Misc Methods
//- (NSString *)summaryStringForEmail;

@end
