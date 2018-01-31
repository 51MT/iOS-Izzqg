//
//  NickNameViewController.m
//  Ixyb
//
//  Created by wangjianimac on 15/12/14.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "NickNameViewController.h"
#import "Utility.h"
#import "WebService.h"

@interface NickNameViewController () {
    MBProgressHUD *hud;
}

@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initUI {
    self.navItem.title = XYBString(@"string_nick_name", @"昵称");

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

    self.view.backgroundColor = COLOR_BG;

    UIView *inputBgView = [[UIView alloc] init];
    inputBgView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:inputBgView];
    [inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom).offset(20);
        make.height.equalTo(@51);
    }];

    UIView *split1View = [[UIView alloc] init];
    split1View.backgroundColor = COLOR_LINE;
    [inputBgView addSubview:split1View];
    [split1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@(0));
        make.height.equalTo(@(Line_Height));
    }];

    self.nickNameTextField = [[UITextField alloc] init];
    self.nickNameTextField.placeholder = XYBString(@"string_please_input_nickname", @"请输入昵称");
    self.nickNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nickNameTextField.keyboardType = UIKeyboardTypeDefault;
    self.nickNameTextField.font = TEXT_FONT_16;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nickNameTextFieldChange) name:UITextFieldTextDidChangeNotification object:self.nickNameTextField];
    [inputBgView addSubview:self.nickNameTextField];

    [self.nickNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(split1View.mas_bottom);
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@-Margin_Length);
        make.height.equalTo(@50);
    }];

    UIView *split2View = [[UIView alloc] init];
    split2View.backgroundColor = COLOR_LINE;
    [inputBgView addSubview:split2View];
    [split2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickNameTextField.mas_bottom);
        make.left.right.equalTo(inputBgView);
        make.height.equalTo(@(Line_Height));
    }];
}

- (void)initData {
    User *user = [UserDefaultsUtil getUser];

    if (user.nickName) {
        self.nickNameTextField.text = user.nickName;
    }
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickTheRightBtn:(id)sender {

    [self.nickNameTextField resignFirstResponder];

    NSString *nickName = [self.nickNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; //去掉字符串前后空格

    if (nickName.length == 0 || [StrUtil isEmptyString:nickName]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_please_input_nickname", @"请输入昵称") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    int byte = [self convertToByte:nickName];

    if (byte > 10) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_nick_name_lenth", @"昵称最多5个汉字或10个英文字母") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    NSDictionary *contentDic = @{ @"userId" : [UserDefaultsUtil getUser].userId,
                                  @"nickName" : nickName,
                                  @"sex" : @"",
                                  @"birthDate" : @""
    };

    [self callUpdateUserInfoWebService:contentDic];
}

//判断一个字符串子节数 汉字为两个字节
- (int)convertToByte:(NSString *)strtemp {
    int chinese = 0;
    for (int i = 0; i < [strtemp length]; i++) {
        int a = [strtemp characterAtIndex:i];
        if (a >= 0x4e00 && a <= 0x9fff)
            chinese++;
    }
    return (int) [strtemp length] + chinese;
}

- (void)nickNameTextFieldChange {

    if (![[UIApplication sharedApplication] textInputMode].primaryLanguage) {
        [self.nickNameTextField resignFirstResponder];

        int length = (int) self.nickNameTextField.text.length;
        self.nickNameTextField.text = [self.nickNameTextField.text substringToIndex:length - 2];

        [HUD showPromptViewWithToShowStr:XYBString(@"string_notexpression", @"不支持输入表情") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];

        return;
    }

    if ([self.nickNameTextField.text isEqualToString:@"\n"]) {
        //禁止输入换行
        [self.nickNameTextField resignFirstResponder];
        return;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*****************************修改用户信息接口**********************************/

- (void)callUpdateUserInfoWebService:(NSDictionary *)dictionary {

    [self showDataLoading];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    NSString *urlPath = [RequestURL getRequestURL:UserUpdateInfoURL param:params];

    [WebService postRequest:urlPath param:params JSONModelClass:[ResponseModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {

            [self hideLoading];

            if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishedUpdateNickNameSuccess:)]) {
                [self.navigationController popViewControllerAnimated:YES];
                [self.delegate didFinishedUpdateNickNameSuccess:self];
            }

        }

        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }

    ];
}

@end
