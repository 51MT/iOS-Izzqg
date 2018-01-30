//
//  AFAppDotNetAPIClient.m
//  Ixyb
//
//  Created by wang on 15/8/18.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"
#import "VersionUpdateHttpRequest.h"
#import "Utility.h"

static NSString * const AFAppDotNetAPIBaseURLString = @"https://www.baidu.com/";
static BOOL isReachable = YES;
static AFAppDotNetAPIClient *_sharedClient = nil;

@implementation AFAppDotNetAPIClient

+ (instancetype)sharedClient {
    

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        [_sharedClient.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    if (!isReachable) {
                          [_sharedClient alertDismiss];
                        [VersionUpdateHttpRequest getRequest];
                    }
                    isReachable = YES;
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    if (!isReachable) {
                        [_sharedClient alertDismiss];
                        [VersionUpdateHttpRequest getRequest];
                    }
                    isReachable = YES;
                }
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                {
                    isReachable = NO;
                    _sharedClient.alert  = [[UIAlertView alloc] initWithTitle:nil message:@"网络异常,请检查网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
           
                    [_sharedClient.alert show];
//                    ALERT(@"网络异常,请检查网络连接");
                }
             
                    break;
                default:
                    break;
            }
        }];
        [_sharedClient.reachabilityManager startMonitoring];
    });
    
    return _sharedClient;
}

- (void)alertDismiss {
    if (_sharedClient) {
        UIAlertView  *a = _sharedClient.alert;
        [a dismissWithClickedButtonIndex:0 animated:YES];
    }

}

@end
