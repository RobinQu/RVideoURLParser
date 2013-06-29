//
//  RVideoURLParserCommon.h
//  RVideoURLParser
//
//  Created by Robin Qu on 13-6-28.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#ifndef RVideoURLParser_RVideoURLParserCommon_h
#define RVideoURLParser_RVideoURLParserCommon_h

#define kDefaultErrorDomain @"com.elfvision.VideoURLParser"
#define kVideoParserParsingErrorCode 1
#define kVideoParserRequestErrorCode 2
#define kVideoParserNotSupportedErrorCode 2

typedef void (^VideoParserCallback)(NSError *, RVideoMeta *);


#endif
