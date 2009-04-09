//
//  Checkpoint.m
//  viz
//
//  Created by Jared Flatow on 3/8/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import "Checkpoint.h"
#import "RecordStream.h"
#import "RecordPainter.h"

CGLayerRef CGLayerCopy(CGLayerRef layerRef) {
    CGLayerRef layerRefCopy = CGLayerCreateWithContext(CGLayerGetContext(layerRef), CGLayerGetSize(layerRef), nil);
    CGContextDrawLayerAtPoint(CGLayerGetContext(layerRefCopy), CGPointZero, layerRef);
    return layerRefCopy;
}

@implementation Checkpoint

- (Checkpoint *) initFromRecordStream:(RecordStream *) recordStream {
    if (self = [super init]) {
        index = [recordStream index];
        offset = [[recordStream fileHandle] offsetInFile];
        graphicsLayer = CGLayerCopy([[recordStream recordPainter] graphicsLayer]);
    }
    return self;
}

- (void) loadIntoRecordStream:(RecordStream *) recordStream {
    [recordStream setIndex:index];
    [[recordStream fileHandle] seekToFileOffset:offset];
    [[recordStream recordPainter] setGraphicsLayer:CGLayerCopy(graphicsLayer)];
}

- (void) dealloc {
    CGLayerRelease(graphicsLayer);
    [super dealloc];
}

@end
