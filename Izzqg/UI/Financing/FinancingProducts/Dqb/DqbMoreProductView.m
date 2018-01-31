//
//  DqbMoreProductView.m
//  Ixyb
//
//  Created by wang on 15/8/27.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "DqbMoreProductView.h"

#import "MJExtension.h"
#import "MJRefresh.h"
#import "Utility.h"

#import "CcProductResponseModel.h"
#import "DqbTableViewCell.h"
#import "WebService.h"
#import "UMengAnalyticsUtil.h"

@implementation DqbMoreProductView

@synthesize dataArray;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        currentPage = 0;
        dataArray = [[NSMutableArray alloc] init];
        [self creatTheNodataView];
        [self setUI];
        [self setupRefresh];
    }
    return self;
}

- (void)setUI {
    
    dqbTable = [[XYTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    dqbTable.backgroundColor = COLOR_COMMON_CLEAR;
    //    dqbTable.scrollEnabled = NO;
    dqbTable.showsHorizontalScrollIndicator = NO;
    dqbTable.showsVerticalScrollIndicator = NO;
    dqbTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    dqbTable.delegate = self;
    dqbTable.dataSource = self;
    [dqbTable registerClass:[DqbTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:dqbTable];

    [dqbTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-64);
    }];
}

- (void)creatTheNodataView {

    noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    noDataView.hidden = YES;
    [self addSubview:noDataView];

    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)refreshRequest {
    NSDictionary *contentDic = @{
                                 @"page" : [NSNumber numberWithInt:0],
                                 @"pageSize" : PageSize,
                                 @"userId" : [Utility shareInstance].isLogin ? [UserDefaultsUtil getUser].userId : @"0"
                                 };
    [self requestCcProductWebService:contentDic];
}

- (void)setTheRequest {

    NSDictionary *contentDic = @{
        @"page" : [NSNumber numberWithInt:0],
        @"pageSize" : PageSize,
        @"userId" : [Utility shareInstance].isLogin ? [UserDefaultsUtil getUser].userId : @"0"
    };
    [self showDataLoading];
    [self requestCcProductWebService:contentDic];
}

#pragma mark-- tableView delegate method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (dataArray.count > 0) {
        if (indexPath.row == 0) {
            return 175.f;
        }else if(indexPath.row == dataArray.count - 1){
            return 176;
        }else{
            return 168.0f;
        }
    }
    return 174.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DqbTableViewCell *cell = (DqbTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DqbTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //回调时，clickTheInvestButton再次进行回调，完成跳转
    DqbTableViewCell *weakCell = cell;
    cell.block = ^{
//        NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%zi", indexPath.row], @"click_index", nil];
        
//        [UMengAnalyticsUtil event:EVENT_PRODUCT_DQB_INVEST attributes:attr];
        if (self.clickTheInvestButton) {
            CcProductModel *product = weakCell.info;
            self.clickTheInvestButton(product);
        }
    };

    if (dataArray.count > 0) {
        cell.info = dataArray[indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //    if (self.clickTheDetailVC) {
    //        CcProduct *product = [dataArray objectAtIndex:indexPath.row];
    //        self.clickTheDetailVC(product);
    //    }
}

#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    dqbTable.header = self.gifHeader3;
}

- (void)headerRereshing {
    [dataArray removeAllObjects];
    [self refreshRequest];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [dqbTable.header endRefreshing];
}

#pragma mark -定期宝产品列表接口

- (void)requestCcProductWebService:(NSDictionary *)param {

    NSString *requestURL = [RequestURL getRequestURL:CcProductData param:param];
    [WebService postRequest:requestURL param:param JSONModelClass:[CcProductResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [self hideLoading];
        CcProductResponseModel *model = responseObject;
        User *user = [UserDefaultsUtil getUser];
        user.isNewUser = model.isNewUser;
        [UserDefaultsUtil setUser:user];

        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray:model.products];

        if (dataArray.count == 0) {
            noDataView.hidden = NO;
        } else {
            noDataView.hidden = YES;
        }

        [dqbTable reloadData];

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {

            if (dataArray.count == 0) {
                noDataView.hidden = NO;
            } else {
                noDataView.hidden = YES;
            }
            [self hideLoading];
            [self showPromptTip:errorMessage];

        }];
}

@end
