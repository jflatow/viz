//
//  WebScriptRecordPainter.m
//  viz
//
//  Created by Jared Flatow on 4/13/09.
//  Copyright 2009 Jared Flato. All rights reserved.
//

#import "WebScriptRecordPainter.h"
#import "Canvas.h"
#import "Record.h"

@implementation WebScriptRecordPainter

+ (void) initialize {
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"function paintRecord(record, index, canvas) { canvas.setText_(index + '\\n' + record.fields.join('\\n'));}", 
                                 @"PaintRecordScript", 
                                 @"", @"PaintRecordScriptFile", nil];
    [defaults registerDefaults:appDefaults];
}

- (id) init {
    if (self = [super init]) {
        webScriptObject = [[[WebView alloc] init] windowScriptObject];
        NSUserDefaults *defaults        = [NSUserDefaults standardUserDefaults];
        NSString *paintRecordScript     = [defaults stringForKey:@"PaintRecordScript"];
        NSString *paintRecordScriptFile = [defaults stringForKey:@"PaintRecordScriptFile"];
        if (![paintRecordScriptFile isEqualToString:@""])
            paintRecordScript = [NSString stringWithContentsOfFile:paintRecordScriptFile encoding:NSUTF8StringEncoding error:NULL];
        DebugLog(@"Using PaintRecordScript: %@", paintRecordScript);
        [webScriptObject evaluateWebScript:paintRecordScript];
    }
    return self;
}

- (void) paintRecord:(Record *) record withIndex:(NSUInteger) index {
    NSArray *args = [NSArray arrayWithObjects:record, [NSNumber numberWithUnsignedInteger:index], canvas, nil];
    [webScriptObject callWebScriptMethod:@"paintRecord" withArguments:args];
    [canvas setNeedsDisplay];
}

@end
