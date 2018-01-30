//
//  NotAssetListView.m
//  Ixyb
//
//  Created by dengjian on 2017/3/11.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NotAssetListView.h"
#import "Utility.h"
#import "AssetListTableViewCell.h"
#import "RequestURL.h"
#import "WebService.h"
#import "MJRefresh.h"
#import "NoDataView.h"

@interface NotAssetListView ()

@property (nonatomic, copy) NSString *productType; //产品类型：步步高：BBG；定期宝：ZZY CCNY
@property (nonatomic, copy) NSString *projectId;   //产品ID
@property (nonatomic, copy) NSString *amountStr;   //项目发售额度
@property (nonatomic, strong) NSMutableArray *dataSource;//数据源
@property (nonatomic, assign) int state;           //状态 1: 发售中 2：发售完

@end

@implementation NotAssetListView {
    
    XYTableView *myTableView;  //已匹配资产视图
    NoDataView *fullBidView;   //项目已满标
    int currentPage;           //页码
}

- (instancetype)initWithFrame:(CGRect)frame state:(int)state productType:(NSString *)productType projectId:(NSString *)projectId amountStr:(NSString *)amountStr
{
    self = [super initWithFrame:frame];
    if (self) {
        [self getValueState:state productType:productType projectId:projectId amountStr:amountStr];
        [self createNoDataView];
        [self createMainUI];
        [self setupRefresh];
        if (self.state == 1) {
            [self callNotConfigureAssetListWebServiceWithAmount:[amountStr floatValue] showLoading:YES];
        }
    }
    return self;
}


/**
 接收init方法传过来的值
 
 @param state       状态 1: 发售中 2：发售完
 @param productType 产品类型：步步高：BBG；定期宝：ZZY CCNY
 @param projectId   产品ID
 @param amountStr   项目发售额度
 */
- (void)getValueState:(int)state productType:(NSString *)productType projectId:(NSString *)projectId amountStr:(NSString *)amountStr {
    _state = state;
    _productType = productType;
    _projectId = projectId;
    _amountStr = amountStr;
}

- (void)createNoDataView {
    fullBidView = [[NoDataView alloc] initWithFrame:CGRectZero];
    fullBidView.titleLab.text = @"项目已满标";
    if (self.state == 1) {
        fullBidView.titleLab.text = @"暂无记录";
        fullBidView.hidden = YES;
    }else if (self.state == 2) {
        fullBidView.hidden = NO;
        fullBidView.titleLab.text = @"项目已满标";
    }
    [self addSubview:fullBidView];
    
    [self sendSubviewToBack:fullBidView];
    
    [fullBidView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [self callNotConfigureAssetListWebServiceWithAmount:[_amountStr floatValue] showLoading:YES];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [myTableView.header endRefreshing];
}

- (void)footerRereshing {
    
    if (currentPage * 20 > self.dataSource.count) {
        [myTableView.footer noticeNoMoreData];
        
    } else {
        [self callNotConfigureAssetListWebServiceWithAmount:[_amountStr floatValue] showLoading:NO];
        [myTableView.footer endRefreshing];
    }
}

#pragma mark - 待配置资产列表 Webservice

/**
 待配置资产列表的数据请求
 
 @param showLoading 是否带有loading
 */
- (void)callNotConfigureAssetListWebServiceWithAmount:(CGFloat)amount showLoading:(BOOL)showLoading {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.productType forKey:@"productType"];
    [params setValue:self.projectId forKey:@"projectId"];
    [params setValue:self.amountStr forKey:@"amount"];
    [params setValue:[NSNumber numberWithInt:currentPage] forKey:@"page"];
    [params setValue:[NSNumber numberWithInt:20] forKey:@"pageSize"];
    [params setValue:[NSNumber numberWithInt:0] forKey:@"assetType"];//待配置资产 和 已配置资产列表数据请求区分：0：待匹配 1：已匹配
//    [params setValue:[NSNumber numberWithD:[_amountStr doubleValue]] forKey:@"amount"];//查询未匹配时需要，项目发售额度
    
    if (showLoading == YES) {
        [self showDataLoading];
    }
    [self requestConfigureAssetListWebServiceWithParam:params];
}

- (void)requestConfigureAssetListWebServiceWithParam:(NSDictionary *)params {
    
    NSString *requestURL = [RequestURL getRequestURL:FinanceAssetListURL param:params];
    [WebService postRequest:requestURL param:params JSONModelClass:[AssetListModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        AssetListModel *model = responseObject;
                        [_dataSource addObjectsFromArray:model.assetList];
                        [myTableView reloadData];
                        
                        if (self.dataSource.count == 0) {
                            fullBidView.hidden = NO;
                            
                        } else {
                            fullBidView.hidden = YES;
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

@end
