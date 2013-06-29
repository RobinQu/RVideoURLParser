//
//  RTestCase.m
//  catworks
//
//  Created by Robin Qu on 13-6-20.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RTestCase.h"

@implementation RTestCase


- (dispatch_queue_t)serialQueue
{
    static dispatch_queue_t serialQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serialQueue = dispatch_queue_create("SenTestCase.serialQueue", DISPATCH_QUEUE_SERIAL);
    });
    return serialQueue;
}


// new version based on GHUnit
- (void)waitWithTimeout:(NSTimeInterval)timeout forSuccessInBlock:(BOOL(^)())block
{
    BOOL(^serialBlock)() = ^BOOL{
        __block BOOL result;
        dispatch_sync(self.serialQueue, ^{
            result = block();
        });
        return result;
    };
    NSArray *_runLoopModes = [NSArray arrayWithObjects:NSDefaultRunLoopMode, NSRunLoopCommonModes, nil];
    
    NSTimeInterval checkEveryInterval = 0.2;
    NSDate *runUntilDate = [NSDate dateWithTimeIntervalSinceNow:timeout];
    NSInteger runIndex = 0;
    while(! serialBlock()) {
        NSString *mode = [_runLoopModes objectAtIndex:(runIndex++ % [_runLoopModes count])];
        
        @autoreleasepool {
            if (!mode || ![[NSRunLoop currentRunLoop] runMode:mode beforeDate:[NSDate dateWithTimeIntervalSinceNow:checkEveryInterval]]) {
                // If there were no run loop sources or timers then we should sleep for the interval
                [NSThread sleepForTimeInterval:checkEveryInterval];
            }
        }
        
        // If current date is after the run until date
        if ([runUntilDate compare:[NSDate date]] == NSOrderedAscending) {
            break;
        }
    }
}


@end
