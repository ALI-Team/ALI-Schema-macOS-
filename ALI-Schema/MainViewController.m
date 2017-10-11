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

#pragma mark STARTUP

- (void)viewWillAppear {
	[super viewWillAppear];
	
	self.view.window.titleVisibility = NSWindowTitleHidden;
	
	[self reloadSidebar];
	
	[self.sidebarSplitView setMinSize:250 ofSubviewAtIndex:0];
	[self.sidebarSplitView setMaxSize:250 ofSubviewAtIndex:0];
    
    [self todayPressed:self];
}

- (void)awakeFromNib {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSchedule) name:NSWindowDidResizeNotification object:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark SIDEBAR

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

- (void)sourceListSelectionDidChange:(NSNotification *)notification {
	
	NSInteger sectionIndex = [self.sourceList rowForItem:[self.sourceList parentForItem:[self.sourceList itemAtRow:self.sourceList.selectedRow]]];
	NSInteger rowIndex = self.sourceList.selectedRow - sectionIndex - 1;
	
	NSIndexPath *currentFavorite = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"favorite"]];
	NSIndexPath *selectedItemIndex = [NSIndexPath indexPathForItem:rowIndex inSection:sectionIndex];
	
	if ([currentFavorite isEqualTo:selectedItemIndex]) {
		[self.favouritesButton setImage:[NSImage imageNamed:@"ic_star"]];
	} else {
		[self.favouritesButton setImage:[NSImage imageNamed:@"ic_star_border"]];
	}
	
	NSString *schoolName = [[self.sourceList parentForItem:[self.sourceList itemAtRow:self.sourceList.selectedRow]] title];
	NSString *className = [[self.sourceList itemAtRow:self.sourceList.selectedRow] title];
	
	for (NSDictionary *school in self.scheduleList) {
		if ([school[@"namn"] isEqualToString:schoolName]) {
			self.currentSchool = school[@"id"];
			for (NSString *class in school[@"classList"]) {
				if ([class isEqualToString:className]) {
					self.currentClass = class;
				}
			}
		}
	}
	
	[self loadSchedule];
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

- (IBAction)toggleFavourites:(id)sender {
	
	NSInteger sectionIndex = [self.sourceList rowForItem:[self.sourceList parentForItem:[self.sourceList itemAtRow:self.sourceList.selectedRow]]];
	NSInteger rowIndex = self.sourceList.selectedRow - sectionIndex - 1;
	
	NSIndexPath *currentFavorite = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"favorite"]];
	NSIndexPath *selectedItemIndex = [NSIndexPath indexPathForItem:rowIndex inSection:sectionIndex];
	
	//    NSLog(@"s %i r %i", currentFavorite.section, currentFavorite.item);
	
	if ([currentFavorite isEqualTo:selectedItemIndex]) {
		
		[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"favorite"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		[self.favouritesButton setImage:[NSImage imageNamed:@"ic_star_border"]];
		
	} else {
		
		[self.favouritesButton setImage:[NSImage imageNamed:@"ic_star"]];
		
		[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:selectedItemIndex] forKey:@"favorite"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void)toggleSidebar:(id)sender {
	[self.sidebarSplitView collapseOrExpandSubview:self.sidebarPlaceholder animated:true];
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview {
	return true;
}

- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex {
	return true;
}

- (NSRect)splitView:(NSSplitView *)splitView effectiveRect:(NSRect)proposedEffectiveRect forDrawnRect:(NSRect)drawnRect ofDividerAtIndex:(NSInteger)dividerIndex {
	return NSZeroRect;
}

#pragma mark SCHEDULE

- (void)loadSchedule {
    [self.scheduleView setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.novasoftware.se/ImgGen/schedulegenerator.aspx?format=png&schoolid=%@/sv-se&type=-1&id=%@&period=&week=%i&mode=0&printer=0&colors=32&head=0&clock=0&foot=0&day=0&width=%.f&height=%.f&maxwidth=%.f&maxheight=%.f", self.currentSchool, self.currentClass, self.week, self.scheduleView.frame.size.width, self.scheduleView.frame.size.height, self.scheduleView.frame.size.width, self.scheduleView.frame.size.height]]];
}

- (void)weekIncrease {
    if (self.week < 52) {
        self.week++;
        [self loadSchedule];
    }
}

- (void)weekDecrease {
    if (self.week > 1) {
        self.week--;
        [self loadSchedule];
    }
}

- (void)todayPressed:(id)sender {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:NSCalendarUnitWeekOfYear fromDate:[NSDate date]];
    self.week = (int)dateComponent.weekOfYear;
    
    [self loadSchedule];
    [self.mainWindowController performSelector:@selector(updateControl)];
}

- (void)calendarPickerChanged:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:NSCalendarUnitWeekOfYear fromDate:date];
    self.week = (int)dateComponent.weekOfYear;
    
    [self loadSchedule];
    [self.mainWindowController performSelector:@selector(updateControl)];
}

@end
