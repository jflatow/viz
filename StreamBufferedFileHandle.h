//
//  StreamBufferedFileHandle.h
//  viz
//
//  Created by Jared Flatow on 4/15/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface StreamBufferedFileHandle : NSFileHandle {
    unsigned long long offsetInFile;
    NSFileHandle *wrappedFileHandle;
    NSMutableData *lastReadBuffer, *pushBackBuffer;
}

@end
