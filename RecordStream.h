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
    BOOL playing, recording, savesCheckpoints;
    NSUInteger checkpointDistance, framesPerSecond, index, recordsPerFrame;
    NSMutableArray *checkpoints;
    NSFileHandle *fileHandle;
    Class <RecordParsing> recordParser;
    RecordPainter *recordPainter;
    Record *currentRecord;
}

@property NSUInteger framesPerSecond, index, recordsPerFrame;
@property NSFileHandle *fileHandle;
@property Record *currentRecord;
@property RecordPainter *recordPainter;
@property (readonly) double frameInterval;

+ (Class) validClassForKey:(NSString *) key;
- (id) initWithPath:(NSString *) path;
- (void) close;
- (void) first;
- (void) last;
- (void) next;
- (BOOL) nextFrame;
- (void) pause;
- (void) play;
- (void) playTimerFired:(NSTimer *) timer;
- (void) prev;
- (void) prevFrame;
- (Record *) pullRecord;
- (NSUInteger) pullRecords:(NSUInteger) howMany;
- (void) reset;
- (void) seekToIndex:(NSUInteger) theIndex;
- (void) slowDown;
- (void) speedUp;
- (void) togglePlay;

- (Checkpoint *) checkpointForRecordIndex:(NSUInteger) theIndex;
- (void) loadCheckpoint:(Checkpoint *) checkpoint;
- (void) maybeSaveCheckpoint;
- (void) saveCheckpoint:(Checkpoint *) checkpoint;

@end
