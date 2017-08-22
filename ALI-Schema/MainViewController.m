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

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSUInteger)sourceList:(PXSourceList *)sourceList numberOfChildrenOfItem:(id)item {
    return 1;
}

- (id)sourceList:(PXSourceList *)aSourceList child:(NSUInteger)index ofItem:(id)item {
    return [PXSourceListItem itemWithTitle:@"test" identifier:@"asd"];
}

- (id)sourceList:(PXSourceList*)aSourceList objectValueForItem:(id)item {
    return [item title];
}

- (BOOL)sourceList:(PXSourceList *)aSourceList isItemExpandable:(id)item {
    return true;
}

- (IBAction)addSchool:(id)sender {
    
    self.addView = [[AddViewController alloc] initWithNibName:@"AddViewController" bundle:[NSBundle mainBundle]];
    
    [self presentViewControllerAsSheet:self.addView];
}
@end
