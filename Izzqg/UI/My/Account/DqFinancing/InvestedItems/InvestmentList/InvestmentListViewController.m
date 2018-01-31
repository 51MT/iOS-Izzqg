//
//  InvestmentListViewController.m
//  Ixyb
//
//  Created by wang on 16/4/11.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "InvestmentListViewController.h"
#import "ZqzrDetailViewController.h"
#import "HnbProductDetailViewController.h"
#import "InvestmentListCell.h"
#import "InvestmentModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "NoDataView.h"
#import "NoDataView.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "XYCellLine.h"
#import "XYTableView.h"
#import "XsdProductDetailViewController.h"
#import "XtbProductDetailViewController.h"
#import "RrcProductDetailViewController.h"
#import "ZglProductDetailViewController.h"
#define CELL_ROW_HEIGHT 60.f
@interface InvestmentListViewController () <UITableViewDataSource, UITableViewDelegate, InvestmentListCellTableViewCellDelegate> {

    //    UIView *headerView;
    XYTableView *table;
    int currentPage;
    NoDataView *noDataView;
    MBProgressHUD *hud;
    NSMutableArray *dataArray;
}

@end

@implementation InvestmentListViewController

- (void)setNav {

    self.navItem.title = XYBString(@"str_investment_details", @"项目出借明细");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    dataArray = [[NSMutableArray alloc] init];
    currentPage = 0;
    [self setNav];
    //    [self creatTheHeaderView];
    [self creatTheNodataView];
    [self creatTheTableView];
    [self setupRefresh];
    [self setTheRequest];
}
- (void)creatTheNodataView {

    noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    noDataView.hidden = YES;
    noDataView.titleLab.text = XYBString(@"str_matching", @"匹配中，请稍后查询。");
    [self.view addSubview:noDataView];

    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];

    [XYCellLine initWithTopLineAtSuperView:noDataView];
    [XYCellLine initWithBottomLineAtSuperView:noDataView];
}

- (void)creatTheTableView {

    table = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.backgroundColor = COLOR_COMMON_CLEAR;
    table.delegate = self;
    table.dataSource = self;
    table.showsHorizontalScrollIndicator = NO;
    table.showsVerticalScrollIndicator = NO;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table registerClass:[InvestmentListCell class] forCellReuseIdentifier:@"InvestmentListCell"];

    [self.view addSubview:table];

    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)setTheRequest {

    if ([StrUtil isEmptyString:self.orderType]) {
        self.orderType = @"";
    }
    
    if ([StrUtil isEmptyString:self.orderId]) {
        self.orderType = @"";
    }
    
    NSDictionary *contentDic = @{
        @"page" : [NSNumber numberWithInt:currentPage],
        @"pageSize" : PageSize,
        @"userId" : [Utility shareInstance].isLogin ? [UserDefaultsUtil getUser].userId : @"0",
        @"orderType" : self.orderType,
        @"orderId" : self.orderId
    };
    [self callInvestProductsWebService:contentDic];
}

#pragma mark-- tableView delegate method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_ROW_HEIGHT;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    InvestmentListCell *cell = (InvestmentListCell *) [tableView dequeueReusableCellWithIdentifier:@"InvestmentListCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[InvestmentListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InvestmentListCell"];
    }
    cell.cellDelegate = self;
    if (dataArray.count > 0) {
        MatchAssetListProjectModel *matchList = dataArray[indexPath.row];
        cell.matchAssetList = matchList;
    }
    return cell;
}

/**
 *  项目详情
 *
 *  @param cell     self
 *  @param cashId   项目ID
 *  @param cashType 项目类型
 */
- (void)cashDetailsTableViewCell:(InvestmentListCell *)cell didClickDetailsButtonOfId:(NSDictionary *)dic{
    
    NSString * cashType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"loanType"]];
    NSString * cashId = [dic objectForKey:@"projectId"];
    NSString * matchType = [dic objectForKey:@"matchType"];
    NSString * subType = [dic objectForKey:@"subType"];
    
    if ([cashType intValue] == 6) {//信闪贷
        XsdProductDetailViewController *xsdProductDetail = [[XsdProductDetailViewController alloc] init];
        xsdProductDetail.productId = cashId;
        [self.navigationController pushViewController:xsdProductDetail animated:YES];
        
    } else if ([cashType intValue] == 4) {//惠农宝
        HnbProductDetailViewController *hnbProductDetail = [[HnbProductDetailViewController alloc] init];
        hnbProductDetail.productId = cashId;
        [self.navigationController pushViewController:hnbProductDetail animated:YES];
        
    } else if ([cashType intValue] == 7) {//人人车
        
        RrcProductDetailViewController *rrcProductDetail = [[RrcProductDetailViewController alloc] init];
        rrcProductDetail.productId = cashId;
        rrcProductDetail.loanType = cashType;
        rrcProductDetail.matchType = matchType;
        rrcProductDetail.subType = subType;
        [self.navigationController pushViewController:rrcProductDetail animated:YES];
        
    }else if ([cashType intValue] == 8) {//租葛亮
        
        ZglProductDetailViewController *zglProductDetail = [[ZglProductDetailViewController alloc] init];
        zglProductDetail.productId = cashId;
        zglProductDetail.loanType = cashType;
        zglProductDetail.matchType = matchType;
        zglProductDetail.subType = subType;
        [self.navigationController pushViewController:zglProductDetail animated:YES];
        
    }else if ([cashType isEqualToString:@"REBACK"]) {//债权转让
        ZqzrDetailViewController *zqzrDetailVC = [[ZqzrDetailViewController alloc] init];
        zqzrDetailVC.productId = cashId;
        zqzrDetailVC.matchType = matchType;
        zqzrDetailVC.isMatching = YES;
        [self.navigationController pushViewController:zqzrDetailVC animated:YES];
        
    }else{//信投宝
        XtbProductDetailViewController *xtbProductDetail = [[XtbProductDetailViewController alloc] init];
        xtbProductDetail.productId = cashId;
        xtbProductDetail.matchType = matchType;
        xtbProductDetail.isMatching = 1;
        [self.navigationController pushViewController:xtbProductDetail animated:YES];
    }
}

/**
 *  合同
 *
 *  @param cell   self
 *  @param cashId 项目ID
 */
- (void)cashContractTableViewCell:(InvestmentListCell *)cell didClickContractButtonOfId:(NSDictionary *)dic {

    BOOL isFull = [[dic objectForKey:@"hasContract"] boolValue];
    NSString *str;
    if (!isFull) {
        [self showPromptTip:XYBString(@"str_contract_generation", @"合同生成中")];
    } else {
        
        str = [NSString stringWithFormat:@"%@", App_Agreement_URL];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", [RequestURL getNodeJsH5URL:str withIsSign:YES], [self getProjectId:[dic objectForKey:@"projectId"] matchId:[dic objectForKey:@"matchId"] matchType:[dic objectForKey:@"matchType"] pdrMatchDetailId:[dic objectForKey:@"pdrDetailId"]]];
        WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:nil webUrlString:urlStr];
        [self.navigationController pushViewController:webView animated:YES];
        
    }
}

- (NSString *)getProjectId:(NSString *)projectId matchId:(NSString *)matchId matchType:(NSString *)matchType pdrMatchDetailId:(NSString *)pdrMatchDetailId {
    NSString *projectStr = [NSString stringWithFormat:@"&projectId=%@&matchId=%@&matchType=%@&pdrDetailId=%@", projectId, matchId,matchType, pdrMatchDetailId];
    return projectStr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MatchAssetListProjectModel *investMent = dataArray[indexPath.row];
    
    if (investMent.loanType == 6) {//信闪贷
        XsdProductDetailViewController *xsdProductDetail = [[XsdProductDetailViewController alloc] init];
        xsdProductDetail.productId = investMent.projectId;
        [self.navigationController pushViewController:xsdProductDetail animated:YES];
        
    } else if (investMent.loanType == 4) {//惠农宝
        HnbProductDetailViewController *hnbProductDetail = [[HnbProductDetailViewController alloc] init];
        hnbProductDetail.productId = investMent.projectId;
        [self.navigationController pushViewController:hnbProductDetail animated:YES];
        
    } else if (investMent.loanType == 7) {//人人车
        
        RrcProductDetailViewController *rrcProductDetail = [[RrcProductDetailViewController alloc] init];
        NSString * loanType = [StrUtil isEmptyString:[NSString stringWithFormat:@"%ld",investMent.loanType]] ? @"" : [NSString stringWithFormat:@"%ld",investMent.loanType];
        rrcProductDetail.loanType = loanType;
        rrcProductDetail.matchType = investMent.matchType;
        rrcProductDetail.subType =  [StrUtil isEmptyString:investMent.subType] ? @"" : investMent.subType;
        rrcProductDetail.productId = investMent.projectId;
        [self.navigationController pushViewController:rrcProductDetail animated:YES];
        
    }else if (investMent.loanType == 8) {//租葛亮
        
        NSString * loanType = [StrUtil isEmptyString:[NSString stringWithFormat:@"%ld",investMent.loanType]] ? @"" : [NSString stringWithFormat:@"%ld",investMent.loanType];
        
        ZglProductDetailViewController *zglProductDetail = [[ZglProductDetailViewController alloc] init];
        zglProductDetail.productId = investMent.projectId;
        zglProductDetail.loanType = loanType;;
        zglProductDetail.matchType = investMent.matchType;
        zglProductDetail.subType = investMent.subType;
        [self.navigationController pushViewController:zglProductDetail animated:YES];
        
    }else if ([investMent.matchType isEqualToString:@"REBACK"]) {//债权转让
        ZqzrDetailViewController *zqzrDetailVC = [[ZqzrDetailViewController alloc] init];
        zqzrDetailVC.productId = investMent.projectId;
        zqzrDetailVC.matchType = investMent.matchType;
        zqzrDetailVC.isMatching = YES;
        [self.navigationController pushViewController:zqzrDetailVC animated:YES];
        
    }else{//信投宝
        XtbProductDetailViewController *xtbProductDetail = [[XtbProductDetailViewController alloc] init];
        xtbProductDetail.productId = investMent.projectId;
        xtbProductDetail.matchType = investMent.matchType;
        xtbProductDetail.isMatching = 1;
        [self.navigationController pushViewController:xtbProductDetail animated:YES];
    }
    
}

#pragma mark - 设置刷新的方法
- (void)setupRefresh {
    table.header = self.gifHeader3;
    table.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

-(void)headerRereshing {
    currentPage = 0;
    [dataArray removeAllObjects];
    [self setTheRequest];
    [self performSelector:@selector(endrefresh) withObject:nil afterDelay:1.0f];
}

- (void)endrefresh {
    [table.header endRefreshing];
}

- (void)footerRereshing {

    if (currentPage * 20 > dataArray.count) {

        //        projectTableView.footer.hidden = YES;
        [table.footer noticeNoMoreData];

    } else {

        [self setTheRequest];
        [table.footer endRefreshing];
    }
}

/*****************************资产匹配接口**********************************/
- (void)callInvestProductsWebService:(NSDictionary *)dictionary {
    [self showDataLoading];
    NSString *urlPath = [RequestURL getRequestURL:MyInvestAssetMatchDetailURL param:dictionary];
    [WebService postRequest:urlPath param:dictionary JSONModelClass:[InvestmentModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            InvestmentModel *investment = responseObject;
            if (investment.resultCode == 1) {
                NSArray *arr = investment.matchAssetList;
                [dataArray addObjectsFromArray:arr];
                if (dataArray.count == 0) {

                    noDataView.hidden = NO;
                    table.footer.hidden = YES;
                } else {
                    noDataView.hidden = YES;
                    if (currentPage * 20 > dataArray.count) {

                        table.footer.hidden = YES;
                        [table.footer noticeNoMoreData];

                    } else {
                        table.footer.hidden = NO;
                        [table.footer resetNoMoreData];
                    }
                }
            }
            [table reloadData];
        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [table reloadData];
            if (dataArray.count == 0) {

                noDataView.hidden = NO;
                table.footer.hidden = YES;
            }
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }

    ];
    currentPage++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
