//
//  WebScriptRecordPainter.h
//  viz
//
//  Created by Jared Flatow on 4/13/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Webkit/WebKit.h>

#import "RecordPainter.h"


@interface WebScriptRecordPainter : RecordPainter {
    WebScriptObject *webScriptObject;
    NSString *paintRecordFunction;
}

@end
