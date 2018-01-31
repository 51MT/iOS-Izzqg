//
//  ConfigureAssetListView.m
//  Ixyb
//
//  Created by dengjian on 2017/3/11.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "AssetListView.h"
#import "Utility.h"
#import "AssetListTableViewCell.h"
#import "RequestURL.h"
#import "WebService.h"
#import "MJRefresh.h"
#import "NoDataView.h"

@interface AssetListView ()

@property (nonatomic, copy) NSString *productType; //产品类型：步步高：BBG；定期宝：ZZY CCNY
@property (nonatomic, copy) NSString *projectId;   //产品ID
@property(nonatomic, strong) NSMutableArray *dataSource;//数据源
@property (nonatomic, assign) int state;           //状态 1: 发售中 2：发售完

@end

@implementation AssetListView {
    
    XYTableView *myTableView;  //已匹配资产视图
    NoDataView *noDataView;    //暂无记录
    int currentPage;           //页码
}

- (instancetype)initWithFrame:(CGRect)frame state:(int)state productType:(NSString *)productType projectId:(NSString *)projectId
{
    self = [super initWithFrame:frame];
    if (self) {
        [self getValueState:state productType:productType projectId:projectId];
        [self createNoDataView];
        [self createMainUI];
        [self setupRefresh];
    }
    return self;
}

/**
 接收init方法传过来的值
 
 @param state       状态 1: 发售中 2：发售完
 @param productType 产品类型：步步高：BBG；定期宝：ZZY CCNY
 @param projectId   产品ID
 */
- (void)getValueState:(int)state productType:(NSString *)productType projectId:(NSString *)projectId {
    _state = state;
    _productType = productType;
    _projectId = projectId;
}


- (void)createNoDataView {
    noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    if (self.state == 1) {
        noDataView.titleLab.text = @"暂无记录";
        noDataView.hidden = YES;
    }else if (self.state == 2) {
        noDataView.hidden = NO;
        noDataView.titleLab.text = @"项目已满标";
    }
    [self addSubview:noDataView];
    
    [self sendSubviewToBack:noDataView];
    
    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)createMainUI {
    //已匹配资产展示区
    myTableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    myTableView.backgroundColor = COLOR_COMMON_CLEAR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [myTableView registerClass:[AssetListTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:myTableView];
    
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

#pragma mark - tableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AssetListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[AssetListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (self.dataSource.count > 0) {
        cell.model = [self.dataSource objectAtIndex:indexPath.row];
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

#pragma mark - tableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Cell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.complete) {
        AssetModel *model = [self.dataSource objectAtIndex:indexPath.row];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:model.matchType forKey:@"matchType"];
        [params setObject:model.loanType forKey:@"loanType"];
        [params setObject:model.projectId forKey:@"projectId"];
        
        _complete([params copy]);
    }
}

#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    if (self.state == 2) {
        return;
    }
    myTableView.header = self.gifHeader3;
    myTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (void)headerRereshing {
    if (self.state == 2) {
        return;
    }
    currentPage = 0;
    [self.dataSource removeAllObjects];
    [self callConfigureAssetListWebServiceWithShowLoading:YES];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [myTableView.header endRefreshing];
}

- (void)footerRereshing {
    
    if (currentPage * 20 > self.dataSource.count) {
        [myTableView.footer noticeNoMoreData];
        
    } else {
        [self callConfigureAssetListWebServiceWithShowLoading:NO];
        [myTableView.footer endRefreshing];
    }
}

#pragma mark - 已配置资产列表 Webservice

- (void)requestConfigureAssetListWebServiceWithParam:(NSDictionary *)params {
    
    NSString *requestURL = [RequestURL getRequestURL:FinanceAssetListURL param:params];
    [WebService postRequest:requestURL param:params JSONModelClass:[AssetListModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self hideLoading];
                        AssetListModel *model = responseObject;
                        [_dataSource addObjectsFromArray:model.assetList];
                        [myTableView reloadData];
                        
                        if (self.dataSource.count == 0) {
                            noDataView.hidden = NO;
                            
                        } else {
                            noDataView.hidden = YES;
                            if (currentPage * 20 > self.dataSource.count) {
                                myTableView.footer.hidden = YES;
                                [myTableView.footer resetNoMoreData];
                            } else {
                                myTableView.footer.hidden = NO;
                            }
                        }
                    }
     
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }
     ];
    currentPage ++;
}

- (void)callConfigureAssetListWebServiceWithShowLoading:(BOOL)showLoading {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.productType forKey:@"productType"];
    [params setValue:self.projectId forKey:@"projectId"];
    [params setValue:[NSNumber numberWithInt:currentPage] forKey:@"page"];
    [params setValue:[NSNumber numberWithInt:20] forKey:@"pageSize"];
    [params setValue:[NSNumber numberWithInt:1] forKey:@"assetType"];//资产类型0 未匹配，1 已匹配
    
    if (showLoading == YES) {
        [self showDataLoading];
    }
    [self requestConfigureAssetListWebServiceWithParam:params];
}

@end
