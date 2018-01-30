//
//  RunViewController.m
//  DZGTestDemo
//
//  Created by dengjian on 16/12/9.
//  Copyright © 2016年 dongzhigang. All rights reserved.
//

#import "JDRefreshTableViewController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface JDRefreshTableViewController () <XHRefreshControlDelegate, UITableViewDelegate, UITableViewDataSource>

@end

@implementation JDRefreshTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupRefreshControl];
    [self.refreshControl startPullDownRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //直接设置tableView支持上下拉刷新
    self.pullDownRefreshed = YES;
    self.loadMoreRefreshed = YES;

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"identifer"];
    [self.view addSubview:self.tableView];

    //继承该类后用户可在此方法中重新编辑tableView的各种属性
}

- (void)setupRefreshControl {
    if (!_refreshControl) {
        _refreshControl = [[XHRefreshControl alloc] initWithScrollView:self.tableView delegate:self];
    }
}

- (XHJDRefreshView *)refreshView {
    if (!_refreshView) {
        _refreshView = [[XHJDRefreshView alloc] initWithFrame:CGRectMake(0, -60, ScreenWidth, 60)];
    }
    return _refreshView;
}

#pragma tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"identifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    if (indexPath.row < self.dataSource.count) {
        cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    }
    return cell;
}

#pragma mark - XHRefreshControl Delegate

//获取用户定义下拉的View
- (UIView *)customPullDownRefreshView {
    return self.refreshView;
}

//通知外部，下拉的状态，用于定制某个时机的状态
- (void)customPullDownRefreshViewRefreshState:(XHRefreshState)refreshState {
    switch (refreshState) {
        case XHRefreshStateNormal:
        case XHRefreshStateStopped:
            [self.refreshView normal];
            break;
        case XHRefreshStateLoading:
            [self.refreshView refreing];
            break;
        case XHRefreshStatePulling:
            [self.refreshView willRefresh];
            break;
        default:
            break;
    }
}

//通知外部，下拉的距离，用于定制某个时机的状态
- (void)customPullDownRefreshView:(UIView *)customPullDownRefreshView withPullDownOffset:(CGFloat)pullDownOffset {
    self.refreshView.pullDownOffset = pullDownOffset;
}

//将要下拉的时候，被调用
- (void)customPullDownRefreshViewWillStartRefresh:(UIView *)customPullDownRefreshView {
}

//刚进入下拉的时候，被调用
- (void)customPullDownRefreshViewDidStartRefresh:(UIView *)customPullDownRefreshView {
}

//将要停止下啦的时候，被调用
- (void)customPullDownRefreshViewWillEndRefresh:(UIView *)customPullDownRefreshView {
    [self.refreshView endRefresing];
}

//刚进入停止下啦的时候，被调用
- (void)customPullDownRefreshViewDidEndRefresh:(UIView *)customPullDownRefreshView {
}

#pragma mark - XHRefreshControl Delegate中的相关设置如下

//设置：支持下拉刷新
- (BOOL)isPullDownRefreshed {
    return self.pullDownRefreshed;
}

//设置：支持上拉加载数据
- (BOOL)isLoadMoreRefreshed {
    return self.loadMoreRefreshed;
}

//设置下拉刷新类型：用户自定义
- (XHPullDownRefreshViewType)pullDownRefreshViewType {
    return XHPullDownRefreshViewTypeCustom;
}

//设置：下拉加载最新数据，外部继承本类以后必须实现的方法
- (void)beginPullDownRefreshing {
    self.requestCurrentPage = 0;
    [self loadDataSource];
}

//设置：上拉刷新，加载更多数据；外部继承本类以后必须实现的方法
- (void)beginLoadMoreRefreshing {
    self.requestCurrentPage++;
    [self loadDataSource];
}

//设置：更新数据的时间
- (NSString *)lastUpdateTimeString {

    NSString *destDateString;
    destDateString = @"从未更新";

    return destDateString;
}

//设置：下拉刷新是UIScrollView的子view上
- (XHRefreshViewLayerType)refreshViewLayerType {
    return XHRefreshViewLayerTypeOnScrollViews;
}

- (void)loadDataSource {
    //继承本类后需要实现该方法，下面的代码供参考

    //开启异步线程加载数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *dataSource = [[NSMutableArray alloc] init];
        for (int i = 0; i < 100; i++) {
            [dataSource addObject:@"请问你现在在哪里啊？我在广州天河"];
        }

        NSMutableArray *indexPaths;
        if (self.requestCurrentPage) {
            indexPaths = [[NSMutableArray alloc] initWithCapacity:dataSource.count];
            [dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:self.dataSource.count + idx inSection:0]];
            }];
        }
        sleep(1);

        //主线程中刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.requestCurrentPage) {
                if (self.requestCurrentPage == arc4random() % 10) {
                    [self.refreshControl endMoreOverWithMessage:@"段子已加载完"];
                } else {

                    [self.dataSource addObjectsFromArray:dataSource];
                    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                    [self.refreshControl endLoadMoreRefresing];
                }
            } else {
                if (rand() % 3 > 1) {
                    self.loadMoreRefreshed = NO;
                }

                self.dataSource = dataSource;
                [self.tableView reloadData];
                [self.refreshControl endPullDownRefreshing];
            }
        });
    });
}

@end
