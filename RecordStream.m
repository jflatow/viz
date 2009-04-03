//
//  RecordStream.m
//  viz
//
//  Created by Jared Flatow on 3/1/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import "RecordStream.h"


@implementation RecordStream

@synthesize currentRecord, graphicsLayer, animationLayer;

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
        index = 0;
        checkpointDistance = 100;
        checkpoints = [NSMutableArray arrayWithCapacity:1<<5];
        fileHandle = aFileHandle;
        recordParser = aRecordParser;
        currentRecord = nil;
        animationLayer = [CALayer layer];
        [animationLayer setDelegate:self];
    }
    return self;
}

- (void) blink {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setRepeatCount:1];
    [animation setFromValue:[NSNumber numberWithFloat:0.]];
    [animation setToValue:[NSNumber numberWithFloat:1.]];
    [animationLayer addAnimation:animation forKey:@"animateOpacity"];
}

- (void) more {
    [self maybeSaveCheckpoint];
    [self pullRecord];
    if (currentRecord)
        index++;
}

- (void) less {
    if (index <= 1)
        return [self reset];
    if (currentRecord)
        index--;
    [self loadCheckpoint:[self closestCheckpoint]];
}

- (void) reset {
    index = 0;
    [fileHandle seekToFileOffset:0];
    [self setCurrentRecord:nil];
    [self setGraphicsLayer:CGLayerCreateWithContext(CGLayerGetContext(graphicsLayer), CGSizeZero, nil)];
}

- (void) pullRecord {
    [self setCurrentRecord:[recordParser nextRecordFromFileHandle:fileHandle]];
    [currentRecord paintInContext:CGLayerGetContext(graphicsLayer)];
}

- (void) pullRecords:(NSUInteger) howMany {
    while (howMany--)
        [self pullRecord];
}

- (Checkpoint *) closestCheckpoint {
    return [checkpoints objectAtIndex:(index - 1) / checkpointDistance];
}

- (void) loadCheckpoint:(Checkpoint *) checkpoint {
    [self setGraphicsLayer:CopyCGLayer([checkpoint graphicsLayer])];
    [fileHandle seekToFileOffset:[checkpoint offset]];
    [self pullRecords:(index - 1) % checkpointDistance + 1];
}

- (void) maybeSaveCheckpoint {
    if (index % checkpointDistance == 0 && [checkpoints count] < index / checkpointDistance + 1)
        [self saveCheckpoint:[[Checkpoint alloc] initWithOffset:[fileHandle offsetInFile] andGraphicsLayer:graphicsLayer]];
}

- (void) saveCheckpoint:(Checkpoint *) checkpoint {
    [checkpoints addObject:checkpoint];
}

- (void) drawLayer:(CALayer *) theLayer inContext:(CGContextRef) context {
    if (!graphicsLayer)
        [self setGraphicsLayer:CGLayerCreateWithContext(context, CGSizeMake(500, 500), nil)];
    
    CATextLayer *textLayer;
    if (!(textLayer = [[theLayer sublayers] lastObject])) {
        CGColorRef fgColor = CGColorCreateGenericRGB(0.1, 0.1, 0.1, 1.0);
        textLayer = [CATextLayer layer];
        [textLayer setForegroundColor:fgColor];
        [textLayer setFontSize:12];
        [textLayer setAutoresizingMask:(kCALayerHeightSizable | kCALayerWidthSizable)];
        [theLayer addSublayer:textLayer];
        [textLayer setFrame:[theLayer frame]];
        CGColorRelease(fgColor);
    }
    [textLayer setString:[[NSString alloc] initWithFormat:@"%d\n%@", index, [[currentRecord fields] componentsJoinedByString:@"\n"], nil]];
    
    CGContextDrawLayerAtPoint(context, CGPointZero, graphicsLayer);
}

- (void) setGraphicsLayer:(CGLayerRef) layer {
    CGLayerRelease(graphicsLayer);
    graphicsLayer = layer;
}

- (void) dealloc {
    CGLayerRelease(graphicsLayer);
    [super dealloc];
}

@end
