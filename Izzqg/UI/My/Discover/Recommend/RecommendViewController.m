//
//  GeneralRecommendViewController.m
//  Ixyb
//
//  Created by wang on 15/9/1.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "RecommendViewController.h"

#import "EarnBonus.h"
#import "EarnBonusCell.h"
#import "EarnBonusCodeViewController.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "NoDataView.h"
#import "Utility.h"
#import "WebService.h"
#import "XYTableView.h"

@interface RecommendViewController () {
    XYTableView *mainTable;
    UILabel *recommendLab;
    UILabel *detailLab;
    UIView *headerView;
    MBProgressHUD *hud;

    int currentPage;
    NSMutableArray *dataArr;
}
@end

@implementation RecommendViewController

- (void)setNav {
    self.navItem.title = XYBString(@"commendIncome", @"推荐收益"); // "推荐收益";

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = COLOR_BG;
    [self setNav];
    [self initData];
    [self creatTheMainTable];
    [self setupRefresh];
    [self setRequest];
}

- (void)initData {
    currentPage = 0;
    dataArr = [[NSMutableArray alloc] init];
}

- (void)creatTheMainTable {

    mainTable = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    mainTable.backgroundColor = COLOR_COMMON_CLEAR;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.showsHorizontalScrollIndicator = NO;
    mainTable.showsVerticalScrollIndicator = NO;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [mainTable registerClass:[EarnBonusCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:mainTable];

    [mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];

    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenWidth > 330 ? 210 : 168)];
    mainTable.tableHeaderView = headerView;

    UIImageView *backImage = [[UIImageView alloc] init];
    backImage.backgroundColor = COLOR_MAIN;
    backImage.layer.masksToBounds = YES;
    backImage.layer.cornerRadius = MainScreenWidth > 330 ? 60 : 45;
    [headerView addSubview:backImage];
    if (MainScreenWidth > 330) {
        [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(headerView.mas_centerX);
            make.top.equalTo(@36);
            make.width.height.equalTo(@120);
        }];
    } else {
        [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(headerView.mas_centerX);
            make.top.equalTo(@24);
            make.width.height.equalTo(@90);
        }];
    }

    recommendLab = [[UILabel alloc] init];
    recommendLab.font = [UIFont systemFontOfSize:30.f];
    recommendLab.textAlignment = NSTextAlignmentCenter;
    recommendLab.textColor = COLOR_COMMON_WHITE;
    recommendLab.text = @"0";
    [backImage addSubview:recommendLab];

    [recommendLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImage.mas_centerX);
        make.centerY.equalTo(backImage.mas_centerY).offset(-5);
        make.width.equalTo(backImage.mas_width);
    }];

    UILabel *scoreTitleLab = [[UILabel alloc] init];
    scoreTitleLab.text = XYBString(@"string_got_award_yuan", @"已获礼金(元)");
    scoreTitleLab.font = ADDAMOUNT_FONT;
    scoreTitleLab.textColor = COLOR_COMMON_WHITE;
    [backImage addSubview:scoreTitleLab];
    [scoreTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(recommendLab.mas_bottom).offset(1);
        make.centerX.equalTo(backImage.mas_centerX);
    }];

    detailLab = [[UILabel alloc] init];
    detailLab.backgroundColor = COLOR_COMMON_CLEAR;
    detailLab.text = XYBString(@"string_invite_zero_friend", @"已推荐0位好友");
    detailLab.textColor = COLOR_MAIN_GREY;
    detailLab.textAlignment = NSTextAlignmentCenter;
    detailLab.font = TEXT_FONT_16;
    [headerView addSubview:detailLab];

    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImage.mas_bottom).offset(15);
        make.centerX.equalTo(headerView.mas_centerX);
    }];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = COLOR_LINE;
    [headerView addSubview:lineView];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(-2.5);
        make.centerX.equalTo(headerView.mas_centerX);
        make.left.equalTo(@0);
        make.height.equalTo(@(Line_Height));
    }];

    UILabel *detailedLab = [[UILabel alloc] init];
    detailedLab.backgroundColor = COLOR_BG;
    detailedLab.text = XYBString(@"str_details", @"明细");
    detailedLab.textColor = COLOR_LIGHT_GREY;
    detailedLab.textAlignment = NSTextAlignmentCenter;
    detailedLab.font = TEXT_FONT_14;
    [headerView addSubview:detailedLab];

    [detailedLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView.mas_centerY);
        make.centerX.equalTo(headerView.mas_centerX);
        make.width.equalTo(@33);
    }];
}

#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return dataArr.count;
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

    EarnBonusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                          forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[EarnBonusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (dataArr.count > 0) {
        cell.earnBonus = dataArr[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 设置刷新的方法
- (void)setupRefresh {
    mainTable.header = self.gifHeader3;
    mainTable.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (void)headerRereshing {
    [dataArr removeAllObjects];
    currentPage = 0;
    [self setRequest];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [mainTable.header endRefreshing];
}

- (void)footerRereshing {

    if (currentPage * 20 > dataArr.count) {
        [mainTable.footer noticeNoMoreData];

    } else {

        [self setRequest];
        [mainTable.footer endRefreshing];
    }
}

- (void)setRequest {
    NSDictionary *contentDic = @{
        @"page" : [NSNumber numberWithInt:currentPage],
        @"pageSize" : PageSize,
        @"userId" : [UserDefaultsUtil getUser].userId
    };
    [self callEarnBonusWebService:contentDic];
}

- (void)creatTheHud {

    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.square = YES;
        [hud show:YES];
        [self.view addSubview:hud];
    }
}

- (void)callEarnBonusWebService:(NSDictionary *)dictionary {
    [self showDataLoading];
    NSString *requestURL = [RequestURL getRequestURL:BonusEarnURL param:dictionary];
    [WebService postRequest:requestURL param:dictionary JSONModelClass:[EarnBonus class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        EarnBonus *earnBonusCode = responseObject;
        if (earnBonusCode.resultCode == 1) {
            if ([earnBonusCode.totalBonus floatValue] == 0) {
                recommendLab.text = @"0.00";
            } else {
                recommendLab.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [earnBonusCode.totalBonus doubleValue]]];
            }
            detailLab.text = [NSString stringWithFormat:XYBString(@"string_invite_some_friends", @"已推荐%@位好友"), earnBonusCode.recommendCount];
            [headerView bringSubviewToFront:detailLab];

            NSArray *arr = earnBonusCode.earnBonus;
            [dataArr addObjectsFromArray:arr];
            [mainTable reloadData];
            if (dataArr.count == 0) {
                mainTable.footer.hidden = YES;
            } else {
                if (currentPage * 20 > dataArr.count) {

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
        }];
    currentPage++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
