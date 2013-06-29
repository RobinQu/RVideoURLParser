//
//  RVideoMeta.h
//  RVideoURLParser
//
//  Created by Robin Qu on 13-6-28.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RVideoMeta : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSURL *preview;
@property (nonatomic, retain) NSURL *swf;
@property (nonatomic, retain) NSURL *mobile;
@property (nonatomic, retain) NSURL *link;

- (NSDictionary *)digest;

@end
