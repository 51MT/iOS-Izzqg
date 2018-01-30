//
//  RiskEvaluatingViewController.m
//  Ixyb
//
//  Created by 董镇华 on 16/9/28.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "RiskEvaluatingViewController.h"
#import "Utility.h"

@interface RiskEvaluatingViewController ()

@property (nonatomic, copy) NSString *nextStr; //记录第一题时NSRequestUrl的next的值
@property (nonatomic, assign) BOOL isTest;     //记录用户是否完成测评（出现测评结果页才表示用户完成测评）

@end

@implementation RiskEvaluatingViewController

- (void)clickBackBtn:(id)sender {

    if (_isTest == YES) {
        if (self.clickRefresh) {
            self.clickRefresh();
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if ([self.webView canGoBack]) {
        self.closeBtn.hidden = NO;
        if ([_nextStr isEqualToString:@"0"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:XYBString(@"str_common_sureStopRiskTest",@"本次风险测评未完成，终止将不保存当前进度，确定终止？") delegate:self cancelButtonTitle:XYBString(@"str_common_riskTestContinue",@"继续评估") otherButtonTitles:XYBString(@"str_common_riskTestStop",@"终止"), nil];
            alertView.tag = 500;
            [alertView show];
            
        } else {
            [self.webView goBack];
        }
        return;
    }

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickCloseBtn:(id)sender {

    if (![self.webView canGoBack]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:XYBString(@"str_common_sureStopRiskTest",@"本次风险测评未完成，终止将不保存当前进度，确定终止？") delegate:self cancelButtonTitle:XYBString(@"str_common_riskTestContinue",@"继续评估") otherButtonTitles:XYBString(@"str_common_riskTestStop",@"终止"), nil];
    alertView.tag = 600;
    [alertView show];
}

#pragma mark - alertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 500 && buttonIndex == 1) {
        [self.webView goBack];
    } else if (alertView.tag == 600 && buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (id)initWithTitle:(NSString *)title webUrlString:(NSString *)webUrlString {
    self = [super init];
    if (self) {
        self.navItem.title = title;
        self.urlStr = webUrlString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //设置标题
    NSString *documentTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navItem.title = [NSString stringWithFormat:@"%@", documentTitle];
}

// 网页中的每一个请求都会被触发
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/evaluatingDone"]) {
        [self synchronizeTheTestState:YES];
        _isTest = YES;
        self.closeBtn.hidden = YES;
        return NO;
    }

    _isTest = NO;
    BOOL isContaint = [request.mainDocumentURL.query containsString:@"next=0"];
    if (isContaint) {
        _nextStr = @"0";
    } else {
        _nextStr = @"1";
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    if (error.code == -1009) {
        [self showPromptTip:XYBString(@"str_common_network_error",@"网络连接不可用，请检查")];
    }
}

/**
 *  缓存是否测评的字段
 *
 *  @param isEvaluation 是否测评
 */
- (void)synchronizeTheTestState:(BOOL)isEvaluation {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:isEvaluation forKey:@"isEvaluation"];
    [userDefault synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
