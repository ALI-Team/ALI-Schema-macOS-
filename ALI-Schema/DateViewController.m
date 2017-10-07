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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)_makePopoverIfNeeded {
    if (self.popover == nil) {
        self.popover = [[NSPopover alloc] init];
        [self.popover setContentViewController:[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"date"]];
        [self.popover setContentSize:CGSizeMake(160, 220)];
        [self.popover setAnimates:true];
        [self.popover setBehavior:NSPopoverBehaviorTransient];
        [self.popover setDelegate:self];
    }
}

- (void)showPopup:(NSView *)positioningView {
    [self _makePopoverIfNeeded];
    [self.popover showRelativeToRect:[positioningView bounds] ofView:positioningView preferredEdge:NSMinYEdge];
}

@end
