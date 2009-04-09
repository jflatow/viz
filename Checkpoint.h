//
//  Checkpoint.h
//  viz
//
//  Created by Jared Flatow on 3/8/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@class RecordStream;

CGLayerRef CGLayerCopy(CGLayerRef layerRef);

@interface Checkpoint : NSObject {
    NSUInteger index, offset;
    CGLayerRef graphicsLayer;
}

- (Checkpoint *) initFromRecordStream:(RecordStream *) recordStream;
- (void) loadIntoRecordStream:(RecordStream *) recordStream;

@end
