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


NSUInteger checkpointIndexForRecordIndex(NSUInteger recordIndex, NSUInteger checkpointDistance) {
        return checkpointDistance ? (recordIndex - 1) / checkpointDistance : 0;
}

@implementation RecordStream

@synthesize index, fileHandle, currentRecord, recordPainter;

+ (void) initialize {
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"400", @"CheckpointDistance", nil];
    [defaults registerDefaults:appDefaults];
}

+ (RecordStream *) recordStreamWithPath:(NSString *) path {
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    if (!fileHandle)
        return nil;
    return [[RecordStream alloc] initWithFileHandle:fileHandle 
                                    andRecordParser:[Record class]];
}

- (RecordStream *) initWithFileHandle:(NSFileHandle *) aFileHandle 
                      andRecordParser:(Class <RecordParsing>) aRecordParser {
    if (self = [super init]) {
        NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
        checkpointDistance = [defaults integerForKey:@"CheckpointDistance"];
        checkpoints = [NSMutableArray arrayWithCapacity:1<<5];
        fileHandle = aFileHandle;
        recordParser = aRecordParser;
        [self reset];
    }
    return self;
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

- (void) prev {
    if (index <= 1)
        return [self reset];
    [self seekToIndex:index - 1];
}

- (Record *) pullRecord {
    [self maybeSaveCheckpoint];
    if (currentRecord = [recordParser nextRecordFromFileHandle:fileHandle])
        [recordPainter paintRecord:currentRecord withIndex:++index];
    return currentRecord;
}

- (BOOL) pullRecords:(NSUInteger) howMany {
    while (howMany-- && [self pullRecord]);
    return howMany == 0;
}

- (void) reset {
    [fileHandle seekToFileOffset:index = 0];
    [self setCurrentRecord:nil];
    [recordPainter clear];
}

- (void) seekToIndex:(NSUInteger) theIndex {
    [self loadCheckpoint:[self checkpointForRecordIndex:theIndex]];
    [self pullRecords:theIndex - index];
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
    if (index % checkpointDistance == 0 && [checkpoints count] < index / checkpointDistance + 1)
        [self saveCheckpoint:[[Checkpoint alloc] initFromRecordStream:self]];
}

- (void) saveCheckpoint:(Checkpoint *) checkpoint {
    [checkpoints addObject:checkpoint];
}

@end
