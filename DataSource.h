//
//  DataSource.h
//  viz
//
//  Created by Jared Flatow on 3/2/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>

@class DataView, RecordStream;

@interface DataSource : NSDocument {
    IBOutlet DataView *dataView;
    RecordStream *recordStream;
    NSString *lastSearchString;
}

@property(assign) RecordStream *recordStream;

- (id) initWithPath:(NSString *) path;

@end
