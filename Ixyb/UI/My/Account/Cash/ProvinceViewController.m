//
//  ProvinceViewController.m
//  Ixyb
//
//  Created by wang on 15/7/8.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "ProvinceViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "XYTableView.h"
#import "MJExtension.h"
#import "ProvinceModel.h"

#import "CityViewController.h"

@interface ProvinceViewController () {
    XYTableView *provinceTable;
    NSMutableArray *dataArray;
    MBProgressHUD *hud;
}
@end

@implementation ProvinceViewController

- (void)setNav {

    self.navItem.title = XYBString(@"str_choose_province", @"选择省市");

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

    [self requestAreas:@{
        @"code" : @"0"
    }];
}

- (void)creatTheTableView {

    provinceTable = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    provinceTable.backgroundColor = COLOR_COMMON_CLEAR;
    provinceTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    provinceTable.delegate = self;
    provinceTable.dataSource = self;
    [provinceTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:provinceTable];

    [provinceTable mas_makeConstraints:^(MASConstraintMaker *make) {
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

        AreasModel *model = dataArray[indexPath.row];
        cell.textLabel.text = model.name;
    }

    UIImageView *verlineImage = [[UIImageView alloc] init];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CityViewController *cityVC = [[CityViewController alloc] init];
    cityVC.provinceModel = dataArray[indexPath.row];
    [self.navigationController pushViewController:cityVC animated:YES];
}

/****************************4.16	查询省市信息接口******************************/
- (void)requestAreas:(NSDictionary *)dic {
    [self showDataLoading];
    NSString *urlPath = [RequestURL getRequestURL:AreasURL param:dic];
    [WebService postRequest:urlPath param:dic JSONModelClass:[ProvinceModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        ProvinceModel *province = responseObject;
        if (province.resultCode == 1) {
            NSArray *arr = province.areas;
            [dataArray addObjectsFromArray:arr];
            [provinceTable reloadData];
        }
    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {

            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
