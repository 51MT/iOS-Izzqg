//
//  XYWebViewController.h
//  Ixyb
//
//  Created by wangjianimac on 16/11/1.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"

typedef enum {
    CgOpen  = 1, //存管开户
    JkOpen  = 2  //借款开户
} CgState;

@interface XYWebViewController : HiddenNavBarBaseViewController

@property (nonatomic, assign)CgState openType; 

@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) UIButton *closeBtn;//风险测评页面需要用到，so暴露此入口
@property (nonatomic, strong) UIWebView *webView;

- (id)initWithTitle:(NSString *)title webUrlString:(NSString *)webUrlString;

- (void)clickBackBtn:(id)sender;
- (void)clickCloseBtn:(id)sender;

@end
