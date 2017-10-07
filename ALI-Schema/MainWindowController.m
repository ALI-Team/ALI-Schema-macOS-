//
//  MainWindowController.m
//  ALI-Schema
//
//  Created by Luka Janković on 2017-09-24.
//  Copyright © 2017 ALI-Team. All rights reserved.
//

#import "MainWindowController.h"

@interface MainWindowController ()

@end

@implementation MainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];

    self.mainViewController = (MainViewController *)self.contentViewController;
    [self updateControl];
}

- (IBAction)toggleSidebar:(id)sender {
    [self.mainViewController toggleSidebar:self];
}

- (IBAction)weekChanged:(id)sender {
    
    switch (self.weekControl.selectedSegment) {
        case 0: {
            [self.mainViewController weekDecrease];
            break;
        }
            
        case 1: {
            if (!self.dateViewController) {
                self.dateViewController = [[DateViewController alloc] init];
            }
            
            [self.dateViewController showPopup:self.weekControl];
            
            break;
        }
        case 2: {
            [self.mainViewController weekIncrease];
            break;
        }
    }
    
    [self updateControl];
}

- (void)updateControl {

    [self.weekControl setLabel:[NSString stringWithFormat:@"Week %i", self.mainViewController.week] forSegment:1];
}

- (void)showRelativeToRect:(NSRect)positioningRect ofView:(NSView *)positioningView preferredEdge:(NSRectEdge)preferredEdge {
    
}

@end
