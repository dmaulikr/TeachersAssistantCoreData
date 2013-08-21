//
//  NSUserDefaults+BTIAdditions.h
//  infraction
//
//  Created by Brian Slick on 7/22/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#define kUserDefaultsDataExchangeKey				@"kUserDefaultsDataExchangeKey"

#define kUserDefaultsStudentSortModeKey				@"studentSortModeKey"
#define kUserDefaultsStudentDisplayModeKey			@"kUserDefaultsStudentDisplayModeKey"
#define kUserDefaultsScreenLockEnabledKey			@"kUserDefaultsScreenLockEnabledKey"
#define kUserDefaultsScreenLockPinKey				@"kUserDefaultsScreenLockPinKey"
#define kUserDefaultsImageFileNameIndexKey			@"kUserDefaultsImageFileNameIndexKey"
#define kUserDefaultsShowPersonThumbnailsKey		@"kUserDefaultsShowPersonThumbnailsKey"
#define kUserDefaultsShowColorPointsKey				@"kUserDefaultsShowColorPointsKey"
#define kUserDefaultsJumpButtonModeKey				@"kUserDefaultsJumpButtonModeKey"
#define kUserDefaultsOldDataMigratedKey				@"kUserDefaultsOldDataMigratedKey"
#define kUserDefaultsActionViewTipKey				@"kUserDefaultsActionViewTipKey"
#define kUserDefaultsEmailBlastToAddressKey			@"kUserDefaultsEmailBlastToAddressKey"
#define kUserDefaultsEmailBlastTipKey				@"kUserDefaultsEmailBlastTipKey"
#define kUserDefaultsGradingPeriodsKey				@"kUserDefaultsGradingPeriodsKey"
#define kUserDefaultsActionSortAscendingKey			@"kUserDefaultsActionSortAscendingKey"
#define kUserDefaultsPointFilterModeKey				@"kUserDefaultsPointFilterModeKey"
#define kUserDefaultsPointFilterValueKey			@"kUserDefaultsPointFilterValueKey"

typedef enum {
	BTIPersonSortModeFirstLast = 1,
	BTIPersonSortModeLastFirst,
} BTIPersonSortMode;

typedef enum {
	BTIJumpButtonModeHome = 0,
	BTIJumpButtonModeClasses,
	BTIJumpButtonModeStudents,
	BTIJumpButtonModeCount,
} BTIJumpButtonMode;

typedef enum {
	BTIPointFilterModeOff = 0,
	BTIPointFilterModeGreaterThan,
	BTIPointFilterModeLessThan,
	BTIPointFilterModeEqualTo,
} BTIPointFilterMode;

@interface NSUserDefaults (NSUserDefaults_BTIAdditions)

@property (assign, getter = btiPersonSortMode, setter = btiSetPersonSortMode:) NSInteger btiPersonSortMode;
@property (assign, getter = btiPersonDisplayMode, setter = btiSetPersonDisplayMode:) NSInteger btiPersonDisplayMode;
@property (assign, getter = btiImageFileNameIndex, setter = btiSetImageFileNameIndex:) NSInteger btiImageFileNameIndex;
@property (assign, getter = btiJumpButtonMode, setter = btiSetJumpButtonMode:) NSInteger btiJumpButtonMode;
@property (assign, getter = btiIsScreenLockEnabled, setter = btiSetScreenLockEnabled:) BOOL btiScreenLockEnabled;
@property (assign, getter = btiIsOldDataMigrated, setter = btiSetOldDataMigrated:) BOOL btiOldDataMigrated;
@property (assign, getter = btiDidShowActionTip, setter = btiSetDidShowActionTip:) BOOL btiShowActionTip;
@property (assign, getter = btiDidShowEmailBlastTip, setter = btiSetDidShowEmailBlastTip:) BOOL btiShowEmailBlastTip;
@property (assign, getter = btiShouldShowPersonThumbnails, setter = btiSetShouldShowPersonThumbnails:) BOOL btiShouldShowPersonThumbnails;
@property (assign, getter = btiShouldShowColorPointValues, setter = btiSetShouldShowColorPointValues:) BOOL btiShouldShowColorPointValues;
@property (assign, getter = isActionsSortAscendingBTI, setter = setActionsSortAscendingBTI:) BOOL actionsSortAscendingBTI;
@property (assign, getter = btiScreenLockPin, setter = btiSetScreenLockPin:) NSString *btiScreenLockPin;
@property (assign, getter = btiEmailBlastToAddress, setter = btiSetEmailBlastToAddress:) NSString *btiEmailBlastToAddress;
@property (assign, getter = btiGradingPeriods, setter = btiSetGradingPeriods:) NSArray *btiGradingPeriods;

#pragma mark Point Filter

@property (assign, getter = pointFilterModeBTI, setter = setPointFilterModeBTI:) NSInteger pointFilterModeBTI;
@property (assign, getter = pointFilterValueBTI, setter = setPointFilterValueBTI:) NSNumber *pointFilterValueBTI;

- (void)btiInitializeDefaults;
- (void)btiResetDefaults;
- (NSDictionary *)attributesForBackup;
- (void)loadFromBackUpAttributes:(NSDictionary *)attributes;

@end
