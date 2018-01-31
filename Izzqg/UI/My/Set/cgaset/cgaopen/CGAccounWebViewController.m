//
//  CGAccounWebViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/21.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "CGAccounWebViewController.h"
#import "CgDepRegisterModel.h"
#import "Utility.h"
#import "RequestURLDefine.h"

@interface CGAccounWebViewController ()

@property (nonatomic,strong) NSMutableDictionary *param;

@end

@implementation CGAccounWebViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _param = [[NSMutableDictionary alloc] initWithDictionary:params];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //接口地址
    NSString *path = [_param objectForKey:@"baseURL"];
    
    [_param removeObjectForKey:@"baseURL"];
    
    //访问请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    if (_param.allKeys.count == 0) {
        return;
    }
    
    //签名
    NSString *signStr = [Utility withThesha:_param];
    [_param setValue:signStr forKey:@"sign"];
    
    //将参数进行拼接
    NSString *bodyStr = [[NSString alloc] init];
    NSArray *keyArr = [_param allKeys];
    
    //遍历参数，进行拼接
    for (int i = 0; i < keyArr.count; i++) {
        
        //移除baseURL
        NSString *key = [keyArr objectAtIndex:i];
        if ([key isEqualToString:@"baseURL"]) {
            continue;
        }
        
        //拼接key
        bodyStr = [bodyStr stringByAppendingString:key];
        bodyStr = [bodyStr stringByAppendingString:@"="];
        
        //拼接value
        NSString *valueStr = [_param objectForKey:[keyArr objectAtIndex:i]];
        bodyStr = [bodyStr stringByAppendingString:valueStr];
        
        //最后一个value不需要拼接&
        if (i != keyArr.count - 1) {
            bodyStr = [bodyStr stringByAppendingString:@"&"];
        }
    }
    
    //将拼接好的参数放入body中
    request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
