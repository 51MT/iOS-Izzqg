//
//  OneFriendsRecordViewController.m
//  Ixyb
//
//  Created by wang on 2017/2/13.
//  Copyright © 2017年 xyb. All rights reserved.
//
#import "Utility.h"
#import "WebService.h"
#import "OneFriendsRecordViewController.h"
#import "NoDataView.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "OneFriendRecordModel.h"

@interface OneFriendsRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NoDataView * noDataView;
    NSMutableArray * dataArray;
    int currentPage;
}
@property(nonatomic,strong)XYTableView * mainTable;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UILabel * investmentLabel;

@end

@implementation OneFriendsRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self initTableView];
    [self setTheRequest];
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setNav {
    
    [self.view bringSubviewToFront:self.navBar];
    if (self.recodeType == oneRecord) {
            self.navItem.title = XYBString(@"one_Friends_Record", @"1级好友出借记录");
    }else if(self.recodeType == twoRecord)
    {
            self.navItem.title = XYBString(@"two_Friends_Record", @"2级好友出借记录");
    }
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initTableView {
    dataArray = [NSMutableArray array];
    self.mainTable = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.mainTable.backgroundColor = COLOR_BG;
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.showsHorizontalScrollIndicator = NO;
    self.mainTable.showsVerticalScrollIndicator = NO;
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.mainTable registerClass:[RewardAmountCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.mainTable];
    
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 80)];
    headerView.backgroundColor = COLOR_MAIN;

    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = self.namePhone;
    self.nameLabel.font = TEXT_FONT_16;
    self.nameLabel.textColor = COLOR_COMMON_WHITE;
    [headerView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.centerY.equalTo(headerView.mas_centerY).offset(-9);
    }];
    
    self.investmentLabel = [[UILabel alloc]init];
    float totalAmount = [self.investMoney floatValue];
    if (totalAmount == 0.00) {
    self.investmentLabel.text =  [NSString stringWithFormat:XYBString(@"cumulative_Investment_Money_Yuan", @"累计出借金额%@元"), @"0.00"];
    }else
    {
    self.investmentLabel.text = [NSString stringWithFormat:XYBString(@"cumulative_Investment_Money_Yuan", @"累计出借总额%@元"),  [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", totalAmount]]];
    }
    self.investmentLabel.font = TEXT_FONT_12;
    self.investmentLabel.textColor = COLOR_COMMON_WHITE;
    [headerView addSubview:self.investmentLabel];
    [self.investmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.centerY.equalTo(headerView.mas_centerY).offset(9);
    }];
    if (totalAmount < 1) {
        [self.view addSubview:headerView];
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navBar.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@80);
        }];
    }else
    {
        self.mainTable.tableHeaderView = headerView;
    }
    
    noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    noDataView.hidden = YES;
    noDataView.titleLab.text = XYBString(@"friends_investment_product", @"该好友暂无出借任何产品");
    [self.view addSubview:noDataView];
    
    [self.view sendSubviewToBack:noDataView];
    
    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom).offset(80.f);
    }];
}



#pragma mark-- tableView delegate method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewHeadDate = [[UIView alloc] init];
    viewHeadDate.backgroundColor = COLOR_BG;
    UILabel *HeadDateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    HeadDateLab.text = XYBString(@"invenst_cp", @"出借产品");
    HeadDateLab.textColor = COLOR_AUXILIARY_GREY;
    HeadDateLab.font = TEXT_FONT_12;
    [viewHeadDate addSubview:HeadDateLab];
    [HeadDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewHeadDate.mas_centerY);
        make.left.equalTo(@(Margin_Left));
    }];
    
    UILabel *InvenstMoneyLab = [[UILabel alloc] initWithFrame:CGRectZero];
    InvenstMoneyLab.text = XYBString(@"invenst_je", @"出借金额");
    InvenstMoneyLab.textColor = COLOR_AUXILIARY_GREY;
    InvenstMoneyLab.font = TEXT_FONT_12;
    [viewHeadDate addSubview:InvenstMoneyLab];
    [InvenstMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewHeadDate.mas_centerY);
        make.right.equalTo(@(-Margin_Right));
    }];
    
    [XYCellLine initWithTopLineAtSuperView:viewHeadDate];
    [XYCellLine initWithBottomLineAtSuperView:viewHeadDate];
    if (dataArray.count == 0) {
        viewHeadDate.hidden = YES;
    }
    return viewHeadDate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [XYCellLine initWithBottomLine_2_AtSuperView:cell.contentView];
    
    if ([cell.contentView viewWithTag:1000]) {
        [[cell.contentView viewWithTag:1000] removeFromSuperview];
    }
    
    if (indexPath.row == dataArray.count - 1) {
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = COLOR_LINE;
        bottomLine.tag = 1000;
        [cell.contentView addSubview:bottomLine];
        
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(cell.contentView);
            make.height.equalTo(@(Line_Height));
        }];
    }
    
    OrderListModel *recommend;
    if (dataArray.count > 0) {
        recommend = dataArray[indexPath.row];
    }
    
    

    
    UILabel *createdDateLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:createdDateLabel];
    createdDateLabel.text = recommend.orderDate;
    createdDateLabel.font = TEXT_FONT_12;
    createdDateLabel.textColor = COLOR_AUXILIARY_GREY;
    createdDateLabel.textAlignment = NSTextAlignmentLeft;
    createdDateLabel.numberOfLines = 1;
    [createdDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Left);
        make.bottom.equalTo(cell.mas_bottom).offset(-13);
    }];
    
    UILabel *recomendCntLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:recomendCntLabel];
    CGFloat icStr = [recommend.orderAmount floatValue];
    if (icStr == 0) {
        recomendCntLabel.text = @"0.00";
    } else {
        recomendCntLabel.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", icStr]];
    }
    recomendCntLabel.textColor = COLOR_MAIN_GREY;
    recomendCntLabel.textAlignment = NSTextAlignmentRight;
    recomendCntLabel.numberOfLines = 1;
    recomendCntLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    recomendCntLabel.font = TEXT_FONT_14;
    [recomendCntLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(cell.mas_centerY);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:nameLabel];
    nameLabel.text = recommend.projectName;
    nameLabel.font = TEXT_FONT_14;
    nameLabel.textColor = COLOR_MAIN_GREY;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.numberOfLines = 1;
    nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Left);
        make.right.equalTo(recomendCntLabel.mas_left).offset(-Margin_Right);
        make.top.equalTo(@13);
    }];
    
    return cell;
}


- (void)setTheRequest {
    NSDictionary *contentDic = @{
                                 @"pageSize" : PageSize,
                                 @"page" : [NSNumber numberWithInt:currentPage],
                                 @"userId" : [UserDefaultsUtil getUser].userId,
                                 @"investorId":self.investId
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
    [dataArray removeAllObjects];
    [self setTheRequest];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [_mainTable.header endRefreshing];
}

- (void)footerRereshing {
    
    if (currentPage * 20 > dataArray.count) {
        
        [_mainTable.footer noticeNoMoreData];
        
    } else {
        
        [self setTheRequest];
        [_mainTable.footer endRefreshing];
    }
}

/****************************一级好友出借记录**********************************/
- (void)callRewardAccountWebService:(NSDictionary *)dictionary {
    
    [self showDataLoading];
    NSString *urlPath = [RequestURL getRequestURL:UserInvestDetailtURL param:dictionary];
    [WebService postRequest:urlPath param:dictionary JSONModelClass:[OneFriendRecordModel class]
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self hideLoading];
                        OneFriendRecordModel *reward = responseObject;
                        if (reward.resultCode == 1) {
                            float totalAmount = [reward.totalAmount floatValue];
                            if (totalAmount == 0) {
                                self.investmentLabel.text =  [NSString stringWithFormat:XYBString(@"cumulative_Investment_Money_Yuan", @"累计出借金额%@元"), @"0.00"];
                            }else
                            {
                                self.investmentLabel.text = [NSString stringWithFormat:XYBString(@"cumulative_Investment_Money_Yuan", @"累计出借总额%@元"),  [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", totalAmount]]];
                            }
                            NSArray *detailsArr = reward.orderList;
                            [dataArray addObjectsFromArray:detailsArr];
                            [_mainTable reloadData];
                            if (dataArray.count == 0) {
                                
                                noDataView.hidden = NO;
                                _mainTable.hidden = YES;
                                _mainTable.footer.hidden = YES;
                            } else {
                                noDataView.hidden = YES;
                                _mainTable.hidden = NO;
                                if (currentPage * 20 > dataArray.count) {
                                    [_mainTable.footer noticeNoMoreData];
                                    
                                } else {
                                    
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
