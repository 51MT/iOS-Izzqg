//
//  NPDetailViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/13.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NPDetailViewController.h"
#import "Utility.h"
#import "NpDetailMarkFormView.h"
#import "NPInvestViewController.h"
#import "NPIntroduceViewController.h"
#import "NPLoanRecordViewController.h"
#import "NPMatchListViewController.h"
#import "NProductDetailResModel.h"
#import "WebService.h"

#import "XsdProductDetailViewController.h"
#import "HnbProductDetailViewController.h"
#import "ZqzrDetailViewController.h"
#import "RrcProductDetailViewController.h"
#import "ZglProductDetailViewController.h"
#import "XtbProductDetailViewController.h"

#import "XYWebViewController.h"

#define VIEW_TAG_PRODUCT_INFO_VIEW 1000
#define HISTORYRATE_TAG 1001
#define VIEW_TAG_THREE 1002
#define VIEW_TAG_FOUR  1003
#define VIEW_TAG_FIVE  1004

@interface NPDetailViewController ()

@property (nonatomic,copy) NSString *productID;

@end

@implementation NPDetailViewController {
    
    XYScrollView *mainScroll;
    UIImageView *topImgView;    //顶部UI的底图
    
    UILabel *timeLab;           //一键出借的可投次数
    UILabel *rateLab;           //利率
    UILabel *minAmountLab;      //起借金额
    UILabel *deadLineLab;       //出借期限
    UILabel *repayLab;          //还款方式
    
    UIImageView *progress2;
    UILabel *investLab;         //出借
    UILabel *profitLab;         //起息
    UILabel *transferableLab;   //可转让
    UILabel *time1;             //出借日期
    UILabel *time2;             //起息日期
    UILabel *transferableTime;  //可转让日期
    UILabel *time3;             //到账日期
    UILabel *profitDay;         //• 计息日:T+1计息，每月增+1%
    
    NpDetailMarkFormView *listView;
    ColorButton *investBtn;     //出借按钮
    UILabel * restLab;          //底部金额提示文案
    UIView *backview;
}

- (instancetype)initWithNProductID:(NSString *)productID {
    self = [super init];
    if (self) {
        _productID = productID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self createTopUI];
    [self createMiddleUI];
    [self createTheThreeView];
    [self callOneKeyProductDetailWebService];
}

#pragma mark - 创建UI

- (void)setNav {
    self.navItem.title = XYBString(@"str_common_yjcj", @"一键出借");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    self.view.backgroundColor = COLOR_BG;
}

/**
 创建顶部UI
 */
- (void)createTopUI {
    
    mainScroll = [[XYScrollView alloc] initWithFrame:CGRectZero];
    mainScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainScroll];
    
    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    topImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"np_backImage"]];
    [mainScroll addSubview:topImgView];
    
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(mainScroll);
        make.height.equalTo(@(MainScreenWidth * 158/375));
    }];
    
    //起借
    rateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    rateLab.font = XTB_RATE_FONT;
    rateLab.textColor = COLOR_COMMON_WHITE;
    rateLab.text = @"0%";
    rateLab.textAlignment = NSTextAlignmentCenter;
    [topImgView addSubview:rateLab];
    
    [rateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topImgView.mas_centerX);
        make.top.equalTo(topImgView.mas_top).offset(Margin_Length);
    }];
    
    timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    timeLab.backgroundColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:0.2];
    timeLab.font = WEAK_TEXT_FONT_11;
    timeLab.textColor = COLOR_COMMON_WHITE;
    timeLab.textAlignment = NSTextAlignmentCenter;
    timeLab.text = [NSString stringWithFormat:XYBString(@"str_financing_restTimes", @"%@次可投"),@"0"];
    timeLab.layer.cornerRadius = Corner_Radius_4;
    timeLab.layer.masksToBounds = YES;
    timeLab.hidden = YES;
    [topImgView addSubview:timeLab];
    
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rateLab.mas_right);
        make.top.equalTo(topImgView.mas_top).offset(11);
        make.width.equalTo(@52);
        make.height.equalTo(@19);
    }];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
    lab.font = TEXT_FONT_12;
    lab.textColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:0.6];
    lab.text = XYBString(@"str_financing_zhydexpectedAnnualizedProfit", @"综合约定年化利率");
    lab.textAlignment = NSTextAlignmentCenter;
    [topImgView addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topImgView.mas_centerX);
        make.top.equalTo(rateLab.mas_bottom).offset(7);
    }];
    
    //起投
    UILabel *minTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    minTitleLab.font = TEXT_FONT_12;
    minTitleLab.textColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:0.6];
    minTitleLab.text = XYBString(@"str_financing_minInvestAmount", @"起投(元)");
    minTitleLab.textAlignment = NSTextAlignmentLeft;
    [topImgView addSubview:minTitleLab];
    
    [minTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topImgView.mas_left).offset(Margin_Length);
        make.bottom.equalTo(topImgView.mas_bottom).offset(-35);
    }];
    
    minAmountLab = [[UILabel alloc] initWithFrame:CGRectZero];
    minAmountLab.font = TEXT_FONT_BOLD_15;
    minAmountLab.textColor = COLOR_COMMON_WHITE;
    minAmountLab.text = @"0.00";
    minAmountLab.textAlignment = NSTextAlignmentLeft;
    [topImgView addSubview:minAmountLab];
    
    [minAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(minTitleLab.mas_centerX);
        make.bottom.equalTo(topImgView.mas_bottom).offset(-Margin_Length);
    }];
    
    //锁定期
    UILabel *deadLab = [[UILabel alloc] initWithFrame:CGRectZero];
    deadLab.font = TEXT_FONT_12;
    deadLab.textColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:0.6];
    deadLab.text = XYBString(@"str_financing_closedPeriod", @"锁定期");
    deadLab.textAlignment = NSTextAlignmentCenter;
    [topImgView addSubview:deadLab];
    
    [deadLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topImgView.mas_centerX);
        make.bottom.equalTo(topImgView.mas_bottom).offset(-35);
    }];
    
    deadLineLab = [[UILabel alloc] initWithFrame:CGRectZero];
    deadLineLab.font = TEXT_FONT_BOLD_15;
    deadLineLab.textColor = COLOR_COMMON_WHITE;
    deadLineLab.text = [NSString stringWithFormat:XYBString(@"str_financing_someMonth", @"%@个月"),@"0"];
    deadLineLab.textAlignment = NSTextAlignmentCenter;
    [topImgView addSubview:deadLineLab];
    
    [deadLineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topImgView.mas_centerX);
        make.bottom.equalTo(topImgView.mas_bottom).offset(-Margin_Length);
    }];
    
    
    //还款方式
    repayLab = [[UILabel alloc] initWithFrame:CGRectZero];
    repayLab.font = TEXT_FONT_BOLD_15;
    repayLab.textColor = COLOR_COMMON_WHITE;
    repayLab.text =XYBString(@"str_financing_expireBackProfitAndInvestMoney", @"到期还本息");
    repayLab.textAlignment = NSTextAlignmentCenter;
    [topImgView addSubview:repayLab];
    
    [repayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topImgView.mas_right).offset(-Margin_Length);
        make.bottom.equalTo(topImgView.mas_bottom).offset(-Margin_Length);
    }];
   
    UILabel *repaymentLab = [[UILabel alloc] initWithFrame:CGRectZero];
    repaymentLab.font = TEXT_FONT_12;
    repaymentLab.textColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:0.6];
    repaymentLab.text = XYBString(@"str_financing_backMoney_type", @"还款方式");
    repaymentLab.textAlignment = NSTextAlignmentRight;
    [topImgView addSubview:repaymentLab];
    
    [repaymentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(repayLab.mas_centerX);
        make.bottom.equalTo(topImgView.mas_bottom).offset(-35);
        
    }];
}


/**
 创建出借周期UI
 */
-(void)createMiddleUI {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    backView.tag = HISTORYRATE_TAG;
    [mainScroll addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView.mas_bottom).offset(Margin_Top);
        make.left.right.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
    }];
    
    //UI:出借周期
    UILabel *cycleTimeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    cycleTimeLab.font = TEXT_FONT_14;
    cycleTimeLab.textColor = COLOR_MAIN_GREY;
    cycleTimeLab.text = XYBString(@"str_financing_investCycleTime", @"出借周期");
    cycleTimeLab.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:cycleTimeLab];
    
    [cycleTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(Margin_Length);
        make.top.equalTo(backView.mas_top).offset(23);
    }];
    
    
    UIView *greenLine = [[UIView alloc] initWithFrame:CGRectZero];
    greenLine.backgroundColor = COLOR_LINE_GREEN;
    [backView addSubview:greenLine];
    
    [greenLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.top.equalTo(cycleTimeLab.mas_bottom).offset(41);
        make.width.equalTo(@((MainScreenWidth - 30)/8));
        make.height.equalTo(@(3));
    }];
    
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectZero];
    grayLine.backgroundColor = COLOR_LINE;
    [backView addSubview:grayLine];
    
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(greenLine.mas_right);
        make.centerY.equalTo(greenLine.mas_centerY);
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@(3));
    }];
    
    UIImageView *progress1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"progress"]];
    progress1.backgroundColor = COLOR_COMMON_WHITE;
    [greenLine addSubview:progress1];
    
    [progress1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(greenLine.mas_left);
        make.centerY.equalTo(greenLine.mas_centerY);
    }];
    
    progress2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grayProgress"]];
    progress2.backgroundColor = COLOR_COMMON_WHITE;
    [grayLine addSubview:progress2];
    
    [progress2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset((MainScreenWidth - 30)/8);
        make.centerY.equalTo(greenLine.mas_centerY);
    }];
    
    UIImageView * transferableProgress = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grayProgress"]];
    transferableProgress.backgroundColor = COLOR_COMMON_WHITE;;
    [grayLine addSubview:transferableProgress];
    
    [transferableProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progress2.mas_right).offset((MainScreenWidth - 30)/8 + 30);
        make.centerY.equalTo(greenLine.mas_centerY);
    }];
    
    UIImageView *progress3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grayProgress"]];
    progress3.backgroundColor = COLOR_COMMON_WHITE;
    [grayLine addSubview:progress3];
    
    [progress3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(grayLine.mas_right);
        make.centerY.equalTo(grayLine.mas_centerY);
    }];
    
    investLab = [[UILabel alloc] initWithFrame:CGRectZero];
    investLab.font = TEXT_FONT_14;
    investLab.textColor = COLOR_LINE_GREEN;
    investLab.text = XYBString(@"str_message_finance", @"出借");
    investLab.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:investLab];
    
    [investLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(Margin_Length);
        make.bottom.equalTo(grayLine.mas_top).offset(-9);
    }];
    
    profitLab = [[UILabel alloc] initWithFrame:CGRectZero];
    profitLab.font = TEXT_FONT_14;
    profitLab.textColor = COLOR_DETAILE_GREY;
    profitLab.text = XYBString(@"str_financing_startProfit", @"起息");
    profitLab.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:profitLab];
    
    [profitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progress2.mas_left);
        make.bottom.equalTo(grayLine.mas_top).offset(-9);
    }];
    
    transferableLab = [[UILabel alloc] initWithFrame:CGRectZero];
    transferableLab.font = TEXT_FONT_14;
    transferableLab.textColor = COLOR_DETAILE_GREY;
    transferableLab.text = XYBString(@"str_financing_transferable", @"可转让");
    transferableLab.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:transferableLab];
    
    [transferableLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(transferableProgress.mas_left);
        make.bottom.equalTo(grayLine.mas_top).offset(-9);
    }];
    
    UILabel *accountLab = [[UILabel alloc] initWithFrame:CGRectZero];
    accountLab.font = TEXT_FONT_14;
    accountLab.textColor = COLOR_DETAILE_GREY;
    accountLab.text = XYBString(@"str_financing_profitToAccount", @"到期");
    accountLab.textAlignment = NSTextAlignmentRight;
    [backView addSubview:accountLab];
    
    [accountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
        make.bottom.equalTo(grayLine.mas_top).offset(-9);
    }];
    
    time1 = [[UILabel alloc] initWithFrame:CGRectZero];
    time1.font = WEAK_TEXT_FONT_11;
    time1.textColor = COLOR_LINE_GREEN;
    time1.text = @"00-00";
    time1.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:time1];
    
    [time1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progress1.mas_left);
        make.top.equalTo(greenLine.mas_bottom).offset(11);
    }];
    
    time2 = [[UILabel alloc] initWithFrame:CGRectZero];
    time2.font = WEAK_TEXT_FONT_11;
    time2.textColor = COLOR_DETAILE_GREY;
    time2.text = @"00-00";
    time2.textAlignment = NSTextAlignmentRight;
    [backView addSubview:time2];
    
    [time2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progress2.mas_left);
        make.top.equalTo(grayLine.mas_bottom).offset(11);
    }];
    
    transferableTime = [[UILabel alloc] initWithFrame:CGRectZero];
    transferableTime.font = WEAK_TEXT_FONT_11;
    transferableTime.textColor = COLOR_DETAILE_GREY;
    transferableTime.text = [NSString stringWithFormat:XYBString(@"str_financing_mbhjgy", @"满标后%@个月"),@"0"];
    transferableTime.textAlignment = NSTextAlignmentRight;
    [backView addSubview:transferableTime];
    
    [transferableTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(transferableProgress.mas_left);
        make.top.equalTo(grayLine.mas_bottom).offset(11);
    }];
    
    time3 = [[UILabel alloc] initWithFrame:CGRectZero];
    time3.font = WEAK_TEXT_FONT_11;
    time3.textColor = COLOR_DETAILE_GREY;
    time3.text = @"00-00";
    time3.textAlignment = NSTextAlignmentRight;
    [backView addSubview:time3];
    
    [time3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(progress3.mas_right);
        make.top.equalTo(grayLine.mas_bottom).offset(11);
    }];
    
    profitDay = [[UILabel alloc] initWithFrame:CGRectZero];
    profitDay.font = TEXT_FONT_14;
    profitDay.textColor = COLOR_AUXILIARY_GREY;
    profitDay.text = [NSString stringWithFormat:XYBString(@"str_finance_jxgzr", @"• 计息日:%@"),@"0"];
    profitDay.textAlignment = NSTextAlignmentRight;
    [backView addSubview:profitDay];
    
    [profitDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(Margin_Length);
        make.top.equalTo(time1.mas_bottom).offset(22);
        make.bottom.equalTo(backView.mas_bottom).offset(-Margin_Length);
    }];
}

/**
 创建产品介绍 出借记录 风险揭示
 */
- (void)createTheThreeView {
    
    UIView *threeView = [[UIView alloc] initWithFrame:CGRectZero];
    threeView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:threeView];
    
    UIView *backView = [self.view viewWithTag:HISTORYRATE_TAG];
    [threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_bottom).offset(Margin_Top);
        make.left.right.equalTo(mainScroll);
        make.height.equalTo(@105);
        make.width.equalTo(@(MainScreenWidth));
    }];
    
    //产品介绍
    XYButton *productIntroductionBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [productIntroductionBtn setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_CLEAR] forState:UIControlStateNormal];
    [productIntroductionBtn addTarget:self action:@selector(clickProductIntroductionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [threeView addSubview:productIntroductionBtn];
    
    [productIntroductionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeView.mas_top);
        make.left.equalTo(threeView.mas_left).offset(0);
        make.width.equalTo(@((MainScreenWidth/3)));
        make.bottom.equalTo(threeView.mas_bottom);
    }];
    
    UIImageView *productIntroductionView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cg_cpjs"]];
    [threeView addSubview:productIntroductionView];
    
    [productIntroductionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(productIntroductionBtn.mas_centerX);
        make.top.equalTo(productIntroductionBtn.mas_top).offset(17);
    }];
    
    UILabel *productIntroductionLab = [[UILabel alloc] initWithFrame:CGRectZero];
    productIntroductionLab.text = XYBString(@"str_financing_productIntroduce", @"产品介绍");
    productIntroductionLab.textColor = COLOR_MAIN_GREY;
    productIntroductionLab.font = SMALL_TEXT_FONT_13;
    [productIntroductionBtn addSubview:productIntroductionLab];
    
    [productIntroductionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(productIntroductionView.mas_bottom);
        make.centerX.equalTo(productIntroductionBtn.mas_centerX);
    }];

    
    //出借记录
    XYButton *investRecordBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [investRecordBtn setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_CLEAR] forState:UIControlStateNormal];
    [investRecordBtn addTarget:self action:@selector(clickTheInvestRecordBtnBtn:) forControlEvents:UIControlEventTouchUpInside];
    [threeView addSubview:investRecordBtn];
    
    [investRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeView.mas_top);
        make.left.equalTo(productIntroductionBtn.mas_right);
        make.width.equalTo(@(MainScreenWidth/3));
        make.bottom.equalTo(threeView.mas_bottom);
    }];
    
    UIImageView *investRecordImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cg_cjjl"]];
    [threeView addSubview:investRecordImgView];
    
    [investRecordImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(investRecordBtn.mas_centerX);
        make.top.equalTo(threeView.mas_top).offset(17);
    }];
    
    UILabel *investRecordLab = [[UILabel alloc] initWithFrame:CGRectZero];
    investRecordLab.text = XYBString(@"str_financing_investRecord", @"出借记录");
    investRecordLab.font = SMALL_TEXT_FONT_13;
    investRecordLab.textColor = COLOR_MAIN_GREY;
    [investRecordBtn addSubview:investRecordLab];
    
    [investRecordLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(investRecordImgView.mas_bottom);
        make.centerX.equalTo(investRecordBtn.mas_centerX);
    }];

    
    //风险揭示
    XYButton *riskDisclosurepBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [riskDisclosurepBtn setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_CLEAR] forState:UIControlStateNormal];
    [riskDisclosurepBtn addTarget:self action:@selector(clickTheRiskDisclosureButton:) forControlEvents:UIControlEventTouchUpInside];
    [threeView addSubview:riskDisclosurepBtn];
    
    [riskDisclosurepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeView.mas_top);
        make.left.equalTo(investRecordBtn.mas_right);
        make.width.equalTo(@(MainScreenWidth / 3));
        make.bottom.equalTo(threeView.mas_bottom);
    }];
    
    UIImageView *riskDisclosurepView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cg_fxjs"]];
    [threeView addSubview:riskDisclosurepView];
    
    [riskDisclosurepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(riskDisclosurepBtn.mas_centerX);
        make.top.equalTo(riskDisclosurepBtn.mas_top).offset(17);
    }];
    
    UILabel *riskDisclosurepLab = [[UILabel alloc] initWithFrame:CGRectZero];
    riskDisclosurepLab.text = XYBString(@"str_financing_riskDisclosure", @"风险揭示");
    riskDisclosurepLab.font = SMALL_TEXT_FONT_13;
    riskDisclosurepLab.textColor = COLOR_MAIN_GREY;
    [riskDisclosurepBtn addSubview:riskDisclosurepLab];
    
    [riskDisclosurepLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(riskDisclosurepView.mas_bottom);
        make.centerX.equalTo(riskDisclosurepBtn.mas_centerX);
    }];
    
    
    //标的组成
    UIView * bdzcView = [[UIView alloc] initWithFrame:CGRectZero];
    bdzcView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:bdzcView];
    
    [bdzcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeView.mas_bottom).offset(Margin_Top);
        make.left.right.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
//        make.height.equalTo(@(375));
        make.bottom.equalTo(mainScroll.mas_bottom).offset(-111);
    }];
    
    UILabel *bdzcLab = [[UILabel alloc] initWithFrame:CGRectZero];
    bdzcLab.text = XYBString(@"str_financing_bdzc", @"标的组成");
    bdzcLab.font = BIG_TEXT_FONT_17;
    bdzcLab.textColor = COLOR_MAIN_GREY;
    [bdzcView addSubview:bdzcLab];
    
    [bdzcLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bdzcView.mas_top).offset(14);
        make.left.equalTo(@(Margin_Left));
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = COLOR_LINE;
    [bdzcView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(Line_Height));
        make.left.right.equalTo(bdzcView);
        make.top.equalTo(@(45));
    }];
    
    listView = [[NpDetailMarkFormView alloc] initWithFrame:CGRectZero productId:_productID];
    listView.backgroundColor = COLOR_COMMON_CLEAR;
    [bdzcView addSubview:listView];
    
    [listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.height.equalTo(@(340));
        make.left.right.bottom.equalTo(bdzcView);
    }];
    
    __weak NPDetailViewController *weakSelf = self;
    listView.block =^(NSString *productID) {
        NPMatchListViewController * npMatchListVc = [[NPMatchListViewController alloc] initWithNProductID:productID];
        [weakSelf.navigationController pushViewController:npMatchListVc animated:YES];
    };
    
    listView.sinBlock = ^(NPBidListModel *model) {
        
        NSString *matchType = model.matchType;
        int loanType = [model.type intValue];
        NSString *productId = model.loanId;
        NSString *subType = model.subType;
        
        // loanType   4 信农贷   5格莱珉 6信闪贷  7人人车  8租葛亮
        
        if (loanType == 6) {//信闪贷
            XsdProductDetailViewController *xsdProductDetail = [[XsdProductDetailViewController alloc] init];
            xsdProductDetail.productId = productId;
            xsdProductDetail.matchType = matchType;
            xsdProductDetail.isNP = YES;
            [weakSelf.navigationController pushViewController:xsdProductDetail animated:YES];
            
        } else if (loanType == 4) {//惠农宝
            HnbProductDetailViewController *hnbProductDetail = [[HnbProductDetailViewController alloc] init];
            hnbProductDetail.productId = productId;
            hnbProductDetail.matchType = matchType;
            hnbProductDetail.isNP = YES;
            [weakSelf.navigationController pushViewController:hnbProductDetail animated:YES];
            
        } else if (loanType == 7) {//人人车
            
            RrcProductDetailViewController *rrcProductDetail = [[RrcProductDetailViewController alloc] init];
            rrcProductDetail.productId = productId;
            rrcProductDetail.loanType =  [StrUtil isEmptyString:model.type] ? @"" : model.type;
            rrcProductDetail.matchType = matchType;
            rrcProductDetail.subType = [StrUtil isEmptyString:subType] ? @"" : subType;
            rrcProductDetail.isNP = YES;
            [weakSelf.navigationController pushViewController:rrcProductDetail animated:YES];
            
        }else if (loanType == 8) {//租葛亮
            
            ZglProductDetailViewController *zglProductDetail = [[ZglProductDetailViewController alloc] init];
            zglProductDetail.productId = productId;
            zglProductDetail.loanType =   [StrUtil isEmptyString:model.type] ? @"" : model.type;
            zglProductDetail.matchType = matchType;
            zglProductDetail.subType = [StrUtil isEmptyString:subType] ? @"" : subType;
            zglProductDetail.isNP = YES;
            [weakSelf.navigationController pushViewController:zglProductDetail animated:YES];
            
        }else if ([matchType isEqualToString:@"REBACK"]) {//债权转让
            
            ZqzrDetailViewController *zqzrDetailVC = [[ZqzrDetailViewController alloc] init];
            zqzrDetailVC.productId = productId;
            zqzrDetailVC.matchType = matchType;
            zqzrDetailVC.isNP = YES;
            [weakSelf.navigationController pushViewController:zqzrDetailVC animated:YES];
            
        }else {//信投宝
            XtbProductDetailViewController *xtbProductDetail = [[XtbProductDetailViewController alloc] init];
            xtbProductDetail.productId = productId;
            xtbProductDetail.matchType = matchType;
            xtbProductDetail.isNP = YES;
            [weakSelf.navigationController pushViewController:xtbProductDetail animated:YES];
        }
    };

    //立即出借按钮
    UIView * backButtomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 91)];
    backButtomView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:backButtomView];
    
    [backButtomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(91));
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    //添加阴影
    backButtomView.layer.shadowColor = [COLOR_SHADOW_GRAY colorWithAlphaComponent:0.1].CGColor;//阴影颜色
    backButtomView.layer.shadowOffset = CGSizeMake(0,-3);//阴影偏移,x向右偏移0，y向上偏移-3，默认(0, -3),这个跟shadowRadius配合使用
    backButtomView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    backButtomView.layer.shadowRadius = 4;//阴影半径，默认3
    
    restLab = [[UILabel alloc] initWithFrame:CGRectZero];
    restLab.font = TEXT_FONT_12;
    restLab.textColor = COLOR_MAIN_GREY;
    restLab.text = [NSString stringWithFormat:XYBString(@"str_financing_restAmount", @"剩余额度%@元"),@"0"];
    [backButtomView addSubview:restLab];
    
    [restLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backButtomView.mas_centerX);
        make.top.equalTo(backButtomView.mas_top).offset(12);
    }];
    
    investBtn = [[ColorButton alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"str_financing_investedImmidiate", @"立即出借")  ByGradientType:leftToRight];
    [investBtn addTarget:self action:@selector(clickTheInvestBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backButtomView addSubview:investBtn];
    
    [investBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backButtomView.mas_centerX);
        make.top.equalTo(restLab.mas_bottom).offset(9);
        make.height.equalTo(@(Cell_Height));
        make.width.equalTo(@(MainScreenWidth - 30));
    }];
}


/**
 创建新产品介绍3页面
 */
- (void)createIntroduceThirdView {
    
    backview = [[UIView alloc] initWithFrame:self.view.bounds];
    backview.backgroundColor = COLOR_COMMON_BLACK_TRANS_75;
    [self.view addSubview:backview];
    
    NSString *imageName = @"newProGuide3";
    UIImage *guide_1 = [UIImage imageNamed:imageName];
    CGSize image_size = guide_1.size;
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageview.image = guide_1;
    [backview addSubview:imageview];
    
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backview);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenWidth * image_size.height / image_size.width));
    }];
    
    UIImage *btn_iKnowImage = [UIImage imageNamed:@"btn_iKnow"];
    CGSize iKnowImage_size = btn_iKnowImage.size;
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setBackgroundImage:btn_iKnowImage forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(clickIntroduceThirdButton:) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:nextBtn];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageview.mas_bottom).offset(0);
        make.right.equalTo(@(-Margin_Length));
        make.width.equalTo(@(iKnowImage_size.width));
        make.height.equalTo(@(iKnowImage_size.height));
    }];
}

#pragma mark - 刷新UI

- (void)refreshUI:(NProductDetailResModel *)model {
    
    if (model) {
        
        self.navItem.title = model.productInfo.name;
        
        NSString *rateStr = [Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[model.productInfo.rate doubleValue] * 100]];
        rateStr = [rateStr stringByAppendingString:XYBString(@"str_financing_percentSymbol", @"%")];
        
        //综合约定年化利率
        NSMutableAttributedString *mutAttStr2 = [[NSMutableAttributedString alloc] initWithString:rateStr];
        [mutAttStr2 addAttributes:@{ NSFontAttributeName : XTB_RATE_FONT,
                                     NSForegroundColorAttributeName : COLOR_COMMON_WHITE }
                            range:NSMakeRange(0, rateStr.length - 1)];
        [mutAttStr2 addAttributes:@{ NSFontAttributeName : TEXT_FONT_12,
                                     NSForegroundColorAttributeName : COLOR_COMMON_WHITE }
                            range:NSMakeRange(rateStr.length - 1 , 1)];
        rateLab.attributedText = mutAttStr2;
        
        
        //起投金额
        minAmountLab.text = [Utility replaceTheNumberForNSNumberFormatter:model.productInfo.minInvestAmount];
        
        //锁定期
        NSString *lockTime;//锁定期字符串
        if ([model.productInfo.lockMonths intValue] > 0) {
            lockTime = [NSString stringWithFormat:@"%@个月",model.productInfo.lockMonths];
        } else {
            lockTime = [NSString stringWithFormat:@"%@天", model.productInfo.lockMonths];
        }
        deadLineLab.text = lockTime;
        
        //还款方式
        repayLab.text = [NSString stringWithFormat:@"%@", model.productInfo.repayTypeStr];
        
        //1.出借日期、2.起息日期、3.可转让日期、4.到期日期
        NSDate *date = [self stringToDate:model.productInfo.currDate withDateFormat:@"yyyy-MM-dd"];
        BOOL isThisYear = [self isThisYearWithDate:date];
        
        if (isThisYear) {
            time1.text = [model.productInfo.currDate substringFromIndex:5];
        }else{
            time1.text = model.productInfo.currDate;
        }
        
        time2.text = XYBString(@"str_financing_bidFullDay", @"满标日");
        
        //可转让日期
        transferableTime.text = [NSString stringWithFormat:XYBString(@"str_financing_mbhFreedom", @"满标后%@"),lockTime];
        
        //到期日期
        NSString *loanTime;
        if ([model.productInfo.loanMonths intValue] > 0  && [model.productInfo.loanDays intValue] > 0) {
            loanTime = [NSString stringWithFormat:@"%@个月%@天",model.productInfo.loanMonths,model.productInfo.loanDays];
        }else{
            
            if ([model.productInfo.loanMonths intValue] > 0 && [model.productInfo.loanDays intValue] <= 0) {
                loanTime = [NSString stringWithFormat:@"%@个月", model.productInfo.loanMonths];
            }else if ([model.productInfo.loanDays intValue] > 0 && [model.productInfo.loanMonths intValue] <= 0) {
                loanTime = [NSString stringWithFormat:@"%@天", model.productInfo.loanDays];
            }else{
                loanTime = [NSString stringWithFormat:@"%@天", model.productInfo.loanDays];
            }
        }
        time3.text = [NSString stringWithFormat:XYBString(@"str_financing_mbhFreedom", @"满标后%@"),loanTime];
        
        profitDay.text = XYBString(@"str_financing_gsbmbzrqdljx", @"• 计息日: 各散标满标之日起独立计息");
        
        //刷新标的组成
        [listView reloadWithDataSourse:model.bidList];
        
        if (model.bidList.count == 5) {
            [listView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(340));
            }];
            
        } else if (model.bidList.count < 5 && model.bidList.count > 0) {
            [listView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(50.f * model.bidList.count +  Cell_Height * 2));
            }];
        }
        
        if ([model.productInfo.restAmount doubleValue] <= 0) {
            restLab.text = [NSString stringWithFormat:XYBString(@"str_financing_restAmount", @"剩余额度%@元"), @"0.00"];
            investBtn.isColorEnabled = NO;
            [investBtn setTitle:XYBString(@"str_financing_haveSoldOut", @"已售罄") forState:UIControlStateNormal];
            
        }else{
            restLab.text = [NSString stringWithFormat:XYBString(@"str_financing_restAmount", @"剩余额度%@元"), [Utility replaceTheNumberForNSNumberFormatter:model.productInfo.restAmount]];
            investBtn.isColorEnabled = YES;
            [investBtn setTitle:XYBString(@"str_financing_investedImmidiate", @"立即出借") forState:UIControlStateNormal];
        }
        
    }else{
        investBtn.isColorEnabled = NO;
    }
}

-(void)setShowThirdView:(BOOL)showThirdView {
    _showThirdView = showThirdView;
    [self createIntroduceThirdView];
}

//字符串转日期格式
- (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

/**
 *  是否为今年
 */
- (BOOL)isThisYearWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得date的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date];
    
    if (nowCmps.year == selfCmps.year) {
        return YES;
    }
    
    return NO;
}

#pragma mark - 点击事件

-(void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickIntroduceThirdButton:(id)sender {

    //记录状态
    [UserDefaultsUtil setNewFunction];
    
    NSArray *viewArr = backview.subviews;
    for (UIView *subview in viewArr) {
        [subview removeFromSuperview];
    }
    [backview removeFromSuperview];
}

//产品介绍
-(void)clickProductIntroductionBtn:(id)sender {
    NPIntroduceViewController * introduceVC = [[NPIntroduceViewController alloc] init];
    introduceVC.navItem.title = XYBString(@"str_financing_productIntroduce", @"产品介绍");
    [self.navigationController pushViewController:introduceVC animated:YES];
}

//出借记录
-(void)clickTheInvestRecordBtnBtn:(id)sender {
    NPLoanRecordViewController * nploanRecord = [[NPLoanRecordViewController alloc] initWithNProductID:_productID];
    [self.navigationController pushViewController:nploanRecord animated:YES];
}

//风险揭示
-(void)clickTheRiskDisclosureButton:(id)sender {
    NSString *requestUrl = [RequestURL getNodeJsH5URL:App_Risk_Show_URL withIsSign:NO];
    XYWebViewController *webView = [[XYWebViewController alloc] initWithTitle:nil webUrlString:requestUrl];
    [self.navigationController pushViewController:webView animated:YES];
}

//立即出借
-(void)clickTheInvestBtn:(id)sender {
    NPInvestViewController * npinvest = [[NPInvestViewController alloc] initWithProductId:_productID];
    [self.navigationController pushViewController:npinvest animated:YES];
}

#pragma mark - 新产品详情

- (void)callOneKeyProductDetailWebService {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[UserDefaultsUtil getUser].userId forKey:@"userId"];
    [params setValue:self.productID forKey:@"productId"];
    [self requestOneKeyProductDetailWebServiceWithParams:[params copy]];
}

- (void)requestOneKeyProductDetailWebServiceWithParams:(NSDictionary *)param {
    
    NSString *requestURL = [RequestURL getRequestURL:OneKeyProductDetail_URL param:param];
    [self showDataLoading];
    
    [WebService postRequest:requestURL param:param JSONModelClass:[NProductDetailResModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        NProductDetailResModel *model = responseObject;
                        [self refreshUI:model];
                        
                    } fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                        [self hideLoading];
                        [self showPromptTip:errorMessage];
                    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
