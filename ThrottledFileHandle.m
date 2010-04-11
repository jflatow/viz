//
//  ThrottledFileHandle.m
//  viz
//
//  Created by Jared Flatow on 4/15/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import "ThrottledFileHandle.h"

@implementation ThrottledFileHandle

+ (id) fileHandleForReadingAtPath:(NSString *) path {
    if ([path isEqualToString:@"/dev/stdin"]) {
        const char *template    = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"viz.XXXXXXXXXX"] UTF8String];
        char *templateCopy      = malloc(sizeof(char) * (strlen(template) + 1));
        int fd                  = mkstemp(strcpy(templateCopy, template));
        NSString *temporaryPath = [NSString stringWithUTF8String:templateCopy];
        free(templateCopy);
        return [[self alloc] initWithFileDescriptor:fd AndTemporaryPath:temporaryPath];
    }
    return [NSFileHandle fileHandleForReadingAtPath:path];
}

- (id) initWithFileDescriptor:(int) fd AndTemporaryPath:(NSString *) path {
    DebugLog(@"Writing standard input to %@", path);
    if (self = [super init]) {
        temporaryTask        = [[NSTask alloc] init];
        [temporaryTask setLaunchPath:@"/bin/cat"];
        [temporaryTask setArguments:[NSArray arrayWithObject:@"-"]];
        [temporaryTask setStandardOutput:[[NSFileHandle alloc] initWithFileDescriptor:fd 
                                                                       closeOnDealloc:YES]];
        [temporaryTask launch];
        temporaryPath = path;
        wrappedFileHandle = [NSFileHandle fileHandleForReadingAtPath:temporaryPath];
    }
    return self;
}

- (void) closeFile {
    [wrappedFileHandle closeFile];
    [temporaryTask terminate];
    [[NSFileManager defaultManager] removeItemAtPath:temporaryPath error:NULL];
}

- (unsigned long long) offsetInFile {
    return [wrappedFileHandle offsetInFile];
}

- (NSData *) readDataOfLength:(NSUInteger) length {
    return [wrappedFileHandle readDataOfLength:length];
}

- (void) seekToFileOffset:(unsigned long long) offset {
    return [wrappedFileHandle seekToFileOffset:offset];
}


@end
