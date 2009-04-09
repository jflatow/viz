//
//  RecordPainter.m
//  viz
//
//  Created by Jared Flatow on 4/3/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import "RecordPainter.h"
#import "DataView.h"
#import "Record.h"

@implementation RecordPainter

@synthesize dataView, graphicsLayer;

- (RecordPainter *) initWithDataView:(DataView *) aDataView {
    if (self = [super init]) {
        [self setDataView:aDataView];
        animationLayer = [CALayer layer];
        [animationLayer setDelegate:self];
        [dataView addLayer:animationLayer];
        [self setNeedsDisplay];
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

- (void) clear {
    [self setGraphicsLayer:CGLayerCreateWithContext(CGLayerGetContext(graphicsLayer), CGSizeZero, nil)];
    [[[animationLayer sublayers] lastObject] removeFromSuperlayer];
    [self setNeedsDisplay];
}

- (void) drawLayer:(CALayer *) theLayer inContext:(CGContextRef) context {
    if (!graphicsLayer)
        [self setGraphicsLayer:CGLayerCreateWithContext(context, CGSizeMake(500, 500), nil)];
    CGContextDrawLayerAtPoint(context, CGPointZero, graphicsLayer);
}

- (void) paintRecord:(Record *) record withIndex:(NSUInteger) index {
    CATextLayer *textLayer;
    if (!(textLayer = [[animationLayer sublayers] lastObject])) {
        CGColorRef fgColor = CGColorCreateGenericRGB(0.1, 0.1, 0.1, 1.0);
        textLayer = [CATextLayer layer];
        [textLayer setForegroundColor:fgColor];
        [textLayer setFontSize:12];
        [textLayer setAutoresizingMask:(kCALayerHeightSizable | kCALayerWidthSizable)];
        [animationLayer addSublayer:textLayer];
        [textLayer setFrame:[animationLayer frame]];
        CGColorRelease(fgColor);
    }
    [textLayer setString:[[NSString alloc] initWithFormat:@"%d\n%@", index, [[record fields] componentsJoinedByString:@"\n"], nil]];
    
    CGContextRef context = CGLayerGetContext(graphicsLayer);
    float value = [[[record fields] objectAtIndex:5] floatValue];
    value       = value * value;
    
    CGContextSetRGBFillColor(context, 0, 0, 1, .2);
    CGContextSetRGBStrokeColor(context, 1, 0, 0, .2);
    CGContextBeginPath(context);
    CGContextAddArc(context, value, value, value, 0, 2 * M_PI, false);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    [self blink];
    [self setNeedsDisplay];
}

- (void) setGraphicsLayer:(CGLayerRef) layer {
    CGLayerRelease(graphicsLayer);
    graphicsLayer = layer;
}

- (void) setNeedsDisplay {
    [animationLayer setNeedsDisplay];
}

- (void) dealloc {
    CGLayerRelease(graphicsLayer);
    [super dealloc];
}

@end
