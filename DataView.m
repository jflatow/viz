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
    [self setWantsLayer:YES];
    rootLayer = [self layer];
    [rootLayer setDelegate:self];
    [rootLayer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
    [rootLayer setNeedsDisplay];
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

- (void) insertText:(id) text {
    [[[self window] delegate] insertText:text];
}

- (void) keyDown:(NSEvent *) theEvent {
    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
}

- (void) resizeTo:(NSSize) size {
    NSRect windowFrame  = [[self window] frame];
    NSRect frame        = [self frame];
    windowFrame.size    = NSMakeSize(size.width  + windowFrame.size.width  - frame.size.width,
                                     size.height + windowFrame.size.height - frame.size.height);
    [[self window] setFrame:windowFrame display:YES];
    [[self window] setContentAspectRatio:size];
}

@end
