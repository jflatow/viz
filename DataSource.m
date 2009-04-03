//
//  DataSource.m
//  viz
//
//  Created by Jared Flatow on 3/2/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource

@synthesize recordStream;

- (DataSource *) initWithPath:(NSString *) path {
  if (self = [super init])
    if (!(recordStream = [RecordStream recordStreamWithPath:path]))
      return nil;
  return self;
}

- (NSString *) windowNibName {
  return @"DataSource";
}

- (void) windowControllerWillLoadNib:(NSWindowController *) windowController {
    DebugLog(@"%@ nib loading", [windowController windowNibName]);
}

- (void) windowControllerDidLoadNib:(NSWindowController *) windowController {
    DebugLog(@"%@ nib loaded", [windowController windowNibName]);
    [dataView addLayer:[recordStream animationLayer]];
}
 
- (IBAction) moveUp:(id) sender {
  [recordStream blink];
  [recordStream less];
  [[recordStream animationLayer] setNeedsDisplay];
}

- (IBAction) moveDown:(id) sender {
  [recordStream blink];
  [recordStream more];
  [[recordStream animationLayer] setNeedsDisplay];
}

- (IBAction) moveLeft:(id) sender {
  [recordStream reset];
  [[recordStream animationLayer] setNeedsDisplay];
}

- (IBAction) moveRight:(id) sender {
    // Change this
  do
    [recordStream more]; 
  while ([recordStream currentRecord]);
  [[recordStream animationLayer] setNeedsDisplay];
}

- (void) finalize {
    DebugLog(@"finalizing datasource", nil);
    [super finalize];
}

@end
