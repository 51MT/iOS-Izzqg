//
//  BirthdayViewController.m
//  Ixyb
//
//  Created by wangjianimac on 15/12/15.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BirthdayViewController.h"
#import "Utility.h"
#import "WebService.h"

@interface BirthdayViewController () {
    MBProgressHUD *hud;
}

@end

@implementation BirthdayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initUI {
    self.navItem.title = XYBString(@"string_birthday", @"生日");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
    [button setTitle:XYBString(@"string_ok", @"确定") forState:UIControlStateNormal];
    button.titleLabel.font = TEXT_FONT_14;
    [button addTarget:self action:@selector(clickTheRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];

    self.view.backgroundColor = COLOR_BG;
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    self.datePicker.backgroundColor = COLOR_COMMON_WHITE;
    [self.datePicker setTimeZone:[NSTimeZone systemTimeZone]];
    [self.datePicker setDate:[DateTimeUtil dateFromString:@"1900-01-01"] animated:YES];
    [self.datePicker setMinimumDate:[DateTimeUtil dateFromString:@"1900-01-01"]];
    [self.datePicker setMaximumDate:[NSDate date]];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    //[self.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.datePicker];

    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(150));
    }];
}

- (void)initData {
    User *user = [UserDefaultsUtil getUser];

    if (user.birthDate) {
        NSDate *currentDate = [DateTimeUtil dateFromString:user.birthDate];
        [self.datePicker setDate:currentDate animated:YES];
    }
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickTheRightBtn:(id)sender {

    NSString *datePickerStr = [DateTimeUtil stringLineFromDate:[self.datePicker date]];

    // 获得当前UIPickerDate所在的时间
    NSDictionary *contentDic = @{ @"userId" : [UserDefaultsUtil getUser].userId,
                                  @"nickName" : @"",
                                  @"sex" : @"",
                                  @"birthDate" : datePickerStr
    };

    [self callUpdateUserInfoWebService:contentDic];
}

/*****************************修改用户信息接口**********************************/
- (void)callUpdateUserInfoWebService:(NSDictionary *)dictionary {

    [self showDataLoading];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    NSString *urlPath = [RequestURL getRequestURL:UserUpdateInfoURL param:params];

    [WebService postRequest:urlPath param:params JSONModelClass:[ResponseModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {

            [self hideLoading];

            if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishedUpdateBirthdaySuccess:)]) {
                [self.navigationController popViewControllerAnimated:YES];
                [self.delegate didFinishedUpdateBirthdaySuccess:self];
            }

        }

        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }

    ];
}

@end
