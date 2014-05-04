//
//  RVideoParserStrategy.h
//  RVideoURLParser
//
//  Created by Robin Qu on 14-5-4.
//  Copyright (c) 2014年 Robin Qu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RVideoMeta.h"

@interface RVideoParserStrategy : NSObject

+ (BOOL)canHandleURL:(NSURL *)url;
+ (instancetype)sharedInstance;
- (void)parseURL:(NSURL *)url withCallback:(void(^)(NSError *error, RVideoMeta *meta))callback;


@end
