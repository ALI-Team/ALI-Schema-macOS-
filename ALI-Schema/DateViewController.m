//
//  DateViewController.m
//  ALI-Schema
//
//  Created by Luka Janković on 2017-10-07.
//  Copyright © 2017 ALI-Team. All rights reserved.
//

#import "DateViewController.h"

@interface DateViewController ()

@end

@implementation DateViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self instantiatePopover];
    }
    return self;
}

- (void)instantiatePopover {
    if (self.popover == nil) {
        
        NSViewController *contentViewController = [[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"date"];
        
        for (NSView *view in contentViewController.view.subviews) {
            if ([view isKindOfClass:[NSDatePicker class]]) {
                
                self.calendarPicker = (NSDatePicker *)view;
                self.calendarPicker.dateValue = [NSDate date];
                
                [self.calendarPicker setTarget:self];
                [self.calendarPicker setAction:@selector(calendarPickerChanged:)];
            }
            
            if ([view isKindOfClass:[NSButton class]]) {
                
                NSButton *todayButton = (NSButton *)view;
                
                [todayButton setTarget:self];
                [todayButton setAction:@selector(todayPressed:)];
            }
        }
        
        self.popover = [[NSPopover alloc] init];
        [self.popover setContentViewController:contentViewController];
        [self.popover setContentSize:CGSizeMake(160, 220)];
        [self.popover setAnimates:true];
        [self.popover setBehavior:NSPopoverBehaviorTransient];
        [self.popover setDelegate:self];
    }
}

- (void)showPopup:(NSView *)positioningView {
    
    [self instantiatePopover];
    
    [self.popover showRelativeToRect:[positioningView bounds] ofView:positioningView preferredEdge:NSMinYEdge];
}

- (IBAction)todayPressed:(id)sender {
    [self.listener performSelector:@selector(todayPressed:) withObject:self];
    [self.popover close];
}

- (IBAction)calendarPickerChanged:(id)sender {
    [self.listener performSelector:@selector(calendarPickerChanged:) withObject:self.calendarPicker.dateValue];
    [self.popover close];
}

@end
