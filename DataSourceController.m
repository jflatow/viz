//
//  DataSourceController.m
//  viz
//
//  Created by Jared Flatow on 3/2/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import "DataSourceController.h"
#import "DataSource.h"

@implementation DataSourceController

- (void) openDataSource {
  NSOpenPanel *openPanel = [NSOpenPanel openPanel];
  [openPanel retain];
  [openPanel setAllowsMultipleSelection:YES];
  [openPanel setResolvesAliases:YES];
  [openPanel beginForDirectory:nil
                          file:nil
                         types:nil
              modelessDelegate:self
                didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:)
                   contextInfo:nil];
}

- (void) openPanelDidEnd:(NSOpenPanel *) panel returnCode:(int) returnCode contextInfo:(void  *) contextInfo {
    if (returnCode == NSOKButton)
        [self openDataSourcesForPaths:[panel filenames]];
    [panel release];
}

- (BOOL) openDataSourcesForPaths:(NSArray *) paths {
    DebugLog(@"creating data source for paths: %@", paths);

    for (NSString *path in paths) {
    DataSource *dataSource = [[DataSource alloc] initWithPath:path];
        if (!dataSource) {
            NSAlert *alert = [NSAlert alertWithError:[NSError errorWithDomain:NSCocoaErrorDomain
                                                                         code:NSFileReadUnknownError
                                                                     userInfo:nil]];
      [alert runModal];
            return NO;
        }
        [dataSource setFileURL:[NSURL fileURLWithPath:[paths lastObject]]];
        [dataSource makeWindowControllers];
        [dataSource showWindows];  
        [self noteNewRecentDocumentURL:[NSURL fileURLWithPath:path]];
    }
    return YES;
}

- (void) closeAll {
    for (NSDocument *document in [self documents])
        [document close];
}

@end
