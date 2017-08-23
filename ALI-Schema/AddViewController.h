//
//  AddViewController.h
//  ALI-Schema
//
//  Created by Luka Janković on 2017-08-22.
//  Copyright © 2017 ALI-Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AddViewController : NSViewController

@property (weak) IBOutlet NSComboBox *schoolList;
@property (weak) IBOutlet NSTextField *classInput;
@property (weak) IBOutlet NSButton *favoriteSwitch;

@property id parent;

@property (strong, nonatomic) NSArray *schools;

@end
