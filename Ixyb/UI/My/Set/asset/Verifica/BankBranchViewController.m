//
//  BankBranchViewController.m
//  Ixyb
//
//  Created by wang on 15/10/22.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "BankBranchModel.h"
#import "BankBranchViewController.h"
#import "MJExtension.h"
#import "NoDataView.h"
#import "Utility.h"
#import "WebService.h"
#import "XYTableView.h"
@interface BankBranchViewController () {
    XYTableView *provinceTable;
    NSMutableArray *dataArray;
    MBProgressHUD *hud;
    NoDataView *noDataView;
}
@end

@implementation BankBranchViewController
- (void)setNav {
    self.navItem.title = XYBString(@"string_bank_branch_name", @"支行名称");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    dataArray = [NSMutableArray array];

    [self creatTheTableView];
    [self creatTheNodataView];
    [self requestBankBranch:@{
        @"cityCode" : self.cityCodeStr,
        @"code" : self.bankTypeNumber
    }];
}

- (void)creatTheTableView {

    provinceTable = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    provinceTable.backgroundColor = COLOR_COMMON_CLEAR;
    //    oneTable.scrollEnabled = NO;
    provinceTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    provinceTable.delegate = self;
    provinceTable.dataSource = self;
    [provinceTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:provinceTable];

    [provinceTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 41)];
    headView.backgroundColor = COLOR_BG;
    provinceTable.tableHeaderView = headView;

    UIImageView *image_Info = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_info_gray"]];
    [headView addSubview:image_Info];
    [image_Info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.centerY.equalTo(headView.mas_centerY);
    }];

    UILabel *remaindTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindTitleLab.text = @"当以下列表无您的开户支行时,可选择附近的支行";
    remaindTitleLab.textColor = COLOR_AUXILIARY_GREY;
    remaindTitleLab.font = WEAK_TEXT_FONT_11;
    [headView addSubview:remaindTitleLab];
    [remaindTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView.mas_centerY);
        make.left.equalTo(image_Info.mas_right).offset(2);
    }];
    [XYCellLine initWithBottomLineAtSuperView:headView];
}

- (void)creatTheNodataView {

    noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    noDataView.hidden = YES;
    [self.view addSubview:noDataView];

    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark-- tableView delegate method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Cell_Height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = COLOR_COMMON_WHITE;
    if (dataArray.count > 0) {

        BranchsModel *model = dataArray[indexPath.row];
        cell.textLabel.text = model.brabank_name;
        cell.textLabel.font = TEXT_FONT_16;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }

    UIImageView *verlineImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    verlineImage.image = [UIImage imageNamed:@"onePoint"];
    [cell addSubview:verlineImage];
    [verlineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell);
        make.bottom.equalTo(cell.mas_bottom);
        make.height.equalTo(@1);
    }];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BankBranchModel *bankBranchModel = dataArray[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
    NSDictionary *contentDic = @{ @"bankBranch" : bankBranchModel

    };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBankBranchData" object:contentDic];
}

/****************************4.17	查询支行信息接口*****************************/
- (void)requestBankBranch:(NSDictionary *)dic {
    [self showDataLoading];
    NSString *requestURL = [RequestURL getRequestURL:BankBranchURL param:dic];
    [WebService postRequest:requestURL param:dic JSONModelClass:[BankBranchModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        BankBranchModel *bankBranch = responseObject;
        if (bankBranch.resultCode == 1) {
            NSArray *arr = bankBranch.branchs;
            //            NSArray *provinceArray = [BankBranchModel objectArrayWithKeyValuesArray:arr];
            [dataArray addObjectsFromArray:arr];
            [provinceTable reloadData];
            if (dataArray.count == 0) {
                noDataView.hidden = NO;
            } else {
                noDataView.hidden = YES;
            }
        }
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
