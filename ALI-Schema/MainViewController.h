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

#import "NSImageView+WebCache.h"

@interface MainViewController : NSViewController <PXSourceListDelegate, PXSourceListDataSource, NSSplitViewDelegate>

@property (strong) IBOutlet PXSourceList *sourceList;

@property (strong, nonatomic) AddViewController *addView;

@property (strong, nonatomic) NSMutableArray *scheduleList;
@property (strong, nonatomic) NSMutableArray *sourceListItems;

@property (strong, nonatomic) NSString *currentSchool;
@property (strong, nonatomic) NSString *currentClass;

@property (weak) IBOutlet NSButton *favouritesButton;
@property (weak) IBOutlet NSView *sidebarPlaceholder;
@property (weak) IBOutlet NSImageView *scheduleView;
@property (weak) IBOutlet DMSplitView *sidebarSplitView;

@property int week;

- (IBAction)addSchool:(id)sender;

- (void)toggleSidebar:(id)sender;
- (void)reloadSidebar;
- (void)weekIncrease;
- (void)weekDecrease;

@end
