//
//  XYWebViewController.h
//  Ixyb
//
//  Created by wangjianimac on 16/11/1.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"

@interface XYWebViewController : HiddenNavBarBaseViewController

/**
 自定义初始化方法

 @param status 状态,1:表示从钱罐页面进入；2：从福利页面进入；3：从我的页面进入
 @return self
 */
- (id)initWithStatus:(int)status;

- (void)clickBackBtn:(id)sender;
- (void)clickCloseBtn:(id)sender;

@end
