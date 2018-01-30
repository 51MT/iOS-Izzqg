//
//  AccountStatisticsViewController.m
//  Ixyb
//
//  Created by wang on 16/11/16.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "AccountStatisticsCell.h"
#import "AccountStatisticsViewController.h"
#import "MJRefresh.h"
#import "Utility.h"
#import "XYCellLine.h"

@interface AccountStatisticsViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation AccountStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initUI {
    [self initNav];
    [self initTableView];
}

- (void)initNav {
    self.navItem.title = XYBString(@"str_account_statistics", @"账户统计");
    self.view.backgroundColor = COLOR_BG;

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initTableView {
    self.tableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = COLOR_COMMON_CLEAR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[AccountStatisticsCell class] forCellReuseIdentifier:@"accountStatisticsCell"];
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).offset(-53);
    }];
    //    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateInvested)];
}

- (void)updateInvested {
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return INVESTED_DETAIL_TABLEVEIW_CELL_HEIGHT;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountStatisticsCell"
                                                                  forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[AccountStatisticsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"accountStatisticsCell"];
    }
    if (indexPath.row == 0) {
        cell.titleLabel.text = XYBString(@"str_cumulative_investment_profit", @"累计出借收益(元)");
        NSString *totalEarnedAmount = [NSString stringWithFormat:@"%@", [self.accountDic objectForKey:@"totalEarnedAmount"]];
        if ([totalEarnedAmount doubleValue] != 0) {
            cell.contentLabel.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [totalEarnedAmount doubleValue]]]];
        } else {
            cell.contentLabel.text = XYBString(@"str_account_yuan", @"0.00元");
        }
    } else if (indexPath.row == 1) {
        cell.titleLabel.text = XYBString(@"str_cumulative_recharge", @"累计充值(元)");
        NSString *totalRecharge = [NSString stringWithFormat:@"%@", [self.accountDic objectForKey:@"totalRecharge"]];
        if ([totalRecharge doubleValue] != 0) {
            cell.contentLabel.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [totalRecharge doubleValue]]]];
        } else {
            cell.contentLabel.text = XYBString(@"str_account_yuan", @"0.00元");
        }
    } else if (indexPath.row == 2) {
        cell.titleLabel.text = XYBString(@"str_cumulative_withdrawals", @"累计提现(元)");
        NSString *totalWithdraw = [NSString stringWithFormat:@"%@", [self.accountDic objectForKey:@"totalWithdraw"]];
        if ([totalWithdraw doubleValue] != 0) {
            cell.contentLabel.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [totalWithdraw doubleValue]]]];
        } else {
            cell.contentLabel.text = XYBString(@"str_account_yuan", @"0.00元");
        }
    } else if (indexPath.row == 3) {
        cell.titleLabel.text = XYBString(@"str_cumulative_incestment", @"累计出借(元)");
        NSString *totalLoanedAmount = [NSString stringWithFormat:@"%@", [self.accountDic objectForKey:@"totalLoanedAmount"]];
        if ([self.accountInfoStatistics.totalInterest2callback doubleValue] != 0) {
            cell.contentLabel.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [totalLoanedAmount doubleValue]]]];
        } else {
            cell.contentLabel.text = XYBString(@"str_account_yuan", @"0.00元");
        }
    } else if (indexPath.row == 4) {
        cell.titleLabel.text = XYBString(@"str_deductible_lj", @"抵扣礼金(元)");
        NSString *usedRewardAmount = [NSString stringWithFormat:@"%@", [self.accountDic objectForKey:@"usedRewardAmount"]];

        if ([usedRewardAmount doubleValue] != 0) {
            cell.contentLabel.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [usedRewardAmount doubleValue]]]];
        } else {
            cell.contentLabel.text = XYBString(@"str_account_yuan", @"0.00元");
        }
        cell.hasSplitLine = NO;
        [XYCellLine initWithBottomLineAtSuperView:cell.contentView];
    }
    return cell;
}
@end
