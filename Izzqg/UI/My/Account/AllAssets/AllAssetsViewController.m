//
//  AllAssetsViewController.m
//  Ixyb
//
//  Created by dengjian on 10/22/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "AllAssetsViewController.h"

#import "ColorUtil.h"
#import "HandleUserInfo.h"
#import "MJRefresh.h"
#import "User.h"
#import "Utility.h"
#import "XYCellLine.h"

#import "AccountResponseModel.h"
#import "AccountStatisticsViewController.h"
#import "AllAssetsTableViewCell.h"
#import "ChargeViewController.h"shareImage
#import "RoundCakesTableViewCell.h"
#import "TropismViewController.h"
#import "BbgInvestListViewController.h"
#import "DqbInvestListViewController.h"
#import "XtbInvestListViewController.h"
#import "UserDetailRealNamesViewController.h"
#import "WebService.h"

@interface AllAssetsViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation AllAssetsViewController

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
    self.navItem.title = XYBString(@"str_all_asert", @"总资产");
    self.view.backgroundColor = COLOR_BG;

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                             target:nil
                             action:nil];
    negativeSpacer.width = -12; //这个数值可以根据情况自由变化

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 80.0f, 40.0f);
    [button setTitle:XYBString(@"str_account_statistics", @"账户统计")
            forState:UIControlStateNormal];
    [button setTitleColor:COLOR_COMMON_GRAY forState:UIControlStateHighlighted];
    button.titleLabel.font = TEXT_FONT_14;
    [button addTarget:self
                  action:@selector(clickRightBtn:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
}

- (void)clickRightBtn:(id)sender {
    AccountStatisticsViewController *accountStatustics = [[AccountStatisticsViewController alloc] init];
    accountStatustics.accountInfoStatistics = self.accountInfo;
    accountStatustics.accountDic = self.accountDic;
    [self.navigationController pushViewController:accountStatustics animated:YES];
}

- (void)initTableView {
    self.tableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = COLOR_COMMON_CLEAR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[AllAssetsTableViewCell class] forCellReuseIdentifier:@"allAssetsTableViewCell"];
    [self.tableView registerClass:[RoundCakesTableViewCell class] forCellReuseIdentifier:@"roundCakesTableViewCell"];
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 24.f;
    } else if (section == 2 || section == 3) {
        return 10.f;
    }
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *tipSafeView = [[UIView alloc] init];
    tipSafeView.backgroundColor = COLOR_BG;
//    if (section == 3) {
//        UIView *tipView = [[UIView alloc] init];
//        [tipSafeView addSubview:tipView];
//        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(tipSafeView.mas_centerX);
//            make.centerY.equalTo(tipSafeView.mas_centerY);
//        }];
//
//        UIImage *img = [UIImage imageNamed:@"bsj_icon"];
//        UIImageView *insureImageView = [[UIImageView alloc] initWithImage:img];
//        [tipView addSubview:insureImageView];
//
//        [insureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.equalTo(@0);
//            make.size.mas_equalTo(img.size);
//            make.bottom.equalTo(tipView.mas_bottom);
//        }];
//
//        UILabel *tip2Label = [[UILabel alloc] init];
//        tip2Label.text = XYBString(@"str_financing_platformRiskProtectMoney", @"风险缓释金");
//        tip2Label.font = TEXT_FONT_12;
//        tip2Label.textColor = COLOR_AUXILIARY_GREY;
//        [tipView addSubview:tip2Label];
//
//        [tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(insureImageView.mas_centerY);
//            make.left.equalTo(insureImageView.mas_right).offset(6.0f);
//            make.right.equalTo(tipView.mas_right);
//        }];
//    }
    return tipSafeView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return ALL_ASERT_Round_DETAIL_TABLEVEIW_CELL_HEIGHT;
    } else {
        return ALL_ASERT_DETAIL_TABLEVEIW_CELL_HEIGHT;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    } else if (section == 2) {
        return 2;
    } else if (section == 3) {
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RoundCakesTableViewCell *roundCakesCell = [tableView dequeueReusableCellWithIdentifier:@"roundCakesTableViewCell"
                                                                                  forIndexPath:indexPath];
        if (roundCakesCell == nil) {
            roundCakesCell = [[RoundCakesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"roundCakesTableViewCell"];
        }
        double assertDoule = [self.accountInfo.bbgPrincipal doubleValue] + [self.accountInfo.dqbPrincipal doubleValue] + [self.accountInfo.xtbPrincipal doubleValue]  + [self.accountInfo.usableAmount doubleValue] + [self.accountInfo.freezedAmount doubleValue] + [self.accountInfo.totalInterest2callback doubleValue];
        if ([self.accountInfo.totalAmount intValue] != 0) {
            roundCakesCell.labAcountAllAssets.text = [Utility
                replaceTheNumberForNSNumberFormatter:
                    [NSString stringWithFormat:@"%.2f",
                                               assertDoule]];
        } else {
            roundCakesCell.labAcountAllAssets.text = XYBString(@"str_account_no_yuan", @"0.00");
        }
        if ([self.accountInfo.bbgPrincipal doubleValue] >0 ||  [self.accountInfo.dqbPrincipal doubleValue] >0  ||  [self.accountInfo.xtbPrincipal doubleValue] >0 ||  [self.accountInfo.usableAmount doubleValue] >0 ||  [self.accountInfo.freezedAmount doubleValue] >0 ||  [self.accountInfo.totalInterest2callback doubleValue] >0) {
            roundCakesCell.valueArray = [[NSMutableArray alloc] initWithObjects:
                                         [NSNumber numberWithDouble:[self.accountInfo.bbgPrincipal doubleValue]],
                                         [NSNumber numberWithDouble:[self.accountInfo.dqbPrincipal doubleValue]],
                                        [NSNumber numberWithDouble:[self.accountInfo.xtbPrincipal doubleValue]],
                                         [NSNumber numberWithDouble:[self.accountInfo.usableAmount doubleValue]],
                                         [NSNumber numberWithDouble:[self.accountInfo.freezedAmount doubleValue]],
                                         [NSNumber numberWithDouble:[self.accountInfo.totalInterest2callback doubleValue]], nil];
        }else
        {
            roundCakesCell.valueArray = [NSMutableArray arrayWithObjects:@"1", nil];
        }
     
        [XYCellLine initWithBottomLineAtSuperView:roundCakesCell.contentView];
        return roundCakesCell;
    } else {
        AllAssetsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allAssetsTableViewCell"
                                                                       forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[AllAssetsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"accountStatisticsCell"];
        }
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                [XYCellLine initWithTopLineAtSuperView:cell.contentView];
                cell.titleLabel.text = XYBString(@"str_bbg_asert", @"步步高资产");
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                [cell.btnleft setBackgroundImage:[ColorUtil imageWithColor:COLOR_STRONG_RED] forState:UIControlStateNormal];
                if ([self.accountInfo.bbgPrincipal doubleValue] != 0) {
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@元", [Utility
                                                                                     replaceTheNumberForNSNumberFormatter:
                                                                                         [NSString stringWithFormat:@"%.2f",
                                                                                                                    [self.accountInfo.bbgPrincipal doubleValue]]]];
                } else {
                    cell.contentLabel.text = XYBString(@"str_account_yuan", @"0.00元");
                }
            } else if (indexPath.row == 1) {
                cell.titleLabel.text = XYBString(@"str_dq_asert", @"定期宝资产");
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                [cell.btnleft setBackgroundImage:[ColorUtil imageWithColor:COLOR_MAIN] forState:UIControlStateNormal];
                if ([self.accountInfo.dqbPrincipal doubleValue] != 0) {
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@元", [Utility
                                                                                     replaceTheNumberForNSNumberFormatter:
                                                                                         [NSString stringWithFormat:@"%.2f",
                                                                                                                    [self.accountInfo.dqbPrincipal doubleValue]]]];
                } else {
                    cell.contentLabel.text = XYBString(@"str_account_yuan", @"0.00元");
                }
            } else if (indexPath.row == 2) {
                cell.titleLabel.text = XYBString(@"str_xtb_asert", @"信投宝资产");
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                [cell.btnleft setBackgroundImage:[ColorUtil imageWithColor:COLOR_XTB_BG] forState:UIControlStateNormal];
                if ([self.accountInfo.xtbPrincipal doubleValue] != 0) {
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@元", [Utility
                                                                                 replaceTheNumberForNSNumberFormatter:
                                                                                 [NSString stringWithFormat:@"%.2f",
                                                                                  [self.accountInfo.xtbPrincipal doubleValue]]]];
                } else {
                    cell.contentLabel.text = XYBString(@"str_account_yuan", @"0.00元");
                }
                cell.hasSplitLine = NO;
                [XYCellLine initWithBottomLineAtSuperView:cell.contentView];
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                [XYCellLine initWithTopLineAtSuperView:cell.contentView];
                cell.isStateArrow = NO;
                cell.titleLabel.text = XYBString(@"str_account_balance", @"可用余额");
                cell.btnleft.backgroundColor = COLOR_ORANGE;
                if ([self.accountInfo.usableAmount doubleValue] != 0) {
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.accountInfo.usableAmount doubleValue]]]];
                } else {
                    cell.contentLabel.text = XYBString(@"str_account_yuan", @"0.00元");
                }
            } else if (indexPath.row == 1) {
                cell.titleLabel.text = XYBString(@"str_frozen_capital", @"冻结本金");
                cell.isStateArrow = NO;
                if ([self.accountInfo.freezedAmount doubleValue] != 0) {
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.accountInfo.freezedAmount doubleValue]]]];
                } else {
                    cell.contentLabel.text = XYBString(@"str_account_yuan", @"0.00元");
                }
                cell.btnleft.backgroundColor = COLOR_STRONG_LIGHT_RED;
                cell.hasSplitLine = NO;
                [XYCellLine initWithBottomLineAtSuperView:cell.contentView];
            }
        } else if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                cell.titleLabel.text = XYBString(@"str_collect_profit", @"待收收益");
                cell.isStateArrow = NO;
                if ([self.accountInfo.totalInterest2callback doubleValue] != 0) {
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.accountInfo.totalInterest2callback doubleValue]]]];
                } else {
                    cell.contentLabel.text = XYBString(@"str_account_yuan", @"0.00元");
                }
                cell.btnleft.backgroundColor = COLOR_LIGHT_GREEN;
                cell.hasSplitLine = NO;
                [XYCellLine initWithTopLineAtSuperView:cell.contentView];
                [XYCellLine initWithBottomLineAtSuperView:cell.contentView];
            }
        }
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            BbgInvestListViewController *investedItems= [[BbgInvestListViewController alloc] init];
            [self.navigationController pushViewController:investedItems
                                                 animated:YES];
        } else if (indexPath.row == 1) {
            DqbInvestListViewController *investedItems= [[DqbInvestListViewController alloc] init];

            [self.navigationController pushViewController:investedItems
                                                 animated:YES];
        }else if (indexPath.row == 2) {
            XtbInvestListViewController *investedItems= [[XtbInvestListViewController alloc] init];
            [self.navigationController pushViewController:investedItems
                                                 animated:YES];
        }
    }
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
