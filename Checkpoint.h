//
//  Checkpoint.h
//  viz
//
//  Created by Jared Flatow on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

CGLayerRef CopyCGLayer(CGLayerRef layerRef);

@interface Checkpoint : NSObject {
    NSUInteger offset;
    CGLayerRef graphicsLayer;
}

- (Checkpoint *) initWithOffset:(NSUInteger) theOffset andGraphicsLayer:(CGLayerRef) theGraphicsLayer;

@property NSUInteger offset;
@property CGLayerRef graphicsLayer;

@end
