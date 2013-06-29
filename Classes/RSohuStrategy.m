//
//  RSohuStrategy.m
//  RVideoURLParser
//
//  Created by Robin Qu on 13-6-29.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RSohuStrategy.h"
#import "RVideoURLParserCommon.h"
#import "RVideoMeta.h"
#import <AFNetworking/AFHTTPRequestOperation.h>


static NSRegularExpression *TitleRegex = nil;
static NSRegularExpression *DescriptionRegex = nil;
static NSRegularExpression *VIDRegex = nil;
static NSRegularExpression *TotalTimeRegex = nil;
static NSRegularExpression *PreviewRegex = nil;

static NSString *const SohuVideoM3U8URL = @"http://hot.vrs.sohu.com/ipad%@.m3u8";
static NSString *const SohuVideoSWFURL = @"http://share.vrs.sohu.com/%@/v.swf&autoplay=false";

//搜狐这个心真麻烦，没有接口拿vid，需要抓视频页面
@implementation RSohuStrategy

+ (BOOL)canHandleURL:(NSURL *)url
{
    return [url.absoluteString rangeOfString:@"sohu.com"].location != NSNotFound;
}

+ (void)initialize
{
    //setup regex objects
    TitleRegex = [NSRegularExpression regularExpressionWithPattern:@"<title>(.+)</title>" options:0 error:nil];
    DescriptionRegex = [NSRegularExpression regularExpressionWithPattern:@"name=\"description\" content=\"(.+)\"" options:0 error:nil];
    VIDRegex = [NSRegularExpression regularExpressionWithPattern:@"var vid=\"(\\d+)\"" options:0 error:nil];
    TotalTimeRegex = [NSRegularExpression regularExpressionWithPattern:@"var playTime=\"(.+)\"" options:0 error:nil];
    PreviewRegex = [NSRegularExpression regularExpressionWithPattern:@"\"og:image\" content=\"(.+)\"" options:0 error:nil];
}

//http://tv.sohu.com/20130420/n373357063.shtml
//http://hot.vrs.sohu.com/ipad1100078.m3u8
//http://hot.vrs.sohu.com/ipad1100078_4583713382573_4311399.m3u8?_=1372492250461&suv=1306291518560146
- (void)parseURL:(NSURL *)url withCallback:(void (^)(NSError *, RVideoMeta *))callback
{
    //send request asa  PC client because we need thoese meta header in html of PC version;
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:20];
    [urlRequest setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        RVideoMeta *meta = [self parseMetaFromHTMLString:operation.responseData];
        if (meta) {
            if (callback) {
                callback(nil, meta);
            }
        } else {
            if (callback) {
                callback([NSError errorWithDomain:kDefaultErrorDomain code:kVideoParserParsingErrorCode userInfo:@{@"url":url}], nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback(error, nil);
        }
    }];
    [operation start];
}

- (RVideoMeta *)parseMetaFromHTMLString:(NSData *)htmlData
{
    if (!htmlData || !htmlData.length) {
        return nil;
    }
    RVideoMeta *meta = [RVideoMeta new];
    //Sohu is using GBK!
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *source = [[NSString alloc] initWithData:htmlData encoding:gbkEncoding];
    NSUInteger searchEndPos = [source rangeOfString:@"<body>"].location;
    NSString *html = [source substringToIndex:searchEndPos];
    NSString *vid = [self grepString:html usingRegex:VIDRegex];
    if (!vid || !vid.length) {
        return nil;
    }
    meta.mobile = [NSURL URLWithString:[NSString stringWithFormat:SohuVideoM3U8URL, vid]];
    meta.title = [self grepString:html usingRegex:TitleRegex];
    meta.description = [self grepString:html usingRegex:DescriptionRegex];
    meta.duration = [NSNumber numberWithFloat:[[self grepString:html usingRegex:TotalTimeRegex] floatValue]];
    meta.swf = [NSURL URLWithString:[NSString stringWithFormat:SohuVideoSWFURL, vid]];
    meta.preview = [NSURL URLWithString:[self grepString:html usingRegex:PreviewRegex]];
    return meta;
}

- (NSString *)grepString:(NSString *)source usingRegex:(NSRegularExpression *)regex
{
    if (!source || !source.length) {
        return nil;
    }
    NSAssert(regex, @"must have valid regex object");
    NSArray *results = [regex matchesInString:source options:0 range:NSMakeRange(0, source.length)];
    if (results.count) {
        NSTextCheckingResult *result = [results objectAtIndex:0];
        if (result.numberOfRanges) {
            NSString *match = [source substringWithRange:[result rangeAtIndex:1]];
            if (match && match.length) {
                return match;
            }
        }
    }
    return nil;
}

@end
