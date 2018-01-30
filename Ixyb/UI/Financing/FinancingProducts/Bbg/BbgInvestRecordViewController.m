//
//  BbgInvestRecordViewController.m
//  Ixyb
//
//  Created by dengjian on 16/8/31.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "BbgInvestRecordResponseModel.h"
#import "BbgInvestRecordTableViewCell.h"
#import "BbgInvestRecordViewController.h"
#import "WebService.h"

@interface BbgInvestRecordViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation BbgInvestRecordViewController {
    NSMutableArray *recordArray;
    UIView *backView;
    NoDataView *noDataView;
    int currentPage;
    MBProgressHUD *hud;
}

- (void)setNav {
    self.navItem.title = XYBString(@"str_financing_investRecord",@"出借记录");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    currentPage = 0;
    recordArray = [[NSMutableArray alloc] init];
    [self setNav];
    [self createHeaderView];
    [self creatNoDataView];
    [self creatTableView];
    [self setupRefresh];
    [self startRequestWithShowLoading:YES];
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
    [self.view addSubview:_recordTable];

    [_recordTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(backView.mas_bottom).offset(0);
    }];

    [_recordTable registerClass:[BbgInvestRecordTableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)startRequestWithShowLoading:(BOOL)showLoading {
    NSDictionary *dict = @{
        @"userId" : [UserDefaultsUtil getUser].userId.length > 0 ? [UserDefaultsUtil getUser].userId : @"0",
        @"pageSize" : PageSize,
        @"page" : [NSNumber numberWithInt:currentPage],
        @"projectId" : self.projectId
    };
    if (showLoading == YES) {
        [self showDataLoading];
    }
    
    [self callBbgInvestRecordWebService:dict];
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

    BbgInvestRecordTableViewCell *cell = (BbgInvestRecordTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[BbgInvestRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (recordArray.count > 0) {
        BbgTradeRecords *model = recordArray[indexPath.row];
        cell.bbgModel = model;
    }

    if ([cell.contentView viewWithTag:1000]) {
        [[cell.contentView viewWithTag:1000] removeFromSuperview];
    }

    if (indexPath.row == recordArray.count - 1) {
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

#pragma mark - 步步高出借记录数据请求

- (void)callBbgInvestRecordWebService:(NSDictionary *)param {

    NSString *requestURL = [RequestURL getRequestURL:BbgInvestRecordRequestURL param:param];
    [WebService postRequest:requestURL param:param JSONModelClass:[BbgInvestRecordResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [self hideLoading];
        BbgInvestRecordResponseModel *model = responseObject;
        [recordArray addObjectsFromArray:model.tradeRecords];
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
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];

    currentPage++;
}

@end
