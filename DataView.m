//
//  DataView.m
//  viz
//
//  Created by Jared Flatow on 3/4/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import "DataView.h"

@implementation DataView

- (void) awakeFromNib {
    CALayer *rootLayer;
    CGColorRef bgColor = CGColorCreateGenericRGB(1., 1., 1., .9);
    [[self window] setContentAspectRatio:NSMakeSize(1, 1)];
    [self setWantsLayer:YES];
    rootLayer = [self layer];
    [rootLayer setDelegate:self];
    [rootLayer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
    [rootLayer setBackgroundColor:bgColor];
    [rootLayer setNeedsDisplay];
    CGColorRelease(bgColor);
}

- (void) addLayer:(CALayer *) layer {
    [layer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX
                                                    relativeTo:@"superlayer"
                                                     attribute:kCAConstraintMinX]];
    [layer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX
                                                    relativeTo:@"superlayer"
                                                     attribute:kCAConstraintMaxX]];
    [layer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY
                                                    relativeTo:@"superlayer"
                                                     attribute:kCAConstraintMinY]];
    [layer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY
                                                    relativeTo:@"superlayer"
                                                     attribute:kCAConstraintMaxY]];
    [layer setFrame:[[self layer] frame]];
    [[self layer] addSublayer:layer];
}

- (BOOL) acceptsFirstResponder {
    return YES;
}

- (void) keyDown:(NSEvent *) theEvent {
    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
}

- (void) drawLayer:(CALayer *) layer inContext:(CGContextRef) context {
    // draw root layer
}

@end
