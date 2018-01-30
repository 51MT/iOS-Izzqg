//
//  HnbProductDetailViewController.m
//  Ixyb
//
//  Created by wang on 16/10/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "HnbProductDetailViewController.h"
#import "BorrowDetailMainViewController.h"
#import "Utility.h"
#import "HnbDetailResponseModel.h"
#import "LoginFlowViewController.h"
#import "MJExtension.h"

#import "LoginFlowViewController.h"
#import "RiskEvaluatingViewController.h"
#import "WebService.h"
#import "XYAlertView.h"
#import "XtbBorrowDetailViewController.h"
#import "XtbInvestRecordViewController.h"
#import "NPBidDetailResModel.h"

#define INVEST_CYCLEDAY_TAG 1000

@interface HnbProductDetailViewController ()

@property (nonatomic, strong) NSArray  * bidList;
@property (nonatomic, strong) ColorButton *nextBtn;

//借款详情的数据源
@property (nonatomic, strong) NSMutableArray *dataSourse;

//出借记录的数据源
@property (nonatomic, strong) NSMutableArray *recordDataSourse;

//集合匹配Model
@property (nonatomic, strong)NPBidDetailResModel  *  depBideDetailData;

@end

@implementation HnbProductDetailViewController {
    
    XYScrollView *mainScroll;
    UIImageView *topImgView;
    
    UILabel *rateLab;           // 利率
    UILabel *minAmountLab;      // 起借金额
    UILabel *deadLineLab;       // 出借期限
    UILabel *repayLab;          // 还款方式
    
    UILabel *investLab;
    UILabel *time1;             // 出借日期
    UILabel *profitLab;
    UIImageView *progress2;
    UILabel *time2;             // 起息日期
    UILabel *time3;             // 到账日期
    UILabel *profitDay;         // • 满标当日，开始计息
    
    UILabel *titleLab;          // 标名
    UILabel *standardLab;       // 0个月起 先息后本
    
    UIView *whiteBackView;      //投资额度和投资按钮的背景
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_isNP == YES) {
        [self callNPBidDetailWebservice];
        return;
    }
    
    NSDictionary *paramMatching = @{
                                    @"projectId" : self.productId ,
                                    @"userId" : [Utility shareInstance].isLogin ? [UserDefaultsUtil getUser].userId : @"0",
                                    };
    [self requestHnbProductDetailWebserviceWithParam:paramMatching];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self createTopUI];
    [self createMiddleUI];
    [self createThirdUI];
}

- (void)setNav {
    self.navItem.title = XYBString(@"str_financing_projectDetail", @"项目详情");
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
        make.left.bottom.right.equalTo(self.view);
    }];
    
    topImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bbgBackImage"]];
    [mainScroll addSubview:topImgView];
    
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(mainScroll);
        make.height.equalTo(@(MainScreenWidth * 158/375));
    }];
    
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
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
    lab.font = TEXT_FONT_12;
    lab.textColor = COLOR_COMMON_WHITE;
    lab.text = XYBString(@"str_xtb_rate", @"年化借款利率");
    lab.textAlignment = NSTextAlignmentCenter;
    [topImgView addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topImgView.mas_centerX);
        make.top.equalTo(rateLab.mas_bottom).offset(7);
    }];
    
    
    //期限
    UILabel *minTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    minTitleLab.font = TEXT_FONT_12;
    minTitleLab.textColor = COLOR_COMMON_WHITE;
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
        make.left.equalTo(topImgView.mas_left).offset(Margin_Length);
        make.bottom.equalTo(topImgView.mas_bottom).offset(-Margin_Length);
    }];
    
    
    //期限
    UILabel *deadLab = [[UILabel alloc] initWithFrame:CGRectZero];
    deadLab.font = TEXT_FONT_12;
    deadLab.textColor = COLOR_COMMON_WHITE;
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
    UILabel *repaymentLab = [[UILabel alloc] initWithFrame:CGRectZero];
    repaymentLab.font = TEXT_FONT_12;
    repaymentLab.textColor = COLOR_COMMON_WHITE;
    repaymentLab.text = XYBString(@"str_financing_backMoney_type", @"还款方式");
    repaymentLab.textAlignment = NSTextAlignmentRight;
    [topImgView addSubview:repaymentLab];
    
    [repaymentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topImgView.mas_right).offset(-Margin_Length);
        make.bottom.equalTo(topImgView.mas_bottom).offset(-35);
    }];
    
    repayLab = [[UILabel alloc] initWithFrame:CGRectZero];
    repayLab.font = TEXT_FONT_BOLD_15;
    repayLab.textColor = COLOR_COMMON_WHITE;
    repayLab.text = XYBString(@"str_financing_expireBackProfitAndInvestMoney", @"到期还本息");
    repayLab.textAlignment = NSTextAlignmentCenter;
    [topImgView addSubview:repayLab];
    
    [repayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topImgView.mas_right).offset(-Margin_Length);
        make.bottom.equalTo(topImgView.mas_bottom).offset(-Margin_Length);
    }];
}


/**
 创建出借周期UI
 */
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
    
    UIView *blueLine = [[UIView alloc] initWithFrame:CGRectZero];
    blueLine.backgroundColor = COLOR_LINE_GREEN;
    [backView addSubview:blueLine];
    
    [blueLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.top.equalTo(cycleTimeLab.mas_bottom).offset(41);
        make.width.equalTo(@((MainScreenWidth - 30)/8));
        make.height.equalTo(@3);
    }];
    
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectZero];
    grayLine.backgroundColor = COLOR_LINE;
    [backView addSubview:grayLine];
    
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(blueLine.mas_right);
        make.centerY.equalTo(blueLine.mas_centerY);
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@3);
    }];
    
    UIImageView *progress1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"progress"]];
    progress1.backgroundColor = COLOR_COMMON_WHITE;
    [blueLine addSubview:progress1];
    
    [progress1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(blueLine.mas_left);
        make.centerY.equalTo(blueLine.mas_centerY);
    }];
    
    progress2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grayProgress"]];
    progress2.backgroundColor = COLOR_COMMON_WHITE;
    [grayLine addSubview:progress2];
    
    [progress2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset((MainScreenWidth - 30)/8);
        make.centerY.equalTo(blueLine.mas_centerY);
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
    investLab.textColor = COLOR_LINE_BLUE_01;
    investLab.text = XYBString(@"str_message_finance", @"出借");
    investLab.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:investLab];
    
    [investLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(Margin_Length);
        make.bottom.equalTo(blueLine.mas_top).offset(-9);
    }];
    
    profitLab = [[UILabel alloc] initWithFrame:CGRectZero];
    profitLab.font = TEXT_FONT_14;
    profitLab.textColor = COLOR_MAIN_GREY;
    profitLab.text = XYBString(@"str_financing_startProfit", @"起息");
    profitLab.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:profitLab];
    
    [profitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progress2.mas_left);
        make.bottom.equalTo(grayLine.mas_top).offset(-9);
    }];
    
    UILabel *accountLab = [[UILabel alloc] initWithFrame:CGRectZero];
    accountLab.font = TEXT_FONT_14;
    accountLab.textColor = COLOR_MAIN_GREY;
    accountLab.text = XYBString(@"str_financing_profitToAccount", @"到期");
    accountLab.textAlignment = NSTextAlignmentRight;
    [backView addSubview:accountLab];
    
    [accountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
        make.bottom.equalTo(grayLine.mas_top).offset(-9);
    }];
    
    time1 = [[UILabel alloc] initWithFrame:CGRectZero];
    time1.font = WEAK_TEXT_FONT_11;
    time1.textColor = COLOR_LINE_BLUE_01;
    time1.text = @"00-00";
    time1.textAlignment = NSTextAlignmentRight;
    [backView addSubview:time1];
    
    [time1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progress1.mas_left);
        make.top.equalTo(blueLine.mas_bottom).offset(11);
    }];
    
    time2 = [[UILabel alloc] initWithFrame:CGRectZero];
    time2.font = WEAK_TEXT_FONT_11;
    time2.textColor = COLOR_LIGHT_GREY;
    time2.text = @"00-00";
    time2.textAlignment = NSTextAlignmentRight;
    [backView addSubview:time2];
    
    [time2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progress2.mas_left);
        make.top.equalTo(grayLine.mas_bottom).offset(11);
    }];
    
    time3 = [[UILabel alloc] initWithFrame:CGRectZero];
    time3.font = WEAK_TEXT_FONT_11;
    time3.textColor = COLOR_LIGHT_GREY;
    time3.text = @"00-00";
    time3.textAlignment = NSTextAlignmentRight;
    [backView addSubview:time3];
    
    [time3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(grayLine.mas_right);
        make.top.equalTo(grayLine.mas_bottom).offset(11);
    }];
    
    NSString *str = XYBString(@"str_financing_bidFull_cauculateProfit", @"• 满标当日，开始计息\n• 项目募集期:不超过20个自然日");
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 6;
    
    NSMutableAttributedString *attrabutedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrabutedStr addAttributes:@{
                                   NSParagraphStyleAttributeName : style,
                                   NSForegroundColorAttributeName :COLOR_AUXILIARY_GREY
                                   } range:NSMakeRange(0, attrabutedStr.length - 1)];
    
    profitDay = [[UILabel alloc] initWithFrame:CGRectZero];
    profitDay.font = TEXT_FONT_14;
    profitDay.textColor = COLOR_AUXILIARY_GREY;
    profitDay.attributedText = attrabutedStr;
    profitDay.textAlignment = NSTextAlignmentLeft;
    profitDay.numberOfLines = 0;
    [backView addSubview:profitDay];
    
    [profitDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(Margin_Length);
        make.top.equalTo(time1.mas_bottom).offset(18);
        make.bottom.equalTo(backView.mas_bottom).offset(-Margin_Length);
    }];
}

/**
 创建UI中的第三部分：借款详情、出借记录、出借按钮
 */
- (void)createThirdUI {
    
    //借款详情
    XYButton *detailBtn = [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_financing_loanDetails", @"借款详情") titleColor:COLOR_MAIN_GREY isUserInteractionEnabled:YES];
    detailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    detailBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 51, 0, 0);
    [detailBtn addTarget:self action:@selector(clickTheBorrowDetailBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:detailBtn];
    
    UIView *topView = [mainScroll viewWithTag:INVEST_CYCLEDAY_TAG];
    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.width.equalTo(@(MainScreenWidth));
        make.top.equalTo(topView.mas_bottom).offset(10);
        make.height.equalTo(@(Cell_Height));
    }];
    
    UIImageView *borrowDetailImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [borrowDetailImage setImage:[UIImage imageNamed:@"containImage"]];
    [detailBtn addSubview:borrowDetailImage];
    
    [borrowDetailImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(detailBtn.mas_left).offset(Margin_Length);
        make.centerY.equalTo(detailBtn.mas_centerY);
    }];
    
    UIImageView *cellArrow = [[UIImageView alloc] init];
    cellArrow.image = [UIImage imageNamed:@"cell_arrow"];
    [detailBtn addSubview:cellArrow];
    
    [cellArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(detailBtn.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(detailBtn.mas_centerY);
    }];
    
    [XYCellLine initWithBottomLine_2_AtSuperView:detailBtn];
    
    //出借记录
    XYButton *investRecordBtn = [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_financing_investRecord", @"出借记录") titleColor:COLOR_MAIN_GREY isUserInteractionEnabled:YES];
    investRecordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    investRecordBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 51, 0, 0);
    [investRecordBtn addTarget:self action:@selector(clickInvestRecordBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:investRecordBtn];
    
    [investRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.width.equalTo(@(MainScreenWidth));
        make.top.equalTo(detailBtn.mas_bottom).offset(0);
        make.height.equalTo(@(Cell_Height));
        make.bottom.equalTo(mainScroll.mas_bottom).offset(-Margin_Length);
    }];
    
    UIImageView *investRecordImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [investRecordImage setImage:[UIImage imageNamed:@"investRecordImage"]];
    [investRecordBtn addSubview:investRecordImage];
    
    [investRecordImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(investRecordBtn.mas_left).offset(Margin_Length);
        make.centerY.equalTo(investRecordBtn.mas_centerY);
    }];
    
    UIImageView *cellArrow2 = [[UIImageView alloc] init];
    cellArrow2.image = [UIImage imageNamed:@"cell_arrow"];
    [investRecordBtn addSubview:cellArrow2];
    
    [cellArrow2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(investRecordBtn.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(investRecordBtn.mas_centerY);
    }];
}

#pragma mark - 返回点击事件

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//借款详情
- (void)clickTheBorrowDetailBtn:(id)sender {
    
    //集合匹配 借款详情
    if (_isNP == YES) {
        BorrowDetailMainViewController * borrowDetauil = [[BorrowDetailMainViewController alloc] init];
        borrowDetauil.bidDetailModel = _depBideDetailData;
        [self.navigationController pushViewController:borrowDetauil animated:YES];
        return;
    }
    
    if (_dataSourse) {
        XtbBorrowDetailViewController *detailVC = [[XtbBorrowDetailViewController alloc] init];
        detailVC.dataSource = _dataSourse;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

//出借记录
- (void)clickInvestRecordBtn:(id)sender {

    XtbInvestRecordViewController *recordVC = [[XtbInvestRecordViewController alloc] init];
    recordVC.recordArray = self.recordDataSourse;
    [self.navigationController pushViewController:recordVC animated:YES];
}

#pragma mark - 页面刷新

- (void)refreshUI:(HnbDetailResponseModel *)model {
    
    self.navItem.title = [NSString stringWithFormat:XYBString(@"str_financing_hnbProduct", @"惠农宝-%@"),model.product.title];
    
    //年化收益率
    NSString *rateStr = [[Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[model.product.baseRate doubleValue] * 100]] stringByAppendingString:XYBString(@"str_financing_percentSymbol", @"%")];
    
    NSMutableAttributedString *mutAttStr2 = [[NSMutableAttributedString alloc] initWithString:rateStr];
    [mutAttStr2 addAttributes:@{ NSFontAttributeName : XTB_RATE_FONT,
                                 NSForegroundColorAttributeName : COLOR_COMMON_WHITE }
                        range:NSMakeRange(0, rateStr.length - 1)];
    [mutAttStr2 addAttributes:@{ NSFontAttributeName : TEXT_FONT_12,
                                 NSForegroundColorAttributeName : COLOR_COMMON_WHITE }
                        range:NSMakeRange(rateStr.length - 1 , 1)];
    rateLab.attributedText = mutAttStr2;
    
    
    //起投金额
    minAmountLab.text = [Utility replaceTheNumberForNSNumberFormatter:model.product.minBidAmount];
    
    //出借期限
    deadLineLab.text = [NSString stringWithFormat:@"%@", model.product.monthes2ReturnStr];
    
    //还款方式
    repayLab.text = [NSString stringWithFormat:@"%@", model.product.returnTypeString];
    
    
    //进度条改变，显示两个进度圈
    investLab.text = XYBString(@"str_financing_startProfit", @"起息");
    time1.text = [StrUtil isEmptyString:model.product.interestDate] ? @"00-00" : model.product.interestDate;
    
    //隐藏进度圈
    profitLab.hidden = YES;
    progress2.hidden = YES;
    time2.hidden = YES;
    time3.text = model.product.refundDate;

    
    //1.出借日期、2.满标日期、3.到账日期
//    NSDate *date = [self stringToDate:model.product.orderDate withDateFormat:@"yyyy-MM-dd"];
//    BOOL isThisYear = [self isThisYearWithDate:date];
//    
//    if (isThisYear) {
//        time1.text = [model.product.orderDate substringFromIndex:5];
//    }else{
//        time1.text = model.product.orderDate;
//    }
//    
//    time2.text = XYBString(@"str_financing_bidFullDay", @"满标日");
//    
//    NSString *timeStr3 = [NSString stringWithFormat:XYBString(@"str_financing_mbhjgy", @"满标后%@个月"), model.product.monthes2Return];
//    time3.text = timeStr3;
}

- (void)reloadDataForUI:(NPBidDetailResModel *)model {
    
    self.navItem.title = [NSString stringWithFormat:XYBString(@"str_financing_hnbProduct", @"惠农宝-%@"),model.product.title];
    
    //年化收益率
    NSString *rateStr = [[Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[model.product.baseRate doubleValue] * 100]] stringByAppendingString:XYBString(@"str_financing_percentSymbol", @"%")];
    
    NSMutableAttributedString *mutAttStr2 = [[NSMutableAttributedString alloc] initWithString:rateStr];
    [mutAttStr2 addAttributes:@{ NSFontAttributeName : XTB_RATE_FONT,
                                 NSForegroundColorAttributeName : COLOR_COMMON_WHITE }
                        range:NSMakeRange(0, rateStr.length - 1)];
    [mutAttStr2 addAttributes:@{ NSFontAttributeName : TEXT_FONT_12,
                                 NSForegroundColorAttributeName : COLOR_COMMON_WHITE }
                        range:NSMakeRange(rateStr.length - 1 , 1)];
    rateLab.attributedText = mutAttStr2;
    
    
    //起投金额
    minAmountLab.text = [Utility replaceTheNumberForNSNumberFormatter:model.product.minBidAmount];
    
    //出借期限
    deadLineLab.text = [NSString stringWithFormat:@"%@", model.product.monthes2ReturnStr];
    
    //还款方式
    repayLab.text = [NSString stringWithFormat:@"%@", model.product.returnTypeString];
    
    
    //进度条改变，显示两个进度圈
    investLab.text = XYBString(@"str_financing_startProfit", @"起息");
    time1.text = [StrUtil isEmptyString:model.product.interestDate] ? @"00-00" : model.product.interestDate;
    
    //隐藏进度圈
    profitLab.hidden = YES;
    progress2.hidden = YES;
    time2.hidden = YES;
    time3.text = model.product.refundDate;
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

#pragma mark - 匹配惠农宝详情数据接口

- (void)requestHnbProductDetailWebserviceWithParam:(NSDictionary *)param {
    NSString *requestURL = [RequestURL getRequestURL:HnbMatchingProductURL param:param];

    [self showDataLoading];
    [WebService postRequest:requestURL param:param JSONModelClass:[HnbDetailResponseModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        HnbDetailResponseModel *responseModel = responseObject;
                        _dataSourse = [[NSMutableArray alloc] initWithArray:responseModel.detailList];
                        _recordDataSourse = [[NSMutableArray alloc] initWithArray:responseModel.bidList];
                        [self refreshUI:responseModel];
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
}

#pragma mark - 适用于“一键出借”产品匹配的标 数据请求

/**
 适用于“一键出借”产品匹配的标 数据请求
 */
- (void)callNPBidDetailWebservice {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[UserDefaultsUtil getUser].userId forKey:@"userId"];
    [params setValue:self.productId forKey:@"loanId"];
    [params setValue:self.matchType forKey:@"matchType"];
    
    [self requestNPDetailWebserviceWithParam:params];
}

- (void)requestNPDetailWebserviceWithParam:(NSDictionary *)param {
    
    NSString *requestURL = [RequestURL getRequestURL:OneKeyProductLoanBidDet_URL param:param];
    [self showDataLoading];
    [WebService postRequest:requestURL param:param JSONModelClass:[NPBidDetailResModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        _depBideDetailData = responseObject;
                        _recordDataSourse = [[NSMutableArray alloc] initWithArray:_depBideDetailData.bidList];
                        [self reloadDataForUI:_depBideDetailData];
                    }
     
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           
                           [self hideLoading];
                           [self showDelayTip:errorMessage];
                       }
     
     ];
}

@end
