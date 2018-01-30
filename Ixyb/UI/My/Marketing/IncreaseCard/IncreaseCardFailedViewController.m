//
//  IncreaseCardFailedViewController.m
//  Ixyb
//
//  Created by wang on 16/9/19.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "IncreaseCardCell.h"
#import "IncreaseCardFailedViewController.h"
#import "IncreaseCardModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "NoDataView.h"
#import "ShakeGameViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "WordAlertView.h"
#import "XYTableView.h"

@interface IncreaseCardFailedViewController () <UITableViewDelegate, UITableViewDataSource, IncreaseCardCellDelegate>

    {
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

@implementation IncreaseCardFailedViewController

- (void)setNav {
    self.navItem.title = XYBString(@"string_increase_card_my", @"已失效优惠券");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [button setImage:[UIImage imageNamed:@"question_mark"] forState:UIControlStateNormal];
    [button setTitle:@"使用规则" forState:UIControlStateNormal];
    button.titleLabel.font = TEXT_FONT_14;
    button.frame = CGRectMake(0.0f, 0.0f, 80.0f, 40.0f);
    [button addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
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
    self.invalidCardPageIndex = 0;
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
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];

    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
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
    tipLabel.text = XYBString(@"string_increase_null_card", @"您还没有无效的优惠券");
    tipLabel.font = TEXT_FONT_14;
    tipLabel.textColor = COLOR_LIGHT_GREY;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(notDataImageView.mas_bottom).offset(Margin_Top);
        make.left.equalTo(@Margin_Length);
        make.width.equalTo(@(MainScreenWidth - 20));
    }];
    bgView.hidden = YES;
    [self requestInvalidCardsWithShowLoading:YES];
}
- (void)increaseCardCell:(IncreaseCardCell *)cell didClickIndex:(NSInteger)index {
}

- (void)requestInvalidCardsWithShowLoading:(BOOL)showLoading {
    //刷新过期和未过期的收益提升卡
    NSDictionary *paramVaild = @{
        @"pageSize" : PageSize,
        @"page" : [NSNumber numberWithInteger:self.invalidCardPageIndex],
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"state" : @1
    };
    if (showLoading == YES) {
        [self showDataLoading];
    }

    NSString *urlPath = [RequestURL getRequestURL:UserIncreaseCardURL param:paramVaild];
    [WebService postRequest:urlPath param:paramVaild JSONModelClass:[IncreaseCardModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            [self.mainTable.header endRefreshing];
            IncreaseCardModel *IncreaseCard = responseObject;
            if (IncreaseCard.resultCode == 1) {
                NSArray *detailsArr = IncreaseCard.cards;
                if (self.invalidCardPageIndex == 0) {
                    [self.invalidCardArray removeAllObjects];
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
            [self.mainTable.header endRefreshing];
            [_mainTable reloadData];
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

- (void)refreshUI {
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
    [self.mainTable reloadData];

    //到达最后一页
    if ([self.invalidCardArray count] < [PageSize integerValue]) {
        self.mainTable.footer.hidden = YES;
        [self.mainTable.footer noticeNoMoreData];
    }
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

- (void)headerRereshing {
    [self.validCardArray removeAllObjects];
    [self.invalidCardArray removeAllObjects];
    self.isShowInvalidCard = NO;
    [self requestInvalidCardsWithShowLoading:NO];
}

- (void)footerRereshing {
    [self requestInvalidCardsWithShowLoading:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
