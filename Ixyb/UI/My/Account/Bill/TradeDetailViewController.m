//
//  TradeDetailViewController.m
//  Ixyb
//
//  Created by wangjianimac on 15/6/26.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "CashRecordTableViewCell.h"
#import "DropTableViewCell.h"
#import "ExchangeRecordTableViewCell.h"
#import "FreezeRecordTableViewCell.h"
#import "IncomeDetailTableViewCell.h"
#import "LuckdrawRecordTableViewCell.h"
#import "NoDataView.h"
#import "RechargeRecordTableViewCell.h"
#import "TradeDetailViewController.h"
#import "XYTableView.h"

#import "MJExtension.h"
#import "MJRefresh.h"
#import "Utility.h"

#import "DMExchangeRecord.h"
#import "DMFreezeRecord.h"
#import "DMLuckdrawRecord.h"
#import "WebService.h"

#import <objc/runtime.h>

@interface TradeDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, CashRecordTableViewCellDelegate>

@property (nonatomic, strong) XYTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger pageIndex;


@property (nonatomic, strong) UITableView *dropTableView;
@property (nonatomic, strong) NSMutableArray *dropDataArray;
@property (nonatomic, assign) NSInteger selectedDropIndex; // 项目类型, 0:收支明细，1:充值记录，2:提现记录 3:冻结记录 4:中奖记录 5:兑换记录
@property (nonatomic, strong) UIView *dropView;

@property (nonatomic, strong) NoDataView *noDataView;
@property (nonatomic, strong) UIButton *navTitleButton;
@property (nonatomic, strong) UIImageView *navTitleImg;
@property (nonatomic, strong) UIButton *upButton;

@end

@implementation TradeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];

    [self updateData];
}

- (void)initData {
    self.dataArray = [NSMutableArray arrayWithCapacity:5];
    //    [@{ @"title" : XYBString(@"string_jackpot_record", @"中奖记录"),
    //        @"selected" : @NO } mutableCopy],
    //    [@{ @"title" : XYBString(@"string_exchange_record", @"兑换记录"),
    //        @"selected" : @NO } mutableCopy]
    NSArray *array = @[ [@{ @"title" : XYBString(@"str_income_details", @"收支明细"),
                            @"selected" : @YES } mutableCopy],
                        [@{ @"title" : XYBString(@"str_charge_record", @"充值记录"),
                            @"selected" : @NO } mutableCopy],
                        [@{ @"title" : XYBString(@"str_tropism_record", @"提现记录"),
                            @"selected" : @NO } mutableCopy],
                        [@{ @"title" : XYBString(@"str_freeze_record", @"冻结记录"),
                            @"selected" : @NO } mutableCopy] ];

    self.dropDataArray = [array mutableCopy];
    self.pageIndex = 0;
    self.selectedDropIndex = 0;
}

- (void)initUI {

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    self.navTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navTitleButton setTitle:XYBString(@"str_income_details", @"收支明细") forState:UIControlStateNormal];
    self.navTitleButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [self.navTitleButton sizeToFit];
    [self.navTitleButton addTarget:self action:@selector(clickNavHeadBtn:) forControlEvents:UIControlEventTouchUpInside];

    UIView *navTitleView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 140.0f, 40.0f)];
    self.navTitleImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arrow"]];
    [navTitleView addSubview:self.navTitleButton];
    [navTitleView addSubview:self.navTitleImg];
    [navTitleView sizeToFit];
    self.navItem.titleView = navTitleView;

    [self.navTitleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navTitleButton.mas_right).offset(5);
        make.centerY.equalTo(self.navTitleButton.mas_centerY);
    }];

    [self.navTitleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navTitleView.mas_centerX);
        make.centerY.equalTo(navTitleView.mas_centerY);
    }];

    [self initTableView];
    [self initNodataView];
    [self initDropTableView];
}

- (void)initNodataView {
    self.noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    self.noDataView.hidden = YES;
    [self.view addSubview:self.noDataView];

    [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)clickNavHeadBtn:(id)sender {
    if (self.dropView.hidden == YES) {
        self.navTitleImg.transform = CGAffineTransformRotate(self.navTitleImg.transform, M_PI);
        self.dropView.hidden = NO;
        [self.dropTableView reloadData];
    } else {
        self.navTitleImg.transform = CGAffineTransformIdentity;
        self.dropView.hidden = YES;
    }
}

- (void)initTableView {
    self.tableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = COLOR_BG;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[IncomeDetailTableViewCell class] forCellReuseIdentifier:@"incomeDetailTableViewCell"];
    [self.tableView registerClass:[CashRecordTableViewCell class] forCellReuseIdentifier:@"cashRecordTableViewCell"];
    [self.tableView registerClass:[RechargeRecordTableViewCell class] forCellReuseIdentifier:@"rechargeRecordTableViewCell"];
    [self.tableView registerClass:[FreezeRecordTableViewCell class] forCellReuseIdentifier:@"freezeRecordTableViewCell"];
    [self.tableView registerClass:[LuckdrawRecordTableViewCell class] forCellReuseIdentifier:@"luckdrawRecordTableViewCell"];
    [self.tableView registerClass:[ExchangeRecordTableViewCell class] forCellReuseIdentifier:@"exchangeRecordTableViewCell"];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    UIImage *btnImage = [UIImage imageNamed:@"up_arrow"];
    self.upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.upButton setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.upButton addTarget:self action:@selector(clickUpButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.upButton];
    self.upButton.hidden = YES;
    [self.upButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.width.mas_equalTo(btnImage.size.width);
        make.height.mas_equalTo(btnImage.size.height);

    }];

    self.tableView.header = self.gifHeader3;
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
}

- (void)clickUpButton:(id)sender {
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.contentOffset.y > ((MainScreenHeight + 100) / 2)) {
        self.upButton.hidden = NO;
    } else {
        self.upButton.hidden = YES;
    }
}

- (void)initDropTableView {
    self.dropView = [[UIView alloc] init];
    self.dropView.backgroundColor = COLOR_COMMON_BLACK_TRANS;
    self.dropView.hidden = YES;
    [self.view addSubview:self.dropView];
    [self.dropView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom);
    }];

    UIControl *bgControl = [[UIControl alloc] init];
    bgControl.backgroundColor = COLOR_COMMON_CLEAR;
    [bgControl addTarget:self action:@selector(clickDropTableBg:) forControlEvents:UIControlEventTouchUpInside];
    [self.dropView addSubview:bgControl];

    [bgControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenHeight));
    }];

    self.dropTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.dropView addSubview:self.dropTableView];
    self.dropTableView.delegate = self;
    self.dropTableView.dataSource = self;
    self.dropTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dropTableView.scrollEnabled = NO;
    self.dropTableView.backgroundColor = COLOR_COMMON_CLEAR;
    [self.dropTableView registerClass:[DropTableViewCell class] forCellReuseIdentifier:@"dropTableViewCell"];

    [self.dropTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@((Cell_Height) *6));
    }];
}

- (void)clickDropTableBg:(id)sender {
    self.dropView.hidden = YES;
}

- (void)cashRecordTableViewCell:(CashRecordTableViewCell *)cell didClickCancelButtonOfId:(NSInteger)cashId {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:XYBString(@"str_cancel_apply", @"请确认撤销提现申请")
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:XYBString(@"str_cancel", @"取消")
                                              otherButtonTitles:XYBString(@"str_ok", @"确定"), nil];
    objc_setAssociatedObject(alertView, "cashId", @(cashId), OBJC_ASSOCIATION_RETAIN);
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSNumber *cashId = objc_getAssociatedObject(alertView, "cashId");
        [self cancelCashRecord:[cashId integerValue]];
    }
}

/**
 *  充值记录 下拉
 */
- (void)updateRechargeRecord {

    self.pageIndex = 0;
    NSDictionary *param = @{
        @"page" : [NSNumber numberWithInteger:self.pageIndex],
        @"pageSize" : PageSize,
        @"userId" : [UserDefaultsUtil getUser].userId,
    };
    [self.tableView.footer resetNoMoreData];
    self.tableView.footer.hidden = NO;
    [self showDataLoading];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:param];
    NSString *urlPath = [RequestURL getRequestURL:RechargeListURL param:params];
    [WebService postRequest:urlPath param:params JSONModelClass:[RechargeRecord class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        RechargeRecord *income = responseObject;
        if (income.resultCode == 1) {
            NSArray *detailsArr = income.rechargeList;
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:detailsArr];
            if (self.dataArray.count == 0) {
                self.noDataView.hidden = NO;
            } else {
                self.noDataView.hidden = YES;
            }

            [self.tableView reloadData];

            if ([detailsArr count] < [PageSize integerValue]) {
                self.tableView.footer.hidden = YES;
                [self.tableView.footer noticeNoMoreData];
            }
        }
    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

/**
 *  充值记录 上拉
 */
- (void)moreRechargeRecord {
    self.pageIndex = self.pageIndex + 1;
    NSDictionary *param = @{
        @"page" : [NSNumber numberWithInteger:self.pageIndex],
        @"pageSize" : PageSize,
        @"userId" : [UserDefaultsUtil getUser].userId,
    };

    [self showDataLoading];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:param];
    NSString *urlPath = [RequestURL getRequestURL:RechargeListURL param:params];
    [WebService postRequest:urlPath param:params JSONModelClass:[RechargeRecord class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        RechargeRecord *income = responseObject;
        if (income.resultCode == 1) {
            NSArray *detailsArr = income.rechargeList;
            [self.dataArray addObjectsFromArray:detailsArr];
            if (self.dataArray.count == 0) {
                self.noDataView.hidden = NO;
            } else {
                self.noDataView.hidden = YES;
            }

            [self.tableView reloadData];

            if ([detailsArr count] < [PageSize integerValue]) {
                self.tableView.footer.hidden = YES;
                [self.tableView.footer noticeNoMoreData];
            }
        }
    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

/**
 *  提现记录
 */
- (void)updateCashRecord {

    self.pageIndex = 0;
    NSDictionary *param = @{
        @"page" : [NSNumber numberWithInteger:self.pageIndex],
        @"pageSize" : PageSize,
        @"userId" : [UserDefaultsUtil getUser].userId,
    };
    [self.tableView.footer resetNoMoreData];
    self.tableView.footer.hidden = NO;
    [self showDataLoading];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:param];
    NSString *urlPath = [RequestURL getRequestURL:AccountWithdrawalsURL param:params];
    [WebService postRequest:urlPath param:params JSONModelClass:[CashRecord class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        CashRecord *income = responseObject;
        if (income.resultCode == 1) {
            NSArray *detailsArr = income.withdrawals;
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:detailsArr];
            if (self.dataArray.count == 0) {
                self.noDataView.hidden = NO;
            } else {
                self.noDataView.hidden = YES;
            }

            [self.tableView reloadData];

            if ([detailsArr count] < [PageSize integerValue]) {
                self.tableView.footer.hidden = YES;
                [self.tableView.footer noticeNoMoreData];
            }
        }
    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

- (void)moreCashRecord {
    self.pageIndex = self.pageIndex + 1;
    NSDictionary *param = @{
        @"page" : [NSNumber numberWithInteger:self.pageIndex],
        @"pageSize" : PageSize,
        @"userId" : [UserDefaultsUtil getUser].userId,
    };
    [self showDataLoading];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:param];
    NSString *urlPath = [RequestURL getRequestURL:AccountWithdrawalsURL param:params];
    [WebService postRequest:urlPath param:params JSONModelClass:[CashRecord class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        CashRecord *income = responseObject;
        if (income.resultCode == 1) {
            NSArray *detailsArr = income.withdrawals;
            [self.dataArray addObjectsFromArray:detailsArr];
            if (self.dataArray.count == 0) {
                self.noDataView.hidden = NO;
            } else {
                self.noDataView.hidden = YES;
            }

            [self.tableView reloadData];

            if ([detailsArr count] < [PageSize integerValue]) {
                self.tableView.footer.hidden = YES;
                [self.tableView.footer noticeNoMoreData];
            }
        }
    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

/**
 *  冻结记录 下拉
 */
- (void)updateFreezeRecord {

    self.pageIndex = 0;
    NSDictionary *param = @{
        @"userId" : [UserDefaultsUtil getUser].userId
    };
    self.tableView.footer.hidden = YES;
    [self.tableView.footer noticeNoMoreData]; // 没有分页,就没有更多,因为复用,暂时没有去掉UI层.

    [self showDataLoading];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:param];
    NSString *urlPath = [RequestURL getRequestURL:AccountFreezeDetailURL param:params];
    [WebService postRequest:urlPath param:params JSONModelClass:[DMFreezeRecord class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        DMFreezeRecord *income = responseObject;
        if (income.resultCode == 1) {
            NSArray *detailsArr = income.freezeList;
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:detailsArr];
            if (self.dataArray.count == 0) {
                self.noDataView.hidden = NO;
            } else {
                self.noDataView.hidden = YES;
            }

            [self.tableView reloadData];

            self.tableView.footer.hidden = YES;
            [self.tableView.footer noticeNoMoreData]; // 没有分页,就没有更多,因为复用,暂时没有去掉UI层.
        }
    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

/**
 *  冻结记录 上拉
 */
- (void)moreFreezeRecord {
    self.pageIndex = self.pageIndex + 1;
    NSDictionary *param = @{
        @"userId" : [UserDefaultsUtil getUser].userId,
    };

    [self showDataLoading];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:param];
    NSString *urlPath = [RequestURL getRequestURL:AccountFreezeDetailURL param:params];
    [WebService postRequest:urlPath param:params JSONModelClass:[DMFreezeRecord class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];;
        DMFreezeRecord *dmFreeze = responseObject;
        if (dmFreeze.resultCode == 1) {
            NSArray *detailsArr = dmFreeze.freezeList;
            //            NSArray *objArray = [DMFreezeRecord objectArrayWithKeyValuesArray:detailsArr];
            [self.dataArray addObjectsFromArray:detailsArr];
            if (self.dataArray.count == 0) {
                self.noDataView.hidden = NO;
            } else {
                self.noDataView.hidden = YES;
            }

            [self.tableView reloadData];

            if ([detailsArr count] < [PageSize integerValue]) {
                self.tableView.footer.hidden = YES;
                [self.tableView.footer noticeNoMoreData];
            }
        }
    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

//- (void)updateLuckdrawRecord {
//    self.pageIndex = 0;
//    NSDictionary *param = @{
//        @"page" : [NSNumber numberWithInteger:self.pageIndex],
//        @"pageSize" : PageSize,
//        @"userId" : [UserDefaultsUtil getUser].userId,
//    };
//    [self.tableView.footer resetNoMoreData];
//    self.tableView.footer.hidden = NO;
//    [self showLoading];
//    [OtherHttpService requestLuckdrawRecord:param Success:^(AFHTTPRequestOperation *operation, NSDictionary *resultDic) {
//        [self hideLoading];
//        [self.tableView.header endRefreshing];
//        int resultCode = [[resultDic objectForKey:@"resultCode"] intValue];
//        if (resultCode == 1) {
//            NSArray *detailsArr = [resultDic objectForKey:@"luckdrawList"];
//            NSArray *arr = [DMLuckdrawRecord objectArrayWithKeyValuesArray:detailsArr];
//            [self.dataArray removeAllObjects];
//            [self.dataArray addObjectsFromArray:arr];
//            if (self.dataArray.count == 0) {
//                self.noDataView.hidden = NO;
//            } else {
//                self.noDataView.hidden = YES;
//            }
//
//            [self.tableView reloadData];
//
//            if ([arr count] < [PageSize integerValue]) {
//                self.tableView.footer.hidden = YES;
//                [self.tableView.footer noticeNoMoreData];
//            }
//        }
//
//    }
//        fail:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [self hideLoading];
//            [self.tableView.header endRefreshing];
//            if (operation.response.statusCode == 400 || operation.response.statusCode == 500) {
//                NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
//                NSDictionary *errorDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//                [self showPromptTip:[errorDic objectForKey:@"message"]];
//            } else {
//                if (operation.response) {
//                    [self showDelayTip:XYBString(@"string_connect_time_out", @"服务器连接超时，请重试")];
//                } else {
//                    [self showDelayTip:XYBString(@"string_network_error", @"网络连接不可用，请检查")];
//                }
//            }
//
//        }];
//}

//- (void)moreLuckdrawRecord {
//    self.pageIndex = self.pageIndex + 1;
//    NSDictionary *param = @{
//        @"page" : [NSNumber numberWithInteger:self.pageIndex],
//        @"pageSize" : PageSize,
//        @"userId" : [UserDefaultsUtil getUser].userId,
//    };
//    [self showLoading];
//    [OtherHttpService requestWithdrawals:param Success:^(AFHTTPRequestOperation *operation, NSDictionary *resultDic) {
//        [self hideLoading];
//        //        [self.tableView.footer endRefreshing];
//        int resultCode = [[resultDic objectForKey:@"resultCode"] intValue];
//        if (resultCode == 1) {
//            NSArray *detailsArr = [resultDic objectForKey:@"luckdrawList"];
//            NSArray *objArray = [DMLuckdrawRecord objectArrayWithKeyValuesArray:detailsArr];
//            [self.dataArray addObjectsFromArray:objArray];
//
//            if (self.dataArray.count == 0) {
//                self.noDataView.hidden = NO;
//            } else {
//                self.noDataView.hidden = YES;
//            }
//
//            [self.tableView reloadData];
//
//            if ([objArray count] < [PageSize integerValue]) {
//                self.tableView.footer.hidden = YES;
//                [self.tableView.footer noticeNoMoreData];
//            }
//        }
//    }
//        fail:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [self hideLoading];
//            //        [self.tableView.footer endRefreshing];
//            if (operation.response.statusCode == 400 || operation.response.statusCode == 500) {
//                NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
//                NSDictionary *errorDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//                [self showPromptTip:[errorDic objectForKey:@"message"]];
//            } else {
//                if (operation.response) {
//                    [self showDelayTip:XYBString(@"string_connect_time_out", @"服务器连接超时，请重试")];
//                } else {
//                    [self showDelayTip:XYBString(@"string_network_error", @"网络连接不可用，请检查")];
//                }
//            }
//
//        }];
//
//    [self.tableView.footer endRefreshing];
//}

//- (void)updateExchangeRecord {
//
//    self.pageIndex = 0;
//    NSDictionary *param = @{
//        @"page" : [NSNumber numberWithInteger:self.pageIndex],
//        @"pageSize" : PageSize,
//        @"userId" : [UserDefaultsUtil getUser].userId
//    };
//
//    [self.tableView.footer resetNoMoreData];
//    self.tableView.footer.hidden = NO;
//    [self showLoading];
//    [OtherHttpService requestExchangeRecord:param Success:^(AFHTTPRequestOperation *operation, NSDictionary *resultDic) {
//        [self hideLoading];
//        [self.tableView.header endRefreshing];
//        int resultCode = [[resultDic objectForKey:@"resultCode"] intValue];
//        if (resultCode == 1) {
//            NSArray *detailsArr = [resultDic objectForKey:@"exchangeList"];
//            NSArray *arr = [DMExchangeRecord objectArrayWithKeyValuesArray:detailsArr];
//            [self.dataArray removeAllObjects];
//            [self.dataArray addObjectsFromArray:arr];
//            if (self.dataArray.count == 0) {
//                self.noDataView.hidden = NO;
//            } else {
//                self.noDataView.hidden = YES;
//            }
//
//            [self.tableView reloadData];
//
//            if ([arr count] < [PageSize integerValue]) {
//                self.tableView.footer.hidden = YES;
//                [self.tableView.footer noticeNoMoreData];
//            }
//        }
//
//    }
//        fail:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [self hideLoading];
//            [self.tableView.header endRefreshing];
//            if (operation.response.statusCode == 400 || operation.response.statusCode == 500) {
//                NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
//                NSDictionary *errorDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//                [self showPromptTip:[errorDic objectForKey:@"message"]];
//            } else {
//                if (operation.response) {
//                    [self showDelayTip:XYBString(@"string_connect_time_out", @"服务器连接超时，请重试")];
//                } else {
//                    [self showDelayTip:XYBString(@"string_network_error", @"网络连接不可用，请检查")];
//                }
//            }
//
//        }];
//}

//- (void)moreExchangeRecord {
//    self.pageIndex = self.pageIndex + 1;
//    NSDictionary *param = @{
//        @"page" : [NSNumber numberWithInteger:self.pageIndex],
//        @"pageSize" : PageSize,
//        @"userId" : [UserDefaultsUtil getUser].userId,
//    };
//    [self showLoading];
//    [OtherHttpService requestExchangeRecord:param Success:^(AFHTTPRequestOperation *operation, NSDictionary *resultDic) {
//        [self hideLoading];
//        [self.tableView.footer endRefreshing];
//        int resultCode = [[resultDic objectForKey:@"resultCode"] intValue];
//        if (resultCode == 1) {
//            NSArray *detailsArr = [resultDic objectForKey:@"exchangeList"];
//            NSArray *objArray = [DMExchangeRecord objectArrayWithKeyValuesArray:detailsArr];
//            [self.dataArray addObjectsFromArray:objArray];
//            if (self.dataArray.count == 0) {
//                self.noDataView.hidden = NO;
//            } else {
//                self.noDataView.hidden = YES;
//            }
//
//            [self.tableView reloadData];
//
//            if ([objArray count] < [PageSize integerValue]) {
//                self.tableView.footer.hidden = YES;
//                [self.tableView.footer noticeNoMoreData];
//            }
//        }
//
//    }
//        fail:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [self hideLoading];
//            [self.tableView.footer endRefreshing];
//            if (operation.response.statusCode == 400 || operation.response.statusCode == 500) {
//                NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
//                NSDictionary *errorDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//                [self showPromptTip:[errorDic objectForKey:@"message"]];
//            } else {
//                if (operation.response) {
//                    [self showDelayTip:XYBString(@"string_connect_time_out", @"服务器连接超时，请重试")];
//                } else {
//                    [self showDelayTip:XYBString(@"string_network_error", @"网络连接不可用，请检查")];
//                }
//            }
//
//        }];
//}

-(void)headerRereshing {
    [self updateData];
}

- (void)updateData {
    self.pageIndex = 0;
    if (self.selectedDropIndex == 0) {
        [self updateIncomeDetail];
    } else if (self.selectedDropIndex == 1) {
        [self updateRechargeRecord];
    } else if (self.selectedDropIndex == 2) {
        [self updateCashRecord];
    } else if (self.selectedDropIndex == 3) {
        [self updateFreezeRecord];
    }
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
    //    else if (self.selectedDropIndex == 4) {
    //        [self updateLuckdrawRecord];
    //    } else if (self.selectedDropIndex == 5) {
    //        [self updateExchangeRecord];
    //    }
}

- (void)moreData {
    if (self.selectedDropIndex == 0) {
        [self moreIncomeDetail];
    } else if (self.selectedDropIndex == 1) {
        [self moreRechargeRecord];
    } else if (self.selectedDropIndex == 2) {
        [self moreCashRecord];
    } else if (self.selectedDropIndex == 2) {
        [self moreCashRecord];
    } else if (self.selectedDropIndex == 3) {
        [self moreFreezeRecord];
    }
    
    [self.tableView.footer endRefreshing];
    //    else if (self.selectedDropIndex == 4) {
    //        [self moreLuckdrawRecord];
    //    } else if (self.selectedDropIndex == 5) {
    //        [self moreExchangeRecord];
    //    }
}

- (void)endRefresh {
    
    [self.tableView.header endRefreshing];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return [self.dataArray count];
    } else if (tableView == self.dropTableView) {
        return [self.dropDataArray count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return 1;
    } else if (tableView == self.dropTableView) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.tableView) {
        if (self.selectedDropIndex == 0) {
            return Double_Cell_Height;
        } else if (self.selectedDropIndex == 1) {
            return Double_Cell_Height;
        } else if (self.selectedDropIndex == 2) {
            return Double_Cell_Height;
        } else if (self.selectedDropIndex == 3) {
            return Double_Cell_Height;
        }
        //        else if (self.selectedDropIndex == 4) {
        //            return Double_Cell_Height;
        //        } else if (self.selectedDropIndex == 5) {
        //            return 144;
        //        }
    } else if (tableView == self.dropTableView) {
        return Cell_Height;
    }
    return 0;
}

/**
 *  撤销提现
 *
 *  @param cashId
 */
- (void)cancelCashRecord:(NSInteger)cashId {
    NSDictionary *param = @{
        @"id" : [NSNumber numberWithInteger:cashId],
        @"userId" : [UserDefaultsUtil getUser].userId,
    };

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:param];
    NSString *urlPath = [RequestURL getRequestURL:AccountDrawMoneyCancelURL param:params];
    [WebService postRequest:urlPath param:params JSONModelClass:[ResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ResponseModel *Response = responseObject;
        if (Response.resultCode == 1) {
            [self updateCashRecord];
            [self showPromptTip:XYBString(@"str_canceled", @"已撤销")];
        }

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self showPromptTip:errorMessage];
        }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // 项目类型, 0:收支明细，1:充值记录，2:提现记录 3:冻结记录 4:中奖记录 5:兑换记录
    if (tableView == self.tableView) {
        if (self.selectedDropIndex == 0) {
            IncomeDetailTableViewCell *cell = (IncomeDetailTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"incomeDetailTableViewCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[IncomeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"incomeDetailTableViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell.incomeDetail = self.dataArray[indexPath.row];
            return cell;
        } else if (self.selectedDropIndex == 1) {
            RechargeRecordTableViewCell *cell = (RechargeRecordTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"rechargeRecordTableViewCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[RechargeRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rechargeRecordTableViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.rechargeRecord = self.dataArray[indexPath.row];
            return cell;

        } else if (self.selectedDropIndex == 2) {
            CashRecordTableViewCell *cell = (CashRecordTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cashRecordTableViewCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[CashRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cashRecordTableViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.cellDelegate = self;
            cell.cashRecord = self.dataArray[indexPath.row];
            return cell;

        } else if (self.selectedDropIndex == 3) {
            FreezeRecordTableViewCell *cell = (FreezeRecordTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"freezeRecordTableViewCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[FreezeRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"freezeRecordTableViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.record = self.dataArray[indexPath.row];
            return cell;

        } else if (self.selectedDropIndex == 4) {
            LuckdrawRecordTableViewCell *cell = (LuckdrawRecordTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"luckdrawRecordTableViewCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[LuckdrawRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"luckdrawRecordTableViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.record = self.dataArray[indexPath.row];
            return cell;

        } else if (self.selectedDropIndex == 5) {
            ExchangeRecordTableViewCell *cell = (ExchangeRecordTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"exchangeRecordTableViewCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[ExchangeRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"exchangeRecordTableViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.record = self.dataArray[indexPath.row];
            return cell;
        }
        return [[UITableViewCell alloc] init];
    } else if (tableView == self.dropTableView) {
        DropTableViewCell *cell = (DropTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"dropTableViewCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[DropTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dropTableViewCell"];
        }
        cell.title = self.dropDataArray[indexPath.row][@"title"];
        cell.isSelectedState = [self.dropDataArray[indexPath.row][@"selected"] boolValue];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {

    } else if (tableView == self.dropTableView) {
        NSInteger oldSelectedDropIndex = self.selectedDropIndex;
        if (oldSelectedDropIndex != indexPath.row) {
            self.selectedDropIndex = indexPath.row;
            for (int i = 0; i < self.dropDataArray.count; i++) {
                self.dropDataArray[i][@"selected"] = @NO;
            }
            self.dropDataArray[indexPath.row][@"selected"] = @YES;
            [self.dropTableView reloadData];
            [self.navTitleButton setTitle:self.dropDataArray[indexPath.row][@"title"] forState:UIControlStateNormal];
            [self.navTitleButton sizeToFit];
            self.dropView.hidden = YES;
            self.navTitleImg.transform = CGAffineTransformIdentity;

            [self updateData];
        }
    }
}

/**
 *  收支明细
 */
- (void)updateIncomeDetail {
    self.pageIndex = 0;
    NSDictionary *param = @{
        @"page" : [NSNumber numberWithInteger:self.pageIndex],
        @"pageSize" : PageSize,
        @"userId" : [UserDefaultsUtil getUser].userId,
    };
    [self.tableView.footer resetNoMoreData];
    self.tableView.footer.hidden = NO;
    [self showDataLoading];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:param];
    NSString *urlPath = [RequestURL getRequestURL:UserTransDetailsURL param:params];
    [WebService postRequest:urlPath param:params JSONModelClass:[IncomeDetail class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        IncomeDetail *income = responseObject;
        if (income.resultCode == 1) {
            NSArray *detailsArr = income.transDetails;
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:detailsArr];
            if (self.dataArray.count == 0) {
                self.noDataView.hidden = NO;
            } else {
                self.noDataView.hidden = YES;
            }

            [self.tableView reloadData];

            if ([detailsArr count] < [PageSize integerValue]) {
                self.tableView.footer.hidden = YES;
                [self.tableView.footer noticeNoMoreData];
            }
        }
    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

- (void)moreIncomeDetail {
    self.pageIndex = self.pageIndex + 1;
    NSDictionary *param = @{
        @"page" : [NSNumber numberWithInteger:self.pageIndex],
        @"pageSize" : PageSize,
        @"userId" : [UserDefaultsUtil getUser].userId,
    };
    [self showDataLoading];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:param];
    NSString *urlPath = [RequestURL getRequestURL:UserTransDetailsURL param:params];
    [WebService postRequest:urlPath param:params JSONModelClass:[IncomeDetail class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        IncomeDetail *income = responseObject;
        if (income.resultCode == 1) {
            NSArray *detailsArr = income.transDetails;
            [self.dataArray addObjectsFromArray:detailsArr];
            if (self.dataArray.count == 0) {
                self.noDataView.hidden = NO;
            } else {
                self.noDataView.hidden = YES;
            }

            [self.tableView reloadData];
            if ([detailsArr count] < [PageSize integerValue]) {

                [self.tableView.footer noticeNoMoreData];
                self.tableView.footer.hidden = YES;
            }
        }

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

@end
