//
//  Canvas.h
//  viz
//
//  Created by Jared Flatow on 4/13/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@class DataView;

@interface Canvas : NSObject {
    DataView *dataView;
    CGColorRef backgroundColor, fontColor;
    CALayer *animationLayer;
    CATextLayer *textLayer;
    CGLayerRef graphicsLayer;
    CGSize canvasSize;
}

@property DataView *dataView;
@property CGLayerRef graphicsLayer;
@property(readonly) CGFloat width, height;

- (id) initWithDataView:(DataView *) dataView;
- (void) blink;
- (void) clear;
- (CGContextRef) context;
- (void) paintCircleWithRadius:(CGFloat) radius atX:(CGFloat) x andY:(CGFloat) y;
- (void) renderInImage:(NSImage *) image;
- (NSImage *) renderInImage;
- (void) setNeedsDisplay;
- (void) setText:(NSString *) text;

@end
