//
//  AddressCountyViewController.m
//  Ixyb
//
//  Created by wangjianimac on 15/12/15.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "AddressCountyViewController.h"
#import "XYTableView.h"

#import "AreaModel.h"
#import "CityModel.h"
#import "MJExtension.h"
#import "Utility.h"
#import "WebService.h"

@interface AddressCountyViewController () {
    XYTableView *countyTable;
    NSMutableArray *dataArray;
    MBProgressHUD *hud;
}
@end

@implementation AddressCountyViewController

- (void)setNav {

    self.navItem.title = XYBString(@"string_choust_area", @"选择区");

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
    [self requestAreas:@{ @"code" : _cityModel.code }];
}

- (void)creatTheTableView {

    countyTable = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    countyTable.backgroundColor = COLOR_COMMON_CLEAR;
    countyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    countyTable.delegate = self;
    countyTable.dataSource = self;
    [countyTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:countyTable];

    [countyTable mas_makeConstraints:^(MASConstraintMaker *make) {
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
        AreaModel *model = dataArray[indexPath.row];
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

    AreaModel *areaModel = dataArray[indexPath.row];
    NSArray *viewControllers = self.navigationController.viewControllers;
    [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count - 4] animated:YES];
    NSDictionary *contentDic = @{ @"province" : _provinceModel,
                                  @"city" : _cityModel,
                                  @"county" : areaModel
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProvinceCityCountyData" object:contentDic];
}

/****************************查询省市区信息接口******************************/
- (void)requestAreas:(NSDictionary *)dic {
    [self showDataLoading];
    NSString *urlPath = [RequestURL getRequestURL:UserAreaURL param:dic];
    [WebService postRequest:urlPath param:dic JSONModelClass:[ProvinceModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        ProvinceModel *province = responseObject;
        if (province.resultCode == 1) {
            NSArray *arr = province.areas;
            [dataArray addObjectsFromArray:arr];
            [countyTable reloadData];
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
