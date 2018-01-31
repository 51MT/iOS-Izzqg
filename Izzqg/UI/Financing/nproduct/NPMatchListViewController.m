//
//  NPMatchListViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/13.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NPMatchListViewController.h"
#import "NpDetailMarkTableViewCell.h"
#import "NoDataView.h"
#import "Utility.h"
#import "WebService.h"
#import "NProductDetailResModel.h"
#import "MJRefresh.h"

#import "XsdProductDetailViewController.h"
#import "HnbProductDetailViewController.h"
#import "ZqzrDetailViewController.h"
#import "RrcProductDetailViewController.h"
#import "ZglProductDetailViewController.h"
#import "XtbProductDetailViewController.h"


@interface NPMatchListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIView *backView;
    NoDataView *noDataView;
}

@property (nonatomic,strong) XYTableView *recordTable;
@property (nonatomic,copy) NSString *productID;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,strong) NSMutableArray *recordArray;

@end

@implementation NPMatchListViewController

- (instancetype)initWithNProductID:(NSString *)productID {
    self = [super init];
    if (self) {
        _productID = productID;
        _recordArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self createHeaderView];
    [self creatNoDataView];
    [self creatTableView];
    [self setupRefresh];
    [self startRequestWithShowLoading:YES];
}

#pragma mark - 初始化 UI

- (void)setNav {
    self.navItem.title = XYBString(@"str_financing_bdzc", @"标的组成");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    self.view.backgroundColor = COLOR_BG;
}

//创建出借人、出借金额、出借时间的顶部View
- (void)createHeaderView {
    
    backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = COLOR_COMMON_CLEAR;
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(34));
    }];
    
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectZero];
    title1.font = TEXT_FONT_12;
    title1.textColor = COLOR_AUXILIARY_GREY;
    title1.textAlignment = NSTextAlignmentLeft;
    title1.text = XYBString(@"str_financing_projectName",@"项目名称");
    [self.view addSubview:title1];
    
    [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(Margin_Left);
        make.centerY.equalTo(backView.mas_centerY).offset(0);
    }];
    
    UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectZero];
    title2.font = TEXT_FONT_12;
    title2.textColor = COLOR_AUXILIARY_GREY;
    title2.textAlignment = NSTextAlignmentLeft;
    title2.text = XYBString(@"str_financing_projectTotal", @"融资总额(元)");
    [self.view addSubview:title2];
    
    [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.centerY.equalTo(backView.mas_centerY);
    }];
    
    UILabel *title3 = [[UILabel alloc] initWithFrame:CGRectZero];
    title3.font = TEXT_FONT_12;
    title3.textColor = COLOR_AUXILIARY_GREY;
    title3.textAlignment = NSTextAlignmentRight;
    title3.text = XYBString(@"str_financing_ptojectBalance", @"剩余可投金额(元)");
    [self.view addSubview:title3];
    
    [title3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY).offset(0);
        make.right.equalTo(backView.mas_right).offset(-Margin_Right);
    }];
    
    [XYCellLine initWithBottomLineAtSuperView:backView];
}

- (void)creatNoDataView {
    
    noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    noDataView.hidden = YES;
    [self.view addSubview:noDataView];
    
    [self.view sendSubviewToBack:noDataView];
    
    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_bottom).offset(0);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)creatTableView {
    
    _recordTable = [[XYTableView alloc] initWithFrame:CGRectMake(0, 43, MainScreenWidth, MainScreenHeight - 43) style:UITableViewStylePlain];
    _recordTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _recordTable.backgroundColor = COLOR_COMMON_CLEAR;
    _recordTable.delegate = self;
    _recordTable.dataSource = self;
    [self.view addSubview:_recordTable];
    
    [_recordTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(backView.mas_bottom).offset(0);
    }];
    
    [_recordTable registerClass:[NpDetailMarkTableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - tableView delegate method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _recordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NpDetailMarkTableViewCell *cell = (NpDetailMarkTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NpDetailMarkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (_recordArray.count > 0) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        NPBidListModel *model = [_recordArray objectAtIndex:indexPath.row];
        cell.model = model;
        cell.showBottomLine = YES;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NPBidListModel *model = [_recordArray objectAtIndex:indexPath.row];
    
    NSString *matchType = model.matchType;
    int loanType = [model.type intValue];
    NSString *productId = model.loanId;
    NSString *subType = model.subType;
    
    // loanType   4 信农贷   5格莱珉 6信闪贷  7人人车  8租葛亮
    
    if (loanType == 6) {//信闪贷
        XsdProductDetailViewController *xsdProductDetail = [[XsdProductDetailViewController alloc] init];
        xsdProductDetail.productId = productId;
        xsdProductDetail.matchType = matchType;
        xsdProductDetail.isNP = YES;
        [self.navigationController pushViewController:xsdProductDetail animated:YES];
        
    } else if (loanType == 4) {//惠农宝
        HnbProductDetailViewController *hnbProductDetail = [[HnbProductDetailViewController alloc] init];
        hnbProductDetail.productId = productId;
        hnbProductDetail.matchType = matchType;
        hnbProductDetail.isNP = YES;
        [self.navigationController pushViewController:hnbProductDetail animated:YES];
        
    } else if (loanType == 7) {//人人车
        
        RrcProductDetailViewController *rrcProductDetail = [[RrcProductDetailViewController alloc] init];
        rrcProductDetail.productId = productId;
        rrcProductDetail.loanType =  [StrUtil isEmptyString:model.type] ? @"" : model.type;
        rrcProductDetail.matchType = matchType;
        rrcProductDetail.subType = [StrUtil isEmptyString:subType] ? @"" : subType;
        rrcProductDetail.isNP = YES;
        [self.navigationController pushViewController:rrcProductDetail animated:YES];
        
    }else if (loanType == 8) {//租葛亮
        
        ZglProductDetailViewController *zglProductDetail = [[ZglProductDetailViewController alloc] init];
        zglProductDetail.productId = productId;
        zglProductDetail.loanType =   [StrUtil isEmptyString:model.type] ? @"" : model.type;
        zglProductDetail.matchType = matchType;
        zglProductDetail.subType = [StrUtil isEmptyString:subType] ? @"" : subType;
        zglProductDetail.isNP = YES;
        [self.navigationController pushViewController:zglProductDetail animated:YES];
        
    }else if ([matchType isEqualToString:@"REBACK"]) {//债权转让
        
        ZqzrDetailViewController *zqzrDetailVC = [[ZqzrDetailViewController alloc] init];
        zqzrDetailVC.productId = productId;
        zqzrDetailVC.matchType = matchType;
        zqzrDetailVC.isNP = YES;
        [self.navigationController pushViewController:zqzrDetailVC animated:YES];
        
    }else{//信投宝
        XtbProductDetailViewController *xtbProductDetail = [[XtbProductDetailViewController alloc] init];
        xtbProductDetail.productId = productId;
        xtbProductDetail.matchType = matchType;
        xtbProductDetail.isNP = YES;
        [self.navigationController pushViewController:xtbProductDetail animated:YES];
    }
}

#pragma mark - 点击事件
-(void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    _recordTable.header = self.gifHeader3;
    _recordTable.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (void)headerRereshing {
    _currentPage = 0;
    [_recordArray removeAllObjects];
    [self startRequestWithShowLoading:NO];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [_recordTable.header endRefreshing];
}

- (void)footerRereshing {
    
    if (_currentPage * 20 > _recordArray.count) {
        
        [_recordTable.footer noticeNoMoreData];
        
    } else {
        
        [self startRequestWithShowLoading:NO];
        [_recordTable.footer endRefreshing];
    }
}

#pragma mark - 新产品标的组成 数据请求

- (void)startRequestWithShowLoading:(BOOL)showLoading {
    
    if (showLoading == YES) {
        [self showDataLoading];
    }
    
    NSDictionary *params = @{
                             @"userId" : [UserDefaultsUtil getUser].userId.length > 0 ? [UserDefaultsUtil getUser].userId : @"0",
                             @"pageSize" : PageSize,
                             @"page" : [NSNumber numberWithInt:_currentPage],
                             @"productId" : self.productID,
                             };
    [self requestNP_InvestRecord_WebService:params];
}


/**
 新产品标的组成 数据请求
 
 @param param 参数
 */
- (void)requestNP_InvestRecord_WebService:(NSDictionary *)params {
    
    NSString *requestURL = [RequestURL getRequestURL:OneKeyProductBidItems_URL param:params];
    [WebService postRequest:requestURL param:params JSONModelClass:[NProductDetailResModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        NProductDetailResModel *model = responseObject;
                        [_recordArray addObjectsFromArray:model.bidList];
                        [self.recordTable reloadData];
                        
                        if (_recordArray.count == 0) {
                            noDataView.hidden = NO;
                            _recordTable.footer.hidden = YES;
                            
                        } else {
                            
                            noDataView.hidden = YES;
                            if (_currentPage * 20 > _recordArray.count) {
                                _recordTable.footer.hidden = YES;
                                [_recordTable.footer noticeNoMoreData];
                            } else {
                                _recordTable.footer.hidden = NO;
                                [_recordTable.footer resetNoMoreData];
                            }
                        }
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
    
    _currentPage++;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}


@end
