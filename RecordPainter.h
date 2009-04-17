//
//  RecordPainter.h
//  viz
//
//  Created by Jared Flatow on 4/3/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DataView, Canvas, Record, RecordPainter;

@interface RecordPainter : NSObject {
    Canvas *canvas;
}

@property Canvas *canvas;

- (void) clearCanvas;
- (void) paintRecord:(Record *) record withIndex:(NSUInteger) index;

@end
