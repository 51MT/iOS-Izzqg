//
//  ShakePrizeRecordViewController.m
//  Ixyb
//
//  Created by 董镇华 on 16/7/27.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "GETStatusViewController.h"
#import "MJRefresh.h"
#import "NoDataView.h"
#import "PosGetViewController.h"
#import "ShakeMPosRecordCell.h"
#import "ShakePrizeRecordCell.h"
#import "ShakePrizeRecordResponseModel.h"
#import "ShakePrizeRecordViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "XYTableView.h"

@interface ShakePrizeRecordViewController () <UITableViewDataSource, UITableViewDelegate> {
    NoDataView *noDataView;
}
@property (nonatomic, strong) NSMutableArray *dataSourse;
@property (nonatomic, strong) XYTableView *myTabelView;
@property (nonatomic, assign) int currentPage;

@end

@implementation ShakePrizeRecordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
}

/**
 *  数据源懒加载
 *
 */
- (NSMutableArray *)dataSourse {
    if (!_dataSourse) {
        _dataSourse = [[NSMutableArray alloc] init];
    }
    return _dataSourse;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self createNoDataView];
    [self createMyTableView];
    [self setupRefresh];
    [self setTheRequestWithShowLoading:YES];
}

- (void)setNav {

    self.navItem.title = XYBString(@"string_shake_win_record", @"中奖记录");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createNoDataView {
    noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    noDataView.titleLab.text = @"暂无记录";
    noDataView.hidden = NO;
    [self.view addSubview:noDataView];

    [self.view sendSubviewToBack:noDataView];

    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)createMyTableView {

    _currentPage = 0;
    _myTabelView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _myTabelView.backgroundColor = COLOR_COMMON_CLEAR;
    _myTabelView.dataSource = self;
    _myTabelView.delegate = self;
    _myTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTabelView];

    [_myTabelView registerClass:[ShakePrizeRecordCell class] forCellReuseIdentifier:@"cell1"];
    [_myTabelView registerClass:[ShakeMPosRecordCell class] forCellReuseIdentifier:@"cell2"];

    [_myTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourse.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell1 = [[UITableViewCell alloc] init];
    if (self.dataSourse.count > 0) {
        SingleRewardModel *model = self.dataSourse[indexPath.row];

        if ([model.prizeCode isEqualToString:@"REWARD"] || [model.prizeCode isEqualToString:@"SLEEPREWARD"] || [model.prizeCode isEqualToString:@"ZZY"] || [model.prizeCode isEqualToString:@"INCREASECARD"] || [model.prizeCode isEqualToString:@"SCORE"] || [model.prizeCode isEqualToString:@"INCREASECARD_POINT"]) {
            /**
             *  礼金 红包 积分 收益提升卡 加息券 周周盈出借机会的cell
             */
            ShakePrizeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model;

            if (indexPath.row == self.dataSourse.count - 1) {
                [XYCellLine initWithBottomLineAtSuperView:cell.contentView];
            }
            return cell;

        } else if ([model.prizeCode isEqualToString:@"MPOS"]) {
            /**
             *  MPOS机刷卡器的cell
             */
            ShakeMPosRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model;
            ShakeMPosRecordCell *circleCell = cell;
            cell.getBlock = ^(NSString *prizeLogId) {

                /**
                 进入确认领取页面
                 */
                PosGetViewController *posGetVc = [[PosGetViewController alloc] init];
                posGetVc.prizeLogId = prizeLogId;
                posGetVc.changeStatue = ^(NSInteger statue) {
                    model.state = statue;
                    circleCell.model = model;
                };
                [self.navigationController pushViewController:posGetVc animated:YES];
            };

            cell.statueBlock = ^(SingleRewardModel *model) {

                /**
                 进入领取状态页面
                 */
                GETStatusViewController *getStatueVC = [[GETStatusViewController alloc] init];
                getStatueVC.model = model;
                [self.navigationController pushViewController:getStatueVC animated:YES];

            };

            if (indexPath.row == self.dataSourse.count - 1) {
                [XYCellLine initWithBottomLineAtSuperView:cell.contentView];
            }
            return cell;
        }
    }
    return cell1;
}

#pragma mark - 设置刷新的方法
- (void)setupRefresh {
    _myTabelView.header = self.gifHeader3;
    _myTabelView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}
- (void)headerRereshing {

    _currentPage = 0;
    [_dataSourse removeAllObjects];
    [self setTheRequestWithShowLoading:NO];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [_myTabelView.header endRefreshing];
}

- (void)footerRereshing {

    [self setTheRequestWithShowLoading:NO];
    [_myTabelView.footer endRefreshing];
}

#pragma mark - 摇摇乐中奖记录Webservice

- (void)setTheRequestWithShowLoading:(BOOL)showLoading {
    if ([UserDefaultsUtil getUser].userId) {
        NSDictionary *contentDic = @{
            @"pageSize" : PageSize,
            @"page" : [NSNumber numberWithInt:_currentPage],
            @"userId" : [UserDefaultsUtil getUser].userId
        };
        if (showLoading == YES) {
            [self showDataLoading];
        }

        [self callShakePrizeRecordWebServiceWithParam:contentDic];
    }
}

- (void)callShakePrizeRecordWebServiceWithParam:(NSDictionary *)param {

    NSString *requestURL = [RequestURL getRequestURL:ShakePrideRecordRequestURL param:param];
    [WebService postRequest:requestURL param:param JSONModelClass:[ShakePrizeRecordResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [self hideLoading];
        ShakePrizeRecordResponseModel *model = responseObject;
        [self.dataSourse addObjectsFromArray:model.prizeInfos];
        [_myTabelView reloadData];

        if (self.dataSourse.count == 0) {
            noDataView.hidden = NO;
        } else {
            noDataView.hidden = YES;
            if (_currentPage * 20 > self.dataSourse.count) {

                _myTabelView.footer.hidden = YES;
                [_myTabelView.footer resetNoMoreData];
            } else {
                _myTabelView.footer.hidden = NO;
            }
        }

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {

            [self hideLoading];
            [self showDelayTip:errorMessage];
        }];
    _currentPage++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
