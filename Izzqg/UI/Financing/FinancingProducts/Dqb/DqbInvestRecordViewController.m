//
//  TrendRecordViewController.m
//  Ixyb
//
//  Created by dengjian on 16/6/30.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "DqbInvestRecordsResponseModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "NoDataView.h"
#import "DqbInvestRecordTableViewCell.h"
#import "DqbInvestRecordViewController.h"
#import "Utility.h"
#import "WebService.h"

@interface DqbInvestRecordViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *recordArray;

    NoDataView *noDataView;

    int currentPage;
    MBProgressHUD *hud;
}

@end

@implementation DqbInvestRecordViewController

- (void)setNav {
    self.navItem.title = XYBString(@"str_financing_investRecord",@"出借记录");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self creatNoDataView];
    [self creatTableView];

    recordArray = [[NSMutableArray alloc] init];

    currentPage = 0;
    [self setupRefresh];
    [self startRequestWithShowLoading:YES];
}

//创建出借人、出借金额、出借时间的顶部View
- (void)creatTableView {

    UILabel *title1 = [[UILabel alloc] init];
    title1.font = SMALL_TEXT_FONT_13;
    title1.textColor = COLOR_AUXILIARY_GREY;
    title1.textAlignment = NSTextAlignmentLeft;
    title1.text = XYBString(@"str_financing_investPerson",@"出借人");
    [self.view addSubview:title1];

    [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(Margin_Top);
        make.left.equalTo(self.view).offset(Margin_Left);
    }];

    UILabel *title2 = [[UILabel alloc] init];
    title2.font = SMALL_TEXT_FONT_13;
    title2.textColor = COLOR_AUXILIARY_GREY;
    title2.textAlignment = NSTextAlignmentLeft;
    title2.text = XYBString(@"str_financing_investMoneytotal",@"出借金额(元)");
    [self.view addSubview:title2];

    [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(title1.mas_centerY);
        make.width.equalTo(@((MainScreenWidth - 50) / 3));
    }];

    UILabel *title3 = [[UILabel alloc] init];
    title3.font = SMALL_TEXT_FONT_13;
    title3.textColor = COLOR_AUXILIARY_GREY;
    title3.textAlignment = NSTextAlignmentRight;
    title3.text = XYBString(@"str_financing_investTime",@"出借时间");
    [self.view addSubview:title3];

    [title3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(Margin_Top);
        make.right.equalTo(self.view.mas_right).offset(-Margin_Right);
    }];

    _recordTable = [[XYTableView alloc] initWithFrame:CGRectMake(0, 43, MainScreenWidth, MainScreenHeight - 43) style:UITableViewStylePlain];
    _recordTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _recordTable.backgroundColor = COLOR_COMMON_CLEAR;
    _recordTable.delegate = self;
    _recordTable.dataSource = self;
    [self.view addSubview:_recordTable];

    [_recordTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(title2.mas_bottom).offset(Margin_Top);
    }];

    [_recordTable registerClass:[DqbInvestRecordTableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)creatNoDataView {

    noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    noDataView.hidden = YES;
    [self.view addSubview:noDataView];

    [self.view sendSubviewToBack:noDataView];

    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@35);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)startRequestWithShowLoading:(BOOL)showLoading {

    if (showLoading == YES) {
        [self showDataLoading];
    }
    [self requestDqbInvestRecordWebServiceWithParam:@{
        @"bidRequestId" : _bidRequestIdStr,
        @"pageSize" : PageSize,
        @"page" : [NSNumber numberWithInt:currentPage]
    }];
}

#pragma mark-- tableView delegate method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return Cell_Height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return recordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DqbInvestRecordTableViewCell *cell = (DqbInvestRecordTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DqbInvestRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (recordArray.count > 0) {
        cell.model = recordArray[indexPath.row];
    }

    if ([cell.contentView viewWithTag:1000]) {
        [[cell.contentView viewWithTag:1000] removeFromSuperview];
    }

    if (indexPath.row == 0) {
        UIView *splitView = [[UIView alloc] init];
        splitView.backgroundColor = COLOR_LINE;
        splitView.tag = 1000;
        [cell.contentView addSubview:splitView];

        [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(cell);
            make.height.equalTo(@(Line_Height));
        }];
    }

    if ([cell.contentView viewWithTag:1001]) {
        [[cell.contentView viewWithTag:1001] removeFromSuperview];
    }

    if (indexPath.row == recordArray.count - 1) {
        UIView *splitView = [[UIView alloc] init];
        splitView.backgroundColor = COLOR_LINE;
        splitView.tag = 1001;
        [cell.contentView addSubview:splitView];

        [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(cell);
            make.height.equalTo(@(Line_Height));
        }];
    }

    return cell;
}

#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    _recordTable.header = self.gifHeader3;
    _recordTable.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (void)headerRereshing {
    currentPage = 0;
    [recordArray removeAllObjects];
    [self startRequestWithShowLoading:NO];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [_recordTable.header endRefreshing];
}

- (void)footerRereshing {

    if (currentPage * 20 > recordArray.count) {

        [_recordTable.footer noticeNoMoreData];

    } else {

        [self startRequestWithShowLoading:NO];
        [_recordTable.footer endRefreshing];
    }
}

#pragma mark - 投标记录

- (void)requestDqbInvestRecordWebServiceWithParam:(NSDictionary *)param {
    NSString *requestRUL = [RequestURL getRequestURL:CcInvestRecordsURL param:param];
    [WebService postRequest:requestRUL param:param JSONModelClass:[DqbInvestRecordsResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        DqbInvestRecordsResponseModel *responseModel = responseObject;
        [recordArray addObjectsFromArray:responseModel.projects];
        [self.recordTable reloadData];

        if (recordArray.count == 0) {

            noDataView.hidden = NO;
            _recordTable.footer.hidden = YES;
        } else {
            noDataView.hidden = YES;
            if (currentPage * 20 > recordArray.count) {

                _recordTable.footer.hidden = YES;
                [_recordTable.footer noticeNoMoreData];

            } else {
                _recordTable.footer.hidden = NO;
                [_recordTable.footer resetNoMoreData];
            }
        }

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [_recordTable reloadData];
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
    currentPage++;
}

@end
