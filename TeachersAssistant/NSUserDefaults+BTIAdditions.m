//
//  NSUserDefaults+BTIAdditions.m
//  infraction
//
//  Created by Brian Slick on 7/22/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "NSUserDefaults+BTIAdditions.h"

@implementation NSUserDefaults (NSUserDefaults_BTIAdditions)

#pragma mark -
#pragma mark Custom Getters and Setters

- (NSInteger)btiPersonSortMode
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self integerForKey:kUserDefaultsStudentSortModeKey];
}

- (void)btiSetPersonSortMode:(NSInteger)mode
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	[self setInteger:mode forKey:kUserDefaultsStudentSortModeKey];
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSInteger)btiPersonDisplayMode
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self integerForKey:kUserDefaultsStudentDisplayModeKey];
}

- (void)btiSetPersonDisplayMode:(NSInteger)mode
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	[self setInteger:mode forKey:kUserDefaultsStudentDisplayModeKey];
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSInteger)btiImageFileNameIndex
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self integerForKey:kUserDefaultsImageFileNameIndexKey];
}

- (void)btiSetImageFileNameIndex:(NSInteger)index
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	[self setInteger:index forKey:kUserDefaultsImageFileNameIndexKey];
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSInteger)btiJumpButtonMode
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self integerForKey:kUserDefaultsJumpButtonModeKey];
}

- (void)btiSetJumpButtonMode:(NSInteger)mode
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	[self setInteger:mode forKey:kUserDefaultsJumpButtonModeKey];
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (BOOL)btiIsScreenLockEnabled
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self boolForKey:kUserDefaultsScreenLockEnabledKey];
}

- (void)btiSetScreenLockEnabled:(BOOL)enabled
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	[self setBool:enabled forKey:kUserDefaultsScreenLockEnabledKey];
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (BOOL)btiShouldShowPersonThumbnails
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self boolForKey:kUserDefaultsShowPersonThumbnailsKey];
}

- (void)btiSetShouldShowPersonThumbnails:(BOOL)enabled
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	[self setBool:enabled forKey:kUserDefaultsShowPersonThumbnailsKey];
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (BOOL)btiShouldShowColorPointValues
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self boolForKey:kUserDefaultsShowColorPointsKey];
}

- (void)btiSetShouldShowColorPointValues:(BOOL)enabled
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	[self setBool:enabled forKey:kUserDefaultsShowColorPointsKey];
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (BOOL)isActionsSortAscendingBTI
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self boolForKey:kUserDefaultsActionSortAscendingKey];
}

- (void)setActionsSortAscendingBTI:(BOOL)actionsSortAscendingBTI
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[self setBool:actionsSortAscendingBTI forKey:kUserDefaultsActionSortAscendingKey];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (BOOL)btiIsOldDataMigrated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self boolForKey:kUserDefaultsOldDataMigratedKey];
}

- (void)btiSetOldDataMigrated:(BOOL)migrated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	[self setBool:migrated forKey:kUserDefaultsOldDataMigratedKey];
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (BOOL)btiDidShowActionTip
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self boolForKey:kUserDefaultsActionViewTipKey];
}

- (void)btiSetDidShowActionTip:(BOOL)didShow
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	[self setBool:didShow forKey:kUserDefaultsActionViewTipKey];
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (BOOL)btiDidShowEmailBlastTip
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self boolForKey:kUserDefaultsEmailBlastTipKey];
}

- (void)btiSetDidShowEmailBlastTip:(BOOL)btiShowEmailBlastTip
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	[self setBool:btiShowEmailBlastTip forKey:kUserDefaultsEmailBlastTipKey];
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSString *)btiScreenLockPin
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self stringForKey:kUserDefaultsScreenLockPinKey];
}

- (void)btiSetScreenLockPin:(NSString *)pin
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	if (pin == nil)
	{
		[self removeObjectForKey:kUserDefaultsScreenLockPinKey];
	}
	else
	{
		[self setObject:pin forKey:kUserDefaultsScreenLockPinKey];
    }
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSString *)btiEmailBlastToAddress
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [self stringForKey:kUserDefaultsEmailBlastToAddressKey];
}

- (void)btiSetEmailBlastToAddress:(NSString *)btiEmailBlastToAddress
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
    
	[self setObject:btiEmailBlastToAddress forKey:kUserDefaultsEmailBlastToAddressKey];
    	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSArray *)btiGradingPeriods
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSArray *attributes = [self objectForKey:kUserDefaultsGradingPeriodsKey];
	
	NSMutableArray *gradingPeriods = [NSMutableArray array];
	
	for (NSDictionary *attribute in attributes)
	{
		GradingPeriod *gradingPeriod = [[GradingPeriod alloc] initWithAttributes:attribute];
		
		[gradingPeriods addObject:gradingPeriod];
		
		[gradingPeriod release], gradingPeriod = nil;
	}

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return [NSArray arrayWithArray:gradingPeriods];
}

- (void)btiSetGradingPeriods:(NSArray *)btiGradingPeriods
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSArray *sortedGradingPeriods = [btiGradingPeriods sortedArrayUsingDescriptors:[[DataController sharedDataController] descriptorArrayForManualSortOrderSort]];
	
	NSMutableArray *attributes = [NSMutableArray array];
	
	for (GradingPeriod *gradingPeriod in sortedGradingPeriods)
	{
		[attributes addObject:[gradingPeriod attributes]];
	}

	[self setObject:attributes forKey:kUserDefaultsGradingPeriodsKey];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark Point Filter

- (NSInteger)pointFilterModeBTI
{
	return [self integerForKey:kUserDefaultsPointFilterModeKey];
}

- (void)setPointFilterModeBTI:(NSInteger)pointFilterModeBTI
{
	[self setInteger:pointFilterModeBTI forKey:kUserDefaultsPointFilterModeKey];
}

- (NSNumber *)pointFilterValueBTI
{
	return [self objectForKey:kUserDefaultsPointFilterValueKey];
}

- (void)setPointFilterValueBTI:(NSNumber *)pointFilterValueBTI
{
	[self setObject:pointFilterValueBTI forKey:kUserDefaultsPointFilterValueKey];
}

#pragma mark - Misc Methods

- (void)btiInitializeDefaults
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if ([self objectForKey:kUserDefaultsOldDataMigratedKey] == nil)
	{
		[self btiSetOldDataMigrated:NO];
	}
	
	if ([self objectForKey:kUserDefaultsStudentSortModeKey] == nil)
	{
		[self btiSetPersonSortMode:BTIPersonSortModeFirstLast];
	}
	
	if ([self objectForKey:kUserDefaultsStudentDisplayModeKey] == nil)
	{
		[self btiSetPersonDisplayMode:BTIPersonSortModeLastFirst];
	}

	if ([self objectForKey:kUserDefaultsImageFileNameIndexKey] == nil)
	{
		[self btiSetImageFileNameIndex:1];
	}
	
	if ([self objectForKey:kUserDefaultsScreenLockEnabledKey] == nil)
	{
		[self btiSetScreenLockEnabled:NO];
	}
	
	if ([self objectForKey:kUserDefaultsShowPersonThumbnailsKey] == nil)
	{
		[self btiSetShouldShowPersonThumbnails:YES];
	}
	
	if ([self objectForKey:kUserDefaultsShowColorPointsKey] == nil)
	{
		[self btiSetShouldShowColorPointValues:YES];
	}
	
	if ([self objectForKey:kUserDefaultsJumpButtonModeKey] == nil)
	{
		[self btiSetJumpButtonMode:BTIJumpButtonModeHome];
	}
	
	if ([self objectForKey:kUserDefaultsActionViewTipKey] == nil)
	{
		[self btiSetDidShowActionTip:NO];
	}
	
	if ([self objectForKey:kUserDefaultsEmailBlastTipKey] == nil)
	{
		[self btiSetDidShowEmailBlastTip:NO];
	}
	
	if ([self objectForKey:kUserDefaultsActionSortAscendingKey] == nil)
	{
		[self setActionsSortAscendingBTI:YES];
	}
	
	if ([self objectForKey:kUserDefaultsPointFilterValueKey] == nil)
	{
		[self setPointFilterModeBTI:BTIPointFilterModeOff];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)btiResetDefaults
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[self removeObjectForKey:kUserDefaultsStudentSortModeKey];
	[self removeObjectForKey:kUserDefaultsStudentDisplayModeKey];
	[self removeObjectForKey:kUserDefaultsScreenLockEnabledKey];
	[self removeObjectForKey:kUserDefaultsScreenLockPinKey];
	[self removeObjectForKey:kUserDefaultsImageFileNameIndexKey];
	[self removeObjectForKey:kUserDefaultsShowPersonThumbnailsKey];
	[self removeObjectForKey:kUserDefaultsShowColorPointsKey];
	[self removeObjectForKey:kUserDefaultsJumpButtonModeKey];
	[self removeObjectForKey:kUserDefaultsEmailBlastToAddressKey];
	[self removeObjectForKey:kUserDefaultsGradingPeriodsKey];
	[self removeObjectForKey:kUserDefaultsActionSortAscendingKey];
	[self removeObjectForKey:kUserDefaultsPointFilterValueKey];
	
	[self btiInitializeDefaults];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (NSDictionary *)attributesForBackup
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];

	NSNumber *sortMode = [self objectForKey:kUserDefaultsStudentSortModeKey];
	if (sortMode != nil)
		[attributes setObject:sortMode forKey:kUserDefaultsStudentSortModeKey];
	
	NSNumber *displayMode = [self objectForKey:kUserDefaultsStudentDisplayModeKey];
	if (displayMode != nil)
		[attributes setObject:displayMode forKey:kUserDefaultsStudentDisplayModeKey];
	
	NSNumber *lockEnabled = [self objectForKey:kUserDefaultsScreenLockEnabledKey];
	if (lockEnabled != nil)
		[attributes setObject:lockEnabled forKey:kUserDefaultsScreenLockEnabledKey];
	
	NSString *lockPin = [self objectForKey:kUserDefaultsScreenLockPinKey];
	if (lockPin != nil)
		[attributes setObject:lockPin forKey:kUserDefaultsScreenLockPinKey];
	
	NSNumber *thumbnails = [self objectForKey:kUserDefaultsShowPersonThumbnailsKey];
	if (thumbnails != nil)
		[attributes setObject:thumbnails forKey:kUserDefaultsShowPersonThumbnailsKey];
	
	NSNumber *points = [self objectForKey:kUserDefaultsShowColorPointsKey];
	if (points != nil)
		[attributes setObject:points forKey:kUserDefaultsShowColorPointsKey];
	
	NSNumber *jump = [self objectForKey:kUserDefaultsJumpButtonModeKey];
	if (jump != nil)
		[attributes setObject:jump forKey:kUserDefaultsJumpButtonModeKey];
	
	// Assume that data has already been migrated
	[attributes setObject:[NSNumber numberWithBool:YES] forKey:kUserDefaultsOldDataMigratedKey];
//	NSNumber *migrated = [self objectForKey:kUserDefaultsOldDataMigratedKey];
//	if (migrated != nil)
//		[attributes setObject:migrated forKey:kUserDefaultsOldDataMigratedKey];
	
	NSNumber *tip = [self objectForKey:kUserDefaultsActionViewTipKey];
	if (tip != nil)
		[attributes setObject:tip forKey:kUserDefaultsActionViewTipKey];
	
	NSNumber *emailTip = [self objectForKey:kUserDefaultsEmailBlastTipKey];
	if (emailTip != nil)
		[attributes setObject:emailTip forKey:kUserDefaultsEmailBlastTipKey];
	
	NSString *toAddress = [self objectForKey:kUserDefaultsEmailBlastToAddressKey];
	if (toAddress != nil)
		[attributes setObject:toAddress forKey:kUserDefaultsEmailBlastToAddressKey];
	
	NSArray *gradingPeriods = [self objectForKey:kUserDefaultsGradingPeriodsKey];
	if (gradingPeriods != nil)
		[attributes setObject:gradingPeriods forKey:kUserDefaultsGradingPeriodsKey];
	
	NSNumber *actionSort = [self objectForKey:kUserDefaultsActionSortAscendingKey];
	if (actionSort != nil)
		[attributes setObject:actionSort forKey:kUserDefaultsActionSortAscendingKey];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return attributes;
}

- (void)loadFromBackUpAttributes:(NSDictionary *)attributes
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSNumber *sortMode = [attributes objectForKey:kUserDefaultsStudentSortModeKey];
	if (sortMode != nil)
		[self setObject:sortMode forKey:kUserDefaultsStudentSortModeKey];
	
	NSNumber *displayMode = [attributes objectForKey:kUserDefaultsStudentDisplayModeKey];
	if (displayMode != nil)
		[self setObject:displayMode forKey:kUserDefaultsStudentDisplayModeKey];
	
	NSNumber *lockEnabled = [attributes objectForKey:kUserDefaultsScreenLockEnabledKey];
	if (lockEnabled != nil)
		[self setObject:lockEnabled forKey:kUserDefaultsScreenLockEnabledKey];
	
	NSString *lockPin = [attributes objectForKey:kUserDefaultsScreenLockPinKey];
	if (lockPin != nil)
		[self setObject:lockPin forKey:kUserDefaultsScreenLockPinKey];
	
	NSNumber *thumbnails = [attributes objectForKey:kUserDefaultsShowPersonThumbnailsKey];
	if (thumbnails != nil)
		[self setObject:thumbnails forKey:kUserDefaultsShowPersonThumbnailsKey];
	
	NSNumber *points = [attributes objectForKey:kUserDefaultsShowColorPointsKey];
	if (points != nil)
		[self setObject:points forKey:kUserDefaultsShowColorPointsKey];
	
	NSNumber *jump = [attributes objectForKey:kUserDefaultsJumpButtonModeKey];
	if (jump != nil)
		[self setObject:jump forKey:kUserDefaultsJumpButtonModeKey];
	
	NSNumber *migrated = [attributes objectForKey:kUserDefaultsOldDataMigratedKey];
	if (migrated != nil)
		[self setObject:migrated forKey:kUserDefaultsOldDataMigratedKey];
	
	NSNumber *tip = [attributes objectForKey:kUserDefaultsActionViewTipKey];
	if (tip != nil)
		[self setObject:tip forKey:kUserDefaultsActionViewTipKey];
	
	NSNumber *emailTip = [attributes objectForKey:kUserDefaultsEmailBlastTipKey];
	if (emailTip != nil)
		[self setObject:emailTip forKey:kUserDefaultsEmailBlastTipKey];
	
	NSString *toAddress = [attributes objectForKey:kUserDefaultsEmailBlastToAddressKey];
	if (toAddress != nil)
		[self setObject:toAddress forKey:kUserDefaultsEmailBlastToAddressKey];
	
	NSArray *gradingPeriods = [attributes objectForKey:kUserDefaultsGradingPeriodsKey];
	if (gradingPeriods != nil)
		[self setObject:gradingPeriods forKey:kUserDefaultsGradingPeriodsKey];
	
	NSNumber *actionSort = [attributes objectForKey:kUserDefaultsActionSortAscendingKey];
	if (actionSort != nil)
		[self setObject:actionSort forKey:kUserDefaultsActionSortAscendingKey];
	
	[self synchronize];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
