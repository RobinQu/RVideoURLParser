//
//  RTudouStrategy.h
//  RVideoURLParser
//
//  Created by Robin Qu on 13-6-29.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RVideoParserStrategy.h"
#import "RVideoURLParserCommon.h"

@interface RTudouStrategy : NSObject <RVideoParserStrategy>


+ (void)configureAPIKey:(NSString *)key;
- (void)parseURL:(NSURL *)url withCallback:(void (^)(NSError *, RVideoMeta *))callback;

@end
