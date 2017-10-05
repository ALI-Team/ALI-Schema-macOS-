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

- (void)viewWillAppear {
    [super viewWillAppear];
    
    self.schools = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"schools" ofType:@"json"]] options:kNilOptions error:nil];
    
    for (NSDictionary *school in self.schools) {
        [self.schoolList addItemWithObjectValue:[NSString stringWithFormat:@"%@ (%@)", school[@"namn"], school[@"stad"]]];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"scheduleList"])
        [self.favoriteSwitch setState:NSOnState];
    else
        [self.favoriteSwitch setState:NSOffState];
}

- (IBAction)add:(id)sender {
    
    if (self.schoolList.indexOfSelectedItem == -1) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"Invalid school";
        alert.informativeText = @"Please select a school from the drop down list.";
        
        [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
    } else {
        if ([self.classInput.stringValue isEqualToString:@""]) {
            NSAlert *alert = [[NSAlert alloc] init];
            alert.messageText = @"Class empty";
            alert.informativeText = @"Please enter your class in the class field.";
            
            [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
        } else {
            
            NSMutableArray *scheduleArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"scheduleList"] mutableCopy];
            
            if (!scheduleArray)
                scheduleArray = @[].mutableCopy;
            
            NSDictionary *currentSchool = self.schools[self.schoolList.indexOfSelectedItem];
            NSMutableDictionary *existingSchool = nil;
            int schoolIndex = 0;
            
            for (NSDictionary *school in scheduleArray) {
                if ([school[@"namn"] isEqualToString:currentSchool[@"namn"]]) {
                    existingSchool = school.mutableCopy;
                    schoolIndex = (int)[scheduleArray indexOfObject:school];
                }
            }
            
            if (existingSchool) {
                NSMutableArray *schoolClassList = [existingSchool[@"classList"] mutableCopy];
                [schoolClassList addObject:self.classInput.stringValue];
                [existingSchool setValue:schoolClassList forKey:@"classList"];
                [scheduleArray replaceObjectAtIndex:schoolIndex withObject:existingSchool];
            } else {
                [scheduleArray addObject:@{@"namn":currentSchool[@"namn"], @"id":currentSchool[@"id"], @"classList":@[self.classInput.stringValue].mutableCopy}];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:scheduleArray forKey:@"scheduleList"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.parent performSelector:@selector(reloadSidebar)];
            [self.view.window.sheetParent endSheet:self.view.window];
        }
    }
}

- (IBAction)cancel:(id)sender {
    [self.view.window.sheetParent endSheet:self.view.window];
}

@end
