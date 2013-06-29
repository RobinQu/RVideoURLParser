//
//  RYoukuStrategy.m
//  RVideoURLParser
//
//  Created by Robin Qu on 13-6-28.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RYoukuStrategy.h"
#import "RVideoURLParserCommon.h"
#import <AFNetworking/AFJSONRequestOperation.h>
#import "RVideoMeta.h"

static NSString *const YoukuVideoInfoURL = @"http://v.youku.com/player/getPlayList/VideoIDS/%@/timezone/+08/version/5/source/out?password=&ran=2513&n=3";
static NSString *const YoukuVideoSWFURL = @"http://player.youku.com/player.php/sid/%@/v.swf";
static NSString *const YoukuVideoM3U8URL = @"http://v.youku.com/player/getRealM3U8/vid/%@/type/mp4/v.m3u8";

@implementation RYoukuStrategy


static NSRegularExpression *urlRegex;

+ (void)initialize
{
    urlRegex = [[NSRegularExpression alloc] initWithPattern:@"youku.com" options:0 error:nil];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
}

+ (BOOL)canHandleURL:(NSURL *)url
{
    return [url.absoluteString rangeOfString:@"youku.com"].location != NSNotFound;
}

//http://v.youku.com/player/getRealM3U8/vid/XNTQ5ODExNzYw/type/mp4/v.m3u8
- (void)parseURL:(NSURL *)url withCallback:(VideoParserCallback)callback
{
    static NSRegularExpression *vidRegex = nil;
    if (!vidRegex) {
        vidRegex = [NSRegularExpression regularExpressionWithPattern:@"id_(\\w+)" options:0 error:nil];
    }
    NSArray *results = [vidRegex matchesInString:url.absoluteString options:0 range:NSMakeRange(0, url.absoluteString.length)];
    if (results.count) {
        NSTextCheckingResult *match = [results objectAtIndex:0];
        if (match.numberOfRanges) {
            NSString *vid = [url.absoluteString substringWithRange:[match rangeAtIndex:1]];
            [self requestVideoMeta:vid callback:callback];
            return;
        }
    }
    if (callback) {
        callback([NSError errorWithDomain:kDefaultErrorDomain code:kVideoParserParsingErrorCode userInfo:@{@"url":url}], nil);
    }
}

- (void)requestVideoMeta:(NSString *)vid callback:(VideoParserCallback)callback
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:YoukuVideoInfoURL, vid]];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10000];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *data = [JSON valueForKey:@"data"];
        if (data && data.count) {
            NSDictionary *dataObj = [data objectAtIndex:0];
            NSString *title = [dataObj valueForKey:@"title"];
            NSString *preview = [dataObj valueForKey:@"logo"];
            RVideoMeta *meta = [RVideoMeta new];
            meta.preview = [NSURL URLWithString:preview];
            meta.title = title;
            meta.swf = [NSURL URLWithString:[NSString stringWithFormat:YoukuVideoSWFURL, vid]];
            meta.mobile = [NSURL URLWithString:[NSString stringWithFormat:YoukuVideoM3U8URL, vid]];
            meta.duration = [NSNumber numberWithFloat:[[dataObj valueForKey:@"seconds"] floatValue]];
            if (callback) {
                callback(nil, meta);
            }
            return;
        }
        if (callback) {
            callback([NSError errorWithDomain:kDefaultErrorDomain code:kVideoParserParsingErrorCode userInfo:JSON], nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (callback) {
            callback(error, nil);
        }
    }];
    [operation start];
}

@end