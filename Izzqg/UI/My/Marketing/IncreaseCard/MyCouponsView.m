//
//  MyCouponsView.m
//  Ixyb
//
//  Created by wang on 2017/2/15.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "MyCouponsView.h"

@implementation MyCouponsView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        [self initTableView];
        currentPage = 0;
        [self initTableView];
        self.dataArray = [[NSMutableArray alloc] init];
        
        [self setupRefresh];
        [self showDataLoading];
    }
    return self;
}

- (void)initTableView {
    self.mainTable = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.backgroundColor = COLOR_BG;
    [self.mainTable registerClass:[IncreaseCardCell class] forCellReuseIdentifier:@"cell"];
    self.mainTable.header = self.gifHeader3;
    self.mainTable.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [self.mainTable.footer noticeNoMoreData];
    self.mainTable.footer.hidden = YES;
    [self addSubview:self.mainTable];
    
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(@-60);
    }];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    bgView.userInteractionEnabled = YES;
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIImageView *notDataImageView = [[UIImageView alloc] init];
    notDataImageView.image = [UIImage imageNamed:@"noDataImage"];
    [bgView addSubview:notDataImageView];
    [notDataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@50);
        make.centerX.equalTo(bgView.mas_centerX);
    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    [bgView addSubview:tipLabel];
    tipLabel.text = XYBString(@"str_increase_null_card", @"您还没有可用的优惠券");
    tipLabel.font = TEXT_FONT_14;
    tipLabel.textColor = COLOR_LIGHT_GREY;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(notDataImageView.mas_bottom).offset(Margin_Top);
        make.left.equalTo(@Margin_Length);
        make.width.equalTo(@(MainScreenWidth - 20));
    }];
    
    self.bgViewSeeInvalidCardButton = [[XYButton alloc] initWithSubordinationButtonTitle:XYBString(@"str_check_lose_effic_increase_card", @"查看已失效优惠券>>") isUserInteractionEnabled:YES];
    [bgView addSubview:self.bgViewSeeInvalidCardButton];
    self.bgViewSeeInvalidCardButton.titleLabel.font = TEXT_FONT_12;
    
    [self.bgViewSeeInvalidCardButton addTarget:self action:@selector(clickSeeInvalidCardButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgViewSeeInvalidCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(30);
        make.centerX.equalTo(@0);
    }];
    
    self.mainTable.backgroundView.hidden = YES;
    bgView.hidden = YES;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 50)];
    self.mainTable.tableFooterView = footView;
    self.mainTable.tableFooterView.hidden = YES;
    self.seeInvalidCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [footView addSubview:self.seeInvalidCardButton];
    self.seeInvalidCardButton.titleLabel.font = TEXT_FONT_12;
    [self.seeInvalidCardButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [self.seeInvalidCardButton setBackgroundColor:COLOR_COMMON_CLEAR];
    [self.seeInvalidCardButton setTitle:XYBString(@"str_check_lose_effic_increase_card", @"查看已失效优惠券>>") forState:UIControlStateNormal];
    [self.seeInvalidCardButton addTarget:self action:@selector(clickSeeInvalidCardButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.seeInvalidCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0);
    }];
}

- (void)clickSeeInvalidCardButton:(id)sender {
    if (self.clickTheFailedVC) {
        self.clickTheFailedVC();
    }
}

- (void)increaseCardCell:(IncreaseCardCell *)cell didClickIndex:(NSInteger)index {
    if (self.clickTheMoreProductVc) {
        self.clickTheMoreProductVc();
    }
}



#pragma mark-- tableView delegate method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 134;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IncreaseCardCell *cell = (IncreaseCardCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[IncreaseCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.index = indexPath.row;
    cell.delegate = self;
    if (self.dataArray.count > 0) {
        cell.increaseCardModel = self.dataArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];;
}

- (void)setTheRequest:(NSInteger)currentPageItem {
    
    NSDictionary *contentDic = @{ @"pageSize" : PageSize,
                                  @"page" : [NSNumber numberWithInteger:currentPageItem],
                                  @"state" : @0, //0: 未过期，1：已过期
                                  @"userId" : [UserDefaultsUtil getUser].userId };
    
    [self callRewardAccountWebService:contentDic];
}

#pragma mark - 设置刷新的方法
- (void)setupRefresh {
    _mainTable.header = self.gifHeader3;
    _mainTable.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (void)headerRereshing {
    currentPage = 0;
    [self.dataArray removeAllObjects];
    [self setTheRequest:currentPage];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [_mainTable.header endRefreshing];
}

- (void)footerRereshing {
    
    if (currentPage * 20 > self.dataArray.count) {
        
        [_mainTable.footer noticeNoMoreData];
        
    } else {
        
        [self setTheRequest:currentPage];
        [_mainTable.footer endRefreshing];
    }
}

/****************************我的优惠劵**********************************/
- (void)callRewardAccountWebService:(NSDictionary *)dictionary {
    
    [self showDataLoading];
    NSString *urlPath = [RequestURL getRequestURL:UserIncreaseCardURL param:dictionary];
    [WebService postRequest:urlPath param:dictionary JSONModelClass:[IncreaseCardModel class]
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self hideLoading];
                        IncreaseCardModel *IncreaseCard = responseObject;
                        if (IncreaseCard.resultCode == 1) {
                            
                            NSArray *detailsArr = IncreaseCard.cards;
                            [self.dataArray addObjectsFromArray:detailsArr];
                            [_mainTable reloadData];
                            
                            if (self.dataArray.count == 0) {
                                
                                bgView.hidden  = NO;
                                _mainTable.footer.hidden = YES;
                                _mainTable.tableFooterView.hidden = YES;
                            } else {
                                
                                if ([IncreaseCard.overdueCards intValue] < 1) {
                                    self.bgViewSeeInvalidCardButton.hidden = YES;
                                    self.mainTable.tableFooterView.hidden = YES;
                                    
                                } else {
                                    
                                    self.bgViewSeeInvalidCardButton.hidden = NO;
                                    self.mainTable.tableFooterView.hidden = NO;
                                }
                                
                                bgView.hidden  = YES;
                                if (currentPage * 20 > self.dataArray.count) {
                                    
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
                           [_mainTable reloadData];
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }
     
     ];
    currentPage++;
}

@end
