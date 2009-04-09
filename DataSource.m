//
//  DataSource.m
//  viz
//
//  Created by Jared Flatow on 3/2/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import "DataSource.h"
#import "DataView.h"
#import "RecordStream.h"
#import "RecordPainter.h"
#import "RecordStream.h"

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
    [recordStream setRecordPainter:[[RecordPainter alloc] initWithDataView:dataView]];
}

- (IBAction) gotoBeginning:(id) sender {
    [recordStream first];
}

- (IBAction) gotoEnd:(id) sender {
    [recordStream last];
}

- (IBAction) gotoRecord:(id) sender {
    [recordStream seekToIndex:[sender integerValue]];
}

- (IBAction) insertNewline:(id) sender {
    [recordStream next];
}

- (IBAction) moveBackward:(id) sender {
    [recordStream prev];
}

- (IBAction) moveUp:(id) sender {
    [recordStream prev];
}

- (IBAction) moveDown:(id) sender {
    [recordStream next];
}

- (IBAction) moveForward:(id) sender {
    [recordStream next];
}

- (IBAction) moveLeft:(id) sender {
    [recordStream reset];
}

- (IBAction) moveRight:(id) sender {
    [recordStream last];
}

- (IBAction) deleteBackward:(id) sender {
    [recordStream prev];
}

- (void) finalize {
    DebugLog(@"finalizing datasource", nil);
    [super finalize];
}

@end
