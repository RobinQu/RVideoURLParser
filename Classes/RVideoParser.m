//
//  RVideoParser.m
//  RVideoURLParser
//
//  Created by Robin Qu on 13-6-28.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RVideoParser.h"
#import "RYoukuStrategy.h"
#import <objc/runtime.h>

@interface RVideoParser ()

@property (nonatomic, retain) NSMutableSet *strategies;

@end

@implementation RVideoParser

+ (id)sharedVideoParser
{
    static RVideoParser *parser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSSet *set = [NSSet setWithObjects:[RYoukuStrategy class], nil];
        parser = [[RVideoParser alloc] initWithStrategies:set];
    });
    return parser;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.strategies = [NSMutableSet set];
    }
    return self;
}

- (id)initWithStrategies:(NSSet *)strategies
{
    self = [self init];
    if (self) {
        [self.strategies setSet:strategies];
    }
    return self;
}

- (void)addStrategy:(id<RVideoParserStrategy>)strategy
{
    [self.strategies addObject:strategy];
}

- (id<RVideoParserStrategy>)findStrategyForURL:(NSURL *)url
{
    __block id<RVideoParserStrategy> strategy = nil;
    SEL checker = @selector(canHandleURL:);
    [self.strategies enumerateObjectsUsingBlock:^(Class StrategyClass, BOOL *stop) {
        BOOL canHandle = [StrategyClass respondsToSelector:checker ] && [StrategyClass performSelector:checker withObject:url];
        if (canHandle) {
            strategy = [StrategyClass new];
            *stop = YES;
        }
    }];
    return strategy;
}

- (void)parseWithURL:(NSURL *)url callback:(void (^)(NSError *, RVideoMeta *))callback
{
    id<RVideoParserStrategy> strategy = [self findStrategyForURL:url];
    [strategy parseURL:url withCallback:callback];
}

@end
