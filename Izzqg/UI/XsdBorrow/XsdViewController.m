//
//  XsdViewController.m
//  Ixyb
//
//  Created by wang on 16/1/25.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "XsdViewController.h"

#import "AppDelegate.h"
#import "Utility.h"
#import "XYAlertView.h"
#import "InfoView.h"
#import "LoginFlowViewController.h"

#import "MJRefreshCustomGifHeader.h"
#import "RTLabel.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "XsdPageResponseModel.h"
#import "XsdQuickBorrowModel.h"
#import "XsdWebViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>

#define whiteBackView_Tag 1000
#define borrowBtn_Tag 1001

@interface XsdViewController () <RTLabelDelegate, UIWebViewDelegate,CLLocationManagerDelegate> {
    
    XYScrollView *mainScroll;
    XYButton *remaindBtn;           //借款逾期黄色提醒View
    UILabel *remaindLab;            //黄色提醒View上的文字
    UILabel *borrowAmountLab;       //最高可借额度
    UIView *greenLine;              //登录：绿线，未登录：灰线
    UILabel *totalLab;              //总额度
    UILabel *dayLab;                //日费用
    UIView *verticalLine;           //竖线
    RTLabel *loginLab;              //未登录时，提示登录的Label
    XYButton *improveAmountBtn;     //提额
    XYButton *quickBtn;             //1000元快速借款
    XsdPageResponseModel *xsdModel; //记录请求数据时模型
    UILabel *locationLab;           //启用定位，获取服务城市
    CLLocationManager *locationManager;
}

@end

@implementation XsdViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UMengAnalyticsUtil event:EVENT_XSDBORROW_IN];
    [UMengAnalyticsUtil beginLogPageView:NSStringFromClass([self class])];
    [self checkIsLogin];
    if ([Utility shareInstance].isLogin) {
        [self callXsdPageWebserviceWithLoading:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UMengAnalyticsUtil event:EVENT_XSDBORROW_OUT];
    [UMengAnalyticsUtil endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self createTheTopView];
    [self createTheBottomView];
    [self setupRefresh];
    
    if ([Utility shareInstance].isLogin) {
        [self callXsdPageWebserviceWithLoading:YES];
    }
}

#pragma mark - 创建UI

- (void)setNav {
    self.navItem.title = XYBString(@"str_common_xsd", @"信闪贷");
}

/**
 *  @brief 创建信闪贷默认页面的上半部分
 */
- (void)createTheTopView {
    
    mainScroll = [[XYScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:mainScroll];
    
    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
        make.width.equalTo(@(MainScreenWidth));
    }];
    
    //逾期提醒
    remaindBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [remaindBtn setBackgroundImage:[ColorUtil imageWithColor:COLOR_HOME_TEST] forState:UIControlStateNormal];
    [remaindBtn addTarget:self action:@selector(clickTheRemainBtn:) forControlEvents:UIControlEventTouchUpInside];
    remaindBtn.hidden = YES;
    [mainScroll addSubview:remaindBtn];
    
    [remaindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(0));
    }];
    
    remaindLab = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab.font = TEXT_FONT_14;
    remaindLab.textColor = COLOR_TRAD_RED;
    remaindLab.textAlignment = NSTextAlignmentLeft;
    remaindLab.text = XYBString(@"str_xsdborrow_haveZeroLoanShouldPayOff", @"你有0笔借款已逾期");
    [remaindBtn addSubview:remaindLab];
    
    [remaindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(remaindBtn.mas_left).offset(Margin_Length);
        make.right.equalTo(remaindBtn.mas_right).offset(-22);
        make.centerY.equalTo(remaindBtn.mas_centerY);
    }];
    
    UIImageView *redArrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homeNotify_Arrow"]];
    [remaindBtn addSubview:redArrowImg];
    
    [redArrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(remaindBtn.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(remaindBtn.mas_centerY);
    }];
    
    //最高可借额度
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 180)];
    backView.tag = whiteBackView_Tag;
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.top.equalTo(remaindBtn.mas_bottom);
        make.height.equalTo(@(180));
        make.width.equalTo(@(MainScreenWidth));
    }];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:backView.bounds];
    backView.layer.masksToBounds = NO;
    backView.layer.shadowColor = [UIColor blackColor].CGColor;
    backView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    backView.layer.shadowOpacity = 0.05f;
    backView.layer.shadowPath = shadowPath.CGPath;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = TEXT_FONT_14;
    titleLab.textColor = COLOR_AUXILIARY_GREY;
    titleLab.text = XYBString(@"str_xsdborrow_theHighestBorrowAmount", @"最高可借额度(元)");
    [backView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top).offset(35);
        make.centerX.equalTo(backView.mas_centerX);
    }];
    
    borrowAmountLab = [[UILabel alloc] initWithFrame:CGRectZero];
    borrowAmountLab.font = FONT_HUGE_VERY_50;
    borrowAmountLab.textColor = COLOR_MAIN_GREY;
    borrowAmountLab.text = XYBString(@"str_financing_zero", @"0.00");
    [backView addSubview:borrowAmountLab];
    
    [borrowAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleLab.mas_centerX);
        make.top.equalTo(titleLab.mas_bottom).offset(7);
    }];
    
    //提额按钮
    improveAmountBtn = [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_xsdborrow_improveBorrowAmount", @"提额") titleColor:COLOR_MAIN_GREY isUserInteractionEnabled:YES];
    [improveAmountBtn addTarget:self action:@selector(clickQuickBtn:) forControlEvents:UIControlEventTouchUpInside];
    improveAmountBtn.hidden = YES;
    improveAmountBtn.titleLabel.font = TEXT_FONT_12;
    improveAmountBtn.layer.cornerRadius = Corner_Radius;
    improveAmountBtn.layer.borderColor = COLOR_AUXILIARY_GREY.CGColor;
    improveAmountBtn.layer.borderWidth = Border_Width;
    [backView addSubview:improveAmountBtn];
    
    [improveAmountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(titleLab.mas_centerY);
        make.width.equalTo(@(46));
        make.height.equalTo(@(24));
    }];
    
    greenLine = [[UIView alloc] initWithFrame:CGRectZero];
    [backView addSubview:greenLine];
    
    [greenLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.height.equalTo(@(TabLine_Height));
        make.top.equalTo(backView.mas_top).offset(140);
    }];
    
    verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
    verticalLine.backgroundColor = COLOR_LINE;
    [backView addSubview:verticalLine];
    
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.width.equalTo(@(Line_Height));
        make.height.equalTo(@(16));
        make.bottom.equalTo(backView.mas_bottom).offset(-12);
    }];
    
    totalLab = [[UILabel alloc] initWithFrame:CGRectZero];
    totalLab.font = TEXT_FONT_12;
    totalLab.textColor = COLOR_AUXILIARY_GREY;
    totalLab.text = XYBString(@"str_xsdborrow_totalAmount_zero", @"总额度¥0.00");
    totalLab.textAlignment = NSTextAlignmentRight;
    [backView addSubview:totalLab];
    
    [totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(verticalLine.mas_left).offset(-Margin_Length);
        make.centerY.equalTo(verticalLine.mas_centerY);
        make.width.equalTo(@((MainScreenWidth - Line_Height - Margin_Length) / 2));
        make.height.equalTo(@(13));
    }];
    
    dayLab = [[UILabel alloc] initWithFrame:CGRectZero];
    dayLab.font = TEXT_FONT_12;
    dayLab.textColor = COLOR_AUXILIARY_GREY;
    dayLab.text = XYBString(@"str_xsdborrow_dayFee_zero", @"日费用低至0.00元");
    [backView addSubview:dayLab];
    
    [dayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLine.mas_right).offset(Margin_Length);
        make.centerY.equalTo(verticalLine.mas_centerY);
    }];
    
    [XYCellLine initWithBottomLineAtSuperView:backView];
    
    //添加一个RTLabel 提示登录
    loginLab = [[RTLabel alloc] init];
    loginLab.font = TEXT_FONT_12;
    loginLab.textColor = COLOR_AUXILIARY_GREY;
    loginLab.textAlignment = RTTextAlignmentCenter;
    NSString *str = XYBString(@"str_xsdborrow_pleaseLogin", @"提额或借款前，请<font color='#0ab0ef'><u color=clear><a href='login'>登录</a></u></font>信用宝");
    loginLab.text = str;
    loginLab.delegate = self;
    [backView addSubview:loginLab];
    
    [loginLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(verticalLine);
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@18);
    }];
}

/**
 *  @brief 创建信闪贷默认页面的下半部分
 */
- (void)createTheBottomView {
    
    XYButton *borrowBtn = [[XYButton alloc] initWithTitle:XYBString(@"str_xsdborrow_borrowMoney", @"借钱") btnType:ImportanceButton];
    [borrowBtn addTarget:self action:@selector(clickBorrowBtn:) forControlEvents:UIControlEventTouchUpInside];
    borrowBtn.tag = borrowBtn_Tag;
    [mainScroll addSubview:borrowBtn];
    
    UIView *backView = [self.view viewWithTag:whiteBackView_Tag];
    [borrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_bottom).offset(20);
        make.left.equalTo(mainScroll.mas_left).offset(Margin_Length);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
        make.width.equalTo(@(MainScreenWidth - 2 * Margin_Length));
        make.height.equalTo(@(Cell_Height));
    }];
    
    quickBtn = [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_xsdborrow_quicklyBorrow", @"1000元快速借款") titleColor:COLOR_MAIN_GREY isUserInteractionEnabled:YES];
    [quickBtn addTarget:self action:@selector(clickQuickBtn:) forControlEvents:UIControlEventTouchUpInside];
    quickBtn.layer.cornerRadius = Corner_Radius;
    quickBtn.layer.borderColor = COLOR_LIGHT_GREY.CGColor;
    quickBtn.layer.borderWidth = Border_Width;
    quickBtn.hidden = YES;
    [mainScroll addSubview:quickBtn];
    
    [quickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(borrowBtn.mas_bottom).offset(Margin_Length);
        make.left.equalTo(mainScroll.mas_left).offset(Margin_Length);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
        make.width.equalTo(@(MainScreenWidth - 2 * Margin_Length));
        make.height.equalTo(@(Cell_Height));
    }];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    bottomView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
        make.top.equalTo(quickBtn.mas_bottom).offset(20);
        make.height.equalTo(@(135));
    }];
    
    //我要还款
    XYButton *repayBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [repayBtn addTarget:self action:@selector(clickRepayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:repayBtn];
    
    [repayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(bottomView);
        make.height.equalTo(@(Cell_Height));
    }];
    
    UILabel *titleLab1 = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab1.font = TEXT_FONT_16;
    titleLab1.textColor = COLOR_MAIN_GREY;
    titleLab1.text = XYBString(@"str_xsdborrow_IWantToRepayTheLoad", @"我要还款");
    [repayBtn addSubview:titleLab1];
    
    [titleLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(repayBtn.mas_left).offset(Margin_Length);
        make.centerY.equalTo(repayBtn.mas_centerY);
    }];
    
    UIImageView *arrowImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    [repayBtn addSubview:arrowImage1];
    
    [arrowImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(repayBtn.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(repayBtn.mas_centerY);
    }];
    
    [XYCellLine initWithTopLineAtSuperView:repayBtn];
    [XYCellLine initWithBottomLine_2_AtSuperView:repayBtn];
    
    //借款记录
    XYButton *borrowRecordBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [borrowRecordBtn addTarget:self action:@selector(clickBorrowRecordBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:borrowRecordBtn];
    
    [borrowRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomView);
        make.top.equalTo(repayBtn.mas_bottom);
        make.height.equalTo(@(Cell_Height));
    }];
    
    UILabel *titleLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab2.font = TEXT_FONT_16;
    titleLab2.textColor = COLOR_MAIN_GREY;
    titleLab2.text = XYBString(@"str_xsdborrow_borrowRecord", @"借款记录");
    [borrowRecordBtn addSubview:titleLab2];
    
    [titleLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(borrowRecordBtn.mas_left).offset(Margin_Length);
        make.centerY.equalTo(borrowRecordBtn.mas_centerY);
    }];
    
    UIImageView *arrowImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    [borrowRecordBtn addSubview:arrowImage2];
    
    [arrowImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(borrowRecordBtn.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(borrowRecordBtn.mas_centerY);
    }];
    
    [XYCellLine initWithBottomLine_2_AtSuperView:borrowRecordBtn];
    
    //还款记录
    XYButton *repayRecordBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [repayRecordBtn addTarget:self action:@selector(clickRepayRecordBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:repayRecordBtn];
    
    [repayRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomView);
        make.top.equalTo(borrowRecordBtn.mas_bottom);
        make.height.equalTo(@(Cell_Height));
        make.bottom.equalTo(mainScroll.mas_bottom).offset(-Margin_Length);
    }];
    
    UILabel *titleLab3 = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab3.font = TEXT_FONT_16;
    titleLab3.textColor = COLOR_MAIN_GREY;
    titleLab3.text = XYBString(@"str_xsdborrow_repaymentRecord", @"还款记录");
    [repayRecordBtn addSubview:titleLab3];
    
    [titleLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(repayRecordBtn.mas_left).offset(Margin_Length);
        make.centerY.equalTo(repayRecordBtn.mas_centerY);
    }];
    
    UIImageView *arrowImage3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    [repayRecordBtn addSubview:arrowImage3];
    
    [arrowImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(repayRecordBtn.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(repayRecordBtn.mas_centerY);
    }];
    [XYCellLine initWithBottomLineAtSuperView:repayRecordBtn];
}


#pragma mark - 页面UI刷新
/**
 *  @brief 页面UI刷新
 *
 *  @param xsdModel 信闪贷页面模型
 */
- (void)reloadData:(XsdPageResponseModel *)model {
    if (model.data.overdueCount != 0) {
        remaindBtn.hidden = NO;
        [remaindBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(33));
        }];
        remaindLab.text = [NSString stringWithFormat:XYBString(@"str_xsdborrow_haveSomeLoanShouldPayOff", @"你有%zi笔借款已逾期"), model.data.overdueCount];
    } else {
        remaindBtn.hidden = YES;
        [remaindBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
    }
    
    if ([model.data.canGrant intValue] == 0) {
        improveAmountBtn.hidden = YES;
    } else if ([model.data.canGrant intValue] == 1) {
        improveAmountBtn.hidden = NO;
    }
    
    if ([model.data.showBtn intValue] == 1) {
        quickBtn.hidden = NO;
        improveAmountBtn.hidden = NO;
    } else {
        quickBtn.hidden = YES;
        improveAmountBtn.hidden = YES;
    }
    
    borrowAmountLab.text = [NSString stringWithFormat:@"%@", xsdModel.data.highCanBorrowAmount];
    totalLab.text = [NSString stringWithFormat:XYBString(@"str_xsdborrow_totalAmount_some", @"总额度¥%@"), xsdModel.data.totalAmount];
    dayLab.text = [NSString stringWithFormat:XYBString(@"str_xsdborrow_dayFee_some", @"日费用低至%@元"), xsdModel.data.dayFees];
}

#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    mainScroll.header = self.gifHeader2;
}

- (void)headerRereshing {
    if ([Utility shareInstance].isLogin) {
        [self callXsdPageWebserviceWithLoading:NO];
    }
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [mainScroll.header endRefreshing];
}

#pragma mark - 检测用户是否登录
/**
 检测用户是否登录
 */
- (void)checkIsLogin {
    XYButton *borrowBtn = (XYButton *) [mainScroll viewWithTag:borrowBtn_Tag];
    if ([Utility shareInstance].isLogin) {
        greenLine.backgroundColor = COLOR_LIGHT_GREEN;
        totalLab.hidden = NO;
        dayLab.hidden = NO;
        verticalLine.hidden = NO;
        loginLab.hidden = YES;
        borrowBtn.isEnabled = YES;
    } else {
        remaindBtn.hidden = YES;
        [remaindBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
        
        greenLine.backgroundColor = COLOR_LIGHT_GREY;
        totalLab.hidden = YES;
        dayLab.hidden = YES;
        verticalLine.hidden = YES;
        loginLab.hidden = NO;
        borrowBtn.isEnabled = NO;
        
        totalLab.text = XYBString(@"str_xsdborrow_totalAmount_zero", @"总额度¥0.00");
    }
}

#pragma mark - button点击事件

/**
 逾期提醒 点击事件
 
 @param sender 逾期提醒
 */
- (void)clickTheRemainBtn:(id)sender {
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:nil];
        return;
    }
    
    if (xsdModel.data.overdueRepaylistUrl != nil) {
        XsdWebViewController *webVC = [[XsdWebViewController alloc] initWithTitle:nil webUrlString:[NSString stringWithFormat:@"%@", xsdModel.data.overdueRepaylistUrl]];
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

/**
 提额按钮 和1000元快速借款按钮 点击事件
 
 @param sender 提额按钮  1000元快速借款按钮
 */
- (void)clickQuickBtn:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:XYBString(@"str_xsdborrow_loanXsdApp",@"请下载信闪贷APP，申请提额或1000元快速借款") preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:XYBString(@"str_xsdborrow_goToloan", @"去下载") style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
                                                          
                                                          NSURL *downloadURL = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1218095648?mt=8"];
                                                          
                                                          if ([[UIApplication sharedApplication] canOpenURL:downloadURL]) {
                                                              
                                                              if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0f) {
                                                                  [[UIApplication sharedApplication] openURL:downloadURL];
                                                              }else{
                                                                  [[UIApplication sharedApplication] openURL:downloadURL options:@{} completionHandler:nil];
                                                              }
                                                          }
                                                          
                                                          [alertController dismissViewControllerAnimated:YES completion:nil];
                                                      }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:XYBString(@"str_common_cancel", @"取消") style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *_Nonnull action) {
                                                          [alertController dismissViewControllerAnimated:YES completion:nil];
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

/**
 *  @brief 借钱按钮点击事件
 *
 *  @param sender 借钱
 */
- (void)clickBorrowBtn:(id)sender {
    
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:nil];
        return;
    }
    
    if ([xsdModel.data.highCanBorrowAmount floatValue] < 500.0f) {
        [UMengAnalyticsUtil event:EVENT_XSDBORROW_MONEY];
        [self presentDownloadXsdAppAlertView];
        return;
    }
    
    if (xsdModel.data.borrowApplyUrl != nil) {
        [UMengAnalyticsUtil event:EVENT_XSDBORROW_MONEY];
        XsdWebViewController *webVC = [[XsdWebViewController alloc] initWithTitle:nil webUrlString:[NSString stringWithFormat:@"%@", xsdModel.data.borrowApplyUrl]];
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];//进入借款页面
    }
}

- (void)presentDownloadXsdAppAlertView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:XYBString(@"str_xsdborrow_QJJE",@"可借额度不足，起借金额为500元") preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:XYBString(@"str_financing_ok", @"确定") style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *_Nonnull action) {
                                                          [alertController dismissViewControllerAnimated:YES completion:nil];
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  @brief 我要还款的点击事件
 *
 *  @param sender 我要还款按钮
 */
- (void)clickRepayBtn:(id)sender {
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:nil];
        return;
    }
    
    //进入还款页面
    if (xsdModel.data.repayApplyUrl != nil) {
        [UMengAnalyticsUtil event:EVENT_XSDBORROW_REPAYMENT];
        XsdWebViewController *webVC = [[XsdWebViewController alloc] initWithTitle:nil webUrlString:[NSString stringWithFormat:@"%@", xsdModel.data.repayApplyUrl]];
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

/**
 *  @brief 借款记录的点击事件
 *
 *  @param sender 借款记录按钮
 */
- (void)clickBorrowRecordBtn:(id)sender {
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:nil];
        return;
    }
    
    //进入借款记录页面
    if (xsdModel.data.applyListUrl != nil) {
        XsdWebViewController *webVC = [[XsdWebViewController alloc] initWithTitle:nil webUrlString:[NSString stringWithFormat:@"%@", xsdModel.data.applyListUrl]];
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

/**
 *  @brief 还款记录的点击事件
 *
 *  @param sender 还款记录按钮
 */
- (void)clickRepayRecordBtn:(id)sender {
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:nil];
        return;
    }
    
    //进入还款记录页面
    if (xsdModel.data.repayListUrl != nil) {
        [UMengAnalyticsUtil event:EVENT_XSDBORROW_REPAYMENT_RECORD];
        XsdWebViewController *webVC = [[XsdWebViewController alloc] initWithTitle:nil webUrlString:[NSString stringWithFormat:@"%@", xsdModel.data.repayListUrl]];
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- RTLabelDelegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url {
    
    if ([url.description isEqualToString:@"login"]) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:nil];
    }
}

#pragma mark - 信闪贷页面Webservice

- (void)callXsdPageWebserviceWithLoading:(BOOL)isLoading {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *mobilePhoneStr;
    NSString *idNumberStr;
    
    mobilePhoneStr = [UserDefaultsUtil getUser].tel;
    idNumberStr = [UserDefaultsUtil getUser].idNumbers ? [UserDefaultsUtil getUser].idNumbers : @"";
    
    [param setValue:mobilePhoneStr forKey:@"mobilePhone"];
    [param setValue:idNumberStr forKey:@"idNumber"];
    [param setValue:@"" forKey:@"longitude"];
    [param setValue:@"" forKey:@"latitude"];
    [param setValue:@"" forKey:@"provinceName"];
    [param setValue:@"" forKey:@"cityName"];
    [param setValue:@"" forKey:@"countyName"];
    [param setValue:@"ios" forKey:@"os"];
    
    if (isLoading) {
        [self showDataLoading];
    }
    
    [self requestXsdPageWebserviceWithParam:[[NSDictionary alloc] initWithDictionary:param]];
}

- (void)requestXsdPageWebserviceWithParam:(NSDictionary *)param {
    NSString *requestURL = [RequestURL getXsdUrl:XsdPageURL];
    [WebService postXsdRequest:requestURL param:param JSONModelClass:[XsdPageResponseModel class]
                       Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           [self hideLoading];
                           XsdPageResponseModel *model = responseObject;
                           xsdModel = model; //记录模型，点击按钮时会用到
                           if (model.result == 0) {
                               //获取数据失败，提示
                               [self showPromptTip:model.data.message];
                           } else {
                               [self reloadData:model];
                           }
                       }
                          fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                              [self hideLoading];
                              [self showPromptTip:errorMessage];
                          }];
}

@end
