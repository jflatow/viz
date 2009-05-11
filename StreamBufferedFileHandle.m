//
//  StreamBufferedFileHandle.m
//  viz
//
//  Created by Jared Flatow on 4/15/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import "StreamBufferedFileHandle.h"


@implementation StreamBufferedFileHandle

static NSUInteger BUFFER_SIZE = 1 << 16;

+ (id) fileHandleForReadingAtPath:(NSString *) path {
    if ([path isEqualToString:@"/dev/stdin"])
        return [[self alloc] init];
    return [NSFileHandle fileHandleForReadingAtPath:path];
}

- (id) init {
    DebugLog(@"Initializing file buffered input", nil);
    if (self = [super init]) {
        offsetInFile = 0;
        wrappedFileHandle = [NSFileHandle fileHandleWithStandardInput];
        lastReadBuffer    = [NSMutableData data];
        pushBackBuffer    = [NSMutableData data];
    }
    return self;
}

- (unsigned long long) offsetInFile {
    return offsetInFile;
}

- (void) closeFile {
    [wrappedFileHandle closeFile];
}

- (NSData *) readDataOfLength:(NSUInteger) length {
    NSMutableData *data = [NSMutableData dataWithData:pushBackBuffer];
    [data appendData:[wrappedFileHandle readDataOfLength:length - [data length]]];
    [pushBackBuffer setLength:0];
    offsetInFile += [data length];
    [lastReadBuffer setData:data];
    return data;
}

- (void) seekToFileOffset:(unsigned long long) offset {
    if (offset < offsetInFile) {
        unsigned long long offsetDiff = offsetInFile - offset;
        if (offsetDiff < [lastReadBuffer length]) {
            unsigned long long cutPoint = [lastReadBuffer length] - offsetDiff;
            [pushBackBuffer setData:[lastReadBuffer subdataWithRange:NSMakeRange(cutPoint, offsetDiff)]];
            [lastReadBuffer setLength:cutPoint];
            offsetInFile = offset;
            return;
        }
        return DebugLog(@"backward buffered seek to offset: %d from: %d goes beyond last read", offset, offsetInFile);
    }
    DebugLog(@"forward buffered seek to offset: %d from: %d", offset, offsetInFile);
    unsigned long long readLength;
    while (readLength = MIN(offset - offsetInFile, BUFFER_SIZE)) {
        if ([[self readDataOfLength:readLength] length] < readLength)
            @throw [NSException exceptionWithName:@"BufferedSeekException"
                                           reason:@"Attempted seek beyond EOF"
                                         userInfo:nil];
    }
}

@end
