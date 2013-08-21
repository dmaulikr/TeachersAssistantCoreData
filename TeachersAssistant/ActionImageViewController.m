//
//  ActionImageViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 10/5/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ActionImageViewController.h"

// Models and other global

// Sub-controllers

// Views

// Private Constants


@interface ActionImageViewController ()

// Private Properties
@property (nonatomic, retain) UIBarButtonItem *cameraButton;
@property (nonatomic, retain) UIBarButtonItem *trashButton;
@property (nonatomic, retain) UIPopoverController *detailPopover;

// Notification Handlers



// UI Response Methods
- (void)doneButtonPressed:(UIBarButtonItem *)button;
- (void)cameraButtonPressed:(UIBarButtonItem *)button;
- (void)trashButtonPressed:(UIBarButtonItem *)button;


// Misc Methods

@end

@implementation ActionImageViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainImageView = ivMainImageView;
@synthesize scratchObjectContext = ivScratchObjectContext;
@synthesize scratchActionValue = ivScratchActionValue;
@synthesize imagePickerController = ivImagePickerController;
@synthesize imagePickerTitles = ivImagePickerTitles;

// Private
@synthesize cameraButton = ivCameraButton;
@synthesize trashButton = ivTrashButton;
@synthesize detailPopover = ivDetailPopover;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
    [self setMainImageView:nil];
    [self setScratchObjectContext:nil];
    [self setScratchActionValue:nil];
	
	// Private Properties
	[self setCameraButton:nil];
	[self setTrashButton:nil];
	[self setDetailPopover:nil];
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	[self setCameraButton:nil];
	[self setTrashButton:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

- (NSMutableArray *)imagePickerTitles
{
	if (ivImagePickerTitles == nil)
	{
		ivImagePickerTitles = [[NSMutableArray alloc] init];
	}
	return ivImagePickerTitles;
}

#pragma mark - Initialization and UI Creation Methods

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	if ([[DataController sharedDataController] isIPadVersion])
	{
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																					target:self
																					action:@selector(doneButtonPressed:)];
		[[self navigationItem] setRightBarButtonItem:doneButton];
		[doneButton release], doneButton = nil;
	}
	
	UIBarButtonItem *camera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
																				  target:self
																				  action:@selector(cameraButtonPressed:)];
	[self setCameraButton:camera];
	
	UIBarButtonItem *trash = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
																		   target:self
																		   action:@selector(trashButtonPressed:)];
	[self setTrashButton:trash];
	
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	
	[self setToolbarItems:[NSArray arrayWithObjects:camera, flexItem, trash, nil]];
	
	[camera release], camera = nil;
	[trash release], trash = nil;
	[flexItem release], flexItem = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self navigationController] setToolbarHidden:NO animated:YES];
	
	[[self mainImageView] setImage:[[[self scratchActionValue] imageMediaInfo] image]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidAppear:animated];
	
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillDisappear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillDisappear:animated];
	
	if ([self detailPopover] != nil)
	{
		[[self detailPopover] setDelegate:nil];
		[[self detailPopover] dismissPopoverAnimated:NO];
		
		[self setDetailPopover:nil];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidDisappear:animated];
	
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Notification Handlers



#pragma mark - UI Response Methods

- (void)doneButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	[[self parentViewController] dismissModalViewControllerAnimated:YES];

	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)cameraButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self imagePickerTitles] removeAllObjects];
	
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
													   delegate:self
											  cancelButtonTitle:nil
										 destructiveButtonTitle:nil
											  otherButtonTitles:nil];
	
	[sheet addButtonWithTitle:kImagePickerTitleChoose];
	[[self imagePickerTitles] addObject:kImagePickerTitleChoose];
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		[sheet addButtonWithTitle:kImagePickerTitleTake];
		[[self imagePickerTitles] addObject:kImagePickerTitleTake];
	}
	
	[sheet setCancelButtonIndex:[sheet addButtonWithTitle:@"Cancel"]];
	
	if ([[DataController sharedDataController] isIPadVersion])
	{
		if ( ([[self splitViewController] interfaceOrientation] == UIInterfaceOrientationLandscapeLeft) || ([[self splitViewController] interfaceOrientation] == UIInterfaceOrientationLandscapeRight) )
		{
			[sheet showFromBarButtonItem:[self cameraButton] animated:YES];
		}
		else
		{
			[sheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
			if ([self splitViewController] != nil)
			{
				[sheet showInView:[[self splitViewController] view]];
			}
			else if ([self navigationController] != nil)
			{
				[sheet showFromToolbar:[[self navigationController] toolbar]];
			}
			else
			{
				[sheet showInView:[self view]];
			}
		}
	}
	else
	{
		[sheet showFromToolbar:[[self navigationController] toolbar]];
	}

	[sheet release], sheet = nil;
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)trashButtonPressed:(UIBarButtonItem *)button
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[self scratchActionValue] setImageMediaInfo:nil];
	[[self scratchActionValue] setThumbnailImageMediaInfo:nil];
	
	[[self mainImageView] setImage:nil];
	
	[button setEnabled:NO];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Misc Methods


#pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if ([self detailPopover] != nil)
	{
		[[self detailPopover] setDelegate:nil];
		[[self detailPopover] dismissPopoverAnimated:NO];
		
		[self setDetailPopover:nil];
	}
	
	UIImage *selectedImage = nil;
	if ([info objectForKey:UIImagePickerControllerEditedImage] != nil)
		selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
	else
		selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	
	DataController *dataController = [DataController sharedDataController];
	NSManagedObjectContext *context = [dataController managedObjectContext];
	
	UIImage *largeImage = [dataController removeOrientationFromImage:selectedImage];
	UIImage *smallImage = [dataController smallActionValueImageFromImage:largeImage];
	
	MediaInfo *largeMediaInfo = [MediaInfo managedObjectInContextBTI:context];
	[largeMediaInfo setType:[NSNumber numberWithInt:BTIMediaTypeImage]];
	[largeMediaInfo setImage:largeImage];
	
	MediaInfo *smallMediaInfo = [MediaInfo managedObjectInContextBTI:context];
	[smallMediaInfo setType:[NSNumber numberWithInt:BTIMediaTypeImage]];
	[smallMediaInfo setImage:smallImage];
	
	[dataController addFileForMediaInfo:largeMediaInfo];
	[dataController addFileForMediaInfo:smallMediaInfo];
	
	[dataController saveCoreDataContext];
	
	MediaInfo *scratchLargeMediaInfo = (MediaInfo *)[[self scratchObjectContext] existingObjectWithID:[largeMediaInfo objectID] error:nil];
	MediaInfo *scratchSmallMediaInfo = (MediaInfo *)[[self scratchObjectContext] existingObjectWithID:[smallMediaInfo objectID] error:nil];
	
	[[self scratchActionValue] setImageMediaInfo:scratchLargeMediaInfo];
	[[self scratchActionValue] setThumbnailImageMediaInfo:scratchSmallMediaInfo];
	
	[scratchLargeMediaInfo setImage:nil];		// Just to reduce memory
	
	if ([self modalViewController] != nil)
	{
		[self dismissModalViewControllerAnimated:YES];
	}
	
	[[self mainImageView] setImage:largeImage];
	
	[self setImagePickerController:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if ([self detailPopover] != nil)
	{
		[[self detailPopover] setDelegate:nil];
		[[self detailPopover] dismissPopoverAnimated:NO];
		
		[self setDetailPopover:nil];
	}
	
	if ([self modalViewController] != nil)
	{
		[self dismissModalViewControllerAnimated:YES];
	}
	
	[self setImagePickerController:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if (buttonIndex != [actionSheet cancelButtonIndex])
	{
		NSString *rowTitle = [[self imagePickerTitles] objectAtIndex:buttonIndex];
		
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		[self setImagePickerController:imagePicker];
		[imagePicker setMediaTypes:[NSArray arrayWithObject:(NSString *)kUTTypeImage]];
		[imagePicker setDelegate:self];
		
		if ([rowTitle isEqualToString:kImagePickerTitleChoose])
		{
			[imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
			
			// On iPhone, presentModal.  On iPad, use picker.
			if ([[DataController sharedDataController] isIPadVersion])
			{
				UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
				[self setDetailPopover:popover];
				[popover setDelegate:self];
				
				[popover presentPopoverFromBarButtonItem:[self cameraButton] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
								
				[popover release], popover = nil;
			}
			else
			{
				[self presentModalViewController:imagePicker animated:YES];
			}
		}
		else if ([rowTitle isEqualToString:kImagePickerTitleTake])	// Can present full-screen camera
		{
			[imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
			
			[self presentModalViewController:imagePicker animated:YES];
		}
		
		[imagePicker release], imagePicker = nil;
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
