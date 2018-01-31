//
//  IncreaseCardViewController.m
//  Ixyb
//
//  Created by wang on 15/8/7.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "IncreaseCardCell.h"
#import "IncreaseCardFailedViewController.h"
#import "IncreaseCardModel.h"
#import "IncreaseCardViewController.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MoreProductViewController.h"
#import "NoDataView.h"
#import "ShakeGameViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "WordAlertView.h"
#import "XYTableView.h"

@interface IncreaseCardViewController () <UITableViewDelegate, UITableViewDataSource, IncreaseCardCellDelegate> {
    UIView *bgView;
}
@property (nonatomic, strong) XYTableView *mainTable;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic) NSInteger invalidCardPageIndex;

@property (nonatomic, strong) NSMutableArray *validCardArray;
@property (nonatomic, strong) NSMutableArray *invalidCardArray;
@property (nonatomic) BOOL isShowInvalidCard;

@property (nonatomic, strong) UIButton *seeInvalidCardButton;
@property (nonatomic, strong) XYButton *bgViewSeeInvalidCardButton;

@end

@implementation IncreaseCardViewController

- (void)setNav {
    self.navigationItem.title = XYBString(@"str_increase_card_my", @"我的优惠券");

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [button setImage:[UIImage imageNamed:@"question_mark"] forState:UIControlStateNormal];
    [button setTitle:XYBString(@"str_gift_userrole", @"使用规则") forState:UIControlStateNormal];
    button.titleLabel.font = TEXT_FONT_14;
    button.frame = CGRectMake(0.0f, 0.0f, 80.0f, 40.0f);
    [button addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12; //这个数值可以根据情况自由变化
    self.navigationItem.rightBarButtonItems = @[ negativeSpacer, rightButtonItem ];
}

- (void)clickBackBtn:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightBtn:(id)sender {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_CardUseRules_URL withIsSign:NO];
    NSString *titleStr = XYBString(@"str_increase_card_use_rule", @"优惠券使用规则");
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)clickGoToButton:(id)sender {

    ShakeGameViewController *shakeGameViewController = [[ShakeGameViewController alloc] init];
    shakeGameViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shakeGameViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];

    self.dataArray = [[NSMutableArray alloc] init];
    self.validCardArray = [[NSMutableArray alloc] init];
    self.invalidCardArray = [[NSMutableArray alloc] init];
    self.isShowInvalidCard = NO;

    self.mainTable = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.backgroundColor = COLOR_BG;
    [self.mainTable registerClass:[IncreaseCardCell class] forCellReuseIdentifier:@"cell"];
    self.mainTable.header = self.gifHeader3;
    self.mainTable.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [self.mainTable.footer noticeNoMoreData];
    self.mainTable.footer.hidden = YES;
    [self.view addSubview:self.mainTable];

    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    //    [bgView setTranslatesAutoresizingMaskIntoConstraints:NO];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];

    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    UIImageView *notDataImageView = [[UIImageView alloc] init];
    notDataImageView.image = [UIImage imageNamed:@"noDataImage"];
    [bgView addSubview:notDataImageView];
    [notDataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@50);
        make.centerX.equalTo(bgView.mas_centerX);
    }];

    UILabel *tipLabel = [[UILabel alloc] init];
    [bgView addSubview:tipLabel];
    tipLabel.text = XYBString(@"str_increase_null_card", @"您还没有可用的优惠券");
    tipLabel.font = TEXT_FONT_14;
    tipLabel.textColor = COLOR_LIGHT_GREY;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(notDataImageView.mas_bottom).offset(Margin_Top);
        make.left.equalTo(@Margin_Length);
        make.width.equalTo(@(MainScreenWidth - 20));
    }];

    self.bgViewSeeInvalidCardButton = [[XYButton alloc] initWithSubordinationButtonTitle:XYBString(@"str_check_lose_effic_increase_card", @"查看已失效优惠券>>") isUserInteractionEnabled:YES];
    [bgView addSubview:self.bgViewSeeInvalidCardButton];
    self.bgViewSeeInvalidCardButton.titleLabel.font = TEXT_FONT_12;

    [self.bgViewSeeInvalidCardButton addTarget:self action:@selector(clickSeeInvalidCardButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgViewSeeInvalidCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(30);
        make.centerX.equalTo(@0);
    }];

    self.mainTable.backgroundView.hidden = YES;
    bgView.hidden = YES;

    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 50)];
    self.mainTable.tableFooterView = footView;
    self.mainTable.tableFooterView.hidden = YES;
    self.seeInvalidCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [footView addSubview:self.seeInvalidCardButton];
    self.seeInvalidCardButton.titleLabel.font = TEXT_FONT_12;
    [self.seeInvalidCardButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [self.seeInvalidCardButton setBackgroundColor:COLOR_COMMON_CLEAR];
    [self.seeInvalidCardButton setTitle:XYBString(@"str_check_lose_effic_increase_card", @"查看已失效优惠券>>") forState:UIControlStateNormal];
    [self.seeInvalidCardButton addTarget:self action:@selector(clickSeeInvalidCardButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.seeInvalidCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0);
    }];

    [self requestValidCards];
    [self showDataLoading];
    [self requestInvalidCards];
}

- (void)clickSeeInvalidCardButton:(id)sender {
    IncreaseCardFailedViewController *IncreaseCardFailed = [[IncreaseCardFailedViewController alloc] init];
    IncreaseCardFailed.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:IncreaseCardFailed animated:YES];
}

- (void)increaseCardCell:(IncreaseCardCell *)cell didClickIndex:(NSInteger)index {
    MoreProductViewController *moreProductVC = [[MoreProductViewController alloc] init];
    moreProductVC.hidesBottomBarWhenPushed = YES;
    moreProductVC.type = ClickTheDQB;
    [self.navigationController pushViewController:moreProductVC animated:YES];
}

- (void)requestInvalidCards {
    //刷新过期和未过期的收益提升卡
    NSDictionary *paramVaild = @{
        @"pageSize" : PageSize,
        @"page" : [NSNumber numberWithInteger:self.invalidCardPageIndex],
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"state" : @1
    };

    NSString *urlPath = [RequestURL getRequestURL:UserIncreaseCardURL param:paramVaild];
    [WebService postRequest:urlPath param:paramVaild JSONModelClass:[IncreaseCardModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            [self.mainTable.footer endRefreshing];
            IncreaseCardModel *IncreaseCard = responseObject;
            if (IncreaseCard.resultCode == 1) {
                NSArray *detailsArr = IncreaseCard.cards;
                if (self.invalidCardPageIndex == 0) {
                    [self.invalidCardArray removeAllObjects];
                }
                if (IncreaseCard.overdueCards < 1) {
                    self.bgViewSeeInvalidCardButton.hidden = YES;
                } else {
                    self.bgViewSeeInvalidCardButton.hidden = NO;
                }
                [self.invalidCardArray addObjectsFromArray:detailsArr];
                self.invalidCardPageIndex++;

                if ([detailsArr count] < [PageSize integerValue]) {
                    self.mainTable.footer.hidden = YES;
                    [self.mainTable.footer noticeNoMoreData];
                }

                [self refreshUI];
            }
        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self.mainTable.footer endRefreshing];
            [_mainTable reloadData];
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

- (void)refreshUI {
    //数据回合,刷新
    [self.dataArray removeAllObjects];

    if ([self.validCardArray count]) {
        [self.dataArray addObjectsFromArray:self.validCardArray];
    }

    if (!self.isShowInvalidCard) {
        self.mainTable.tableFooterView.hidden = NO;

        if ([self.validCardArray count] <= 0) {
            self.mainTable.header.hidden = YES;
            bgView.hidden = NO;
            self.mainTable.tableFooterView.hidden = YES;
        } else {
            bgView.hidden = YES;
            self.mainTable.tableFooterView.hidden = NO;
        }

    } else {
        //点击了显示过期收益提升卡
        self.mainTable.tableFooterView.hidden = YES;
        if ([self.invalidCardArray count]) {
            [self.dataArray addObjectsFromArray:self.invalidCardArray];
        }
        if ([self.dataArray count] <= 0) {
            bgView.hidden = NO;
        } else {
            bgView.hidden = YES;
        }
    }
    [self.mainTable reloadData];

    //    //到达最后一页
    if ([self.invalidCardArray count] < [PageSize integerValue]) {
        self.mainTable.footer.hidden = YES;
        [self.mainTable.footer noticeNoMoreData];
    }
}

- (void)requestValidCards {
    //刷新过期和未过期的收益提升卡
    NSDictionary *paramVaild = @{
        @"pageSize" : PageSizeMax,
        @"page" : @0,
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"state" : @0
    };

    NSString *urlPath = [RequestURL getRequestURL:UserIncreaseCardURL param:paramVaild];
    [WebService postRequest:urlPath param:paramVaild JSONModelClass:[IncreaseCardModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            [self.mainTable.header endRefreshing];
            IncreaseCardModel *IncreaseCard = responseObject;
            if (IncreaseCard.resultCode == 1) {
                NSArray *detailsArr = IncreaseCard.cards;
                [self.validCardArray removeAllObjects];
                [self.validCardArray addObjectsFromArray:detailsArr];
                [self refreshUI];
            }
        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self.mainTable.header endRefreshing];
            [_mainTable reloadData];
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

#pragma mark-- tableView delegate method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 134;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    IncreaseCardCell *cell = (IncreaseCardCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[IncreaseCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.index = indexPath.row;
    cell.delegate = self;
    if (self.dataArray.count > 0) {
        cell.increaseCardModel = self.dataArray[indexPath.row];
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    MoreProductViewController *moreProductVC = [[MoreProductViewController alloc] init];
    //    moreProductVC.hidesBottomBarWhenPushed = YES;
    //    moreProductVC.type = ClickTheDQB;
    //    [self.navigationController pushViewController:moreProductVC animated:YES];
}

-(void)headerRereshing {
    [self.validCardArray removeAllObjects];
    [self.invalidCardArray removeAllObjects];
    self.isShowInvalidCard = NO;
    [self requestValidCards];
}

- (void)footerRereshing {
    [self requestInvalidCards];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
