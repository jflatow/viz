//
//  RecordPainter.h
//  viz
//
//  Created by Jared Flatow on 4/3/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DataView, Record, RecordPainter;

@interface RecordPainter : NSObject {
    DataView *dataView;
    CALayer *animationLayer;
    CGLayerRef graphicsLayer;
}

@property DataView *dataView;
@property CGLayerRef graphicsLayer;

- (RecordPainter *) initWithDataView:(DataView *) dataView;
- (void) clear;
- (void) paintRecord:(Record *) record withIndex:(NSUInteger) index;
- (void) setNeedsDisplay;
@end
