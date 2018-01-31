//
//  VipWebViewController.m
//  Ixyb
//
//  Created by dengjian on 2017/1/9.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "VipWebViewController.h"
#import "RequestURL.h"
#import "Utility.h"
#import "WebviewViewController.h"

@interface VipWebViewController ()

@end

@implementation VipWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
}

- (void)setNav {
    self.navItem.title = XYBString(@"str_xsdborrow_new_guide", @"新手任务");

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"question_mark"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"question_mark_ed"] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
    [button addTarget:self action:@selector(clickTheRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickTheRightBtn {
    NSString *urlStr = [RequestURL getNodeJsH5URL:VipRuleReqestURL withIsSign:NO];
    NSString *titleStr = XYBString(@"str_xsdborrow_taskRule", @"任务规则");
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
