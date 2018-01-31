//
//  SafeUserVoiceViewController.m
//  Ixyb
//
//  Created by wang on 16/12/16.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "MJRefresh.h"
#import "SafeUserVoiceTableViewCell.h"
#import "SafeUserVoiceViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UserVoiceModel.h"
#import "Utility.h"
#import "WebService.h"

@interface SafeUserVoiceViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) XYTableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, assign) int currentPage;
@end

@implementation SafeUserVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initTableView];
    [self setTheRequest];
    [self setupRefresh];
}

- (void)initNav {
    self.navItem.title = XYBString(@"str_security_user_voice", @"用户心声");
    self.view.backgroundColor = COLOR_BG;

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)initTableView {
    self.tableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = COLOR_COMMON_CLEAR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SafeUserVoiceTableViewCell class] forCellReuseIdentifier:xYBSafeUserVoiceTableViewCell];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SafeUserVoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:xYBSafeUserVoiceTableViewCell];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    if (cell == nil) {
        cell = [[SafeUserVoiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:xYBSafeUserVoiceTableViewCell];
    }
    if (self.dataArray.count > 0) {
        cell.userVoice = self.dataArray[indexPath.row];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:xYBSafeUserVoiceTableViewCell configuration:^(SafeUserVoiceTableViewCell *cell) {
        if (self.dataArray.count > 0) {
            UserCommentsModel * userVoice = self.dataArray[indexPath.row];
            [userVoice.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            cell.userVoice = self.dataArray[indexPath.row];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - 设置刷新的方法
- (void)setupRefresh {
    _tableView.header = self.gifHeader3;
    _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (void)headerRereshing {
    _currentPage = 0;
    [_dataArray removeAllObjects];
    [self setTheRequest];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
     [_tableView.header endRefreshing];
}

- (void)footerRereshing {

    if (_currentPage * 20 > _dataArray.count) {

        [_tableView.footer noticeNoMoreData];

    } else {

        [self setTheRequest];
        [_tableView.footer endRefreshing];
    }
}

- (void)setTheRequest {
    NSDictionary *contentDic = @{
        @"pageSize" : PageSize,
        @"page" : [NSNumber numberWithInt:_currentPage],
    };
    [self callTradDataWebServiceParams:contentDic];
}

/*!
 *  @author JiangJJ, 16-12-16 17:12:25
 *
 *  实时交易数据
 */
- (void)callTradDataWebServiceParams:(NSDictionary *)params {

    NSString *urlPath = [RequestURL getRequestURL:UserCommentsURL param:params];
    [WebService postRequest:urlPath param:params JSONModelClass:[UserVoiceModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            UserVoiceModel *userVoice = responseObject;
            NSArray *detailsArr = userVoice.userComments;
            [self.dataArray  addObjectsFromArray:detailsArr];
            [self.tableView reloadData];
            if ( self.dataArray.count == 0) {
                _tableView.footer.hidden = YES;
            } else {
                if (_currentPage * 20 > _dataArray.count) {

                    _tableView.footer.hidden = YES;
                    [_tableView.footer noticeNoMoreData];

                } else {
                    _tableView.footer.hidden = NO;
                    [_tableView.footer resetNoMoreData];
                }
            }

        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {

            [self showPromptTip:errorMessage];
        }];
    
       _currentPage++;
}

@end
