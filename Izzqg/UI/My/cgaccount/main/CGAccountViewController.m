//
//  CGAccountViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/14.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "CGAccountViewController.h"
#import "NPInvestedListViewController.h"
#import "CGAccountAssetsViewController.h"
#import "CGBackPlanViewController.h"
#import "CGRechargeViewController.h"
#import "CGTransdetailsListViewController.h"
#import "CGAccountStatModel.h"
#import "CGCashViewController.h"
#import "Utility.h"
#import "UICountingLabel.h"
#import "WebService.h"
#import "WaterView.h"

@interface CGAccountViewController ()
{
    UICountingLabel * amountLabel;       //账户金额
    UILabel         * remainAmountLabel; //可用余额
    UILabel         * yjcjQuotaLabel;    //一键出借
    UILabel         * hkjhQuotaLabel;    //回款计划
    AccountStatInfoModel * accountStatInfo;
    XYScrollView    * mainScrollView;
    UIButton        * eyeButton;     //眼睛
    WaterView      * wangYiWave;    //波形
}
@end

@implementation CGAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self initUI];
    [self updataInfo:YES];
    [self setupRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updataInfo:NO];
}

#pragma mark -- 初始化 UI
-(void)setNav
{
    self.navItem.title = XYBString(@"str_account_titleDepository", @"存管账户");
    self.view.backgroundColor = COLOR_BG;
    
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
    UIButton *butTransactionDetailed = [UIButton buttonWithType:UIButtonTypeCustom];
    [butTransactionDetailed setBackgroundImage:[UIImage imageNamed:@"account_transactionload"] forState:UIControlStateNormal];
    [butTransactionDetailed setBackgroundImage:[UIImage imageNamed:@"account_transactionselect"] forState:UIControlStateHighlighted];
    butTransactionDetailed.frame = CGRectMake(0.0f, 0.0f, 22.0f, 22.0f);
    [butTransactionDetailed addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:butTransactionDetailed];
    
    self.navItem.rightBarButtonItem = rightButtonItem;
}

-(void)initUI
{
    mainScrollView = [[XYScrollView alloc] init];
    mainScrollView.backgroundColor = COLOR_COMMON_CLEAR;
    [self.view addSubview:mainScrollView];
    [mainScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    UIView *headView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 156.f)];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = headView.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id) COLOR_MAIN.CGColor,
                       (id) COLOR_LIGHT_BLUE.CGColor, nil];
    [headView.layer addSublayer:gradient];
    
    [headView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                    initWithTarget:self
                                    action:@selector(clickHeadView:)]];
    [mainScrollView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(MainScreenWidth));
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@156);
    }];
    
    wangYiWave = [[WaterView alloc]initWithFrame:CGRectMake(0,65.f, MainScreenWidth, 91.f)];
    [headView addSubview:wangYiWave];
    
    
    
    UILabel * totalAssetsLabel = [[UILabel alloc] init];
    totalAssetsLabel.text = XYBString(@"str_tip_all_asset", @"总资产(元)");
    totalAssetsLabel.font = SMALL_TEXT_FONT_13;
    totalAssetsLabel.textColor = COLOR_COMMON_WHITE;
    totalAssetsLabel.userInteractionEnabled = YES;
    [totalAssetsLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(clickEyeButton:)]];
    [headView addSubview:totalAssetsLabel];
    [totalAssetsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(Margin_Top);
        make.centerX.equalTo(headView.mas_centerX)
        .offset(-13);
    }];
    
    eyeButton = [[UIButton alloc] init];
    [headView addSubview:eyeButton];
    if ([UserDefaultsUtil getNew]) {
        eyeButton.selected = YES;
    } else {
        eyeButton.selected = NO;
    }
    [eyeButton setBackgroundImage:[UIImage imageNamed:@"eye_on"]
                         forState:UIControlStateNormal];
    [eyeButton setBackgroundImage:[UIImage imageNamed:@"eye_off"]
                         forState:UIControlStateSelected];
    [eyeButton addTarget:self
                  action:@selector(clickEyeButton:)
        forControlEvents:UIControlEventTouchUpInside];
    [eyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(totalAssetsLabel.mas_centerY);
        make.left.equalTo(totalAssetsLabel.mas_right).offset(5);
    }];
    
    amountLabel = [[UICountingLabel alloc] initWithFrame:CGRectZero];
    amountLabel.textAlignment = NSTextAlignmentCenter;
    amountLabel.font = MYCOUPONS_FONT;
    amountLabel.textColor = COLOR_COMMON_WHITE;
    amountLabel.text = @"0.00";
    amountLabel.format = @"%.2f";
    [headView addSubview:amountLabel];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(totalAssetsLabel.mas_bottom).offset(4);
        make.height.equalTo(@46);
    }];
    
    remainAmountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    remainAmountLabel.text = [Utility frontAfterString:[NSString stringWithFormat: XYBString(@"str_account_balancey", @"可用余额%@元"),@"0.00"]];
    remainAmountLabel.textColor = COLOR_COMMON_WHITE;
    remainAmountLabel.font = WEAK_TEXT_FONT_11;
    remainAmountLabel.layer.cornerRadius = 10.f;
    remainAmountLabel.layer.borderWidth = Line_Height;
    remainAmountLabel.layer.borderColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:0.6].CGColor;
    remainAmountLabel.userInteractionEnabled = YES;
    [headView addSubview:remainAmountLabel];
    [remainAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountLabel.mas_bottom).offset(6);
        make.height.equalTo(@(20));
        make.centerX.equalTo(headView);
    }];
    
    //卡片
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    backImageView.image = [UIImage imageNamed:@"radioBackImg"];
    backImageView.userInteractionEnabled = YES;
    [mainScrollView addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remainAmountLabel.mas_bottom).offset(20);
        make.left.equalTo(@(10));
        make.right.equalTo(@(-10));
        make.width.equalTo(@(MainScreenWidth - 20));
        make.height.equalTo(@(63));
    }];
    
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
    verticalLine.backgroundColor = COLOR_LINE;
    [backImageView addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(backImageView);
        make.height.equalTo(@(63/3));
        make.width.equalTo(@(Line_Height));
    }];
    
    XYButton *withDrawButton = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [withDrawButton setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_CLEAR] forState:UIControlStateNormal];
    [withDrawButton addTarget:self action:@selector(clickWithDrawBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:withDrawButton];
    
    [withDrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_top).offset(1);
        make.bottom.equalTo(backImageView.mas_bottom).offset(-7);
        make.left.equalTo(backImageView.mas_left).offset(4);
        make.right.equalTo(verticalLine.mas_left);
    }];
    
    UIImageView *withDrawImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_tx"]];
    [withDrawButton addSubview:withDrawImgView];
    
    [withDrawImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(withDrawButton.mas_centerY);
        make.centerX.equalTo(withDrawButton.mas_centerX).offset(-20);
    }];
    
    UILabel *withDrawLab = [[UILabel alloc] initWithFrame:CGRectZero];
    withDrawLab.text = XYBString(@"str_withdraw", @"提现");
    withDrawLab.textColor = COLOR_MAIN_GREY;
    withDrawLab.font = BIG_TEXT_FONT_17;
    [withDrawButton addSubview:withDrawLab];
    
    [withDrawLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(withDrawButton.mas_centerY);
        make.centerX.equalTo(withDrawButton.mas_centerX).offset(20);
    }];
    
    XYButton *chargeButton = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [chargeButton setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_CLEAR] forState:UIControlStateNormal];
    [chargeButton addTarget:self action:@selector(clickChargeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:chargeButton];
    
    [chargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_top).offset(1);
        make.bottom.equalTo(backImageView.mas_bottom).offset(-7);
        make.left.equalTo(verticalLine.mas_right);
        make.right.equalTo(backImageView.mas_right).offset(-4);
    }];
    
    UIImageView *chargeImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_cz"]];
    [chargeButton addSubview:chargeImgView];
    
    [chargeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(chargeButton.mas_centerY);
        make.centerX.equalTo(chargeButton.mas_centerX).offset(-20);
    }];
    
    UILabel *chargeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    chargeLab.text = XYBString(@"str_charge", @"充值");
    chargeLab.textColor = COLOR_MAIN_GREY;
    chargeLab.font = BIG_TEXT_FONT_17;
    [chargeButton addSubview:chargeLab];
    
    [chargeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(chargeButton.mas_centerY);
        make.centerX.equalTo(chargeButton.mas_centerX).offset(20);
    }];
#pragma mark -- 一键出借 回款计划
    //一键出借
    UIView * yjcjView = [[UIView alloc] initWithFrame:CGRectZero];
    yjcjView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScrollView addSubview:yjcjView];
    [yjcjView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(headView.mas_bottom).offset(42);
        make.height.equalTo(@45.5);
    }];
    
    
    XYButton *yjcjBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil
                                                          titleColor:nil
                                            isUserInteractionEnabled:YES];
    [yjcjBtn addTarget:self
                   action:@selector(clickYjctControl:)
         forControlEvents:UIControlEventTouchUpInside];
    [yjcjView addSubview:yjcjBtn];
    [yjcjBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yjcjView.mas_top);
        make.width.equalTo(yjcjView.mas_width);
        make.bottom.equalTo(yjcjView.mas_bottom).offset(-Line_Height);
    }];
    
    UIView *yjcjLineView = [[UIView alloc] initWithFrame:CGRectZero];
    yjcjLineView.backgroundColor = COLOR_LINE;
    [yjcjView addSubview:yjcjLineView];
    
    [yjcjLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@0);
        make.bottom.equalTo(yjcjBtn.mas_bottom).offset(-0.5);
        make.height.equalTo(@(Line_Height));
    }];
    
    UIImageView * yjcjImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    yjcjImageView.image = [UIImage imageNamed:@"yjcj_Icon"];
    [yjcjView addSubview:yjcjImageView];
    [yjcjImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.centerY.equalTo(yjcjBtn.mas_centerY);
    }];
    
    UILabel *tipYjcjLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipYjcjLabel.text = XYBString(@"str_common_yjcj", @"一键出借");
    tipYjcjLabel.font = TEXT_FONT_16;
    tipYjcjLabel.textColor = COLOR_MAIN_GREY;
    [yjcjView addSubview:tipYjcjLabel];
    [tipYjcjLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yjcjImageView.mas_right).offset(Margin_Left);
        make.centerY.equalTo(yjcjBtn.mas_centerY);
    }];
    
    UIImageView *arrowYjcjView =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    [yjcjView addSubview:arrowYjcjView];
    [arrowYjcjView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(yjcjBtn.mas_centerY);
        make.right.equalTo(yjcjView.mas_right).offset(-Margin_Right);
    }];
    
    yjcjQuotaLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    yjcjQuotaLabel.font = TEXT_FONT_14;
    yjcjQuotaLabel.textColor = COLOR_AUXILIARY_GREY;
    yjcjQuotaLabel.textAlignment = NSTextAlignmentRight;
    yjcjQuotaLabel.text =  XYBString(@"str_tip_amount_asset_zero", @"0.00");
    [yjcjView addSubview:yjcjQuotaLabel];
    [yjcjQuotaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowYjcjView.mas_left).offset(-3);
        make.centerY.equalTo(yjcjBtn.mas_centerY);
    }];
    
    
    //回款计划
    UIView * paymentPlanView = [[UIView alloc] initWithFrame:CGRectZero];
    paymentPlanView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScrollView addSubview:paymentPlanView];
    [paymentPlanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(yjcjView.mas_bottom).offset(0);
        make.height.equalTo(@(45.f));
    }];
    
    XYButton *paymentPlanControlBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil
                                                                     titleColor:nil
                                                       isUserInteractionEnabled:YES];
    [paymentPlanControlBtn addTarget:self
                              action:@selector(clickStayBackControl:)
                    forControlEvents:UIControlEventTouchUpInside];
    [paymentPlanView addSubview:paymentPlanControlBtn];
    [paymentPlanControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(paymentPlanView.mas_top);
        make.width.equalTo(paymentPlanView.mas_width);
        make.bottom.equalTo(paymentPlanView.mas_bottom).offset(-Line_Height);
    }];
    
    UIImageView * paymentPlanmageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    paymentPlanmageView.image = [UIImage imageNamed:@"paymentplan_Icon"];
    [paymentPlanView addSubview:paymentPlanmageView];
    [paymentPlanmageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.centerY.equalTo(paymentPlanControlBtn.mas_centerY);
    }];
    
    UILabel *tipPaymentPlanLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipPaymentPlanLabel.text = XYBString(@"str_payment_plan", @"回款计划");
    tipPaymentPlanLabel.font = TEXT_FONT_16;
    tipPaymentPlanLabel.textColor = COLOR_MAIN_GREY;
    [paymentPlanView addSubview:tipPaymentPlanLabel];
    [tipPaymentPlanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(paymentPlanmageView.mas_right).offset(Margin_Left);
        make.centerY.equalTo(paymentPlanControlBtn.mas_centerY);
    }];
    
    UIImageView *arrowPaymentPlanImageView =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    [paymentPlanView addSubview:arrowPaymentPlanImageView];
    [arrowPaymentPlanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(paymentPlanControlBtn.mas_centerY);
        make.right.equalTo(paymentPlanView.mas_right).offset(-Margin_Right);
    }];
    
//    hkjhQuotaLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    hkjhQuotaLabel.font = TEXT_FONT_14;
//    hkjhQuotaLabel.textColor = COLOR_AUXILIARY_GREY;
//    hkjhQuotaLabel.textAlignment = NSTextAlignmentRight;
//    hkjhQuotaLabel.text =  XYBString(@"str_tip_amount_asset_zero", @"0.00");
//    [paymentPlanView addSubview:hkjhQuotaLabel];
//    [hkjhQuotaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(arrowPaymentPlanImageView.mas_left).offset(-3);
//        make.centerY.equalTo(paymentPlanControlBtn.mas_centerY);
//    }];
}

#pragma mark --  点击事件
-(void)clickBackBtn:(id)sender
{
     [self.navigationController popViewControllerAnimated:YES];
}

//收支明细
-(void)clickRightBtn:(id)sender
{
    CGTransdetailsListViewController * cgTransDetailsVc = [[CGTransdetailsListViewController alloc] init];
    [self.navigationController pushViewController:cgTransDetailsVc animated:YES];
}

//总资产
-(void)clickHeadView:(id)sender
{
    CGAccountAssetsViewController * cgaccountAssets = [[CGAccountAssetsViewController alloc] init];
    cgaccountAssets.accountStatInfo = accountStatInfo;
    [self.navigationController pushViewController:cgaccountAssets animated:YES];
}

//眼睛
-(void)clickEyeButton:(id)sender
{
    eyeButton.selected = !eyeButton.selected;
    [self refreshUI];
}

//一键出借规则
-(void)clickyjcjGZControl:(id)sender
{
    
}

//一键出借
-(void)clickYjctControl:(id)sender
{
    NPInvestedListViewController * npInvested = [[NPInvestedListViewController alloc] init];
    [self.navigationController pushViewController:npInvested animated:YES];
}

//回款计划
-(void)clickStayBackControl:(id)sender
{
    CGBackPlanViewController * cgbackPlan = [[CGBackPlanViewController alloc] init];
    [self.navigationController pushViewController:cgbackPlan animated:YES];
}

//提现
-(void)clickWithDrawBtn:(id)sender
{
    CGCashViewController * cgCash = [[CGCashViewController alloc] init];
    [self.navigationController pushViewController:cgCash animated:YES];
}

//充值
-(void)clickChargeBtn:(id)sender
{
    CGRechargeViewController * cgRecharge = [[CGRechargeViewController alloc] init];
    [self.navigationController pushViewController:cgRecharge animated:YES];
}

#pragma mark --  数据处理
- (void)setupRefresh {
    mainScrollView.header = self.gifHeader1;
}

- (void)headerRereshing {
    [self updataInfo:NO];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [mainScrollView.header endRefreshing];
}

-(void)updataInfo:(BOOL)showLoading
{
    NSMutableDictionary * dic =[[NSMutableDictionary alloc] init];
    [dic setValue:[Utility shareInstance].isLogin ? [UserDefaultsUtil getUser].userId : @"0" forKey:@"userId"];
    
    if (showLoading == YES) {
        [self showDataLoading];
    }
    
    [self cgAccountRequestWebServiceWithParam:dic];
}


- (void)cgAccountRequestWebServiceWithParam:(NSMutableDictionary *)paramsDic {

    NSString *urlPath = [RequestURL getRequestURL:AccountStatURL param:paramsDic];
    
    [WebService postRequest:urlPath param:paramsDic JSONModelClass:[CGAccountStatModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self hideLoading];
                        
                        CGAccountStatModel * cgAccount = responseObject;
                        
                        User *user = [UserDefaultsUtil getUser];
                        user.cgUsableAmount = cgAccount.accountStatInfo.usableAmt;
                        user.cgTotalAsset   = cgAccount.accountStatInfo.totalAsset;
                        user.cashOrderPrinAmountTotal =  cgAccount.accountStatInfo.cashOrderPrinAmountTotal;
                        [UserDefaultsUtil setUser:user];

                        accountStatInfo = cgAccount.accountStatInfo;
                        [self refreshUI];
                    
                    }
     
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }
     
     ];
}

-(void)refreshUI
{
    User *userInfo = [UserDefaultsUtil getUser];
    
    //总资产
    if (eyeButton.selected == NO) {
        [UserDefaultsUtil clearNew];
        if ([userInfo.cgTotalAsset doubleValue] == 0) {
            amountLabel.text = @"0.00";
        } else {
            
            amountLabel.formatBlock = ^NSString* (double value)
            {
                NSString* formatted =  [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",value]];
                return [NSString stringWithFormat:@"%@",formatted];
            };
            
            amountLabel.method = UILabelCountingMethodEaseOut;
            NSDecimalNumber * minBidAmounts = [NSDecimalNumber doubleToNSDecimalNumber:[userInfo.cgTotalAsset  doubleValue]];
            double toAmonut = [minBidAmounts doubleValue];
            amountLabel.toAmount = toAmonut;
            [amountLabel countFrom:0 to:toAmonut  withDuration:1.0f];
            
        }
    } else {
        [amountLabel.timer invalidate];
        amountLabel.text = @"****";
        [UserDefaultsUtil setNew];
    }
    [Utility frontAfterString:[NSString stringWithFormat: XYBString(@"str_account_balancey", @"可用余额%@元"),@"0.00"]];
    
    //可用余额
    if (eyeButton.selected == NO) {
        if (userInfo.cgUsableAmount.doubleValue == 0) {
            remainAmountLabel.text = [Utility frontAfterString:[NSString stringWithFormat: XYBString(@"str_account_balancey", @"可用余额%@元"),XYBString(@"str_tip_amount_asset_zero", @"0.00")]];
            
        } else {
            NSString *sTemp =  [Utility frontAfterString:[NSString stringWithFormat: XYBString(@"str_account_balancey", @"可用余额%@元"),[Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[userInfo.cgUsableAmount doubleValue]]]]];
            remainAmountLabel.text = [NSString stringWithFormat:XYBString(@"str_usableAmount_asset", @"%@"), sTemp];
        }
    } else {
        remainAmountLabel.text = [Utility frontAfterString:XYBString(@"str_account_KqCharge_jm", @"****")];
    }
    
    //一键出借本金
    if (eyeButton.selected == NO) {
        if ([userInfo.cashOrderPrinAmountTotal doubleValue] == 0) {
             yjcjQuotaLabel.text = @"0.00元";
        } else {
             yjcjQuotaLabel.text = [[Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[userInfo.cashOrderPrinAmountTotal doubleValue]]] stringByAppendingString:@"元"];
        }
    } else {
         yjcjQuotaLabel.text = @"****";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
