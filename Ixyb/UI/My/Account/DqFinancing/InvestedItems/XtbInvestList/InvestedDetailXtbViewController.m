//
//  InvestedDetailXtbViewController.m
//  Ixyb
//
//  Created by dengjian on 10/14/15.
//  Copyright (c) 2015 xyb. All rights reserved.
//

#import "InvestedDetailXtbViewController.h"
#import "CreditAssignmentRecordViewController.h"
#import "CreditAssignmentDescriptionViewController.h"
#import "DMInvestedProject.h"
#import "DqbOrXtbModel.h"
#import "XtbLendStateViewController.h"
#import "InvestedDetailActionViewController.h"
#import "CellView.h"
#import "InvestmentListViewController.h"
#import "MJRefresh.h"
#import "ContractViewController.h"
#import "XtbHaveCastDetailModel.h"
#import "Utility.h"
#import "WebService.h"
#import "XtbProductDetailViewController.h"
#import "XYTableView.h"
#import "ZqzrDetailViewController.h"

#define VIEW_TAG_TZSJ_LAB_VIEW 1019001
#define VIEW_TAG_JXR_LAB_VIEW 1019002
#define VIEW_TAG_HKFS_LAB_VIEW 1019003
#define VIEW_TAG_KTCDZJE_LAB 1019004
#define VIEW_TAG_TITLE_LABEL 1019005
#define VIEW_TAG_TIPSAMOUNT_LABEL 10190061
#define VIEW_TAG_AMOUNT_LABEL 1019006

#define VIEW_TAG_HOLDDAY_LAB 1019007
#define VIEW_TAG_STAGE_LAB  1019008
#define VIEW_TAG_RECEIVEREST_LAB 1019009
#define VIEW_TAG_BUY_BUTTON     1019010
#define VIEW_TAG_REDEEMED       1019011
#define VIEW_TAG_BUTTOM         1019012


#define VIEW_TAG_APPLYTIME_LAB 1019013
#define VIEW_TAG_ZQBJ_LAB      1019014
#define VIEW_TAG_ZRFUF_LAB     1019015
#define VIEW_TAG_YJLX_LAB      1019016
#define VIEW_TAG_YJJL_LAB      1019017
#define VIEW_TAG_JFZRF_LAB     1019018
#define VIEW_TAG_ZRJL_CELL     1019019
#define VIEW_TAG_LENDMX_LAB     1019021

@interface InvestedDetailXtbViewController ()
{

    XYScrollView *  scrollView;
}


@property (nonatomic, strong) NSDictionary *productInfo;


@end

@implementation InvestedDetailXtbViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self updateXtbInvestedInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --  初始化UI

- (void)initUI {
    self.navItem.title = XYBString(@"str_invested_details", @"出借详情");
    self.view.backgroundColor = COLOR_BG;
    
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
    
    scrollView = [[XYScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    scrollView.header = self.gifHeader3;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 172)];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = headView.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id) COLOR_MAIN.CGColor,
                       (id) COLOR_HAVECAST_BLUE.CGColor, nil];
    [headView.layer addSublayer:gradient];
    
    [scrollView addSubview:headView];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(172));
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = TEXT_FONT_14;
    titleLabel.textColor = COLOR_COMMON_WHITE;
    titleLabel.text = XYBString(@"str_bbg_title_tip", @"步步高 1130");
    titleLabel.tag = VIEW_TAG_TITLE_LABEL;
    [headView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(@Margin_Length);
    }];
    
    
    /*
     *步步高回款时间视图
     */
    
    UIView * bttomView = [[UIView alloc] init];
    bttomView.backgroundColor = COLOR_COMMON_WHITE;
    [scrollView addSubview:bttomView];
    [bttomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom);
        make.left.right.equalTo(headView);
        make.height.equalTo(@(161));
    }];
    
    //出借时间
    UIView * lendTimeView = [[UIView alloc] init];
    [bttomView addSubview:lendTimeView];
    [lendTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bttomView);
        make.bottom.equalTo(bttomView.mas_bottom).offset(-8);
        make.width.equalTo(@(MainScreenWidth/3));
        make.height.equalTo(@(90));
    }];
    
    
    UIImageView * lendTimeImageView = [[UIImageView alloc] init];
    lendTimeImageView.image = [UIImage imageNamed:@"loantime"];
    [lendTimeView addSubview:lendTimeImageView];
    [lendTimeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(lendTimeView);
        make.top.equalTo(@(0));
    }];
    
    
    UILabel *lendTimeTipsLabel = [[UILabel alloc] init];
    lendTimeTipsLabel.font = TEXT_FONT_14;
    lendTimeTipsLabel.textColor = COLOR_MAIN_GREY;
    lendTimeTipsLabel.textAlignment = NSTextAlignmentRight;
    lendTimeTipsLabel.text = XYBString(@"str_financing_investTime",@"出借时间");
    [lendTimeView addSubview:lendTimeTipsLabel];
    
    [lendTimeTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lendTimeImageView.mas_bottom).offset(0);
        make.centerX.equalTo(lendTimeView);
    }];
    
    UIFont * font = IS_IPHONE_5_OR_LESS ? WEAK_TEXT_FONT_11 : SMALL_TEXT_FONT_13;
    
    UILabel *lendTimeLabel = [[UILabel alloc] init];
    lendTimeLabel.font = font;
    lendTimeLabel.textColor = COLOR_AUXILIARY_GREY;
    lendTimeLabel.textAlignment = NSTextAlignmentCenter;
    lendTimeLabel.tag = VIEW_TAG_TZSJ_LAB_VIEW;
    lendTimeLabel.text = [NSString stringWithFormat:XYBString(@"str_bbg_investTime",@"%@"),@"06-09-12"];
    [lendTimeView addSubview:lendTimeLabel];
    
    [lendTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lendTimeTipsLabel.mas_bottom).offset(5);
        make.centerX.equalTo(lendTimeView);
        make.width.equalTo(lendTimeView);
    }];
    
    
    //计息周期
    UIView * interestPeriodView = [[UIView alloc] init];
    [bttomView addSubview:interestPeriodView];
    [interestPeriodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.bottom.width.equalTo(lendTimeView);
        make.left.equalTo(lendTimeView.mas_right);
        
    }];
    
    UIImageView * interestPeriodImageView = [[UIImageView alloc] init];
    interestPeriodImageView.image = [UIImage imageNamed:@"Interestperiod"];
    [interestPeriodView addSubview:interestPeriodImageView];
    [interestPeriodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(interestPeriodView);
        make.top.equalTo(@(0));
    }];
    
    
    UILabel *interestPeriodTipsLabel = [[UILabel alloc] init];
    interestPeriodTipsLabel.font = TEXT_FONT_14;
    interestPeriodTipsLabel.textColor = COLOR_MAIN_GREY;
    interestPeriodTipsLabel.textAlignment = NSTextAlignmentRight;
    interestPeriodTipsLabel.text = XYBString(@"str_bbg_interestcycle",@"计息周期");
    [interestPeriodView addSubview:interestPeriodTipsLabel];
    
    [interestPeriodTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(interestPeriodImageView.mas_bottom).offset(0);
        make.centerX.equalTo(interestPeriodView);
    }];
    
    
    UILabel *interestPeriodLabel = [[UILabel alloc] init];
    interestPeriodLabel.font = font;
    interestPeriodLabel.textColor = COLOR_AUXILIARY_GREY;
    interestPeriodLabel.textAlignment = NSTextAlignmentCenter;
    interestPeriodLabel.tag = VIEW_TAG_JXR_LAB_VIEW;
    interestPeriodLabel.text = [NSString stringWithFormat:XYBString(@"str_bbg_investTime",@"%@"),@"06-09-12"];
    [interestPeriodView addSubview:interestPeriodLabel];
    
    [interestPeriodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(interestPeriodTipsLabel.mas_bottom).offset(5);
        make.width.equalTo(interestPeriodView);
        make.centerX.equalTo(interestPeriodView);
    }];
    
    //还款方式
    UIView * repaymentMethodsView = [[UIView alloc] init];
    [bttomView addSubview:repaymentMethodsView];
    [repaymentMethodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.bottom.width.equalTo(lendTimeView);
        make.left.equalTo(interestPeriodView.mas_right);
        
    }];
    
    UIImageView * repaymentMethodsImageView = [[UIImageView alloc] init];
    repaymentMethodsImageView.image = [UIImage imageNamed:@"repaymentmethods"];
    [repaymentMethodsView addSubview:repaymentMethodsImageView];
    [repaymentMethodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(repaymentMethodsView);
        make.top.equalTo(@(0));
    }];
    
    
    UILabel *repaymentMethodsTipsLabel = [[UILabel alloc] init];
    repaymentMethodsTipsLabel.font = TEXT_FONT_14;
    repaymentMethodsTipsLabel.textColor = COLOR_MAIN_GREY;
    repaymentMethodsTipsLabel.textAlignment = NSTextAlignmentRight;
    repaymentMethodsTipsLabel.text = XYBString(@"str_financing_backMoney_type",@"还款方式");
    [repaymentMethodsView addSubview:repaymentMethodsTipsLabel];
    
    [repaymentMethodsTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(repaymentMethodsImageView.mas_bottom).offset(0);
        make.centerX.equalTo(repaymentMethodsView);
    }];
    
    
    UILabel * repaymentMethodsLabel = [[UILabel alloc] init];
    repaymentMethodsLabel.font = font;
    repaymentMethodsLabel.textColor = COLOR_AUXILIARY_GREY;
    repaymentMethodsLabel.tag = VIEW_TAG_HKFS_LAB_VIEW;
    repaymentMethodsLabel.textAlignment = NSTextAlignmentRight;
    repaymentMethodsLabel.text = [NSString stringWithFormat:XYBString(@"str_bbg_repayment_methods",@"%@"),@"先息后本"];
    [repaymentMethodsView addSubview:repaymentMethodsLabel];
    
    [repaymentMethodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(repaymentMethodsTipsLabel.mas_bottom).offset(5);
        make.centerX.equalTo(repaymentMethodsView);
    }];
    
    
    /*
     *步步高中间视图
     */
    
    UIView * contentView = [[UIView alloc] init];
    contentView.backgroundColor = COLOR_COMMON_WHITE;
    contentView.layer.cornerRadius = Corner_Radius_4;
    contentView.layer.shadowColor = COLOR_SHADOW_GRAY.CGColor;
    contentView.layer.shadowOffset = CGSizeMake(0,1);
    contentView.layer.shadowOpacity = 0.25;
    contentView.layer.shadowRadius = 4;
    [scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(48));
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(173));
    }];
    
    UILabel *holdDayLabel = [[UILabel alloc] init];
    holdDayLabel.font = TEXT_FONT_14;
    holdDayLabel.textColor = COLOR_SHADOW_GRAY;
    holdDayLabel.tag = VIEW_TAG_HOLDDAY_LAB;
    holdDayLabel.text = [NSString stringWithFormat:XYBString(@"str_sholdDay",@"剩%@天"),@"50"] ;
    [contentView addSubview:holdDayLabel];
    [holdDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(21));
        make.top.equalTo(@(Margin_Top));
    }];
    
    UIButton * lendBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [lendBut addTarget:self action:@selector(clickLendState:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:lendBut];
    [lendBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(holdDayLabel.mas_centerY);
        make.width.height.equalTo(@(30));
        make.left.equalTo(holdDayLabel.mas_right).offset(6);;
    }];
    
    UIImageView *infoIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lendstate"]];
    [lendBut addSubview:infoIconView];
    [infoIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lendBut.mas_centerY);
        make.left.equalTo(lendBut.mas_left);
    }];
    
    
    UIButton * stageControlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [stageControlBtn addTarget:self action:@selector(clickCollectionDetailsBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:stageControlBtn];
    [stageControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Margin_Right));
        make.centerY.equalTo(holdDayLabel.mas_centerY);
        make.width.equalTo(@(80));
        make.height.equalTo(holdDayLabel);
    }];
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = [UIImage imageNamed:@"cell_arrow"];
    [stageControlBtn addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(stageControlBtn.mas_centerY);
        make.right.equalTo(stageControlBtn.mas_right);
        
    }];
    
    UILabel *stageLabel = [[UILabel alloc] init];
    stageLabel.font = TEXT_FONT_14;
    stageLabel.textColor = COLOR_MAIN;
    stageLabel.tag = VIEW_TAG_STAGE_LAB;
    stageLabel.text = [NSString stringWithFormat:XYBString(@"str_stage",@"已回款%@期"),@"1"];
    [stageControlBtn addSubview:stageLabel];
    [stageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(stageControlBtn.mas_centerY);
        make.right.equalTo(arrowImageView.mas_left).offset(-Right_Arrow_Length);
    }];
    
    UILabel *lendPrincipalLabel = [[UILabel alloc] init];
    lendPrincipalLabel.font = TEXT_FONT_14;
    lendPrincipalLabel.textColor = COLOR_AUXILIARY_GREY;
    lendPrincipalLabel.text = XYBString(@"str_financial_cjcapital",@"出借本金(元)");
    lendPrincipalLabel.tag = VIEW_TAG_TIPSAMOUNT_LABEL;
    [contentView addSubview:lendPrincipalLabel];
    [lendPrincipalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(21));
        make.top.equalTo(holdDayLabel.mas_bottom).offset(Margin_Bottom);
    }];
    
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.font = XTB_RATE_FONT;
    amountLabel.textColor = COLOR_ORANGE;
    amountLabel.tag = VIEW_TAG_AMOUNT_LABEL;
    amountLabel.text = @"400.00";
    [contentView addSubview:amountLabel];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lendPrincipalLabel.mas_left);
        make.top.equalTo(lendPrincipalLabel.mas_bottom).offset(7);
    }];
    
    UILabel *receiveRestLabel = [[UILabel alloc] init];
    receiveRestLabel.font = TEXT_FONT_14;
    receiveRestLabel.textColor = COLOR_AUXILIARY_GREY;
    receiveRestLabel.tag = VIEW_TAG_RECEIVEREST_LAB;
    receiveRestLabel.text =  [NSString stringWithFormat:XYBString(@"str_receive_jlrest", @"待收利息%@元 待收奖励%@元"),@"10.00",@"4.00"];
    [contentView addSubview:receiveRestLabel];
    [receiveRestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lendPrincipalLabel.mas_left);
        make.bottom.equalTo(contentView.mas_bottom).offset(-20);
    }];
    
    //信投保已赎回View
    UIView * viewRedeemed = [[UIView alloc] init];
    viewRedeemed.backgroundColor = COLOR_COMMON_WHITE;
    viewRedeemed.hidden = YES;
    viewRedeemed.tag = VIEW_TAG_REDEEMED;
    [scrollView addSubview:viewRedeemed];
    [viewRedeemed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bttomView.mas_bottom).offset(Margin_Bottom);
        make.left.right.equalTo(bttomView);
        make.height.equalTo(@(0));//226
    }];
    
    UILabel * tipsapplyApplyTransfertimeLabel = [[UILabel alloc] init];
    tipsapplyApplyTransfertimeLabel.font = TEXT_FONT_14;
    tipsapplyApplyTransfertimeLabel.textColor = COLOR_AUXILIARY_GREY;
    tipsapplyApplyTransfertimeLabel.textAlignment = NSTextAlignmentRight;
    tipsapplyApplyTransfertimeLabel.text = XYBString(@"str_Xtb_TipsApplyTransfer_Time",@"申请转让时间");
    [viewRedeemed addSubview:tipsapplyApplyTransfertimeLabel];
    
    [tipsapplyApplyTransfertimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(27));
        make.left.equalTo(@(Margin_Left));
    }];
    
    UILabel * applyRedeemtimeLabel = [[UILabel alloc] init];
    applyRedeemtimeLabel.font = TEXT_FONT_14;
    applyRedeemtimeLabel.textColor = COLOR_TITLE_GREY;
    applyRedeemtimeLabel.tag = VIEW_TAG_APPLYTIME_LAB;
    applyRedeemtimeLabel.textAlignment = NSTextAlignmentRight;
    applyRedeemtimeLabel.text = [NSString stringWithFormat:XYBString(@"str_Xtb_ApplyTransfer_Time",@"%@"),@"2017-08-25 14:11"];
    [viewRedeemed addSubview:applyRedeemtimeLabel];
    
    [applyRedeemtimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsapplyApplyTransfertimeLabel.mas_right).offset(28);
        make.centerY.equalTo(tipsapplyApplyTransfertimeLabel);
    }];
    
    
    UILabel * tipsCreditorMoneyLabel = [[UILabel alloc] init];
    tipsCreditorMoneyLabel.font = TEXT_FONT_14;
    tipsCreditorMoneyLabel.textColor = COLOR_AUXILIARY_GREY;
    tipsCreditorMoneyLabel.textAlignment = NSTextAlignmentRight;
    tipsCreditorMoneyLabel.text = XYBString(@"str_Xtb_TipsCreditor_Money",@"债权本金");
    [viewRedeemed addSubview:tipsCreditorMoneyLabel];
    
    [tipsCreditorMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.top.equalTo(tipsapplyApplyTransfertimeLabel.mas_bottom).offset(14);
    }];
    
    UILabel * creditorMoneyLabel = [[UILabel alloc] init];
    creditorMoneyLabel.font = TEXT_FONT_14;
    creditorMoneyLabel.textColor = COLOR_TITLE_GREY;
    creditorMoneyLabel.textAlignment = NSTextAlignmentRight;
    creditorMoneyLabel.tag = VIEW_TAG_ZQBJ_LAB;
    creditorMoneyLabel.text = [NSString stringWithFormat:XYBString(@"str_Xtb_Creditor_Money",@"%@元"),@"109"];
    [viewRedeemed addSubview:creditorMoneyLabel];
    
    [creditorMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(applyRedeemtimeLabel.mas_left);
        make.centerY.equalTo(tipsCreditorMoneyLabel);
    }];
    
    UILabel * TipsTransferFwfLabel = [[UILabel alloc] init];
    TipsTransferFwfLabel.font = TEXT_FONT_14;
    TipsTransferFwfLabel.textColor = COLOR_AUXILIARY_GREY;
    TipsTransferFwfLabel.textAlignment = NSTextAlignmentRight;
    TipsTransferFwfLabel.text = XYBString(@"str_Xtb_TipsTransfer_Fwf",@"转让服务费");
    [viewRedeemed addSubview:TipsTransferFwfLabel];
    
    [TipsTransferFwfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.top.equalTo(tipsCreditorMoneyLabel.mas_bottom).offset(14);
    }];
    
    UILabel * transferFwfLabel = [[UILabel alloc] init];
    transferFwfLabel.font = TEXT_FONT_14;
    transferFwfLabel.textColor = COLOR_TITLE_GREY;
    transferFwfLabel.tag = VIEW_TAG_ZRFUF_LAB;
    transferFwfLabel.textAlignment = NSTextAlignmentRight;
    transferFwfLabel.text = [NSString stringWithFormat:XYBString(@"str_Xtb_Transfer_Fwf",@"%@元"),@"200"];
    [viewRedeemed addSubview:transferFwfLabel];
    
    [transferFwfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(creditorMoneyLabel.mas_left);
        make.centerY.equalTo(TipsTransferFwfLabel);
    }];
    
    UILabel * tipsYjLxLab = [[UILabel alloc] init];
    tipsYjLxLab.font = TEXT_FONT_14;
    tipsYjLxLab.textColor = COLOR_AUXILIARY_GREY;
    tipsYjLxLab.textAlignment = NSTextAlignmentRight;
    tipsYjLxLab.text = XYBString(@"str_Xtb_TipsYj_NoLx",@"应计利息");
    [viewRedeemed addSubview:tipsYjLxLab];
    
    [tipsYjLxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.top.equalTo(TipsTransferFwfLabel.mas_bottom).offset(14);
    }];
    
    UILabel * yjLxLab = [[UILabel alloc] init];
    yjLxLab.font = TEXT_FONT_14;
    yjLxLab.textColor = COLOR_TITLE_GREY;
    yjLxLab.tag = VIEW_TAG_YJLX_LAB;
    yjLxLab.textAlignment = NSTextAlignmentRight;
    yjLxLab.text = [NSString stringWithFormat:XYBString(@"str_Xtb_Yj_Lx",@"%@元"),@"200"];
    [viewRedeemed addSubview:yjLxLab];
    
    [yjLxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(transferFwfLabel.mas_left);
        make.centerY.equalTo(tipsYjLxLab);
    }];
    
    UILabel * tipsYjJlLab = [[UILabel alloc] init];
    tipsYjJlLab.font = TEXT_FONT_14;
    tipsYjJlLab.textColor = COLOR_AUXILIARY_GREY;
    tipsYjJlLab.textAlignment = NSTextAlignmentRight;
    tipsYjJlLab.text = XYBString(@"str_Xtb_TipsYj_NoJl",@"应计奖励");
    [viewRedeemed addSubview:tipsYjJlLab];
    
    [tipsYjJlLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.top.equalTo(tipsYjLxLab.mas_bottom).offset(14);
    }];
    
    UILabel * yjJlLab = [[UILabel alloc] init];
    yjJlLab.font = TEXT_FONT_14;
    yjJlLab.textColor = COLOR_TITLE_GREY;
    yjJlLab.tag = VIEW_TAG_YJJL_LAB;
    yjJlLab.textAlignment = NSTextAlignmentRight;
    yjJlLab.text = [NSString stringWithFormat:XYBString(@"str_Xtb_Yj_Jl",@"%@元"),@"200"];
    [viewRedeemed addSubview:yjJlLab];
    
    [yjJlLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yjLxLab.mas_left);
        make.centerY.equalTo(tipsYjJlLab);
    }];
    
    UILabel * tipsJfZrfLabel = [[UILabel alloc] init];
    tipsJfZrfLabel.font = TEXT_FONT_14;
    tipsJfZrfLabel.textColor = COLOR_AUXILIARY_GREY;
    tipsJfZrfLabel.textAlignment = NSTextAlignmentRight;
    tipsJfZrfLabel.text = XYBString(@"str_Xtb_TipsJf_Zrf",@"积分折让费");
    [viewRedeemed addSubview:tipsJfZrfLabel];
    
    [tipsJfZrfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.bottom.equalTo(@(-27));
        
    }];
    
    UILabel * jfZrfLabel = [[UILabel alloc] init];
    jfZrfLabel.font = TEXT_FONT_14;
    jfZrfLabel.textColor = COLOR_TITLE_GREY;
    jfZrfLabel.tag = VIEW_TAG_JFZRF_LAB;
    jfZrfLabel.textAlignment = NSTextAlignmentRight;
    jfZrfLabel.text = [NSString stringWithFormat:XYBString(@"str_Xtb_Jf_Zrf",@"%@元"),@"2000"];
    [viewRedeemed addSubview:jfZrfLabel];
    
    [jfZrfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yjJlLab.mas_left);
        make.centerY.equalTo(tipsJfZrfLabel);
    }];
    
    //转让记录
    CellView *zrjlView = [[CellView alloc] initWithStyle:CellViewStyleDefault];
    zrjlView.hidden = YES;
    zrjlView.titleLabel.text = XYBString(@"str_trans_record", @"转让记录");
    zrjlView.tag  = VIEW_TAG_ZRJL_CELL;
    zrjlView.imageView.image = [UIImage imageNamed:@"zrrecord"];
    [scrollView addSubview:zrjlView];
    [zrjlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(0));
        make.top.equalTo(viewRedeemed.mas_bottom).offset(0);
    }];
    
    //转让记录
    zrjlView.blcokClick =^(void){
        
        CreditAssignmentRecordViewController * creditAssignmentRecord = [[CreditAssignmentRecordViewController alloc] init];
        creditAssignmentRecord.dicInfo = self.xtbHaveCastModel.toDictionary;
        [self.navigationController pushViewController:creditAssignmentRecord animated:YES];
    };
    
    
    
    //出借明细 出借合同
    UIView * viewLendMx = [[UIView alloc] init];
    viewLendMx.tag  = VIEW_TAG_LENDMX_LAB;
    [scrollView addSubview:viewLendMx];
    
    [viewLendMx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(90));
        make.top.equalTo(zrjlView.mas_bottom).offset(Margin_Bottom);
        make.bottom.equalTo(scrollView.mas_bottom).offset(-90);
    }];
    
    
    CellView *cjmxView = [[CellView alloc] initWithStyle:CellViewStyleDefault];
    cjmxView.titleLabel.text = XYBString(@"str_Xtb_LendProject", @"出借项目");
    cjmxView.imageView.image = [UIImage imageNamed:@"loandetails"];
    [viewLendMx addSubview:cjmxView];
    [cjmxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(Cell_Height));
        make.top.equalTo(viewLendMx.mas_top);
    }];
    
    
    //出借项目点击事件
    cjmxView.blcokClick =^(void) {
        
        BOOL isCa = [self.xtbHaveCastModel.isCa boolValue];
        
        //债权转让
        if (isCa) {
            ZqzrDetailViewController *zqzrDetailVC = [[ZqzrDetailViewController alloc] init];
            zqzrDetailVC.productId = self.xtbHaveCastModel.projectId;
            zqzrDetailVC.isMatching = YES;
            [self.navigationController pushViewController:zqzrDetailVC animated:YES];
            
        }else{//信投宝
            XtbProductDetailViewController *xsbProductDetail = [[XtbProductDetailViewController alloc] init];
            xsbProductDetail.productId = self.xtbHaveCastModel.projectId;
            xsbProductDetail.isMatching = 2;
            [self.navigationController pushViewController:xsbProductDetail animated:YES];
        }
    };
    
    UIView *splitView = [[UIView alloc] init];
    [cjmxView addSubview:splitView];
    splitView.backgroundColor = COLOR_LINE;
    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(cjmxView);
        make.height.equalTo(@(Line_Height));
        make.top.equalTo(cjmxView.mas_bottom).offset(-Line_Height);
    }];
    
    CellView *cjhtView = [[CellView alloc] initWithStyle:CellViewStyleDefault];
    cjhtView.titleLabel.text = XYBString(@"str_bbg_lendContract", @"出借合同");
    cjhtView.imageView.image = [UIImage imageNamed:@"loancontract"];
    [viewLendMx addSubview:cjhtView];
    [cjhtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(Cell_Height));
        make.top.equalTo(cjmxView.mas_bottom);
    }];
    
    //出借合同点击事件
    cjhtView.blcokClick =^(void){
        
        if ([[self.dicXtbInfo objectForKey:@"projectState"] integerValue] == 2 && [[self.dicXtbInfo objectForKey:@"projectType'"] integerValue] == 2) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请等待满标后生成合同！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        } else {
            ContractViewController *contractVC = [[ContractViewController alloc] init];
            contractVC.dicInfo = self.xtbHaveCastModel.toDictionary;
            //合同名字 contractVC.contractName = self.contractName;
            [self.navigationController pushViewController:contractVC animated:YES];
        }
    };
    
    //底部 我要转让VIEW
    UIView * viewBttom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth,91.f)];
    viewBttom.backgroundColor = COLOR_COMMON_WHITE;
    viewBttom.tag = VIEW_TAG_BUTTOM;
    viewBttom.hidden = YES;
    viewBttom.layer.shadowColor = [COLOR_SHADOW_GRAY colorWithAlphaComponent:0.1].CGColor;
    viewBttom.layer.shadowOffset = CGSizeMake(0,-3);
    viewBttom.layer.shadowOpacity = 0.8;
    viewBttom.layer.shadowRadius = 4;
    [self.view addSubview:viewBttom];
    [viewBttom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(75));
        make.width.equalTo(@(MainScreenWidth));
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.view.mas_bottom);
        ;
    }];
    
    
    ColorButton *myTransferBut = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"str_my_trans", @"我要转让")  ByGradientType:leftToRight];
    myTransferBut.tag = VIEW_TAG_BUY_BUTTON;
    [myTransferBut addTarget:self action:@selector(clickBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    [viewBttom addSubview:myTransferBut];
    
    [myTransferBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(Cell_Height));
        make.centerY.equalTo(viewBttom.mas_centerY);
    }];
    
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//出借状态
- (void)clickLendState:(id)sender
{
    if (self.xtbHaveCastModel) {
        XtbLendStateViewController * lendState = [[XtbLendStateViewController alloc] init];
        lendState.xtbOrderInfo = self.xtbHaveCastModel;
        [self.navigationController pushViewController:lendState animated:YES];
    }
}

- (void)clickBuyButton:(id)sender {
    
    if (self.xtbHaveCastModel) {
        CreditAssignmentDescriptionViewController *vc = [CreditAssignmentDescriptionViewController new];
        vc.dicXtbInfo = self.xtbHaveCastModel.toDictionary;
        vc.titleStr = [NSString stringWithFormat:@"%@", self.productInfo[@"description"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)clickCollectionDetailsBtn:(id)sender {
    if (self.xtbHaveCastModel) {
        InvestedDetailActionViewController *vc = [[InvestedDetailActionViewController alloc] init];
        vc.dic =  self.xtbHaveCastModel.toDictionary;
        vc.paymentDetailed = XtbPaymentDetailed;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -- 刷新
-(void)headerRereshing {
    [self updateXtbInvestedInfo];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    
    [scrollView.header endRefreshing];
}

#pragma mark --  信投保已投详情查询
- (void)updateXtbInvestedInfo {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    
    if ([UserDefaultsUtil getUser].userId) {
        [param setObject:[UserDefaultsUtil getUser].userId forKey:@"userId"];
    }
    [param setObject:[NSString stringWithFormat:@"%@", [self.dicXtbInfo objectForKey:@"orderId"]] forKey:@"orderId"];
    
    [self showDataLoading];
    NSString *urlPath = [RequestURL getRequestURL:XtbInvestDetailURL param:param];
    [WebService postRequest:urlPath param:param JSONModelClass:[XtbHaveCastDetailModel class]
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self hideLoading];
                        XtbHaveCastDetailModel *Invested = responseObject;
                        if (Invested.resultCode == 1) {
                            self.xtbHaveCastModel = Invested.orderInfo;
                            [self refreshXtbUI];
                        }
                        
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
}

#pragma mark --  信投保UI数据处理
-(void)refreshXtbUI
{
    
    //标题
    UILabel *titleLabel = [self.view viewWithTag:VIEW_TAG_TITLE_LABEL];
    if ([self.xtbHaveCastModel.addRate doubleValue] > 0) {
        
        NSString *actualRateStr = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [self.xtbHaveCastModel.rate  doubleValue] * 100]];
        NSString * addRate = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [self.xtbHaveCastModel.addRate doubleValue]* 100]];
        NSString * actualRateOrAddRate = [NSString stringWithFormat:@"%@%%+%@%%(加息)",actualRateStr,addRate];
        titleLabel.text = [NSString stringWithFormat:@"%@ %@",self.xtbHaveCastModel.title,actualRateOrAddRate];
        
    }else
    {
        NSString *actualRateStr = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [self.xtbHaveCastModel.rate doubleValue] * 100]];
        titleLabel.text = [NSString stringWithFormat:@"%@ %@%%",self.xtbHaveCastModel.title,actualRateStr];
    }
    
    
    
    //持有天数 assignState: //转让状态 0待审核 1转让中 2审核拒绝 3已满标 4还款结束 5已过期
    
    UILabel * holdDayLabel = [self.view viewWithTag:VIEW_TAG_HOLDDAY_LAB];
    if ([self.xtbHaveCastModel.projectState intValue] ==  2) {
        holdDayLabel.text = @"未满标";
    }else
    {
        if ([self.xtbHaveCastModel.assignState integerValue] == 0) {
            
            holdDayLabel.text = XYBString(@"str_Xtb_Zrshz", @"转让审核中");
           
        }else if ([self.xtbHaveCastModel.assignState integerValue] == 1)
        {
            holdDayLabel.text = XYBString(@"str_Xtb_Zrz", @"转让中");
        }else
        {
            holdDayLabel.text = [NSString stringWithFormat:XYBString(@"str_sholdDay",@"剩%@天"),self.xtbHaveCastModel.restDay];
        }
    }
    
    //已回款期数
    UILabel * stageLabel = [self.view viewWithTag:VIEW_TAG_STAGE_LAB];
    stageLabel.text = [NSString stringWithFormat:XYBString(@"str_dqbstage",@"已回款%@/%@期"),self.xtbHaveCastModel.refundPeriods,self.xtbHaveCastModel.periods];
    
    //待收利息 待收补息
    UILabel * receiveRestLabel = [self.view viewWithTag:VIEW_TAG_RECEIVEREST_LAB];
    NSString * addInterest;
    NSString * interest;
    if ([self.xtbHaveCastModel.addInterest  doubleValue] <= 0) {
        addInterest = @"0.00元";
    }else
    {
        addInterest = [NSString stringWithFormat:@"%@元",[Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.xtbHaveCastModel.addInterest doubleValue]]]];
    }
    
    if ([self.xtbHaveCastModel.interest  doubleValue] <= 0) {
        interest = @"0.00元";
    }else
    {
        interest = [NSString stringWithFormat:@"%@元",[Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.xtbHaveCastModel.interest doubleValue]]]];
    }
    
    NSString * str = [NSString stringWithFormat:XYBString(@"str_receive_jlrest", @"待收利息%@ 待收奖励%@"),interest,addInterest];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:COLOR_TITLE_GREY range:[str rangeOfString:addInterest]];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:COLOR_TITLE_GREY range:[str rangeOfString:interest]];
    receiveRestLabel.attributedText = attributedStr;
    
    //出借金额
    UILabel * tipsAmountLabel = [self.view viewWithTag:VIEW_TAG_TIPSAMOUNT_LABEL];
    UILabel *amountLabel = [self.view viewWithTag:VIEW_TAG_AMOUNT_LABEL];
    //待转让本金 转让金额 - 已承接金额
    double zrAmount = [self.xtbHaveCastModel.assignAmount doubleValue] - [self.xtbHaveCastModel.acceptAmount doubleValue];
    
    if ([self.xtbHaveCastModel.assignState integerValue] == 0 ||  [self.xtbHaveCastModel.assignState integerValue] == 1) {
        
        tipsAmountLabel.text = XYBString(@"str_Xtb_DzrPrincipal", @"待转让本金(元)");
        amountLabel.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",zrAmount]];
    }else
    {
        tipsAmountLabel.text =  XYBString(@"str_financial_cjcapital",@"出借本金(元)");
        if ([self.xtbHaveCastModel.amount doubleValue] == 0) {
            amountLabel.text = @"0.00";
        } else {
            amountLabel.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.xtbHaveCastModel.amount doubleValue]]];
        }
    }
    //申请转让时间
    UILabel * applyTimeLab = [self.view viewWithTag:VIEW_TAG_APPLYTIME_LAB];
    applyTimeLab.text = [NSString stringWithFormat:XYBString(@"str_Xtb_ApplyTransfer_Time", @"%@"),self.xtbHaveCastModel.assignDate];
    
    //债权本金
    UILabel * zqMoneyLab = [self.view viewWithTag:VIEW_TAG_ZQBJ_LAB];
    zqMoneyLab.text = [NSString stringWithFormat:XYBString(@"str_Xtb_Creditor_Money", @"%@元"), [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.xtbHaveCastModel.assignAmount doubleValue]]]];
  
    //转让服务费
    UILabel * zrfufLab = [self.view viewWithTag:VIEW_TAG_ZRFUF_LAB];
    zrfufLab.text = [NSString stringWithFormat:XYBString(@"str_Xtb_Transfer_Fwf", @"%@元"),  [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.xtbHaveCastModel.assignFee doubleValue]]]];
    
    //应计利息
    UILabel * yjlxLab = [self.view viewWithTag:VIEW_TAG_YJLX_LAB];
    yjlxLab.text = [NSString stringWithFormat:XYBString(@"str_Xtb_Yj_Lx", @"%@元"), [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.xtbHaveCastModel.assignInterest doubleValue]]]];
    
    //应计奖励
    UILabel * yjllLab = [self.view viewWithTag:VIEW_TAG_YJJL_LAB];
    yjllLab.text = XYBString(@"string_zero_yuan", @"0.00元");
    if ([self.xtbHaveCastModel.assignAddInterest doubleValue] > 0) {
        yjllLab.text = [NSString stringWithFormat:XYBString(@"str_Xtb_Yj_Jl", @"%@元"),[Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.xtbHaveCastModel.assignAddInterest doubleValue]]]];
    }
    
    //积分折让费
    UILabel * jfzrfLab = [self.view viewWithTag:VIEW_TAG_JFZRF_LAB];
    jfzrfLab.text = XYBString(@"string_zero_yuan", @"0.00元");
    if ([self.xtbHaveCastModel.disScoreFee doubleValue] > 0) {
        jfzrfLab.text = [NSString stringWithFormat:XYBString(@"str_Xtb_Jf_Zrf", @"%@元"),[Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.xtbHaveCastModel.disScoreFee doubleValue]]]];
    }
    //出借时间
    UILabel * tzsjLab = [self.view viewWithTag:VIEW_TAG_TZSJ_LAB_VIEW];
    NSRange range = NSMakeRange(2,8);
    NSString* investstrDate = [self.xtbHaveCastModel.orderDate substringWithRange:range];
    tzsjLab.text = investstrDate;
    
    //计息周期
    UILabel * jxLab = [self.view viewWithTag:VIEW_TAG_JXR_LAB_VIEW];
    //如果计息时间为null.显示 -
    if ([StrUtil isEmptyString:self.xtbHaveCastModel.interestDate]) {
        jxLab.text      = @"-";
    }else
    {
        NSString* interestDate = [self.xtbHaveCastModel.interestDate substringWithRange:range];
        NSString* refundDate = [self.xtbHaveCastModel.refundDate substringWithRange:range];
        jxLab.text      = [NSString stringWithFormat:@"%@至%@",interestDate,refundDate];
    }
    //还款方式
    UILabel * hkfsLab = [self.view viewWithTag:VIEW_TAG_HKFS_LAB_VIEW];
    hkfsLab.text      = [NSString stringWithFormat:@"%@",self.xtbHaveCastModel.refundTypeStr];
    
    //转让审核中视图
    UIView * viewRedeemed   = [self.view viewWithTag:VIEW_TAG_REDEEMED];
    
    //底部按钮视图
    UIView * viewButtom     = [self.view viewWithTag:VIEW_TAG_BUTTOM];
    
    //底部按钮
    ColorButton * buyButton = (ColorButton *) [self.view viewWithTag:VIEW_TAG_BUY_BUTTON];
    
    //出借项目 出借合同
    UIView * viewLend   = [self.view viewWithTag:VIEW_TAG_LENDMX_LAB];
    
    //转让中 才有转让记录
    CellView * zrjlVIew = [self.view viewWithTag:VIEW_TAG_ZRJL_CELL];
    
    //底部按钮
    BOOL isCanTransfer = [self.xtbHaveCastModel.isCanAssign boolValue];
    
    //距离底部距离
    float jlbuttom;
    
    if (isCanTransfer) {
        
        viewButtom.hidden = NO;
        [buyButton setTitle:XYBString(@"str_my_trans", @"我要转让") forState:UIControlStateNormal];
        jlbuttom = 90.f;
    } else {
        
        viewButtom.hidden = YES;
        jlbuttom = Margin_Bottom;
    }
    
  
    //转让状态 0 已转让 1未转让
    if ([self.xtbHaveCastModel.assignState integerValue] == 0) {
        
        viewRedeemed.hidden = NO;
        [viewRedeemed mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(226));
        }];
        
        [viewLend mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(zrjlVIew.mas_bottom).offset(Margin_Bottom);
            make.bottom.equalTo(scrollView.mas_bottom).offset(-jlbuttom);
        }];
        
    }else if ([self.xtbHaveCastModel.assignState integerValue] == 1)
    {
        viewRedeemed.hidden = YES;
        [viewRedeemed mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
        
        zrjlVIew.hidden = NO;
        [zrjlVIew mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(Cell_Height));
        }];
        
        zrjlVIew.rightLabel.hidden = NO;
        if ([self.xtbHaveCastModel.acceptAmount doubleValue] > 0) {
            zrjlVIew.rightLabel.text = [NSString stringWithFormat:XYBString(@"str_Xtb_YcjAmount", @"%@元"),[Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.xtbHaveCastModel.acceptAmount doubleValue]]]];
        }else
        {
            zrjlVIew.rightLabel.text = [NSString stringWithFormat:XYBString(@"str_Xtb_YcjAmount", @"%@元"),@"0.00"];
        }
     

        [viewLend mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(zrjlVIew.mas_bottom).offset(Margin_Bottom);
            make.bottom.equalTo(scrollView.mas_bottom).offset(-jlbuttom);
        }];
    }else
    {
        [viewLend mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(zrjlVIew.mas_bottom).offset(0);
            make.bottom.equalTo(scrollView.mas_bottom).offset(-jlbuttom);
        }];
    
    }
    
}
@end
