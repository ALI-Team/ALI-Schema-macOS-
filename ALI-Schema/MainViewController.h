//
//  SourceListController.h
//  ALI-Schema
//
//  Created by Luka Janković on 2017-08-21.
//  Copyright © 2017 ALI-Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PXSourceList.h"
#import "AddViewController.h"
#import "DMSplitView.h"

@interface MainViewController : NSViewController <PXSourceListDelegate, PXSourceListDataSource, NSSplitViewDelegate>

@property (strong) IBOutlet PXSourceList *sourceList;

@property (strong, nonatomic) AddViewController *addView;

@property (strong, nonatomic) NSMutableArray *scheduleList;
@property (strong, nonatomic) NSMutableArray *sourceListItems;

@property (weak) IBOutlet NSButton *favouritesButton;
@property (weak) IBOutlet NSView *sidebarPlaceholder;
@property (weak) IBOutlet DMSplitView *sidebarSplitView;

- (IBAction)addSchool:(id)sender;

- (void)reloadSidebar;

@end
