//
//  FinanceMessageViewController.m
//  Ixyb
//
//  Created by dengjian on 16/12/26.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "FinanceMessageViewController.h"

@interface FinanceMessageViewController ()<UITableViewDelegate, UITableViewDataSource> {
    XYTableView *myTableView;
    NSMutableArray *dataSource;
    int currentPage;
}
@property (nonatomic, strong) NSMutableDictionary *messageDic; //用来储存消息的； key为userId value为消息的noticeId
@property (nonatomic, strong) NSMutableArray *idArr;           //用来储存已读消息id号 和 刚点击的消息的id号


@end

@implementation FinanceMessageViewController

//懒加载
- (NSMutableDictionary *)messageDic {
    if (!_messageDic) {
        _messageDic = [[NSMutableDictionary alloc] init];
    }
    return _messageDic;
}

- (NSArray *)idArr {
    if (!_idArr) {
        _idArr = [[NSMutableArray alloc] init];
    }
    return _idArr;
}

- (void)createNav {
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
    self.navItem.title = @"出借消息";
}

- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataSource = [[NSMutableArray alloc] init];
    currentPage = 0;
    [self createNav];
    [self createMyTableView];
    [self setupRefresh];
    [self setTheRequestWithLoading:YES];
}

- (void)createMyTableView {
    myTableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    myTableView.backgroundColor = COLOR_COMMON_CLEAR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [myTableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:@"cell"];
    [myTableView registerClass:[ActivityTableViewCell class] forCellReuseIdentifier:@"cell1"];
    [self.view addSubview:myTableView];
    
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma
#pragma mark - TableviewDelegate TableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat bottomHeight = 0;
    
    return bottomHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NotificationsModel *model = [dataSource objectAtIndex:indexPath.row];
    //缓存中查找是否存在该noticeId，如果不存在就加入到缓存中，同时改变cell的颜色
    if (![self.idArr containsObject:[NSNumber numberWithInteger:model.noticeId]]) {
        [self.idArr addObject:[NSNumber numberWithInteger:model.noticeId]];
        [self.messageDic setValue:self.idArr forKey:[NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]];
        [UserDefaultsUtil setMessageNoticeId:self.messageDic];
    }
    
}

#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    myTableView.header = self.gifHeader3;
    myTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (void)headerRereshing {
    currentPage = 0;
    [dataSource removeAllObjects];
    [self setTheRequestWithLoading:NO];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [myTableView.header endRefreshing];
}

- (void)footerRereshing {
    
    if (currentPage * 20 > dataSource.count) {
        //        myTableView.footer.hidden = YES;
        [myTableView.footer noticeNoMoreData];
        
    } else {
        
        [self setTheRequestWithLoading:NO];
        [myTableView.footer endRefreshing];
    }
}

- (void)setTheRequestWithLoading:(BOOL)showLoading {
    
    NSDictionary *contentDic = @{
                                 @"page" : [NSNumber numberWithInt:currentPage],
                                 @"pageSize" : @(20),
                                 @"userId" : [Utility shareInstance].isLogin ? [UserDefaultsUtil getUser].userId : @"",
                                 @"type" : [NSNumber numberWithInteger:1]
                                 };
    if (showLoading == YES) {
        [self showDataLoading];
    }
    [self requestNotificationWebServiceWithParam:contentDic];
}

/**
 *  公告消息请求
 *
 *  @param params 参数
 */
- (void)requestNotificationWebServiceWithParam:(NSDictionary *)params {
    NSString *requestURL = [RequestURL getRequestURL:NotificationURL param:params];
    [WebService postRequest:requestURL param:params JSONModelClass:[MessageResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self hideLoading];
        MessageResponseModel *responseModel = responseObject;
        [dataSource addObjectsFromArray:responseModel.notifications];
        
        NSDictionary *noticeIdMessageDic = [UserDefaultsUtil getMessageNoticeId];
        if (noticeIdMessageDic) {
            NSArray *idArr = [noticeIdMessageDic valueForKey:[UserDefaultsUtil getUser].userId];
            if (idArr) {
                [self.idArr removeAllObjects];
                [self.idArr addObjectsFromArray:idArr];
            }
        }
        
        [myTableView reloadData];
        
        if (dataSource.count == 0) {
            myTableView.footer.hidden = YES;
        } else {
            if (currentPage * 20 > dataSource.count) {
                
                myTableView.footer.hidden = YES;
                [myTableView.footer noticeNoMoreData];
                
            } else {
                myTableView.footer.hidden = NO;
                [myTableView.footer resetNoMoreData];
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
