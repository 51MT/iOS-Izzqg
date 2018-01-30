//
//  ReturnRecordViewController.m
//  Ixyb
//
//  Created by wang on 2017/3/8.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ReturnRecordViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "RecommendCommmissionModel.h"
#define CELL_HEIGHT 60.f
@interface ReturnRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
        int currentPage;
}
@end

@implementation ReturnRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray arrayWithCapacity:20];
    [self initUI];
    [self setNav];
    [self headerRereshing];
    [self setupRefresh];
}
- (void)setNav {
    self.navItem.title = XYBString(@"return_record", @"返佣记录");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initUI {
    self.noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    self.noDataView.hidden = YES;
    [self.view addSubview:self.noDataView];
    
    [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(32);
        make.centerX.equalTo(self.view);
    }];
    
    self.tableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = COLOR_MYUNION_SECTIONHEADER;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
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
    
    if (indexPath.row == self.dataArray.count - 1) {
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = COLOR_LINE;
        bottomLine.tag = 1000;
        [cell.contentView addSubview:bottomLine];
        
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(cell.contentView);
            make.height.equalTo(@(Line_Height));
        }];
    }
    
    CommissionList *recommend;
    if (self.dataArray.count > 0) {
        recommend = self.dataArray[indexPath.row];
    }
    
    UILabel *yingjiLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:yingjiLabel];
    NSString *yingjiAmount = [Utility
                              replaceTheNumberForNSNumberFormatter:
                              [NSString
                               stringWithFormat:@"%.2f", [recommend.interest doubleValue]]];
    yingjiLabel.text = yingjiAmount;
    yingjiLabel.font = TEXT_FONT_14;
    yingjiLabel.textColor = COLOR_MAIN_GREY;
    yingjiLabel.textAlignment = NSTextAlignmentLeft;
    yingjiLabel.numberOfLines = 1;
    yingjiLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [yingjiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Left);
        make.top.equalTo(@10);
    }];
    
    UILabel *yingjiTipLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:yingjiTipLabel];
    yingjiTipLabel.text = XYBString(@"accrued_return_money", @"返佣金额");
    yingjiTipLabel.font = TEXT_FONT_14;
    yingjiTipLabel.textColor = COLOR_AUXILIARY_GREY;
    yingjiTipLabel.textAlignment = NSTextAlignmentLeft;
    yingjiTipLabel.numberOfLines = 1;
    [yingjiTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yingjiLabel.mas_left);
        make.bottom.equalTo(cell.mas_bottom).offset(-10);
    }];
    
    
    UILabel *timerLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:timerLabel];
    timerLabel.text = [NSString stringWithFormat:XYBString(@"release_time", @"发放时间%@"),recommend.actionDate];
    timerLabel.font = TEXT_FONT_14;
    timerLabel.textColor = COLOR_MAIN_GREY;
    timerLabel.textAlignment = NSTextAlignmentLeft;
    timerLabel.numberOfLines = 1;
    [timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yingjiLabel.mas_top);
        make.right.equalTo(@(-Margin_Right));
    }];

    UILabel *cycleLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:cycleLabel];
    cycleLabel.font = TEXT_FONT_14;
    cycleLabel.textColor = COLOR_AUXILIARY_GREY;
    cycleLabel.textAlignment = NSTextAlignmentLeft;
    cycleLabel.text = [NSString stringWithFormat:XYBString(@"settlement_cycle", @"结算周期%@"),recommend.closedCycle];
    [cycleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yingjiTipLabel.mas_top);
        make.right.equalTo(cell.mas_right).offset(-Margin_Right);
    }];
    
    return cell;
}


#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    self.tableView.header = self.gifHeader3;
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (void)headerRereshing {
    [self.dataArray removeAllObjects];
    currentPage = 0;
    [self requestRecommendCommissionWebService];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [self.tableView.header endRefreshing];
}

- (void)footerRereshing {
    if (currentPage * 20 > self.dataArray.count) {
        [self.tableView.footer noticeNoMoreData];
        
    } else {
        [self requestRecommendCommissionWebService];
        
        [self.tableView.footer endRefreshing];
    }
}

- (void)requestRecommendCommissionWebService {
    NSDictionary *param = @{
                            @"userId" : [UserDefaultsUtil getUser].userId,
                            @"page" : [NSNumber numberWithInteger:currentPage],
                            @"pageSize" : PageSize,
                            };
    NSString *requestURL = [RequestURL getRequestURL:RecommendCommissionURL param:param];
    [self showDataLoading];
    [WebService postRequest:requestURL param:param JSONModelClass:[RecommendCommmissionModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        
        RecommendCommmissionModel *responseModel = responseObject;
        if (responseModel.resultCode == 1) {
            NSArray *scArr = responseModel.commissionList;
            [self.dataArray addObjectsFromArray:scArr];
            [self.tableView reloadData];
            if (self.dataArray.count == 0) {
                self.tableView.hidden = YES;
                self.noDataView.hidden = NO;
                self.tableView.footer.hidden = YES;
            } else {
                self.tableView.hidden = NO;
                self.noDataView.hidden = YES;
                if (currentPage * 20 > self.dataArray.count) {
                    [self.tableView.footer noticeNoMoreData];
                } else {
                    [self.tableView.footer resetNoMoreData];
                }
            }
        }
        
    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
    currentPage++;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
