//
//  RecordStream.h
//  viz
//
//  Created by Jared Flatow on 3/1/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Checkpoint, Record, RecordPainter;
@protocol RecordParsing;

NSUInteger checkpointIndexForRecordIndex(NSUInteger recordIndex, NSUInteger checkpointDistance);

@interface RecordStream : NSObject {
    NSUInteger index, checkpointDistance;
    NSMutableArray *checkpoints;
    NSFileHandle *fileHandle;
    Class <RecordParsing> recordParser;
    RecordPainter *recordPainter;
    Record *currentRecord;
}

@property NSUInteger index;
@property NSFileHandle *fileHandle;
@property Record *currentRecord;
@property RecordPainter *recordPainter;

+ (RecordStream *) recordStreamWithPath:(NSString *) path;
- (RecordStream *) initWithFileHandle:(NSFileHandle *) aFileHandle 
                      andRecordParser:(Class <RecordParsing>) recordParser;

- (void) first;
- (void) last;
- (void) next;
- (void) prev;
- (Record *) pullRecord;
- (BOOL) pullRecords:(NSUInteger) howMany;
- (void) reset;
- (void) seekToIndex:(NSUInteger) theIndex;

- (Checkpoint *) checkpointForRecordIndex:(NSUInteger) theIndex;

- (void) loadCheckpoint:(Checkpoint *) checkpoint;
- (void) maybeSaveCheckpoint;
- (void) saveCheckpoint:(Checkpoint *) checkpoint;

@end
