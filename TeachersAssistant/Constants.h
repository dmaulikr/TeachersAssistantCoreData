#pragma mark - Dropbox Support

#define kDropboxAppKey											@"zydl1k22nd6oc1f"
#define kDropboxAppSecret										@"1w8wb28dtw3t97k"
#define kDropboxDestinationFolderName							@"TeachersAssistant"

#pragma mark - Notifications

#define kShouldShowUpgradeViewNotification						@"kShouldShowUpgradeViewNotification"
#define kShouldShowCSVImportNotification						@"kShouldShowCSVImportNotification"
#define kShouldShowActionDetailViewNotification					@"kShouldShowActionDetailViewNotification"
#define kShouldHideActionDetailViewNotification					@"kShouldHideActionDetailViewNotification"
#define kInfractionDetailViewDidFinishNotification				@"kInfractionDetailViewDidFinishNotification"
#define kPopoverShouldFinishNotification						@"kPopoverShouldFinishNotification"
#define kLogoImageDidChangeNotification							@"kLogoImageDidChangeNotification"
#define kSplitMasterTitleDidChangeNotification					@"kSplitMasterTitleDidChangeNotification"
#define kShouldShowMasterViewControllerNotification				@"kShouldShowMasterViewControllerNotification"
#define kShouldHideMasterViewControllerNotification				@"kShouldHideMasterViewControllerNotification"
#define kDidDeleteActionNotification							@"kDidDeleteActionNotification"
#define kDidCreateExportFileNotification						@"kDidCreateExportFileNotification"
#define kDidImportDataNotification								@"kDidImportDataNotification"
#define kShouldShowStudentDetailViewNotification				@"kShouldShowStudentDetailViewNotification"
#define kShouldHideStudentDetailViewNotification				@"kShouldHideStudentDetailViewNotification"

#pragma mark - Notification Object Keys				

#define kNotificationPersonObjectKey							@"kNotificationPersonObjectKey"
#define kNotificationActionObjectKey							@"kNotificationActionObjectKey"
#define kNotificationFilePathKey								@"kNotificationFilePathKey"

#pragma mark - Action Field Types

typedef enum {
	BTIActionFieldValueTypeDate = 1,
	BTIActionFieldValueTypePicker,
	BTIActionFieldValueTypeLongText,
	BTIActionFieldValueTypeBoolean,
	BTIActionFieldValueTypeImage,
	BTIActionFieldValueTypeAudio,
	BTIActionFieldValueTypeVideo,
	BTIActionFieldValueTypeColor,
} BTIActionFieldValueType;

#pragma mark - Media Types

typedef enum {
	BTIMediaTypeAudio = 1,
	BTIMediaTypeImage,
	BTIMediaTypeVideo
} BTIMediaType;

#pragma mark - Report Modes

typedef enum {
	BTIReportModeAllPersons = 0,
	BTIReportModePersonsWithActions,
	BTIReportModeTotal,	
} BTIReportMode;

#pragma mark - CSV Export Modes

typedef enum {
	BTICSVExportModeDemographics = 0,
	BTICSVExportModeActions,
} BTICSVExportMode;

#pragma mark - Randomizer Modes

typedef enum {
	BTIRandomizerModeSorted = 0,
	BTIRandomizerModeRandom
} BTIRandomizerMode;

typedef enum {
	BTIRandomizerCheckMarkModeNone = 0,
	BTIRandomizerCheckMarkModeGreenCheck,
	BTIRandomizerCheckMarkModeRedX,
} BTIRandomizerCheckMarkMode;

typedef enum {
	BTIRandomizerGroupModeGroupSize = 0,
	BTIRandomizerGroupModeNumberOfGroups,
} BTIRandomizerGroupMode;

#pragma mark - Contact Info Types

#define kContactInfoTypeHome									@"Home"
#define kContactInfoTypeWork									@"Work"
#define kContactInfoTypeMobile									@"Mobile"
#define kContactInfoTypeOther									@"Other"

#pragma mark - Lite Version Limits

#define kLiteVersionMaxNumberOfStudents							5
#define kLiteVersionMaxNumberOfActions							3

#pragma mark - Action Field Info Standard Identifiers

#define kTermInfoIdentifierAction								@"kTermInfoIdentifierAction"
#define kTermInfoIdentifierAudio								@"kTermInfoIdentifierAudio"
#define kTermInfoIdentifierClass								@"kTermInfoIdentifierClass"
#define kTermInfoIdentifierColorLabel							@"kTermInfoIdentifierColorLabel"
#define kTermInfoIdentifierDate									@"kTermInfoIdentifierDate"
#define kTermInfoIdentifierDescription							@"kTermInfoIdentifierDescription"
#define kTermInfoIdentifierGradingPeriod							@"kTermInfoIdentifierGradingPeriod"
#define kTermInfoIdentifierImage								@"kTermInfoIdentifierImage"
#define kTermInfoIdentifierLocation								@"kTermInfoIdentifierLocation"
#define kTermInfoIdentifierNote									@"kTermInfoIdentifierNote"
#define kTermInfoIdentifierOptional								@"kTermInfoIdentifierOptional"
#define kTermInfoIdentifierOther								@"kTermInfoIdentifierOther"
#define kTermInfoIdentifierParent								@"kTermInfoIdentifierParent"
#define kTermInfoIdentifierParentNotified						@"kTermInfoIdentifierParentNotified"
#define kTermInfoIdentifierPerson								@"kTermInfoIdentifierPerson"
#define kTermInfoIdentifierRandomizer							@"kTermInfoIdentifierRandomizer"
#define kTermInfoIdentifierSummary								@"kTermInfoIdentifierSummary"
#define kTermInfoIdentifierTeacherResponse						@"kTermInfoIdentifierTeacherResponse"
#define kTermInfoIdentifierTeacherResponseOccurred				@"kTermInfoIdentifierTeacherResponseOccurred"
#define kTermInfoIdentifierVideo								@"kTermInfoIdentifierVideo"

#pragma mark - Color Info Standard Identifiers

#define kColorIdentifierRed										@"kColorIdentifierRed"
#define kColorIdentifierYellow									@"kColorIdentifierYellow"
#define kColorIdentifierGreen									@"kColorIdentifierGreen"
#define kColorIdentifierBlue									@"kColorIdentifierBlue"

#pragma mark - Misc

#define kStudentsFileName_OBSOLETE								@"storage.data"
#define kPeriodsFileName_OBSOLETE								@"periods.data"
#define kNativeFileExtension_OBSOLETE							@"idiscipline"
#define kNativeFileExtension									@"tappro"
#define kCommaSeparatedFileExtension							@"csv"
#define kValueDelimiter											@", "
#define kUserLogoImageFileName									@"userlogo.png"
#define kDatabaseFileName										@"TeachersAssistant.sqlite"
#define kAllStudentsClassName									@"12345AllStudents12345"

#pragma mark - Zip File Elements

#define kZipFileAllModelsKey									@"kZipFileAllModelsKey"
#define kZipFilePreferencesKey									@"kZipFilePreferencesKey"
#define kZipFileContainerFolder									@"TAP Contents"
#define kZipFileModelFileName									@"Data.data"
#define kZipFilePreferencesFileName								@"Preferences.data"
#define kZipFileImageFolder										@"Images"
#define kZipFileAudioFolder										@"Sounds"
#define kZipFileVideoFolder										@"Videos"

#pragma mark - Action Identifiers

#define kDefaultActionIdentifier								@"kDefaultActionIdentifier"
#define kPersonFilterActionIdentifier							@"kPersonFilterActionIdentifier"

#pragma mark - Image Info

#define kJPEGImageQuality										0.7
#define kThumbnailMaxHeightiPhone								44.0
#define kThumbnailMaxHeightiPad									100.0
#define kPersonPlaceholderImage									[UIImage imageNamed:@"person_120x120.png"]
#define kImagePickerTitleChoose									@"Choose Photo"
#define kImagePickerTitleTake									@"Take Photo"
#define kImagePickerTitleDelete									@"Delete Photo"

#pragma mark - Model Keys

#define kACTION													@"action"
#define kACTIONS												@"actions"
#define kACTION_FIELD_INFO										@"actionFieldInfo"
#define kACTION_VALUES											@"actionValues"
#define kACTION_VALUE_AUDIO										@"actionValueAudio"
#define kACTION_VALUE_IMAGE										@"actionValueImage"
#define kACTION_VALUE_THUMBNAIL									@"actionValueThumbnail"
#define kACTION_VALUE_VIDEO										@"actionValueVideo"
#define kAUDIO_MEDIA_INFO										@"audioMediaInfo"
#define kBOOLEAN												@"boolean"
#define kCLASS_PERIODS											@"classPeriods"
#define kCOLOR													@"color"
#define kCOLOR_INFO												@"colorInfo"
#define kDATE													@"date"
#define kDATE_CREATED											@"dateCreated"
#define kDATE_MODIFIED											@"dateModified"
#define kDEFAULT_NAME_PLURAL									@"defaultNamePlural"
#define kDEFAULT_NAME_SINGULAR									@"defaultNameSingular"
#define kDEFAULT_SORT_DATE										@"defaultSortDate"
#define kEMAIL_ADDRESSES										@"emailAddresses"
#define kEXCHANGE_IDENTIFIER									@"exchangeIdentifier"
#define kFILE_NAME												@"fileName"
#define kFILTER_TO_DATE											@"filterToDate"
#define kFILTER_FROM_DATE										@"filterFromDate"
#define kFIRST_LETTER_OF_FIRST_NAME								@"firstLetterOfFirstName"
#define kFIRST_LETTER_OF_LAST_NAME								@"firstLetterOfLastName"
#define kFIRST_NAME												@"firstName"
#define kIDENTIFIER												@"identifier"
#define kIMAGE													@"image"
#define kIMAGE_MEDIA_INFO										@"imageMediaInfo"
#define kIS_DEFAULT												@"isDefault"
#define kIS_HIDDEN												@"isHidden"
#define kIS_USER_CREATED										@"isUserCreated"
#define kLARGE_THUMBNAIL_MEDIA_INFO								@"largeThumbnailMediaInfo"
#define kLAST_NAME												@"lastName"
#define kLONG_TEXT												@"longText"
#define kMEETS_FILTER_CRITERIA									@"meetsFilterCriteria"
#define kNAME													@"name"
#define kOTHER													@"other"
#define kPARENT													@"parent"
#define kPARENTS												@"parents"
#define kPERSON													@"person"
#define kPERSONS												@"persons"
#define kPERSON_LARGE											@"personLarge"
#define kPERSON_SMALL											@"personSmall"
#define kPHONE_NUMBERS											@"phoneNumbers"
#define kPICKER_VALUES											@"pickerValues"
#define kPOINT_VALUE											@"pointValue"
#define kSMALL_THUMBNAIL_MEDIA_INFO								@"smallThumbnailMediaInfo"
#define kSORT_ORDER												@"sortOrder"
#define kSTUDENT												@"student"
#define kTERM_INFO												@"termInfo"
#define kTHUMBNAIL_IMAGE_MEDIA_INFO								@"thumbnailImageMediaInfo"
#define kTYPE													@"type"
#define kUSER_NAME_SINGULAR										@"userNameSingular"
#define kUSER_NAME_PLURAL										@"userNamePlural"
#define kVALUE													@"value"
#define kVIDEO_MEDIA_INFO										@"videoMediaInfo"




#pragma mark - Obsolete Keys

#define kExchangeStudentsKey						@"students"
#define kExchangeInfractionNamesKey					@"infractionNames"
#define kExchangePunishmentsKey						@"infractionPunishments"
#define kExchangeLocationsKey						@"infractionLocations"
#define kExchangeClassPeriodsKey					@"infractionClassPeriods"
#define kExchangeOptionalsKey						@"infractionOptionals"
#define kExchangeFieldNameInfoKey					@"fieldNameInfo"
#define kExchangePeriodsKey							@"periods"
	
#define kFieldNameAction							@"Action"
#define kFieldNameTeacherResponse					@"Teacher Response"
#define kFieldNameLocation							@"Location"
#define kFieldNamePeriod_Old                        @"Period"
#define kFieldNameClass                             @"Class"
#define kFieldNameTeacherResponseOccurred			@"Teacher Response Occurred"
#define kFieldNameDescription						@"Description"
#define kFieldNameNote								@"Note"
#define kFieldNameParentNotified					@"Parent Notified"
#define kFieldNameDate								@"Date"
#define kFieldNameOptional							@"Optional"
	
#define kUserDefaultsNamesKey						@"namesKey"
#define kUserDefaultsPunishmentsKey					@"punishmentsKey"
#define kUserDefaultsLocationsKey					@"locationsKey"
#define kUserDefaultsClassPeriodsKey				@"classPeriodsKey"
#define kUserDefaultsOptionalsKey					@"optionalsKey"
#define kUserDefaultsFieldNamesKey					@"fieldNamesKey"