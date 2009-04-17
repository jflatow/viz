//
//  RecordStream.m
//  viz
//
//  Created by Jared Flatow on 3/1/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import "RecordStream.h"
#import "Checkpoint.h"
#import "Record.h"
#import "RecordPainter.h"
#import "StreamBufferedFileHandle.h"
#import "ThrottledFileHandle.h"

NSUInteger checkpointIndexForRecordIndex(NSUInteger recordIndex, NSUInteger checkpointDistance) {
    if (!recordIndex)
        return 0;
    return checkpointDistance ? (recordIndex) / checkpointDistance : 0;
}

@implementation RecordStream

static NSUInteger DELTA_RPF = 10;

@synthesize currentRecord, fileHandle, framesPerSecond, index, recordPainter, recordsPerFrame;

+ (void) initialize {
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"300",           @"CheckpointDistance",
                                 @"100",           @"FramesPerSecond",
                                 @"100",           @"RecordsPerFrame",
                                 @"YES",           @"SavesCheckpoints",
                                 @"RecordPainter", @"RecordPainterClass",
                                 @"Record",        @"RecordParserClass", nil];
    [defaults registerDefaults:appDefaults];
}

+ (Class) validClassForKey:(NSString *) key {
    Class class;
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [defaults volatileDomainForName:NSRegistrationDomain];
    if (!(class = objc_getClass([[defaults   stringForKey:key] UTF8String])))
          class = objc_getClass([[appDefaults valueForKey:key] UTF8String]);
    return class;
}

- (id) initWithPath:(NSString *) path {
    if (self = [super init]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        checkpointDistance = [defaults                   integerForKey:@"CheckpointDistance"];
        framesPerSecond    = [defaults                   integerForKey:@"FramesPerSecond"];
        recordsPerFrame    = [defaults                   integerForKey:@"RecordsPerFrame"];
        recordPainter      = [[[[self class]          validClassForKey:@"RecordPainterClass"] alloc] init];
        recordParser       = [[  self class]          validClassForKey:@"RecordParserClass"];
        savesCheckpoints   = checkpointDistance ? [defaults boolForKey:@"SavesCheckpoints"] : NO;
        checkpoints        = [NSMutableArray arrayWithCapacity:1<<5];
        playing            = false; 
        if (savesCheckpoints)
            fileHandle = [ThrottledFileHandle fileHandleForReadingAtPath:path];
        else
            fileHandle = [StreamBufferedFileHandle fileHandleForReadingAtPath:path];
        if (!fileHandle)
            return nil;
        [self reset];
    }
    return self;
}

- (Canvas *) canvas {
    return [recordPainter canvas];
}

- (void) setCanvas:(Canvas *) canvas {
    [recordPainter setCanvas:canvas];
}

- (void) close {
    [fileHandle closeFile];
}

- (void) first {
    [self seekToIndex:1];
}

- (void) last {
    [self seekToIndex:NSUIntegerMax];
}

- (void) next {
    [self pullRecord];
}

- (BOOL) nextFrame {
    return [self pullRecords:recordsPerFrame] < recordsPerFrame;
}

- (void) pause {
    playing = false;
}

- (void) play {
    playing = true;
    [NSTimer scheduledTimerWithTimeInterval:[self frameInterval]
                                     target:self
                                   selector:@selector(playTimerFired:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void) playTimerFired:(NSTimer *) timer {
    [self nextFrame];
    if (!playing || !currentRecord) {
        playing = false;
        [timer invalidate];
    }
}

- (void) prev {
    if (index <= 1)
        return [self reset];
    [self seekToIndex:index - 1];
}

- (void) prevFrame {
    if (index <= recordsPerFrame)
        return [self reset];
    [self seekToIndex:index - recordsPerFrame];
}

- (Record *) pullRecord {
    [self maybeSaveCheckpoint];
    if (currentRecord = [recordParser nextRecordFromFileHandle:fileHandle])
        [recordPainter paintRecord:currentRecord withIndex:++index];
    return currentRecord;
}

- (NSUInteger) pullRecords:(NSUInteger) howMany {
    while (howMany-- && [self pullRecord]);
    return howMany + 1;
}

- (void) reset {
    [fileHandle seekToFileOffset:index = 0];
    [self setCurrentRecord:nil];
    [recordPainter clearCanvas];
}

- (void) seekToIndex:(NSUInteger) theIndex {
    [self loadCheckpoint:[self checkpointForRecordIndex:theIndex]];
    if (theIndex > index)
        [self pullRecords:theIndex - index];
}

- (void) slowDown {
    if (recordsPerFrame >= DELTA_RPF)
        recordsPerFrame -= DELTA_RPF;
    DebugLog(@"recordsPerFrame: %d, framesPerSecond: %d", recordsPerFrame, framesPerSecond);
}

- (void) speedUp {
    recordsPerFrame += DELTA_RPF;
    DebugLog(@"recordsPerFrame: %d, framesPerSecond: %d", recordsPerFrame, framesPerSecond);
}

- (void) togglePlay {
    playing ? [self pause] : [self play];
}

- (Checkpoint *) checkpointForRecordIndex:(NSUInteger) theIndex {
    NSUInteger checkpointIndex = checkpointIndexForRecordIndex(theIndex, checkpointDistance);
    if (checkpointIndex < [checkpoints count])
        return [checkpoints objectAtIndex:checkpointIndex];
    return [checkpoints lastObject];
}

- (void) loadCheckpoint:(Checkpoint *) checkpoint {
    [checkpoint loadIntoRecordStream:self];
}

- (void) maybeSaveCheckpoint {
    if (savesCheckpoints)
        if (index % checkpointDistance == 0 && [checkpoints count] < index / checkpointDistance + 1)
            [self saveCheckpoint:[[Checkpoint alloc] initFromRecordStream:self]];
}

- (void) saveCheckpoint:(Checkpoint *) checkpoint {
    [checkpoints addObject:checkpoint];
}

- (double) frameInterval {
    return 1. / framesPerSecond;
}

@end
