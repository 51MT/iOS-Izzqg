//
//  HbOverDueView.m
//  Ixyb
//
//  Created by wang on 2017/2/15.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "HbOverDueView.h"

@implementation HbOverDueView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        [self initTableView];
         self.dataArray = [NSMutableArray arrayWithCapacity:20];
        currentPage = 0;
        [self initUI];
        [self initTableView];
        [self setupRefresh];
    }
    return self;
}


- (void)initUI {
    [self initTableView];
}

- (void)initTableView {
    self.tableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = COLOR_BG;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SleepRewardAccountCell class] forCellReuseIdentifier:@"sleepRewardAccountCell"];
    [self addSubview:self.tableView];
    
    [self.tableView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(@-60);
    }];
    
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 390)];
    headView.backgroundColor = COLOR_COMMON_WHITE;
    self.headView = headView;
    self.tableView.tableHeaderView = headView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = XYBString(@"string_discount", @"每投200元送1元");
    titleLabel.textColor = COLOR_MAIN_GREY;
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    titleLabel.tag = VIEW_TAG_TITLE_LABEL;
    titleLabel.hidden = YES; //先隐藏这个提示
    [self.headView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.centerX.equalTo(@0);
    }];
    
    CGFloat circleProgressWidth = 204;
    HomeCircleProgressView *circleProgress = [[HomeCircleProgressView alloc] initWithFrame:CGRectMake(20, 5, circleProgressWidth, circleProgressWidth)];
    circleProgress.tag = VIEW_TAG_PROGRES_VIEW;
    [self.headView addSubview:circleProgress];
    
    [circleProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@37);
        make.centerX.equalTo(self.headView.mas_centerX);
        make.height.width.equalTo(@(circleProgressWidth));
    }];
    circleProgress.trackColor = COLOR_LINE;
    circleProgress.progressColor = COLOR_LIGHT_GREEN; //COLOR_STRONG_RED;
    circleProgress.progressWidth = 5.0f;
    [circleProgress setProgress:0.0f animated:NO];
    
    UILabel *tip1Label = [[UILabel alloc] init];
    [self.headView addSubview:tip1Label];
    tip1Label.text = XYBString(@"string_thawing_redenvelope", @"待解冻红包(元)");
    tip1Label.font = TEXT_FONT_14;
    tip1Label.textColor = COLOR_LIGHT_GREY;
    [tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(circleProgress.mas_centerX);
    }];
    
    UILabel *sleepRewordAmountLabel = [[UILabel alloc] init];
    [self.headView addSubview:sleepRewordAmountLabel];
    sleepRewordAmountLabel.text = @"0.00";
    sleepRewordAmountLabel.textColor = COLOR_MAIN_GREY;
    sleepRewordAmountLabel.tag = VIEW_TAG_SLEEP_REWARD_AMOUNT_LABEL;
    sleepRewordAmountLabel.font = [UIFont systemFontOfSize:37.0f];
    [sleepRewordAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(circleProgress.mas_centerX);
        make.baseline.equalTo(circleProgress.mas_centerY);
        make.top.equalTo(tip1Label.mas_bottom).offset(5);
    }];
    
    UIView *splitHView = [[UIView alloc] init];
    splitHView.backgroundColor = COLOR_LINE;
    [self.headView addSubview:splitHView];
    [splitHView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@120);
        make.height.equalTo(@(Line_Height));
        make.centerX.equalTo(@0);
        make.centerY.equalTo(circleProgress.mas_centerY).offset(25);
    }];
    
    UILabel *endTimeLabel = [[UILabel alloc] init];
    [self.headView addSubview:endTimeLabel];
    endTimeLabel.text = XYBString(@"string_endTimeLabel", @"2000-01-01到期");
    endTimeLabel.font = TEXT_FONT_14;
    endTimeLabel.textColor = COLOR_LIGHT_GREY;
    endTimeLabel.tag = VIEW_TAG_END_TIME_LABEL;
    [endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(splitHView.mas_bottom).offset(10);
    }];
    
    XYButton *overAwardButton = [[XYButton alloc] initWithSubordinationButtonTitle:XYBString(@"string_over_sleep_award", @"查看过期红包") isUserInteractionEnabled:YES];
    
    overAwardButton.titleLabel.font = TEXT_FONT_12;
    [overAwardButton addTarget:self action:@selector(clickOverAwardButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:overAwardButton];
    
    [overAwardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(circleProgress.mas_centerX);
        make.top.equalTo(endTimeLabel.mas_bottom).offset(5);
    }];
    
    UIView *splitView = [[UIView alloc] init];
    splitView.backgroundColor = COLOR_LINE;
    [self.headView addSubview:splitView];
    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Line_Height));
        make.centerX.equalTo(@0);
        make.top.equalTo(circleProgress.mas_bottom).offset(Margin_Length);
        make.height.equalTo(@35);
    }];
    
    //左边的
    UILabel *thawSleepRewordAmountLabel = [[UILabel alloc] init];
    thawSleepRewordAmountLabel.text = XYBString(@"string_thawed_zero", @"已解冻0(元)");
    thawSleepRewordAmountLabel.textColor = COLOR_MAIN_GREY;
    thawSleepRewordAmountLabel.font = TEXT_FONT_12;
    thawSleepRewordAmountLabel.tag = VIEW_TAG_THAW_SLEEP_REWORD_AMOUNT_LABEL;
    [self.headView addSubview:thawSleepRewordAmountLabel];
    [thawSleepRewordAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(splitView.mas_centerY);
        make.right.equalTo(splitView.mas_left).offset(-10);
    }];
    
    //右边的
    UILabel *allThawSleepCashAmountLabel = [[UILabel alloc] init];
    allThawSleepCashAmountLabel.text = XYBString(@"string_total_redenvelope", @"红包总金额0(元)");
    allThawSleepCashAmountLabel.textColor = COLOR_MAIN_GREY;
    allThawSleepCashAmountLabel.font = TEXT_FONT_12;
    allThawSleepCashAmountLabel.tag = VIEW_TAG_ALL_THAW_SLEEP_CASH_AMOUNT_LABEL;
    [self.headView addSubview:allThawSleepCashAmountLabel];
    [allThawSleepCashAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(splitView.mas_centerY);
        make.left.equalTo(splitView.mas_left).offset(10);
    }];
    
    ColorButton *button = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0,MainScreenWidth - 30, Cell_Height) Title:XYBString(@"string_thawing", @"立即出借解冻红包") ByGradientType:leftToRight];
    [self.headView addSubview:button];
    [button addTarget:self action:@selector(clickThawButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.width.equalTo(@(MainScreenWidth - 30));
        make.top.equalTo(splitView.mas_bottom).offset(10);
        make.height.equalTo(@45);
    }];
    
    UILabel *tip4Label = [[UILabel alloc] init];
    tip4Label.text = XYBString(@"string_details", @"明细");
    tip4Label.textAlignment = NSTextAlignmentCenter;
    tip4Label.textColor = COLOR_LIGHT_GREY;
    tip4Label.backgroundColor = COLOR_COMMON_WHITE;
    tip4Label.font = [UIFont systemFontOfSize:14.0f];
    [headView addSubview:tip4Label];
    
    [tip4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headView.mas_centerX);
        make.bottom.equalTo(self.headView.mas_bottom);
        make.width.equalTo(@46);
    }];
    
    UIView *bottomSplitView = [[UIView alloc] init];
    bottomSplitView.backgroundColor = COLOR_LINE;
    [self.headView addSubview:bottomSplitView];
    [bottomSplitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tip4Label);
        make.height.equalTo(@(Line_Height));
        make.left.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
    }];
    
    [self.headView bringSubviewToFront:tip4Label];
}

- (void)clickOverAwardButton:(id)sender {
    if (self.clickTheDueVC) {
        self.clickTheDueVC();
    }
}

- (void)clickThawButton:(id)sender {
    if (self.clickTheMoreProductVc) {
        self.clickTheMoreProductVc();
    }
}

- (void)setTheRequest:(NSInteger)currentPageItem {
    
    [self updateSleepReward];
    
    NSDictionary *param = @{ @"userId" : [UserDefaultsUtil getUser].userId,
                             @"pageSize" : PageSize,
                             @"rewardState" : @0,
                             @"page" : [NSNumber numberWithInteger:currentPageItem] };
    
    [self callUpdateSleepRewardWebService:param];
}

#pragma mark - 设置刷新的方法
- (void)setupRefresh {
    self.tableView.header = self.gifHeader3;
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}
- (void)headerRereshing {
    currentPage = 0;
    [_dataArray removeAllObjects];
    [self setTheRequest:currentPage];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [self.tableView.header endRefreshing];
}

- (void)footerRereshing {
    
    if (currentPage * 20 > _dataArray.count) {
        
        [self.tableView.footer noticeNoMoreData];
        
    } else {
        
        [self setTheRequest:currentPage];
        [self.tableView.footer endRefreshing];
    }
}



- (void)callUpdateSleepRewardWebService:(NSDictionary *) param{
    [self showDataLoading];
    NSString *urlPath = [RequestURL getRequestURL:UserAccountGetSleepRewardAccountDetailURL param:param];
    [WebService postRequest:urlPath param:param JSONModelClass:[SleepRewardAccountModel class]
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self hideLoading];
                        SleepRewardAccountModel *sleepReward = responseObject;
                        if (sleepReward.resultCode == 1) {
                            NSArray *detailsArr = sleepReward.sleepRewardAccountDetailList;
                            [self.dataArray addObjectsFromArray:detailsArr];
                            [self.tableView reloadData];
                            if (currentPage * 20 > _dataArray.count) {
                                self.tableView.footer.hidden = YES;
                                [ self.tableView.footer noticeNoMoreData];
                                
                            } else {
                                self.tableView.footer.hidden = NO;
                                [ self.tableView.footer resetNoMoreData];
                            }
                            
                        }
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
    currentPage ++ ;
}

- (void)updateSleepReward {
    
    NSDictionary *param = @{
                            @"userId" : [UserDefaultsUtil getUser].userId,
                            };
    
    [self showDataLoading];
    NSString *urlPath = [RequestURL getRequestURL:UserAccountGetSleepRewardAccountURL param:param];
    [WebService postRequest:urlPath param:param JSONModelClass:[SleepRewordAmountModel class]
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self hideLoading];
                        SleepRewordAmountModel *sleepReward = responseObject;
                        if (sleepReward.resultCode == 1) {
                            
                            double sleepRewardAmt = [sleepReward.sleepRewordAmount.sleepRewordAmount doubleValue];
                            double thawSleepRewardAmt = [sleepReward.sleepRewordAmount.thawSleepRewordAmount doubleValue];
                            double allSleepAmt = sleepRewardAmt + thawSleepRewardAmt;
                            
                            // 标题
                            NSString *titleStr = sleepReward.sleepRewordAmount.title;
                            UILabel *titleLabel = (UILabel *) [self.headView viewWithTag:VIEW_TAG_TITLE_LABEL];
                            titleLabel.text = titleStr;
                            
                            //待解冻红包总额
                            NSString *sleepRewordAmountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", sleepRewardAmt]];
                            UILabel *sleepRewardAmountLabel = (UILabel *) [self.headView viewWithTag:VIEW_TAG_SLEEP_REWARD_AMOUNT_LABEL];
                            if (sleepRewardAmt == 0) {
                                sleepRewardAmountLabel.text = @"0.00";
                            } else {
                                sleepRewardAmountLabel.text = sleepRewordAmountStr;
                            }
                            
                            //全解冻所需出借
                            NSString *allThawSleepCashAmountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", allSleepAmt]];
                            if (allSleepAmt == 0) {
                                allThawSleepCashAmountStr = @"0.00";
                            }
                            NSString *strAll = [NSString stringWithFormat:XYBString(@"str_total_redenvelope", @"红包总金额%@(元)"), allThawSleepCashAmountStr];
                            UILabel *allThawSleepCashAmountLabel = (UILabel *) [self.headView viewWithTag:VIEW_TAG_ALL_THAW_SLEEP_CASH_AMOUNT_LABEL];
                            allThawSleepCashAmountLabel.text = strAll;
                            
                            //已解冻红包总额
                            NSString *thawSleepRewordAmountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", thawSleepRewardAmt]];
                            if (thawSleepRewardAmt == 0) {
                                thawSleepRewordAmountStr = @"0.00";
                            }
                            NSString *strHasThaw = [NSString stringWithFormat:XYBString(@"str_thawed_y", @"已解冻%@(元)"), thawSleepRewordAmountStr];
                            
                            UILabel *thawSleepRewordAmountLabel = (UILabel *) [self.headView viewWithTag:VIEW_TAG_THAW_SLEEP_REWORD_AMOUNT_LABEL];
                            
                            thawSleepRewordAmountLabel.text = strHasThaw;
                            
                            //过期时间
                            NSString *dateStr = sleepReward.sleepRewordAmount.sleepRewardDuetime;
                            if (dateStr.length <= 0) {
                                dateStr = @"--";
                            } else {
                                dateStr = [NSString stringWithFormat:XYBString(@"str_end_time", @"%@到期"), dateStr];
                            }
                            UILabel *endTimeLabel = (UILabel *) [self.headView viewWithTag:VIEW_TAG_END_TIME_LABEL];
                            endTimeLabel.text = dateStr;
                            
                            CGFloat freezeProgress = [sleepReward.sleepRewordAmount.freezeProgress doubleValue];
                            HomeCircleProgressView *circleProgress = (HomeCircleProgressView *) [self.headView viewWithTag:VIEW_TAG_PROGRES_VIEW];
                            circleProgress.progress = freezeProgress;
                        }
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];;
                           [self showPromptTip:errorMessage];
                       }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Double_Cell_Height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SleepRewardAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sleepRewardAccountCell"
                                                                   forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SleepRewardAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sleepRewardAccountCell"];
    }
    cell.isBeoverdue = YES;
    if (self.dataArray.count > 0) {
        SleepRewardAccountDetailListModel *detail = self.dataArray[indexPath.row];
        cell.model = detail;
    }
    return cell;
}


@end
