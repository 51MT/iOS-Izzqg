//
//  CGAccounWebViewController.h
//  Ixyb
//
//  Created by wang on 2017/12/21.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "XYWebViewController.h"

@interface CGAccounWebViewController : XYWebViewController

/**
 自定义初始化方法

 @param params 传入字典，且字典中必须包含baseURL的键值对
 @return self
 */
- (instancetype)initWithParams:(NSDictionary *)params;

@end
