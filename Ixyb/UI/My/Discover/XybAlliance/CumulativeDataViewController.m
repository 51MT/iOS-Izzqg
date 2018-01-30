//
//  CumulativeDataViewController.m
//  Ixyb
//
//  Created by wang on 16/8/25.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "CumulativeDataViewController.h"
#import "OneFriendsRecordViewController.h"
#import "AllianceDataView.h"
#import "Utility.h"

@interface CumulativeDataViewController ()

@end

@implementation CumulativeDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self creatTheRankView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setNav {
    self.navItem.title = XYBString(@"str_cumulative_data", @"累计数据");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatTheRankView {

    NSString *all = @"ALL";
    AllianceDataView *unionDataView = [[AllianceDataView alloc] initWithFrame:CGRectZero dateQueryStr:all];
    [self.view addSubview:unionDataView];
    unionDataView.block =^(NSString *  text,NSString * totalAmount,NSString * investId,NSInteger type)
    {
        OneFriendsRecordViewController * oneFriendsRecord = [[OneFriendsRecordViewController alloc]init];
        oneFriendsRecord.namePhone = text;
        if (type == 0 ) {
            oneFriendsRecord.recodeType = oneRecord;
        }else if (type == 1)
        {
            oneFriendsRecord.recodeType = twoRecord;
        }
        oneFriendsRecord.investMoney = totalAmount;
        oneFriendsRecord.investId = investId;
        [self.navigationController pushViewController:oneFriendsRecord animated:YES];
    };
    [unionDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}

@end
