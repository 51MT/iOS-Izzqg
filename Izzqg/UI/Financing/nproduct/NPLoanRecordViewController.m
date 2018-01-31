//
//  NPLoanRecordViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/13.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NPLoanRecordViewController.h"
#import "BbgInvestRecordTableViewCell.h"
#import "NoDataView.h"
#import "Utility.h"
#import "MJRefresh.h"
#import "WebService.h"
#import "NPLoanListResModel.h"

@interface NPLoanRecordViewController ()<UITableViewDelegate,UITableViewDataSource> {
    
    UIView *backView;
    NoDataView *noDataView;
}

@property (nonatomic,strong) XYTableView *recordTable;
@property (nonatomic,copy) NSString *productID;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,strong) NSMutableArray *recordArray;

@end

@implementation NPLoanRecordViewController

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

#pragma mark -- 初始化 UI

- (void)setNav {
    self.navItem.title = XYBString(@"InvestmentRecords", @"出借记录");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    self.view.backgroundColor = COLOR_BG;
}


//创建出借人、出借金额、出借时间的顶部View
- (void)createHeaderView {
    
    backView = [[UIView alloc] init];
    backView.backgroundColor = COLOR_COMMON_CLEAR;
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(34));
    }];
    
    UILabel *title1 = [[UILabel alloc] init];
    title1.font = TEXT_FONT_12;
    title1.textColor = COLOR_AUXILIARY_GREY;
    title1.textAlignment = NSTextAlignmentLeft;
    title1.text = XYBString(@"str_financing_investPerson",@"出借人");
    [self.view addSubview:title1];
    
    [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(Margin_Left);
        make.centerY.equalTo(backView.mas_centerY).offset(0);
    }];
    
    UILabel *title2 = [[UILabel alloc] init];
    title2.font = TEXT_FONT_12;
    title2.textColor = COLOR_AUXILIARY_GREY;
    title2.textAlignment = NSTextAlignmentLeft;
    title2.text = XYBString(@"string_financing_money",@"出借金额(元)");
    [self.view addSubview:title2];
    
    [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.equalTo(@((MainScreenWidth - 50) / 3));
    }];
    
    UILabel *title3 = [[UILabel alloc] init];
    title3.font = TEXT_FONT_12;
    title3.textColor = COLOR_AUXILIARY_GREY;
    title3.textAlignment = NSTextAlignmentRight;
    title3.text = XYBString(@"str_financing_investTime",@"出借时间");
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
    [_recordTable registerClass:[BbgInvestRecordTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_recordTable];
    
    [_recordTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(backView.mas_bottom).offset(0);
    }];
}

#pragma mark - UITableViewDataSource + UITableViewDelegate method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _recordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BbgInvestRecordTableViewCell *cell = (BbgInvestRecordTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[BbgInvestRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_recordArray.count > 0) {
        NPLoanListModel *model = [_recordArray objectAtIndex:indexPath.row];
        cell.loanModel = model;
    }

    if ([cell.contentView viewWithTag:1000]) {
        [[cell.contentView viewWithTag:1000] removeFromSuperview];
    }

    if (indexPath.row == _recordArray.count - 1) {
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = COLOR_LINE;
        bottomLine.tag = 1000;
        [cell.contentView addSubview:bottomLine];

        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(cell.contentView);
            make.height.equalTo(@(Line_Height));
        }];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return Cell_Height;
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

#pragma mark - 新产品出借记录 数据请求

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
 新产品出借记录 数据请求

 @param param 参数
 */
- (void)requestNP_InvestRecord_WebService:(NSDictionary *)params {
    
    NSString *requestURL = [RequestURL getRequestURL:OneKeyProductOrderList_URL param:params];
    [WebService postRequest:requestURL param:params JSONModelClass:[NPLoanListResModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        NPLoanListResModel *model = responseObject;
                        [_recordArray addObjectsFromArray:model.orderList];
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
