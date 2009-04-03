//
//  VizAppDelegate.h
//  viz
//
//  Created by Jared Flatow on 3/2/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DataSourceController.h"

@interface VizAppDelegate : NSObject {
	IBOutlet DataSourceController *dataSourceController;
}

- (IBAction) openDocument:(id) sender;
- (BOOL) application:(NSApplication *) application openFile:(NSString *) filename;
- (void) application:(NSApplication *) application openFiles:(NSArray *) filenames;

@end
