//
//  MyCouponsViewController.m
//  Ixyb
//
//  Created by 董镇华 on 16/9/19.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "CardsModel.h"
#import "CardsModel.h"
#import "IncreaseCardCell.h"
#import "IncreaseCardModel.h"
#import "MyCouponsViewController.h"
#import "NoDataView.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "XYScrollView.h"
#import "XYTableView.h"

@interface MyCouponsViewController () <UITableViewDataSource, UITableViewDelegate> {

    UIView *backView;
    XYButton *notUseButton; //不使用优惠券的button
    NoDataView *noDataView;
    XYTableView *myTableView;
}

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *canUseArr; //储存可用优惠券
@property (nonatomic, strong) NSMutableArray *noUseArr;  //储存不可用优惠券

@end

@implementation MyCouponsViewController

- (void)setNav {
    self.navItem.title = XYBString(@"string_increase_card_my", @"我的优惠券");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"]
                                                                                       imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(clickBackBtn:)];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"使用规则" forState:UIControlStateNormal];
    button.titleLabel.font = TEXT_FONT_14;
    button.frame = CGRectMake(0.0f, 0.0f, 80.0f, 40.0f);
    [button addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                             target:nil
                             action:nil];
    negativeSpacer.width = -12; //这个数值可以根据情况自由变化
    self.navItem.rightBarButtonItems =
        @[ negativeSpacer, rightButtonItem ];
}

- (void)clickBackBtn:(id)sender {
    if (self.canUseArr.count == 0 && self.noUseArr.count == 0) {
        self.couponsBlock(@"", @"暂无券可用", 0.00);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightBtn:(id)sender {
    NSString *requestURL = [RequestURL getNodeJsH5URL:App_CardUseRules_URL withIsSign:NO];
    NSString *titleStr = XYBString(@"str_increase_card_use_rule", @"优惠券使用规则");
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:requestURL];
    [self.navigationController pushViewController:webView animated:YES];
}

//懒加载
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)canUseArr {
    if (_canUseArr == nil) {
        _canUseArr = [[NSMutableArray alloc] init];
    }
    return _canUseArr;
}

- (NSMutableArray *)noUseArr {
    if (_noUseArr == nil) {
        _noUseArr = [[NSMutableArray alloc] init];
    }
    return _noUseArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self createNoDataView];
    [self createMyTableView];
    [self requestMyCouponsWebServiceWithParam:@{ @"userId" : [UserDefaultsUtil getUser].userId,
                                                 @"productType" : self.productType,
                                                 @"projectId" : self.projectId }];
}

- (void)createNoDataView {
    noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    noDataView.titleLab.text = @"你没有可用的优惠券";
    noDataView.hidden = YES;
    [self.view addSubview:noDataView];

    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

/**
 *  顶部视图：不使用优惠券
 */
- (void)createMyTableViewHeaderView {
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 60)];
    backView.backgroundColor = COLOR_COMMON_CLEAR;

    notUseButton = [[XYButton alloc] initWithGeneralBtnTitle:@"不使用优惠券"
                                                  titleColor:COLOR_MAIN_GREY
                                    isUserInteractionEnabled:YES];
    [notUseButton addTarget:self
                     action:@selector(clickTheNoUseCouponsButton:)
           forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:notUseButton];

    [notUseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(backView).offset(Margin_Length);
        make.width.equalTo(@(MainScreenWidth - 30));
        make.height.equalTo(@(Cell_Height));
    }];
}

- (void)clickTheNoUseCouponsButton:(id)sender {
    if (self.canUseArr.count > 0) {
        self.couponsBlock(@"", @"未使用", 0.00);
    } else {
        self.couponsBlock(@"", @"暂无券可用", 0.00);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createMyTableView {
    myTableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    myTableView.backgroundColor = COLOR_COMMON_CLEAR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;

    [self createMyTableViewHeaderView];
    myTableView.tableHeaderView = backView;
    [myTableView registerClass:[IncreaseCardCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:myTableView];

    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 && self.canUseArr.count == 0) {
        return 20;
    } else if (section == 1 && self.canUseArr.count != 0) {
        return 40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1 && self.noUseArr.count != 0) {
        UIView *headerView = [self createTheSectionHeaderView];
        return headerView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IncreaseCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.singleCardModle = [self.dataSource[indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 134;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        SingleIncreaseCardModel *model = [self.dataSource[indexPath.section] objectAtIndex:indexPath.row];
        NSString *couponsName;
        if (model.cardType == 0) {
            couponsName = @"专属加息券";
        } else if (model.cardType == 1) {
            couponsName = @"加息券";
        }
        self.couponsBlock(model.ID, couponsName, [model.rate doubleValue]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 *  @return 段头
 */
- (UIView *)createTheSectionHeaderView {
    CGFloat hight;
    if (self.canUseArr.count > 0) {
        hight = 40.f;
    } else {
        hight = 20.f;
    }

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, hight)];
    headerView.backgroundColor = COLOR_COMMON_CLEAR;

    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = TEXT_FONT_10;
    titleLab.textColor = COLOR_AUXILIARY_GREY;
    titleLab.text = @"以下券不满足使用条件";
    [headerView addSubview:titleLab];

    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.bottom.equalTo(headerView.mas_bottom);
    }];

    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = COLOR_LINE;
    [headerView addSubview:lineView1];

    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleLab.mas_left).offset(-5);
        make.centerY.equalTo(titleLab.mas_centerY);
        make.height.equalTo(@(Line_Height));
        make.width.equalTo(@(36));
    }];

    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = COLOR_LINE;
    [headerView addSubview:lineView2];

    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_right).offset(5);
        make.centerY.equalTo(titleLab.mas_centerY);
        make.height.equalTo(@(Line_Height));
        make.width.equalTo(@(36));
    }];

    return headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取所有的加息券
- (void)requestMyCouponsWebServiceWithParam:(NSDictionary *)params {
    NSString *requestURL = [RequestURL getRequestURL:IncreaseCardInvestCanUseURL param:params];
    [self showDataLoading];
    [WebService postRequest:requestURL param:params JSONModelClass:[CardsModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {

            [self hideLoading];
            CardsModel *responseModle = responseObject;
            for (SingleIncreaseCardModel *model in responseModle.cards) {
                if (model.isUsable == YES) {
                    [self.canUseArr addObject:model];
                } else {
                    [self.noUseArr addObject:model];
                }
            }
            [self.dataSource addObject:self.canUseArr];
            [self.dataSource addObject:self.noUseArr];
            if (self.noUseArr.count == 0 && self.canUseArr.count == 0) {
                myTableView.hidden = YES;
                noDataView.hidden = NO;
            }
            [myTableView reloadData];
        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
