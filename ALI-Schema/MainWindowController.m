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

- (IBAction)toggleSidebar:(id)sender {
    [self.contentViewController performSelector:@selector(toggleSidebar:) withObject:self];
}

@end
