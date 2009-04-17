//
//  Canvas.m
//  viz
//
//  Created by Jared Flatow on 4/13/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import "Canvas.h"
#import "DataView.h"

@implementation Canvas

@synthesize dataView, graphicsLayer;

#pragma mark Class Initialization Methods

+ (void) initialize {
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"500", @"CanvasWidth",
                                 @"500", @"CanvasHeight", nil];
    [defaults registerDefaults:appDefaults];    
}

#pragma mark WebScripting Protocol Methods

+ (BOOL) isKeyExcludedFromWebScript:(const char *) name {
    return NO;
}

+ (BOOL) isSelectorExcludedFromWebScript:(SEL) aSelector {
    return NO;
}

- (id) invokeUndefinedMethodFromWebScript:(NSString *) name
                            withArguments:(NSArray *) args {
    DebugLog(@"No such method: %@", name);
    return false;
}

#pragma mark Interface Methods

- (id) initWithDataView:(DataView *) aDataView {
    if (self = [super init]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        canvasSize      = CGSizeMake([defaults floatForKey:@"CanvasWidth"], [defaults floatForKey:@"CanvasHeight"]);
        backgroundColor = CGColorCreateGenericRGB(1, 1, 1, 0.8);
        fontColor       = CGColorCreateGenericRGB(0.1, 0.1, 0.1, 1.0);
        animationLayer  = [CALayer layer];
        textLayer       = [CATextLayer layer];
        [textLayer setForegroundColor:fontColor];
        [textLayer setFontSize:12];
        [textLayer setAutoresizingMask:(kCALayerHeightSizable | kCALayerWidthSizable)];
        [animationLayer setBackgroundColor:backgroundColor];
        [animationLayer setDelegate:self];
        [animationLayer addSublayer:textLayer];
        [textLayer setFrame:[animationLayer frame]];
        [aDataView addLayer:animationLayer];
        [aDataView resizeTo:NSSizeFromCGSize(canvasSize)];
        [self setDataView:aDataView];
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
    [self setGraphicsLayer:CGLayerCreateWithContext(CGLayerGetContext(graphicsLayer), canvasSize, nil)];
    [self setText:@""];
    [self setNeedsDisplay];
}

- (CGContextRef) context {
    return CGLayerGetContext(graphicsLayer);
}

- (void) paintCircleWithRadius:(CGFloat) radius atX:(CGFloat) x andY:(CGFloat) y {
    CGContextRef context = [self context];
    CGContextBeginPath(context);
    CGContextAddArc(context, x, y, radius, 0, 2 * M_PI, false);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void) renderInImage:(NSImage *) image {
    [dataView lockFocus];
    NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:[dataView bounds]];
    [dataView unlockFocus];    
    CGContextRef imageContext = [[NSGraphicsContext graphicsContextWithBitmapImageRep:imageRep] graphicsPort];
    [animationLayer renderInContext:imageContext];
    [image addRepresentation:imageRep];
}

- (NSImage *) renderInImage {
    NSImage *image = [[NSImage alloc] initWithSize:[dataView bounds].size];
    [self renderInImage:image];
    return image;
}

- (void) setGraphicsLayer:(CGLayerRef) layer {
    CGLayerRelease(graphicsLayer);
    graphicsLayer = layer;
}

- (void) setNeedsDisplay {
    [animationLayer setNeedsDisplay];
}

- (void) setFillColorR:(CGFloat) r G:(CGFloat) g B:(CGFloat) b A:(CGFloat) a {
    CGContextSetRGBFillColor([self context], r, g, b, a);
}

- (void) setStrokeColorR:(CGFloat) r G:(CGFloat) g B:(CGFloat) b A:(CGFloat) a {
    CGContextSetRGBStrokeColor([self context], r, g, b, a);
}

- (void) setText:(NSString *) text {
    [textLayer setString:text];
}

- (CGFloat) width {
    return canvasSize.width;
}

- (CGFloat) height {
    return canvasSize.height;
}

#pragma mark CALayer Delegate Methods

- (void) drawLayer:(CALayer *) theLayer inContext:(CGContextRef) context {
    if (!graphicsLayer)
        [self setGraphicsLayer:CGLayerCreateWithContext(context, canvasSize, nil)];
    CGContextDrawLayerInRect(context, NSRectToCGRect([dataView bounds]), graphicsLayer);
}

#pragma mark Overridden NSObject Methods

- (void) dealloc {
    CGLayerRelease(graphicsLayer);
    CGColorRelease(backgroundColor);
    CGColorRelease(fontColor);
    [super dealloc];
}

@end
