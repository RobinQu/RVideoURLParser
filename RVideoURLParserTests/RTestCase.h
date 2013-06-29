//
//  RTestCase.h
//  catworks
//
//  Created by Robin Qu on 13-6-20.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface RTestCase : XCTestCase


- (void)waitWithTimeout:(NSTimeInterval)timeout forSuccessInBlock:(BOOL(^)())block;


@end
