//
//  CityViewController.m
//  Ixyb
//
//  Created by wang on 15/7/8.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "CityViewController.h"

#import "Utility.h"
#import "WebService.h"
#import "AreaModel.h"
#import "CityModel.h"
#import "MJExtension.h"
#import "XYTableView.h"

@interface CityViewController () {
    XYTableView *cityTable;
    NSMutableArray *dataArray;
    MBProgressHUD *hud;
}
@end

@implementation CityViewController

- (void)setNav {

    self.navItem.title = XYBString(@"str_chouse_city", @"选择市");

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
        @"code" : _provinceModel.code
    }];
}

- (void)creatTheTableView {

    cityTable = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    cityTable.backgroundColor = COLOR_COMMON_CLEAR;
    //    oneTable.scrollEnabled = NO;
    cityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    cityTable.delegate = self;
    cityTable.dataSource = self;
    [cityTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:cityTable];

    [cityTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
        CityModel *model = dataArray[indexPath.row];
        cell.textLabel.text = model.name;
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

    CityModel *cityModel = dataArray[indexPath.row];

    NSArray *viewControllers = self.navigationController.viewControllers;
    [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count - 3] animated:YES];
    NSDictionary *contentDic = @{ @"province" : _provinceModel,
                                  @"city" : cityModel
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCityData" object:contentDic];
}

/****************************4.16	查询省市信息接口******************************/
- (void)requestAreas:(NSDictionary *)dic {
    [self showDataLoading];
    NSString *urlPath = [RequestURL getRequestURL:AreasURL param:dic];
    [WebService postRequest:urlPath param:dic JSONModelClass:[ProvinceModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        ProvinceModel * province = responseObject;
        if (province.resultCode == 1) {
            NSArray *arr = province.areas;
            [dataArray addObjectsFromArray:arr];
            [cityTable reloadData];
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
