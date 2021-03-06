//
//  DataView.h
//  viz
//
//  Created by Jared Flatow on 3/4/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@class Canvas;

@interface DataView : NSView {
    Canvas *canvas;
}

@property Canvas *canvas;

- (void) addLayer:(CALayer *) layer;
- (void) resizeTo:(NSSize) size;

@end
