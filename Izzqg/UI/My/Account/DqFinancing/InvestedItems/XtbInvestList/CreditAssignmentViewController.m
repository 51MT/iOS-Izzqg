//
//  CreditAssignmentViewController.m
//  Ixyb
//
//  Created by dengjian on 10/16/15.
//  Copyright (c) 2015 xyb. All rights reserved.
//

#import "CreditAssignmentDescriptionViewController.h"
#import "CreditAssignmentRecordViewController.h"
#import "CreditAssignmentViewController.h"
#import "DMInvestedProject.h"
#import "DqbOrXtbModel.h"
#import "HomeCircleProgressView.h"
#import "InvestedDetailXtbViewController.h"
#import "MJRefresh.h"
#import "Utility.h"
#import "WebService.h"

#define VIEW_TAG_TITLE_LABEL 50601
#define VIEW_TAG_PRECENT_LABEL 50602
#define VIEW_TAG_AMOUNT_LABEL 50603
#define VIEW_TAG_INVESTED_AMOUNT_LABEL 50604
#define VIEW_TAG_BEGIN_LABEL 50605
#define VIEW_TAG_TRANS_LABEL 50606
#define VIEW_TAG_PROGRES_LABEL 50607

@interface CreditAssignmentViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSDictionary *productInfo;

@end

@implementation CreditAssignmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNav];
    [self initScrollView];
    [self setupRefresh];
    [self updateDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initNav {
    self.navItem.title = XYBString(@"str_zqzr", @"债权转让");
    self.view.backgroundColor = COLOR_BG;

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)refershScrollView {

    UILabel *titleLabel = (UILabel *) [self.scrollView viewWithTag:VIEW_TAG_TITLE_LABEL];
    UILabel *precentLabel = (UILabel *) [self.scrollView viewWithTag:VIEW_TAG_PRECENT_LABEL];
    UILabel *amountLabel = (UILabel *) [self.scrollView viewWithTag:VIEW_TAG_AMOUNT_LABEL];
    UILabel *investedAmountLabel = (UILabel *) [self.scrollView viewWithTag:VIEW_TAG_INVESTED_AMOUNT_LABEL];
    UILabel *beginLabel = (UILabel *) [self.scrollView viewWithTag:VIEW_TAG_BEGIN_LABEL];
    UILabel *transLabel = (UILabel *) [self.scrollView viewWithTag:VIEW_TAG_TRANS_LABEL];

    HomeCircleProgressView *circleProgress = (HomeCircleProgressView *) [self.scrollView viewWithTag:VIEW_TAG_PROGRES_LABEL];

    titleLabel.text = self.productInfo[@"title"];
    CGFloat rate = [self.productInfo[@"actualRate"] floatValue];
    precentLabel.attributedText = [Utility rateAttributedStr:rate size:26.6f sizeSymble:13.3f color:COLOR_COMMON_BLACK];

    NSString *amountText_ = [NSString stringWithFormat:@"%.2f", [self.productInfo[@"restAmount"] doubleValue]];
    NSString *amountText = @"0.00";
    if (![amountText_ isEqualToString:@"0.00"]) {
        amountText = [Utility replaceTheNumberForNSNumberFormatter:amountText_];
    }
    NSMutableAttributedString *amountStr = [[NSMutableAttributedString alloc] initWithString:amountText];
    [amountStr addAttributes:@{ NSForegroundColorAttributeName : COLOR_COMMON_BLACK,
                                NSFontAttributeName : [UIFont systemFontOfSize:37.0f] }
                       range:NSMakeRange(0, [amountText length] - 3)];
    [amountStr addAttributes:@{ NSForegroundColorAttributeName : COLOR_COMMON_BLACK,
                                NSFontAttributeName : [UIFont systemFontOfSize:17.0f] }
                       range:NSMakeRange([amountText length] - 3, 3)];
    amountLabel.attributedText = amountStr;

    CGFloat traamAmount = [self.productInfo[@"amount"] doubleValue];
    NSString *investAmtS = [NSString stringWithFormat:@"%.2f", traamAmount];
    NSString *investAmtStr = [Utility replaceTheNumberForNSNumberFormatter:investAmtS];
    investedAmountLabel.text = [NSString stringWithFormat:XYBString(@"str_invest_all_amount", @"总投%@元"), investAmtStr];

    beginLabel.text = [NSString stringWithFormat:XYBString(@"str_begin_trans_date", @"开始转让日: %@"), self.productInfo[@"assignDate"]];

    CGFloat traam = [self.productInfo[@"acceptAmount"] doubleValue];
    NSString *transAmtS = [NSString stringWithFormat:@"%.2f", traam];
    NSString *transAmtStr = [Utility replaceTheNumberForNSNumberFormatter:transAmtS];
    transLabel.text = [NSString stringWithFormat:XYBString(@"str_some_yuan", @"%@元"), transAmtStr];

    [circleProgress setProgress:[self.productInfo[@"assignProgress"] doubleValue] animated:YES];
}
- (void)initScrollView {

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = COLOR_COMMON_WHITE;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    UIView *assistView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:assistView]; //撑大scrollview的
    assistView.backgroundColor = COLOR_COMMON_CLEAR;
    [assistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@(1));
        make.width.equalTo(@(MainScreenWidth));

    }];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = XYBString(@"str_title_tip", @"定期宝-当季满盈156");
    titleLabel.font = TEXT_FONT_16;
    titleLabel.tag = VIEW_TAG_TITLE_LABEL;
    [self.scrollView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@32);
        make.centerX.equalTo(self.view);
    }];

    CGFloat circleProgressWidth = 261.5;
    HomeCircleProgressView *circleProgress = [[HomeCircleProgressView alloc] initWithFrame:CGRectMake(20, 5, circleProgressWidth, circleProgressWidth)];
    circleProgress.tag = VIEW_TAG_PROGRES_LABEL;
    circleProgress.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"circle_bttom"]];
    [self.scrollView addSubview:circleProgress];

    [circleProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(32);
        make.centerX.equalTo(self.scrollView.mas_centerX);
        make.height.width.equalTo(@(circleProgressWidth));
    }];
    circleProgress.trackColor = COLOR_LINE;
    circleProgress.progressColor = COLOR_MAIN;
    circleProgress.progressWidth = 3.0f;
    [circleProgress setProgress:0.3f animated:NO];

    //    UIButton *viewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.scrollView addSubview:viewButton];
    //    viewButton.backgroundColor = COLOR_COMMON_CLEAR;
    //    [viewButton addTarget:self action:@selector(clickViewButton:) forControlEvents:UIControlEventTouchUpInside];
    //    [viewButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(circleProgress.mas_centerX);
    //        make.bottom.equalTo(circleProgress.mas_centerY).offset(0);
    //        make.height.equalTo(@30);
    //    }];
    //

    //    UIImageView *viewImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    //    viewImageView.image = [UIImage imageNamed:@"icon_info_bule"];
    //    [viewButton addSubview:viewImageView];
    //    [viewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(@0);
    //        make.centerY.equalTo(viewButton.mas_centerY);
    //        make.left.equalTo(tip3Label.mas_right).offset(5);
    //    }];

    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:amountLabel];
    amountLabel.text = @"57,852.11";
    amountLabel.tag = VIEW_TAG_AMOUNT_LABEL;
    amountLabel.font = [UIFont systemFontOfSize:37.0f];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(circleProgress.mas_centerX);
        make.centerY.equalTo(circleProgress.mas_centerY);
    }];

    UILabel *tip3Label = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:tip3Label];
    tip3Label.text = XYBString(@"str_remain_benjin", @"剩余债权本金(元)");
    tip3Label.font = [UIFont systemFontOfSize:14.0f];
    tip3Label.textColor = COLOR_AUXILIARY_GREY;
    [tip3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(amountLabel.mas_top).offset(-9);
        make.centerX.equalTo(circleProgress.mas_centerX);
    }];

    UILabel *beginLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:beginLabel];
    beginLabel.text = XYBString(@"str_begin_trans_date_default", @"开始转让日 2015-10-21");
    beginLabel.font = TEXT_FONT_10;
    beginLabel.textColor = COLOR_LIGHT_GREY;
    beginLabel.tag = VIEW_TAG_BEGIN_LABEL;
    [beginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountLabel.mas_bottom).offset(9);
        make.centerX.equalTo(circleProgress.mas_centerX);
    }];

    UILabel *precentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:precentLabel];
    precentLabel.text = @"0%";
    precentLabel.font = BORROW_TEXT_FONT_40;
    precentLabel.textColor = COLOR_COMMON_BLACK;
    precentLabel.tag = VIEW_TAG_PRECENT_LABEL;
    [precentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(circleProgress.mas_bottom).offset(45);
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    UILabel *tip1Label = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:tip1Label];
    tip1Label.text = XYBString(@"str_xtb_rate", @"年化借款利率");
    tip1Label.font = TEXT_FONT_14;
    tip1Label.textColor = COLOR_LIGHT_GREY;
    [tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(precentLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    UIView *otherView = [[UIView alloc] initWithFrame:CGRectZero];
    otherView.backgroundColor = COLOR_BG;
    otherView.clipsToBounds = YES;
    otherView.layer.borderWidth = Border_Width;
    otherView.layer.cornerRadius = Corner_Radius;
    otherView.layer.borderColor = [COLOR_LIGHT_GREY CGColor];
    [self.scrollView addSubview:otherView];

    [otherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.height.equalTo(@83);
        make.top.equalTo(tip1Label.mas_bottom).offset(45);
        make.bottom.equalTo(self.scrollView.mas_bottom).offset(-Margin_Bottom);
    }];

    UIView *splitView = [[UIView alloc] initWithFrame:CGRectZero];
    splitView.backgroundColor = COLOR_LINE;
    [otherView addSubview:splitView];
    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Line_Height));
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0);
        make.height.equalTo(@50);
    }];

    //左边的
    UILabel *investAmountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    investAmountLabel.text = XYBString(@"str_amount_milian", @"总投100,000元");
    investAmountLabel.font = TEXT_FONT_16;
    investAmountLabel.tag = VIEW_TAG_INVESTED_AMOUNT_LABEL;
    [otherView addSubview:investAmountLabel];
    [investAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(otherView.mas_centerX).offset(-80);
        make.bottom.equalTo(otherView.mas_centerY).offset(-8);
    }];

    UIButton *viewLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [otherView addSubview:viewLeftButton];
    viewLeftButton.backgroundColor = COLOR_COMMON_CLEAR;
    [viewLeftButton addTarget:self action:@selector(clickViewLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    [viewLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(investAmountLabel.mas_centerX);
        make.top.equalTo(investAmountLabel.mas_centerY).offset(7);
        make.height.equalTo(@30);
    }];

    UILabel *tip4Label = [[UILabel alloc] initWithFrame:CGRectZero];
    [viewLeftButton addSubview:tip4Label];
    tip4Label.text = XYBString(@"str_look", @"查看");
    tip4Label.font = [UIFont systemFontOfSize:13.0f];
    tip4Label.textColor = COLOR_LIGHT_GREY;
    [tip4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.centerY.equalTo(viewLeftButton.mas_centerY);
    }];

    UIImageView *view1ImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    view1ImageView.image = [UIImage imageNamed:@"icon_look"];
    [viewLeftButton addSubview:view1ImageView];
    [view1ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.centerY.equalTo(viewLeftButton.mas_centerY);
        make.left.equalTo(tip4Label.mas_right).offset(5);
    }];

    //右边的
    UILabel *transRecordLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    transRecordLabel.text = XYBString(@"str_trans_record", @"转让记录");
    transRecordLabel.font = TEXT_FONT_16;
    [otherView addSubview:transRecordLabel];
    [transRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(otherView.mas_centerX).offset(80);
        make.bottom.equalTo(otherView.mas_centerY).offset(-8);
    }];

    UIButton *viewRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [otherView addSubview:viewRightButton];
    viewRightButton.backgroundColor = COLOR_COMMON_CLEAR;
    [viewRightButton addTarget:self action:@selector(clickViewRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [viewRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(transRecordLabel.mas_centerX);
        make.top.equalTo(transRecordLabel.mas_centerY).offset(7);
        make.height.equalTo(@30);
    }];

    UILabel *recordLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [viewRightButton addSubview:recordLabel];
    recordLabel.text = XYBString(@"str_2220_yuan", @"2,220元");
    recordLabel.font = [UIFont systemFontOfSize:13.0f];
    recordLabel.textColor = COLOR_LIGHT_GREY;
    recordLabel.tag = VIEW_TAG_TRANS_LABEL;
    [recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.centerY.equalTo(viewRightButton.mas_centerY);
    }];

    UIImageView *view2ImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    view2ImageView.image = [UIImage imageNamed:@"icon_look"];
    [viewRightButton addSubview:view2ImageView];
    [view2ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.centerY.equalTo(viewRightButton.mas_centerY);
        make.left.equalTo(recordLabel.mas_right).offset(5);
    }];
}

#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    _scrollView.header = self.gifHeader3;
}

- (void)headerRereshing {
    [self updateDetail];
}

- (void)clickViewButton:(id)sender {
}

- (void)clickViewLeftButton:(id)sender {

//    InvestedDetailXtbViewController *vc = [[InvestedDetailXtbViewController alloc] init];
//    vc.investedProject = self.investedProject;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickViewRightButton:(id)sender {
    CreditAssignmentRecordViewController *vc = [[CreditAssignmentRecordViewController alloc] init];
    vc.dicInfo = self.dicZqjlInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateDetail {

    NSDictionary *param = @{
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"projectType" : [NSNumber numberWithInteger:[[self.dicZqjlInfo objectForKey:@"projectType"] integerValue]],
        @"orderId" : [NSNumber numberWithInteger:[[self.dicZqjlInfo objectForKey:@"orderId"]integerValue]],
    };

    [self showDataLoading];

    NSString *urlPath = [RequestURL getRequestURL:InvestDetailURL param:param];
    [WebService postRequest:urlPath param:param JSONModelClass:[DqbOrXtbModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            [self.scrollView.header endRefreshing];
            DqbOrXtbModel *dqbOrXtb = responseObject;
            NSDictionary *resultDic = dqbOrXtb.toDictionary;
            if (dqbOrXtb.resultCode == 1) {
                NSDictionary *productInfo = [resultDic objectForKey:@"productInfo"];
                self.productInfo = [NSDictionary dictionaryWithDictionary:productInfo];
                [self refershScrollView];
            }
        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self.scrollView.header endRefreshing];
            [self showPromptTip:errorMessage];
        }

    ];
}

@end
