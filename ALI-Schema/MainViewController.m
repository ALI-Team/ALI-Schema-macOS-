//
//  SourceListController.m
//  ALI-Schema
//
//  Created by Luka Janković on 2017-08-21.
//  Copyright © 2017 ALI-Team. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewWillAppear {
    [super viewWillAppear];
    
    [self reloadSidebar];
}

- (NSUInteger)sourceList:(PXSourceList *)sourceList numberOfChildrenOfItem:(id)item {
    if (item)
        return [item children].count;
    else
        return self.scheduleList.count;
}

- (id)sourceList:(PXSourceList *)aSourceList child:(NSUInteger)index ofItem:(id)item {
    if (item) {
        return [[item children] objectAtIndex:index];
    } else {
        return [self.sourceListItems objectAtIndex:index];
    }
}

- (id)sourceList:(PXSourceList*)aSourceList objectValueForItem:(id)item {
    return [item title];
}

- (BOOL)sourceList:(PXSourceList *)aSourceList isItemExpandable:(id)item {
    return [[item identifier] isEqualToString:@"school"];
}

- (IBAction)addSchool:(id)sender {
    
    self.addView = [[AddViewController alloc] initWithNibName:@"AddViewController" bundle:[NSBundle mainBundle]];
    self.addView.parent = self;
    
    [self presentViewControllerAsSheet:self.addView];
}

- (IBAction)removeSchool:(id)sender {
    
    NSString *schoolName = [[self.sourceList parentForItem:[self.sourceList itemAtRow:self.sourceList.selectedRow]] title];
    NSString *className = [[self.sourceList itemAtRow:self.sourceList.selectedRow] title];
    NSMutableArray *classArray = nil;
    int schoolIndex = -1;
    
    for (NSDictionary *school in self.scheduleList)  {
        if ([school[@"namn"] isEqualToString:schoolName]) {
            schoolIndex = (int)[self.scheduleList indexOfObject:school];
            classArray = [school[@"classList"] mutableCopy];
            [classArray removeObject:className];
        }
    }
    
    if (schoolIndex > -1) {
        if (classArray.count > 0) {
            NSMutableDictionary *schoolDict = [self.scheduleList[schoolIndex] mutableCopy];
            [schoolDict setObject:classArray forKey:@"classList"];
            
            [self.scheduleList replaceObjectAtIndex:schoolIndex withObject:schoolDict];
        } else {
            [self.scheduleList removeObjectAtIndex:schoolIndex];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:self.scheduleList forKey:@"scheduleList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self reloadSidebar];
    }
}

- (void)reloadSidebar {
    
    self.scheduleList = [[[NSUserDefaults standardUserDefaults] objectForKey:@"scheduleList"] mutableCopy];
    self.sourceListItems = @[].mutableCopy;
    
    for (NSDictionary *school in self.scheduleList) {
        PXSourceListItem *schoolItem = [PXSourceListItem itemWithTitle:school[@"namn"] identifier:@"school"];
        
        NSMutableArray *classList = @[].mutableCopy;
        
        for (NSString *class in school[@"classList"]) {
            [classList addObject:[PXSourceListItem itemWithTitle:class identifier:@"class"]];
        }
        
        schoolItem.children = classList;
        
        [self.sourceListItems addObject:schoolItem];
    }
    
    [self.sourceList reloadData];
}

@end
