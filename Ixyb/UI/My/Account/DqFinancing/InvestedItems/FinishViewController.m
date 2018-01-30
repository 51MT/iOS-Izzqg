//
//  FinishViewController.m
//  Ixyb
//
//  Created by wangjianimac on 16/7/7.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "FinishViewController.h"
#import "XYTableView.h"
#import "DMInvestedProject.h"
#import "FinishTableViewCell.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "MoreProductViewController.h"
#import "NoDataTableViewCell.h"
#import "Utility.h"
#import "WebService.h"

@interface FinishViewController () <UITableViewDelegate, UITableViewDataSource, NoDataTableViewCellDelegate>

@property (nonatomic, strong) XYTableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, retain) NSMutableDictionary *dataDic;
@property (nonatomic, retain) NSMutableArray *today_Time_Array;

@property (nonatomic, copy) NSString *monthCallBackIncome;
@property (nonatomic, copy) NSString *totalLoanedAmount;

@end

@implementation FinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataDic = [[NSMutableDictionary alloc] init];
    self.today_Time_Array = [[NSMutableArray alloc] init];
    [self initUI];
    [self setNav];
    [self setTheRequest];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setNav {
    self.navItem.title = XYBString(@"str_has_finished", @"已完成");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initUI {
    self.tableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = COLOR_BG;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[FinishTableViewCell class] forCellReuseIdentifier:@"FinishTableViewCell"];
    [self.tableView registerClass:[NoDataTableViewCell class] forCellReuseIdentifier:@"noDataTableViewCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom).offset(-1);
    }];
    
    self.tableView.header = self.gifHeader3;
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 41)];
    headView.backgroundColor = COLOR_BG;
    self.tableView.tableHeaderView = headView;

    UILabel *remaindTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindTitleLab.text = XYBString(@"str_plan",@"• 惠农宝和策诚年盈-格莱珉资产详情，请到信用宝网站查看");
    remaindTitleLab.textColor = COLOR_AUXILIARY_GREY;
    remaindTitleLab.font = WEAK_TEXT_FONT_11;
    [headView addSubview:remaindTitleLab];
    [remaindTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView.mas_centerY);
        make.left.equalTo(@12);
    }];
}



#pragma mark-- TableVIew Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.today_Time_Array.count <= 0) {
        return 1;
    } else {
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
    if (self.today_Time_Array.count <= 0) {
        return NO_DATA_CELL_HEIGHT;
    } else {
        return STOPFINISH_TABLEVEIW_CELL_HEIGHT;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.today_Time_Array.count <= 0) {
        return 0.f;
    } else {
        return 30.f;
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewHeadDate = [[UIView alloc] init];
    viewHeadDate.backgroundColor = COLOR_BG;
    UILabel *HeadDateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    NSString *curtime;
    
    if(self.today_Time_Array.count > 0)
    {
        curtime = [self.today_Time_Array objectAtIndex:section];
    }
    
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
    if (self.dataDic.count <= 0) {
        NoDataTableViewCell *cell = (NoDataTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"noDataTableViewCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[NoDataTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noDataTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellDelegate = self;
        return cell;
    } else {
        FinishTableViewCell *cell = (FinishTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"FinishTableViewCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[FinishTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FinishTableViewCell"];
        }
        if (self.today_Time_Array.count > 0) {
            NSArray *array = self.dataDic[self.today_Time_Array[indexPath.section]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *arr = [ProductsProject objectArrayWithKeyValuesArray:array];
            cell.investFinishProject = [arr objectAtIndex:indexPath.row];
        }

        return cell;
    }

    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)noDataTableViewCell:(NoDataTableViewCell *)cell didSelectButton:(UIButton *)button {

    //王智要求改的
    self.tabBarController.selectedIndex = 0;
}


#pragma mark - 设置刷新的方法
- (void)headerRereshing {
    
    _pageIndex = 0;
    [self.today_Time_Array removeAllObjects];
    [self refreshRequest];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    
    [self.tableView.header endRefreshing];
}

- (void)footerRefreshing {
    
    if (_pageIndex * 20 > _today_Time_Array.count) {
        self.tableView.footer.hidden = YES;
        
    } else {
        
        [self refreshRequest];
    }
    [self.tableView.footer endRefreshing];
}

- (void)refreshRequest {
    NSDictionary *param = @{
                            @"page" : [NSNumber numberWithInteger:self.pageIndex],
                            @"pageSize" : PageSize,
                            @"userId" : [UserDefaultsUtil getUser].userId,
                            @"projectType" : [NSNumber numberWithInteger:self.selectedInvestedType],
                            @"state" : [NSNumber numberWithInteger:1],
                            };
    [self requestMyInvestWebService:param];
}

- (void)setTheRequest {
    NSDictionary *param = @{
                            @"page" : [NSNumber numberWithInteger:self.pageIndex],
                            @"pageSize" : PageSize,
                            @"userId" : [UserDefaultsUtil getUser].userId,
                            @"projectType" : [NSNumber numberWithInteger:self.selectedInvestedType],
                            @"state" : [NSNumber numberWithInteger:1],
                            };
    BOOL s_isUpdate = NO;
    if (s_isUpdate == NO) {
        [self showDataLoading];
        s_isUpdate = YES;
    }
    [self requestMyInvestWebService:param];
}

-(void)requestMyInvestWebService:(NSDictionary *)param
{
    NSString *urlPath = [RequestURL getRequestURL:InvestMyInvestURL param:param];
    [WebService postRequest:urlPath param:param JSONModelClass:[DMInvestedProject class]
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self hideLoading];
                        [self.tableView.footer resetNoMoreData];
                        self.tableView.footer.hidden = NO;
                        DMInvestedProject *dmInvested = responseObject;
                        NSDictionary *dic = dmInvested.toDictionary;
                        if (dmInvested.resultCode == 1) {
                            
                            NSArray *products = [dic objectForKey:@"products"];
                            self.monthCallBackIncome = [NSString stringWithFormat:@"%.2f", [[dic objectForKey:@"monthCallBackIncome"] doubleValue]];
                            self.totalLoanedAmount = [NSString stringWithFormat:@"%.2f", [[dic objectForKey:@"totalLoanedAmount"] doubleValue]];
                            [self.dataDic removeAllObjects];
                            for (NSDictionary *dic in products) {
                                NSMutableString *dateStr = [NSMutableString stringWithString:[dic objectForKey:@"investDate"]];
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
                                    return [obj2 compare:obj1];
                                }
                                return NSOrderedSame;
                            }];
                            [self.tableView reloadData];
                            if ([products count] < [PageSize integerValue]) {
                                self.tableView.footer.hidden = YES;
                                [self.tableView.footer noticeNoMoreData];
                            }
                        }
                        
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self.tableView.header endRefreshing];
                           [self showPromptTip:errorMessage];
                       }
     
     ];
    _pageIndex ++;
}

//- (void)updateInvested {
//    if (!self.today_Time_Array) {
//        self.today_Time_Array = [[NSMutableArray alloc] init];
//    }
//    self.pageIndex = 0;
//
//    NSDictionary *param = @{
//        @"page" : [NSNumber numberWithInteger:self.pageIndex],
//        @"pageSize" : PageSize,
//        @"userId" : [UserDefaultsUtil getUser].userId,
//        @"projectType" : [NSNumber numberWithInteger:self.selectedInvestedType],
//        @"state" : [NSNumber numberWithInteger:1],
//    };
//
//    [self showDataLoading];
//
//}
//
//- (void)moreInvested {
//
//    self.pageIndex = self.pageIndex + 1;
//    [self.tableView.footer endRefreshing];
//
//    NSDictionary *param = @{
//        @"page" : [NSNumber numberWithInteger:self.pageIndex],
//        @"pageSize" : PageSize,
//        @"userId" : [UserDefaultsUtil getUser].userId,
//        @"projectType" : [NSNumber numberWithInteger:self.selectedInvestedType],
//        @"state" : [NSNumber numberWithInteger:1],
//    };
//    [self showDataLoading];
//
//    NSString *urlPath = [RequestURL getRequestURL:InvestMyInvestURL param:param];
//    [WebService postRequest:urlPath param:param JSONModelClass:[DMInvestedProject class]
//        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [self hideLoading];
//            [self.tableView.footer endRefreshing];
//            DMInvestedProject *dmInvested = responseObject;
//            NSDictionary *dic = dmInvested.toDictionary;
//            if (dmInvested.resultCode == 1) {
//
//                NSArray *products = [dic objectForKey:@"products"];
//                for (NSDictionary *dic in products) {
//                    NSMutableString *dateStr = [NSMutableString stringWithString:[dic objectForKey:@"investDate"]];
//                    NSArray *arrDate = [dateStr componentsSeparatedByString:@"-"];
//                    NSString *dateStrData = [NSString stringWithFormat:@"%@年%@月", arrDate[0], arrDate[1]];
//                    if (self.dataDic.count == 0) {
//                        NSMutableArray *mutArr = [[NSMutableArray alloc] init];
//                        [mutArr addObject:dic];
//                        [self.dataDic setValue:mutArr forKey:dateStrData];
//                    } else {
//                        if ([[self.dataDic allKeys] containsObject:dateStrData]) {
//                            [self.dataDic[dateStrData] addObject:dic];
//                        } else {
//                            NSMutableArray *mutArr3 = [[NSMutableArray alloc] init];
//                            [mutArr3 addObject:dic];
//                            [self.dataDic setValue:mutArr3 forKey:dateStrData];
//                        }
//                    }
//                }
//                [self.today_Time_Array removeAllObjects];
//                [self.today_Time_Array addObjectsFromArray:[self.dataDic allKeys]];
//
//                [self.today_Time_Array sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
//                    if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {
//                        return [obj2 compare:obj1];
//                    }
//                    return NSOrderedSame;
//                }];
//                [self.tableView reloadData];
//
//                if ([products count] < [PageSize integerValue]) {
//                    [self.tableView.footer noticeNoMoreData];
//                    self.tableView.footer.hidden = YES;
//                }
//            }
//
//        }
//        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
//            [self hideLoading];
//            [self.tableView.footer endRefreshing];
//            [self showPromptTip:errorMessage];
//        }
//
//    ];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
