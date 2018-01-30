//
//  LoanCustomerViewController.m
//  Ixyb
//
//  Created by wang on 16/8/24.
//  Copyright © 2016年 xyb. All rights reserved.
//
#import "LoanCustomerViewController.h"
#import "RandomUtil.h"
#import "Utility.h"
#import "XYCellLine.h"

#import "NTalkerChatViewController.h"
#import "XNGoodsInfoModel.h"

#define VIEW_TAG_ALEERT_WEICHAT 10170001
#define VIEW_TAG_LOAN_ALEERT_PHONE 10170003

@interface LoanCustomerViewController () <UIWebViewDelegate>

@end

@implementation LoanCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*!
 *  @author JiangJJ, 16-12-13 09:12:38
 *
 *  初始化
 */
- (void)createNav {
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
    self.navItem.title = XYBString(@"str_sidebar_loan_customer", @"借款客服");
    self.view.backgroundColor = COLOR_BG;
}

/*!
 *  @author JiangJJ, 16-12-13 10:12:16
 *
 *  返回
 */
- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initUI {
    UIView *viewHead = [[UIView alloc] init];
    viewHead.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:viewHead];
    [viewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@137);
        make.top.equalTo(self.navBar.mas_bottom).offset(Margin_Top);
        make.left.right.equalTo(self.view);
    }];
    [XYCellLine initWithTopLineAtSuperView:viewHead];
    [XYCellLine initWithBottomLineAtSuperView:viewHead];

    XYButton *kfQQ = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [viewHead addSubview:kfQQ];
    [kfQQ addTarget:self action:@selector(kfQQControl:) forControlEvents:UIControlEventTouchUpInside];
    [kfQQ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewHead.mas_top).offset(Line_Height);
        make.left.right.equalTo(@0);
        make.height.equalTo(@45);
    }];

    UILabel *lbaleKfQQ = [[UILabel alloc] init];
    lbaleKfQQ.text = XYBString(@"str_loan_kf_zx", @"在线客服");
    lbaleKfQQ.textColor = COLOR_MAIN_GREY;
    lbaleKfQQ.font = TEXT_FONT_16;
    [kfQQ addSubview:lbaleKfQQ];
    [lbaleKfQQ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kfQQ).offset(Margin_Length);
        make.centerY.equalTo(kfQQ.mas_centerY);
    }];

    UIImageView *imageArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    [kfQQ addSubview:imageArrow];
    [imageArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(kfQQ.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(kfQQ.mas_centerY);
    }];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR_LINE;
    [viewHead addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@45);
        make.left.equalTo(@Margin_Left);
        make.right.equalTo(viewHead.mas_right);
        make.height.equalTo(@(Line_Height));
    }];

    XYButton *kfPhone = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [viewHead addSubview:kfPhone];
    [kfPhone addTarget:self action:@selector(kfPhoneControl:) forControlEvents:UIControlEventTouchUpInside];
    [kfPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_top).offset(Line_Height);
        make.left.right.equalTo(@0);
        make.height.equalTo(@45);
    }];

    UILabel *lbaleKfPhone = [[UILabel alloc] init];
    lbaleKfPhone.text = XYBString(@"str_loan_kf_dh", @"客服电话");
    lbaleKfPhone.textColor = COLOR_MAIN_GREY;
    lbaleKfPhone.font = TEXT_FONT_16;
    [kfPhone addSubview:lbaleKfPhone];
    [lbaleKfPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kfPhone).offset(Margin_Length);
        make.centerY.equalTo(kfPhone.mas_centerY);
    }];

    UILabel *lbaleKfRihhtPhone = [[UILabel alloc] init];
    lbaleKfRihhtPhone.text = @"400-687-0880";
    lbaleKfRihhtPhone.textColor = COLOR_MAIN;
    lbaleKfRihhtPhone.font = TEXT_FONT_14;
    [kfPhone addSubview:lbaleKfRihhtPhone];
    [lbaleKfRihhtPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(kfPhone.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(kfPhone.mas_centerY);
    }];

    UIView *lineViewOne = [[UIView alloc] init];
    lineViewOne.backgroundColor = COLOR_LINE;
    [viewHead addSubview:lineViewOne];
    [lineViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_top).offset(45);
        make.left.equalTo(@Margin_Left);
        make.right.equalTo(viewHead.mas_right);
        make.height.equalTo(@(Line_Height));
    }];

    XYButton *wxPublicNumber = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [viewHead addSubview:wxPublicNumber];
    [wxPublicNumber addTarget:self action:@selector(wxPublicNumberControl:) forControlEvents:UIControlEventTouchUpInside];
    [wxPublicNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineViewOne.mas_top).offset(Line_Height);
        make.left.right.equalTo(@0);
        make.height.equalTo(@45.5);
    }];

    UILabel *lbalewxPublicNumber = [[UILabel alloc] init];
    lbalewxPublicNumber.text = XYBString(@"str_loan_wx", @"微信公众号");
    lbalewxPublicNumber.textColor = COLOR_MAIN_GREY;
    lbalewxPublicNumber.font = TEXT_FONT_16;
    [wxPublicNumber addSubview:lbalewxPublicNumber];
    [lbalewxPublicNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wxPublicNumber).offset(Margin_Length);
        make.centerY.equalTo(wxPublicNumber.mas_centerY);
    }];

    UILabel *lbaleRihhtNumber = [[UILabel alloc] init];
    lbaleRihhtNumber.text = XYBString(@"str_loan_xsd", @"信闪贷借款");
    lbaleRihhtNumber.textColor = COLOR_MAIN;
    lbaleRihhtNumber.font = TEXT_FONT_14;
    [wxPublicNumber addSubview:lbaleRihhtNumber];
    [lbaleRihhtNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wxPublicNumber.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(wxPublicNumber.mas_centerY);
    }];
}

/**
 *  客服QQ
 */
- (void)kfQQControl:(XYButton *)but {

    [self loadXiaoNengPage:@"kf_9482_1482133740349"];
    return;
}

/*!
 *  @author JiangJJ, 16-12-23 11:12:28
 *
 *  小能客服页面
 *
 */
- (void)loadXiaoNengPage:(NSString *)strSettingid {
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    NTalkerChatViewController *ctrl = [[NTalkerChatViewController alloc] init];
    ctrl.settingid = strSettingid;                  //【必填】客服组ID 一定要传入自己的
    ctrl.erpParams = @"www.xyb100.com";             //传值示例
    ctrl.pageTitle = @"iPhone";                     //传值示例
    ctrl.kefuId = @"";                              //传值示例
    ctrl.isSingle = @"-1";                          //传值示例
    ctrl.pageURLString = @"https://www.xyb100.com"; //传值示例
    ctrl.pushOrPresent = YES;
    ctrl.titleColor = [UIColor whiteColor];
    if (ctrl.pushOrPresent == YES) {
        [self.navigationController pushViewController:ctrl animated:YES];
    } else {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        ctrl.pushOrPresent = NO;
        [self presentViewController:nav animated:YES completion:nil];
    }
}


/**
 *  客服电话
 */
- (void)kfPhoneControl:(XYButton *)but {
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:XYBString(@"str_xyb_jk_tellphone", @"拨打电话: 400-687-0880")
                                                        message:XYBString(@"str_xyb_tel", @"(服务时间)\n 工作日 9:00-22:00 \n 节假日 9:00-18:00")
                                                       delegate:self
                                              cancelButtonTitle:XYBString(@"str_cancel", @"取消")
                                              otherButtonTitles:XYBString(@"str_dial", @"拨打"), nil];
    alertview.tag = VIEW_TAG_LOAN_ALEERT_PHONE;
    [alertview show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == VIEW_TAG_ALEERT_WEICHAT) {
        if (buttonIndex == 1) {
            //打开微信
            NSString *paramStr = [NSString stringWithFormat:@"weixin://"];
            NSURL *url = [NSURL URLWithString:[paramStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            } else {
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:XYBString(@"str_xyb_alert", @"提示")
                                                                    message:XYBString(@"str_notwx_alert", @"未安装微信客户端")
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:XYBString(@"str_ok", @"确定"), nil];

                [alertview show];
            }
        }
    } else if (alertView.tag == VIEW_TAG_LOAN_ALEERT_PHONE) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-687-0880"]];
        }
    }
}

/**
 *  微信公众号
 */
- (void)wxPublicNumberControl:(XYButton *)but {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"信闪贷借款";
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:XYBString(@"str_xyb_alert", @"提示")
                                                        message:XYBString(@"str_xsd_wx_tip", @"公众号已复制到粘贴板，您可以微信-通讯录-搜索框粘贴“信闪贷借款”公众号，点击关注即可。")
                                                       delegate:self
                                              cancelButtonTitle:XYBString(@"str_cancel", @"取消")
                                              otherButtonTitles:XYBString(@"str_to_follow", @"去关注"), nil];
    alertview.tag = VIEW_TAG_ALEERT_WEICHAT;
    [alertview show];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:XYBString(@"str_xyb_alert", @"提示") message:XYBString(@"str_notqq_alert", @"未安装QQ客户端") delegate:nil cancelButtonTitle:nil otherButtonTitles:XYBString(@"str_ok", @"确定"), nil];

    [alertview show];
}

@end
