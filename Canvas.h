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
@property (assign) NSString *text;
@property (readonly) CGFloat width, height;

+ (NSArray *) objectToNSArray:(id) object;
- (id) initWithDataView:(DataView *) dataView;
- (void) blink;
- (void) clear;
- (CGContextRef) context;
- (NSView *) printView;
- (void) renderInImage:(NSImage *) image;
- (NSImage *) renderInImage;
- (void) setNeedsDisplay;

# pragma mark Painting Methods 
- (void) clearRectWithWidth:(CGFloat) width andHeight:(CGFloat) height atX:(CGFloat) x andY:(CGFloat) y;
- (void) fillRectWithWidth:(CGFloat) width andHeight:(CGFloat) height atX:(CGFloat) x andY:(CGFloat) y;
- (void) fillRects:(id) rectsObject;
- (void) paintArcWithRadius:(CGFloat) radius 
              andStartAngle:(CGFloat) startAngle 
                andEndAngle:(CGFloat) endAngle 
                        atX:(CGFloat) x 
                       andY:(CGFloat) y;
- (void) paintCircleWithRadius:(CGFloat) radius atX:(CGFloat) x andY:(CGFloat) y;
- (void) paintRectWithWidth:(CGFloat) width andHeight:(CGFloat) height atX:(CGFloat) x andY:(CGFloat) y;
- (void) restoreGState;
- (void) saveGState;
- (void) setFillColorR:(CGFloat) r G:(CGFloat) g B:(CGFloat) b A:(CGFloat) a;
- (void) setStrokeColorR:(CGFloat) r G:(CGFloat) g B:(CGFloat) b A:(CGFloat) a;
- (void) strokeRectWithWidth:(CGFloat) width andHeight:(CGFloat) height atX:(CGFloat) x andY:(CGFloat) y;

@end
