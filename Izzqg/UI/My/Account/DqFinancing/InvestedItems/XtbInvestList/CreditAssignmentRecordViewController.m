//
//  CreditAssignmentRecordViewController.m
//  Ixyb
//
//  Created by dengjian on 10/21/15.
//  Copyright (c) 2015 xyb. All rights reserved.
//

#import "CreditAssignmentRecordViewController.h"
#import "XYTableView.h"
#import "AssignmentRecordTableViewCell.h"
#import "CaPossessionRecordModel.h"
#import "DMInvestedProject.h"
#import "MJRefresh.h"
#import "NoDataView.h"
#import "Utility.h"
#import "WebService.h"

@interface CreditAssignmentRecordViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) XYTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NoDataView *noDataView;

@end

@implementation CreditAssignmentRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initUI];
    [self initData];

    [self updateRecord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    self.dataArray = [NSMutableArray arrayWithCapacity:5];
    self.pageIndex = 0;
}

- (void)initUI {
    [self initNav];
    [self initTableView];
    [self initNoDataView];
}

- (void)initNav {
    self.navItem.title = XYBString(@"str_trans_record", @"转让记录");
    self.view.backgroundColor = COLOR_BG;

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initTableView {
    self.tableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = COLOR_BG;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[AssignmentRecordTableViewCell class] forCellReuseIdentifier:@"assignmentRecordTableViewCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom);
    }];

    self.tableView.header = self.gifHeader3;
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreRecord)];
}

#pragma mark - 设置刷新的方法

- (void)headerRereshing {
    [self updateRecord];
}

- (void)initNoDataView {
    self.noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    self.noDataView.hidden = YES;
    [self.view addSubview:self.noDataView];
    [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)updateRecord {

    self.pageIndex = 0;
    [self.tableView.footer resetNoMoreData];
    self.tableView.footer.hidden = NO;

    NSDictionary *param = @{
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"orderId" : [NSNumber numberWithInteger:[[self.dicInfo objectForKey:@"orderId"] integerValue]],
        @"projectId" : [NSNumber numberWithInteger:[[self.dicInfo objectForKey:@"projectId"] integerValue]],
        @"projectType" : [NSNumber numberWithInteger:[[self.dicInfo objectForKey:@"projectType"] integerValue]],
        @"page" : [NSNumber numberWithInteger:self.pageIndex],
        @"pageSize" : PageSize,
    };

    NSString *urlPath = [RequestURL getRequestURL:CaAcceptRecordURL param:param];
    [WebService postRequest:urlPath param:param JSONModelClass:[CaPossessionRecordModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.tableView.header endRefreshing];
            CaPossessionRecordModel *caPossessionRecord = responseObject;
            if (caPossessionRecord.resultCode == 1) {
                [self.dataArray removeAllObjects];
                NSArray *recordArray = caPossessionRecord.acceptList;
                [self.dataArray addObjectsFromArray:recordArray];

                if (self.dataArray.count <= 0) {
                    self.noDataView.hidden = NO;
                } else {
                    self.noDataView.hidden = YES;
                }

                [self.tableView reloadData];

                if ([recordArray count] < [PageSize integerValue]) {
                    [self.tableView.footer noticeNoMoreData];
                    self.tableView.footer.hidden = YES;
                }
            }
        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self.tableView.header endRefreshing];
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];

}

- (void)moreRecord {
    self.pageIndex = self.pageIndex + 1;

    NSDictionary *param = @{
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"orderId" : [NSNumber numberWithInteger:[[self.dicInfo objectForKey:@"orderId"] integerValue]],
        @"projectId" : [NSNumber numberWithInteger:[[self.dicInfo objectForKey:@"projectId"] integerValue]],
        @"projectType" : [NSNumber numberWithInteger:[[self.dicInfo objectForKey:@"projectType"] integerValue]],
        @"page" : [NSNumber numberWithInteger:self.pageIndex],
        @"pageSize" : PageSize,
    };

    NSString *urlPath = [RequestURL getRequestURL:CaAcceptRecordURL param:param];
    [WebService postRequest:urlPath param:param JSONModelClass:[CaPossessionRecordModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.tableView.footer endRefreshing];
            CaPossessionRecordModel *caPossessionRecord = responseObject;
            if (caPossessionRecord.resultCode == 1) {
                NSArray *recordArray = caPossessionRecord.acceptList;
                [self.dataArray addObjectsFromArray:[NSArray arrayWithArray:recordArray]];

                if (self.dataArray.count <= 0) {
                    self.noDataView.hidden = NO;
                } else {
                    self.noDataView.hidden = YES;
                }

                [self.tableView reloadData];

                if ([recordArray count] < [PageSize integerValue]) {
                    [self.tableView.footer noticeNoMoreData];
                    self.tableView.footer.hidden = YES;
                }
            }
        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self.tableView.footer endRefreshing];
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return ASSIGNMENT_RECORD_TABLEVIEW_CELL_HEIGHT;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AssignmentRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"assignmentRecordTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[AssignmentRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"assignmentRecordTableViewCell"];
    }
    AcceptListModel *acceptList = self.dataArray[indexPath.row];
    cell.acceptlist = acceptList;
    return cell;
}

@end
