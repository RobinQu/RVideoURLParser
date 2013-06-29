//
//  RVideoMeta.m
//  RVideoURLParser
//
//  Created by Robin Qu on 13-6-28.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RVideoMeta.h"

@implementation RVideoMeta

- (NSDictionary *)digest
{
    return @{@"title":self.title, @"preview":self.preview.absoluteString, @"swf":self.swf.absoluteString, @"mobile":self.mobile.absoluteString, @"duration": self.duration};
}

@end
