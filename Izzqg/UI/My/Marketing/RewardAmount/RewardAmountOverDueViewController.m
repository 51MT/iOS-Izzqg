//
//  RewardAmountOverDueViewController.m
//  Ixyb
//
//  Created by wang on 15/8/8.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "RewardAmountOverDueViewController.h"

#import "Utility.h"

#import "MJExtension.h"
#import "MJRefresh.h"
#import "NoDataView.h"
#import "RewardAmountCell.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "XYTableView.h"

@interface RewardAmountOverDueViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *dataArray;
    NoDataView *noDataView;
    int currentPage;

    MBProgressHUD *hud;
}

@property (nonatomic, strong) XYTableView *mainTable;
@property (nonatomic, strong) UILabel *scoreLab;

@end

@implementation RewardAmountOverDueViewController

- (void)setNav {
    self.navItem.title = XYBString(@"string_overdue_gift_accounts", @"过期礼金");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = TEXT_FONT_14;
    [button setTitle:@"使用规则" forState:UIControlStateNormal];
    button.frame = CGRectMake(0.0f, 0.0f, 80.0f, 40.0f);
    [button addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
}

- (void)clickRightBtn:(id)sender {

    NSString *titleStr = XYBString(@"string_gift_userrole", @"礼金使用规则");
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_CashUseRules_URL withIsSign:NO];
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];

    dataArray = [[NSMutableArray alloc] init];

    [self creatTheNodataView];

    [self initTableView];

    [self setupRefresh];
    [self setTheRequest];
}

- (void)initTableView {
    self.mainTable = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.mainTable.backgroundColor = COLOR_BG;
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.showsHorizontalScrollIndicator = NO;
    self.mainTable.showsVerticalScrollIndicator = NO;
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainTable registerClass:[RewardAmountCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.mainTable];

    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 206)];

    headerView.backgroundColor = COLOR_COMMON_WHITE;
    self.mainTable.tableHeaderView = headerView;

    UIImageView *backImage = [[UIImageView alloc] init];
    backImage.backgroundColor = COLOR_LIGHT_GREY;
    backImage.layer.masksToBounds = YES;
    backImage.layer.cornerRadius = 65;

    [headerView addSubview:backImage];

    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.equalTo(@30);
        make.width.height.equalTo(@130);
    }];

    self.scoreLab = [[UILabel alloc] init];
    self.scoreLab.font = FONT_TEXT_LARGE_MORE;
    self.scoreLab.textAlignment = NSTextAlignmentCenter;
    self.scoreLab.textColor = COLOR_COMMON_WHITE;
    self.scoreLab.adjustsFontSizeToFitWidth = YES;
    self.scoreLab.text = @"0";
    [backImage addSubview:self.scoreLab];

    [self.scoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImage.mas_centerX);
        make.baseline.equalTo(backImage.mas_centerY);
        make.left.equalTo(backImage.mas_left).offset(2);
        make.right.equalTo(backImage.mas_right).offset(-2);
    }];

    UILabel *scoreTitleLab = [[UILabel alloc] init];
    scoreTitleLab.text = XYBString(@"string_overdue_gift", @"已过期礼金(元)");
    scoreTitleLab.font = TEXT_FONT_14;
    scoreTitleLab.textColor = COLOR_COMMON_WHITE;
    [backImage addSubview:scoreTitleLab];
    [scoreTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImage.mas_centerY).offset(10);
        make.centerX.equalTo(backImage.mas_centerX);
    }];

    //    UIView * splitPView = [[UIView alloc] init];
    //    splitPView.backgroundColor = COLOR_LINE ;
    //    [headerView addSubview:splitPView];
    //    [splitPView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(backImage.mas_centerX);
    //        make.width.equalTo(@(Line_Height));
    //        make.height.equalTo(@30);
    //        make.top.equalTo(backImage.mas_bottom).offset(20);
    //    }];
    //
    //    self.overdueLabel = [[UILabel alloc] init];
    //    self.overdueLabel.text = XYBString(@"string_gift_day",@"剩余30天过期");
    //    self.overdueLabel.font = [UIFont systemFontOfSize:15.0f] ;
    //    self.overdueLabel.textColor = COLOR_LIGHT_GREY;
    //    [headerView addSubview:self.overdueLabel];
    //    [self.overdueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(splitPView.mas_centerY);
    //        make.right.equalTo(splitPView.mas_left).offset(-10);
    //    }];
    //
    //    UIButton * overAwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    overAwardButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    //    [overAwardButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    //    overAwardButton.backgroundColor = COLOR_COMMON_CLEAR;
    //    [overAwardButton setTitle:XYBString(@"string_over_award",@"查看过期礼金") forState:UIControlStateNormal];
    //    [headerView addSubview:overAwardButton];
    //    [overAwardButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(splitPView.mas_centerY);
    //        make.left.equalTo(splitPView.mas_right).offset(10);
    //    }];

    UILabel *tip4Label = [[UILabel alloc] init];
    tip4Label.text = XYBString(@"string_details", @"明细");
    tip4Label.textAlignment = NSTextAlignmentCenter;
    tip4Label.textColor = COLOR_LIGHT_GREY;
    tip4Label.tag = 10001;
    tip4Label.backgroundColor = COLOR_COMMON_WHITE;
    tip4Label.font = [UIFont systemFontOfSize:14.0f];

    UIView *splitView = [[UIView alloc] init];
    splitView.backgroundColor = COLOR_LINE;
    [headerView addSubview:splitView];
    [headerView addSubview:tip4Label];

    [tip4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.bottom.equalTo(headerView.mas_bottom);
        make.width.equalTo(@46);
    }];

    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tip4Label.mas_centerY);
        make.height.equalTo(@(Line_Height));
        make.left.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
    }];
}

- (void)creatTheNodataView {

    noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    noDataView.hidden = YES;
    [self.view addSubview:noDataView];

    [self.view sendSubviewToBack:noDataView];

    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(@120);
    }];
}

- (void)setTheRequest {
    NSDictionary *contentDic = @{
        @"pageSize" : PageSize,
        @"page" : [NSNumber numberWithInt:currentPage],
        @"rewardState" : @1, //0: 未过期，1：已过期
        @"userId" : [UserDefaultsUtil getUser].userId
    };
    [self callRewardAccountWebService:contentDic];
}

#pragma mark-- tableView delegate method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Double_Cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    RewardAmountCell *cell = (RewardAmountCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[RewardAmountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (dataArray.count > 0) {
        cell.rewardAmountModel = dataArray[indexPath.row];
        cell.isOverDue = YES;
    }

    return cell;
}

#pragma mark - 设置刷新的方法
- (void)setupRefresh {
    _mainTable.header = self.gifHeader3;
    _mainTable.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}
- (void)headerRereshing {
    currentPage = 0;
    [dataArray removeAllObjects];
    [self setTheRequest];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [_mainTable.header endRefreshing];
}

- (void)footerRereshing {

    if (currentPage * 20 > dataArray.count) {

        [_mainTable.footer noticeNoMoreData];

    } else {

        [self setTheRequest];
        [_mainTable.footer endRefreshing];
    }
}

/****************************礼金账户接口**********************************/
- (void)callRewardAccountWebService:(NSDictionary *)dictionary {

    [self showDataLoading];
    NSString *urlPath = [RequestURL getRequestURL:UserAccountGetRewardAccountURL param:dictionary];
    [WebService postRequest:urlPath param:dictionary JSONModelClass:[RewardAmountModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            RewardAmountModel *reward = responseObject;
            if (reward.resultCode == 1) {

                NSString *totalStr = reward.rewardAccount.rewardAmount;
                if ([totalStr doubleValue] == 0) {
                    self.scoreLab.text = @"0.00";
                } else {
                    NSString *rewardAmountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [totalStr doubleValue]]];
                    self.scoreLab.text = rewardAmountStr;
                }

                NSArray *detailsArr = reward.accountActionList;
                [dataArray addObjectsFromArray:detailsArr];
                [_mainTable reloadData];

                if (dataArray.count == 0) {
                    UILabel * labelTip = (UILabel *)[self.view viewWithTag:10001];
                    labelTip.backgroundColor = COLOR_BG;
                    self.mainTable.tableHeaderView.backgroundColor = COLOR_BG;
                    noDataView.hidden = NO;
                    _mainTable.footer.hidden = YES;
                } else {
                    noDataView.hidden = YES;
                    if (currentPage * 20 > dataArray.count) {
                        _mainTable.footer.hidden = YES;
                        [_mainTable.footer noticeNoMoreData];
                    } else {
                        _mainTable.footer.hidden = NO;
                        [_mainTable.footer resetNoMoreData];
                    }
                }
            }
        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [_mainTable reloadData];
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }

    ];
    currentPage++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
