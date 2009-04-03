//
//  Checkpoint.m
//  viz
//
//  Created by Jared Flatow on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Checkpoint.h"


CGLayerRef CopyCGLayer(CGLayerRef layerRef) {
    CGLayerRef layerRefCopy = CGLayerCreateWithContext(CGLayerGetContext(layerRef), CGLayerGetSize(layerRef), nil);
    CGContextDrawLayerAtPoint(CGLayerGetContext(layerRefCopy), CGPointZero, layerRef);
    return layerRefCopy;
}

@implementation Checkpoint

@synthesize offset, graphicsLayer;

- (Checkpoint *) initWithOffset:(NSUInteger) theOffset andGraphicsLayer:(CGLayerRef) theGraphicsLayer {
    if (self = [super init]) {
        offset = theOffset;
        graphicsLayer = CopyCGLayer(theGraphicsLayer);
    }
    return self;
}

- (void) dealloc {
    CGLayerRelease(graphicsLayer);
    [super dealloc];
}

@end
