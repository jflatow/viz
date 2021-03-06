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

@property (assign) NSArray *fields;

- (id) initWithFields:(NSArray *) fields;
- (id) initFromFileHandle:(NSFileHandle *) fileHandle;
- (BOOL) contains:(NSString *) string;
- (NSString *) stringRepresentation;

@end
