//
//  DataView.m
//  viz
//
//  Created by Jared Flatow on 3/4/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import "DataView.h"

@implementation DataView

- (id) initWithFrame:(NSRect) frame {
    if (self = [super initWithFrame:frame]) 
        rootLayer = [CALayer layer];
    return self;
}

- (void) awakeFromNib {
    CGColorRef bgColor = CGColorCreateGenericRGB(1., 1., 1., .9);
    [[self window] setContentAspectRatio:NSMakeSize(1, 1)];
    [self setLayer:rootLayer];
    [self setWantsLayer:YES];
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
    [rootLayer addSublayer:layer];
    [layer setFrame:[rootLayer frame]];
    [layer setNeedsDisplay];
}


- (BOOL) acceptsFirstResponder {
    return YES;
}

- (void) keyDown:(NSEvent *) theEvent {
    // Arrow keys are associated with the numeric keypad
    if ([theEvent modifierFlags] & NSNumericPadKeyMask)
        [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
    else
        [[self nextResponder] keyDown:theEvent];
}

- (void) drawLayer:(CALayer *) layer inContext:(CGContextRef) context {
    // pass
}

@end
