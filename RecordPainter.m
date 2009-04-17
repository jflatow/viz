//
//  RecordPainter.m
//  viz
//
//  Created by Jared Flatow on 4/3/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import "RecordPainter.h"
#import "Canvas.h"
#import "DataView.h"
#import "Record.h"

@implementation RecordPainter

@synthesize canvas;

- (void) clearCanvas {
    [canvas clear];
}

- (void) paintRecord:(Record *) record withIndex:(NSUInteger) index {
    [canvas setText:[[NSString alloc] initWithFormat:@"%d\n%@", index, [[record fields] componentsJoinedByString:@"\n"], nil]];
    [canvas blink];
    [canvas setNeedsDisplay];
}

@end
