//
//  AFAppDotNetAPIClient.h
//  Ixyb
//
//  Created by wang on 15/8/18.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface AFAppDotNetAPIClient : AFHTTPSessionManager

@property (nonatomic, strong) UIAlertView *alert ;

+ (instancetype)sharedClient;

@end

