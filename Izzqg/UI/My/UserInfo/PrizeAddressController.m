//
//  PrizeAddressController.m
//  Ixyb
//
//  Created by wang on 16/10/24.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "PrizeAddressController.h"
#import "UserMessageResponseModel.h"
#import "Utility.h"
#import "WebService.h"

@interface PrizeAddressController ()
{
    MBProgressHUD *hud;
    
    AreasModel *provinceModel;
    CityModel *cityModel;
    AreaModel *areaModel;
}
@end

@implementation PrizeAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self callUserMyWebService:@{ @"userId" : [UserDefaultsUtil getUser].userId }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadProvinceCityCountyData:) name:@"reloadProvinceCityCountyData" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initUI {
    
    NSString *navigationItemTitle = XYBString(@"string_edit_address", @"编辑收货地址");
    if ([UserDefaultsUtil getUser]) {
        User *user = [UserDefaultsUtil getUser];
        if (!user.isHaveAddr) {
            navigationItemTitle = XYBString(@"string_set_address", @"设置收货地址");
        }
    }
    self.navItem.title = navigationItemTitle;
    
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
    [button setTitle:XYBString(@"string_save", @"保存") forState:UIControlStateNormal];
    button.titleLabel.font = TEXT_FONT_14;
    [button addTarget:self action:@selector(clickTheRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
    
    UIView *inputBgView = [[UIView alloc] initWithFrame:CGRectZero];
    inputBgView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:inputBgView];
    [inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom).offset(20);
        make.height.equalTo(@(Cell_Height * 4 + Line_Height * 5));
    }];
    
    UIView *splitView1 = [[UIView alloc] initWithFrame:CGRectZero];
    splitView1.backgroundColor = COLOR_LINE;
    [inputBgView addSubview:splitView1];
    [splitView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@(0));
        make.height.equalTo(@(Line_Height));
    }];
    
    self.recipientsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.recipientsLabel.font = TEXT_FONT_16;
    self.recipientsLabel.text = XYBString(@"string_receiver_name", @"收货人姓名");
    self.recipientsLabel.textColor = COLOR_MAIN_GREY;
    [inputBgView addSubview:self.recipientsLabel];
    [self.recipientsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(splitView1.mas_bottom);
        make.left.equalTo(@Margin_Length);
        make.width.equalTo(@85);
        make.height.equalTo(@(Cell_Height));
    }];
    
    self.recipientsTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.recipientsTextField.placeholder = XYBString(@"string_please_input_receiver_name", @"请输入收货人姓名");
    self.recipientsTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.recipientsTextField.keyboardType = UIKeyboardTypeDefault;
    self.recipientsTextField.font = TEXT_FONT_14;
    self.recipientsTextField.textColor = COLOR_AUXILIARY_GREY;
    [inputBgView addSubview:self.recipientsTextField];
    
    [self.recipientsTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(splitView1.mas_bottom);
        make.left.equalTo(self.recipientsLabel.mas_right).offset(Text_Margin_Length);
        make.right.equalTo(@-Margin_Length);
        make.height.equalTo(@(Cell_Height));
    }];
    
    UIView *splitView2 = [[UIView alloc] initWithFrame:CGRectZero];
    splitView2.backgroundColor = COLOR_LINE;
    [inputBgView addSubview:splitView2];
    [splitView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recipientsLabel.mas_bottom);
        make.right.equalTo(@(0));
        make.left.equalTo(@Margin_Length);
        make.height.equalTo(@(Line_Height));
    }];
    
    self.mobilePhoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.mobilePhoneLabel.font = TEXT_FONT_16;
    self.mobilePhoneLabel.text = XYBString(@"string_phone_number", @"手机号码");
    self.mobilePhoneLabel.textColor = COLOR_MAIN_GREY;
    [inputBgView addSubview:self.mobilePhoneLabel];
    [self.mobilePhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(splitView2.mas_bottom);
        make.left.equalTo(@Margin_Length);
        make.width.equalTo(@80);
        make.height.equalTo(@(Cell_Height));
    }];
    
    self.mobilePhoneTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.mobilePhoneTextField.placeholder = XYBString(@"string_please_input_phone_number", @"请输入手机号码");
    self.mobilePhoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.mobilePhoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.mobilePhoneTextField.font = TEXT_FONT_14;
    self.mobilePhoneTextField.textColor = COLOR_AUXILIARY_GREY;
    [inputBgView addSubview:self.mobilePhoneTextField];
    
    [self.mobilePhoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(splitView2.mas_bottom);
        make.left.equalTo(self.mobilePhoneLabel.mas_right).offset(Text_Margin_Length);
        make.right.equalTo(@-Margin_Length);
        make.height.equalTo(@(Cell_Height));
    }];
    
    UIView *splitView3 = [[UIView alloc] initWithFrame:CGRectZero];
    splitView3.backgroundColor = COLOR_LINE;
    [inputBgView addSubview:splitView3];
    [splitView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mobilePhoneLabel.mas_bottom);
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@(0));
        make.height.equalTo(@(Line_Height));
    }];
    
    self.areaLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.areaLabel.font = TEXT_FONT_16;
    self.areaLabel.text = XYBString(@"string_at_area", @"所在区域");
    self.areaLabel.textColor = COLOR_MAIN_GREY;
    [inputBgView addSubview:self.areaLabel];
    
    [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(splitView3.mas_bottom);
        make.left.equalTo(@Margin_Length);
        make.width.equalTo(@80);
        make.height.equalTo(@(Cell_Height));
    }];
    
    self.selectAreaLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.selectAreaLabel.font = TEXT_FONT_14;
    self.selectAreaLabel.textColor = COLOR_AUXILIARY_GREY;
    self.selectAreaLabel.text = @"";
    self.selectAreaLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *selectAreaLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateSaveUserAddress:)];
    [self.selectAreaLabel addGestureRecognizer:selectAreaLabelTap];
    [inputBgView addSubview:self.selectAreaLabel];
    
    [self.selectAreaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(splitView3.mas_bottom);
        make.left.equalTo(self.areaLabel.mas_right).offset(Text_Margin_Length);
        make.right.equalTo(@-25);
        make.height.equalTo(@(Cell_Height));
    }];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    arrowImageView.image = [UIImage imageNamed:@"cell_arrow"];
    [inputBgView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Margin_Length));
        make.centerY.equalTo(self.areaLabel.mas_centerY);
    }];
    
    UIView *splitView4 = [[UIView alloc] initWithFrame:CGRectZero];
    splitView4.backgroundColor = COLOR_LINE;
    [inputBgView addSubview:splitView4];
    [splitView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.areaLabel.mas_bottom);
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@(0));
        make.height.equalTo(@(Line_Height));
    }];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.detailLabel.font = TEXT_FONT_16;
    self.detailLabel.numberOfLines = 2;
    self.detailLabel.text = XYBString(@"string_detail_location", @"详细地址");
    self.detailLabel.textColor = COLOR_MAIN_GREY;
    [inputBgView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(splitView4.mas_bottom);
        make.left.equalTo(@Margin_Length);
        make.width.equalTo(@80);
        make.height.equalTo(@(Cell_Height));
    }];
    
    self.detailTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.detailTextField.placeholder = XYBString(@"string_please_input_detail_location", @"请输入详细地址");
    self.detailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.detailTextField.keyboardType = UIKeyboardTypeDefault;
    self.detailTextField.font = TEXT_FONT_14;
    self.detailTextField.textColor = COLOR_AUXILIARY_GREY;
    [inputBgView addSubview:self.detailTextField];
    [self.detailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(splitView4.mas_bottom);
        make.left.equalTo(self.detailLabel.mas_right).offset(Text_Margin_Length);
        make.right.equalTo(@-Margin_Length);
        make.height.equalTo(@(Cell_Height));
    }];
    
    UIView *splitView5 = [[UIView alloc] initWithFrame:CGRectZero];
    splitView5.backgroundColor = COLOR_LINE;
    [inputBgView addSubview:splitView5];
    [splitView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom);
        make.left.right.equalTo(@(0));
        make.height.equalTo(@(Line_Height));
    }];
}

- (void)initData {
    
    self.userAddress = [UserDefaultsUtil getCurrentUserAddress];
    if (self.userAddress) {
        if (self.userAddress.recipients)
            self.recipientsTextField.text = self.userAddress.recipients;
        
        if (self.userAddress.mobilePhone)
            self.mobilePhoneTextField.text = self.userAddress.mobilePhone;
        
        if (self.userAddress.provinceName)
            self.selectAreaLabel.text = [NSString stringWithFormat:@"%@ %@ %@", self.userAddress.provinceName, self.userAddress.cityName, self.userAddress.countyName];
        
        if (self.userAddress.detail)
            self.detailTextField.text = self.userAddress.detail;
    } else {
        self.userAddress = [[UserAddress alloc] init];
    }
}

- (void)updateSaveUserAddress:(id)sender {
    AddressProvinceViewController *provinceVC = [[AddressProvinceViewController alloc] init];
    [self.navigationController pushViewController:provinceVC animated:YES];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickTheRightBtn:(id)sender {
    
    [self.recipientsTextField resignFirstResponder];
    [self.mobilePhoneTextField resignFirstResponder];
    [self.detailTextField resignFirstResponder];
    
    if (!self.userAddress) {
        self.userAddress = [[UserAddress alloc] init];
    }
    
    NSString *recipients = [self.recipientsTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *mobilePhone = [self.mobilePhoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *detail = [self.detailTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (recipients.length == 0) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_please_input_receiver_name", @"请输入收货人姓名") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    
    if (recipients.length > 10) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_reveiver_name_most_ten", @"收货人姓名最多10个字符") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    
    //手机号码
    NSString *errMsg = [Utility checkUserName:mobilePhone];
    if (errMsg != nil) {
        [HUD showPromptViewWithToShowStr:errMsg autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    
    if (self.selectAreaLabel.text.length == 0 || [self.selectAreaLabel.text isEqualToString:@""]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_chouse_area", @"请选择所在区域") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    
    if (detail.length == 0) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_please_input_detail_location", @"请输入详细地址") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    
    if (detail.length > 30) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_location_detail_most_thirty", @"详细地址最多30个字符") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    
    self.userAddress.recipients = recipients;
    self.userAddress.mobilePhone = mobilePhone;
    self.userAddress.detail = detail;
    
    NSDictionary *contentDic = @{
                                 @"userId" : [UserDefaultsUtil getUser].userId,
                                 @"recipients" : self.userAddress.recipients,
                                 @"mobilePhone" : self.userAddress.mobilePhone,
                                 @"detail" : self.userAddress.detail,
                                 @"provinceCode" : self.userAddress.provinceCode,
                                 @"provinceName" : self.userAddress.provinceName,
                                 @"cityName" : self.userAddress.cityName,
                                 @"cityCode" : self.userAddress.cityCode,
                                 @"countyName" : self.userAddress.countyName,
                                 @"countyCode" : self.userAddress.countyCode,
                                 };
    
    [self callUpdateUserAddressWebService:contentDic];
}

- (void)reloadProvinceCityCountyData:(NSNotification *)note {
    NSDictionary *dic = note.object;
    provinceModel = [dic objectForKey:@"province"];
    cityModel = [dic objectForKey:@"city"];
    areaModel = [dic objectForKey:@"county"];
    
    if (!self.userAddress) {
        self.userAddress = [[UserAddress alloc] init];
    }
    
    self.userAddress.provinceName = provinceModel.name;
    self.userAddress.provinceCode = provinceModel.code;
    self.userAddress.cityName = cityModel.name;
    self.userAddress.cityCode = cityModel.code;
    self.userAddress.countyName = areaModel.name;
    self.userAddress.countyCode = areaModel.code;
    
    if (self.userAddress.provinceName)
        self.selectAreaLabel.text = [NSString stringWithFormat:@"%@ %@ %@", self.userAddress.provinceName, self.userAddress.cityName, self.userAddress.countyName];
}

/*****************************修改用户地址接口**********************************/

- (void)callUpdateUserAddressWebService:(NSDictionary *)dictionary {
    
    [self showDataLoading];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    NSString *urlPath = [RequestURL getRequestURL:UserUpdateAddressURL param:params];
    
    [WebService postRequest:urlPath param:params JSONModelClass:[ResponseModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishedUpdateAddressSuccess:)]) {
                            [UserDefaultsUtil setUserAddress:self.userAddress];
                            [self.navigationController popViewControllerAnimated:YES];
                            [self.delegate didFinishedUpdateAddressSuccess:self];
                        }
                        
                    }
     
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }
     
     ];
}

/****************************用户信息接口******************************/
- (void)callUserMyWebService:(NSDictionary *)dictionary {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    NSString *urlPath = [RequestURL getRequestURL:UserMyRequestURL param:params];
    [WebService postRequest:urlPath param:dictionary JSONModelClass:[UserMessageResponseModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        UserMessageResponseModel *userMessage = responseObject;
                        if (userMessage.resultCode == 1) {
                            User *user = [UserDefaultsUtil getUser];
                            user.tel = userMessage.user.mobilePhone;
                            user.userId = userMessage.user.id;
                            user.isBankSaved = userMessage.user.isBankSaved;
                            user.isIdentityAuth = userMessage.user.isIdentityAuth;
                            user.isPhoneAuth = userMessage.user.isPhoneAuth;
                            user.isTradePassword = userMessage.user.isTradePassword;
                            user.recommendCode = userMessage.user.recommendCode;
                            user.score = userMessage.user.score;
                            user.url = userMessage.user.url;
                            user.userName = userMessage.user.username;
                            user.vipLevel = userMessage.user.vipLevel;
                            user.roleName = userMessage.user.roleName;
                            user.bonusState = userMessage.user.bonusState;
                            user.sex = userMessage.user.sex;
                            user.sexStr = userMessage.user.sexStr;
                            user.isHaveAddr = [userMessage.user.isHaveAddr boolValue];
                            user.birthDate = userMessage.user.birthDate;
                            user.nickName = userMessage.user.nickName;
                            user.email = userMessage.user.email;
                            user.isEmailAuth = [userMessage.user.isEmailAuth boolValue];
                            user.isNewUser = userMessage.user.isNewUser;
                            [UserDefaultsUtil setUser:user];
                            
                            if (user.isHaveAddr) {
                                [UserDefaultsUtil setUserAddress:userMessage.userAddress];
                                [self initData];
                            }
                        }
                        
                    }
     
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage){
                           
                       }
     
     ];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
