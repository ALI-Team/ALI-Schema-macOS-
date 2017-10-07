//
//  MainWindowController.h
//  ALI-Schema
//
//  Created by Luka Janković on 2017-09-24.
//  Copyright © 2017 ALI-Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MainViewController.h"
#import "DateViewController.h"

@interface MainWindowController : NSWindowController <NSPopoverDelegate>

@property MainViewController *mainViewController;
@property DateViewController *dateViewController;

@property (weak) IBOutlet NSSegmentedControl *weekControl;

- (IBAction)weekChanged:(id)sender;

@end
