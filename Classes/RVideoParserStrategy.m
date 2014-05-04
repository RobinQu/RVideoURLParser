//
//  RVideoParserStrategy.m
//  RVideoURLParser
//
//  Created by Robin Qu on 14-5-4.
//  Copyright (c) 2014年 Robin Qu. All rights reserved.
//

#import "RVideoParserStrategy.h"

@implementation RVideoParserStrategy

+ (instancetype)sharedInstance
{
    static RVideoParserStrategy *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [RVideoParserStrategy new];
    });
    return instance;
}

+ (BOOL)canHandleURL:(NSURL *)url
{
    NSLog(@"should implement in subclass");
    return NO;
}

- (void)parseURL:(NSURL *)url withCallback:(void (^)(NSError *, int *))callback
{
    NSLog(@"should implement in subclass");
}

@end
