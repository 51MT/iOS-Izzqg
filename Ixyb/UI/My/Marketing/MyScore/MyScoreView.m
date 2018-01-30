//
//  MyScoreView.m
//  Ixyb
//
//  Created by wang on 2017/2/15.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "MyScoreView.h"

@implementation MyScoreView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        [self creatTheNodataView];
        self.dataArray = [[NSMutableArray alloc]init];
        [self creatTheMainTable];
        currentPage = 0;
        [self setupRefresh];
    }
    return self;
}


- (void)creatTheNodataView {
    
    noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    noDataView.hidden = YES;
    [self addSubview:noDataView];
    
    [self sendSubviewToBack:noDataView];
    
    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)creatTheMainTable {
    
    mainTable = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    mainTable.backgroundColor = COLOR_BG;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.showsHorizontalScrollIndicator = NO;
    mainTable.showsVerticalScrollIndicator = NO;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [mainTable registerClass:[MyScoreCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:mainTable];
    
    [mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(@-60);
    }];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenWidth > 330 ? 210 : 140)];
    headerView.backgroundColor = COLOR_COMMON_WHITE;
    mainTable.tableHeaderView = headerView;
    
    UIImageView *backImage = [[UIImageView alloc] init];
    backImage.backgroundColor = COLOR_MAIN;
    backImage.layer.masksToBounds = YES;
    backImage.layer.cornerRadius = MainScreenWidth > 330 ? 65 : 45;
    [headerView addSubview:backImage];
    if (MainScreenWidth > 330) {
        [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(headerView.mas_centerX);
            make.top.equalTo(@36);
            make.width.height.equalTo(@130);
        }];
    } else {
        [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(headerView.mas_centerX);
            make.top.equalTo(@24);
            make.width.height.equalTo(@90);
        }];
    }
    
    scoreLab = [[UILabel alloc] init];
    if (IS_IPHONE_5_OR_LESS) {
        scoreLab.font = [UIFont systemFontOfSize:20.f];
    } else {
        scoreLab.font = [UIFont systemFontOfSize:30.f];
    }
    scoreLab.textAlignment = NSTextAlignmentCenter;
    scoreLab.textColor = COLOR_COMMON_WHITE;
    scoreLab.adjustsFontSizeToFitWidth = YES;
    scoreLab.text = @"0";
    [backImage addSubview:scoreLab];
    
    [scoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImage.mas_centerX);
        make.centerY.equalTo(backImage.mas_centerY).offset(-5);
        make.left.equalTo(backImage.mas_left).offset(2);
        make.right.equalTo(backImage.mas_right).offset(-2);
    }];
    
    UILabel *scoreTitleLab = [[UILabel alloc] init];
    scoreTitleLab.text = XYBString(@"str_score", @"积分");
    scoreTitleLab.font = TEXT_FONT_14;
    scoreTitleLab.textColor = COLOR_COMMON_WHITE;
    [backImage addSubview:scoreTitleLab];
    [scoreTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scoreLab.mas_bottom).offset(1);
        make.centerX.equalTo(backImage.mas_centerX);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = COLOR_LINE;
    [headerView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.left.equalTo(@0);
        make.bottom.equalTo(headerView.mas_bottom).offset(-7);
        make.height.equalTo(@(Line_Height));
    }];
    
    UILabel *detailLab = [[UILabel alloc] init];
    detailLab.backgroundColor = COLOR_COMMON_WHITE;
    detailLab.text = XYBString(@"str_score_detail", @"明细");
    detailLab.textColor = COLOR_LIGHT_GREY;
    detailLab.textAlignment = NSTextAlignmentCenter;
    detailLab.font = TEXT_FONT_14;
    [headerView addSubview:detailLab];
    
    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerView.mas_bottom).offset(0);
        make.centerX.equalTo(headerView.mas_centerX);
        make.width.equalTo(@80);
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Double_Cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1f;
    }
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *myView = [[UIView alloc] init];
    myView.backgroundColor = COLOR_COMMON_CLEAR;
    return myView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                        forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MyScoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataArray.count > 0) {
        cell.scoreDetail = _dataArray[indexPath.row];
        //        if (scoreArr.count == indexPath.row + 1) {
        //             [XYCellLine initWithBottomAtIndexPath:indexPath addSuperView:cell.contentView];
        //        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 设置刷新的方法
- (void)setupRefresh {
    
    mainTable.header = self.gifHeader3;
    mainTable.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (void)headerRereshing {
    [_dataArray removeAllObjects];
    currentPage = 0;
    [self setTheRequest:currentPage];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [mainTable.header endRefreshing];
}
- (void)footerRereshing {
    
    if (currentPage * 20 > _dataArray.count) {
        [mainTable.footer noticeNoMoreData];
        
    } else {
        
        [self setTheRequest:currentPage];
        [mainTable.footer endRefreshing];
    }
}

- (void)setTheRequest:(NSInteger)currentPageItem {
    
    NSDictionary *contentDic = @{@"page" : [NSNumber numberWithInt:currentPageItem],
                                 @"pageSize" : PageSize,
                                 @"userId" : [UserDefaultsUtil getUser].userId };
    
    [self callUserScoreWebService:contentDic];
}

- (void)callUserScoreWebService:(NSDictionary *)dictionary {
    [self showDataLoading];
    NSString *urlPath = [RequestURL getRequestURL:UserScoreURL param:dictionary];
    
    [WebService postRequest:urlPath param:dictionary JSONModelClass:[ScoreDetail class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self hideLoading];
                        ScoreDetail *score = responseObject;
                        if (score.resultCode == 1) {
                            scoreLab.text = [NSString stringWithFormat:@"%@", score.totalScore];
                            NSArray *scArr = score.scoreDetail;
                            [_dataArray addObjectsFromArray:scArr];
                            [mainTable reloadData];
                            if (_dataArray.count == 0) {
                                mainTable.hidden = YES;
                                noDataView.hidden = NO;
                                mainTable.footer.hidden = YES;
                            } else {
                                noDataView.hidden = YES;
                                if (currentPage * 20 > _dataArray.count) {
                                    
                                    mainTable.footer.hidden = YES;
                                    [mainTable.footer noticeNoMoreData];
                                    
                                } else {
                                    mainTable.footer.hidden = NO;
                                    [mainTable.footer resetNoMoreData];
                                }
                            }
                        }
                        
                    }
     
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }
     
     ];
    
    currentPage++;
}

@end
