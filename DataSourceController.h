//
//  DataSourceController.h
//  viz
//
//  Created by Jared Flatow on 3/2/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DataSourceController : NSDocumentController {
}

- (void) openDataSource;
- (BOOL) openDataSourcesForPaths:(NSArray *) paths;

@end
