//
//  XtbBorrowDetailViewController.m
//  Ixyb
//
//  Created by dengjian on 2017/9/16.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "XtbBorrowDetailViewController.h"
#import "NoDataView.h"
#import "Utility.h"
#import "XtbDetailResponseModel.h"
#import "BorrowDetailTableViewCell.h"

@interface XtbBorrowDetailViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    XYTableView *myTableView;  //借款记录视图
    NoDataView *noDataView;    //暂无记录
}


@end

@implementation XtbBorrowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createMyTableView];
//    [self createTheBottomView];
}

- (void)createNav {
    
    self.navItem.title = XYBString(@"str_financing_loanDetails", @"借款详情");
    self.view.backgroundColor = COLOR_BG;
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
}

- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createMyTableView {
    
    myTableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    myTableView.backgroundColor = COLOR_COMMON_CLEAR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [myTableView registerClass:[BorrowDetailTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:myTableView];
    
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
    }];
}

/**
 *  @brief 创建风险缓释金View
 */
- (void)createTheBottomView {
    
    UIView *tipSafeView = [[UIView alloc] init];
    tipSafeView.backgroundColor = COLOR_BG;
    [self.view addSubview:tipSafeView];
    
    [tipSafeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    UIView *tipView = [[UIView alloc] init];
    [tipSafeView addSubview:tipView];
    
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tipSafeView.mas_centerX);
        make.centerY.equalTo(tipSafeView.mas_centerY);
    }];
    
    UIImage *img = [UIImage imageNamed:@"bsj_icon"];
    UIImageView *insureImageView = [[UIImageView alloc] initWithImage:img];
    [tipView addSubview:insureImageView];
    
    [insureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0);
        make.size.mas_equalTo(img.size);
        make.bottom.equalTo(tipView.mas_bottom);
    }];
    
    UILabel *tip2Label = [[UILabel alloc] init];
    tip2Label.text = XYBString(@"str_financing_platformRiskProtectMoney", @"风险缓释金保障");
    tip2Label.font = TEXT_FONT_12;
    tip2Label.textColor = COLOR_AUXILIARY_GREY;
    [tipView addSubview:tip2Label];
    
    [tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(insureImageView.mas_centerY);
        make.left.equalTo(insureImageView.mas_right).offset(6.0f);
        make.right.equalTo(tipView.mas_right);
    }];
}

#pragma
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    DetailListModel *listModel = [_dataSource objectAtIndex:section];
    return listModel.pairItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BorrowDetailTableViewCell *cell = (BorrowDetailTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell =  [[BorrowDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DetailListModel *listModel = [_dataSource objectAtIndex:indexPath.section];
    PairItemModel *dataModel = [listModel.pairItems objectAtIndex:indexPath.row];
    cell.model = dataModel;
    
    return cell;
}

#pragma
#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, MainScreenWidth, 55)];
    headView.backgroundColor = COLOR_BG;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, MainScreenWidth, 45)];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [headView addSubview:backView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(Margin_Length, 7.5, MainScreenWidth, 30)];
    titleLab.font = BIG_TEXT_FONT_17;
    titleLab.textColor = COLOR_TITLE_GREY;
    DetailListModel *listModel = [_dataSource objectAtIndex:section];
    titleLab.text = listModel.name;
    [backView addSubview:titleLab];
    
    [XYCellLine initWithTopLineAtSuperView:headView];
    [XYCellLine initWithBottomLine_2_AtSuperView:headView];
    
    return headView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 36.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55.f;
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
