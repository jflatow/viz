//
//  DataSourceController.h
//  viz
//
//  Created by Jared Flatow on 3/2/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DataSourceController : NSDocumentController {
    BOOL hasOpenedDataSources;
}

@property BOOL hasOpenedDataSources;

- (void) openDataSource;
- (BOOL) openDataSourcesForPaths:(NSArray *) paths;
- (void) closeAll;
@end
