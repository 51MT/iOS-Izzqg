//
//  ZqzrMorProductView.m
//  Ixyb
//
//  Created by dengjian on 16/6/23.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "MJExtension.h"
#import "MJRefresh.h"
#import "ZqzrMoreProductView.h"

#import "BidProductResponseModel.h"
#import "WebService.h"
#import "ZqzrTableViewCell.h"

@implementation ZqzrMoreProductView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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

    ZQZRTable = [[XYTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    ZQZRTable.backgroundColor = COLOR_COMMON_CLEAR;
    ZQZRTable.showsVerticalScrollIndicator = NO;
    ZQZRTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    ZQZRTable.delegate = self;
    ZQZRTable.dataSource = self;
    [ZQZRTable registerClass:[ZqzrTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:ZQZRTable];

    [ZQZRTable mas_makeConstraints:^(MASConstraintMaker *make) {
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
        @"page" : [NSNumber numberWithInt:currentPage],
        @"pageSize" : PageSize,
    };

    [self requestZqzrProductWebService:contentDic];
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
            return 176.f;
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

    ZqzrTableViewCell *cell = (ZqzrTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[ZqzrTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //回调时，clickTheInvestButton再次进行回调，完成跳转
    ZqzrTableViewCell *weakCell = cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    ZQZRTable.header = self.gifHeader3;
    ZQZRTable.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (void)headerRereshing {
    currentPage = 0;
    [_dataArray removeAllObjects];
    [self refreshRequest];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [ZQZRTable.header endRefreshing];
}

- (void)footerRereshing {

    if (currentPage * 20 > _dataArray.count) {
        ZQZRTable.footer.hidden = YES;
        [ZQZRTable.footer noticeNoMoreData];

    } else {

        [self refreshRequest];
        [ZQZRTable.footer endRefreshing];
    }
}

- (void)refreshRequest {

    NSDictionary *contentDic = @{
        @"page" : [NSNumber numberWithInt:currentPage],
        @"pageSize" : PageSize,
    };
    [self requestZqzrProductWebService:contentDic];
}

#pragma mark - 债权转让产品列表接口

- (void)requestZqzrProductWebService:(NSDictionary *)param {
    NSString *requestURL = [RequestURL getRequestURL:ZqzrProductData param:param];
    [WebService postRequest:requestURL param:param JSONModelClass:[BidProductResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        BidProductResponseModel *model = responseObject;
        [_dataArray addObjectsFromArray:model.products];
        [ZQZRTable reloadData];

        if (_dataArray.count == 0) {

            noDataView.hidden = NO;
            ZQZRTable.footer.hidden = YES;
        } else {
            noDataView.hidden = YES;
            if (currentPage * 20 > _dataArray.count) {

                ZQZRTable.footer.hidden = YES;

            } else {
                ZQZRTable.footer.hidden = NO;
                [ZQZRTable.footer resetNoMoreData];
            }
        }

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [ZQZRTable reloadData];
            if (_dataArray.count == 0) {

                noDataView.hidden = NO;
                ZQZRTable.footer.hidden = YES;
            }

            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];

    currentPage++;
}

@end
