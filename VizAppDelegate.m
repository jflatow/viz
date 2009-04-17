//
//  VizAppDelegate.m
//  viz
//
//  Created by Jared Flatow on 3/2/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import "VizAppDelegate.h"
#import "DataSourceController.h"

@implementation VizAppDelegate

- (IBAction) openDocument:(id) sender {
    [dataSourceController openDataSource];
}

- (BOOL) application:(NSApplication *) application openFile:(NSString *) filename {
    return [dataSourceController openDataSourcesForPaths:[NSArray arrayWithObject:filename]];
}

- (void) application:(NSApplication *) application openFiles:(NSArray *) filenames {
    [dataSourceController openDataSourcesForPaths:filenames];
}

- (void) applicationWillFinishLaunching:(NSNotification *) aNotification {
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
}

- (void) applicationWillTerminate:(NSNotification *) aNotification {
    [dataSourceController closeAll];
}

@end
