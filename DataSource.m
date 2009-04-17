//
//  DataSource.m
//  viz
//
//  Created by Jared Flatow on 3/2/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import "DataSource.h"
#import "Canvas.h"
#import "DataView.h"
#import "RecordStream.h"
#import "RecordPainter.h"
#import "RecordStream.h"

@implementation DataSource

static NSString *QuickTimeMovieType = @"com.apple.quicktime-movie";

@synthesize recordStream;

#pragma mark Interface Methods

- (id) initWithPath:(NSString *) path {
    if (self = [super init])
        if (!(recordStream = [[RecordStream alloc] initWithPath:path]))
            return nil;
    return self;
}

#pragma mark Delegated Methods

- (IBAction) copy:(id) sender {
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    NSArray *types = [NSArray arrayWithObject:NSStringPboardType];
    [pb declareTypes:types owner:self];
    [pb setString:[[recordStream canvas] text] forType:NSStringPboardType];
}

- (IBAction) cut:(id) sender {
    [self copy:sender];
    [[recordStream canvas] setText:@""];
}

- (void) insertText:(id) text {
    if ([text isEqualToString:@" "])
        [recordStream togglePlay];
    else if ([text isEqualToString:@"-"])
        [recordStream slowDown];
    else if ([text isEqualToString:@"+"])
        [recordStream speedUp];
}

- (IBAction) deleteBackward:(id) sender {
    [recordStream prev];
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

- (IBAction) moveForward:(id) sender {
    [recordStream next];
}

- (IBAction) moveLeft:(id) sender {
    [recordStream first];
}

- (IBAction) moveRight:(id) sender {
    [recordStream last];
}

- (IBAction) paste:(id) sender {
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    NSString *data = [pb stringForType:NSStringPboardType];
    if (data)
        [[recordStream canvas] setText:data];
}

- (IBAction) play:(id) sender {
    [recordStream play];
}

- (IBAction) stepBack:(id) sender {
    [recordStream prevFrame];
}

- (IBAction) stepForward:(id) sender {
    [recordStream nextFrame];
}

#pragma mark Overrides of NSDocument Methods

- (void) close {
    [recordStream close];
    [super close];
}

- (void) printShowingPrintPanel:(BOOL) showPanels {
    DebugLog(@"print document", nil);
    NSPrintOperation *op = [NSPrintOperation
                            printOperationWithView:[[recordStream canvas] printView]
                            printInfo:[self printInfo]];
    [op setShowPanels:showPanels];
    [self runModalPrintOperation:op
                        delegate:nil
                  didRunSelector:NULL
                     contextInfo:NULL];
}

- (NSString *) windowNibName {
    return @"DataSource";
}

- (void) windowControllerWillLoadNib:(NSWindowController *) windowController {
    DebugLog(@"%@ nib loading", [windowController windowNibName]);
}

- (void) windowControllerDidLoadNib:(NSWindowController *) windowController {
    [recordStream setCanvas:[[Canvas alloc] initWithDataView:dataView]];
}

- (NSArray *) writableTypesForSaveOperation:(NSSaveOperationType) saveOperation {
    return [NSArray arrayWithObject:QuickTimeMovieType];
}

- (BOOL) writeToURL:(NSURL *) absoluteURL ofType:(NSString *) typeName error:(NSError **) outError {
    if ([[NSWorkspace sharedWorkspace] type:QuickTimeMovieType conformsToType:typeName]) {
        QTMovie *movie = [[QTMovie alloc] initToWritableFile:[absoluteURL path] error:outError];
        if (!movie)
            return NO;
        NSImage *image;
        NSDictionary *attrs = [NSDictionary dictionaryWithObject:@"jpeg" forKey:QTAddImageCodecType];
        do {
            image = [[recordStream canvas] renderInImage];
            [movie addImage:image forDuration:QTMakeTime(1, [recordStream framesPerSecond]) withAttributes:attrs];
        } while ([recordStream nextFrame]);
        if ([movie updateMovieFile])
            return YES;
    }
    return NO;
}

@end
