//
//  Record.m
//  viz
//
//  Created by Jared Flatow on 3/1/09.
//  Copyright 2009 Jared Flatow. All rights reserved.
//

#import "Record.h"

@implementation Record

static NSUInteger BUFFER_SIZE = 1 << 10;

@synthesize fields;

+ (void) initialize {
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"\n", @"RecordSeparator", @"\t", @"FieldSeparator", nil];
    [defaults registerDefaults:appDefaults];
}

+ (Record *) nextRecordFromFileHandle:(NSFileHandle *) fileHandle {
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    NSString *recordSeparator = [defaults stringForKey:@"RecordSeparator"];
    NSString *fieldSeparator  = [defaults stringForKey:@"FieldSeparator"];
    NSMutableString *string   = [NSMutableString stringWithCapacity:BUFFER_SIZE];
    NSData *data;
    NSUInteger end;
    while ([data = [fileHandle readDataOfLength:BUFFER_SIZE] length]) {
        [string appendString:[[NSString alloc] initWithBytes:[data bytes]
                                                      length:[data length]
                                                    encoding:NSUTF8StringEncoding]];
        end = [string rangeOfString:recordSeparator].location;
        if (end == NSNotFound)
            continue;
        [fileHandle seekToFileOffset:[fileHandle offsetInFile] - ([string length] - end) + 1];
        return [Record recordWithFields:[[string substringToIndex:end] componentsSeparatedByString:fieldSeparator]];
    }
    if ([string length])
        return [Record recordWithFields:[string componentsSeparatedByString:fieldSeparator]];
    return nil;
}

+ (Record *) recordWithFields:(NSArray *) theFields {
    Record *record = [[Record alloc] init];
    [record setFields:theFields];
    return record;
}

- (void) paintInContext:(CGContextRef) context {
    float value = [[[self fields] objectAtIndex:5] floatValue];
    value       = value * value;
    
    CGContextSetRGBFillColor(context, 0, 0, 1, .2);
    CGContextSetRGBStrokeColor(context, 1, 0, 0, .2);
    CGContextBeginPath(context);
    CGContextAddArc(context, value, value, value, 0, 2 * M_PI, false);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
