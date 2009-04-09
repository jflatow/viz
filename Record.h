//
//  Record.h
//  viz
//
//  Created by Jared Flatow on 3/1/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Record;

@protocol RecordParsing
+ (Record *) nextRecordFromFileHandle:(NSFileHandle *) fileHandle;
@end

@interface Record : NSObject <RecordParsing> {
    NSArray *fields;
}

@property(assign) NSArray *fields;

- (Record *) initWithFields:(NSArray *) fields;
- (Record *) initFromFileHandle:(NSFileHandle *) fileHandle;
@end
