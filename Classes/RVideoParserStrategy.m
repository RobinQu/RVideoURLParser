//
//  RVideoParserStrategy.m
//  RVideoURLParser
//
//  Created by Robin Qu on 14-5-4.
//  Copyright (c) 2014年 Robin Qu. All rights reserved.
//

#import "RVideoParserStrategy.h"
#import <objc/runtime.h>

const char ASSOCIATION_KEY;

@implementation RVideoParserStrategy

+ (instancetype)sharedInstance
{
    id instance = objc_getAssociatedObject(self, &ASSOCIATION_KEY);

    if (instance) {
        return instance;
    }
    instance = [self new];
    objc_setAssociatedObject(self, &ASSOCIATION_KEY, instance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return instance;
}

+ (BOOL)canHandleURL:(NSURL *)url
{
    NSLog(@"should implement in subclass");
    return NO;
}

- (void)parseURL:(NSURL *)url withCallback:(void (^)(NSError *, RVideoMeta *))callback
{
    
}

@end
