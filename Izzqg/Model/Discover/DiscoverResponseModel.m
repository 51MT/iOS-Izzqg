//
//  DiscoverResponseModel.m
//  Ixyb
//
//  Created by wang on 16/7/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "DiscoverResponseModel.h"

@implementation BannersModel

//linkUrl 以;分割,前面是分享,后面是点击
//分享abc 链接def
//分享空 链接def
//分享abc 链接空
//分享abc 链接abc
- (NSString *)shareLinkUrl {
    if (_linkUrl) {
        NSArray *array = [_linkUrl componentsSeparatedByString:@";"];
        if (array.count > 0) {
            return [array objectAtIndex:0];
        }
    }
    return @"";
}

- (NSString *)clickLinkUrl {
    if (_linkUrl) {
        NSArray *array = [_linkUrl componentsSeparatedByString:@";"];
        if (array.count > 1) {
            return [array objectAtIndex:1];
        } else {
            return [array objectAtIndex:0];
        }
    }
    return @"";
}

@end

@implementation LatestNewsModel

@end

@implementation DiscoverResponseModel

@end
