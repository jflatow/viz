//
//  RecordStream.h
//  viz
//
//  Created by Jared Flatow on 3/1/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

#import "Record.h"
#import "Checkpoint.h"

@interface RecordStream : NSObject {
  NSUInteger index, checkpointDistance;
  NSMutableArray *checkpoints;
  NSFileHandle *fileHandle;
  Class <RecordParsing> recordParser;
  Record *currentRecord;
  
  CGLayerRef graphicsLayer;
  CALayer *animationLayer;
}

@property Record *currentRecord;
@property CGLayerRef graphicsLayer;
@property CALayer *animationLayer;

+ (RecordStream *) recordStreamWithPath:(NSString *) path;
- (RecordStream *) initWithFileHandle:(NSFileHandle *) aFileHandle 
                      andRecordParser:(Class <RecordParsing>) recordParser;

- (void) blink;
- (void) more;
- (void) less;
- (void) reset;

- (void) pullRecord;
- (void) pullRecords:(NSUInteger) howMany;
- (Checkpoint *) closestCheckpoint;
- (void) loadCheckpoint:(Checkpoint *) checkpoint;
- (void) maybeSaveCheckpoint;
- (void) saveCheckpoint:(Checkpoint *) checkpoint;

@end
