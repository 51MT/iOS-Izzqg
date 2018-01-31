//
//  BackPlanViewController.m
//  Ixyb
//
//  Created by wang on 15/7/1.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "BackPlanViewController.h"

#import "BackPlanCell.h"
#import "BackPlanModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MyAlertView.h"
#import "NoDataView.h"
#import "Utility.h"
#import "WebService.h"

@interface BackPlanViewController () <UITableViewDelegate, UITableViewDataSource> {
    NoDataView *noDataView;
    NSMutableArray *dataArray;
    int currentPage;
    MBProgressHUD *hud;
}
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSMutableArray *today_Time_Array;

@property (nonatomic, assign) BOOL s_isUpdate;

@end

@implementation BackPlanViewController

- (void)setNav {
    self.navItem.title = XYBString(@"str_back_money_plan", @"回款计划");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"question_mark"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"question_mark_ed"] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
    [button addTarget:self action:@selector(clickTheRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickTheRightBtn {

    NSString *massageStr = XYBString(@"str_description_back_plan", @"   期数是指购买的项目的期限。例如期数为1/3,表示所投标的期限是3个月，第一个月的回款期数则显示1/3");
    [MyAlertView showMessage:massageStr];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    self.s_isUpdate = NO;
    self.mainTable = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.mainTable.backgroundColor = COLOR_BG;
    [self.view addSubview:self.mainTable];
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom).offset(-1);
    }];
    [self setNav];

    dataArray = [[NSMutableArray alloc] init];
    self.dataDic = [[NSMutableDictionary alloc] init];
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 41)];
    headView.backgroundColor = COLOR_BG;
    self.mainTable.tableHeaderView = headView;

    UILabel *remaindTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindTitleLab.text = XYBString(@"str_planTips", @"具体回款时间以借款人回款或者赎回成功时间为准");
    remaindTitleLab.textColor = COLOR_AUXILIARY_GREY;
    remaindTitleLab.font = WEAK_TEXT_FONT_11;
    [headView addSubview:remaindTitleLab];
    [remaindTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headView);
    }];

    [_mainTable registerClass:[BackPlanCell class] forCellReuseIdentifier:@"cell"];
    [self creatTheNodataView];
    [self setupRefresh];
    [self setTheRequest];
}

- (void)creatTheNodataView {

    noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    noDataView.hidden = YES;
    [self.view addSubview:noDataView];

    [self.view sendSubviewToBack:noDataView];

    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)setTheRequest {
    NSDictionary *contentDic = @{ @"pageSize" : PageSize,
                                  @"page" : [NSNumber numberWithInt:currentPage],
                                  @"userId" : [UserDefaultsUtil getUser].userId
    };
    [self callCollectDetailsWebService:contentDic];
}

#pragma mark-- tableView delegate method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.today_Time_Array.count > 0) {
        return self.today_Time_Array.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.today_Time_Array.count <= 0) {
        return 1;
    } else {
        if (section < [self.today_Time_Array count]) {
            NSString *curtime = [self.today_Time_Array objectAtIndex:section];
            if (curtime) {
                NSArray *sectionArray = [self.dataDic objectForKey:curtime];
                if (sectionArray && [sectionArray isKindOfClass:[NSArray class]]) {

                    return [sectionArray count];
                }
            }
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Double_Cell_Height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.today_Time_Array.count <= 0) {
        return 0.f;
    } else {
        return 30.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewHeadDate = [[UIView alloc] init];
    viewHeadDate.backgroundColor = COLOR_BG;
    UILabel *HeadDateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    NSString *curtime = [self.today_Time_Array objectAtIndex:section];
    HeadDateLab.text = curtime;
    HeadDateLab.textColor = COLOR_AUXILIARY_GREY;
    HeadDateLab.font = TEXT_FONT_12;
    [viewHeadDate addSubview:HeadDateLab];
    [HeadDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewHeadDate.mas_centerY);
        make.left.equalTo(@12);
    }];
    [XYCellLine initWithTopLineAtSuperView:viewHeadDate];
    [XYCellLine initWithBottomLineAtSuperView:viewHeadDate];
    return viewHeadDate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BackPlanCell *cell = (BackPlanCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[BackPlanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *array = self.dataDic[self.today_Time_Array[indexPath.section]];
    NSArray *arr = [DetailsModel objectArrayWithKeyValuesArray:array];
    if (arr.count > 0) {
        cell.backPlanModel = [arr objectAtIndex:indexPath.row];
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

/****************************回款计划接口**********************************/
- (void)callCollectDetailsWebService:(NSDictionary *)dictionary {
    if (!self.today_Time_Array) {
        self.today_Time_Array = [[NSMutableArray alloc] init];
    }
    if (self.s_isUpdate == NO) {
        self.s_isUpdate = YES;
        [self showDataLoading];
    }
    //UserCollectDetailsURL
    NSString *urlPath = [RequestURL getRequestURL:UserCollectDetailsURL param:dictionary];

    [WebService postRequest:urlPath param:dictionary JSONModelClass:[BackPlanModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            BackPlanModel *backPlan = responseObject;
            NSDictionary *dic = backPlan.toDictionary;
            if (backPlan.resultCode == 1) {
                NSArray *detailsArr = [dic objectForKey:@"details"];

                if ([[dictionary objectForKey:@"page"] intValue] == 0) {
                    [self.dataDic removeAllObjects];
                }

                for (NSDictionary *dic in detailsArr) {
                    NSMutableString *dateStr = [NSMutableString stringWithString:[dic objectForKey:@"deadline"]];
                    NSArray *arrDate = [dateStr componentsSeparatedByString:@"-"];
                    NSString *dateStrData = [NSString stringWithFormat:@"%@年%@月", arrDate[0], arrDate[1]];
                    if (self.dataDic.count == 0) {
                        NSMutableArray *mutArr = [[NSMutableArray alloc] init];
                        [mutArr addObject:dic];
                        [self.dataDic setValue:mutArr forKey:dateStrData];
                    } else {
                        if ([[self.dataDic allKeys] containsObject:dateStrData]) {
                            [self.dataDic[dateStrData] addObject:dic];
                        } else {
                            NSMutableArray *mutArr3 = [[NSMutableArray alloc] init];
                            [mutArr3 addObject:dic];
                            [self.dataDic setValue:mutArr3 forKey:dateStrData];
                        }
                    }
                }
                [self.today_Time_Array removeAllObjects];
                [self.today_Time_Array addObjectsFromArray:[self.dataDic allKeys]];

                [self.today_Time_Array sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
                    if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {
                        return [obj1 compare:obj2];
                    }
                    return NSOrderedSame;
                }];
                
                NSArray *arr = detailsArr;
                [dataArray addObjectsFromArray:arr];
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
            [self hideLoading];
            [_mainTable reloadData];
            [self showPromptTip:errorMessage];
        }

    ];

    currentPage++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
