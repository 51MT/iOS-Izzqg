//
//  CGAccountAssetsViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/18.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "CGAccountAssetsViewController.h"
#import "CGAccountStatisticsViewController.h"
#import "NPInvestedListViewController.h"
#import "Utility.h"

@interface CGAccountAssetsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    XYTableView *  tableView;      // 主视图
    UILabel     *  totalAmountLab; // 账户金额
    UILabel     *  yjcjAmountLab;  // 一键出借金额
    UILabel     *  kyAmountLab;    // 可用余额
    UILabel     *  djAmountLab;    // 冻结本金
    UILabel     *  djytAmountLab;  // 冻结本金底部
    UILabel     *  dssyLab;        // 待收收益
}

@end

@implementation CGAccountAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self initUI];
}

#pragma mark -- 初始化 UI
-(void)setNav
{
    self.navItem.title = XYBString(@"string_all_asert", @"总资产");
    self.view.backgroundColor = COLOR_BG;
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 60.0f, 40.0f);
    [button setTitle:XYBString(@"str_account_statistics", @"账户统计") forState:UIControlStateNormal];
    button.titleLabel.font = TEXT_FONT_14;
    [button addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:COLOR_COMMON_GRAY forState:UIControlStateHighlighted];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
}

-(void)initUI
{
    tableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = COLOR_COMMON_CLEAR;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    UIView * viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 121.f)];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = viewHead.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id) COLOR_MAIN.CGColor,
                       (id) COLOR_LIGHT_BLUE.CGColor, nil];
    [viewHead.layer addSublayer:gradient];
    
    tableView.tableHeaderView = viewHead;
    
    totalAmountLab = [[UILabel alloc] init];
    totalAmountLab.font  = DQB_RATE_37;
    totalAmountLab.text  = @"0.00";
    totalAmountLab.textColor = COLOR_COMMON_WHITE;
    [viewHead addSubview:totalAmountLab];
    [totalAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(27));
        make.centerX.equalTo(viewHead.mas_centerX);
    }];
    
    if ([self.accountStatInfo.totalAsset doubleValue] != 0) {
        totalAmountLab.text = [Utility replaceTheNumberForNSNumberFormatter:_accountStatInfo.totalAsset];
    }
    
    UILabel *  tipsTotalAmountLab = [[UILabel alloc] init];
    tipsTotalAmountLab.font  = TEXT_FONT_16;
    tipsTotalAmountLab.text  = XYBString(@"str_tip_all_asset", @"总资产(元)");
    tipsTotalAmountLab.textColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:0.6f];
    [viewHead addSubview:tipsTotalAmountLab];
    [tipsTotalAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalAmountLab.mas_bottom).offset(9.f);
        make.centerX.equalTo(viewHead.mas_centerX);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return 2;
    }
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return Cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
        return 15.f;
    }
    return 0.1f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    UILabel * leftLabl = [[UILabel alloc] init];
    leftLabl.textColor = COLOR_AUXILIARY_GREY;
    leftLabl.font = NORMAL_TEXT_FONT_15;
    [cell.contentView addSubview:leftLabl];
    [leftLabl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.centerY.equalTo(cell.contentView);
    }];
    
    float rightJj = indexPath.section == 0 ? 8.f : 15.f;
    
    UILabel * detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"0.00元";
    detailLabel.font = NORMAL_TEXT_FONT_15;
    detailLabel.textColor = COLOR_MAIN_GREY;
    [cell.contentView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.right.equalTo(@(-rightJj));
    }];
    
    switch (indexPath.section) {
        case 0:
        {
            leftLabl.text = XYBString(@"str_account_yjcjzc", @"一键出借资产");
            if ([self.accountStatInfo.cashOrderPrinAmountTotal doubleValue] != 0) {
                detailLabel.text = [[Utility replaceTheNumberForNSNumberFormatter:_accountStatInfo.cashOrderPrinAmountTotal] stringByAppendingString:@"元"];
            }
        }
        break;
        case 1:
        {
            if (indexPath.row == 0) {
                leftLabl.text = XYBString(@"string_usable_amount", @"可用余额");
                if ([self.accountStatInfo.usableAmt doubleValue] != 0) {
                    detailLabel.text = [[Utility replaceTheNumberForNSNumberFormatter:_accountStatInfo.usableAmt]stringByAppendingString:@"元"];
                }
                [XYCellLine initWithBottomLine_2_AtSuperView:cell.contentView];
            }else if (indexPath.row == 1)
            {
                leftLabl.text = XYBString(@"str_frozen_capital", @"冻结本金");
                
                [leftLabl mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.contentView);
                }];
                
                if ([self.accountStatInfo.freezedAmt doubleValue] != 0) {
                    detailLabel.text = [[Utility replaceTheNumberForNSNumberFormatter:_accountStatInfo.freezedAmt] stringByAppendingString:@"元"];
                }

            }
        }
        break;
        case 2:
        {
            leftLabl.text = XYBString(@"str_collect_profit", @"待收收益");
            
            if ([self.accountStatInfo.expectedInteAmountTotal doubleValue] != 0) {
                detailLabel.text = [[Utility replaceTheNumberForNSNumberFormatter:_accountStatInfo.expectedInteAmountTotal] stringByAppendingString:@"元"];
            }

        }
            break;
        default:
            break;
    }
    
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NPInvestedListViewController * npinvestedList = [[NPInvestedListViewController alloc] init];
        [self.navigationController pushViewController:npinvestedList animated:YES];
    }

}

#pragma mark -- 点击事件

//返回
-(void)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//账户统计
-(void)clickRightBtn:(id)sender
{
    CGAccountStatisticsViewController * cgaccountStatistics = [[CGAccountStatisticsViewController alloc] init];
    cgaccountStatistics.accountDic = _accountStatInfo.toDictionary;
    [self.navigationController pushViewController:cgaccountStatistics animated:YES];
}


#pragma mark -- 数据处理


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
