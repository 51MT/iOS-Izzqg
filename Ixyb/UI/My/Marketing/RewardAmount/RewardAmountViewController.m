//
//  RewardAmountViewController.m
//  Ixyb
//
//  Created by wang on 15/8/8.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "RewardAmountViewController.h"

#import "MJExtension.h"
#import "MJRefresh.h"
#import "NoDataView.h"
#import "RewardAmountCell.h"
#import "RewardAmountOverDueViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "XYTableView.h"

@interface RewardAmountViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *dataArray;
    NoDataView *noDataView;
    int currentPage;

    MBProgressHUD *hud;
}

@property (nonatomic, strong) XYTableView *mainTable;
@property (nonatomic, strong) UILabel *scoreLab;
@property (nonatomic, strong) UILabel *overdueLabel;

@end

@implementation RewardAmountViewController

- (void)setNav {
    self.view.backgroundColor = COLOR_BG;
    self.navigationItem.title = XYBString(@"str_my_gift_accounts", @"我的礼金");

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = TEXT_FONT_14;
    [button setTitle:XYBString(@"str_gift_userrole", @"使用规则") forState:UIControlStateNormal];
    button.frame = CGRectMake(0.0f, 0.0f, 80.0f, 40.0f);
    [button addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12; //这个数值可以根据情况自由变化
    self.navigationItem.rightBarButtonItems = @[ negativeSpacer, rightButtonItem ];
}

- (void)clickRightBtn:(id)sender {
    NSString *titleStr = XYBString(@"str_gift_userrole", @"礼金使用规则");
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
        make.edges.equalTo(self.view);
    }];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 246)];

    headerView.backgroundColor = COLOR_COMMON_WHITE;
    self.mainTable.tableHeaderView = headerView;

    UIImageView *backImage = [[UIImageView alloc] init];
    backImage.backgroundColor = COLOR_MAIN;
    backImage.layer.masksToBounds = YES;
    backImage.layer.cornerRadius = 65;

    [headerView addSubview:backImage];

    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.equalTo(@30);
        make.width.height.equalTo(@130);
    }];

    self.scoreLab = [[UILabel alloc] init];
    if (IS_IPHONE_5_OR_LESS) {
        self.scoreLab.font = TEXT_FONT_26;
    } else {
        self.scoreLab.font = FONT_TEXT_LARGE_MORE;
    }
    self.scoreLab.textAlignment = NSTextAlignmentCenter;
    self.scoreLab.textColor = COLOR_COMMON_WHITE;
    self.scoreLab.adjustsFontSizeToFitWidth = YES;
    self.scoreLab.text = @"0.00";
    [backImage addSubview:self.scoreLab];

    [self.scoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImage.mas_centerX);
        make.baseline.equalTo(backImage.mas_centerY);
        make.left.equalTo(backImage.mas_left).offset(2);
        make.right.equalTo(backImage.mas_right).offset(-2);
    }];

    UILabel *scoreTitleLab = [[UILabel alloc] init];
    scoreTitleLab.text = XYBString(@"str_gift", @"礼金(元)");
    scoreTitleLab.font = TEXT_FONT_14;
    scoreTitleLab.textColor = COLOR_COMMON_WHITE;
    [backImage addSubview:scoreTitleLab];
    [scoreTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImage.mas_centerY).offset(10);
        make.centerX.equalTo(backImage.mas_centerX);
    }];

    UIView *splitPView = [[UIView alloc] init];
    splitPView.backgroundColor = COLOR_LINE;
    [headerView addSubview:splitPView];
    [splitPView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImage.mas_centerX);
        make.width.equalTo(@(Line_Height));
        make.height.equalTo(@30);
        make.top.equalTo(backImage.mas_bottom).offset(20);
    }];

    self.overdueLabel = [[UILabel alloc] init];
    self.overdueLabel.text = XYBString(@"str_gift_day", @"剩余30天过期");
    self.overdueLabel.font = TEXT_FONT_14;
    self.overdueLabel.textColor = COLOR_MAIN_GREY;
    [headerView addSubview:self.overdueLabel];
    [self.overdueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(splitPView.mas_centerY);
        make.right.equalTo(splitPView.mas_left).offset(-10);
    }];

    XYButton *overAwardButton = [[XYButton alloc] initWithSubordinationButtonTitle:XYBString(@"str_over_award", @"查看过期礼金") isUserInteractionEnabled:YES];
    [overAwardButton addTarget:self action:@selector(clickOverAwardButton:) forControlEvents:UIControlEventTouchUpInside];
    overAwardButton.titleLabel.font = TEXT_FONT_14;
    [headerView addSubview:overAwardButton];
    [overAwardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(splitPView.mas_centerY);
        make.left.equalTo(splitPView.mas_right).offset(10);
    }];

    UILabel *tip4Label = [[UILabel alloc] init];
    tip4Label.text = XYBString(@"str_details", @"明细");
    tip4Label.textAlignment = NSTextAlignmentCenter;
    tip4Label.textColor = COLOR_LIGHT_GREY;
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

- (void)clickOverAwardButton:(id)sender {
    RewardAmountOverDueViewController *overDueVC = [[RewardAmountOverDueViewController alloc] init];
    [self.navigationController pushViewController:overDueVC animated:YES];
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


#pragma mark-- tableView delegate method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
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



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    RewardAmountCell *cell = (RewardAmountCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[RewardAmountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (dataArray.count > 0) {
        cell.rewardAmountModel = dataArray[indexPath.row];
        cell.isOverDue = NO;
    }

    return cell;
}


- (void)setTheRequest {
    NSDictionary *contentDic = @{
                                 @"pageSize" : PageSize,
                                 @"page" : [NSNumber numberWithInt:currentPage],
                                 @"rewardState" : @0, //0: 未过期，1：已过期
                                 @"userId" : [UserDefaultsUtil getUser].userId
                                 };
    [self callRewardAccountWebService:contentDic];
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
                NSString *str = [NSString stringWithFormat:XYBString(@"str_gift_lastday", @"剩%@天过期"), reward.rewardAccount.rewardRemainderDay];

                self.overdueLabel.text = str;

                NSArray *detailsArr = reward.accountActionList;
                [dataArray addObjectsFromArray:detailsArr];
                [_mainTable reloadData];
                if (dataArray.count == 0) {

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
