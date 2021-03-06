//
//  ThrottledFileHandle.h
//  viz
//
//  Created by Jared Flatow on 4/15/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ThrottledFileHandle : NSFileHandle {
    NSFileHandle *wrappedFileHandle;
    NSString *temporaryPath;
    NSTask *temporaryTask;
}

- (id) initWithFileDescriptor:(int) fd AndTemporaryPath:(NSString *) path;

@end
