//
//  RVideoParser.h
//  RVideoURLParser
//
//  Created by Robin Qu on 13-6-28.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RVideoParserStrategy.h"
#import "RVideoURLParserCommon.h"

@class RVideoMeta;

@interface RVideoParser : NSObject

+ (id)sharedVideoParser;

- (id)initWithStrategies:(NSSet *)strategies;
- (void)addStrategy:(RVideoParserStrategy*)strategy;
- (void)parseWithURL:(NSURL *)url callback:(VideoParserCallback)callback;

@end