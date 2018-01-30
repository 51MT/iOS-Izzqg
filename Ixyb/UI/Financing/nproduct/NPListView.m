//
//  NPListView.m
//  Ixyb
//
//  Created by wang on 2017/12/13.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NPListView.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "NPListTableViewCell.h"
#import "WebService.h"
#import "UMengAnalyticsUtil.h"
#import "NPIntroduceViewController.h"

@interface NPListView () {
    
    XYTableView *npTableview;
    int currentPage;
    NoDataView *noDataView;
    MBProgressHUD *hud;
}

@property (nonatomic,strong) UINavigationController *nav;

@end

@implementation NPListView

- (id)initWithFrame:(CGRect)frame navigationController:(UINavigationController *)nav {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = COLOR_COMMON_CLEAR;
        _nav = nav;
        currentPage = 0;
        _dataArray = [[NSMutableArray alloc] init];
        [self creatTheNodataView];
        [self setUI];
        [self setupRefresh];
    }
    return self;
}

- (void)setUI {
    
    npTableview = [[XYTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    npTableview.backgroundColor = COLOR_COMMON_CLEAR;
    npTableview.showsHorizontalScrollIndicator = NO;
    npTableview.showsVerticalScrollIndicator = NO;
    npTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    npTableview.delegate = self;
    npTableview.dataSource = self;
    [npTableview registerClass:[NPListTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:npTableview];
    
    [npTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-64);
    }];
    
    UIView * viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 37.f)];
    viewHead.backgroundColor = COLOR_BG_ORANGE;
    npTableview.tableHeaderView = viewHead;
    
    UIButton *yjcjGZBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [yjcjGZBtn setBackgroundImage:[ColorUtil imageWithColor:COLOR_BUTTON_HIGHLIGHT] forState:UIControlStateHighlighted];
    [yjcjGZBtn addTarget:self action:@selector(clickyjcjGZControl:) forControlEvents:UIControlEventTouchUpInside];
    [viewHead addSubview:yjcjGZBtn];
    
    [yjcjGZBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewHead.mas_top);
        make.width.equalTo(viewHead.mas_width);
        make.bottom.equalTo(viewHead.mas_bottom);
    }];
    
    UIImageView *infoDepositoryIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lendstate"]];
    infoDepositoryIconView.userInteractionEnabled = NO;
    [yjcjGZBtn addSubview:infoDepositoryIconView];
    
    [infoDepositoryIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.centerY.equalTo(viewHead);
    }];
    
    UILabel *tipYjcjGZLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipYjcjGZLabel.text = XYBString(@"str_aaount_yjcjgz", @"使用“一键出借”前，请戳这里了解详细规则。");
    tipYjcjGZLabel.font = SMALL_TEXT_FONT_13;
    tipYjcjGZLabel.textColor = COLOR_ORANGE;
    [yjcjGZBtn addSubview:tipYjcjGZLabel];
    
    [tipYjcjGZLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoDepositoryIconView.mas_right).offset(9.f);
        make.centerY.equalTo(yjcjGZBtn.mas_centerY);
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


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NPListTableViewCell *cell = (NPListTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NPListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataArray.count > 0) {
        NProductModel *model = [_dataArray objectAtIndex:indexPath.row];
        cell.info = model;
    }
    
    //回调时，clickTheInvestButton再次进行回调，完成跳转
    NPListTableViewCell *weakCell = cell;
    cell.block = ^{
        if (self.clickTheInvestButton) {
            NProductModel *product = weakCell.info;
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

#pragma mark - tableView delegate method

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
    
    return 174.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.clickTheDetailVC) {
        NProductModel *product = [_dataArray objectAtIndex:indexPath.row];
        self.clickTheDetailVC(product);
    }
}

//一键出借规则介绍
- (void)clickyjcjGZControl:(id)sender
{
    NPIntroduceViewController * introduceVC = [[NPIntroduceViewController alloc] init];
    introduceVC.navItem.title = XYBString(@"str_finance_newProductIntroduction", @"一键出借规则");
    [_nav pushViewController:introduceVC animated:YES];
}

#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    npTableview.header = self.gifHeader3;
}

- (void)headerRereshing {
    [_dataArray removeAllObjects];
    [self refreshRequest];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [npTableview.header endRefreshing];
}

#pragma mark - 一键出借列表 数据请求

/**
 暴露的对象方法，方便MoreProductViewController中的滑块滑动时 新产品页面请求数据
 */
- (void)setTheRequest {
    
    NSDictionary *contentDic = @{
                                 @"page" : [NSNumber numberWithInt:0],
                                 @"pageSize" : PageSize,
                                 @"userId" : [Utility shareInstance].isLogin ? [UserDefaultsUtil getUser].userId : @"0"
                                 };
    [self showDataLoading];
    [self requestOneKeyProductWebService:contentDic];
}


/**
 刷新时使用
 */
- (void)refreshRequest {
    
    NSDictionary *contentDic = @{
                                 @"page" : [NSNumber numberWithInt:0],
                                 @"pageSize" : PageSize,
                                 @"userId" : [Utility shareInstance].isLogin ? [UserDefaultsUtil getUser].userId : @"0"
                                 };
    [self requestOneKeyProductWebService:contentDic];
}

- (void)requestOneKeyProductWebService:(NSDictionary *)param {
    
    NSString *requestURL = [RequestURL getRequestURL:OneKeyProductList_URL param:param];
    [WebService postRequest:requestURL param:param JSONModelClass:[NProductListResModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        NProductListResModel *model = responseObject;
                        
                        [_dataArray removeAllObjects];
                        [_dataArray addObjectsFromArray:model.productList];
                        
                        if (_dataArray.count > 0) {
                            NProductModel *productModel = [model.productList objectAtIndex:0];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"FirstID" object:productModel.nproductId];
                        }
                        
                        if (_dataArray.count == 0) {
                            noDataView.hidden = NO;
                        } else {
                            noDataView.hidden = YES;
                        }
                        
                        [npTableview reloadData];
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
}

@end
