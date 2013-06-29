//
//  RVideoParser.m
//  RVideoURLParser
//
//  Created by Robin Qu on 13-6-29.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RTestCase.h"
#import "RVideoParser.h"

@interface RVideoParserTest : RTestCase

@end

@implementation RVideoParserTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}


- (void)testYouku
{
    __block BOOL done = NO;
    NSURL *url = [NSURL URLWithString:@"http://v.youku.com/v_show/id_XNTc2NjcxMDI4.html"];
    [[RVideoParser sharedVideoParser] parseWithURL:url callback:^(NSError *error, RVideoMeta *meta) {
        done = YES;
        XCTAssertNil(error, @"should have no error");
        XCTAssertNotNil(meta, @"should be truthy");
        XCTAssertNotNil(meta.swf, @"should have swf link");
        XCTAssertNotNil(meta.title, @"should have title");
        XCTAssertNotNil(meta.preview.absoluteString, @"should have preview image url");
        XCTAssertNotNil(meta.mobile.absoluteString, @"should have mobile video url");
        NSLog(@"meta %@", [meta digest]);

    }];
    [self waitWithTimeout:2.0 forSuccessInBlock:^BOOL{
        return done;
    }];
}

@end
