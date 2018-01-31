//
//  ScanLoginViewController.m
//  Ixyb
//
//  Created by wang on 2017/2/14.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ScanLoginViewController.h"
#import "Utility.h"
#import "WebService.h"

@interface ScanLoginViewController ()

@end

@implementation ScanLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self createUI];
}

- (void)initNav {
    self.navItem.title = XYBString(@"scan_code_login", @"扫码登录");
    self.view.backgroundColor = COLOR_BG;
    
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil
                                       action:nil];
    negativeSpacer.width = -12; //这个数值可以根据情况自由变化
}

-(void)clickBackBtn:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)createUI
{
    UIImageView * imageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Computer"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.navBar.mas_bottom).offset(70);
    }];
    
    UILabel * tipsLabel1 = [[UILabel alloc]init];
    tipsLabel1.font = TEXT_FONT_16;
    tipsLabel1.textColor = COLOR_MAIN_GREY;
    tipsLabel1.text = XYBString(@"xyb_login_qr", @"信用宝网站登录确认");
    [self.view addSubview:tipsLabel1];
    [tipsLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(22);
    }];
    
    UILabel * tipsLabel2 = [[UILabel alloc]init];
    tipsLabel2.font = TEXT_FONT_12;
    tipsLabel2.textColor = COLOR_NEWADDARY_GRAY;
    tipsLabel2.text = XYBString(@"xyb_login_aq", @"为保障账户安全，请确认是本人操作");
    [self.view addSubview:tipsLabel2];
    [tipsLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(tipsLabel1.mas_bottom).offset(9);
    }];
    
    //出借按钮
    ColorButton * qrLoginBut = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, 175.f, Button_Height) Title:XYBString(@"str_qr_login", @"确认登录") ByGradientType:leftToRight];
    [qrLoginBut addTarget:self action:@selector(clickQrLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:qrLoginBut];
    [qrLoginBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.bottom.equalTo(@(-84));
        make.width.equalTo(@(175));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    ColorButton * scancelBut = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, 175.f, Button_Height) Title:XYBString(@"str_cancel", @"取消") ByGradientType:leftToRight];
    [scancelBut setBackgroundImage:[ColorUtil imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [scancelBut setTitleColor:COLOR_AUXILIARY_GREY forState:UIControlStateNormal];
    [scancelBut setTitleColor:COLOR_COMMON_BLACK_TRANS forState:UIControlStateHighlighted];
    [scancelBut setBackgroundImage:[ColorUtil imageWithColor:[UIColor clearColor]] forState:UIControlStateHighlighted];
    [scancelBut addTarget:self action:@selector(clickScancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:scancelBut];
    [scancelBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.top.equalTo(qrLoginBut.mas_bottom).offset(24);
        make.width.equalTo(@(175));
        make.centerX.equalTo(self.view.mas_centerX);
    }];

}


//确认登录
-(void)clickQrLoginButton:(id)sender
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject: [UserDefaultsUtil getUser].userId forKey:@"userId"];
    [params setObject:self.qcodeCode forKey:@"loginCode"];
    [self requestTheQrcodeLoginWebServiceWithParam:params];
}

//取消
-(void)clickScancelButton:(id)sender
{
    if (self.blcok) {
        self.blcok();
    }
    [self.navigationController popViewControllerAnimated:YES];
  
}

/****************************扫码登录******************************/
- (void)requestTheQrcodeLoginWebServiceWithParam:(NSDictionary *)param {
    NSString *requestURL = [RequestURL getRequestURL:QrcodeLoginURL param:param];
    [self showDataLoading];
    [WebService postRequest:requestURL param:param JSONModelClass:[ResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ResponseModel * response = responseObject;
        [self hideLoading];
        if (response.resultCode == 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
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
