//
//  CGAccountStatisticsViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/18.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "CGAccountStatisticsViewController.h"
#import "Utility.h"
#import "AccountStatisticsCell.h"

@interface CGAccountStatisticsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    XYTableView * tableView;
}
@end

@implementation CGAccountStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self initUI];

}

#pragma mark -- 初始化 UI
-(void)setNav
{
    self.navItem.title = XYBString(@"str_account_statistics", @"账户统计");
    self.view.backgroundColor = COLOR_BG;
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

-(void)initUI
{
    tableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = COLOR_COMMON_CLEAR;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[AccountStatisticsCell class] forCellReuseIdentifier:@"accountStatisticsCell"];
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
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
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountStatisticsCell"
                                                                  forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[AccountStatisticsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"accountStatisticsCell"];
    }
    if (indexPath.row == 0) {
        cell.titleLabel.text = XYBString(@"str_cumulative_investment_profit", @"累计出借收益(元)");
        NSString *totalEarnedAmount = [NSString stringWithFormat:@"%@", [self.accountDic objectForKey:@"actualInteAmountTotal"]];
        if ([totalEarnedAmount doubleValue] != 0) {
            cell.contentLabel.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [totalEarnedAmount doubleValue]]]];
        } else {
            cell.contentLabel.text = XYBString(@"str_account_yuan", @"0.00元");
        }
    } else if (indexPath.row == 1) {
        cell.titleLabel.text = XYBString(@"str_cumulative_recharge", @"累计充值(元)");
        NSString *totalRecharge = [NSString stringWithFormat:@"%@", [self.accountDic objectForKey:@"rechargeAmountTotal"]];
        if ([totalRecharge doubleValue] != 0) {
            cell.contentLabel.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [totalRecharge doubleValue]]]];
        } else {
            cell.contentLabel.text = XYBString(@"str_account_yuan", @"0.00元");
        }
    } else if (indexPath.row == 2) {
        cell.titleLabel.text = XYBString(@"str_cumulative_withdrawals", @"累计提现(元)");
        NSString *totalWithdraw = [NSString stringWithFormat:@"%@", [self.accountDic objectForKey:@"withdrawAmountTotal"]];
        if ([totalWithdraw doubleValue] != 0) {
            cell.contentLabel.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [totalWithdraw doubleValue]]]];
        } else {
            cell.contentLabel.text = XYBString(@"str_account_yuan", @"0.00元");
        }
    } else if (indexPath.row == 3) {
        cell.titleLabel.text = XYBString(@"str_cumulative_incestment", @"累计出借(元)");
        NSString *totalLoanedAmount = [NSString stringWithFormat:@"%@", [self.accountDic objectForKey:@"depositAmountTotal"]];
        if ([totalLoanedAmount doubleValue] != 0) {
            cell.contentLabel.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [totalLoanedAmount doubleValue]]]];
        } else {
            cell.contentLabel.text = XYBString(@"str_account_yuan", @"0.00元");
        }
        cell.hasSplitLine = NO;
        [XYCellLine initWithBottomLineAtSuperView:cell.contentView];
    }
    return cell;
}

#pragma mark -- 点击事件
-(void)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- 数据处理


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
