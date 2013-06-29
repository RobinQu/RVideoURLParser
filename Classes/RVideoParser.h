//
//  RVideoParser.h
//  RVideoURLParser
//
//  Created by Robin Qu on 13-6-28.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RVideoMeta.h"
#import "RVideoParserStrategy.h"



@interface RVideoParser : NSObject

+ (id)sharedVideoParser;

- (id)initWithStrategies:(NSSet *)strategies;
- (void)addStrategy:(id<RVideoParserStrategy>)strategy;
- (void)parseWithURL:(NSURL *)url callback:(void(^)(NSError *error, RVideoMeta *meta))callback;

@end
