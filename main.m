//
//  main.m
//  viz
//
//  Created by Jared Flatow on 2/25/09.
//  Copyright Jared Flatow 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
    NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
	DebugLog(@"boolArg   = %d", [args boolForKey:@"boolArg"]);
    return NSApplicationMain(argc,  (const char **) argv);
}
