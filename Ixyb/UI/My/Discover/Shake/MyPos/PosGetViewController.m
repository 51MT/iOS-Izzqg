//
//  PosGetViewController.m
//  Ixyb
//
//  Created by wang on 16/4/7.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "PosGetViewController.h"

#import "AddressViewController.h"
#import "OrderHaveSubmitViewController.h"
#import "PosPreApplyModel.h"
#import "Utility.h"
#import "WebService.h"

#define ADDRESSLABTAG 1002

@interface PosGetViewController () <AddressViewControllerDelegate> {

    MBProgressHUD *hud;
    ColorButton *finishBtn;
}

@end

@implementation PosGetViewController

- (void)setNav {

    self.navItem.title = XYBString(@"string_sure_pos", @"确认领取");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)isDismissViewController:(BOOL)isDismiss {
    if (isDismiss) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self setUI];
    [self setTheRequest];
}

- (void)setUI {

    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:headerView];

    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
    }];

    UIView *splitView = [[UIView alloc] init];
    splitView.backgroundColor = COLOR_LINE;
    [headerView addSubview:splitView];

    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.height.equalTo(@(Line_Height));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];

    UIImageView *posImageView = [[UIImageView alloc] init];
    posImageView.image = [UIImage imageNamed:@"myposImageView"];
    [headerView addSubview:posImageView];

    [posImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.top.equalTo(@11);
        make.bottom.equalTo(@(-11));
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = COLOR_MAIN_GREY;
    titleLabel.text = @"刷卡器一台";
    titleLabel.font = TEXT_FONT_16;
    [headerView addSubview:titleLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(posImageView.mas_right).offset(13);
        make.centerY.equalTo(headerView.mas_centerY);
    }];

    UILabel *realPriceLab = [[UILabel alloc] init];
    //    realPriceLab.textColor = COLOR_MAIN_GREY;
    //    realPriceLab.text = @"实付 0元";
    NSArray *attrArray = @[
        @{
            @"kStr" : @"￥0.00",
            @"kColor" : COLOR_STRONG_RED,
            @"kFont" : TEXT_FONT_16,
        },
        @{
            @"kStr" : @"元",
            @"kColor" : COLOR_MAIN_GREY,
            @"kFont" : TEXT_FONT_16,
        }
    ];
    realPriceLab.attributedText = [Utility multAttributedString:attrArray];
    //    realPriceLab.font = TEXT_FONT_16;
    [headerView addSubview:realPriceLab];

    [realPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right).offset(-Margin_Length);
        make.top.equalTo(headerView.mas_top).offset(17);

    }];

    UILabel *oldPriceLab = [[UILabel alloc] init];
    oldPriceLab.textColor = COLOR_AUXILIARY_GREY;
    oldPriceLab.text = @"￥140元";
    oldPriceLab.font = TEXT_FONT_12;
    [headerView addSubview:oldPriceLab];

    [oldPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right).offset(-Margin_Length);
        make.bottom.equalTo(headerView.mas_bottom).offset(-12);

    }];

    UILabel *lineLab = [[UILabel alloc] init];
    lineLab.backgroundColor = COLOR_LIGHT_GREY;
    [headerView addSubview:lineLab];

    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(oldPriceLab.mas_centerY);
        make.height.equalTo(@(0.5));
        make.width.equalTo(@30);
        make.right.equalTo(oldPriceLab.mas_right);
    }];

    UIView *addressInfoView = [[UIView alloc] init];
    addressInfoView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:addressInfoView];

    [addressInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(headerView.mas_bottom).offset(20);
        make.height.equalTo(@45);
    }];

    UIView *split11View = [[UIView alloc] init];
    split11View.backgroundColor = COLOR_LINE;
    [addressInfoView addSubview:split11View];

    [split11View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressInfoView.mas_top);
        make.height.equalTo(@(Line_Height));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];

    UIView *split22View = [[UIView alloc] init];
    split22View.backgroundColor = COLOR_LINE;
    [addressInfoView addSubview:split22View];

    [split22View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(addressInfoView.mas_bottom);
        make.height.equalTo(@(Line_Height));
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@0);
    }];

    UILabel *psStyleLab = [[UILabel alloc] init];
    psStyleLab.text = @"配送方式";
    psStyleLab.textColor = COLOR_MAIN_GREY;
    psStyleLab.font = TEXT_FONT_16;
    [addressInfoView addSubview:psStyleLab];

    [psStyleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressInfoView.mas_centerY);
        make.left.equalTo(@Margin_Length);
    }];

    UILabel *psResultLab = [[UILabel alloc] init];
    psResultLab.text = @"顺丰到付";
    psResultLab.textColor = COLOR_AUXILIARY_GREY;
    psResultLab.font = TEXT_FONT_16;
    [addressInfoView addSubview:psResultLab];

    [psResultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressInfoView.mas_centerY);
        make.right.equalTo(@-Margin_Length);
    }];

    UIView *addressView = [[UIView alloc] init];
    addressView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:addressView];

    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(addressInfoView.mas_bottom);
    }];

    UIImageView *arrowImage = [[UIImageView alloc] init];
    arrowImage.image = [UIImage imageNamed:@"cell_arrow"];
    [addressView addSubview:arrowImage];

    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressView.mas_centerY);
        make.right.equalTo(addressView.mas_right).offset(-Margin_Length);
    }];

    UILabel *selectAddressLab = [[UILabel alloc] init];
    selectAddressLab.text = @"请选择收货地址";
    selectAddressLab.textColor = COLOR_MAIN_GREY;
    selectAddressLab.font = TEXT_FONT_16;
    selectAddressLab.tag = ADDRESSLABTAG;
    selectAddressLab.numberOfLines = 0;
    [addressView addSubview:selectAddressLab];

    [selectAddressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressView.mas_centerY);
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@-30);
        make.bottom.equalTo(addressView.mas_bottom).offset(-Margin_Length);
    }];

    UIView *split33View = [[UIView alloc] init];
    split33View.backgroundColor = COLOR_LINE;
    [addressView addSubview:split33View];

    [split33View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(addressView.mas_bottom);
        make.height.equalTo(@(Line_Height));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];

    UIButton *setAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setAddressBtn addTarget:self action:@selector(clickTheAddressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:setAddressBtn];
    [setAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(addressView);
    }];

    finishBtn= [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Button_Height) Title:@"确认并领取" ByGradientType:leftToRight];
    [finishBtn addTarget:self action:@selector(clickTheFinishBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBtn];
    finishBtn.isColorEnabled = NO;

    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@(Cell_Height));
        make.top.equalTo(addressView.mas_bottom).offset(20);
    }];
}

- (void)clickTheAddressBtn:(id)sender {
    AddressViewController *addressViewController = [[AddressViewController alloc] init];
    addressViewController.delegate = self;
    [self.navigationController pushViewController:addressViewController animated:YES];
}

- (void)clickTheFinishBtn:(id)sender {
    UserAddress *userAddress = [UserDefaultsUtil getCurrentUserAddress];
    if (userAddress != nil) {
        [self mposApplyRequest];
    } else {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_please_input_address", @"请输入发货地址") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
}

- (void)didFinishedUpdateAddressSuccess:(AddressViewController *)addressViewController {
    [self setTheRequest];
}

- (void)setTheRequest {

    NSDictionary *contentDic = @{
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"prizeLogId" : _prizeLogId
    };

    [self callWebService:contentDic];
}

- (void)mposApplyRequest {

    UserAddress *userAddress = [UserDefaultsUtil getCurrentUserAddress];
    NSDictionary *contentDic = @{
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"prizeLogId" : _prizeLogId,
        @"recipients" : userAddress.recipients,
        @"mobilePhone" : userAddress.mobilePhone,
        @"detail" : userAddress.detail,
        @"provinceCode" : userAddress.provinceCode,
        @"provinceName" : userAddress.provinceName,
        @"cityName" : userAddress.cityName,
        @"cityCode" : userAddress.cityCode,
        @"countyName" : userAddress.countyName,
        @"countyCode" : userAddress.countyCode
    };

    [self requestMposApplyWebService:contentDic];
}

- (void)callWebService:(NSDictionary *)dic {
    [self showDataLoading];
    NSString *requestURL = [RequestURL getRequestURL:ShakerMposPreApplyURL param:dic];
    [WebService postRequest:requestURL param:dic JSONModelClass:[PosPreApplyModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        PosPreApplyModel *pospre = responseObject;
        if (pospre.resultCode == 1) {
            UILabel *addressLab = (UILabel *) [self.view viewWithTag:ADDRESSLABTAG];
            if (pospre.userAddress.recipients) {
                NSString *textStr = [NSString stringWithFormat:@"收货人：%@  %@\n收货地址：%@%@%@%@", pospre.userAddress.recipients, pospre.userAddress.mobilePhone, pospre.userAddress.provinceName, pospre.userAddress.cityName, pospre.userAddress.countyName, pospre.userAddress.detail];
                // 调整行间距
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textStr];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:6];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textStr length])];
                addressLab.attributedText = attributedString;
                addressLab.textColor = COLOR_AUXILIARY_GREY;
                addressLab.font = TEXT_FONT_14;
                UserAddress *userAddress = [[UserAddress alloc] init];
                userAddress.userId = pospre.userAddress.userId;
                userAddress.recipients = pospre.userAddress.recipients;
                userAddress.mobilePhone = pospre.userAddress.mobilePhone;
                userAddress.detail = pospre.userAddress.detail;
                userAddress.provinceName = pospre.userAddress.provinceName;
                userAddress.provinceCode = pospre.userAddress.provinceCode;
                userAddress.cityName = pospre.userAddress.cityName;
                userAddress.cityCode = pospre.userAddress.cityCode;
                userAddress.countyName = pospre.userAddress.countyName;
                userAddress.countyCode = pospre.userAddress.countyCode;
                [UserDefaultsUtil setUserAddress:userAddress];
            }
            UserAddress *userAddress = [UserDefaultsUtil getCurrentUserAddress];
            if (userAddress) {
                finishBtn.isColorEnabled = YES;
            } else {
                finishBtn.isColorEnabled = NO;
            }
        }
    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

- (void)requestMposApplyWebService:(NSDictionary *)dic {
    [self showDataLoading];
    NSString *requestURL = [RequestURL getRequestURL:ShakerMposApplyURL param:dic];
    [WebService postRequest:requestURL param:dic JSONModelClass:[ResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        ResponseModel *response = responseObject;
        if (response.resultCode == 1) {
            self.changeStatue(1);
            OrderHaveSubmitViewController *orderHaveSubmitVC = [[OrderHaveSubmitViewController alloc] init];
            [self.navigationController pushViewController:orderHaveSubmitVC animated:NO];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
