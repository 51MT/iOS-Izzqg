//
//  BbgDetailViewController.m
//  Ixyb
//
//  Created by wangjianimac on 15/12/8.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "BbgDetailViewController.h"

#import "BbgDetailResponseModel.h"
#import "BbgInvestRecordViewController.h"
#import "BbgInvestViewController.h"
#import "FoldingView.h"
#import "LoginFlowViewController.h"
#import "LoginFlowViewController.h"
#import "MJExtension.h"
#import "RiskEvaluatingViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "XYAlertView.h"
#import "AssetListViewController.h"
#import "BbgIntroduceViewController.h"
#import "BbgRedeemViewController.h"
#import "XYWebViewController.h"
#import "WebviewViewController.h"

#define PROGRESSBACKIMAGETAG 1000
#define INVEST_CYCLEDAY_TAG 1001
#define HISTORYRATE_TAG 1002
@interface BbgDetailViewController () {
    
    XYScrollView *mainScroll;
    UIImageView *topImgView;    //顶部UI的底图
    
    UILabel *rateLab;           //利率
    UILabel *minAmountLab;      //起借金额
    UILabel *deadLineLab;       //出借期限
    UILabel *repayLab;          //还款方式
    
    UILabel *time1;             //出借日期
    UILabel *time2;             //起息日期
    UILabel *time3;             //到账日期
    UILabel *profitDay;         //• 计息日:T+1计息，每月增+1%
    
    UILabel *historyLab;        //• 历史年化结算利率8%起步，按自然月......
    UILabel *restLab;           //剩余可投金额
    
    UIView *describeView;     //将收益规则+转入及计息规则+退出规则+风控措施等包裹起来的view
    
    XYButton *investRecordBtn;//出借记录
    XYButton *containBtn;     //标的组成
    ColorButton *investBtn;
    XYButton * riskDisclosureBtn; //风险揭示
    int state;                //状态：因为正常标和预约标不同，state不一样，不能从前面带入数据源，必须取详情界面请求数据后得到的状态值
}
@end

@implementation BbgDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestTheBbgDetailWebService];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BG;
    [self setNav];
    [self createTopUI];
    [self createMiddleUI];
    [self createThirdUI];
}

- (void)setNav {
    self.navItem.title = XYBString(@"str_common_bbg", @"步步高");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
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
        make.width.equalTo(@(MainScreenWidth));
    }];
    
    topImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"np_backImage"]];
    [mainScroll addSubview:topImgView];
    
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenWidth * 158/375));
    }];
    
    //起借
    rateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    rateLab.font = XTB_RATE_FONT;
    rateLab.textColor = COLOR_ORANGE;
    rateLab.text = XYBString(@"str_financing_defaultZeroPercent", @"0-0%");
    rateLab.textAlignment = NSTextAlignmentCenter;
    [topImgView addSubview:rateLab];
    
    [rateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topImgView.mas_centerX);
        make.top.equalTo(topImgView.mas_top).offset(Margin_Length);
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
    minTitleLab.font = WEAK_TEXT_FONT_11;
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
    deadLab.font = WEAK_TEXT_FONT_11;
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
    deadLineLab.text = [NSString stringWithFormat:XYBString(@"str_financing_investTimeAtLeast", @"%@个月起"),@"0"];
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
    repayLab.text =XYBString(@"bbg_repaymentStyle", @"先息后本");
    repayLab.textAlignment = NSTextAlignmentCenter;
    [topImgView addSubview:repayLab];
    
    [repayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topImgView.mas_right).offset(-Margin_Length);
        make.bottom.equalTo(topImgView.mas_bottom).offset(-Margin_Length);
    }];
    
    UILabel *repaymentLab = [[UILabel alloc] initWithFrame:CGRectZero];
    repaymentLab.font = WEAK_TEXT_FONT_11;
    repaymentLab.textColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:0.6];
    repaymentLab.text = XYBString(@"str_financing_backMoney_type", @"还款方式");
    repaymentLab.textAlignment = NSTextAlignmentRight;
    [topImgView addSubview:repaymentLab];
    
    [repaymentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(repayLab.mas_centerX);
        make.bottom.equalTo(topImgView.mas_bottom).offset(-35);
    }];
    
    //默认显示_bbgProduct的数据，待数据请求成功后，显示最新数据
    if (_bbgProduct) {
        [self reloadTheDataForUI:_bbgProduct];
    }
}

-(void)createMiddleUI {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    backView.tag = INVEST_CYCLEDAY_TAG;
    [mainScroll addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView.mas_bottom).offset(11);
        make.left.right.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
    }];
    
    //UI:出借周期
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = TEXT_FONT_14;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = XYBString(@"str_financing_investCycleTime", @"出借周期");
    titleLab.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(Margin_Length);
        make.top.equalTo(backView.mas_top).offset(23);
    }];
    
    
    UIView *greenLine = [[UIView alloc] initWithFrame:CGRectZero];
    greenLine.backgroundColor = COLOR_LINE_GREEN;
    [backView addSubview:greenLine];
    
    [greenLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.top.equalTo(titleLab.mas_bottom).offset(41);
        make.width.equalTo(@((MainScreenWidth - 30)/8 + 3.5));
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
    
    UIImageView *progress2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grayProgress"]];
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
    
    
    UILabel *investLab = [[UILabel alloc] initWithFrame:CGRectZero];
    investLab.font = TEXT_FONT_14;
    investLab.textColor = COLOR_LINE_GREEN;
    investLab.text = XYBString(@"str_message_finance", @"出借");
    investLab.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:investLab];
    
    [investLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(Margin_Length);
        make.bottom.equalTo(greenLine.mas_top).offset(-9);
    }];
    
    UILabel *profitLab = [[UILabel alloc] initWithFrame:CGRectZero];
    profitLab.font = TEXT_FONT_14;
    profitLab.textColor = COLOR_DETAILE_GREY;
    profitLab.text = XYBString(@"str_financing_startProfit", @"起息");
    profitLab.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:profitLab];
    
    [profitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset((MainScreenWidth - 30)/8);
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
    time1.textAlignment = NSTextAlignmentRight;
    [backView addSubview:time1];
    
    [time1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progress1.mas_left);
        make.top.equalTo(grayLine.mas_bottom).offset(11);
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
    
    UIView *grayRound = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound.backgroundColor = COLOR_LINE_GREY;
    grayRound.layer.cornerRadius = 1.5;
    grayRound.layer.masksToBounds = YES;
    [backView addSubview:grayRound];
    
    [grayRound mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(Margin_Length);
        make.top.equalTo(time1.mas_bottom).offset(18);
        make.bottom.equalTo(backView.mas_bottom).offset(-Margin_Length);
        make.width.height.equalTo(@3);
    }];
    
    profitDay = [[UILabel alloc] initWithFrame:CGRectZero];
    profitDay.font = TEXT_FONT_14;
    profitDay.textColor = COLOR_AUXILIARY_GREY;
    NSString *profitStr = [NSString stringWithFormat:XYBString(@"str_finance_calculateProfitDay", @"计息日:%@计息，每月增+%@"),@"T+1",@"0"];
    profitDay.text = profitStr;
    profitLab.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:profitDay];
    
    [profitDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayRound.mas_right).offset(4);
        make.centerY.equalTo(grayRound);
    }];

    //UI:年化收益率
    UIView *backView2 = [[UIView alloc] initWithFrame:CGRectZero];
    backView2.backgroundColor = COLOR_COMMON_WHITE;
    backView2.tag = HISTORYRATE_TAG;
    [mainScroll addSubview:backView2];
    
    [backView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_bottom).offset(10);
        make.left.right.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
    }];
    
    UIImageView *rateImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [rateImage setImage:[UIImage imageNamed:@"rateImage"]];
    [backView2 addSubview:rateImage];

    [rateImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView2);
        make.top.equalTo(backView2.mas_top).offset(19);
        make.height.equalTo(@(MainScreenWidth * 170/375));
    }];
    
//    UILabel *titleLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
//    titleLab2.font = TEXT_FONT_14;
//    titleLab2.textColor = COLOR_MAIN_GREY;
//    titleLab2.text = XYBString(@"str_financing_yearRate", @"年化收益率");
//    titleLab2.textAlignment = NSTextAlignmentLeft;
//    [rateImage addSubview:titleLab2];
//
//    [titleLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(backView2.mas_top).offset(19);
//        make.left.equalTo(rateImage.mas_left).offset(Margin_Length);
//    }];
    
    NSString *historyStr = [NSString stringWithFormat:XYBString(@"str_financing_expectInterestRate_azryzydz", @"• 历史年化结算利率%@%%起步，按自然月逐月递增+%@%%的收益，%@%%封顶。\n"), @"0", @"0", @"0"];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 6;

    NSMutableAttributedString *attrabutedStr = [[NSMutableAttributedString alloc] initWithString:historyStr];
    [attrabutedStr addAttributes:@{NSParagraphStyleAttributeName : style} range:NSMakeRange(0, attrabutedStr.length - 1)];
    [attrabutedStr addAttributes:@{NSForegroundColorAttributeName:COLOR_LINE_GREY} range:NSMakeRange(0, 1)];
    [attrabutedStr addAttributes:@{NSForegroundColorAttributeName:COLOR_ORANGE} range:NSMakeRange(9, 2)];
    [attrabutedStr addAttributes:@{NSForegroundColorAttributeName:COLOR_ORANGE} range:NSMakeRange(22,3)];
    [attrabutedStr addAttributes:@{NSForegroundColorAttributeName:COLOR_ORANGE} range:NSMakeRange(attrabutedStr.length - 6,2)];

    historyLab = [[UILabel alloc] initWithFrame:CGRectZero];
    historyLab.font = TEXT_FONT_12;
    historyLab.textColor = COLOR_MAIN_GREY;
    historyLab.numberOfLines = 0;
    historyLab.textAlignment = NSTextAlignmentLeft;
    historyLab.attributedText = attrabutedStr;
    [backView2 addSubview:historyLab];
    
    [historyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rateImage.mas_bottom).offset(21);
        make.left.equalTo(backView2.mas_left).offset(Margin_Length);
        make.right.equalTo(backView2.mas_right).offset(-Margin_Length);
        make.bottom.equalTo(backView2.mas_bottom).offset(-9);
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
    [investRecordBtn addTarget:self action:@selector(clickTheInvestRecordButton:) forControlEvents:UIControlEventTouchUpInside];
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
    
    investBtn =  [[ColorButton alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"str_financing_investedImmidiate", @"立即出借")  ByGradientType:leftToRight];
    [investBtn addTarget:self action:@selector(clickTheInvestBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:investBtn];
    
    [investBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.top.equalTo(restLab.mas_bottom).offset(9);
        make.height.equalTo(@(Cell_Height));
        make.width.equalTo(@(MainScreenWidth - 30));
    }];
}

#pragma mark -  创建UI

- (void)creatTheMainScrollView {

    mainScroll = [[XYScrollView alloc] initWithFrame:CGRectZero];
    mainScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainScroll];

    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


/**
 *  @brief 收益规则+转入及计息规则+退出规则+风控措施等等View
 */
//- (void)createTheDescribeView {
//
//    //将收益规则+转入及计息规则+退出规则+风控措施等包裹起来的view
//    describeView = [[UIView alloc] initWithFrame:CGRectZero];
//    describeView.backgroundColor = COLOR_COMMON_WHITE;
//    [mainScroll addSubview:describeView];
//
//    [describeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(mainScroll);
//        make.width.equalTo(@(MainScreenWidth));
//        make.top.equalTo(investRecordBtn.mas_bottom).offset(Margin_Length);
//    }];
//
//    [XYCellLine initWithTopLineAtSuperView:describeView];
//
//    //    XYBString(@"investRoleStr",@"\n历史年化结算利率8%起步，按自然月逐月递增+1%的收益，12%封顶。\n\n举个例子：存入一个月的历史年化结算利率8%，二个月9%，三个月10%，四个月11%，五个月及更长时间保持12%\n");
//
//    NSString *baseRate = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", self.bbgProduct.baseRate * 100]];
//    NSString *paddRate = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", self.bbgProduct.paddRate * 100]];
//    NSString *maxRate = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", self.bbgProduct.maxRate * 100]];
//
//    NSString *investRoleStr = [NSString stringWithFormat:XYBString(@"str_financing_expectInterestRate_azryzydz", @"• 历史年化结算利率%@%%起步，按自然月逐月递增+%@%%的收益，%@%%封顶。\n"), baseRate, paddRate, maxRate];
//
//    NSString *investPoleStr2 = [NSString stringWithFormat:XYBString(@"str_financing_expectInterestRate_example_crygydyqnhsyl", @"举个例子：存入一个月的历史年化结算利率%@%%，二个月%@%%，三个月%@%%，四个月%@%%，五个月及更长时间保持%@%%\n"), baseRate, [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", self.bbgProduct.baseRate * 100 + 1]], [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", self.bbgProduct.baseRate * 100 + 2]], [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", self.bbgProduct.baseRate * 100 + 3]], maxRate];
//
//    investRoleStr = [investRoleStr stringByAppendingString:investPoleStr2];
//    NSString *tagStr = XYBString(@"str_financing_checkProfitAtTheInvestedProject", @"*在账户已投项目中查看收益时，收益会根据债权的实际收益向上浮动。\n");
//
//    FoldingView *investRoleView = [[FoldingView alloc] initWithTitle:XYBString(@"str_financing_profitRule", @"收益规则") contentDescribeStr:investRoleStr DescriptionStr:tagStr isShowSelectImage:YES];
//    [describeView addSubview:investRoleView];
//
//    [investRoleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.equalTo(describeView);
//    }];
//
//    NSString *transferredRoleStr = XYBString(@"str_financing_invest100AtLeastAndCalculateProfit", @"\n• 100元起投\n• T（出借日）+1工作日开始计息\n• 计息金额不足1分时,不计入收益\n• 每月返息,个人退出金额无上限,不退出时本金自动续投\n");
//    FoldingView *transferredRoleView = [[FoldingView alloc] initWithTitle:XYBString(@"str_financing_transferInAndProfitRule", @"转入及计息规则") contentDescribeStr:transferredRoleStr isShowSelectImage:YES];
//    [describeView addSubview:transferredRoleView];
//
//    [transferredRoleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(describeView);
//        make.top.equalTo(investRoleView.mas_bottom);
//    }];
//
//    NSString *quitStr = XYBString(@"str_financing_ygysdqmydcsqdxmkshje", @"\n• 计息后1个月为锁定期，退出到账日为锁定期结束日\n• 每月多次申请,每月锁定期结束日前任意时间申请\n• 当项目可赎回金额>=100且为整数;当项目可赎回金额<100元，赎回申请金额=项目可赎回金额且为整数\n");
//    FoldingView *quitRoleView = [[FoldingView alloc] initWithTitle:XYBString(@"str_financing_quitRule", @"退出规则") contentDescribeStr:quitStr isShowSelectImage:YES];
//    [describeView addSubview:quitRoleView];
//
//    [quitRoleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(describeView);
//        make.top.equalTo(transferredRoleView.mas_bottom);
//    }];
//
//    NSString *riskStr = [NSString stringWithFormat:@"\n• %@\n", XYBString(@"str_financing_platformRiskProtectMoney", @"风险缓释金保障")];
//    FoldingView *riskRoleView = [[FoldingView alloc] initWithTitle:XYBString(@"str_financing_riskSolution", @"风控措施") contentDescribeStr:riskStr isShowSelectImage:YES];
//    [describeView addSubview:riskRoleView];
//
//    [riskRoleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(describeView);
//        make.top.equalTo(quitRoleView.mas_bottom);
//        make.bottom.equalTo(describeView.mas_bottom);
//    }];
//
//    [XYCellLine initWithBottomLineAtSuperView:describeView]; //在describeView底部画线，因为describeView是被撑大的
//}

/**
 *  @brief 底部安全部分 图片+文字(风险缓释金保障)
 */
- (void)createBottomView {
    
    UIView *tipSafeView = [[UIView alloc] initWithFrame:CGRectZero];
    tipSafeView.backgroundColor = COLOR_BG;
    [mainScroll addSubview:tipSafeView];
    
    [tipSafeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.height.equalTo(@40);
        make.top.equalTo(mainScroll.mas_top).offset(MainScreenHeight - 64 -40);
        make.bottom.equalTo(mainScroll.mas_bottom);
    }];
    
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectZero];
    [tipSafeView addSubview:tipView];
    
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tipSafeView.mas_centerX);
        make.centerY.equalTo(tipSafeView.mas_centerY);
    }];
    
    UIImageView *insureImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    UIImage *img = [UIImage imageNamed:@"bsj_icon"];
    [insureImageView setImage:img];
    [tipView addSubview:insureImageView];
    
    [insureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipView.mas_top).offset(0);
        make.left.equalTo(tipView.mas_left).offset(0);
        make.size.mas_equalTo(img.size);
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.text = XYBString(@"str_financing_platformRiskProtectMoney", @"风险缓释金保障");
    tipLab.font = TEXT_FONT_12;
    tipLab.textColor = COLOR_AUXILIARY_GREY;
    [tipView addSubview:tipLab];
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipView.mas_top).offset(0);
        make.left.equalTo(insureImageView.mas_right).offset(6.0f);
        make.right.equalTo(tipView.mas_right);
        make.bottom.equalTo(tipView.mas_bottom);
    }];
}

#pragma mark - 点击事件 和 响应事件

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//产品介绍
- (void)clickTheIntroduceBtn:(id)sender {
    BbgIntroduceViewController *vc = [[BbgIntroduceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//赎回规则
- (void)clickInvestTheRuleBtn:(id)sender {
    BbgRedeemViewController *vc = [[BbgRedeemViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//标的组成
- (void)clickTheContainButton:(id)sender {
    AssetListViewController *assetVC = [[AssetListViewController alloc] init];
    assetVC.projectId = self.bbgProduct.projectId;
    assetVC.productType = @"BBG";
    assetVC.state = state;
    assetVC.amountStr = self.bbgProduct.amount;
    [self.navigationController pushViewController:assetVC animated:YES];
}

//出借记录
- (void)clickTheInvestRecordButton:(id)sender {
    BbgInvestRecordViewController *recordVC = [[BbgInvestRecordViewController alloc] init];
    recordVC.projectId = self.bbgProduct.projectId;
    [self.navigationController pushViewController:recordVC animated:YES];
}

//风险揭示
-(void)clickTheRiskDisclosureButton:(id)sender
{
    NSString *requestUrl = [RequestURL getNodeJsH5URL:App_Risk_Show_URL withIsSign:NO];
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:nil webUrlString:requestUrl];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)clickTheInvestBtn:(id)sender {
    BbgInvestViewController *investViewController = [[BbgInvestViewController alloc] init];
    investViewController.info = _bbgProduct;
    [self.navigationController pushViewController:investViewController animated:YES];
}

#pragma mark - 页面刷新

- (void)reloadTheDataForUI:(BbgProductModel *)product {

    if (product) {
        
        NSString *minRateStr = [Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[product.baseRate doubleValue] * 100]];
        NSString *paddRateStr = [Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[product.paddRate doubleValue] * 100]];
        NSString *maxRateStr = [Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[product.maxRate doubleValue] * 100]];
        NSString *rateStr = [[[minRateStr stringByAppendingString:@"-"] stringByAppendingString:maxRateStr] stringByAppendingString:XYBString(@"str_financing_percentSymbol", @"%")];
        
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
        minAmountLab.text = [Utility replaceTheNumberForNSNumberFormatter:product.minBidAmount];
        
        //出借期限
        deadLineLab.text = [NSString stringWithFormat:XYBString(@"str_financing_investTimeAtLeast", @"%@个月起"), product.minPeriods];
        
        //还款方式
        repayLab.text = [NSString stringWithFormat:@"%@", product.refundTypeStr];
        
        //照华添加字段
        
        //1.出借日期、2.起息日期、3.到账日期
        NSDate *date = [self stringToDate:product.orderDate withDateFormat:@"yyyy-MM-dd"];
        BOOL isThisYear = [self isThisYearWithDate:date];
        
        if (isThisYear) {
            time1.text = [product.orderDate substringFromIndex:5];
        }else{
            time1.text = product.orderDate;
        }
        
        NSString *timeStr2 = [product.interestDate substringFromIndex:5];
        time2.text = timeStr2;
        
        time3.text = product.refundDate;
        
        //计息日
        profitDay.text = [NSString stringWithFormat:XYBString(@"str_finance_calculateProfitDay", @"计息日:%@计息，每月增+%%%"),@"T+1",paddRateStr];
        
        //历史年化结算利率
        NSString *historyStr = [NSString stringWithFormat:XYBString(@"str_financing_expectInterestRate_azryzydz", @"• 历史年化结算利率%@%%起步，按自然月逐月递增+%@%%的收益，%@%%封顶。\n"), minRateStr, paddRateStr, maxRateStr];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 6;
        
        NSMutableAttributedString *attrabutedStr = [[NSMutableAttributedString alloc] initWithString:historyStr];
        [attrabutedStr addAttributes:@{NSParagraphStyleAttributeName : style} range:NSMakeRange(0, attrabutedStr.length - 1)];
        [attrabutedStr addAttributes:@{NSForegroundColorAttributeName:COLOR_LINE_GREY} range:NSMakeRange(0, 1)];
        [attrabutedStr addAttributes:@{NSForegroundColorAttributeName:COLOR_ORANGE} range:NSMakeRange(10, 2)];
        [attrabutedStr addAttributes:@{NSForegroundColorAttributeName:COLOR_ORANGE} range:NSMakeRange(23,3)];
        [attrabutedStr addAttributes:@{NSForegroundColorAttributeName:COLOR_ORANGE} range:NSMakeRange(attrabutedStr.length - 7,3)];
        historyLab.attributedText = attrabutedStr;
        
        NSString *restStr;
        if ([product.restAmount doubleValue] <= 0) {
            restStr = [NSString stringWithFormat:XYBString(@"str_financing_restAmount", @"剩余额度%@元"), @"0.00"];
        }else{
            restStr = [NSString stringWithFormat:XYBString(@"str_financing_restAmount", @"剩余额度%@元"), [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [product.restAmount doubleValue]]]];
        }
        
        NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc] initWithString:restStr];
        [attributStr addAttribute:NSForegroundColorAttributeName value:COLOR_RED_LEVEL1 range:NSMakeRange(4, restStr.length - 5)];
        restLab.attributedText = attributStr;
        
        if ([product.restAmount doubleValue] <= 0) {
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

#pragma mark - 步步高详情WebService

- (void)requestTheBbgDetailWebService {
    NSDictionary *param = @{ @"projectId": self.bbgProduct.projectId };
    NSString *requestURL = [RequestURL getRequestURL:BbgDetailData param:param];
    
    [self showDataLoading];
    [WebService postRequest:requestURL param:param JSONModelClass:[BbgDetailResponseModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        BbgDetailResponseModel *responseModel = responseObject;
                        _bbgProduct = responseModel.product;
                        state = [responseModel.product.state intValue];
                        [self reloadTheDataForUI:_bbgProduct];
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
