//
//  InvestedDetailXtbViewController.m
//  Ixyb
//
//  Created by dengjian on 10/14/15.
//  Copyright (c) 2015 xyb. All rights reserved.
//

#import "InvestedDetailXtbViewController.h"

#import "CreditAssignmentDescriptionViewController.h"
#import "DMInvestedProject.h"
#import "DqbOrXtbModel.h"
#import "InvestedDetailActionViewController.h"
#import "CellView.h"
#import "InvestmentListViewController.h"
#import "ColorButton.h"
#import "MJRefresh.h"
#import "ContractViewController.h"
#import "XtbHaveCastDetailModel.h"
#import "Utility.h"
#import "WebService.h"
#import "XtbProductDetailViewController.h"
#import "XYTableView.h"

#define VIEW_TAG_TZSJ_LAB_VIEW 1019001
#define VIEW_TAG_JXR_LAB_VIEW 1019002
#define VIEW_TAG_HKFS_LAB_VIEW 1019003
#define VIEW_TAG_KTCDZJE_LAB 1019004
#define VIEW_TAG_TITLE_LABEL 1019005
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
    cjmxView.titleLabel.text = XYBString(@"str_Xtb_LendProject", @"出借项目");
    cjmxView.imageView.image = [UIImage imageNamed:@"loandetails"];
    [scrollView addSubview:cjmxView];
    [cjmxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(Cell_Height));
        make.top.equalTo(bttomView.mas_bottom).offset(10);
    }];
    
    //出借项目点击事件
    cjmxView.blcokClick =^(void){
        
        XtbProductDetailViewController *xsbProductDetail = [[XtbProductDetailViewController alloc] init];
        xsbProductDetail.productId = [self.dicXtbInfo objectForKey:@"projectId"];
        [self.navigationController pushViewController:xsbProductDetail animated:YES];
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
        
        if ([[self.dicXtbInfo objectForKey:@"projectState"] integerValue] == 2 && [[self.dicXtbInfo objectForKey:@"projectType'"] integerValue] == 2) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请等待满标后生成合同！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        } else {
//            ContractViewController *contractVC = [[ContractViewController alloc] init];
//            contractVC.investedProject = self.investedProject;
//            //合同名字 contractVC.contractName = self.contractName;
//            [self.navigationController pushViewController:contractVC animated:YES];
        }
    };
    
    
    //信投保已赎回View
    UIView * viewRedeemed = [[UIView alloc] init];
    viewRedeemed.backgroundColor = COLOR_COMMON_WHITE;
    viewRedeemed.hidden = YES;
    viewRedeemed.tag = VIEW_TAG_REDEEMED;
    [scrollView addSubview:viewRedeemed];
    [viewRedeemed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cjhtView.mas_bottom).offset(10);
        make.left.right.equalTo(cjhtView);
        make.height.equalTo(@(226));
    }];
    
    UIView * viewContentRedeemed = [[UIView alloc] init];
    [viewRedeemed addSubview:viewContentRedeemed];
    [viewContentRedeemed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.top.equalTo(@(27));
        make.bottom.equalTo(@(-27));
    }];
    
    UILabel * tipsapplyApplyTransfertimeLabel = [[UILabel alloc] init];
    tipsapplyApplyTransfertimeLabel.font = TEXT_FONT_14;
    tipsapplyApplyTransfertimeLabel.textColor = COLOR_NEWADDARY_GRAY;
    tipsapplyApplyTransfertimeLabel.textAlignment = NSTextAlignmentRight;
    tipsapplyApplyTransfertimeLabel.text = XYBString(@"str_Xtb_TipsApplyTransfer_Time",@"申请转让时间");
    [viewContentRedeemed addSubview:tipsapplyApplyTransfertimeLabel];
    
    [tipsapplyApplyTransfertimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(viewContentRedeemed);
    }];
    
    UILabel * applyRedeemtimeLabel = [[UILabel alloc] init];
    applyRedeemtimeLabel.font = TEXT_FONT_14;
    applyRedeemtimeLabel.textColor = COLOR_MAIN_GREY;
    applyRedeemtimeLabel.tag = VIEW_TAG_APPLYTIME_LAB;
    applyRedeemtimeLabel.textAlignment = NSTextAlignmentRight;
    applyRedeemtimeLabel.text = [NSString stringWithFormat:XYBString(@"str_Xtb_ApplyTransfer_Time",@"%@"),@"2017-08-25 14:11"];
    [viewContentRedeemed addSubview:applyRedeemtimeLabel];
    
    [applyRedeemtimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsapplyApplyTransfertimeLabel.mas_right).offset(28);
        make.centerY.equalTo(tipsapplyApplyTransfertimeLabel);
    }];
    
    
    UILabel * tipsCreditorMoneyLabel = [[UILabel alloc] init];
    tipsCreditorMoneyLabel.font = TEXT_FONT_14;
    tipsCreditorMoneyLabel.textColor = COLOR_NEWADDARY_GRAY;
    tipsCreditorMoneyLabel.textAlignment = NSTextAlignmentRight;
    tipsCreditorMoneyLabel.text = XYBString(@"str_Xtb_TipsCreditor_Money",@"债权本金");
    [viewContentRedeemed addSubview:tipsCreditorMoneyLabel];
    
    [tipsCreditorMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewContentRedeemed);
        make.top.equalTo(tipsapplyApplyTransfertimeLabel.mas_bottom).offset(14);
    }];
    
    UILabel * creditorMoneyLabel = [[UILabel alloc] init];
    creditorMoneyLabel.font = TEXT_FONT_14;
    creditorMoneyLabel.textColor = COLOR_MAIN_GREY;
    creditorMoneyLabel.textAlignment = NSTextAlignmentRight;
    creditorMoneyLabel.tag = VIEW_TAG_ZQBJ_LAB;
    creditorMoneyLabel.text = [NSString stringWithFormat:XYBString(@"str_Xtb_Creditor_Money",@"%@元"),@"109"];
    [viewContentRedeemed addSubview:creditorMoneyLabel];
    
    [creditorMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(applyRedeemtimeLabel.mas_left);
        make.centerY.equalTo(tipsCreditorMoneyLabel);
    }];
    
    UILabel * TipsTransferFwfLabel = [[UILabel alloc] init];
    TipsTransferFwfLabel.font = TEXT_FONT_14;
    TipsTransferFwfLabel.textColor = COLOR_NEWADDARY_GRAY;
    TipsTransferFwfLabel.textAlignment = NSTextAlignmentRight;
    TipsTransferFwfLabel.text = XYBString(@"str_Xtb_TipsTransfer_Fwf",@"转让服务费");
    [viewContentRedeemed addSubview:TipsTransferFwfLabel];
    
    [TipsTransferFwfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewContentRedeemed);
        make.top.equalTo(tipsCreditorMoneyLabel.mas_bottom).offset(14);
    }];
    
    UILabel * transferFwfLabel = [[UILabel alloc] init];
    transferFwfLabel.font = TEXT_FONT_14;
    transferFwfLabel.textColor = COLOR_MAIN_GREY;
    transferFwfLabel.tag = VIEW_TAG_ZRFUF_LAB;
    transferFwfLabel.textAlignment = NSTextAlignmentRight;
    transferFwfLabel.text = [NSString stringWithFormat:XYBString(@"str_Xtb_Transfer_Fwf",@"%@元"),@"200"];
    [viewContentRedeemed addSubview:transferFwfLabel];
    
    [transferFwfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(creditorMoneyLabel.mas_left);
        make.centerY.equalTo(TipsTransferFwfLabel);
    }];
    
    UILabel * tipsYjLxLab = [[UILabel alloc] init];
    tipsYjLxLab.font = TEXT_FONT_14;
    tipsYjLxLab.textColor = COLOR_NEWADDARY_GRAY;
    tipsYjLxLab.textAlignment = NSTextAlignmentRight;
    tipsYjLxLab.text = XYBString(@"str_Xtb_TipsYj_Lx",@"应计利息");
    [viewContentRedeemed addSubview:tipsYjLxLab];
    
    [tipsYjLxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewContentRedeemed);
        make.top.equalTo(TipsTransferFwfLabel.mas_bottom).offset(14);
    }];
    
    UILabel * yjLxLab = [[UILabel alloc] init];
    yjLxLab.font = TEXT_FONT_14;
    yjLxLab.textColor = COLOR_MAIN_GREY;
    yjLxLab.tag = VIEW_TAG_YJLX_LAB;
    yjLxLab.textAlignment = NSTextAlignmentRight;
    yjLxLab.text = [NSString stringWithFormat:XYBString(@"str_Xtb_Yj_Lx",@"%@元"),@"200"];
    [viewContentRedeemed addSubview:yjLxLab];
    
    [yjLxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(transferFwfLabel.mas_left);
        make.centerY.equalTo(tipsYjLxLab);
    }];

    UILabel * tipsYjJlLab = [[UILabel alloc] init];
    tipsYjJlLab.font = TEXT_FONT_14;
    tipsYjJlLab.textColor = COLOR_NEWADDARY_GRAY;
    tipsYjJlLab.textAlignment = NSTextAlignmentRight;
    tipsYjJlLab.text = XYBString(@"str_Xtb_TipsYj_Jl",@"应计奖励");
    [viewContentRedeemed addSubview:tipsYjJlLab];
    
    [tipsYjJlLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewContentRedeemed);
        make.top.equalTo(tipsYjLxLab.mas_bottom).offset(14);
    }];
    
    UILabel * yjJlLab = [[UILabel alloc] init];
    yjJlLab.font = TEXT_FONT_14;
    yjJlLab.textColor = COLOR_MAIN_GREY;
    yjJlLab.tag = VIEW_TAG_YJJL_LAB;
    yjJlLab.textAlignment = NSTextAlignmentRight;
    yjJlLab.text = [NSString stringWithFormat:XYBString(@"str_Xtb_Yj_Jl",@"%@元"),@"200"];
    [viewContentRedeemed addSubview:yjJlLab];
    
    [yjJlLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yjLxLab.mas_left);
        make.centerY.equalTo(tipsYjJlLab);
    }];
    
    UILabel * tipsJfZrfLabel = [[UILabel alloc] init];
    tipsJfZrfLabel.font = TEXT_FONT_14;
    tipsJfZrfLabel.textColor = COLOR_NEWADDARY_GRAY;
    tipsJfZrfLabel.textAlignment = NSTextAlignmentRight;
    tipsJfZrfLabel.text = XYBString(@"str_Xtb_TipsJf_Zrf",@"积分折让费");
    [viewContentRedeemed addSubview:tipsJfZrfLabel];
    
    [tipsJfZrfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(viewContentRedeemed);
        
    }];
    
    UILabel * jfZrfLabel = [[UILabel alloc] init];
    jfZrfLabel.font = TEXT_FONT_14;
    jfZrfLabel.textColor = COLOR_MAIN_GREY;
    jfZrfLabel.tag = VIEW_TAG_JFZRF_LAB;
    jfZrfLabel.textAlignment = NSTextAlignmentRight;
    jfZrfLabel.text = [NSString stringWithFormat:XYBString(@"str_Xtb_Jf_Zrf",@"%@元"),@"2000"];
    [viewContentRedeemed addSubview:jfZrfLabel];
    
    [jfZrfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yjJlLab.mas_left);
        make.centerY.equalTo(tipsJfZrfLabel);
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


- (void)clickBuyButton:(id)sender {
    CreditAssignmentDescriptionViewController *vc = [CreditAssignmentDescriptionViewController new];
    vc.dicXtbInfo = self.xtbHaveCastModel.toDictionary;
    vc.titleStr = [NSString stringWithFormat:@"%@", self.productInfo[@"description"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickCollectionDetailsBtn:(id)sender {
    InvestedDetailActionViewController *vc = [[InvestedDetailActionViewController alloc] init];
    vc.dic =  self.xtbHaveCastModel.toDictionary;
    [self.navigationController pushViewController:vc animated:YES];
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
        NSString *actualRateStr = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [self.xtbHaveCastModel.addRate doubleValue] * 100]];
        titleLabel.text = [NSString stringWithFormat:@"%@ %@",self.xtbHaveCastModel.title,actualRateStr];
    }
    
    
    
    //持有天数 assignState: //转让状态 0待审核 1转让中 2审核拒绝 3已满标 4还款结束 5已过期
    
    UILabel * holdDayLabel = [self.view viewWithTag:VIEW_TAG_HOLDDAY_LAB];

    if ([self.xtbHaveCastModel.assignState integerValue] == 0) {
        
        holdDayLabel.text = XYBString(@"str_Xtb_Zrshz", @"转让审核中");
       
    }else if ([self.xtbHaveCastModel.assignState integerValue] == 1)
    {
        holdDayLabel.text = XYBString(@"str_Xtb_Zrz", @"转让中");
    }else
    {
        holdDayLabel.text = [NSString stringWithFormat:XYBString(@"str_holdDay",@"持有%@天"),self.xtbHaveCastModel.restDay];
    }
  
    
    //已回款期数
    UILabel * stageLabel = [self.view viewWithTag:VIEW_TAG_STAGE_LAB];
    stageLabel.text = [NSString stringWithFormat:XYBString(@"str_stage",@"已回款%@期"),self.xtbHaveCastModel.refundPeriods];
    
    //待收利息 待收补息
    UILabel * receiveRestLabel = [self.view viewWithTag:VIEW_TAG_RECEIVEREST_LAB];
    receiveRestLabel.text = [NSString stringWithFormat:XYBString(@"str_receive_rest", @"待收利息%@元 待收补息%@元"),self.xtbHaveCastModel.interest,self.xtbHaveCastModel.addInterest];
    
    
    //申请转让时间
    UILabel * applyTimeLab = [self.view viewWithTag:VIEW_TAG_APPLYTIME_LAB];
    applyTimeLab.text = [NSString stringWithFormat:XYBString(@"str_Xtb_ApplyTransfer_Time", @"%@"),self.xtbHaveCastModel.assignDate];
    
    //债权本金
    UILabel * zqMoneyLab = [self.view viewWithTag:VIEW_TAG_ZQBJ_LAB];
    zqMoneyLab.text = [NSString stringWithFormat:XYBString(@"str_Xtb_Creditor_Money", @"%@元"),self.xtbHaveCastModel.assignAmount];
    
    //转让服务费
    UILabel * zrfufLab = [self.view viewWithTag:VIEW_TAG_ZRFUF_LAB];
    zrfufLab.text = [NSString stringWithFormat:XYBString(@"str_Xtb_Transfer_Fwf", @"%@元"),self.xtbHaveCastModel.assignFee];
    
    //应计利息
    UILabel * yjlxLab = [self.view viewWithTag:VIEW_TAG_YJLX_LAB];
    yjlxLab.text = [NSString stringWithFormat:XYBString(@"str_Xtb_Yj_Lx", @"%@元"),self.xtbHaveCastModel.assignInterest];
    
    //应计奖励
    UILabel * yjllLab = [self.view viewWithTag:VIEW_TAG_YJJL_LAB];
    yjllLab.text = [NSString stringWithFormat:XYBString(@"str_Xtb_Yj_Jl", @"%@元"),self.xtbHaveCastModel.assignAddInterest];
    
    //积分折让费
    UILabel * jfzrfLab = [self.view viewWithTag:VIEW_TAG_JFZRF_LAB];
    jfzrfLab.text = [NSString stringWithFormat:XYBString(@"str_Xtb_Jf_Zrf", @"%@元"),self.xtbHaveCastModel.disScoreFee];

    //出借金额
    UILabel *amountLabel = [self.view viewWithTag:VIEW_TAG_AMOUNT_LABEL];
    if ([self.xtbHaveCastModel.amount doubleValue] == 0) {
        amountLabel.text = @"0.00";
    } else {
        amountLabel.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.xtbHaveCastModel.amount doubleValue]]];
    }
    
    //出借时间
    UILabel * tzsjLab = [self.view viewWithTag:VIEW_TAG_TZSJ_LAB_VIEW];
    NSRange range = NSMakeRange(2,8);
    NSString* investstrDate = [self.xtbHaveCastModel.orderDate substringWithRange:range];
    tzsjLab.text = investstrDate;
    
    //计息周期
    UILabel * jxLab = [self.view viewWithTag:VIEW_TAG_JXR_LAB_VIEW];
    NSString* interestDate = [self.xtbHaveCastModel.interestDate substringWithRange:range];
    NSString* refundDate = [self.xtbHaveCastModel.refundDate substringWithRange:range];
    jxLab.text      = [NSString stringWithFormat:@"%@至%@",interestDate,refundDate];
    
    //还款方式
    UILabel * hkfsLab = [self.view viewWithTag:VIEW_TAG_HKFS_LAB_VIEW];
    hkfsLab.text      = [NSString stringWithFormat:@"%@",self.xtbHaveCastModel.refundTypeStr];
    
    UIView * viewRedeemed   = [self.view viewWithTag:VIEW_TAG_REDEEMED];
    UIView * viewButtom     = [self.view viewWithTag:VIEW_TAG_BUTTOM];
    ColorButton * buyButton = (ColorButton *) [self.view viewWithTag:VIEW_TAG_BUY_BUTTON];
    
    
    //刷新上面按钮
    BOOL isCanTransfer = [self.xtbHaveCastModel.isCanAssign boolValue];
    NSInteger assignState  = [self.xtbHaveCastModel.assignState integerValue];//转让状态 0待审核 1转让中 2审核拒绝 3已满标 4还款结束 5已过期
    NSString *assignStateStr = [NSString stringWithFormat:@"%@", self.xtbHaveCastModel.assignStateStr];
    
    if (assignState == 0) { //转让审核中显示中间部分UI 
        
        viewRedeemed.hidden = NO;
        [viewButtom mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewRedeemed.mas_bottom).offset(10);
            make.bottom.equalTo(scrollView.mas_bottom);
        }];
        
    }else
    {
        viewRedeemed.hidden = YES;
        [viewButtom mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(MainScreenHeight-137));
            make.bottom.equalTo(scrollView.mas_bottom);
        }];
        
    }
    
    
    viewButtom.hidden = YES;
    BOOL isEnable = YES;
    
    if (isCanTransfer) {
        isEnable = YES;
        viewButtom.hidden = NO;
        [buyButton setTitle:XYBString(@"str_my_trans", @"我要转让") forState:UIControlStateNormal];
    } else {
        isEnable = NO;
        if (assignStateStr.length > 0) {
            viewButtom.hidden = NO;
        } else {
            viewButtom.hidden = YES;
        }
    }
    
    buyButton.isColorEnabled = isEnable;
    
    if (isEnable) {
        [buyButton setTitle:assignStateStr forState:UIControlStateNormal];
    } else {
        if ([assignStateStr isEqualToString:@"待审核"]) {
            [buyButton setTitle:XYBString(@"str_trans_verify", @"转让审核中") forState:UIControlStateNormal];
        } else {
            [buyButton setTitle:assignStateStr forState:UIControlStateNormal];
        }
        buyButton.isColorEnabled = NO;
    }
}
@end
