//
//  SettingViewController.m
//  Ixyb
//
//  Created by wangjianimac on 15/6/1.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "AboutUsViewController.h"

#import "MyFeedBackViewController.h"
#import "RequestURL.h"
#import "ServicePhoneTableViewCell.h"
#import "WebviewViewController.h"
#import "XYCellLine.h"
#import "XYTableView.h"
#import "XYUtil.h"

#define VIEW_TAG_ALEERT_WEICHAT 10170001
#define VIEW_TAG_ALEERT_PHONE 10170002
#define VIEW_TAG_LOAN_ALEERT_PHONE 10170003

@interface AboutUsViewController () <UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) XYTableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createNav];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initData {

    self.dataArray = @[
        @{
            @"setionTitle" : @"",
            @"rows" :
                @[ @{@"rowTitle" : XYBString(@"str_go_score", @"去评分"),
                     @"iconImg" : @"setting_version",
                     @"style" : @"feedback",
                     @"detail" : @""},

                   @{@"rowTitle" : XYBString(@"str_xyb_version", @"当前版本"),
                     @"style" : @"feedback",
                     @"iconImg" : @"currVersion",
                     @"detail" : [NSString stringWithFormat:@"V%@", [ToolUtil getAppVersion]]},

                   @{@"rowTitle" : XYBString(@"str_about_xyb", @"关于信用宝"),
                     @"style" : @"feedback",
                     @"iconImg" : @"setting_phone",
                     @"detail" : @""},

                   @{@"rowTitle" : XYBString(@"str_opinion_feedback", @"意见反馈"),
                     @"style" : @"feedback",
                     @"iconImg" : @"setting_feedback",
                     @"detail" : @""} ]
        }
    ];
}

/*!
 *  @author JiangJJ, 16-12-13 09:12:38
 *
 *  初始化
 */
- (void)createNav {
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
    self.navItem.title = XYBString(@"str_sidebar_about_us", @"关于我们");
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

    //TableView
    self.tableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 160)];
    headView.backgroundColor = COLOR_BG;
    self.tableView.tableHeaderView = headView;
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [headView addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView.mas_centerX);
        make.top.equalTo(@50);
    }];

    UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    logoLabel.text = XYBString(@"string_make_chinese_creditable", @"让中国人更有信用");
    logoLabel.textColor = COLOR_AUXILIARY_GREY;
    logoLabel.font = [UIFont systemFontOfSize:14.f];
    logoLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:logoLabel];

    [logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView.mas_centerX);
        make.top.equalTo(logoImageView.mas_bottom).offset(Margin_Length);
        make.width.equalTo(@200);
    }];

    UILabel *bttomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    bttomLabel.text = XYBString(@"str_make_chinese_xyb", @"信用宝金融信息服务(北京)有限公司版权所有©2015-2018");
    bttomLabel.textColor = COLOR_AUXILIARY_GREY;
    bttomLabel.font = TEXT_FONT_10;
    bttomLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bttomLabel];
    [bttomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.left.right.equalTo(self.view);
    }];
}

//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataArray count];
}

//指定每个分区中有多少行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.dataArray objectAtIndex:section] objectForKey:@"rows"] count];
}

//设置每行调用的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSDictionary *rowDic = [[[self.dataArray objectAtIndex:section] objectForKey:@"rows"] objectAtIndex:row];
    NSString *style = [rowDic objectForKey:@"style"];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    if (indexPath.row == 0) {
        UIView *splitView2 = [[UIView alloc] initWithFrame:CGRectZero];
        splitView2.backgroundColor = COLOR_LINE;
        [cell.contentView addSubview:splitView2];
        [splitView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(@(0));
            make.height.equalTo(@(0.4));
        }];
    }
    if ([style isEqualToString:@"feedback"]) {

        UILabel *mTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mTitleLabel.text = [rowDic objectForKey:@"rowTitle"];
        mTitleLabel.textColor = COLOR_MAIN_GREY;
        mTitleLabel.font = TEXT_FONT_16;
        [cell.contentView addSubview:mTitleLabel];
        [mTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.left.equalTo(@(Margin_Length));
        }];

        UIView *splitView2 = [[UIView alloc] initWithFrame:CGRectZero];
        splitView2.backgroundColor = COLOR_LINE;
        [cell.contentView addSubview:splitView2];
        [splitView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(@(0));
            make.height.equalTo(@(Line_Height));
        }];
        if (indexPath.row == 1) {
            UILabel *mContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            mContentLabel.text = [rowDic objectForKey:@"detail"];
            mContentLabel.textColor = COLOR_AUXILIARY_GREY;
            mContentLabel.font = TEXT_FONT_14;
            [cell.contentView addSubview:mContentLabel];
            [mContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(@0);
                make.right.equalTo(cell.contentView.mas_right).offset(-Margin_Length);
            }];
        } else {
            UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectZero];
            arrowImage.image = [UIImage imageNamed:@"cell_arrow"];
            [cell.contentView addSubview:arrowImage];
            [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.equalTo(cell.contentView.mas_right).offset(-Margin_Length);
            }];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *str_app_id = @"785078356";
    if (indexPath.row == 0) {

        //第一种方法  直接跳转
        NSString *str = [NSString string];
        if (IS_iOS7) {
            str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", str_app_id];
        } else {
            str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", str_app_id];
        }

        NSURL *aURL = [NSURL URLWithString:str];

        if ([[UIApplication sharedApplication] canOpenURL:aURL]) {
            [[UIApplication sharedApplication] openURL:aURL];
        }

        //第二中方法  应用内跳转
        //1:导入StoreKit.framework,控制器里面添加框架#import <StoreKit/StoreKit.h>
        //2:实现代理SKStoreProductViewControllerDelegate
        //SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
        //storeProductVC.delegate = self;
        //        ViewController *viewc = [[ViewController alloc]init];
        //        __weak typeof(viewc) weakViewController = viewc;

        //加载一个新的视图展示
        //[storeProductVC loadProductWithParameters:@{ SKStoreProductParameterITunesItemIdentifier : str_app_id } //appId
        //    completionBlock:^(BOOL result, NSError *error) {                              //回调
        //            if (error) {
        //                NSLog(@"错误%@", error);
        //            } else { //AS应用界面
        //                [self presentViewController:storeProductVC animated:YES completion:nil];
        //            }
        //                                  }];
    }

    if (indexPath.row == 2) {
        NSString *urlStr = [RequestURL getNodeJsH5URL:App_About_URL withIsSign:NO];
        NSString *titleStr = XYBString(@"str_about_xyb", @"关于信用宝");
        WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
        [self.navigationController pushViewController:webView animated:YES];
    }

    if (indexPath.row == 3) {
        MyFeedbackViewController *myFeedBackViewController = [[MyFeedbackViewController alloc] init];
        [self.navigationController pushViewController:myFeedBackViewController animated:YES];
    }
}

//里面的Label左对齐,比较恶心的方法,然而...无效
//- (void)willPresentAlertView:(UIAlertView *)alertView{
//    if (alertView.tag == VIEW_TAG_ALEERT_PHONE) {
//        for(UIView *view in alertView.subviews){
//            if([view isKindOfClass:[UILabel class]]){
//                UILabel *label = (UILabel*)view;
//                if([label.text hasPrefix:@"信用宝客服电话"]){
//                    label.textAlignment = NSTextAlignmentLeft;
//                }
//            }
//        }
//    }
//}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
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
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:XYBString(@"string_xyb_alert", @"提示")
                                                                    message:XYBString(@"str_notwx_alert", @"未安装微信客户端")
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:XYBString(@"str_ok", @"确定"), nil];

                [alertview show];
            }
        }
    } else if (alertView.tag == VIEW_TAG_ALEERT_PHONE) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000707663"]];
        }
    } else if (alertView.tag == VIEW_TAG_LOAN_ALEERT_PHONE) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-669-6060"]];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:XYBString(@"str_xyb_alert", @"提示") message:XYBString(@"str_notqq_alert", @"未安装QQ客户端") delegate:nil cancelButtonTitle:nil otherButtonTitles:XYBString(@"str_ok", @"确定"), nil];

    [alertview show];
}

//第二中方法 评分取消按钮监听
//- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    NSLog(@"评分取消");
//}

@end
