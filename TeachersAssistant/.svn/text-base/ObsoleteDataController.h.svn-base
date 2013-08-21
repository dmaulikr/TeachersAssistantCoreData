//
//  DataController.h
//  infraction
//
//  Created by Brian Slick on 9/26/10.
//  Copyright 2010 BriTer Ideas LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObsoleteDataController : NSObject
{
}

// Properties
@property (nonatomic, retain) NSDateFormatter *oldDateFormatter_DoNotUseForNewStuff;
@property (nonatomic, copy) NSDictionary *importedUpgradeData;
@property (nonatomic, copy) NSString *importedFilePath;


// Methods
+ (ObsoleteDataController *)sharedDataController;

// Saving and Loading Methods
- (void)loadAllObsoleteData;

// Data Exchange Methods

- (void)processImportedFileAtPath:(NSString *)path;
- (void)addDataFromImportedFile;

// All Students List Methods


// Infraction List Methods

// Field Name Info Methods

// Sorted Periods List Methods


@end
