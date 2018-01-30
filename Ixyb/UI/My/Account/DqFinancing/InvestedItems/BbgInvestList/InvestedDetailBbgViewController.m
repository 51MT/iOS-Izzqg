//
//  InvestedDetailBbgViewController.m
//  Ixyb
//
//  Created by dengjian on 12/10/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "InvestedDetailBbgViewController.h"

#import "BbgDescriptionView.h"
#import "BbgRebackViewController.h"
#import "CellView.h"
#import "ChangePayPasswordViewController.h"
#import "ChargeViewController.h"
#import "BbgHaveCastDetailModel.h"
#import "InvestedDetailActionViewController.h"
#import "InvestmentListViewController.h"
#import "MJExtension.h"
#import "BbgLendStateViewController.h"
#import "TradePasswordView.h"
#import "ContractViewController.h"
#import "User.h"
#import "UserDetailRealNamesViewController.h"
#import "Utility.h"
#import "WebService.h"

#define VIEW_TAG_TZSJ_LAB_VIEW 1019001
#define VIEW_TAG_JXR_LAB_VIEW 1019002
#define VIEW_TAG_HKFS_LAB_VIEW 1019003
#define VIEW_TAG_KTCDZJE_LAB 1019004
#define VIEW_TAG_TITLE_LABEL 1019005
#define VIEW_TAG_AMOUNT_LABEL 1019006

#define VIEW_TAG_HOLDDAY_LAB 1019007
#define VIEW_TAG_STAGE_LAB  1019008
#define VIEW_TAG_RECEIVEREST_LAB 1019009
#define VIEW_TAG_APPLYREDEEMT_LAB 1019010
#define VIEW_TAG_APPLYREMMETIme_LAB 1019011
#define VIEW_TAG_APPLYENDTIme_LAB 1019012
#define VIEW_TAG_BUY_BUTTON     1019013
#define VIEW_TAG_REDEEMED       1019014
#define VIEW_TAG_BUTTOM         1019015
#define VIEW_TAG_LENDMX_LAB     1019016
#define VIEW_TAG_SHTIME_LAB     1019017

@interface InvestedDetailBbgViewController () {
    XYScrollView *scrollView;
    TradePasswordView *tradePayView;
}

@property (nonatomic, assign) NSInteger rebackID;
@property (nonatomic, strong) OrderInfoBbgModel *  bbgOrderInfoModel;
@end

@implementation InvestedDetailBbgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataInvestedDetail) name:@"reloadDataInvestedDetail" object:nil];

    [self initUI];
    [self updateBbgInvestedInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chargeSuccess) name:@"chargeSuccessNotification" object:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateBbgInvestedInfo];
}

- (void)chargeSuccess {
    [self showPromptTip:XYBString(@"str_recharge_success", @"充值成功")];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadDataInvestedDetail {
    [self updateBbgInvestedInfo];
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
        make.left.bottom.right.equalTo(self.view);
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
        make.height.equalTo(@172);
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
    holdDayLabel.text = [NSString stringWithFormat:XYBString(@"str_holdDay",@"持有%@天"),@"0"] ;
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
    receiveRestLabel.text =  [NSString stringWithFormat:XYBString(@"str_receive_rest", @"待收利息%@ 待收补息%@"),@"10.00",@"4.00"];
    [contentView addSubview:receiveRestLabel];
    [receiveRestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lendPrincipalLabel.mas_left);
        make.bottom.equalTo(contentView.mas_bottom).offset(-20);
    }];
    
    
    //步步高已赎回View
    
    UIView * viewRedeemed = [[UIView alloc] init];
    viewRedeemed.backgroundColor = COLOR_COMMON_WHITE;
    viewRedeemed.hidden = YES;
    viewRedeemed.tag = VIEW_TAG_REDEEMED;
    [scrollView addSubview:viewRedeemed];
    [viewRedeemed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bttomView.mas_bottom).offset(Margin_Bottom);
        make.left.right.equalTo(bttomView);
        make.height.equalTo(@(0));
    }];
    
    
    UILabel * tipsapplyRedeemtLabel = [[UILabel alloc] init];
    tipsapplyRedeemtLabel.font = TEXT_FONT_14;
    tipsapplyRedeemtLabel.textColor = COLOR_AUXILIARY_GREY;
    tipsapplyRedeemtLabel.textAlignment = NSTextAlignmentRight;
    tipsapplyRedeemtLabel.text = XYBString(@"str_bbg_tipsapplyRedeem_money",@"申请赎回金额");
    [viewRedeemed addSubview:tipsapplyRedeemtLabel];
    
    [tipsapplyRedeemtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.top.equalTo(@(27));
    }];
    
    UILabel * applyRedeemtLabel = [[UILabel alloc] init];
    applyRedeemtLabel.font = TEXT_FONT_14;
    applyRedeemtLabel.textColor = COLOR_ORANGE;
    applyRedeemtLabel.tag = VIEW_TAG_APPLYREDEEMT_LAB;
    applyRedeemtLabel.textAlignment = NSTextAlignmentRight;
    applyRedeemtLabel.text = [NSString stringWithFormat:XYBString(@"str_bbg_applyRedeem_money",@"%@"),@"400元"];
    [viewRedeemed addSubview:applyRedeemtLabel];
    
    [applyRedeemtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsapplyRedeemtLabel.mas_right).offset(28);
        make.centerY.equalTo(tipsapplyRedeemtLabel);
    }];
    
    
    UILabel * tipsapplyRedeemtimeLabel = [[UILabel alloc] init];
    tipsapplyRedeemtimeLabel.font = TEXT_FONT_14;
    tipsapplyRedeemtimeLabel.textColor = COLOR_AUXILIARY_GREY;
    tipsapplyRedeemtimeLabel.textAlignment = NSTextAlignmentRight;
    tipsapplyRedeemtimeLabel.text = XYBString(@"str_bbg_tipsapplyRedeem_time",@"申请赎回时间");
    [viewRedeemed addSubview:tipsapplyRedeemtimeLabel];
    
    [tipsapplyRedeemtimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsapplyRedeemtLabel);
        make.centerY.equalTo(viewRedeemed.mas_centerY);
    }];
    
    UILabel * applyRedeemtimeLabel = [[UILabel alloc] init];
    applyRedeemtimeLabel.font = TEXT_FONT_14;
    applyRedeemtimeLabel.textColor = COLOR_TITLE_GREY;
    applyRedeemtimeLabel.tag = VIEW_TAG_APPLYREMMETIme_LAB;
    applyRedeemtimeLabel.textAlignment = NSTextAlignmentRight;
    applyRedeemtimeLabel.text = [NSString stringWithFormat:XYBString(@"str_bbg_applyRedeem_time",@"%@"),@"2017-08-25 14:11"];
    [viewRedeemed addSubview:applyRedeemtimeLabel];
    
    [applyRedeemtimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsapplyRedeemtimeLabel.mas_right).offset(28);
        make.centerY.equalTo(tipsapplyRedeemtimeLabel);
    }];
    
    
    UILabel * tipsRedeemEstimateTimeLabel = [[UILabel alloc] init];
    tipsRedeemEstimateTimeLabel.font = TEXT_FONT_14;
    tipsRedeemEstimateTimeLabel.textColor = COLOR_AUXILIARY_GREY;
    tipsRedeemEstimateTimeLabel.textAlignment = NSTextAlignmentRight;
    tipsRedeemEstimateTimeLabel.text = XYBString(@"str_bbg_tipsredeem_estimate_time",@"预计到账时间");
    [viewRedeemed addSubview:tipsRedeemEstimateTimeLabel];
    
    [tipsRedeemEstimateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.bottom.equalTo(@(-27));
        
    }];
    
    UILabel * redeemEstimateTimeLabel = [[UILabel alloc] init];
    redeemEstimateTimeLabel.font = TEXT_FONT_14;
    redeemEstimateTimeLabel.textColor = COLOR_TITLE_GREY;
    redeemEstimateTimeLabel.tag = VIEW_TAG_APPLYENDTIme_LAB;
    redeemEstimateTimeLabel.textAlignment = NSTextAlignmentRight;
    redeemEstimateTimeLabel.text = [NSString stringWithFormat:XYBString(@"str_bbg_redeem_estimate_time",@"%@"),@"2017-08-25"];
    [viewRedeemed addSubview:redeemEstimateTimeLabel];
    
    [redeemEstimateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsRedeemEstimateTimeLabel.mas_right).offset(28);
        make.centerY.equalTo(tipsRedeemEstimateTimeLabel);
    }];
    
    
    //出借明细 出借合同
    UIView * viewLendMx = [[UIView alloc] init];
    viewLendMx.tag  = VIEW_TAG_LENDMX_LAB;
    [scrollView addSubview:viewLendMx];
    
    [viewLendMx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(90));
        make.top.equalTo(viewRedeemed.mas_bottom).offset(Margin_Bottom);
        make.bottom.equalTo(scrollView.mas_bottom).offset(-90);
    }];
    
    CellView *cjmxView = [[CellView alloc] initWithStyle:CellViewStyleDefault];
    cjmxView.titleLabel.text = XYBString(@"str_bbg_lendDetail", @"出借明细");
    cjmxView.imageView.image = [UIImage imageNamed:@"loandetails"];
    [viewLendMx addSubview:cjmxView];
    [cjmxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(Cell_Height));
        make.top.equalTo(viewLendMx.mas_top);
    }];
    
    //出借明细点击事件
    cjmxView.blcokClick =^(void){
        if (self.bbgOrderInfoModel) {
            InvestmentListViewController *listVC = [[InvestmentListViewController alloc] init];
            listVC.orderId = self.bbgOrderInfoModel.orderId;
            listVC.orderType = @"BBG";
            [self.navigationController pushViewController:listVC animated:YES];

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
        
//        if ([self.bbgOrderInfoModel.projectState integerValue] == 2 && [self.investedProject.projectType integerValue] == 2) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请等待满标后生成合同！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
//        } else {
        if (self.bbgOrderInfoModel) {
            ContractViewController *contractVC = [[ContractViewController alloc] init];
            contractVC.dicInfo = self.bbgOrderInfoModel.toDictionary;
            //合同名字 contractVC.contractName = self.contractName;
            [self.navigationController pushViewController:contractVC animated:YES];
        }
       
//        }
    };
    
    
    //底部 我要转让VIEW
    UIView * viewBttom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth,91.f)];
    viewBttom.backgroundColor = COLOR_COMMON_WHITE;
    viewBttom.layer.shadowColor = [COLOR_SHADOW_GRAY colorWithAlphaComponent:0.1].CGColor;
    viewBttom.layer.shadowOffset = CGSizeMake(0,-3);
    viewBttom.layer.shadowOpacity = 0.8;
    viewBttom.tag  = VIEW_TAG_BUTTOM;
    viewBttom.layer.shadowRadius = 4;
    [self.view addSubview:viewBttom];
    [viewBttom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(90));
        make.width.equalTo(@(MainScreenWidth));
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    UILabel * shyjdzTimaLabel = [[UILabel alloc] init];
    shyjdzTimaLabel.font = TEXT_FONT_12;
    shyjdzTimaLabel.hidden = NO;
    shyjdzTimaLabel.tag  = VIEW_TAG_SHTIME_LAB;
    shyjdzTimaLabel.textColor = COLOR_INTRODUCE_RED;
    shyjdzTimaLabel.text = [NSString stringWithFormat:XYBString(@"str_redeem_estimate_time", @"赎回预计到账时间%@"),@"2017-8-8"];
    [viewBttom addSubview:shyjdzTimaLabel];
    [shyjdzTimaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewBttom.mas_centerX);
        make.top.equalTo(@(14));
    }];

    ColorButton *myTransferBut = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"str_redeem", @"赎回")  ByGradientType:leftToRight];
    myTransferBut.tag = VIEW_TAG_BUY_BUTTON;
    [myTransferBut addTarget:self action:@selector(clickBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    [viewBttom addSubview:myTransferBut];
    
    [myTransferBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(Cell_Height));
        make.bottom.equalTo(viewBttom.mas_bottom).offset(-12);
    }];

}

#pragma mark -- 刷新
-(void)headerRereshing {
    [self updateBbgInvestedInfo];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    
    [scrollView.header endRefreshing];
}


#pragma mark --  赎回点击事件

- (void)clickBuyButton:(id)sender {
    
        BOOL isReback = [self.bbgOrderInfoModel.isReback boolValue];
        if (isReback) {
            BbgRebackViewController *vc = [[BbgRebackViewController alloc] init];
            vc.dic =  self.bbgOrderInfoModel.toDictionary;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self payTheTouIDFinancing];
        }
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


//出借状态
- (void)clickLendState:(id)sender
{
    if (self.bbgOrderInfoModel){
        BbgLendStateViewController * lendState = [[BbgLendStateViewController alloc] init];
        lendState.bbgOrderInfo = self.bbgOrderInfoModel;
        [self.navigationController pushViewController:lendState animated:YES];
    }
   
}

- (void)clickCollectionDetailsBtn:(id)sender {
    if (self.bbgOrderInfoModel) {
        InvestedDetailActionViewController *vc = [[InvestedDetailActionViewController alloc] init];
        vc.dic = self.bbgOrderInfoModel.toDictionary;
        vc.paymentDetailed = BbgPaymentDetailed;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark --  指纹支付
- (void)payTheTouIDFinancing {
    //验证是否支持TouID
    [[VerificationTouch shared] isSupportTouch:^(XybTouIDVerification touchType) {

        if (touchType == NotSupportedTouID) {

            [self payBbgCancelPassWord];

        } else if (touchType == YesSupportedTouID) {
            if (![[UserDefaultsUtil getUser].isTradePassword boolValue]) { //是否设置交易密码

                [self payBbgCancelPassWord];

            } else {
                //根据当前登录用户ID  查询私钥 是否开始指纹交易
                NSString *encryption = [UserDefaultsUtil getEncryptionData:[UserDefaultsUtil getUser].userId];
                if (encryption > 0) {

                    //验证指纹
                    [[VerificationTouch shared] SupportTouchID:^(XybTouIDVerification touchType) {
                        switch (touchType) {
                            case TouIDVerficationSuccess: //验证成功
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{

                                    HBRSAHandler *handler = [[HBRSAHandler alloc] init];
                                    [handler importKeyWithType:KeyTypePrivate andkeyString:encryption];
                                    NSString *string = [NSString stringWithFormat:@"%@%@%@", [UserDefaultsUtil getUser].userId, [DateTimeUtil getCurrentTime], [OpenUDID value]];

                                    //生成指纹 交易密码
                                    NSString *sigPassWord = [handler signMD5String:string];
                                    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
                                    if ([UserDefaultsUtil getUser].userId) {
                                        [param setObject:[UserDefaultsUtil getUser].userId forKey:@"userId"];
                                    }
                                    NSInteger rebackId = self.rebackID;
                                    [param setObject:@(rebackId) forKey:@"rebackId"];
                                    if (sigPassWord) {
                                        [param setObject:sigPassWord forKey:@"tradePassword"];
                                    }
                                    [param setObject:[OpenUDID value] forKey:@"deviceId"];
                                    [param setObject:[DateTimeUtil getCurrentTime] forKey:@"timestamp"];
                                    [param setObject:@"1" forKey:@"paymentMode"];
                                    [self BbgCancelRebackWeb:param];
                                });
                            } break;
                            case TouIDVerficationFail: //验证失败
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{

                                    [HUD showPromptViewWithToShowStr:XYBString(@"str_transaction_message", @"指纹验证失败，请输入交易密码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                                    [self performSelector:@selector(payTheFinancingInfo) withObject:nil afterDelay:1.2f];

                                });
                            } break;
                            case UserCancelTouID: //用户取消验证TouID
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{

                                               });
                            } break;
                            case UserInputPassWord: //用户选择请输入密码
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self payBbgCancelPassWord];
                                });
                            } break;
                            case UserNotInputTouID: //用户未录入TouID
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{

                                    [UserDefaultsUtil clearEncryptionData:[NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]];
                                    [self payBbgCancelPassWord];

                                });
                            } break;
                            default:
                                break;
                        }

                    }];

                } else {
                    [self payBbgCancelPassWord];
                }
            }
        } else if (touchType == UserNotInputTouID) {
            [UserDefaultsUtil clearEncryptionData:[NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]];
            [self payBbgCancelPassWord];
            return;
        }

    }];
}

- (void)payTheFinancingInfo {
    [self payBbgCancelPassWord];
}

- (void)payBbgCancelPassWord {
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    tradePayView = [TradePasswordView shareInstancesaidView];
    [app.window addSubview:tradePayView];

    [tradePayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app.window);
    }];

    User *user = [UserDefaultsUtil getUser];
    __weak InvestedDetailBbgViewController *weakSelf = self;

    tradePayView.clickSureButton = ^(NSString *payStr) {

        [weakSelf doCancelReback:payStr];
    };

    tradePayView.clickForgetButton = ^{
        if (![user.isIdentityAuth boolValue]) {
            ChargeViewController *chargeViewController = [[ChargeViewController alloc] initWithIdetifer:NO];
            chargeViewController.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:chargeViewController animated:YES];
            return;
        }
        ChangePayPasswordViewController *payPassWordVC = [[ChangePayPasswordViewController alloc] init];
        [weakSelf.navigationController pushViewController:payPassWordVC animated:YES];
    };
}

- (void)doCancelReback:(NSString *)tradePassword {

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    if ([UserDefaultsUtil getUser].userId) {
        [param setObject:[UserDefaultsUtil getUser].userId forKey:@"userId"];
    }

    NSInteger rebackId = self.rebackID;
    [param setObject:@(rebackId) forKey:@"rebackId"];

    if (tradePassword) {
        [param setObject:tradePassword forKey:@"tradePassword"];
    }
    [self BbgCancelRebackWeb:param];
}

- (void)BbgCancelRebackWeb:(NSDictionary *)param {

    [self showTradeLoadingOnAlertView];

    NSString *urlPath = [RequestURL getRequestURL:BbgInvestCancelRebackURL param:param];
    [WebService postRequest:urlPath param:param JSONModelClass:[ResponseModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            [tradePayView removeFromSuperview];
            ResponseModel *Invested = responseObject;
            if (Invested.resultCode == 1) {
                [self updateBbgInvestedInfo];
            }

        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            if ([param objectForKey:@"paymentMode"]) {

                [self showPromptTip:errorMessage];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ERRORNOTIFICATION" object:errorMessage];
            }

        }];
}

#pragma mark --  步步高已投详情查询

- (void)updateBbgInvestedInfo {

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];

    if ([UserDefaultsUtil getUser].userId) {
        [param setObject:[UserDefaultsUtil getUser].userId forKey:@"userId"];
    }
    [self showDataLoading];
    [param setObject:[NSString stringWithFormat:@"%@", [self.dicBbgInfo objectForKey:@"orderId"]] forKey:@"orderId"];

    NSString *urlPath = [RequestURL getRequestURL:BbgInvestDetailURL param:param];
    [WebService postRequest:urlPath param:param JSONModelClass:[BbgHaveCastDetailModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            BbgHaveCastDetailModel *Invested = responseObject;
            if (Invested.resultCode == 1) {
                self.bbgOrderInfoModel = Invested.order;
                self.rebackID = [Invested.order.rebackId integerValue];
                [self refreshBbgUI];
            }

        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

#pragma mark --  步步高UI数据处理

- (void)refreshBbgUI {

    //标题
    UILabel *titleLabel = [self.view viewWithTag:VIEW_TAG_TITLE_LABEL];
    NSString *actualRateStr = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [self.bbgOrderInfoModel.actualRate doubleValue] * 100]];
    titleLabel.text = [NSString stringWithFormat:@"%@ %@%@",self.bbgOrderInfoModel.title,actualRateStr,@"%"];
    
    //持有天数
    UILabel * holdDayLabel = [self.view viewWithTag:VIEW_TAG_HOLDDAY_LAB];
    holdDayLabel.text = [NSString stringWithFormat:XYBString(@"str_holdDay",@"持有%@天"),self.bbgOrderInfoModel.restDay];
    
    //已回款期数
    UILabel * stageLabel = [self.view viewWithTag:VIEW_TAG_STAGE_LAB];
    stageLabel.text = [NSString stringWithFormat:XYBString(@"str_stage",@"已回款%@期"),self.bbgOrderInfoModel.refundPeriods];
    
    //待收利息 待收补息
    UILabel * receiveRestLabel = [self.view viewWithTag:VIEW_TAG_RECEIVEREST_LAB];
    NSString * interestBal;
    NSString * interest;
    if ([self.bbgOrderInfoModel.interestBal doubleValue] <= 0) {
        interestBal = @"0.00元";
    }else
    {
        interestBal = [NSString stringWithFormat:@"%@元",[Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.bbgOrderInfoModel.interestBal doubleValue]]]];
    }
    
    interest = [NSString stringWithFormat:@"%@元",[Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.bbgOrderInfoModel.interest doubleValue]]]];
    
    NSString * str = [NSString stringWithFormat:XYBString(@"str_receive_rest", @"待收利息%@ 待收补息%@"),interest,interestBal];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:COLOR_TITLE_GREY range:[str rangeOfString:interestBal]];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:COLOR_TITLE_GREY range:[str rangeOfString:interest]];
    receiveRestLabel.attributedText = attributedStr;

  
    //申请赎回金额
    UILabel * applyMoneyLabel = [self.view viewWithTag:VIEW_TAG_APPLYREDEEMT_LAB];
    applyMoneyLabel.text = [NSString stringWithFormat:@"%@元",[Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.bbgOrderInfoModel.currRebackAmount doubleValue]]]];
    
    //申请赎回时间
    UILabel * applyTimeLabel = [self.view viewWithTag:VIEW_TAG_APPLYREMMETIme_LAB];
    applyTimeLabel.text = self.bbgOrderInfoModel.rebackDate;
    
    //预计到账时间
    UILabel * applyEndLabel = [self.view viewWithTag:VIEW_TAG_APPLYENDTIme_LAB];
    applyEndLabel.text = self.bbgOrderInfoModel.refundDate;
    
    
    //出借金额
    UILabel *amountLabel = [self.view viewWithTag:VIEW_TAG_AMOUNT_LABEL];
    if ([self.bbgOrderInfoModel.amount doubleValue] == 0) {
        amountLabel.text = @"0.00";
    } else {
        amountLabel.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.bbgOrderInfoModel.amount doubleValue]]];
    }
    
    //出借时间
    UILabel * tzsjLab = [self.view viewWithTag:VIEW_TAG_TZSJ_LAB_VIEW];
    NSRange range = NSMakeRange(2,8);
    NSString* investstrDate = [self.bbgOrderInfoModel.investDate substringWithRange:range];
    
    //字符串替换 NSString *str3 = [investstrDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];

    tzsjLab.text = investstrDate;
 
   
    //计息周期
    UILabel * jxLab = [self.view viewWithTag:VIEW_TAG_JXR_LAB_VIEW];
    NSString* interestDate = [self.bbgOrderInfoModel.interestDate substringWithRange:range];
    NSString* refundDate = [self.bbgOrderInfoModel.refundDate substringWithRange:range];
    jxLab.text      = [NSString stringWithFormat:@"%@至%@",interestDate,refundDate];
    
    //还款方式
    UILabel * hkfsLab = [self.view viewWithTag:VIEW_TAG_HKFS_LAB_VIEW];
    hkfsLab.text      = [NSString stringWithFormat:@"%@",self.bbgOrderInfoModel.refundTypeStr];
    

    NSInteger state = [self.bbgOrderInfoModel.state integerValue];
    BOOL isReback = [self.bbgOrderInfoModel.isReback boolValue];
    
    ColorButton * buyButton = (ColorButton *) [self.view viewWithTag:VIEW_TAG_BUY_BUTTON];
    UIView * viewRedeemed = [self.view viewWithTag:VIEW_TAG_REDEEMED];
    UIView * viewButtom  = [self.view viewWithTag:VIEW_TAG_BUTTOM];
    UIView * viewLend   = [self.view viewWithTag:VIEW_TAG_LENDMX_LAB];
    
    UILabel * yjTimeLab = [self.view viewWithTag:VIEW_TAG_SHTIME_LAB];
    
    if(state == 9){
        viewButtom.hidden = YES;
    }else{
            viewButtom.hidden = NO;
            if (isReback) {
                
                //未赎回时不显示
                viewRedeemed.hidden = YES;
                yjTimeLab.hidden = NO;
                
                NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:XYBString(@"str_redeem_estimate_time", @"赎回预计到账时间%@"),self.bbgOrderInfoModel.refundDate]];
                [attributedStr addAttribute:NSForegroundColorAttributeName value:COLOR_AUXILIARY_GREY range:NSMakeRange(0, 8)];
                
                yjTimeLab.attributedText = attributedStr;

                
                [viewRedeemed mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(0));
                }];
                
                [viewLend mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(viewRedeemed.mas_bottom).offset(0);
                    make.bottom.equalTo(scrollView.mas_bottom).offset(-105);
                }];
                
                [viewButtom mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(90));
                }];
                
                [buyButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(@(-12));
                }];
                
                [buyButton setTitle:XYBString(@"str_redeem", @"赎回") forState:UIControlStateNormal];
                
            } else {
             
                //已赎回时显示
                viewRedeemed.hidden = NO;
                yjTimeLab.hidden = YES;
                
                [viewRedeemed mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(126));
                }];
                
                [viewLend mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(viewRedeemed.mas_bottom).offset(Margin_Bottom);
                    make.bottom.equalTo(scrollView.mas_bottom).offset(-90);
                }];
                
                [viewButtom mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(75));
                }];
                
                [buyButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(@(-Margin_Bottom));
                }];
                
                [buyButton setTitle:XYBString(@"str_redeem_cancel", @"取消赎回") forState:UIControlStateNormal];
                
            }
            
}
    
}
@end
