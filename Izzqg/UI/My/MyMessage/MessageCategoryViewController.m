//
//  MessageViewController.m
//  Ixyb
//
//  Created by dengjian on 16/10/19.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "MJRefresh.h"
#import "MessageCategoryViewController.h"
#import "MessageViewController.h"
#import "NewsViewController.h"
#import "NoDataView.h"
#import "NoticeView.h"
#import "Utility.h"
#import "WebService.h"
#import "NotificationResponseModel.h"

@interface MessageCategoryViewController () {

    NSMutableArray *dataSource;
    XYScrollView *mainScroll;

    NoticeView *noticeView;   //公告
    NoticeView *activityView; //活动
    NoticeView *newsView;     //新闻
    NoticeView *borrowView;   //借款
    NoticeView *financeView;  //出借

    BOOL isBorrow;                //是否借过款
    BOOL isFinance;               //是否出借
    NewsModel *newsModel;         //用来记录新闻
    NSMutableDictionary *dateDic; //点击时消息时，记录阅读消息时间
}

@end

@implementation MessageCategoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //返回当前页面时请求最新数据，刷新页面
    [self setTheRequestWithLoading:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = COLOR_BG;
    dataSource = [[NSMutableArray alloc] init];
    dateDic = [[NSMutableDictionary alloc] init];
    [self setNav];
    [self createMainUI];
    [self setupRefresh];
    [self setTheRequestWithLoading:YES];
}

#pragma mark - 创建页面UI

/**
 *  @brief 设置导航栏
 */
- (void)setNav {
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
    self.navItem.title = @"消息";
}

/**
 *  @brief 创建公告 活动 新闻 借款 出借UI
 */
- (void)createMainUI {

    mainScroll = [[XYScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:mainScroll];

    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    MessageCategoryViewController *weakVC = self;
    //公告
    noticeView = [[NoticeView alloc] initWithFrame:CGRectZero];
    noticeView.type = 0;
    noticeView.hidden = YES;
    noticeView.block = ^(NSInteger type) {
        [weakVC pushToViewControllerWithType:type];
    };
    [mainScroll addSubview:noticeView];

    [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(0));
    }];

    //活动
    activityView = [[NoticeView alloc] initWithFrame:CGRectZero];
    activityView.type = 1;
    activityView.hidden = YES;
    activityView.block = ^(NSInteger type) {
        [weakVC pushToViewControllerWithType:type];
    };
    [mainScroll addSubview:activityView];

    [activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScroll.mas_left);
        make.top.equalTo(noticeView.mas_bottom).offset(0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(0));
    }];

    //新闻
    newsView = [[NoticeView alloc] initWithFrame:CGRectZero];
    newsView.type = 4;
    newsView.hidden = YES;
    newsView.block = ^(NSInteger type) {
        [weakVC pushToViewControllerWithType:type];
    };
    [mainScroll addSubview:newsView];

    [newsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScroll.mas_left);
        make.top.equalTo(activityView.mas_bottom).offset(0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(0));
    }];

    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
    lineView1.backgroundColor = COLOR_LINE;
    [newsView addSubview:lineView1];

    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(newsView);
        make.height.equalTo(@(Line_Height));
    }];

    //借款
    borrowView = [[NoticeView alloc] initWithFrame:CGRectZero];
    borrowView.type = 3;
    borrowView.hidden = YES;
    borrowView.block = ^(NSInteger type) {
        [weakVC pushToViewControllerWithType:type];
    };
    [mainScroll addSubview:borrowView];

    [borrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScroll.mas_left);
        make.top.equalTo(newsView.mas_bottom).offset(Margin_Length);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(0));
    }];

    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
    lineView2.backgroundColor = COLOR_LINE;
    [borrowView addSubview:lineView2];

    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(borrowView);
        make.height.equalTo(@(Line_Height));
    }];

    //出借消息
    financeView = [[NoticeView alloc] initWithFrame:CGRectZero];
    financeView.type = 2;
    financeView.hidden = YES;
    financeView.block = ^(NSInteger type) {
        [weakVC pushToViewControllerWithType:type];
    };
    [mainScroll addSubview:financeView];

    [financeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScroll.mas_left);
        make.top.equalTo(borrowView.mas_bottom).offset(0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(0));
        make.bottom.equalTo(mainScroll.mas_bottom);
    }];

    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectZero];
    lineView3.backgroundColor = COLOR_LINE;
    [financeView addSubview:lineView3];

    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(financeView);
        make.height.equalTo(@(Line_Height));
    }];
}

#pragma mark - 刷新页面UI

/**
 *  @brief 页面刷新
 *
 *  @param mutArr 装有NotificationModel的数组
 */
- (void)refreshUI:(NSMutableArray *)mutArr {
    NSString *lastReadDateStr;
    NSDictionary *userDic = [UserDefaultsUtil getLastReadDateDic];
    NSDictionary *lastReadDateDic = [userDic objectForKey:[UserDefaultsUtil getUser].userId];
    if (mutArr && mutArr.count >= 1) {
        for (NotificationModel *model in mutArr) {
            
            if (model.type == 0) { //公告
                noticeView.hidden = NO;
                noticeView.detailLab.text = [NSString stringWithFormat:@"%@", model.title];
                noticeView.timeLab.text = [model.createdDate substringToIndex:model.createdDate.length - 3];
                [noticeView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@60);
                }];
                
                if (userDic && lastReadDateDic) {
                    lastReadDateStr = [lastReadDateDic objectForKey:@"NoticeDate"];
                }

            } else if (model.type == 1) { //活动
                activityView.hidden = NO;
                activityView.detailLab.text = [NSString stringWithFormat:@"%@", model.title];
                activityView.timeLab.text = [model.createdDate substringToIndex:model.createdDate.length - 3];
                
                [activityView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@60);
                }];
                
                if (userDic && lastReadDateDic) {
                    lastReadDateStr = [lastReadDateDic objectForKey:@"EventDate"];
                }

            } else if (model.type == 2) { //出借
                isFinance = YES;
                financeView.hidden = NO;
                financeView.detailLab.text = [NSString stringWithFormat:@"%@", model.title];
                financeView.timeLab.text = [model.createdDate substringToIndex:model.createdDate.length - 3];
                
                [financeView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@60);
                }];
                
                if (userDic && lastReadDateDic) {
                    lastReadDateStr = [lastReadDateDic objectForKey:@"FinanceDate"];
                }

            } else if (model.type == 3) { //借款
                isBorrow = YES;
                borrowView.hidden = NO;
                borrowView.detailLab.text = [NSString stringWithFormat:@"%@", model.title];
                borrowView.timeLab.text = [model.createdDate substringToIndex:model.createdDate.length - 3];
                
                [borrowView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@60);
                }];
                
                if (userDic && lastReadDateDic) {
                    lastReadDateStr = [lastReadDateDic objectForKey:@"BorrowDate"];
                }
            }

            if (lastReadDateStr) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *messageDate = [dateFormatter dateFromString:model.createdDate]; //读取到notification模型中的时间
                lastReadDateStr = [lastReadDateStr substringToIndex:lastReadDateStr.length - 5];
                NSDate *lastReadDate = [dateFormatter dateFromString:lastReadDateStr]; //上次读取消息的时间

                NSComparisonResult result = [messageDate compare:lastReadDate]; //两个时间作比较，判断messageDate在过去还是将来
                if (result == NSOrderedAscending || result == NSOrderedSame) {  //messageDate 小或者相等，表示已阅读过
                    [self hiddenRedPoint:model];
                } else if (result == NSOrderedDescending) { //messageDate大，表示没有阅读过
                    [self showRedPoint:model];
                }
            } else {
                [self showRedPoint:model];
            }
        }
        [self createLine];
    }
}

/**
 *  @brief 根据类型隐藏红点
 *
 *  @param model NotificationModel模型
 */
- (void)hiddenRedPoint:(NotificationModel *)model {
    if (model.type == 0) {
        noticeView.redPoint.hidden = YES;
    } else if (model.type == 1) {
        activityView.redPoint.hidden = YES;
    } else if (model.type == 2) {
        financeView.redPoint.hidden = YES;
    } else if (model.type == 3) {
        borrowView.redPoint.hidden = YES;
    }
}

/**
 *  @brief 根据NotificationModel的type显示红点
 *
 *  @param model NotificationModel模型
 */
- (void)showRedPoint:(NotificationModel *)model {
    if (model.type == 0) {
        noticeView.redPoint.hidden = NO;
    } else if (model.type == 1) {
        activityView.redPoint.hidden = NO;
    } else if (model.type == 2) {
        financeView.redPoint.hidden = NO;
    } else if (model.type == 3) {
        borrowView.redPoint.hidden = NO;
    }
}

/**
 *  @brief 根据是否借过款（isBorrow）和 是否出借（isFinance）画实线
 */
- (void)createLine {
    if (isBorrow && !isFinance) {
        //借款view底部画实线
        UIView *borrowBottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        borrowBottomLine.backgroundColor = COLOR_LINE;
        [borrowView addSubview:borrowBottomLine];

        [borrowBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(borrowView);
            make.height.equalTo(@(Line_Height));
        }];

        financeView.hidden = YES;
        [financeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
    }

    if (!isBorrow && isFinance) {
        //出借view顶部画实线
        UIView *financeTopLine = [[UIView alloc] initWithFrame:CGRectZero];
        financeTopLine.backgroundColor = COLOR_LINE;
        [financeView addSubview:financeTopLine];

        [financeTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(financeView);
            make.height.equalTo(@(Line_Height));
        }];

        borrowView.hidden = YES;
        [borrowView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
    }

    if (isBorrow && isFinance) {
        //不需要画线，默认UI的显示就是正确的
    }

    if (!isBorrow && !isFinance) {
        borrowView.hidden = YES;
        [borrowView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];

        financeView.hidden = YES;
        [financeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
    }
}

#pragma mark - 下拉刷新

- (void)setupRefresh {
    mainScroll.header = self.gifHeader3;
}

- (void)headerRereshing {
    [self setTheRequestWithLoading:NO];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [mainScroll.header endRefreshing];
}

/**
 *  @brief 根据type存储消息的阅读时间
 *
 *  @param type 0:公告, 1:活动, 2:出借, 3:信闪贷, 4:新闻
 */
- (void)storeReadTimeWithType:(NSInteger)type {
    //缓存中保存当前的时间
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    NSString *dateStr = [NSString stringWithFormat:@"%@", localDate];

    NSDictionary *userDic = [UserDefaultsUtil getLastReadDateDic];
    if (userDic) {
        NSDictionary *lastReadDateDic = [userDic objectForKey:[UserDefaultsUtil getUser].userId];
        if (lastReadDateDic) {
            dateDic = [lastReadDateDic mutableCopy];
        }
    }

    if (type == 0) {
        [dateDic setObject:dateStr forKey:@"NoticeDate"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:dateDic forKey:[NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]];
        [UserDefaultsUtil setLastReadDateDic:dict];
    } else if (type == 1) {
        [dateDic setObject:dateStr forKey:@"EventDate"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:dateDic forKey:[NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]];
        [UserDefaultsUtil setLastReadDateDic:dict];
    } else if (type == 2) {
        [dateDic setObject:dateStr forKey:@"FinanceDate"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:dateDic forKey:[NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]];
        [UserDefaultsUtil setLastReadDateDic:dict];
    } else if (type == 3) {
        [dateDic setObject:dateStr forKey:@"BorrowDate"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:dateDic forKey:[NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]];
        [UserDefaultsUtil setLastReadDateDic:dict];
    } else if (type == 4) {
        [dateDic setObject:dateStr forKey:@"NewsDate"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:dateDic forKey:[NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]];
        [UserDefaultsUtil setLastReadDateDic:dict];
    }
}

#pragma mark - 点击事件 和 block回调

- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  @brief 根据type判断进入页面
 *
 *  @param type 0:公告, 1:活动, 2:出借, 3:信闪贷, 4:新闻
 */
- (void)pushToViewControllerWithType:(NSInteger)type {
    [self storeReadTimeWithType:type];
    if (type == 0 || type == 1 || type == 2 || type == 3) {
        //跳转到消息列表页面
        MessageViewController *messageVC = [[MessageViewController alloc] init];
        messageVC.type = type;
        [self.navigationController pushViewController:messageVC animated:YES];
    }
    //新闻跳转到最新消息详情页面
    if (type == 4) {
        NSString *urlStr = [RequestURL getNodeJsH5URL:APP_Campaing_news_List_URL withIsSign:NO];
        NewsViewController *newsViewController = [[NewsViewController alloc] initWithTitle:@"新闻动态" webUrlString:urlStr];
        newsViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newsViewController animated:YES];
    }
}

#pragma mark - 消息分类Webservice

- (void)setTheRequestWithLoading:(BOOL)showLoading {

    NSDictionary *contentDic = @{
        @"userId" : [Utility shareInstance].isLogin ? [UserDefaultsUtil getUser].userId : @"0",
    };
    if (showLoading == YES) {
        [self showDataLoading];
    }
    [self requestCategoryNotificationWebServiceWithParam:contentDic];
}

/**
 *  消息分类数据请求
 *
 *  @param params userId 字典
 */
- (void)requestCategoryNotificationWebServiceWithParam:(NSDictionary *)params {
    NSString *requestURL = [RequestURL getRequestURL:NotificationCategoryURL param:params];
    [WebService postRequest:requestURL param:params JSONModelClass:[NotificationResponseModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {

            [self hideLoading];
            NotificationResponseModel *responseModel = responseObject;
            if (responseModel.news) {
                newsModel = responseModel.news;
                newsView.hidden = NO;
                newsView.detailLab.text = responseModel.news.title;
                newsView.timeLab.text = responseModel.news.createdDate;
                
                [newsView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@60);
                }];
            }
            [dataSource removeAllObjects];
            [dataSource addObjectsFromArray:responseModel.notifications];
            [self refreshUI:dataSource];
        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
