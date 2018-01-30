//
//  SexViewController.m
//  Ixyb
//
//  Created by wangjianimac on 15/12/14.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "SexViewController.h"
#import "Utility.h"
#import "WebService.h"

#define MAN_TAG 0
#define WOMAN_TAG 1
#define SECRET_TAG 2
#define MAN_TAG_STR @"0"
#define WOMAN_TAG_STR @"1"
#define SECRET_TAG_STR @"2"

@interface SexViewController () {
    MBProgressHUD *hud;
}

@end

@implementation SexViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initUI {
    self.navItem.title = XYBString(@"string_user_sex", @"性别");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    UIView *inputBgView = [[UIView alloc] init];
    inputBgView.backgroundColor = COLOR_COMMON_WHITE;
    inputBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *inputBgViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateSaveSex:)];
    [inputBgView addGestureRecognizer:inputBgViewTap];
    [inputBgViewTap view].tag = MAN_TAG;
    [self.view addSubview:inputBgView];
    [inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom).offset(20);
        make.height.equalTo(@51);
    }];

    UIView *splitView1 = [[UIView alloc] init];
    splitView1.backgroundColor = COLOR_LINE;
    [inputBgView addSubview:splitView1];
    [splitView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@(0));
        make.height.equalTo(@(Line_Height));
    }];

    self.manLabel = [[UILabel alloc] init];
    self.manLabel.font = TEXT_FONT_16;
    self.manLabel.text = XYBString(@"string_user_man", @"男");
    [inputBgView addSubview:self.manLabel];
    [self.manLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputBgView.mas_centerY);
        make.left.equalTo(@Margin_Length);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];

    self.setManSuccessImage = [[UIImageView alloc] init];
    self.setManSuccessImage.image = [UIImage imageNamed:@"set_right"];
    [inputBgView addSubview:self.setManSuccessImage];
    self.setManSuccessImage.hidden = YES;
    [self.setManSuccessImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputBgView.mas_centerY);
        make.right.equalTo(inputBgView.mas_right).offset(-Margin_Length);
        make.width.equalTo(@20);
        make.height.equalTo(@14);
    }];

    UIView *splitView2 = [[UIView alloc] init];
    splitView2.backgroundColor = COLOR_LINE;
    [inputBgView addSubview:splitView2];
    [splitView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(@(0));
        make.height.equalTo(@(Line_Height));
    }];

    UIView *inputBgView2 = [[UIView alloc] init];
    inputBgView2.backgroundColor = COLOR_COMMON_WHITE;
    inputBgView2.userInteractionEnabled = YES;
    UITapGestureRecognizer *inputBgViewTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateSaveSex:)];
    [inputBgView2 addGestureRecognizer:inputBgViewTap2];
    [inputBgViewTap2 view].tag = WOMAN_TAG;
    [self.view addSubview:inputBgView2];
    [inputBgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(inputBgView.mas_bottom);
        make.height.equalTo(@50);
    }];

    self.womanLabel = [[UILabel alloc] init];
    self.womanLabel.font = TEXT_FONT_16;
    self.womanLabel.text = XYBString(@"string_user_woman", @"女");
    [inputBgView2 addSubview:self.womanLabel];
    [self.womanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputBgView2.mas_centerY);
        make.left.equalTo(@Margin_Length);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];

    self.setWomanSuccessImage = [[UIImageView alloc] init];
    self.setWomanSuccessImage.image = [UIImage imageNamed:@"set_right"];
    [inputBgView2 addSubview:self.setWomanSuccessImage];
    self.setWomanSuccessImage.hidden = YES;
    [self.setWomanSuccessImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputBgView2.mas_centerY);
        make.right.equalTo(inputBgView2.mas_right).offset(-Margin_Length);
        make.width.equalTo(@20);
        make.height.equalTo(@14);
    }];

    UIView *inputBgView3 = [[UIView alloc] init];
    inputBgView3.backgroundColor = COLOR_COMMON_WHITE;
    inputBgView3.userInteractionEnabled = YES;
    UITapGestureRecognizer *inputBgViewTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateSaveSex:)];
    [inputBgView3 addGestureRecognizer:inputBgViewTap3];
    [inputBgViewTap3 view].tag = SECRET_TAG;
    [self.view addSubview:inputBgView3];
    [inputBgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(inputBgView2.mas_bottom);
        make.height.equalTo(@51);
    }];

    UIView *splitView3 = [[UIView alloc] init];
    splitView3.backgroundColor = COLOR_LINE;
    [inputBgView3 addSubview:splitView3];
    [splitView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@(0));
        make.height.equalTo(@(Line_Height));
    }];

    self.secretLabel = [[UILabel alloc] init];
    self.secretLabel.font = TEXT_FONT_16;
    self.secretLabel.text = XYBString(@"string_user_confidential", @"保密");
    [inputBgView3 addSubview:self.secretLabel];
    [self.secretLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputBgView3.mas_centerY);
        make.left.equalTo(@Margin_Length);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];

    self.setSecretSuccessImage = [[UIImageView alloc] init];
    self.setSecretSuccessImage.image = [UIImage imageNamed:@"set_right"];
    [inputBgView3 addSubview:self.setSecretSuccessImage];
    self.setSecretSuccessImage.hidden = YES;
    [self.setSecretSuccessImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputBgView3.mas_centerY);
        make.right.equalTo(inputBgView3.mas_right).offset(-Margin_Length);
        make.width.equalTo(@20);
        make.height.equalTo(@14);
    }];

    UIView *splitView4 = [[UIView alloc] init];
    splitView4.backgroundColor = COLOR_LINE;
    [inputBgView3 addSubview:splitView4];
    [splitView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(@(0));
        make.height.equalTo(@(Line_Height));
    }];
}

- (void)initData {

    User *user = [UserDefaultsUtil getUser];

    if ([user.sex intValue] == 0 || [user.sexStr isEqualToString:XYBString(@"string_user_man", @"男")]) {
        self.setManSuccessImage.hidden = NO;
        self.setWomanSuccessImage.hidden = YES;
        self.setSecretSuccessImage.hidden = YES;
    } else if ([user.sex intValue] == 1 || [user.sexStr isEqualToString:XYBString(@"string_user_woman", @"女")]) {
        self.setManSuccessImage.hidden = YES;
        self.setWomanSuccessImage.hidden = NO;
        self.setSecretSuccessImage.hidden = YES;
    } else {
        self.setManSuccessImage.hidden = YES;
        self.setWomanSuccessImage.hidden = YES;
        self.setSecretSuccessImage.hidden = NO;
    }
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateSaveSex:(id)sender {
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *) sender;
    NSString *sexStr;
    if ([singleTap view].tag == MAN_TAG) {
        self.setManSuccessImage.hidden = NO;
        self.setWomanSuccessImage.hidden = YES;
        self.setSecretSuccessImage.hidden = YES;
        sexStr = MAN_TAG_STR;
    } else if ([singleTap view].tag == WOMAN_TAG) {
        self.setManSuccessImage.hidden = YES;
        self.setWomanSuccessImage.hidden = NO;
        self.setSecretSuccessImage.hidden = YES;
        sexStr = WOMAN_TAG_STR;
    } else {
        self.setManSuccessImage.hidden = YES;
        self.setWomanSuccessImage.hidden = YES;
        self.setSecretSuccessImage.hidden = NO;
        sexStr = SECRET_TAG_STR;
    }

    NSDictionary *contentDic = @{
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"nickName" : @"",
        @"sex" : sexStr,
        @"birthDate" : @""
    };

    [self callUpdateUserInfoWebService:contentDic];
}

/*****************************修改用户信息接口**********************************/
- (void)creatTheHud {

    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.square = YES;
        [hud show:YES];
        [self.view addSubview:hud];
    }
}

- (void)callUpdateUserInfoWebService:(NSDictionary *)dictionary {

    [self showDataLoading];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    NSString *urlPath = [RequestURL getRequestURL:UserUpdateInfoURL param:params];

    [WebService postRequest:urlPath param:params JSONModelClass:[ResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [self hideLoading];

        if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishedUpdateSexSuccess:)]) {
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate didFinishedUpdateSexSuccess:self];
        }

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

@end
