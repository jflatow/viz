//
//  DataSource.h
//  viz
//
//  Created by Jared Flatow on 3/2/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DataView.h"
#import "RecordStream.h"

@interface DataSource : NSDocument {
    IBOutlet DataView *dataView;
    
    RecordStream *recordStream;
}

@property(assign) RecordStream *recordStream;

- (DataSource *) initWithPath:(NSString *) path;

@end
