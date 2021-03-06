//
//  DateViewController.h
//  ALI-Schema
//
//  Created by Luka Janković on 2017-10-07.
//  Copyright © 2017 ALI-Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DateViewController : NSViewController <NSPopoverDelegate>

@property id listener;

@property (strong, nonatomic) NSPopover *popover;
@property (weak) IBOutlet NSDatePicker *calendarPicker;

- (void)showPopup:(NSView *)positioningView;

@end
