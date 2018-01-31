//
//  SleepRewardAccountViewController.m
//  Ixyb
//
//  Created by wang on 15/8/8.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "HomeCircleProgressView.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MoreProductViewController.h"
#import "SleepRewardAccountCell.h"
#import "SleepRewardAccountModel.h"
#import "SleepRewardAccountOverDueViewController.h"
#import "SleepRewordAmountModel.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "XYTableView.h"

#define VIEW_TAG_TITLE_LABEL 50501
#define VIEW_TAG_PROGRES_VIEW 50502
#define VIEW_TAG_SLEEP_REWARD_AMOUNT_LABEL 50503
#define VIEW_TAG_END_TIME_LABEL 50504
#define VIEW_TAG_THAW_SLEEP_REWORD_AMOUNT_LABEL 50505
#define VIEW_TAG_ALL_THAW_SLEEP_CASH_AMOUNT_LABEL 50506

@interface SleepRewardAccountOverDueViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) XYTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic) NSInteger pageIndex;

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UILabel *scoreLabel;

@end

@implementation SleepRewardAccountOverDueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = 0;
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
    [self setupRefresh];
    [self setTheRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    self.dataArray = [NSMutableArray arrayWithCapacity:20];
}

- (void)initUI {
    [self initNav];
    [self initTableView];
}


- (void)initTableView {
    self.tableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = COLOR_BG;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SleepRewardAccountCell class] forCellReuseIdentifier:@"sleepRewardAccountCell"];
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom).offset(-1);
    }];


    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 206)];
    headView.backgroundColor = COLOR_COMMON_WHITE;
    self.headView = headView;
    self.tableView.tableHeaderView = headView;
    UIImageView *backImage = [[UIImageView alloc] init];
    backImage.backgroundColor = COLOR_LIGHT_GREY; //COLOR_STRONG_RED;
    backImage.layer.masksToBounds = YES;
    backImage.layer.cornerRadius = 65;

    [headView addSubview:backImage];

    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView.mas_centerX);
        make.top.equalTo(@30);
        make.width.height.equalTo(@130);
    }];

    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.font = FONT_TEXT_LARGE_MORE; //[UIFont systemFontOfSize:30.f];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreLabel.textColor = COLOR_COMMON_WHITE;
    self.scoreLabel.adjustsFontSizeToFitWidth = YES;
    self.scoreLabel.text = @"0.00";
    [backImage addSubview:self.scoreLabel];

    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImage.mas_centerX);
        //        make.centerY.equalTo(backImage.mas_centerY).offset(-5);
        make.baseline.equalTo(backImage.mas_centerY);
        make.left.equalTo(backImage.mas_left).offset(2);
        make.right.equalTo(backImage.mas_right).offset(-2);
    }];

    UILabel *scoreTitleLab = [[UILabel alloc] init];
    scoreTitleLab.text = XYBString(@"string_overdue_hb", @"已过期红包(元)");
    scoreTitleLab.font = TEXT_FONT_14;
    scoreTitleLab.textColor = COLOR_COMMON_WHITE;
    [backImage addSubview:scoreTitleLab];
    [scoreTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImage.mas_centerY).offset(10);
        make.centerX.equalTo(backImage.mas_centerX);
    }];

    UILabel *tip4Label = [[UILabel alloc] init];
    tip4Label.text = XYBString(@"string_details", @"明细");
    tip4Label.textAlignment = NSTextAlignmentCenter;
    tip4Label.textColor = COLOR_LIGHT_GREY;
    tip4Label.backgroundColor = COLOR_COMMON_WHITE;
    tip4Label.font = [UIFont systemFontOfSize:14.0f];
    [headView addSubview:tip4Label];

    [tip4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headView.mas_centerX);
        make.bottom.equalTo(self.headView.mas_bottom);
        make.width.equalTo(@46);
    }];

    UIView *bottomSplitView = [[UIView alloc] init];
    bottomSplitView.backgroundColor = COLOR_LINE;
    [self.headView addSubview:bottomSplitView];
    [bottomSplitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tip4Label);
        make.height.equalTo(@(Line_Height));
        make.left.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
    }];

    [self.headView bringSubviewToFront:tip4Label];
}


- (void)clickThawButton:(id)sender {
    MoreProductViewController *moreProductVC = [[MoreProductViewController alloc] init];
    moreProductVC.type = ClickTheDQB;
    moreProductVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moreProductVC animated:YES];
}

- (void)initNav {
    self.navItem.title = XYBString(@"str_account_redenvelope", @"过期红包");
    self.view.backgroundColor = COLOR_BG;

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = TEXT_FONT_14;
    [button setTitle:@"使用规则" forState:UIControlStateNormal];
    button.frame = CGRectMake(0.0f, 0.0f, 80.0f, 40.0f);
    [button addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
}

- (void)clickRightBtn:(id)sender {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_BonusRules_URL withIsSign:NO];
    NSString *titleStr = XYBString(@"str_thawingrole_redenvelope", @"红包解冻规则说明");
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setTheRequest {
    [self updateSleepReward];
    NSDictionary *param = @{
                            @"userId" : [UserDefaultsUtil getUser].userId,
                            @"pageSize" : PageSize,
                            @"rewardState" : @1,
                            @"page" : [NSNumber numberWithInteger:self.pageIndex],
                            };
    [self callUpdateSleepRewardWebService:param];
}

#pragma mark - 设置刷新的方法
- (void)setupRefresh {
    self.tableView.header = self.gifHeader3;
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}
- (void)headerRereshing {
    _pageIndex = 0;
    [_dataArray removeAllObjects];
    [self setTheRequest];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [self.tableView.header endRefreshing];
}

- (void)footerRereshing {
    
    if (_pageIndex * 20 > _dataArray.count) {
        
        [self.tableView.footer noticeNoMoreData];
        
    } else {
        
        [self setTheRequest];
        [self.tableView.footer endRefreshing];
    }
}

- (void)callUpdateSleepRewardWebService:(NSDictionary *) param{
    [self showDataLoading];
    NSString *urlPath = [RequestURL getRequestURL:UserAccountGetSleepRewardAccountDetailURL param:param];
    [WebService postRequest:urlPath param:param JSONModelClass:[SleepRewardAccountModel class]
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self hideLoading];
                        SleepRewardAccountModel *sleepReward = responseObject;
                        if (sleepReward.resultCode == 1) {
                            NSArray *detailsArr = sleepReward.sleepRewardAccountDetailList;
                            [self.dataArray addObjectsFromArray:detailsArr];
                            [self.tableView reloadData];
                            if (self.pageIndex * 20 > _dataArray.count) {
                                self.tableView.footer.hidden = YES;
                                [ self.tableView.footer noticeNoMoreData];
                                
                            } else {
                                self.tableView.footer.hidden = NO;
                                [ self.tableView.footer resetNoMoreData];
                            }
                            
                        }
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
    self.pageIndex ++ ;
}

- (void)updateSleepReward {

    NSDictionary *param = @{
        @"userId" : [UserDefaultsUtil getUser].userId,
    };

    [self showDataLoading];
    NSString *urlPath = [RequestURL getRequestURL:UserAccountGetSleepRewardAccountURL param:param];
    [WebService postRequest:urlPath param:param JSONModelClass:[SleepRewordAmountModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            SleepRewordAmountModel *sleepReward = responseObject;
            if (sleepReward.resultCode == 1) {
                double overDue = [sleepReward.sleepRewordAmount.sleepCashOverdueAmount doubleValue];
                if (overDue == 0) {
                    self.scoreLabel.text = @"0.00";
                } else {
                    NSString *overDueAmountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", overDue]];
                    self.scoreLabel.text = overDueAmountStr;
                }
            }
        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Double_Cell_Height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SleepRewardAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sleepRewardAccountCell"
                                                                   forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SleepRewardAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sleepRewardAccountCell"];
    }
    SleepRewardAccountDetailListModel *detail = self.dataArray[indexPath.row];
    cell.model = detail;
    cell.isBeoverdue = NO;
    return cell;
}

@end
