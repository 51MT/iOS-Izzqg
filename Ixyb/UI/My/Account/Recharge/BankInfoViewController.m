//
//  BankInfoViewController.m
//  Ixyb
//
//  Created by wang on 15/11/19.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "BankInfoView.h"
#import "BankInfoViewController.h"
#import "BankTableViewCell.h"
#import "Utility.h"
#import "WebService.h"
#import "XYTableView.h"

@interface BankInfoViewController () {

    NSArray *bankArr;
    XYTableView *_selectTab;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation BankInfoViewController

- (void)setNav {
    self.navItem.title = XYBString(@"string_chouse_card_type", @"选择银行");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = COLOR_COMMON_WHITE;

    self.dataArray = [[NSMutableArray alloc] init];
    [self setNav];
    NSString *bankJson = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"json"];

    bankArr = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:bankJson] options:NSJSONReadingMutableContainers error:nil];
    [self creatTheBankInfoView];
    [self requstData];
}

- (void)creatTheBankInfoView {

    UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectZero];
    detailLab.backgroundColor = COLOR_COMMON_WHITE;
    detailLab.textAlignment = NSTextAlignmentCenter;
    detailLab.font = TEXT_FONT_12;
    detailLab.tintColor = COLOR_MAIN_GREY;
    [self.view addSubview:detailLab];
    NSMutableAttributedString *addRateStr = [[NSMutableAttributedString alloc] initWithString:XYBString(@"string_tip_bank_instrict", @"*限额仅供参考,以实际支付界面为准")];
    [addRateStr addAttributes:@{ NSForegroundColorAttributeName : COLOR_STRONG_RED } range:NSMakeRange(0, 1)];
    detailLab.attributedText = addRateStr;
    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@215);
    }];

    UIImageView *pointsImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    pointsImage.image = [UIImage imageNamed:@"onePoint"];
    [self.view addSubview:pointsImage];
    [self.view insertSubview:detailLab aboveSubview:pointsImage];
    [pointsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.centerY.equalTo(detailLab.mas_centerY);
        make.height.equalTo(@1);
    }];

    _selectTab = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _selectTab.dataSource = self;
    _selectTab.delegate = self;
    _selectTab.rowHeight = 60;
    _selectTab.tag = 201;
    _selectTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_selectTab registerClass:[BankTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_selectTab];

    [_selectTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(detailLab.mas_bottom).offset(5);
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BankTableViewCell *cell = (BankTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[BankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.BankInfo = self.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.navigationController popViewControllerAnimated:YES];
    BankInfoModel *BankInfo = [self.dataArray objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BANKINFO" object:BankInfo];
}

- (void)requstData {
    [self showDataLoading];
    NSString *requestURL = [RequestURL getRequestURL:RechargeLimitURL param:[NSDictionary dictionary]];
    [WebService postRequest:requestURL param:[NSDictionary dictionary] JSONModelClass:[BankInfoModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        BankInfoModel *bankInfo = responseObject;
        if (bankInfo.resultCode == 1) {
            NSArray *payLimitsArr = bankInfo.payLimits;
            [self.dataArray addObjectsFromArray:payLimitsArr];
            [_selectTab reloadData];
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
