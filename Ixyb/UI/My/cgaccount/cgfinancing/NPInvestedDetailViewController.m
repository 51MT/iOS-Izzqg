//
//  NPInvestedDetailViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/15.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "Utility.h"
#import "WzOrArrowView.h"
#import "CgOrderDetailModel.h"
#import "WebService.h"
#import "NPInvestedDetailViewController.h"
#import "NPLoanDetailViewController.h"
#import "NPBackRecordViewController.h"
#import "NPAssignApplyViewController.h"
#import "NPAssignRecordViewController.h"
#import "XYWebViewController.h"

@interface NPInvestedDetailViewController ()
{
    XYScrollView   * mainScollView;    //主视图
    UIView         * headerView;       //头部视图
    UIView         * headerjxView;     //头部上内容
    UIView         * cardView;         //卡片
    UIView         * centerView;       //中金视图
    
    UILabel        * dayLab;           //天数
    UILabel        * djxLab;           //待计息
    UILabel        * yjxLab;           //已计息
    
    UILabel        * cjbjLab;          //出借本金
    UILabel        * yqbjxLab;         //已全部计息
    UILabel        * stageLab;         //已回款期
    UILabel        * stagehkLab;       //已回款元
    UILabel        * dhkLab;           //待回款
    
    UILabel        * titleNameLab;     //项目标题
    UILabel        * rateLab;          //年化率
    UILabel        * cjTimeLab;        //出借时间
    UILabel        * amonthLab;        //封闭期
    UILabel        * jhtermLab;        //集合期限
    
    UIView         * transferView;      //转让中视图
    
    UILabel        * transferTitleLab;  //转让中
    UILabel        * dtransferjeLab;    //待转让
    UILabel        * ytransferjeLab;    //已转让
    UILabel        * sqtransfersjLab;   //申请转让时间
    UILabel        * sqtransferjeLab;   //申请转让金额
    UILabel        * tipsZrzLab;        //已耗时
    
    UILabel        * zrStateLab;       //转让状态
    UILabel        * yjzrDateLab;      //一键转让日期
    ColorButton    * zrBut;            //转让but
    CGDepOrderDetailListModel *    depOrderDetail;
    UIView         * backButtomView;   //底部视图
}
@end

@implementation NPInvestedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self initUI];
    [self refreshRequest];
    [self setupRefresh];
}
#pragma mark - 初始化UI
-(void)setNav
{
    self.navItem.title = XYBString(@"str_invested_details", @"出借详情");
    self.view.backgroundColor = COLOR_BG;
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

-(void)initUI
{
    mainScollView = [[XYScrollView alloc] init];
    mainScollView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:mainScollView];
    [mainScollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    #pragma mark  -- 顶部
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 213)];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = headerView.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id) COLOR_MAIN.CGColor,
                       (id) COLOR_LIGHT_BLUE.CGColor, nil];
    [headerView.layer addSublayer:gradient];
    [mainScollView addSubview:headerView];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@213);
    }];
    
    dayLab = [[UILabel alloc] init];
    dayLab.font  = TEXT_FONT_14;
    dayLab.text  = [NSString stringWithFormat:XYBString(@"str_account_hkxssy", @"还可享受%@天收益"),@"1"];
    dayLab.textColor = COLOR_COMMON_WHITE;
    [headerView addSubview:dayLab];
    [dayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(Margin_Left));
    }];
    
    headerjxView = [[UIView alloc] init];
    headerjxView.backgroundColor = COLOR_COMMON_CLEAR;
    [headerView addSubview:headerjxView];
    [headerjxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dayLab.mas_bottom).offset(19);
        make.left.right.equalTo(headerView);
        make.height.equalTo(@(50));
    }];
    
    djxLab = [[UILabel alloc] init];
    djxLab.font  = GENERAL_MIDDLE_BIG_FONT;
    djxLab.text  = @"0.00";
    djxLab.textColor = COLOR_COMMON_WHITE;
    [headerjxView addSubview:djxLab];
    [djxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerjxView);
        make.left.equalTo(@(Margin_Left));
    }];
    
    UILabel * tipsDjxLab = [[UILabel alloc] init];
    tipsDjxLab.font  = TEXT_FONT_14;
    tipsDjxLab.text  = XYBString(@"str_account_djx", @"待计息");
    tipsDjxLab.textColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:0.6f];
    [headerjxView addSubview:tipsDjxLab];
    [tipsDjxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerjxView);
        make.left.equalTo(@(Margin_Left));
    }];
    
    UIImageView * arrowRightImageView = [[UIImageView alloc] init];
    arrowRightImageView.image = [UIImage imageNamed:@"white_arrow"];
    [headerjxView addSubview:arrowRightImageView];
    [arrowRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(djxLab.mas_right).offset(Margin_Left);
        make.centerY.equalTo(djxLab);
    }];
    
    UILabel * tipsMbjxLab = [[UILabel alloc] init];
    tipsMbjxLab.font  = TEXT_FONT_14;
    tipsMbjxLab.text  = XYBString(@"str_account_mbjx", @"满标计息");
    tipsMbjxLab.textColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:0.6f];
    [headerjxView addSubview:tipsMbjxLab];
    [tipsMbjxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerjxView);
        make.centerX.equalTo(arrowRightImageView);
    }];
    
    yjxLab = [[UILabel alloc] init];
    yjxLab.font  = GENERAL_MIDDLE_BIG_FONT;
    yjxLab.text  = @"0.00";
    yjxLab.textColor = COLOR_COMMON_WHITE;
    [headerjxView addSubview:yjxLab];
    [yjxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(arrowRightImageView);
        make.left.equalTo(arrowRightImageView.mas_right).offset(Margin_Left);
    }];
    
    UILabel * tipsYjxLab = [[UILabel alloc] init];
    tipsYjxLab.font  = TEXT_FONT_14;
    tipsYjxLab.text  = XYBString(@"str_account_yjx", @"已计息");
    tipsYjxLab.textColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:0.6f];
    [headerjxView addSubview:tipsYjxLab];
    [tipsYjxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerjxView);
        make.left.equalTo(yjxLab.mas_left);
    }];
    
  
    #pragma mark  -- 中间视图
    centerView = [[UIView alloc] init];
    centerView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScollView addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.height.equalTo(@(232.f));
        make.left.right.equalTo(mainScollView);
    }];
    
    titleNameLab = [[UILabel alloc] init];
    titleNameLab.font  = BIG_TEXT_FONT_17;
    titleNameLab.text  = @"一键出借171030-2";
    titleNameLab.textColor = COLOR_MAIN_GREY;
    [centerView addSubview:titleNameLab];
    [titleNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.top.equalTo(@(75.f));
    }];
    
    WzOrArrowView * wzOrArrow = [[WzOrArrowView alloc] init];
    wzOrArrow.titleLabel.text = XYBString(@"str_bbg_lendContract", @"出借合同");
    [centerView addSubview:wzOrArrow];
    
    wzOrArrow.blcokClick =^ (void)
    {
        NSString *  str = [NSString stringWithFormat:@"%@", App_Investor_URL];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", [RequestURL getNodeJsH5URL:str withIsSign:YES],[self getProjectId:depOrderDetail.orderId orderNo:depOrderDetail.orderNo]];
        XYWebViewController *webView = [[XYWebViewController alloc] initWithTitle:nil webUrlString:urlStr];
        [self.navigationController pushViewController:webView animated:YES];
    };
    
    [wzOrArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Margin_Right));
        make.centerY.equalTo(titleNameLab.mas_centerY);
        make.width.equalTo(@(80));
        make.height.equalTo(@(30.f));
    }];
    
    UIView *spliteLine = [[UIView alloc] initWithFrame:CGRectZero];
    spliteLine.backgroundColor = COLOR_LINE;
    [centerView addSubview:spliteLine];
    [spliteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleNameLab.mas_bottom).offset(Margin_Top);
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(centerView);
        make.height.equalTo(@(Line_Height));
    }];
    
    // 综合约定年化利率
    UIImageView * lsnhImageView = [[UIImageView alloc] init];
    lsnhImageView.image = [UIImage imageNamed:@"cg_nhsyl"];
    [centerView addSubview:lsnhImageView];
    [lsnhImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spliteLine.mas_bottom).offset(24.f);
        make.left.equalTo(@(Margin_Left));
    }];
    
    rateLab = [[UILabel alloc] init];
    rateLab.font  = TEXT_FONT_14;
    rateLab.text  =@"12%";
    rateLab.textColor = COLOR_MAIN_GREY;
    [centerView addSubview:rateLab];
    [rateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lsnhImageView.mas_right).offset(18.f);
        make.centerY.equalTo(lsnhImageView.mas_centerY).offset(-10);
    }];
    
    UILabel * tipsRateLab = [[UILabel alloc] init];
    tipsRateLab.font  = SMALL_TEXT_FONT_13;
    tipsRateLab.text  = XYBString(@"str_np_rate", @"综合约定年化利率");
    tipsRateLab.textColor = COLOR_AUXILIARY_GREY;
    [centerView addSubview:tipsRateLab];
    [tipsRateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rateLab.mas_left);
        make.centerY.equalTo(lsnhImageView.mas_centerY).offset(10);
    }];
    
    // 出借时间
    UIImageView * cjTimeImageView = [[UIImageView alloc] init];
    cjTimeImageView.image = [UIImage imageNamed:@"cg_cjsj"];
    [centerView addSubview:cjTimeImageView];
    [cjTimeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerView.mas_bottom).offset(-22.f);
        make.left.equalTo(@(Margin_Left));
    }];
    
    cjTimeLab = [[UILabel alloc] init];
    cjTimeLab.font  = TEXT_FONT_14;
    cjTimeLab.text  =@"2010-10-11";
    cjTimeLab.textColor = COLOR_MAIN_GREY;
    [centerView addSubview:cjTimeLab];
    [cjTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cjTimeImageView.mas_right).offset(18.f);
        make.centerY.equalTo(cjTimeImageView.mas_centerY).offset(-10);
    }];
    
    UILabel * tipsCjTimeLab = [[UILabel alloc] init];
    tipsCjTimeLab.font  = SMALL_TEXT_FONT_13;
    tipsCjTimeLab.text  = XYBString(@"str_financing_investTime", @"出借时间");
    tipsCjTimeLab.textColor = COLOR_AUXILIARY_GREY;
    [centerView addSubview:tipsCjTimeLab];
    [tipsCjTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cjTimeLab.mas_left);
        make.centerY.equalTo(cjTimeImageView.mas_centerY).offset(10);
    }];
    
    // 封闭期
    UIImageView * amonthImageView = [[UIImageView alloc] init];
    amonthImageView.image = [UIImage imageNamed:@"cg_fbq"];
    [centerView addSubview:amonthImageView];
    [amonthImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lsnhImageView.mas_top);
        make.left.equalTo(@(MainScreenWidth/2 + Margin_Left));
    }];
    
    amonthLab = [[UILabel alloc] init];
    amonthLab.font  = TEXT_FONT_14;
    amonthLab.text  = @"1个月";
    amonthLab.textColor = COLOR_MAIN_GREY;
    [centerView addSubview:amonthLab];
    [amonthLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(amonthImageView.mas_right).offset(18.f);
        make.centerY.equalTo(amonthImageView.mas_centerY).offset(-10);
    }];
    
    UILabel * tipsAmonthLab = [[UILabel alloc] init];
    tipsAmonthLab.font  = SMALL_TEXT_FONT_13;
    tipsAmonthLab.text  = XYBString(@"str_account_fbqtips", @"封闭期");
    tipsAmonthLab.textColor = COLOR_AUXILIARY_GREY;
    [centerView addSubview:tipsAmonthLab];
    [tipsAmonthLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(amonthLab.mas_left);
        make.centerY.equalTo(amonthImageView.mas_centerY).offset(10);
    }];
    
    // 集合期限
    UIImageView * jhqxImageView = [[UIImageView alloc] init];
    jhqxImageView.image = [UIImage imageNamed:@"cg_jhqx"];
    [centerView addSubview:jhqxImageView];
    [jhqxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerView.mas_bottom).offset(-22.f);
        make.left.equalTo(amonthImageView.mas_left);
    }];
    
    jhtermLab = [[UILabel alloc] init];
    jhtermLab.font  = TEXT_FONT_14;
    jhtermLab.text  =@"1个月";
    jhtermLab.textColor = COLOR_MAIN_GREY;
    [centerView addSubview:jhtermLab];
    [jhtermLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jhqxImageView.mas_right).offset(18.f);
        make.centerY.equalTo(jhqxImageView.mas_centerY).offset(-10);
    }];
    
    UILabel * tipsJhTermLab = [[UILabel alloc] init];
    tipsJhTermLab.font  = SMALL_TEXT_FONT_13;
    tipsJhTermLab.text  = XYBString(@"str_account_jhqxtips", @"集合期限");
    tipsJhTermLab.textColor = COLOR_AUXILIARY_GREY;
    [centerView addSubview:tipsJhTermLab];
    [tipsJhTermLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jhtermLab.mas_left);
        make.centerY.equalTo(jhqxImageView.mas_centerY).offset(10);
    }];
    
    #pragma mark  --  卡片
    cardView = [[UIView alloc] init];
    cardView.backgroundColor = COLOR_COMMON_WHITE;
    cardView.layer.cornerRadius = Corner_Radius_4;
    cardView.layer.shadowColor = COLOR_SHADOW_GRAY.CGColor;
    cardView.layer.shadowOffset = CGSizeMake(0,1);
    cardView.layer.shadowOpacity = 0.25;
    cardView.layer.shadowRadius = 4;
    [mainScollView addSubview:cardView];
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(110));
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(160));
    }];
    
    UILabel * tipsCjbjLab = [[UILabel alloc] init];
    tipsCjbjLab.text = XYBString(@"str_have_yuan", @"出借本金(元)");
    tipsCjbjLab.font = TEXT_FONT_14;
    tipsCjbjLab.textColor = COLOR_AUXILIARY_GREY;
    [cardView addSubview:tipsCjbjLab];
    [tipsCjbjLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(28));
        make.left.equalTo(@(20));
    }];
    
    WzOrArrowView * cjmxWzOrArrow = [[WzOrArrowView alloc] init];
    cjmxWzOrArrow.titleLabel.text = XYBString(@"str_bbg_lendDetail", @"出借明细");
    [cardView addSubview:cjmxWzOrArrow];
    
    cjmxWzOrArrow.blcokClick =^ (void)
    {
        if (depOrderDetail) {
            NPLoanDetailViewController * nploanDetail = [[NPLoanDetailViewController alloc] init];
            nploanDetail.orderId =  depOrderDetail.orderId;
            [self.navigationController pushViewController:nploanDetail animated:YES];
        }
    };
    
    [cjmxWzOrArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Margin_Right));
        make.centerY.equalTo(tipsCjbjLab.mas_centerY);
        make.width.equalTo(@(80));
        make.height.equalTo(@(30.f));
    }];
    
    
    cjbjLab = [[UILabel alloc] init];
    cjbjLab.text = @"5000.00";
    cjbjLab.font = FONT_BUTTON_NORMAL;
    cjbjLab.textColor = COLOR_INTRODUCE_ORANGE;
    [cardView addSubview:cjbjLab];
    [cjbjLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsCjbjLab.mas_bottom).offset(12);
        make.left.equalTo(tipsCjbjLab.mas_left);
    }];
    
    yqbjxLab = [[UILabel alloc] init];
    yqbjxLab.text = XYBString(@"str_account_qbjx", @"(已全部计息)");
    yqbjxLab.font = TEXT_FONT_12;
    yqbjxLab.hidden = YES;
    yqbjxLab.textColor = COLOR_LIGHT_GREY;
    [cardView addSubview:yqbjxLab];
    [yqbjxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cjbjLab.mas_bottom);
        make.left.equalTo(cjbjLab.mas_right);
    }];
    
    stageLab = [[UILabel alloc] init];
    stageLab.font = TEXT_FONT_14;
    stageLab.textColor = COLOR_AUXILIARY_GREY;
    stageLab.text = [NSString stringWithFormat:XYBString(@"str_dqbstage", @"已回款%@/%@期"),@"0",@"3"];
    [cardView addSubview:stageLab];
    [stageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cjbjLab.mas_bottom).offset(15);
        make.left.equalTo(cjbjLab.mas_left);
    }];
    
    WzOrArrowView * hkjlWzOrArrow = [[WzOrArrowView alloc] init];
    hkjlWzOrArrow.titleLabel.text = XYBString(@"str_account_hkjl", @"回款记录");
    [cardView addSubview:hkjlWzOrArrow];
    
    hkjlWzOrArrow.blcokClick =^ (void)
    {
        if (depOrderDetail) {
            NPBackRecordViewController * npBackRecord = [[NPBackRecordViewController alloc] init];
            npBackRecord.orderId  = depOrderDetail.orderId;
            [self.navigationController pushViewController:npBackRecord animated:YES];
        }
    };
    
    [hkjlWzOrArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Margin_Right));
        make.centerY.equalTo(stageLab.mas_centerY);
        make.width.equalTo(@(80));
        make.height.equalTo(@(30.f));
    }];
    
    
    stagehkLab = [[UILabel alloc] init];
    stagehkLab.font = TEXT_FONT_14;
    stagehkLab.textColor = COLOR_AUXILIARY_GREY;
    stagehkLab.text = [NSString stringWithFormat:XYBString(@"str_account_stageYuan", @"已回款%@元"),@"0.00"];
    [cardView addSubview:stagehkLab];
    [stagehkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stageLab.mas_bottom).offset(Margin_Top);
        make.left.equalTo(stageLab.mas_left);
    }];
    
    dhkLab = [[UILabel alloc] init];
    dhkLab.font = TEXT_FONT_14;
    dhkLab.textColor = COLOR_AUXILIARY_GREY;
    dhkLab.text = [NSString stringWithFormat:XYBString(@"str_account_dstageYuan", @"待回款%@元"),@"0.00"];
    [cardView addSubview:dhkLab];
    [dhkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(stagehkLab.mas_centerY);
        make.left.equalTo(stagehkLab.mas_right).offset(5);
    }];

    #pragma mark --  转让中 视图
    transferView = [[UIView alloc] init];
    transferView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScollView addSubview:transferView];
    [transferView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScollView);
        make.height.equalTo(@(235.f));
        make.top.equalTo(centerView.mas_bottom).offset(Margin_Top);
        make.bottom.equalTo(mainScollView.mas_bottom).offset(-Margin_Bottom);
    }];
    
    transferTitleLab = [[UILabel alloc] init];
    transferTitleLab.font  = BIG_TEXT_FONT_17;
    transferTitleLab.text  = @"转让中";
    transferTitleLab.textColor = COLOR_MAIN_GREY;
    [transferView addSubview:transferTitleLab];
    [transferTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(Margin_Left));
    }];
    
    WzOrArrowView * zrjlWzOrArrow = [[WzOrArrowView alloc] init];
    zrjlWzOrArrow.titleLabel.text = XYBString(@"str_trans_record", @"转让记录");
    [transferView addSubview:zrjlWzOrArrow];
    
    zrjlWzOrArrow.blcokClick =^ (void)
    {
        if (depOrderDetail) {
            NPAssignRecordViewController * npassignRecord = [[NPAssignRecordViewController alloc] init];
            npassignRecord.assignId  = depOrderDetail.assignId;
            [self.navigationController pushViewController:npassignRecord animated:YES];
        }
    };
    
    [zrjlWzOrArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Margin_Right));
        make.centerY.equalTo(transferTitleLab.mas_centerY);
        make.width.equalTo(@(80));
        make.height.equalTo(@(30.f));
    }];
    
    UIView *spliteZrzLine = [[UIView alloc] initWithFrame:CGRectZero];
    spliteZrzLine.backgroundColor = COLOR_LINE;
    [transferView addSubview:spliteZrzLine];
    [spliteZrzLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(transferTitleLab.mas_bottom).offset(Margin_Top);
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(transferView);
        make.height.equalTo(@(Line_Height));
    }];
    
    dtransferjeLab = [[UILabel alloc] init];
    dtransferjeLab.font  = GENERAL_MIDDLE_BIG_FONT;
    dtransferjeLab.text  = @"0.00";
    dtransferjeLab.textColor = COLOR_MAIN_GREY;
    [transferView addSubview:dtransferjeLab];
    [dtransferjeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spliteZrzLine.mas_bottom).offset(22.f);
        make.left.equalTo(@(Margin_Left));
    }];
    
    UILabel * tipsDtransferjeLab = [[UILabel alloc] init];
    tipsDtransferjeLab.font  = TEXT_FONT_14;
    tipsDtransferjeLab.text  = XYBString(@"str_Xtb_DzrPrincipaltips", @"待转让");
    tipsDtransferjeLab.textColor = COLOR_AUXILIARY_GREY;
    [transferView addSubview:tipsDtransferjeLab];
    [tipsDtransferjeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dtransferjeLab.mas_bottom).offset(8);
        make.left.equalTo(@(Margin_Left));
    }];
    
    UIImageView * arrowDtransferjeImageView = [[UIImageView alloc] init];
    arrowDtransferjeImageView.image = [UIImage imageNamed:@"gray_arrow"];
    [transferView addSubview:arrowDtransferjeImageView];
    [arrowDtransferjeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dtransferjeLab.mas_right).offset(Margin_Left);
        make.centerY.equalTo(dtransferjeLab);
    }];
    
    UILabel * tips1DtransferjeLab = [[UILabel alloc] init];
    tips1DtransferjeLab.font  = TEXT_FONT_14;
    tips1DtransferjeLab.text  = XYBString(@"str_Xtb_Zrz", @"转让中");
    tips1DtransferjeLab.textColor = COLOR_AUXILIARY_GREY;
    [transferView addSubview:tips1DtransferjeLab];
    [tips1DtransferjeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipsDtransferjeLab);
        make.centerX.equalTo(arrowRightImageView);
    }];
    
    ytransferjeLab = [[UILabel alloc] init];
    ytransferjeLab.font  = GENERAL_MIDDLE_BIG_FONT;
    ytransferjeLab.text  = @"0.00";
    ytransferjeLab.textColor = COLOR_MAIN_GREY;
    [transferView addSubview:ytransferjeLab];
    [ytransferjeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(arrowDtransferjeImageView);
        make.left.equalTo(arrowDtransferjeImageView.mas_right).offset(Margin_Left);
    }];
    
    UILabel * tipsYtransferjeLab = [[UILabel alloc] init];
    tipsYtransferjeLab.font  = TEXT_FONT_14;
    tipsYtransferjeLab.text  = XYBString(@"str_Xtb_Yzr", @"已转让");
    tipsYtransferjeLab.textColor = COLOR_AUXILIARY_GREY;
    [transferView addSubview:tipsYtransferjeLab];
    [tipsYtransferjeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tips1DtransferjeLab);
        make.left.equalTo(ytransferjeLab.mas_left);
    }];
    
    UIView *grayRound = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound.backgroundColor = COLOR_LINE_GREY;
    grayRound.layer.cornerRadius = Circular_WH/2;
    grayRound.layer.masksToBounds = YES;
    [transferView addSubview:grayRound];
    
    [grayRound mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.top.equalTo(tipsDtransferjeLab.mas_bottom).offset(20);
        make.width.height.equalTo(@Circular_WH);
    }];
    
    tipsZrzLab = [[UILabel alloc] init];
    tipsZrzLab.font  = SMALL_TEXT_FONT_13;
    tipsZrzLab.text  = [NSString stringWithFormat:XYBString(@"str_account_tipszrz", @"转让中，已耗时%@工作日，预计仍需要%@工作日"),@"1",@"1"];
    tipsZrzLab.textColor = COLOR_CELL_GREY;
    [transferView addSubview:tipsZrzLab];
    [tipsZrzLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(grayRound);
        make.left.equalTo(grayRound.mas_right).offset(5);
    }];

    UIView *splitebtZrzLine = [[UIView alloc] initWithFrame:CGRectZero];
    splitebtZrzLine.backgroundColor = COLOR_LINE;
    [transferView addSubview:splitebtZrzLine];
    [splitebtZrzLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(grayRound.mas_bottom).offset(17);
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(transferView);
        make.height.equalTo(@(Line_Height));
    }];
    
    UILabel * tipsSqtransfersjLab = [[UILabel alloc] init];
    tipsSqtransfersjLab.font  = SMALL_TEXT_FONT_13;
    tipsSqtransfersjLab.text  = XYBString(@"str_Xtb_TipsApplyTransfer_Time", @"申请转让时间");
    tipsSqtransfersjLab.textColor = COLOR_CELL_GREY;
    [transferView addSubview:tipsSqtransfersjLab];
    [tipsSqtransfersjLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(splitebtZrzLine.mas_bottom).offset(13);
        make.left.equalTo(@(Margin_Left));
    }];
    
    sqtransfersjLab = [[UILabel alloc] init];
    sqtransfersjLab.font  = SMALL_TEXT_FONT_13;
    sqtransfersjLab.text  = @"2010-10-09";
    sqtransfersjLab.textColor = COLOR_TITLE_GREY;
    [transferView addSubview:sqtransfersjLab];
    [sqtransfersjLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsSqtransfersjLab.mas_top);
        make.right.equalTo(@(-Margin_Left));
    }];
    
    
    UILabel * tipsSqtransferjeLabLab = [[UILabel alloc] init];
    tipsSqtransferjeLabLab.font  = SMALL_TEXT_FONT_13;
    tipsSqtransferjeLabLab.text  = XYBString(@"str_Xtb_TipsApplyTransfer_Je", @"申请转让金额");
    tipsSqtransferjeLabLab.textColor = COLOR_CELL_GREY;
    [transferView addSubview:tipsSqtransferjeLabLab];
    [tipsSqtransferjeLabLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-13));
        make.left.equalTo(@(Margin_Left));
    }];
    
    sqtransferjeLab = [[UILabel alloc] init];
    sqtransferjeLab.font  = SMALL_TEXT_FONT_13;
    sqtransferjeLab.text  = @"0.00元";
    sqtransferjeLab.textColor = COLOR_TITLE_GREY;
    [transferView addSubview:sqtransferjeLab];
    [sqtransferjeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsSqtransferjeLabLab.mas_top);
        make.right.equalTo(@(-Margin_Left));
    }];
    
    #pragma mark --  底部视图
    backButtomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 67)];
    backButtomView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:backButtomView];
    
    [backButtomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(67));
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    //添加阴影
    backButtomView.layer.shadowColor = [COLOR_SHADOW_GRAY colorWithAlphaComponent:0.1].CGColor;//阴影颜色
    backButtomView.layer.shadowOffset = CGSizeMake(0,-3);//阴影偏移,x向右偏移0，y向上偏移-3，默认(0, -3),这个跟shadowRadius配合使用
    backButtomView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    backButtomView.layer.shadowRadius = 4;//阴影半径，默认3
    
    zrStateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    zrStateLab.font = TEXT_FONT_14;
    zrStateLab.textColor = COLOR_TITLE_GREY;
    zrStateLab.text = @"暂不可转让";
    [backButtomView addSubview:zrStateLab];
    
    [zrStateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backButtomView.mas_top).offset(15);
        make.left.equalTo(@(Margin_Left));
    }];
    
    yjzrDateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    yjzrDateLab.font = TEXT_FONT_12;
    yjzrDateLab.textColor = COLOR_CELL_GREY;
    yjzrDateLab.text = @"2017-10-09";
    yjzrDateLab.numberOfLines = 0;
    [backButtomView addSubview:yjzrDateLab];
    
    [yjzrDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(zrStateLab.mas_bottom).offset(5);
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-170.f));
    }];
    
    zrBut = [[ColorButton alloc]initWithFrame:CGRectMake(0, 0, 140.f, Cell_Height) Title:XYBString(@"str_account_zr", @"转让")  ByGradientType:leftToRight];
    [zrBut addTarget:self action:@selector(clickTheZrBtn:) forControlEvents:UIControlEventTouchUpInside];
    zrBut.isColorEnabled = NO;
    [backButtomView addSubview:zrBut];
    
    [zrBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backButtomView.mas_centerY);
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(Cell_Height));
        make.width.equalTo(@(140.f));
    }];
    
}

- (NSString *)getProjectId:(NSString *)orderId orderNo:(NSString *)orderNo {
    NSString *projectStr = [NSString stringWithFormat:@"&orderId=%@&orderNo=%@", orderId, orderNo];
    return projectStr;
}

#pragma mark - 点击事件
-(void)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//转让事件
-(void)clickTheZrBtn:(id)sender
{
    NPAssignApplyViewController * npassignApply = [[NPAssignApplyViewController alloc] init];
    npassignApply.depOrderDetail = depOrderDetail;
    [self.navigationController pushViewController:npassignApply animated:YES];
}

#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    mainScollView.header = self.gifHeader1;
}

- (void)headerRereshing {
    [self refreshRequest];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [mainScollView.header endRefreshing];
}


#pragma mark - 数据处理

- (void)refreshUI:(CGDepOrderDetailListModel *)detailmodel
{
    dayLab.text  = [NSString stringWithFormat:XYBString(@"str_account_hkxssy", @"还可享受%@天收益"),detailmodel.restDay];
    
    NSString * pendingInterest = [[Utility replaceTheNumberForNSNumberFormatter:detailmodel.pendingInterest] stringByAppendingString:@"元"];
    djxLab.attributedText  =  [self setAmountTail:pendingInterest titLeColor:COLOR_COMMON_WHITE];
    
    NSString * payInterest = [[Utility replaceTheNumberForNSNumberFormatter:detailmodel.payInterest] stringByAppendingString:@"元"];
    yjxLab.attributedText  = [self setAmountTail:payInterest titLeColor:COLOR_COMMON_WHITE];
    
    
    NSString * strTitle = [NSString stringWithFormat:@"%@%@",detailmodel.gatherName,detailmodel.orderId];
    NSMutableAttributedString * attributedStrTitle = [[NSMutableAttributedString alloc] initWithString:strTitle];
    [attributedStrTitle addAttribute:NSForegroundColorAttributeName value:COLOR_AUXILIARY_GREY range:NSMakeRange(detailmodel.gatherName.length, detailmodel.orderId.length)];
    titleNameLab.attributedText   = attributedStrTitle;
    
    rateLab.text  = [NSString stringWithFormat:@"%@",[[Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[detailmodel.rate doubleValue] * 100]] stringByAppendingString:XYBString(@"str_financing_percentSymbol", @"%")]];
    cjTimeLab.text = detailmodel.orderDate;
    amonthLab.text = [NSString stringWithFormat:@"%@个月",detailmodel.lockMonths];
    jhtermLab.text = [NSString stringWithFormat:@"%@个月",detailmodel.loanMonths] ;
    
    cjbjLab.text   =  [Utility replaceTheNumberForNSNumberFormatter:detailmodel.orderAmount];
    stageLab.text = [NSString stringWithFormat:XYBString(@"str_dqbstage", @"已回款%@/%@期"),[StrUtil isEmptyString:detailmodel.refundedNum] ? @"0" : detailmodel.refundedNum,[StrUtil isEmptyString:detailmodel.totalRefundNum] ? @"0" : detailmodel.totalRefundNum];
    
    
    NSString * strStage = [NSString stringWithFormat:XYBString(@"str_account_stageYuan", @"已回款%@元"),[Utility replaceTheNumberForNSNumberFormatter:detailmodel.refundedAmount]];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:strStage];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:COLOR_TITLE_GREY range:NSMakeRange(3, strStage.length - 3)];
    stagehkLab.attributedText = attributedStr;
    
    NSString * strdhk = [NSString stringWithFormat:XYBString(@"str_account_dstageYuan", @"待回款%@元"),[Utility replaceTheNumberForNSNumberFormatter:detailmodel.refundingAmount]];
    NSMutableAttributedString * attributedStr1 = [[NSMutableAttributedString alloc] initWithString:strdhk];
    [attributedStr1 addAttribute:NSForegroundColorAttributeName value:COLOR_TITLE_GREY range:NSMakeRange(3, strdhk.length - 3)];
    dhkLab.attributedText = attributedStr1;
  
    //是否显示全部计息 pendingInterest 等于0  显示已全部计息 大于0 显示 待计息--已计息
    NSInteger pending = [detailmodel.pendingInterest integerValue];
    if (pending == 0) {
        yqbjxLab.hidden = NO;
    }else
    {
        yqbjxLab.hidden = YES;
    }
    
    NSString * strOrderState;
 
    if ([detailmodel.orderState integerValue] == 0 || pending > 0) { //0 匹配中
        
        transferView.hidden = YES;
        [transferView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0.f));
        }];
        
        headerjxView.hidden = NO;
        [headerjxView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dayLab.mas_bottom).offset(19);
            make.height.equalTo(@(50));
        }];
        
        [centerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.mas_bottom);
        }];
        
        [cardView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(110));
        }];
        
        [titleNameLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(75.f));
        }];
        
        zrStateLab.text = @"暂不可转让";
        zrBut.isColorEnabled = NO;
        yjzrDateLab.text = [StrUtil isEmptyString:detailmodel.startAssignDate] ? @"" : [NSString stringWithFormat:@"%@后可一键转让",detailmodel.startAssignDate];
        
    } else
    if ([detailmodel.orderState integerValue] == 2) { //2 已匹配
        
        transferView.hidden = YES;
        [transferView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0.f));
        }];
        
        headerjxView.hidden = YES;
        [headerjxView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dayLab.mas_bottom).offset(19);
            make.height.equalTo(@(0));
        }];
        
        headerView.frame = CGRectMake(0, 0, MainScreenWidth, 163);
        [headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@163);
        }];

        [centerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.mas_bottom);
        }];

        [cardView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(50));
        }];
        
        [titleNameLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(65.f));
        }];
        
        //当前时间>=开始转让时间，才能转让
        NSDate * currentDate = [DateTimeUtil dateFromString:detailmodel.currDate];//当前时间
        NSDate * startAssignDate = [DateTimeUtil dateFromString:detailmodel.startAssignDate];//开始转让时间
        
        int sateZr = [DateTimeUtil compareOneDay:currentDate withAnotherDay:startAssignDate];
        
        if (sateZr >= 0) {
            
            zrStateLab.text = @"可转让";
            yjzrDateLab.text     = @"系统自动匹配受让人，预计耗时2工作日";
            zrBut.isColorEnabled = YES;
            
        }else
        {
            //不能转让显示时间
            yjzrDateLab.text= [StrUtil isEmptyString:detailmodel.startAssignDate] ? @"" : [NSString stringWithFormat:@"%@后可一键转让",detailmodel.startAssignDate];
            zrStateLab.text = @"暂不可转让";
            zrBut.isColorEnabled = NO;
        }
    }
    else
    if ([detailmodel.orderState integerValue] == 4) { //4 转让中
        
        backButtomView.hidden = YES;
        strOrderState = @"转让中";
        transferView.hidden = NO;
        [transferView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(230.f));
        }];
        
        headerjxView.hidden = YES;
        [headerjxView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dayLab.mas_bottom).offset(19);
            make.height.equalTo(@(0));
        }];
        
        headerView.frame = CGRectMake(0, 0, MainScreenWidth, 163);
        [headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@163);
        }];
        
        [centerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.mas_bottom);
        }];
        
        [cardView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(50));
        }];
        
        [titleNameLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(65.f));
        }];
        
        //已耗时 当前时间 - 已转让时间
        tipsZrzLab.text  = [NSString stringWithFormat:XYBString(@"str_account_tipszrz", @"转让中，已耗时%@工作日，预计仍需要%@工作日"),[self dateTimeDifferenceWithStartTime:detailmodel.applyAssignDate endTime:detailmodel.currDate],@"1"];
        
        sqtransfersjLab.text  = detailmodel.applyAssignDate;
        sqtransferjeLab.text  = [Utility replaceTheNumberForNSNumberFormatter:detailmodel.assignAmount];
    }
    
    transferTitleLab.text = strOrderState;
    
    NSString * unAssignAmount = [[Utility replaceTheNumberForNSNumberFormatter:detailmodel.unAssignAmount] stringByAppendingString:@"元"];
    dtransferjeLab.attributedText   = [self setAmountTail:unAssignAmount titLeColor:COLOR_MAIN_GREY];
    
     NSString * assignedAmount = [[Utility replaceTheNumberForNSNumberFormatter:detailmodel.assignedAmount] stringByAppendingString:@"元"];
    ytransferjeLab.attributedText   = [self setAmountTail:assignedAmount titLeColor:COLOR_MAIN_GREY];
}

-(NSMutableAttributedString *)setAmountTail:(NSString *)str titLeColor:(UIColor *)color
{
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttributes:@{ NSFontAttributeName : WEAK_TEXT_FONT_11,
                                    NSForegroundColorAttributeName : color }
                           range:NSMakeRange(str.length - 1 , 1)];
    return attributedStr;
}

/**
 * 开始到结束的时间差
 */
- (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int day = (int)value / (24 *3600);
    
    NSString *str = [NSString stringWithFormat:@"%d",day]; ;

    return str;
}


- (void)refreshRequest
{
    [self cgOrderDetailRequestWebServiceWithParam];
}

-(void)cgOrderDetailRequestWebServiceWithParam
{
    
    NSMutableDictionary * parmDic = [[NSMutableDictionary alloc] init];
    [parmDic setObject: [StrUtil isEmptyString:self.orderId] ? @"" : self.orderId  forKey:@"orderId"];
    [parmDic setObject: [UserDefaultsUtil getUser].userId forKey:@"userId"];
    
    NSString *urlPath = [RequestURL getRequestURL:OrderDetailURL param:parmDic];
    
    [self showDataLoading];
    
    [WebService postRequest:urlPath param:parmDic JSONModelClass:[CgOrderDetailModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self hideLoading];
         CgOrderDetailModel * cgDepOrderDetail = responseObject;
         depOrderDetail  =  cgDepOrderDetail.orderDetail;
         [self refreshUI:cgDepOrderDetail.orderDetail];
         
         
     }fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
         
         [self hideLoading];
         [self showPromptTip:errorMessage];
     }
   ];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}



@end
