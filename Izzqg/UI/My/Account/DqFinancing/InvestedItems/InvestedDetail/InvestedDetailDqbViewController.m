//
//  InvestedDetailDqbViewController.m
//  Ixyb
//
//  Created by dengjian on 10/14/15.
//  Copyright (c) 2015 xyb. All rights reserved.
//

#import "InvestedDetailDqbViewController.h"

#import "DqbOrXtbModel.h"
#import "DqbRebackVc.h"
#import "Utility.h"
#import "WebService.h"

#import "ChangePayPasswordViewController.h"
#import "DMInvestedProject.h"
#import "DqbRebackSuccessViewController.h"
#import "DqbRebackVc.h"
#import "DqbHaveCastDetailsModel.h"
#import "InvestedDetailActionViewController.h"
#import "ColorButton.h"
#import "InvestmentListViewController.h"
#import "MJRefresh.h"
#import "CellView.h"
#import "ContractViewController.h"
#import "RedemptionInfo.h" //定期宝赎回对象
#import "Utility.h"
#import "WebviewViewController.h"
#import "XYAlertView.h"
#import "XYTableView.h"

#define VIEW_TAG_TZSJ_LAB_VIEW 1019001
#define VIEW_TAG_JXR_LAB_VIEW 1019002
#define VIEW_TAG_HKFS_LAB_VIEW 1019003
#define VIEW_TAG_KTCDZJE_LAB 1019004
#define VIEW_TAG_TITLE_LABEL 1019005
#define VIEW_TAG_AMOUNT_LABEL 1019006

#define VIEW_TAG_HOLDDAY_LAB 1019007
#define VIEW_TAG_STAGE_LAB  1019008
#define VIEW_TAG_STAGEBUT_LAB  10190081
#define VIEW_TAG_RECEIVEREST_LAB 1019009
#define VIEW_TAG_SXFREDEEMT_LAB 1019010
#define VIEW_TAG_APPLYREMMETIme_LAB 1019011
#define VIEW_TAG_APPLYENDMONEY_LAB 1019012
#define VIEW_TAG_BUY_BUTTON     1019013
#define VIEW_TAG_REDEEMED       1019014
#define VIEW_TAG_BUTTOM         1019015

@interface InvestedDetailDqbViewController ()
{
    XYScrollView *scrollView;
}

@property (nonatomic, strong) XYTableView *tableView;

@end

@implementation InvestedDetailDqbViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self updateDqbInvestedInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --  初始化UI

- (void)initUI {
    self.navigationItem.title = XYBString(@"str_invested_details", @"出借详情");
    self.view.backgroundColor = COLOR_BG;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
    
    scrollView = [[XYScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    scrollView.header = self.gifHeader3;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 193)];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = headView.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id) [ColorUtil colorWithHexString:@"4385F5"].CGColor,
                       (id) [ColorUtil colorWithHexString:@"2EA4FF"].CGColor, nil];
    [headView.layer addSublayer:gradient];
    
    [scrollView addSubview:headView];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@193);
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
        make.height.equalTo(@(140));
    }];
    
    //出借时间
    UIView * lendTimeView = [[UIView alloc] init];
    [bttomView addSubview:lendTimeView];
    [lendTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(bttomView);
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
        make.top.equalTo(lendTimeImageView.mas_bottom).offset(10);
        make.centerX.equalTo(lendTimeView);
    }];
    
    
    UILabel *lendTimeLabel = [[UILabel alloc] init];
    lendTimeLabel.font = TEXT_FONT_14;
    lendTimeLabel.textColor = COLOR_LIGHT_GREY;
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
        make.top.equalTo(interestPeriodImageView.mas_bottom).offset(10);
        make.centerX.equalTo(interestPeriodView);
    }];
    
    
    UILabel *interestPeriodLabel = [[UILabel alloc] init];
    interestPeriodLabel.font = TEXT_FONT_14;
    interestPeriodLabel.textColor = COLOR_LIGHT_GREY;
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
        make.top.equalTo(repaymentMethodsImageView.mas_bottom).offset(10);
        make.centerX.equalTo(repaymentMethodsView);
    }];
    
    
    UILabel * repaymentMethodsLabel = [[UILabel alloc] init];
    repaymentMethodsLabel.font = TEXT_FONT_14;
    repaymentMethodsLabel.textColor = COLOR_LIGHT_GREY;
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
    contentView.layer.cornerRadius = Corner_Radius;
    contentView.layer.shadowColor = COLOR_PROJECTION.CGColor;
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
    holdDayLabel.font = TEXT_FONT_12;
    holdDayLabel.textColor = COLOR_AUXILIARY_GREY;
    holdDayLabel.tag = VIEW_TAG_HOLDDAY_LAB;
    holdDayLabel.text = [NSString stringWithFormat:XYBString(@"str_holdDay",@"持有%@天"),@"50"] ;
    [contentView addSubview:holdDayLabel];
    [holdDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(21));
        make.top.equalTo(@(Margin_Top));
    }];
    
    UIImageView *infoIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_info_gray"]];
    [contentView addSubview:infoIconView];
    [infoIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(holdDayLabel.mas_centerY);
        make.left.equalTo(holdDayLabel.mas_right).offset(6);
    }];
    
    
    UIButton * stageControlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stageControlBtn.tag = VIEW_TAG_STAGEBUT_LAB;
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
    stageLabel.font = TEXT_FONT_12;
    stageLabel.textColor = COLOR_MAIN_GREY;
    stageLabel.tag = VIEW_TAG_STAGE_LAB;
    stageLabel.text = [NSString stringWithFormat:XYBString(@"str_stage",@"已回款%@期"),@"1"];
    [stageControlBtn addSubview:stageLabel];
    [stageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(stageControlBtn.mas_centerY);
        make.right.equalTo(arrowImageView.mas_left).offset(-Right_Arrow_Length);
    }];
    
    UILabel *lendPrincipalLabel = [[UILabel alloc] init];
    lendPrincipalLabel.font = TEXT_FONT_14;
    lendPrincipalLabel.textColor = COLOR_MAIN_GREY;
    lendPrincipalLabel.text = XYBString(@"str_financial_capital",@"出借本金(元)");
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
    receiveRestLabel.text =  [NSString stringWithFormat:XYBString(@"str_receive_rest", @"待收利息%@元 待收补息%@元"),@"10.00",@"4.00"];
    [contentView addSubview:receiveRestLabel];
    [receiveRestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lendPrincipalLabel.mas_left);
        make.bottom.equalTo(contentView.mas_bottom).offset(-27);
    }];
    
    
    CellView *cjmxView = [[CellView alloc] initWithStyle:CellViewStyleDefault];
    cjmxView.titleLabel.text = XYBString(@"str_bbg_lendDetail", @"出借明细");
    cjmxView.imageView.image = [UIImage imageNamed:@"loandetails"];
    [scrollView addSubview:cjmxView];
    [cjmxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(Cell_Height));
        make.top.equalTo(bttomView.mas_bottom).offset(10);
    }];
    
    //出借明细点击事件
    cjmxView.blcokClick =^(void){
        
        InvestmentListViewController *listVC = [[InvestmentListViewController alloc] init];
        listVC.orderId = [self.dicDqbInfo objectForKey:@"orderId"];
        listVC.orderType = @"BBG";
        [self.navigationController pushViewController:listVC animated:YES];
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
    [scrollView addSubview:cjhtView];
    [cjhtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(Cell_Height));
        make.top.equalTo(cjmxView.mas_bottom);
    }];
    
    //出借合同点击事件
    cjhtView.blcokClick =^(void){
        
        if ([[self.dicDqbInfo objectForKey:@"projectState"] integerValue] == 2 && [[self.dicDqbInfo objectForKey:@"projectState"] integerValue] == 2) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请等待满标后生成合同！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        } else {
//            ContractViewController *contractVC = [[ContractViewController alloc] init];
//            contractVC.investedProject = self.investedProject;
//            //合同名字 contractVC.contractName = self.contractName;
//            [self.navigationController pushViewController:contractVC animated:YES];
        }
    };
    
    
    //步步高已赎回View
    UIView * viewRedeemed = [[UIView alloc] init];
    viewRedeemed.backgroundColor = COLOR_COMMON_WHITE;
    viewRedeemed.hidden = YES;
    viewRedeemed.tag = VIEW_TAG_REDEEMED;
    [scrollView addSubview:viewRedeemed];
    [viewRedeemed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cjhtView.mas_bottom).offset(10);
        make.left.right.equalTo(cjhtView);
        make.height.equalTo(@(126));
    }];
    
    UIView * viewContentRedeemed = [[UIView alloc] init];
    [viewRedeemed addSubview:viewContentRedeemed];
    [viewContentRedeemed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.top.equalTo(@(27));
        make.bottom.equalTo(@(-27));
    }];
    

    UILabel * tipsapplyRedeemtimeLabel = [[UILabel alloc] init];
    tipsapplyRedeemtimeLabel.font = TEXT_FONT_14;
    tipsapplyRedeemtimeLabel.textColor = COLOR_NEWADDARY_GRAY;
    tipsapplyRedeemtimeLabel.textAlignment = NSTextAlignmentRight;
    tipsapplyRedeemtimeLabel.text = XYBString(@"str_bbg_tipsapplyRedeem_time",@"申请赎回时间");
    [viewContentRedeemed addSubview:tipsapplyRedeemtimeLabel];
    
    [tipsapplyRedeemtimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(viewContentRedeemed);
    }];
    
    UILabel * applyRedeemtimeLabel = [[UILabel alloc] init];
    applyRedeemtimeLabel.font = TEXT_FONT_14;
    applyRedeemtimeLabel.textColor = COLOR_MAIN_GREY;
    applyRedeemtimeLabel.tag = VIEW_TAG_APPLYREMMETIme_LAB;
    applyRedeemtimeLabel.textAlignment = NSTextAlignmentRight;
    applyRedeemtimeLabel.text = [NSString stringWithFormat:XYBString(@"str_bbg_applyRedeem_time",@"%@"),@"2017-08-25 14:11"];
    [viewContentRedeemed addSubview:applyRedeemtimeLabel];
    
    [applyRedeemtimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsapplyRedeemtimeLabel.mas_right).offset(28);
        make.centerY.equalTo(tipsapplyRedeemtimeLabel);
    }];
    
    UILabel * tipsRedeemtSxfLabel = [[UILabel alloc] init];
    tipsRedeemtSxfLabel.font = TEXT_FONT_14;
    tipsRedeemtSxfLabel.textColor = COLOR_NEWADDARY_GRAY;
    tipsRedeemtSxfLabel.textAlignment = NSTextAlignmentRight;
    tipsRedeemtSxfLabel.text = XYBString(@"str_Dqb_tipsapplyRedeem_sxf",@"赎回手续费");
    [viewContentRedeemed addSubview:tipsRedeemtSxfLabel];
    
    [tipsRedeemtSxfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewContentRedeemed);
        make.centerY.equalTo(viewContentRedeemed.mas_centerY);
    }];
    
    UILabel * sxfRedeemtLabel = [[UILabel alloc] init];
    sxfRedeemtLabel.font = TEXT_FONT_14;
    sxfRedeemtLabel.textColor = COLOR_ORANGE;
    sxfRedeemtLabel.tag = VIEW_TAG_SXFREDEEMT_LAB;
    sxfRedeemtLabel.textAlignment = NSTextAlignmentRight;
    sxfRedeemtLabel.text = [NSString stringWithFormat:XYBString(@"str_Dqb_applyRedeem_sxf",@"%@"),@"400元"];
    [viewContentRedeemed addSubview:sxfRedeemtLabel];
    
    [sxfRedeemtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(applyRedeemtimeLabel.mas_left);
        make.centerY.equalTo(tipsRedeemtSxfLabel);
    }];
    

    UILabel * tipsRedeemEstimateMoneyLabel = [[UILabel alloc] init];
    tipsRedeemEstimateMoneyLabel.font = TEXT_FONT_14;
    tipsRedeemEstimateMoneyLabel.textColor = COLOR_NEWADDARY_GRAY;
    tipsRedeemEstimateMoneyLabel.textAlignment = NSTextAlignmentRight;
    tipsRedeemEstimateMoneyLabel.text = XYBString(@"str_Dqb_tipsredeem_estimate_money",@"预计到账金额");
    [viewContentRedeemed addSubview:tipsRedeemEstimateMoneyLabel];
    
    [tipsRedeemEstimateMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(viewContentRedeemed);
        
    }];
    
    UILabel * redeemEstimateMoenyLabel = [[UILabel alloc] init];
    redeemEstimateMoenyLabel.font = TEXT_FONT_14;
    redeemEstimateMoenyLabel.textColor = COLOR_MAIN_GREY;
    redeemEstimateMoenyLabel.tag = VIEW_TAG_APPLYENDMONEY_LAB;
    redeemEstimateMoenyLabel.textAlignment = NSTextAlignmentRight;
    redeemEstimateMoenyLabel.text = [NSString stringWithFormat:XYBString(@"str_Dqb_sredeem_estimate_money",@"%@"),@"2000"];
    [viewContentRedeemed addSubview:redeemEstimateMoenyLabel];
    
    [redeemEstimateMoenyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsRedeemEstimateMoneyLabel.mas_right).offset(28);
        make.centerY.equalTo(tipsRedeemEstimateMoneyLabel);
    }];
    
    
    //底部 我要转让VIEW
    UIView * viewBttom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth,91.f)];
    viewBttom.backgroundColor = COLOR_COMMON_WHITE;
    viewBttom.tag = VIEW_TAG_BUTTOM;
    viewBttom.hidden = YES;
    viewBttom.layer.shadowColor = COLOR_GRAY.CGColor;
    viewBttom.layer.shadowOffset = CGSizeMake(0,-4);
    viewBttom.layer.shadowOpacity = 0.25;
    viewBttom.layer.shadowRadius = 4;
    [scrollView addSubview:viewBttom];
    [viewBttom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(75));
        make.width.equalTo(@(MainScreenWidth));
        make.left.right.equalTo(@0);
        make.top.equalTo(@(MainScreenHeight-137));
        make.bottom.equalTo(scrollView.mas_bottom);
    }];
    
    
    ColorButton *myTransferBut = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"str_redeem", @"赎回")  ByGradientType:leftToRight];
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

- (void)clickRightBtn:(id)sender {
    InvestedDetailActionViewController *vc = [InvestedDetailActionViewController new];
    vc.dic = self.dqbHaveCastModel.toDictionary;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickBuyButton:(id)sender {
    DqbRebackVc *dqbReback = [[DqbRebackVc alloc] init];
    dqbReback.strOrderId = [self.dicDqbInfo objectForKey:@"orderId"];
    [self.navigationController pushViewController:dqbReback animated:YES];
}

- (void)clickCollectionDetailsBtn:(id)sender {
    InvestedDetailActionViewController *vc = [[InvestedDetailActionViewController alloc] init];
    vc.dic = self.dqbHaveCastModel.toDictionary;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 刷新
-(void)headerRereshing {
    [self updateDqbInvestedInfo];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    
    [scrollView.header endRefreshing];
}




#pragma mark --  定期宝已投详情查询
- (void)updateDqbInvestedInfo {
        
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
        
        if ([UserDefaultsUtil getUser].userId) {
            [param setObject:[UserDefaultsUtil getUser].userId forKey:@"userId"];
        }
        [param setObject:[NSString stringWithFormat:@"%@",[self.dicDqbInfo objectForKey:@"orderId"]] forKey:@"orderId"];
        
        NSString *urlPath = [RequestURL getRequestURL:DqbInvestDetailURL param:param];
        [WebService postRequest:urlPath param:param JSONModelClass:[DqbHaveCastDetailsModel class]
                        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [self hideLoading];
                            DqbHaveCastDetailsModel *Invested = responseObject;
                            if (Invested.resultCode == 1) {
                                self.dqbHaveCastModel = Invested.orderInfo;
                                [self refreshDqbUI];
                            }
                            
                        }
                           fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                               [self hideLoading];
                               [self showPromptTip:errorMessage];
                           }];
}
    
#pragma mark --  定期宝UI数据处理
-(void)refreshDqbUI
{
    
    //标题
    UILabel *titleLabel = [self.view viewWithTag:VIEW_TAG_TITLE_LABEL];
    if ([self.dqbHaveCastModel.addRate doubleValue] > 0) {
        
        NSString *actualRateStr = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [self.dqbHaveCastModel.rate  doubleValue] * 100]];
        NSString * addRate = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [self.dqbHaveCastModel.addRate doubleValue]* 100]];
        NSString * actualRateOrAddRate = [NSString stringWithFormat:@"%@%%+%@%%(加息)",actualRateStr,addRate];
        titleLabel.text = [NSString stringWithFormat:@"%@ %@",self.dqbHaveCastModel.productName,actualRateOrAddRate];
        
    }else
    {
        NSString *actualRateStr = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [self.dqbHaveCastModel.addRate doubleValue] * 100]];
        titleLabel.text = [NSString stringWithFormat:@"%@ %@",self.dqbHaveCastModel.productName,actualRateStr];
    }
    
    NSInteger orderState = [self.dqbHaveCastModel.orderState  integerValue]; //订单状态为,项目为定期宝时,1:成功(策诚月盈、双季满盈、周周盈 不可赎回),2:还款结束,3:赎回中
    
    //持有天数
    UILabel * holdDayLabel = [self.view viewWithTag:VIEW_TAG_HOLDDAY_LAB];
    if (orderState == 3) {
        holdDayLabel.text = XYBString(@"str_Dqb_Tqshz", @"提前赎回中");
    }else
    {
        holdDayLabel.text = [NSString stringWithFormat:XYBString(@"str_holdDay",@"持有%@天"),self.dqbHaveCastModel.restDay];
    }
    
    //已回款期数
    UILabel * stageLabel = [self.view viewWithTag:VIEW_TAG_STAGE_LAB];
    UIButton * stageBut  = [self.view viewWithTag:VIEW_TAG_STAGEBUT_LAB];
    if ([self.dqbHaveCastModel.ccType isEqualToString:@"RXYY"])//只有日新月义才有回款期数
    {
        stageBut.hidden = NO;
        stageLabel.text = [NSString stringWithFormat:XYBString(@"str_stage",@"已回款%@期"),self.dqbHaveCastModel.refundPeriods];
    }else
    {
        stageBut.hidden = YES;
    }
    //待收利息 待收补息
    UILabel * receiveRestLabel = [self.view viewWithTag:VIEW_TAG_RECEIVEREST_LAB];
    receiveRestLabel.text = [NSString stringWithFormat:XYBString(@"str_receive_rest", @"待收利息%@元 待收补息%@元"),self.dqbHaveCastModel.interest,self.dqbHaveCastModel.addInterest];
    

    //申请赎回时间
    UILabel * applyTimeLabel = [self.view viewWithTag:VIEW_TAG_APPLYREMMETIme_LAB];
    applyTimeLabel.text = self.dqbHaveCastModel.rebackApplyDate;
    
    //赎回手续费
    UILabel * applyMoneyLabel = [self.view viewWithTag:VIEW_TAG_SXFREDEEMT_LAB];
    applyMoneyLabel.text = [NSString stringWithFormat:@"%@元",[Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.dqbHaveCastModel.rebackFee doubleValue]]]];
    
    //预计到账金额
    UILabel * applyEndLabel = [self.view viewWithTag:VIEW_TAG_APPLYENDMONEY_LAB];
    applyEndLabel.text = self.dqbHaveCastModel.actualAmount;
    
    
    //出借金额
    UILabel *amountLabel = [self.view viewWithTag:VIEW_TAG_AMOUNT_LABEL];
    if ([self.dqbHaveCastModel.amount doubleValue] == 0) {
        amountLabel.text = @"0.00";
    } else {
        amountLabel.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.dqbHaveCastModel.amount doubleValue]]];
    }
    
    //出借时间
    UILabel * tzsjLab = [self.view viewWithTag:VIEW_TAG_TZSJ_LAB_VIEW];
    NSRange range = NSMakeRange(2,8);
    NSString* investstrDate = [self.dqbHaveCastModel.orderDate substringWithRange:range];
    tzsjLab.text = investstrDate;
    
    //计息周期
    UILabel * jxLab = [self.view viewWithTag:VIEW_TAG_JXR_LAB_VIEW];
    NSString* interestDate = [self.dqbHaveCastModel.interestDate substringWithRange:range];
    NSString* refundDate = [self.dqbHaveCastModel.refundDate substringWithRange:range];
    jxLab.text      = [NSString stringWithFormat:@"%@至%@",interestDate,refundDate];
    
    //还款方式
    UILabel * hkfsLab = [self.view viewWithTag:VIEW_TAG_HKFS_LAB_VIEW];
    hkfsLab.text      = [NSString stringWithFormat:@"%@",self.dqbHaveCastModel.refundTypeStr];
    
    UIView * viewRedeemed   = [self.view viewWithTag:VIEW_TAG_REDEEMED];
    UIView * viewButtom     = [self.view viewWithTag:VIEW_TAG_BUTTOM];
    ColorButton * buyButton = (ColorButton *) [self.view viewWithTag:VIEW_TAG_BUY_BUTTON];


    if ([self.dqbHaveCastModel.ccType isEqualToString:@"CCNY"] || [self.dqbHaveCastModel.ccType isEqualToString:@"CCNNY"] || [self.dqbHaveCastModel.ccType isEqualToString:@"CCJJY"]) {
        
        if (orderState == 2) {
            
            viewButtom.hidden = YES;
            viewRedeemed.hidden = YES;
            
        } else if (orderState == 3) {
            
            viewButtom.hidden = NO;
            viewRedeemed.hidden = NO;
            [buyButton setTitle:XYBString(@"str_redeem_ing", @"赎回中") forState:UIControlStateNormal];
            buyButton.isColorEnabled = NO;
    
            [viewButtom mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(viewRedeemed.mas_bottom).offset(10);
                make.bottom.equalTo(scrollView.mas_bottom);
            }];
        }
        
        else if (orderState == 1) {
            
            viewRedeemed.hidden = YES;
            viewButtom.hidden = NO;
            
            [viewButtom mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(MainScreenHeight-137));
                make.bottom.equalTo(scrollView.mas_bottom);
            }];
            
            BOOL isCanRedeem = [self.dqbHaveCastModel.canRedeem boolValue];
   
            if (!isCanRedeem) {
                [buyButton setTitle:[NSString stringWithFormat:@"%@之后可赎回", self.dqbHaveCastModel.canRebackDate] forState:UIControlStateNormal];
                buyButton.isColorEnabled = NO;
            } else {
                
                [buyButton setTitle:XYBString(@"str_redeem", @"赎回") forState:UIControlStateNormal];
                buyButton.isColorEnabled = YES;
            }
            
            if ([self.dqbHaveCastModel.canRebackDate isKindOfClass:[NSNull class]] || ! self.dqbHaveCastModel.canRebackDate) {
                buyButton.hidden = YES;
            }

        }
    } else {
        
        viewButtom.hidden = YES;
        viewRedeemed.hidden = YES;
    }
 
}
@end
