//
//  UIActionSheet+Blocks.m
//  Shibui
//
//  Created by Jiva DeVoe on 1/5/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import "UIActionSheet+Blocks.h"
#import <objc/runtime.h>

static NSString *RI_BUTTON_ASS_KEY = @"com.random-ideas.BUTTONS";

@implementation UIActionSheet (Blocks)

// Alternate

- (id)initWithTitle:(NSString *)inTitle
   cancelButtonItem:(RIButtonItem *)inCancelButtonItem
destructiveButtonItem:(RIButtonItem *)inDestructiveItem
   otherButtonItems:(RIButtonItem *)inOtherButtonItems, ...
{
	self = [self initWithTitle:inTitle
					  delegate:self
			 cancelButtonTitle:[inCancelButtonItem label]
		destructiveButtonTitle:[inDestructiveItem label]
			 otherButtonTitles:nil];
	if (self)
	{
		NSMutableArray *buttonsArray = [NSMutableArray array];
        
        RIButtonItem *eachItem;
        va_list argumentList;
        if (inOtherButtonItems != nil)
        {
            [buttonsArray addObject: inOtherButtonItems];
            va_start(argumentList, inOtherButtonItems);
            while ((eachItem = va_arg(argumentList, RIButtonItem *)))
            {
                [buttonsArray addObject: eachItem];
            }
            va_end(argumentList);
        }
        
        for	(RIButtonItem *item in buttonsArray)
        {
            [self addButtonWithTitle:[item label]];
        }
		
		NSLog(@"destructiveButtonIndex: %d", [self destructiveButtonIndex]);
		NSLog(@"cancelButtonIndex: %d", [self cancelButtonIndex]);
		
		if (inDestructiveItem != nil)
        {
			[buttonsArray insertObject:inDestructiveItem atIndex:[self destructiveButtonIndex]];
        }
		
        if (inCancelButtonItem != nil)
        {
            [buttonsArray insertObject:inCancelButtonItem atIndex:[self cancelButtonIndex]];
        }
        
        objc_setAssociatedObject(self, RI_BUTTON_ASS_KEY, buttonsArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self retain]; // keep yourself around!
	}
	
    return self;
}

/*
// Original
-(id)initWithTitle:(NSString *)inTitle cancelButtonItem:(RIButtonItem *)inCancelButtonItem destructiveButtonItem:(RIButtonItem *)inDestructiveItem otherButtonItems:(RIButtonItem *)inOtherButtonItems, ...
{
    if((self = [self initWithTitle:inTitle delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil]))
    {
        NSMutableArray *buttonsArray = [NSMutableArray array];
        
        RIButtonItem *eachItem;
        va_list argumentList;
        if (inOtherButtonItems)
        {
            [buttonsArray addObject: inOtherButtonItems];
            va_start(argumentList, inOtherButtonItems);
            while((eachItem = va_arg(argumentList, RIButtonItem *)))
            {
                [buttonsArray addObject: eachItem];
            }
            va_end(argumentList);
        }
        
        for(RIButtonItem *item in buttonsArray)
        {
            [self addButtonWithTitle:item.label];
        }
        
        if(inDestructiveItem)
        {
            [buttonsArray addObject:inDestructiveItem];
            NSInteger destIndex = [self addButtonWithTitle:inDestructiveItem.label];
            [self setDestructiveButtonIndex:destIndex];
        }
        if(inCancelButtonItem)
        {
            [buttonsArray addObject:inCancelButtonItem];
            NSInteger cancelIndex = [self addButtonWithTitle:inCancelButtonItem.label];
            [self setCancelButtonIndex:cancelIndex];
        }
        
        objc_setAssociatedObject(self, RI_BUTTON_ASS_KEY, buttonsArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self retain]; // keep yourself around!
    }
    return self;
}
*/
- (void)addButtonItem:(RIButtonItem *)item
{	
    NSMutableArray *buttonsArray = objc_getAssociatedObject(self, RI_BUTTON_ASS_KEY);	

	[self addButtonWithTitle:item.label];
	[buttonsArray addObject:item];
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSArray *buttonsArray = objc_getAssociatedObject(self, RI_BUTTON_ASS_KEY);
	
	if ( (buttonIndex >= 0) && (buttonIndex < [buttonsArray count]) )
	{
		RIButtonItem *item = [buttonsArray objectAtIndex:buttonIndex];
		if(item.action)
			item.action();
		objc_setAssociatedObject(self, RI_BUTTON_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
	
	[self release]; // and release yourself!
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


@end
