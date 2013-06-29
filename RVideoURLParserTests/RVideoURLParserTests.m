//
//  RVideoURLParserTests.m
//  RVideoURLParserTests
//
//  Created by Robin Qu on 13-6-28.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface RVideoURLParserTests : XCTestCase

@end

@implementation RVideoURLParserTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testBasiscRegex
{
    NSString *expression = [NSRegularExpression escapedPatternForString:@"youku.com"];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:expression options:0 error:nil];
    NSString *urlString1 = @"http://v.youku.com/v_show/id_XMjI4MDM4NDc2.html";
    NSUInteger occurence1 = [regex numberOfMatchesInString:urlString1 options:0 range:NSMakeRange(0, urlString1.length)];
    XCTAssertTrue(occurence1>0, @"should find any occurence in url");
    NSString *urlString2 = @"http://google.com/test.html";
    NSUInteger occurence2 = [regex numberOfMatchesInString:urlString2 options:0 range:NSMakeRange(0, urlString2.length)];
    XCTAssertTrue(occurence2==0, @"should find none occurence in url");
    
}

- (void)testRegex1
{
    
}

@end
