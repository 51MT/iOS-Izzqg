//
//  AllianceToolView.m
//  Ixyb
//
//  Created by dengjian on 1/4/16.
//  Copyright © 2016 xyb. All rights reserved.
//

#import "AllianceToolView.h"

#import "AllianceToolCell.h"
#import "ShareListModel.h"
#import "HUD.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "Utility.h"
#import "WebService.h"
#import "XYTableView.h"

@interface AllianceToolView () <UITableViewDataSource, UITableViewDelegate, AllianceToolCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) XYTableView *tableView;

@end

@implementation AllianceToolView

- (id)init {
    if (self = [super init]) {
        [self initUI];
        self.dataArray = [NSMutableArray arrayWithCapacity:10];
        [self updateMyUnionTool];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = COLOR_BG;
    self.tableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = COLOR_BG;

    [self addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[AllianceToolCell class] forCellReuseIdentifier:@"myUnionToolCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self setupRefresh];
}

#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    self.tableView.header = self.gifHeader3;
}

- (void)headerRereshing {
    [self updateMyUnionTool];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [_tableView.header endRefreshing];
}

- (void)updateMyUnionTool {

    NSDictionary *param = @{ @"userId" : [UserDefaultsUtil getUser].userId };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:param];
    NSString *urlPath = [RequestURL getRequestURL:DiscoverRequestURL param:params];
    [WebService postRequest:urlPath param:param JSONModelClass:[ShareListModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ShareListModel *discover = responseObject;
        if (discover.resultCode == 1) {
            NSArray *bannersArr = discover.shareList;
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:bannersArr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {

            [self showPromptTip:errorMessage];
        }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MY_UNION_TOOL_CELL_HEGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    AllianceToolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myUnionToolCell"
                                                             forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[AllianceToolCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myUnionToolCell"];
    }
    cell.delegate = self;
    cell.myTool = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AllianceToolCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.delegate && [self.delegate respondsToSelector:@selector(myUnionToolView:didClick:)]) {
//        NSDictionary *userData = @{ @"item" : [self.dataArray objectAtIndex:indexPath.row] };
        NSMutableDictionary *userData = [NSMutableDictionary dictionaryWithCapacity:5];
        [userData setObject:[self.dataArray objectAtIndex:indexPath.row] forKey:@"item"];
        [userData setObject:cell.imgView forKey:@"imageView"];
        [self.delegate myUnionToolView:self didClick:userData];
    }
}

- (void)myUnionToolCell:(AllianceToolCell *)cell didClickShared:(NSDictionary *)userData {
    if (self.delegate && [self.delegate respondsToSelector:@selector(myUnionToolView:didClickShare:)]) {
        [self.delegate myUnionToolView:self didClickShare:userData];
    }
}

- (void)refreshUI {
}

@end
