//
//  NewDqbProductDetailViewController.m
//  Ixyb
//
//  Created by dengjian on 11/20/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "DqbProductDetailViewController.h"

#import "CcProduct.h"
#import "CcProductResponseModel.h"
#import "DqInfoView.h"
#import "DqbDetailResponseModel.h"
#import "DqbInvestRecordViewController.h"
#import "H5UrlDefine.h"
#import "InfoView.h"
#import "LoginFlowViewController.h"
#import "LoginFlowViewController.h"
#import "MJExtension.h"
#import "ProductProgressView.h"
#import "RiskEvaluatingViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "XYAlertView.h"
#import "AssetListViewController.h"
#import "DqbIntroduceViewController.h"
#import "DqbRedeemViewController.h"
#import "DqbInvestViewController.h"

#define VIEW_TAG_PRODUCT_INFO_VIEW 1000
#define HISTORYRATE_TAG 1001

@interface DqbProductDetailViewController () <InfoViewDelegate>

@end

@implementation DqbProductDetailViewController {
    
    XYScrollView *mainScroll;
    UIImageView *topImgView;    //顶部UI的底图
    
    UILabel *timeLab;           //周周盈的可投次数
    UILabel *rateLab;           //利率
    UILabel *minAmountLab;      //起借金额
    UILabel *deadLineLab;       //出借期限
    UILabel *repayLab;          //还款方式
    
    UIImageView *progress2;
    UILabel *investLab;         //出借
    UILabel *profitLab;         //起息
    UILabel *time1;             //出借日期
    UILabel *time2;             //起息日期
    UILabel *time3;             //到账日期
    UILabel *profitDay;         //• 计息日:T+1计息，每月增+1%
    ColorButton *investBtn;
    
    UILabel *titleLab;    //产品名称
    UILabel *standardLab; //0个月起 先息后本
    UILabel *restLab;     //剩余可投金额
    
    InfoView *restInfoView;
    XYButton *investRecordBtn;    //出借记录
    XYButton *containBtn;         //标的组成
    XYButton * riskDisclosureBtn; //风险揭示
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self createTopUI];
    [self createMiddleUI];
    [self createThirdUI];
    [self callDqbDetailWebService];
}

- (void)setNav {
    self.navItem.title = XYBString(@"str_common_dqb", @"定期宝");
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
    
    topImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bbgBackImage"]];
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
    lab.text = XYBString(@"str_bbg_dq_rate", @"历史年化结算利率");
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
    

    //期限
    UILabel *deadLab = [[UILabel alloc] initWithFrame:CGRectZero];
    deadLab.font = TEXT_FONT_12;
    deadLab.textColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:0.6];
    deadLab.text = XYBString(@"str_financing_timeLimit", @"期限");
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
        make.top.equalTo(topImgView.mas_bottom).offset(11);
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
 创建UI中的第三部分：产品介绍、赎回规则、标的组成、出借记录、出借按钮
 */
- (void)createThirdUI {
    
    //产品介绍
    XYButton *introduceBtn = [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_financing_productIntroduce", @"产品介绍") titleColor:COLOR_MAIN_GREY isUserInteractionEnabled:YES];
    introduceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    introduceBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 51, 0, 0);
    [introduceBtn addTarget:self action:@selector(clickTheIntroduceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:introduceBtn];
    
    UIView *topView = [mainScroll viewWithTag:HISTORYRATE_TAG];
    [introduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.width.equalTo(@(MainScreenWidth));
        make.top.equalTo(topView.mas_bottom).offset(10);
        make.height.equalTo(@(Cell_Height));
    }];
    
    UIImageView *introduceImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [introduceImage setImage:[UIImage imageNamed:@"introduceImage"]];
    introduceImage.userInteractionEnabled = NO;
    [introduceBtn addSubview:introduceImage];
    
    [introduceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(introduceBtn.mas_left).offset(Margin_Length);
        make.centerY.equalTo(introduceBtn.mas_centerY);
    }];
    
    UIImageView *cellArrow1 = [[UIImageView alloc] init];
    cellArrow1.image = [UIImage imageNamed:@"cell_arrow"];
    [introduceBtn addSubview:cellArrow1];
    
    [cellArrow1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(introduceBtn.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(introduceBtn.mas_centerY);
    }];
    
    UILabel *introduceLab = [[UILabel alloc] initWithFrame:CGRectZero];
    introduceLab.font = TEXT_FONT_14;
    introduceLab.textColor = COLOR_AUXILIARY_GREY;
    introduceLab.text = XYBString(@"str_finance_profitAndProfitRule", @"收益、计息规则");
    [introduceBtn addSubview:introduceLab];
    
    [introduceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cellArrow1.mas_left).offset(-6);
        make.centerY.equalTo(cellArrow1.mas_centerY);
    }];
    
    [XYCellLine initWithBottomLine_2_AtSuperView:introduceBtn];
    
    //赎回规则
    XYButton *ruleBtn = [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_financing_back_rule", @"赎回规则") titleColor:COLOR_MAIN_GREY isUserInteractionEnabled:YES];
    ruleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    ruleBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 51, 0, 0);
    [ruleBtn addTarget:self action:@selector(clickInvestTheRuleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:ruleBtn];
    
    [ruleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.width.equalTo(@(MainScreenWidth));
        make.top.equalTo(introduceBtn.mas_bottom).offset(0);
        make.height.equalTo(@(Cell_Height + 1));
    }];
    
    UIImageView *ruleImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [ruleImage setImage:[UIImage imageNamed:@"ruleImage"]];
    [ruleBtn addSubview:ruleImage];
    
    [ruleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ruleBtn.mas_left).offset(Margin_Length);
        make.centerY.equalTo(ruleBtn.mas_centerY);
    }];
    
    UIImageView *cellArrow2 = [[UIImageView alloc] init];
    cellArrow2.image = [UIImage imageNamed:@"cell_arrow"];
    [ruleBtn addSubview:cellArrow2];
    
    [cellArrow2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ruleBtn.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(ruleBtn.mas_centerY);
    }];
    
    //标的组成
    containBtn = [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_financing_bidContains", @"标的组成") titleColor:COLOR_MAIN_GREY isUserInteractionEnabled:YES];
    containBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    containBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 51, 0, 0);
    [containBtn addTarget:self action:@selector(clickTheContainButton:) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:containBtn];
    
    [containBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.width.equalTo(@(MainScreenWidth));
        make.top.equalTo(ruleBtn.mas_bottom).offset(10);
        make.height.equalTo(@(Cell_Height));
    }];
    
    UIImageView *containImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [containImage setImage:[UIImage imageNamed:@"containImage"]];
    [containBtn addSubview:containImage];
    
    [containImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containBtn.mas_left).offset(Margin_Length);
        make.centerY.equalTo(containBtn.mas_centerY);
    }];
    
    UIImageView *cellArrow3 = [[UIImageView alloc] init];
    cellArrow3.image = [UIImage imageNamed:@"cell_arrow"];
    [containBtn addSubview:cellArrow3];
    
    [cellArrow3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(containBtn.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(containBtn.mas_centerY);
    }];
    
    [XYCellLine initWithBottomLine_2_AtSuperView:containBtn];
    
    //出借记录
    investRecordBtn = [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_financing_investRecord", @"出借记录") titleColor:COLOR_MAIN_GREY isUserInteractionEnabled:YES];
    investRecordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    investRecordBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 51, 0, 0);
    [investRecordBtn addTarget:self action:@selector(clickTheInvestRecordBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:investRecordBtn];
    
    [investRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.width.equalTo(@(MainScreenWidth));
        make.top.equalTo(containBtn.mas_bottom).offset(0);
        make.height.equalTo(@(Cell_Height));
    }];
    
    UIImageView *investRecordImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [investRecordImage setImage:[UIImage imageNamed:@"investRecordImage"]];
    [investRecordBtn addSubview:investRecordImage];
    
    [investRecordImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(investRecordBtn.mas_left).offset(Margin_Length);
        make.centerY.equalTo(investRecordBtn.mas_centerY);
    }];
    
    UIImageView *cellArrow4 = [[UIImageView alloc] init];
    cellArrow4.image = [UIImage imageNamed:@"cell_arrow"];
    [investRecordBtn addSubview:cellArrow4];
    
    [cellArrow4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(investRecordBtn.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(investRecordBtn.mas_centerY);
    }];
    
    //风险揭示
    riskDisclosureBtn = [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_financing_riskDisclosure", @"风险揭示") titleColor:COLOR_MAIN_GREY isUserInteractionEnabled:YES];
    riskDisclosureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    riskDisclosureBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 51, 0, 0);
    [riskDisclosureBtn addTarget:self action:@selector(clickTheRiskDisclosureButton:) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:riskDisclosureBtn];
    
    [riskDisclosureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.width.equalTo(@(MainScreenWidth));
        make.top.equalTo(investRecordBtn.mas_bottom).offset(10);
        make.height.equalTo(@(Cell_Height));
        make.bottom.equalTo(mainScroll.mas_bottom).offset(-111);
    }];
    
    UIImageView *riskDisclosureImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [riskDisclosureImage setImage:[UIImage imageNamed:@"riskRrompt"]];
    [riskDisclosureBtn addSubview:riskDisclosureImage];
    
    [riskDisclosureImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(riskDisclosureBtn.mas_left).offset(Margin_Length);
        make.centerY.equalTo(riskDisclosureBtn.mas_centerY);
    }];
    
    UIImageView *cellArrow5 = [[UIImageView alloc] init];
    cellArrow5.image = [UIImage imageNamed:@"cell_arrow"];
    [riskDisclosureBtn addSubview:cellArrow5];
    
    [cellArrow5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(riskDisclosureBtn.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(riskDisclosureBtn.mas_centerY);
    }];
    
    //立即出借按钮
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 91)];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(91));
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    //添加阴影
    backView.layer.shadowColor = [COLOR_SHADOW_GRAY colorWithAlphaComponent:0.1].CGColor;//阴影颜色
    backView.layer.shadowOffset = CGSizeMake(0,-3);//阴影偏移,x向右偏移0，y向上偏移-3，默认(0, -3),这个跟shadowRadius配合使用
    backView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    backView.layer.shadowRadius = 4;//阴影半径，默认3
    
    restLab = [[UILabel alloc] initWithFrame:CGRectZero];
    restLab.font = TEXT_FONT_12;
    restLab.textColor = COLOR_MAIN_GREY;
    restLab.text = [NSString stringWithFormat:XYBString(@"str_financing_restAmount", @"剩余额度%@元"),@"0"];
    [backView addSubview:restLab];
    
    [restLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.top.equalTo(backView.mas_top).offset(12);
    }];
    
    investBtn = [[ColorButton alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"str_financing_investedImmidiate", @"立即出借")  ByGradientType:leftToRight];
    [investBtn addTarget:self action:@selector(clickTheInvestBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:investBtn];
    
    [investBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.top.equalTo(restLab.mas_bottom).offset(9);
        make.height.equalTo(@(Cell_Height));
        make.width.equalTo(@(MainScreenWidth - 30));
    }];
}

#pragma mark - 数据请求成功，刷新UI

- (void)refreshUI {
    
    if (_ccProduct) {
        
        self.navItem.title = [NSString stringWithFormat:XYBString(@"str_financing_dqb_investBid", @"定期宝-%@"),_ccProduct.typeStr];
        
        if ([_ccProduct.type isEqualToString:@"ZZY"] && [_ccProduct.restInvestCount intValue] > 0) {
            timeLab.hidden = NO;
            timeLab.text = [NSString stringWithFormat:XYBString(@"str_financing_restTimes", @"%@次可投"),_ccProduct.restInvestCount];
        }
        
        titleLab.text = [NSString stringWithFormat:@"%@", _ccProduct.typeStr];
        
        NSString *rateStr = [[Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[_ccProduct.rate doubleValue] * 100]] stringByAppendingString:XYBString(@"str_financing_percentSymbol", @"%")];
        
        //历史年化结算利率
        NSMutableAttributedString *mutAttStr2 = [[NSMutableAttributedString alloc] initWithString:rateStr];
        [mutAttStr2 addAttributes:@{ NSFontAttributeName : XTB_RATE_FONT,
                                     NSForegroundColorAttributeName : COLOR_COMMON_WHITE }
                            range:NSMakeRange(0, rateStr.length - 1)];
        [mutAttStr2 addAttributes:@{ NSFontAttributeName : TEXT_FONT_12,
                                     NSForegroundColorAttributeName : COLOR_COMMON_WHITE }
                            range:NSMakeRange(rateStr.length - 1 , 1)];
        rateLab.attributedText = mutAttStr2;
        
        //起投金额
        minAmountLab.text = [Utility replaceTheNumberForNSNumberFormatter:_ccProduct.minBidAmount];
        
        //出借期限
        deadLineLab.text = [NSString stringWithFormat:@"%@", _ccProduct.periodsStr];
        
        //还款方式
        repayLab.text = [NSString stringWithFormat:@"%@", _ccProduct.refundTypeString];

    
        //1.出借日期、2.起息日期、3.到账日期
        NSDate *date = [self stringToDate:_ccProduct.orderDate withDateFormat:@"yyyy-MM-dd"];
        BOOL isThisYear = [self isThisYearWithDate:date];
        
        if (isThisYear) {
            time1.text = [_ccProduct.orderDate substringFromIndex:5];
        }else{
            time1.text = _ccProduct.orderDate;
        }
        
        NSString *timeStr2 = [_ccProduct.interestDate substringFromIndex:5];
        time2.text = timeStr2;
        
        time3.text = _ccProduct.refundDate;
        
        //计息日
        if ([_ccProduct.type isEqualToString:@"ZZY"]) {
            profitDay.text = [NSString stringWithFormat:@"• %@",_ccProduct.interestDay];
            investLab.text = XYBString(@"str_message_cjbqx", @"出借并起息");
            progress2.hidden = YES;
            profitLab.hidden = YES;
            time2.hidden = YES;
        
        }else{
            profitDay.text = [NSString stringWithFormat:XYBString(@"str_finance_jxgzr", @"• 计息日:%@"),_ccProduct.interestDay];
        }
        
        //剩余额度
        NSString *restStr;
        if ([_ccProduct.restAmount doubleValue] <= 0) {
            restStr = [NSString stringWithFormat:XYBString(@"str_financing_restAmount", @"剩余额度%@元"), @"0.00"];
        }else{
            restStr = [NSString stringWithFormat:XYBString(@"str_financing_restAmount", @"剩余额度%@元"), [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [_ccProduct.restAmount doubleValue]]]];
        }
        
        NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc] initWithString:restStr];
        [attributStr addAttribute:NSForegroundColorAttributeName value:COLOR_RED_LEVEL1 range:NSMakeRange(4, restStr.length - 5)];
        restLab.attributedText = attributStr;
        
        if ([_ccProduct.restAmount doubleValue] <= 0) {
            investBtn.isColorEnabled = NO;
            [investBtn setTitle:XYBString(@"str_financing_haveSoldOut", @"已售罄") forState:UIControlStateNormal];
        }else{
            investBtn.isColorEnabled = YES;
            [investBtn setTitle:XYBString(@"str_financing_investedImmidiate", @"立即出借") forState:UIControlStateNormal];
        }
        
    }else{
        investBtn.isColorEnabled = NO;
    }
}
    
//    //restInfoView赋值
//    NSString *infoStr = [NSString stringWithFormat:XYBString(@"str_financing_sigleTradeAmount", @"单笔额度上限：单笔出借和当日出借笔数均无上限\n到期赎回方式：平台自动返还剩余本金和当期利息\n提前赎回方式：不支持提前赎回\n账户管理费率：暂时不收取\n计息日：T(出借日)+1工作日\n提现到账日：T（提现申请日）+1工作日"), newCcProduct.interestDay];
//    
//    if ([newCcProduct.type isEqualToString:@"ZZY"]) {
//        infoStr = [NSString stringWithFormat:XYBString(@"str_financing_dqb_jrmk", @"加入门槛：① 新用户专享(首次出借用户) ;② 最低100元起,购买上限为10万 ;③ 每个用户最多%@次;\n到期赎回方式：平台自动返还剩余本金和当期利息\n提前赎回方式：不支持提前赎回\n账户管理费率：暂时不收取\n计息日：T(出借日)+1工作日\n提现到账日：T（提现申请日）+1工作日"), newCcProduct.zzyDefaultCount, newCcProduct.interestDay];
//        
//    } else if ([newCcProduct.type isEqualToString:@"CCNY"]) {
//        infoStr = [NSString stringWithFormat:XYBString(@"str_financing_sigleTradeAmount_NY", @"单笔额度上限：单笔出借和当日出借笔数均无上限\n到期赎回方式：平台自动返还剩余本金和当期利息\n提前赎回方式：4个月后可以赎回，收取5%%的违约金\n账户管理费率：暂时不收取\n计息日：T(出借日)+1工作日\n提现到账日：T（提现申请日）+1工作日"), newCcProduct.interestDay];
//        
//    } else if ([newCcProduct.type isEqualToString:@"CCNNY"] || [newCcProduct.type isEqualToString:@"CCJJY"]) {
//        infoStr = [NSString stringWithFormat:XYBString(@"str_financing_sigleTradeAmount_NNYJJY", @"单笔额度上限：单笔出借和当日出借笔数均无上限\n到期赎回方式：平台自动返还剩余本金和当期利息\n提前赎回方式：12个月后可以赎回，收取5%%的违约金\n账户管理费率：暂时不收取\n计息日：T(出借日)+1工作日\n提现到账日：T（提现申请日）+1工作日"), newCcProduct.interestDay];
//    }
//    
//    float height1 = [ToolUtil getLabelHightWithLabelStr:@"单笔额度上限：单笔出借和当日出借笔数均无上限" MaxSize:CGSizeMake(MainScreenWidth - 30, MainScreenHeight) AndFont:14 LineSpace:6];
//    float height2 = [ToolUtil getLabelHightWithLabelStr:@"加入门槛：① 新用户专享(首次出借用户) ;② 最低100元起,购买上限为10万 ;③ 每个用户最多%@次;" MaxSize:CGSizeMake(MainScreenWidth - 30, MainScreenHeight) AndFont:14 LineSpace:6];
//    
//    float height3 = [ToolUtil getLabelHightWithLabelStr:@"到期赎回方式：平台自动返还剩余本金和当期利息" MaxSize:CGSizeMake(MainScreenWidth - 30, MainScreenHeight) AndFont:14 LineSpace:6];
//    float height4 = [ToolUtil getLabelHightWithLabelStr:@"提前赎回方式：12个月后可以赎回，收取5%%的违约金" MaxSize:CGSizeMake(MainScreenWidth - 30, MainScreenHeight) AndFont:14 LineSpace:6];
//    float height5 = [ToolUtil getLabelHightWithLabelStr:@"提前赎回方式：不支持提前赎回" MaxSize:CGSizeMake(MainScreenWidth - 30, MainScreenHeight) AndFont:14 LineSpace:6];
//    float height6 = [ToolUtil getLabelHightWithLabelStr:@"计息日：T(出借日)+1工作日" MaxSize:CGSizeMake(MainScreenWidth - 30, MainScreenHeight) AndFont:14 LineSpace:6];
//    float height7 = [ToolUtil getLabelHightWithLabelStr:@"提现到账日：T（提现申请日）+1工作日" MaxSize:CGSizeMake(MainScreenWidth - 30, MainScreenHeight) AndFont:14 LineSpace:6];
//    
//    [restInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
//        
//        if ([newCcProduct.type isEqualToString:@"ZZY"]) {
//            make.height.equalTo(@(height2 + height3 + height5*2 + 30 + 46 +16 + height6 + height7));
//            
//        } else if ([newCcProduct.type isEqualToString:@"CCNY"]) {
//            make.height.equalTo(@(height1 + height3 + height4 + height5 + 30 + 46 + 16 + height6 + height7 ));
//            
//        } else if ([newCcProduct.type isEqualToString:@"CCNNY"] || [newCcProduct.type isEqualToString:@"CCJJY"]) {
//            make.height.equalTo(@(height1 + height3 + height4 + height5 + 30 + 46 + 16 + height6 + height7));
//            
//        }else{
//            make.height.equalTo(@(height1 + height3 + height5*2 + 30 + 46 + 16 + height6 + height7));
//        }
//    }];
//    
//    restInfoView.info = infoStr;

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

// 产品介绍
- (void)clickTheIntroduceBtn:(id)sender {
    
    DqbIntroduceViewController *introduceVc = [[DqbIntroduceViewController alloc] initWithDqbModel:_ccProduct];
    [self.navigationController pushViewController:introduceVc animated:YES];
}

// 赎回规则
- (void)clickInvestTheRuleBtn:(id)sender {
    DqbRedeemViewController *dqbRuleVc = [[DqbRedeemViewController alloc] initWithDqbProductModel:_ccProduct];
    [self.navigationController pushViewController:dqbRuleVc animated:YES];
}

// 标的组成
- (void)clickTheContainButton:(id)sender {
    AssetListViewController *assetVC = [[AssetListViewController alloc] init];
    assetVC.projectId = _ccProduct.ccId;
    assetVC.productType = _ccProduct.type;
    assetVC.state = [_ccProduct.state intValue];
    assetVC.amountStr = _ccProduct.amount;
    [self.navigationController pushViewController:assetVC animated:YES];
}

// 出借记录
- (void)clickTheInvestRecordBtn:(id)sender {
    DqbInvestRecordViewController *recordViewController = [[DqbInvestRecordViewController alloc] init];
    recordViewController.bidRequestIdStr = _ccProduct.ccId;
    [self.navigationController pushViewController:recordViewController animated:YES];
}

// 风险揭示
- (void)clickTheRiskDisclosureButton:(id)sender
{
    NSString *requestUrl = [RequestURL getNodeJsH5URL:App_Risk_Show_URL withIsSign:NO];
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:nil webUrlString:requestUrl];
    [self.navigationController pushViewController:webView animated:YES];
}

// 立即出借
- (void)clickTheInvestBtn:(id)sender {
    DqbInvestViewController *investVC = [[DqbInvestViewController alloc] init];
    investVC.ccInfo = _ccProduct;
    [self.navigationController pushViewController:investVC animated:YES];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - InfoView Delegate

- (void)infoView:(InfoView *)infoView didSelectLinkWithURL:(NSURL *)url {
    if ([url.description isEqualToString:@"aqbz"]) {
        NSString *urlStr = [RequestURL getNodeJsH5URL:App_Safe_URL withIsSign:NO];
        NSString *titleStr = XYBString(@"str_financing_safeAssert", @"安全保障");
        WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
        [self.navigationController pushViewController:webView animated:YES];
    }
}

#pragma mark - 定期宝详情Webservice

- (void)callDqbDetailWebService {
    
    NSDictionary *param = @{
                            @"bidRequestId" : self.productId,
                            @"userId" : [Utility shareInstance].isLogin ? [UserDefaultsUtil getUser].userId : @"0"
                            };
    
    [self requestDqbDetailWebServiceWithParam:param];
}

- (void)requestDqbDetailWebServiceWithParam:(NSDictionary *)param {
    NSString *requestURL = [RequestURL getRequestURL:CcDetailURL param:param];
    
    [self showDataLoading];
    [WebService postRequest:requestURL param:param JSONModelClass:[DqbDetailResponseModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        DqbDetailResponseModel *responseModel = responseObject;
                        _ccProduct = responseModel.product;
                        [self refreshUI];
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
}

@end
