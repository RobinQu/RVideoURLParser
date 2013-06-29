//
//  RVideoParser.h
//  RVideoURLParser
//
//  Created by Robin Qu on 13-6-28.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <Foundation/Foundation.h>


@class RVideoMeta;

@protocol RVideoParserStrategy <NSObject>

+ (BOOL)canHandleURL:(NSURL *)url;
- (void)parseURL:(NSURL *)url withCallback:(void(^)(NSError *error, RVideoMeta *meta))callback;

@end
