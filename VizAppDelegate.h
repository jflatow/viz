//
//  VizAppDelegate.h
//  viz
//
//  Created by Jared Flatow on 3/2/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DataSourceController;

@interface VizAppDelegate : NSObject {
	IBOutlet DataSourceController *dataSourceController;
}

- (IBAction) openDocument:(id) sender;

@end
