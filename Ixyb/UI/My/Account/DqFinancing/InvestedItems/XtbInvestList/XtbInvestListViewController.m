//
//  XtbInvestListViewController.m
//  Ixyb
//
//  Created by wang on 2017/9/19.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "XtbInvestListViewController.h"
#import "Utility.h"
#import "XtbInvestListModel.h"
#import "WebService.h"
#import "FinishViewController.h"
#import "NoDataTableViewCell.h"
#import "MJExtension.h"
#import "MyViewController.h"
#import "AllAssetsViewController.h"
#import "MJRefresh.h"
#import "XtbInvestListTableViewCell.h"
#import "InvestedDetailXtbViewController.h"

#define VIEW_TAG_AOMOUNT_LABEL 50301
#define VIEW_TAG_TO_RECEIVE_LABEL 50302

@interface XtbInvestListViewController ()<UITableViewDataSource, UITableViewDelegate, NoDataTableViewCellDelegate> {
    int count;
}
@property (nonatomic, strong) XYTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic) NSInteger selectedTabIndex;     // 0: 持有中 1:已完成
@property (nonatomic, copy) NSString *totalLoanedAmount;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic) NSInteger pageIndex;

@property (nonatomic, strong) XYTableView *dropTableView;
@property (nonatomic, strong) NSMutableArray *dropDataArray;

@end

@implementation XtbInvestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    count = 0;
    [self initUI];
    [self initData];
    [self setTheRequest];
}

- (void)initData {
    
    self.dataArray = [NSMutableArray arrayWithCapacity:5];
    self.totalLoanedAmount = @"";
    self.pageIndex = 0;
    self.selectedTabIndex = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAndRefreshInvestedItemsVCData:) name:@"reloadAndRefreshInvestedItemsVCData" object:nil];
}

- (void)initUI {
    
    self.navItem.title  = XYBString(@"str_common_xtb", @"信投宝");
    
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 60.0f, 40.0f);
    [button setTitle:XYBString(@"str_has_finished", @"已完成") forState:UIControlStateNormal];
    button.titleLabel.font = TEXT_FONT_14;
    [button addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:COLOR_COMMON_GRAY forState:UIControlStateHighlighted];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
    
    [self initTableView];
}

/**
 *  已完成
 *
 *  @param sender 无意义
 */
- (void)clickRightBtn:(id)sender {
    FinishViewController *finishVC = [[FinishViewController alloc] init];
    finishVC.selectedInvestedType = 0;
    [self.navigationController pushViewController:finishVC animated:YES];
}

- (void)noDataTableViewCell:(NoDataTableViewCell *)cell didSelectButton:(UIButton *)button {
    //王智要求改的
    self.tabBarController.selectedIndex = 0;
}

- (void)initTableView {
    
    self.tableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = COLOR_BG;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[XtbInvestListTableViewCell class] forCellReuseIdentifier:@"investedTableViewCell"];
    [self.tableView registerClass:[NoDataTableViewCell class] forCellReuseIdentifier:@"noDataTableViewCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 113)];
    headView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"havecastbg"]];
    
    self.tableView.tableHeaderView = headView;
    self.headView = headView;
    
    
    UILabel *tip1Label = [[UILabel alloc] init];
    tip1Label.text = XYBString(@"str_financial_capital", @"待收本金(元)");
    tip1Label.font = TEXT_FONT_14;
    tip1Label.textColor = COLOR_COMMON_WHITE;
    [headView addSubview:tip1Label];
    [tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).offset(22);
        make.top.equalTo(headView.mas_top).offset(21);
    }];
    
    
    UILabel *amountLabel = [[UILabel alloc] init]; //出借金额（全部已投）
    amountLabel.text = @"0.00";
    amountLabel.textColor = COLOR_COMMON_WHITE;
    amountLabel.font = [UIFont systemFontOfSize:30.0f];
    amountLabel.tag = VIEW_TAG_AOMOUNT_LABEL;
    [headView addSubview:amountLabel];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tip1Label.mas_left);
        make.top.equalTo(tip1Label.mas_bottom).offset(Margin_Bottom);
    }];
    
    
    self.tableView.header = self.gifHeader3;
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}


#pragma mark - 设置刷新的方法
- (void)headerRereshing {
    
    _pageIndex = 0;
    [self.dataArray removeAllObjects];
    [self refreshRequest];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    
    [self.tableView.header endRefreshing];
}

- (void)footerRefreshing {
    
    if (_pageIndex * 20 > _dataArray.count) {
        self.tableView.footer.hidden = YES;
        
    } else {
        
        [self refreshRequest];
    }
    [self.tableView.footer endRefreshing];
}

- (void)setTheRequest {
    NSDictionary *param = @{
                            @"page" : [NSNumber numberWithInteger:self.pageIndex],
                            @"pageSize" : PageSize,
                            @"userId" : [UserDefaultsUtil getUser].userId,
                            @"state" : [NSNumber numberWithInteger:self.selectedTabIndex],
                            };
    BOOL s_isUpdate = NO;
    if (s_isUpdate == NO) {
        [self showDataLoading];
        s_isUpdate = YES;
    }
    [self requestMyInvestWebService:param];
}


- (void)refreshRequest {
    NSDictionary *param = @{
                            @"page" : [NSNumber numberWithInteger:self.pageIndex],
                            @"pageSize" : PageSize,
                            @"userId" : [UserDefaultsUtil getUser].userId,
                            @"state" : [NSNumber numberWithInteger:self.selectedTabIndex],
                            };
    [self requestMyInvestWebService:param];
}



-(void)requestMyInvestWebService:(NSDictionary *)param
{
    NSString *urlPath = [RequestURL getRequestURL:XtbInvestOrderList param:param];
    [WebService postRequest:urlPath param:param JSONModelClass:[XtbInvestListModel class]
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self hideLoading];
                        [self.tableView.footer resetNoMoreData];
                        self.tableView.footer.hidden = NO;
                        XtbInvestListModel * dmInvested = responseObject;
                        if (dmInvested.resultCode == 1) {
                            
                            NSArray *products = dmInvested.orderList;
                            self.totalLoanedAmount = [NSString stringWithFormat:@"%.2f", [dmInvested.totalLoanedAmount doubleValue]];
                            [self.dataArray addObjectsFromArray:products];
                            
                            [self.tableView reloadData];
                            [self refreshHeadView];
                            
                            if ([products count] < [PageSize integerValue]) {
                                self.tableView.footer.hidden = YES;
                                [self.tableView.footer noticeNoMoreData];
                            }
                        }
                        
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           
                           UILabel *amountLabel = (UILabel *) [self.headView viewWithTag:VIEW_TAG_AOMOUNT_LABEL];
                           amountLabel.text = @"0.00";
                           [self.dataArray removeAllObjects];
                           [self.tableView reloadData];
                           
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }
     
     ];
    self.pageIndex++;
}

- (void)clickBackBtn:(id)sender {
//    NSArray *VCArray = self.navigationController.viewControllers;
//    UIViewController *VC = [VCArray objectAtIndex:VCArray.count - 2];
//    if ([VC isKindOfClass:[MyViewController class]] || [VC isKindOfClass:[AllAssetsViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
//    } else {
//        [self.navigationController popToViewController:[VCArray objectAtIndex:VCArray.count - 4] animated:YES];
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        if (self.dataArray.count <= 0) {
            return 1;
        } else {
            return [self.dataArray count];
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        if (self.dataArray.count <= 0) {
            return NO_DATA_CELL_HEIGHT;
        } else {
            return INVESTED_TABLEVEIW_CELL_HEIGHT;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return 10.f;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        if (self.dataArray.count <= 0) {
            
            //            remaindView.hidden = YES;//隐藏添加的提示语
            NoDataTableViewCell *cell = (NoDataTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"noDataTableViewCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[NoDataTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noDataTableViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.cellDelegate = self;
            
            return cell;
        } else if(self.dataArray.count > 0){
            
            //已出借Cell
            XtbInvestListTableViewCell *cell = (XtbInvestListTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"investedTableViewCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[XtbInvestListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"investedTableViewCell"];
            }
            
            cell.xtbOrderList = [self.dataArray objectAtIndex:indexPath.row];
            
            return cell;
        }
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (self.dataArray.count > 0) {
            XtbOrderListModel * investedProject = self.dataArray[indexPath.row];
            InvestedDetailXtbViewController *vc = [[InvestedDetailXtbViewController alloc] init];
            vc.dicXtbInfo = investedProject.toDictionary;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0,MainScreenWidth, 10.f)];
    v.backgroundColor = COLOR_BG;
    
    return v;
}


- (void)refreshHeadView {
    UILabel *amountLabel = (UILabel *) [self.headView viewWithTag:VIEW_TAG_AOMOUNT_LABEL];
    if ([self.totalLoanedAmount doubleValue] == 0) {
        amountLabel.text = @"0.00";
    } else {
        amountLabel.text = [Utility replaceTheNumberForNSNumberFormatter:self.totalLoanedAmount];
    }
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
