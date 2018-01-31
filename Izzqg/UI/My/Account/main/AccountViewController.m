//
//  AccountViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/14.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "AccountViewController.h"
#import "Utility.h"
#import "UICountingLabel.h"
#import "TropismViewController.h"
#import "BackPlanViewController.h"
#import "ChargeViewController.h"
#import "BbgInvestListViewController.h"
#import "DqbInvestListViewController.h"
#import "XtbInvestListViewController.h"
#import "TradeDetailViewController.h"
#import "AllAssetsViewController.h"
#import "WaterView.h"
#import "HandleUserInfo.h"
#import "WebService.h"
#import "AccountResponseModel.h"

@interface AccountViewController ()
{
    UICountingLabel * amountLabel; //账户金额
    UILabel         * remainAmountLabel; //可用余额
    UILabel         * bbgQuotaLabel; //步步高已投金额
    UILabel         * dqbQuotaLabel; //定期宝已投金额
    UILabel         * xtbQuotaLabel; //信投保已投金额
    UIButton        * eyeButton;     //眼睛
    WaterView      * wangYiWave;    //波形
    
}
@property (nonatomic, strong) NSMutableDictionary  * accountDic;
@property (nonatomic, strong) XYScrollView *mainScrollView;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //充值成功后 通知提示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chargeSuccess) name:@"chargeSuccessNotification" object:nil];
    
    [self setNav];
    [self initUI];
    [self updateAccountInfo];
    [self setupRefresh];
}



#pragma mark -- 初始化 UI
-(void)setNav
{
    self.navItem.title = XYBString(@"str_account_titleOrdinary", @"普通账户");
    self.view.backgroundColor = COLOR_BG;
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
}

-(void)initUI
{
    _mainScrollView = [[XYScrollView alloc] init];
    _mainScrollView.backgroundColor = COLOR_COMMON_CLEAR;
    [self.view addSubview:_mainScrollView];
    [_mainScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
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
    [_mainScrollView addSubview:headView];
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
    [_mainScrollView addSubview:backImageView];
    
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

    
#pragma mark -- 步步高已投 定期宝已投 信用宝已投 回款计划

    UIView * bBgCastView = [[UIView alloc] initWithFrame:CGRectZero];
    bBgCastView.backgroundColor = COLOR_COMMON_WHITE;
    [_mainScrollView addSubview:bBgCastView];
    [bBgCastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(headView.mas_bottom).offset(42);
        make.height.equalTo(@45.5);
    }];

    XYButton * bBgCastControlBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil
                                                                       titleColor:nil
                                                         isUserInteractionEnabled:YES];
    [bBgCastControlBtn addTarget:self
                                action:@selector(clickBBgCastControl:)
                      forControlEvents:UIControlEventTouchUpInside];
    [bBgCastView addSubview:bBgCastControlBtn];
    [bBgCastControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bBgCastView.mas_top);
        make.left.equalTo(bBgCastView.mas_left);
        make.right.equalTo(bBgCastView.mas_right);
        make.height.equalTo(@(45));
    }];

    UIImageView * bBgCastImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    bBgCastImageView.image = [UIImage imageNamed:@"bbg_Icon"];
    [bBgCastView addSubview:bBgCastImageView];
    [bBgCastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.centerY.equalTo(bBgCastControlBtn.mas_centerY);
    }];


    UILabel *tipbBgCastLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipbBgCastLabel.text =  XYBString(@"str_bbg_invested", @"步步高已投");
    tipbBgCastLabel.font = TEXT_FONT_16;
    tipbBgCastLabel.textColor = COLOR_MAIN_GREY;
    [bBgCastView addSubview:tipbBgCastLabel];
    [tipbBgCastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bBgCastImageView.mas_right).offset(Margin_Left);
        make.centerY.equalTo(bBgCastControlBtn.mas_centerY);
    }];

    UIImageView *arrowBgCastImageView =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    [bBgCastView addSubview:arrowBgCastImageView];
    [arrowBgCastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bBgCastControlBtn.mas_centerY);
        make.right.equalTo(bBgCastView.mas_right).offset(-Margin_Right);
    }];

    bbgQuotaLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    bbgQuotaLabel.font = TEXT_FONT_14;
    bbgQuotaLabel.textColor = COLOR_AUXILIARY_GREY;
    bbgQuotaLabel.textAlignment = NSTextAlignmentRight;
    bbgQuotaLabel.text =  XYBString(@"str_tip_amount_asset_zero", @"0.00");
    [bBgCastView addSubview:bbgQuotaLabel];
    [bbgQuotaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowBgCastImageView.mas_left).offset(-3);
        make.centerY.equalTo(bBgCastControlBtn.mas_centerY);
    }];

    //定期宝 View
    UIView *dQbCastView = [[UIView alloc] initWithFrame:CGRectZero];
    dQbCastView.backgroundColor = COLOR_COMMON_WHITE;
    [_mainScrollView addSubview:dQbCastView];
    [dQbCastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(bBgCastView.mas_bottom).offset(0);
        make.height.equalTo(@46);
    }];

    UIView *splitInviteDqbCastLineView = [[UIView alloc] initWithFrame:CGRectZero];
    splitInviteDqbCastLineView.backgroundColor = COLOR_LINE;
    [dQbCastView addSubview:splitInviteDqbCastLineView];

    [splitInviteDqbCastLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@0);
        make.top.equalTo(dQbCastView.mas_top);
        make.height.equalTo(@(Line_Height));
    }];

    UIView *splitCenterLineDqbCastView = [[UIView alloc] initWithFrame:CGRectZero];
    splitCenterLineDqbCastView.backgroundColor = COLOR_LINE;
    [dQbCastView addSubview:splitCenterLineDqbCastView];

    [splitCenterLineDqbCastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@0);
        make.bottom.equalTo(dQbCastView.mas_bottom).offset(-0.5);
        make.height.equalTo(@(Line_Height));
    }];

    XYButton *dqbCastControlBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil
                                                               titleColor:nil
                                                 isUserInteractionEnabled:YES];
    [dqbCastControlBtn addTarget:self
                        action:@selector(clickDqbCastControl:)
              forControlEvents:UIControlEventTouchUpInside];
    [dQbCastView addSubview:dqbCastControlBtn];
    [dqbCastControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dQbCastView.mas_top).offset(0.5f);
        make.left.equalTo(dQbCastView.mas_left);
        make.right.equalTo(dQbCastView.mas_right);
        make.height.equalTo(@(44.5f));
    }];

    UIImageView * dqbCastImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    dqbCastImageView.image = [UIImage imageNamed:@"dqb_Icon"];
    [dQbCastView addSubview:dqbCastImageView];
    [dqbCastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.centerY.equalTo(dqbCastControlBtn.mas_centerY);
    }];

    UILabel *tipdqbCastLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipdqbCastLabel.text = XYBString(@"str_dqb_invested", @"定期宝已投");
    tipdqbCastLabel.font = TEXT_FONT_16;
    tipdqbCastLabel.textColor = COLOR_MAIN_GREY;
    [dQbCastView addSubview:tipdqbCastLabel];
    [tipdqbCastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dqbCastImageView.mas_right).offset(Margin_Left);
        make.centerY.equalTo(dqbCastControlBtn.mas_centerY);
    }];

    UIImageView *arrowdqbCastImageView =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    [dQbCastView addSubview:arrowdqbCastImageView];
    [arrowdqbCastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dqbCastControlBtn.mas_centerY);
        make.right.equalTo(dQbCastView.mas_right).offset(-Margin_Right);
    }];

    dqbQuotaLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    dqbQuotaLabel.font = TEXT_FONT_14;
    dqbQuotaLabel.textColor = COLOR_AUXILIARY_GREY;
    dqbQuotaLabel.textAlignment = NSTextAlignmentRight;
    dqbQuotaLabel.text =   XYBString(@"str_tip_amount_asset_zero", @"0.00");
    [dQbCastView addSubview:dqbQuotaLabel];
    [dqbQuotaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowdqbCastImageView.mas_left).offset(-3);
        make.centerY.equalTo(dqbCastControlBtn.mas_centerY);
    }];

    //信投保已投
    UIView * xtbCastView = [[UIView alloc] initWithFrame:CGRectZero];
    xtbCastView.backgroundColor = COLOR_COMMON_WHITE;
    [_mainScrollView addSubview:xtbCastView];
    [xtbCastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(dQbCastView.mas_bottom).offset(0);
        make.height.equalTo(@45.5);
    }];


    XYButton *xtbCastBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil
                                                           titleColor:nil
                                             isUserInteractionEnabled:YES];
    [xtbCastBtn addTarget:self
                    action:@selector(clickXtbCastViewControl:)
          forControlEvents:UIControlEventTouchUpInside];
    [xtbCastView addSubview:xtbCastBtn];
    [xtbCastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xtbCastView.mas_top);
        make.width.equalTo(xtbCastView.mas_width);
        make.bottom.equalTo(xtbCastView.mas_bottom).offset(-Line_Height);
    }];

    UIView *xtbCastLineView = [[UIView alloc] initWithFrame:CGRectZero];
    xtbCastLineView.backgroundColor = COLOR_LINE;
    [xtbCastView addSubview:xtbCastLineView];

    [xtbCastLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@0);
        make.bottom.equalTo(xtbCastBtn.mas_bottom).offset(-0.5);
        make.height.equalTo(@(Line_Height));
    }];

    UIImageView * xtbCastImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    xtbCastImageView.image = [UIImage imageNamed:@"xtb_Icon"];
    [xtbCastView addSubview:xtbCastImageView];
    [xtbCastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.centerY.equalTo(xtbCastBtn.mas_centerY);
    }];

    UILabel *tipXtbCastLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipXtbCastLabel.text = XYBString(@"str_xtb_invested", @"信投保已投");
    tipXtbCastLabel.font = TEXT_FONT_16;
    tipXtbCastLabel.textColor = COLOR_MAIN_GREY;
    [xtbCastView addSubview:tipXtbCastLabel];
    [tipXtbCastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(xtbCastImageView.mas_right).offset(Margin_Left);
        make.centerY.equalTo(xtbCastBtn.mas_centerY);
    }];

    UIImageView *arrowXtbCastView =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    [xtbCastView addSubview:arrowXtbCastView];
    [arrowXtbCastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(xtbCastBtn.mas_centerY);
        make.right.equalTo(xtbCastView.mas_right).offset(-Margin_Right);
    }];

    xtbQuotaLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    xtbQuotaLabel.font = TEXT_FONT_14;
    xtbQuotaLabel.textColor = COLOR_AUXILIARY_GREY;
    xtbQuotaLabel.textAlignment = NSTextAlignmentRight;
    xtbQuotaLabel.text =  XYBString(@"str_tip_amount_asset_zero", @"0.00");
    [xtbCastView addSubview:xtbQuotaLabel];
    [xtbQuotaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowXtbCastView.mas_left).offset(-3);
        make.centerY.equalTo(xtbCastBtn.mas_centerY);
    }];


    //回款计划
    UIView * paymentPlanView = [[UIView alloc] initWithFrame:CGRectZero];
    paymentPlanView.backgroundColor = COLOR_COMMON_WHITE;
    [_mainScrollView addSubview:paymentPlanView];
    [paymentPlanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(xtbCastView.mas_bottom).offset(0);
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
    
}


#pragma mark --  点击事件


//返回
-(void)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//总资产
-(void)clickHeadView:(id)sender
{
    [UMengAnalyticsUtil event:EVENT_MY_assets];
    AllAssetsViewController *allAssetsVC = [[AllAssetsViewController alloc] init];
    allAssetsVC.accountInfo = [UserDefaultsUtil getUser];
    allAssetsVC.accountDic = _accountDic;
    [self.navigationController pushViewController:allAssetsVC animated:YES];
}

//眼睛
-(void)clickEyeButton:(id)sender
{
    eyeButton.selected = !eyeButton.selected;
    [self refreshUI];
}

//步步高
-(void)clickBBgCastControl:(id)sender
{
    BbgInvestListViewController * bbgInvestList = [[BbgInvestListViewController alloc] init];
    [self.navigationController pushViewController:bbgInvestList animated:YES];
}

//定期保
-(void)clickDqbCastControl:(id)sender
{
    DqbInvestListViewController * dqbInvestList = [[DqbInvestListViewController alloc] init];
    [self.navigationController pushViewController:dqbInvestList animated:YES];
}

//信投保
-(void)clickXtbCastViewControl:(id)sender
{
    XtbInvestListViewController * xtbInvestList = [[XtbInvestListViewController alloc] init];
    [self.navigationController pushViewController:xtbInvestList animated:YES];
}

//回款计划
-(void)clickStayBackControl:(id)sender
{
    [UMengAnalyticsUtil event:EVENT_MY_COLLECTION_PLAN];
    BackPlanViewController *backPlan = [[BackPlanViewController alloc] init];
    backPlan.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:backPlan animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}


#pragma mark -- 数据处理
- (void)refreshUI {
    User *userInfo = [UserDefaultsUtil getUser];
    
    //总资产
    if (eyeButton.selected == NO) {
        
        [UserDefaultsUtil clearNew];
        if ([userInfo.totalAmount doubleValue] == 0) {
            amountLabel.text = @"0.00";
        } else {
            
            amountLabel.formatBlock = ^NSString* (double value)
            {
                NSString* formatted =  [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",value]];
                return [NSString stringWithFormat:@"%@",formatted];
            };
            
            amountLabel.method = UILabelCountingMethodEaseOut;
            NSDecimalNumber * minBidAmounts = [NSDecimalNumber doubleToNSDecimalNumber:[userInfo.totalAmount  doubleValue]];
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
        if (userInfo.usableAmount.doubleValue == 0) {
            remainAmountLabel.text = [Utility frontAfterString:[NSString stringWithFormat: XYBString(@"str_account_balancey", @"可用余额%@元"),XYBString(@"str_tip_amount_asset_zero", @"0.00")]];
            
        } else {
            NSString *sTemp =  [Utility frontAfterString:[NSString stringWithFormat: XYBString(@"str_account_balancey", @"可用余额%@元"),[Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[userInfo.usableAmount doubleValue]]]]];
            remainAmountLabel.text = [NSString stringWithFormat:XYBString(@"str_usableAmount_asset", @"%@"), sTemp];
        }
    } else {
        remainAmountLabel.text = [Utility frontAfterString:XYBString(@"str_account_KqCharge_jm", @"****")];
    }
    //步步高已投
    if (eyeButton.selected == NO) {
        if ([userInfo.bbgPrincipal doubleValue] == 0) {
            bbgQuotaLabel.text = @"0.00元";
        } else {
            bbgQuotaLabel.text = [[Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[userInfo.bbgPrincipal doubleValue]]] stringByAppendingString:@"元"];
        }
    } else {
            bbgQuotaLabel.text = @"****";
    }
    //定期宝已投
    if (eyeButton.selected == NO) {
        if ([userInfo.dqbPrincipal doubleValue] == 0) {
            dqbQuotaLabel.text = @"0.00元";
        } else {
            dqbQuotaLabel.text = [[Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[userInfo.dqbPrincipal doubleValue]]] stringByAppendingString:@"元"];
        }
    } else {
            dqbQuotaLabel.text = @"****";
    }
    //信投保已投
    if (eyeButton.selected == NO) {
        if ([userInfo.xtbPrincipal doubleValue] == 0) {
            xtbQuotaLabel.text = @"0.00元";
        } else {
            xtbQuotaLabel.text = [[Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[userInfo.xtbPrincipal doubleValue]]] stringByAppendingString:@"元"];
        }
    } else {
            xtbQuotaLabel.text = @"****";
    }

}

#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    _mainScrollView.header = self.gifHeader1;
}

- (void)headerRereshing {
    [self updateAccountInfo];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [_mainScrollView.header endRefreshing];
}

/*!
 *  @author JiangJJ, 16-12-13 16:12:19
 *
 *  通知
 */
- (void)updateAccountInfo {
    
    static BOOL s_isUpdate = NO;
    if (s_isUpdate == NO) {
        [self showDataLoading];
        s_isUpdate = YES;
    }
    
    NSString *noticeLastReadDateStr = nil;
    NSString *eventLastReadDateStr = nil;
    NSString *financeLastReadDateStr = nil;
    NSString *borrowLastReadDateStr = nil;
    
    NSDictionary *userDic = [UserDefaultsUtil getLastReadDateDic];
    NSDictionary *lastReadDateDic = [userDic objectForKey:[UserDefaultsUtil getUser].userId];
    if (lastReadDateDic) {
        
        if ([lastReadDateDic objectForKey:@"NoticeDate"]) { //公告最后阅读时间
            noticeLastReadDateStr = [lastReadDateDic objectForKey:@"NoticeDate"];
        } else {
            noticeLastReadDateStr = @"";
        }
        
        if ([lastReadDateDic objectForKey:@"EventDate"]) { //活动最后阅读时间
            eventLastReadDateStr = [lastReadDateDic objectForKey:@"EventDate"];
        } else {
            eventLastReadDateStr = @"";
        }
        
        if ([lastReadDateDic objectForKey:@"FinanceDate"]) { //出借最后阅读时间
            financeLastReadDateStr = [lastReadDateDic objectForKey:@"FinanceDate"];
        } else {
            financeLastReadDateStr = @"";
        }
        
        if ([lastReadDateDic objectForKey:@"BorrowDate"]) { //借款最后阅读时间
            borrowLastReadDateStr = [lastReadDateDic objectForKey:@"BorrowDate"];
        } else {
            borrowLastReadDateStr = @"";
        }
        
    } else {
        noticeLastReadDateStr = @"";
        eventLastReadDateStr = @"";
        financeLastReadDateStr = @"";
        borrowLastReadDateStr = @"";
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if ([UserDefaultsUtil getUser].userId) {
        [param setObject:[UserDefaultsUtil getUser].userId forKey:@"userId"];
    }
    
    [param setObject:noticeLastReadDateStr forKey:@"noticeDate"];
    [param setObject:eventLastReadDateStr forKey:@"eventDate"];
    [param setObject:financeLastReadDateStr forKey:@"financeDate"];
    [param setObject:borrowLastReadDateStr forKey:@"borrowDate"];
    
    [self updateAccountInfoRequestWithparam:param];
}

/*!
 *  @author JiangJJ, 16-12-13 16:12:15
 *
 *
 *  @param params 我的账户接口
 */
- (void)updateAccountInfoRequestWithparam:(NSMutableDictionary *)params {
    NSString *urlPath = [RequestURL getRequestURL:AccountRequestURL param:params];
    [WebService postRequest:urlPath param:params JSONModelClass:[AccountResponseModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        AccountResponseModel *account = responseObject;
                        _accountDic = [[NSMutableDictionary alloc] initWithDictionary:account.accountInfo.toDictionary];
                        if (account.resultCode == 1) {
                            
                            //保存user
                            User *user = [HandleUserInfo hanedleTheUserInfo:account.toDictionary];
                            [UserDefaultsUtil setUser:user];
                            [self refreshUI];
                        }
                         
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }
     ];
}



@end
