//
//  RewardAmountView.m
//  Ixyb
//
//  Created by wang on 2017/2/15.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "RewardAmountView.h"


@implementation RewardAmountView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        [self initTableView];
        _dataArray = [[NSMutableArray alloc] init];
        currentPage = 0;
        [self creatTheNodataView];
        [self initTableView];
        [self setupRefresh];
    }
    return self;
}

- (void)initTableView {
    
    self.mainTable = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.mainTable.backgroundColor = COLOR_BG;
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.showsHorizontalScrollIndicator = NO;
    self.mainTable.showsVerticalScrollIndicator = NO;
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainTable registerClass:[RewardAmountCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:self.mainTable];
    
    [self.mainTable  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(@-60);
    }];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 246)];
    
    headerView.backgroundColor = COLOR_COMMON_WHITE;
    self.mainTable.tableHeaderView = headerView;
    
    UIImageView *backImage = [[UIImageView alloc] init];
    backImage.backgroundColor = COLOR_LIGHT_GREEN;
    backImage.layer.masksToBounds = YES;
    backImage.layer.cornerRadius = 65;
    
    [headerView addSubview:backImage];
    
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.equalTo(@30);
        make.width.height.equalTo(@130);
    }];
    
    self.scoreLab = [[UILabel alloc] init];
    if (IS_IPHONE_5_OR_LESS) {
        self.scoreLab.font = TEXT_FONT_26;
    } else {
        self.scoreLab.font = FONT_TEXT_LARGE_MORE;
    }
    self.scoreLab.textAlignment = NSTextAlignmentCenter;
    self.scoreLab.textColor = COLOR_COMMON_WHITE;
    self.scoreLab.adjustsFontSizeToFitWidth = YES;
    self.scoreLab.text = @"0.00";
    [backImage addSubview:self.scoreLab];
    
    [self.scoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImage.mas_centerX);
        make.baseline.equalTo(backImage.mas_centerY);
        make.left.equalTo(backImage.mas_left).offset(2);
        make.right.equalTo(backImage.mas_right).offset(-2);
    }];
    
    UILabel *scoreTitleLab = [[UILabel alloc] init];
    scoreTitleLab.text = XYBString(@"str_gift", @"礼金(元)");
    scoreTitleLab.font = TEXT_FONT_14;
    scoreTitleLab.textColor = COLOR_COMMON_WHITE;
    [backImage addSubview:scoreTitleLab];
    [scoreTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImage.mas_centerY).offset(10);
        make.centerX.equalTo(backImage.mas_centerX);
    }];
    
    UIView *splitPView = [[UIView alloc] init];
    splitPView.backgroundColor = COLOR_LINE;
    [headerView addSubview:splitPView];
    [splitPView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImage.mas_centerX);
        make.width.equalTo(@(Line_Height));
        make.height.equalTo(@30);
        make.top.equalTo(backImage.mas_bottom).offset(20);
    }];
    
    self.overdueLabel = [[UILabel alloc] init];
    self.overdueLabel.text = XYBString(@"str_gift_day", @"剩余30天过期");
    self.overdueLabel.font = TEXT_FONT_14;
    self.overdueLabel.textColor = COLOR_MAIN_GREY;
    [headerView addSubview:self.overdueLabel];
    [self.overdueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(splitPView.mas_centerY);
        make.right.equalTo(splitPView.mas_left).offset(-10);
    }];
    
    XYButton *overAwardButton = [[XYButton alloc] initWithSubordinationButtonTitle:XYBString(@"str_over_award", @"查看过期礼金") isUserInteractionEnabled:YES];
    [overAwardButton addTarget:self action:@selector(clickOverAwardButton:) forControlEvents:UIControlEventTouchUpInside];
    overAwardButton.titleLabel.font = TEXT_FONT_14;
    [headerView addSubview:overAwardButton];
    [overAwardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(splitPView.mas_centerY);
        make.left.equalTo(splitPView.mas_right).offset(10);
    }];
    
    _tip4Label = [[UILabel alloc] init];
    _tip4Label.text = XYBString(@"str_details", @"明细");
    _tip4Label.textAlignment = NSTextAlignmentCenter;
    _tip4Label.textColor = COLOR_LIGHT_GREY;
    _tip4Label.backgroundColor = COLOR_COMMON_WHITE;
    _tip4Label.font = [UIFont systemFontOfSize:14.0f];
    UIView *splitView = [[UIView alloc] init];
    splitView.backgroundColor = COLOR_LINE;
    [headerView addSubview:splitView];
    [headerView addSubview:_tip4Label];
    
    [_tip4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.bottom.equalTo(headerView.mas_bottom);
        make.width.equalTo(@46);
    }];
    
    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_tip4Label.mas_centerY);
        make.height.equalTo(@(Line_Height));
        make.left.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
    }];
}

- (void)clickOverAwardButton:(id)sender {
    if (self.clickTheOverDueVC) {
        self.clickTheOverDueVC();
    }
}

- (void)creatTheNodataView {
    
    noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    noDataView.hidden = YES;
    [self addSubview:noDataView];
    
    [self sendSubviewToBack:noDataView];
    
    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(@120);
    }];
}


#pragma mark-- tableView delegate method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Double_Cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RewardAmountCell *cell = (RewardAmountCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[RewardAmountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataArray.count > 0) {
        cell.rewardAmountModel = self.dataArray[indexPath.row];
        cell.isOverDue = NO;
    }
    
    return cell;
}


- (void)setTheRequest {
    NSDictionary *contentDic = @{
                                 @"pageSize" : PageSize,
                                 @"page" : [NSNumber numberWithInt:currentPage],
                                 @"rewardState" : @0, //0: 未过期，1：已过期
                                 @"userId" : [UserDefaultsUtil getUser].userId
                                 };
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
    [self setTheRequest];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [_mainTable.header endRefreshing];
}

- (void)footerRereshing {
    
    if (currentPage * 20 > self.dataArray.count) {
        
        [_mainTable.footer noticeNoMoreData];
        
    } else {
        
        [self setTheRequest];
        [_mainTable.footer endRefreshing];
    }
}

/****************************礼金账户接口**********************************/
- (void)callRewardAccountWebService:(NSDictionary *)dictionary {
    
    [self showDataLoading];
    NSString *urlPath = [RequestURL getRequestURL:UserAccountGetRewardAccountURL param:dictionary];
    [WebService postRequest:urlPath param:dictionary JSONModelClass:[RewardAmountModel class]
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self hideLoading];
                        RewardAmountModel *reward = responseObject;
                        if (reward.resultCode == 1) {
                            
                            NSString *totalStr = reward.rewardAccount.rewardAmount;
                            if ([totalStr doubleValue] == 0) {
                                self.scoreLab.text = @"0.00";
                            } else {
                                NSString *rewardAmountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [totalStr doubleValue]]];
                                self.scoreLab.text = rewardAmountStr;
                            }
                            NSString *str = [NSString stringWithFormat:XYBString(@"str_gift_lastday", @"剩%@天过期"), reward.rewardAccount.rewardRemainderDay];
                            
                            self.overdueLabel.text = str;
                            
                            NSArray *detailsArr = reward.accountActionList;
                            [self.dataArray addObjectsFromArray:detailsArr];
                            [_mainTable reloadData];
                            if (self.dataArray.count == 0) {
                                noDataView.hidden = NO;
                                _mainTable.tableHeaderView.backgroundColor = COLOR_BG;
                                _mainTable.footer.hidden = YES;
                                _tip4Label.backgroundColor = COLOR_BG;
                            } else {
                                noDataView.hidden = YES;
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
