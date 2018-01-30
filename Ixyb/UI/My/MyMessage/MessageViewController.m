//
//  MessageViewController.m
//  Ixyb
//
//  Created by 董镇华 on 16/10/19.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ActivityTableViewCell.h"
#import "MJRefresh.h"
#import "MessageWebViewController.h"
#import "MessageResponseModel.h"
#import "MessageTableViewCell.h"
#import "MessageViewController.h"
#import "WebService.h"
#import "FinanceTableViewCell.h"
#import "ToolUtil.h"

@interface MessageViewController () <UITableViewDelegate, UITableViewDataSource> {
    XYTableView *myTableView;
    NSMutableArray *dataSource;
    NSMutableArray *dataSource2;//刷新时存dataSource的值
    int currentPage;
}
@property (nonatomic, strong) NSMutableDictionary *messageDic; //用来储存消息的； key为userId value为消息的noticeId
@property (nonatomic, strong) NSMutableArray *idArr;           //用来储存已读消息id号 和 刚点击的消息的id号

@end

@implementation MessageViewController

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

    if (self.type == 0) { //公告
        self.navItem.title = @"公告消息";
    } else if (self.type == 1) { //活动
        self.navItem.title = @"活动消息";
    } else if (self.type == 2) { //出借
        self.navItem.title = @"出借消息";
    } else if (self.type == 3) { //信闪贷
        self.navItem.title = @"借款消息";
    }
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
    [myTableView registerClass:[FinanceTableViewCell class] forCellReuseIdentifier:@"cell2"];
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
    if (dataSource.count > 0 ) {
        if (self.type == 1) {//活动
            
            UIImage *image = [UIImage imageNamed:@"messageDefault"];
            CGFloat imageHight = (MainScreenWidth - 60) * image.size.height / image.size.width; //计算图片适配后的高度
            imageHight = imageHight + Margin_Length;                                            //加上图片的顶部距时间lab的间距
            if (dataSource.count == indexPath.row + 1) {
                bottomHeight = Margin_Length;
            }
            return 173.f + bottomHeight + imageHight;
            
        }else if (self.type == 2 || self.type == 3) {//出借 借款
            NotificationsModel *model = [dataSource objectAtIndex:indexPath.row];
            CGFloat hight = [ToolUtil getLabelHightWithLabelStr:model.content MaxSize:CGSizeMake(MainScreenWidth - 60, MainScreenHeight) AndFont:12 LineSpace:6];
            if (dataSource.count == indexPath.row + 1) {
                bottomHeight = Margin_Length;
            }
            return hight + 100 + bottomHeight;
            
        }else if (self.type == 0){//公告
            if (dataSource.count == indexPath.row + 1) {
                bottomHeight = Margin_Length;
            }
            return 173.f + bottomHeight;
        }
    }
    return bottomHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //type 0:公告（不带图片）, 1:活动（带有图片） 2:出借, 3:借款 4:新闻
    if (self.type == 0) {
        MessageTableViewCell *cell = (MessageTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellAccessoryNone;
        if (dataSource.count > 0) {
            NotificationsModel *model = [dataSource objectAtIndex:indexPath.row];
            cell.notification = model;
            if (self.idArr.count > 0) {
                BOOL isContain = [self.idArr containsObject:[NSNumber numberWithInteger:cell.notification.noticeId]];
                if (isContain) {
                    cell.isRead = YES;
                } else {
                    cell.isRead = NO;
                }
            }
        }
        
        cell.block = ^{
            NotificationsModel *model = [dataSource objectAtIndex:indexPath.row];
            MessageWebViewController *messageWebVC = [[MessageWebViewController alloc] initWithTitle:nil webUrlString:model.detailUrl];
            [self.navigationController pushViewController:messageWebVC animated:YES];        };
        return cell;
    }
    
    if (self.type == 1) {
        ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        cell.selectionStyle = UITableViewCellAccessoryNone;
        if (dataSource.count > 0) {
            NotificationsModel *model = [dataSource objectAtIndex:indexPath.row];
            cell.notification = model;
            if (self.idArr.count > 0) {
                BOOL isContain = [self.idArr containsObject:[NSNumber numberWithInteger:cell.notification.noticeId]];
                if (isContain) {
                    cell.isRead = YES;
                } else {
                    cell.isRead = NO;
                }
            }
        }

        cell.block = ^{
            NotificationsModel *model = [dataSource objectAtIndex:indexPath.row];
            MessageWebViewController *messageWebVC = [[MessageWebViewController alloc] initWithTitle:nil webUrlString:model.detailUrl];
            [self.navigationController pushViewController:messageWebVC animated:YES];
        };
        return cell;
        
    }
    
    if (self.type == 2 || self.type == 3) {
        FinanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[FinanceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        cell.selectionStyle = UITableViewCellAccessoryNone;
        if (dataSource.count > 0) {
            NotificationsModel *model = [dataSource objectAtIndex:indexPath.row];
            cell.notification = model;
        }
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //type 2:出借, 3:借款 没有详情页面，文字高度自适应
    if (self.type == 2 || self.type == 3) {
        return;
    }
    
    NotificationsModel *model;
    //type 0:公告, 1:活动
    if (self.type == 0) {
        MessageTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        model = cell.notification;
        if (cell.isRead == NO) {
            cell.isRead = YES;
        }
    }
    
    if (self.type == 1) {
        ActivityTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        model = cell.notification;
        if (cell.isRead == NO) {
            cell.isRead = YES;
        }
    }
    
    //缓存中查找是否存在该noticeId，如果不存在就加入到缓存中，同时改变cell的颜色
    if (![self.idArr containsObject:[NSNumber numberWithInteger:model.noticeId]]) {
        [self.idArr addObject:[NSNumber numberWithInteger:model.noticeId]];
        [self.messageDic setValue:self.idArr forKey:[NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]];
        [UserDefaultsUtil setMessageNoticeId:self.messageDic];
    }

    MessageWebViewController *messageWebVC = [[MessageWebViewController alloc] initWithTitle:nil webUrlString:model.detailUrl];
    [self.navigationController pushViewController:messageWebVC animated:YES];
}

#pragma mark - 设置刷新的方法
- (void)setupRefresh {
    myTableView.header = self.gifHeader3;
    myTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (void)headerRereshing {
    currentPage = 0;
    dataSource2 = [NSMutableArray arrayWithArray:dataSource];
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
        @"type" : [NSNumber numberWithInteger:self.type]
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
