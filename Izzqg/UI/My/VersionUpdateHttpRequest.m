//
//  VersionUpdateHttpRequest.m
//  Ixyb
//
//  Created by wang on 16/4/29.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "VersionUpdateHttpRequest.h"

#import "DMUpdateInfo.h"
#import "MJExtension.h"
#import "UpdateView.h"
#import "Utility.h"
#import "WebService.h"

@implementation VersionUpdateHttpRequest

static VersionUpdateHttpRequest *_http = nil;

+ (VersionUpdateHttpRequest *)getRequest {

    if (_http) {
        [_http setRequest];
        return _http;
    } else {
        _http = [[VersionUpdateHttpRequest alloc] init];

        [_http setRequest];
    }
    return _http;
}

- (BOOL)canShowNewHandView {

    if ([Utility shareInstance].isLogin) {
        return NO;
    }

    if (![[UserDefaultsUtil getIsAlreadyLogin] isEqualToString:@"0"]) {
        return NO;
    }
    return YES;
}

- (void)setRequest {
    NSString *requestURL = [RequestURL getRequestURL:VersionUpdateURL param:[NSDictionary dictionary]];
    [WebService postRequest:requestURL param:[NSDictionary dictionary] JSONModelClass:[DMUpdateInfo class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DMUpdateInfo *responseModel = responseObject;
        if (responseModel.resultCode == 1) {
            UpdateView *updateView = [[UpdateView alloc] init];
            updateView.updateInfo = responseModel.version;

            [updateView show:nil];
        }
    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            if ([self canShowNewHandView]) {
            }
        }];
}

- (void)clearInstance {

    if (_http) {
        _http = nil;
    }
}

@end
