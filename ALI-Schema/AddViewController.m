//
//  AddViewController.m
//  ALI-Schema
//
//  Created by Luka Janković on 2017-08-22.
//  Copyright © 2017 ALI-Team. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)cancel:(id)sender {
    [self.view.window.sheetParent endSheet:self.view.window];
}

@end
