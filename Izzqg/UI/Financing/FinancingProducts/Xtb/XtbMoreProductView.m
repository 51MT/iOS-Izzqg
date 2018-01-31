//
//  XtbMoreProductView.m
//  Ixyb
//
//  Created by wang on 15/8/27.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "BidProductResponseModel.h"
#import "WebService.h"
#import "XtbMoreProductView.h"

#import "MJExtension.h"
#import "MJRefresh.h"

#import "XtbTableViewCell.h"

@implementation XtbMoreProductView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        currentPage = 0;
        _dataArray = [[NSMutableArray alloc] init];
        [self creatTheNodataView];
        [self setUI];
        [self setupRefresh];
      
    }
    return self;
}

- (void)setUI {

    xtbTable = [[XYTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    xtbTable.backgroundColor = COLOR_COMMON_CLEAR;
    xtbTable.showsVerticalScrollIndicator = NO;
    xtbTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    xtbTable.delegate = self;
    xtbTable.dataSource = self;
    [xtbTable registerClass:[XtbTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:xtbTable];

    [xtbTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-64);
    }];
}

- (void)creatTheNodataView {

    noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    noDataView.hidden = YES;
    [self addSubview:noDataView];

    //[self sendSubviewToBack:noDataView];

    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setTheRequest:(int)page {
    currentPage = page;
    [_dataArray removeAllObjects];
    NSDictionary *contentDic = @{
        @"page" : [NSNumber numberWithInt:0],
        @"pageSize" : PageSize,
        @"userId" : [Utility shareInstance].isLogin ? [UserDefaultsUtil getUser].userId : @"0"
    };
    [self requestXtbProductWebService:contentDic];
}

- (void)setTheRequest {

    NSDictionary *contentDic = @{
        @"page" : [NSNumber numberWithInt:currentPage],
        @"pageSize" : PageSize,
        @"userId" : [Utility shareInstance].isLogin ? [UserDefaultsUtil getUser].userId : @"0"
    };
    [self showDataLoading];
    [self requestXtbProductWebService:contentDic];
}

#pragma mark-- tableView delegate method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_dataArray.count > 0) {
        if (indexPath.row == 0) {
            return 175.f;
        }else if(indexPath.row == _dataArray.count - 1){
            return 176;
        }else{
            return 168.0f;
        }
    }
    return 175.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XtbTableViewCell *cell = (XtbTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[XtbTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //回调时，clickTheInvestButton再次进行回调，完成跳转
    XtbTableViewCell *weakCell = cell;
    cell.block = ^{
        if (self.clickTheInvestButton) {
            BidProduct *product = weakCell.info;
            self.clickTheInvestButton(product);
        }
    };

    if (_dataArray.count > 0) {
        cell.info = _dataArray[indexPath.row];
        if (indexPath.row == 0) {
            [cell.backImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView.mas_top).offset(8);
            }];
        } else {
            [cell.backImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView.mas_top).offset(1);
            }];
        }
    }

    return cell;
}


#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    xtbTable.header = self.gifHeader3;
    xtbTable.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (void)headerRereshing {
    currentPage = 0;
    [_dataArray removeAllObjects];
    [self refreshRequest];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [xtbTable.header endRefreshing];
}

- (void)footerRereshing {

    if (currentPage * 20 > _dataArray.count) {
        xtbTable.footer.hidden = YES;

    } else {

        [self refreshRequest];
    }
    [xtbTable.footer endRefreshing];
}

- (void)refreshRequest {
    NSDictionary *contentDic = @{
                                 @"page" : [NSNumber numberWithInt:currentPage],
                                 @"pageSize" : PageSize,
                                 @"userId" : [Utility shareInstance].isLogin ? [UserDefaultsUtil getUser].userId : @"0"
                                 };
    [self requestXtbProductWebService:contentDic];
}

#pragma mark - 信投宝产品列表接口

- (void)requestXtbProductWebService:(NSDictionary *)param {
    NSString *requestURL = [RequestURL getRequestURL:XtbProductData param:param];
    [WebService postRequest:requestURL param:param JSONModelClass:[BidProductResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [self hideLoading];
        BidProductResponseModel *model = responseObject;
        User *user = [UserDefaultsUtil getUser];
        user.isNewUser = model.isNewUser;
        [UserDefaultsUtil setUser:user];

        [_dataArray addObjectsFromArray:model.products];
        [xtbTable reloadData];

        if (_dataArray.count == 0) {

            noDataView.hidden = NO;
            xtbTable.footer.hidden = YES;
        } else {
            noDataView.hidden = YES;
            if (currentPage * 20 > _dataArray.count) {

                xtbTable.footer.hidden = YES;

            } else {
                xtbTable.footer.hidden = NO;
                [xtbTable.footer resetNoMoreData];
            }
        }
    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {

            [xtbTable reloadData];
            if (_dataArray.count == 0) {

                noDataView.hidden = NO;
                xtbTable.footer.hidden = YES;
            }

            [self hideLoading];
            [self showPromptTip:errorMessage];

        }];
    currentPage++;
}

@end
