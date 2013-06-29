//
//  RTudouStrategy.m
//  RVideoURLParser
//
//  Created by Robin Qu on 13-6-29.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RTudouStrategy.h"
#import <AFNetworking/AFJSONRequestOperation.h>

#import "RVideoMeta.h"

static NSString *const TudouItemQueryAPI = @"http://api.tudou.com/v3/gw?method=item.info.get&appKey=%@&format=&itemCodes=%@";
static NSString *const TudouVideoSWFURL = @"http://www.tudou.com/v/%@/v.swf";
static NSString *const TudouVideoM3U8URL = @"http://vr.tudou.com/v2proxy/v2.m3u8?it=%@&st=2&pw=";

static NSString *apiKey = nil;

@implementation RTudouStrategy


+ (void)configureAPIKey:(NSString *)key
{
    apiKey = key;
}

+ (BOOL)canHandleURL:(NSURL *)url
{
    return [url.absoluteString rangeOfString:@"tudou.com"].location != NSNotFound;
}

//curl -v http://www.tudou.com/programs/view/s981A0L5yNw/ -H "User-Agent:Mozilla/5.0 (iPad; CPU OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B176 Safari/7534.48.3"
//http://api.tudou.com/v3/gw?method=item.info.get&appKey=93f1427674bd19db&format=&itemCodes=s981A0L5yNw
//http://www.tudou.com/programs/view/s981A0L5yNw/
//http://www.tudou.com/listplay/6vwJJRzeC2c/At0Z5vu08ZY.html
//http://www.tudou.com/albumplay/v3rsB9eAMRc.html
//http://vr.tudou.com/v2proxy/v2.m3u8?it=171228513&st=2&pw=
//http://i2.tdimg.com/171/228/513/w.jpg
- (void)parseURL:(NSURL *)url withCallback:(void (^)(NSError *, RVideoMeta *))callback
{
    NSAssert(apiKey, @"should have a valid API key");
    NSString *iCode = nil;
    NSRegularExpression *iCodeRegex = nil;
    if ([url.absoluteString rangeOfString:@"listplay"].location != NSNotFound) {
        iCodeRegex = [NSRegularExpression regularExpressionWithPattern:@"\\/(\\w+)\\.html" options:0 error:nil];
    } else if ([url.absoluteString rangeOfString:@"programs"].location != NSNotFound) {
        iCodeRegex = [NSRegularExpression regularExpressionWithPattern:@"view\\/(\\w+)" options:0 error:nil];
    } else if ([url.absoluteString rangeOfString:@"albumplay"].location != NSNotFound) {
//        iCodeRegex = [NSRegularExpression regularExpressionWithPattern:@"albumplay\\/(\\w+)\\.html" options:0 error:nil];
        if (callback) {
            callback([NSError errorWithDomain:kDefaultErrorDomain code:kVideoParserNotSupportedErrorCode userInfo:@{@"url":url}], nil);
        }
    }
    
    NSArray *results = [iCodeRegex matchesInString:url.absoluteString options:0 range:NSMakeRange(0, url.absoluteString.length)];
    
    if (results.count) {
        NSTextCheckingResult *result = [results objectAtIndex:0];
        if (result.numberOfRanges) {
            iCode = [url.absoluteString substringWithRange:[result rangeAtIndex:1]];
            [self requestVideoMeta:iCode callback:callback];
        }
        return;
    }
    
    if (callback) {
        callback([NSError errorWithDomain:kDefaultErrorDomain code:kVideoParserParsingErrorCode userInfo:@{@"url":url}], nil);
    }
}

- (void)requestVideoMeta:(NSString *)iCode callback:(VideoParserCallback)callback
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:TudouItemQueryAPI, apiKey, iCode]];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *results = [JSON valueForKeyPath:@"multiResult.results"];
        if (results && results.count) {
            RVideoMeta *meta = [RVideoMeta new];
            NSDictionary *data = [results objectAtIndex:0];
            meta.title = [data valueForKey:@"title"];
            meta.preview = [NSURL URLWithString:[data valueForKey:@"bigPicUrl"]];
            meta.description = [data valueForKey:@"description"];
            meta.swf = [NSURL URLWithString:[NSString stringWithFormat:TudouVideoSWFURL, iCode]];
            meta.mobile = [NSURL URLWithString:[NSString stringWithFormat:TudouVideoM3U8URL, [data valueForKey:@"itemId"]]];
            //totaltime is measured in ms; convert to seconds
            meta.duration = [NSNumber numberWithFloat:[[data valueForKey:@"totalTime"] floatValue]/1000];
            if (callback) {
                callback(nil, meta);
            }
            return;
        }
        if (callback) {
            callback([NSError errorWithDomain:kDefaultErrorDomain code:kVideoParserParsingErrorCode userInfo:nil], nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (callback) {
            callback(error, nil);
        }
    }];
    [operation start];
}

@end
