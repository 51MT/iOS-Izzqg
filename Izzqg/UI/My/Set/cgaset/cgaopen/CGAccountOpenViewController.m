//
//  CGAccountOpenViewController.m
//  Ixyb
//
//  Created by dengjian on 2017/12/23.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "CGAccountOpenViewController.h"
#import "CGAccounWebViewController.h"
#import "CgDepRegisterModel.h"
#import "Utility.h"
#import "WebService.h"
#import "RealNamesResponseModel.h"

@interface CGAccountOpenViewController () {
    XYTextField * nameTextField;
    XYTextField * idNumerTextField;
    ColorButton   * nextBut;
}

@property (nonatomic,assign) int type;//1:投资人(INVESTOR) 2:借款人(BORROWERS)

@end

@implementation CGAccountOpenViewController

- (instancetype)initWithType:(int)type
{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark -- 初始化 UI

-(void)setNav {
    
    self.view.backgroundColor = COLOR_BG;
    self.navItem.title = XYBString(@"str_titlekh", @"开户");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

-(void)initUI {
    
    UIView * contenView = [[UIView alloc] init];
    contenView.backgroundColor =COLOR_COMMON_WHITE;
    [self.view addSubview:contenView];
    
    [contenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(Margin_Top);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(90.f));
    }];
    
    [XYCellLine initWithTopLineAtSuperView:contenView];
    [XYCellLine initWithBottomLineAtSuperView:contenView];
    
    UILabel * nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLab.font = TEXT_FONT_16;
    nameLab.text = XYBString(@"str_auth_name", @"姓名");
    nameLab.textColor = COLOR_MAIN_GREY;
    [contenView addSubview:nameLab];
    
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contenView.mas_top);
        make.left.equalTo(@Margin_Length);
        make.width.equalTo(@85);
        make.height.equalTo(@(Cell_Height));
    }];
    
    nameTextField = [[XYTextField alloc] initWithFrame:CGRectZero];
    nameTextField.placeholder = @"请输入本人的真实姓名";
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTextField.keyboardType = UIKeyboardTypeDefault;
    nameTextField.font = TEXT_FONT_14;
    nameTextField.textColor = COLOR_AUXILIARY_GREY;
    [contenView addSubview:nameTextField];
    
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contenView.mas_top);
        make.left.equalTo(nameLab.mas_right).offset(Text_Margin_Length);
        make.right.equalTo(@-Margin_Length);
        make.height.equalTo(@(Cell_Height));
    }];
    
    UIView *splitView = [[UIView alloc] initWithFrame:CGRectZero];
    splitView.backgroundColor = COLOR_LINE;
    [contenView addSubview:splitView];
    
    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTextField.mas_bottom);
        make.right.equalTo(@(0));
        make.left.equalTo(@Margin_Length);
        make.height.equalTo(@(Line_Height));
    }];
    
    UILabel * idNumberLab = [[UILabel alloc] initWithFrame:CGRectZero];
    idNumberLab.font = TEXT_FONT_16;
    idNumberLab.text = XYBString(@"string_address_id", @"身份证号");
    idNumberLab.textColor = COLOR_MAIN_GREY;
    [contenView addSubview:idNumberLab];
    
    [idNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(splitView.mas_bottom);
        make.left.equalTo(@Margin_Length);
        make.width.equalTo(@85);
        make.height.equalTo(@(Cell_Height));
    }];
    
    idNumerTextField = [[XYTextField alloc] initWithFrame:CGRectZero];
    idNumerTextField.placeholder = @"请输入本人的身份证号";
    idNumerTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    idNumerTextField.keyboardType = UIKeyboardTypeDefault;
    idNumerTextField.font = TEXT_FONT_14;
    idNumerTextField.textColor = COLOR_AUXILIARY_GREY;
    [contenView addSubview:idNumerTextField];
    
    [idNumerTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(splitView.mas_bottom);
        make.left.equalTo(idNumberLab.mas_right).offset(Text_Margin_Length);
        make.right.equalTo(@-Margin_Length);
        make.height.equalTo(@(Cell_Height));
    }];
    
    nextBut =[[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"string_next_step", @"下一步")  ByGradientType:leftToRight];
    nextBut.isColorEnabled = NO;
    [nextBut addTarget:self action:@selector(clickNextButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBut];
    
    [nextBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(Cell_Height));
        make.top.equalTo(contenView.mas_bottom).offset(19);
    }];
    
    User *user = [UserDefaultsUtil getUser];
    if (user.realName) {
        nameTextField.text = user.realName;
    }
    
    if (user.idNumber) {
        idNumerTextField.text = user.idNumber;
    }
    
    //1.实名认证过，禁止用户输入，并请求借口查询用户姓名+身份证号，直接显示
    //2.未实名认证，需要用户输入信息，编辑框可编辑
    if ([user.isIdentityAuth boolValue] == YES) {
        nameTextField.userInteractionEnabled = NO;
        idNumerTextField.userInteractionEnabled = NO;
        [self callRealNameInfoWebService];
        
    } else {
        nameTextField.userInteractionEnabled = YES;
        idNumerTextField.userInteractionEnabled = YES;
    }
    
    if (nameTextField.text.length > 0 && idNumerTextField.text.length > 0) {
        nextBut.isColorEnabled = YES;
    } else {
        nextBut.isColorEnabled = NO;
    }
}

#pragma mark -  点击事件

- (void)didTextChanged:(NSNotification *)notification {
    
    if (nameTextField.text.length > 0 && idNumerTextField.text.length > 0) {
        nextBut.isColorEnabled = YES;
    } else {
        nextBut.isColorEnabled = NO;
    }
}

//下一步
-(void)clickNextButton:(id)sender {

    [nameTextField resignFirstResponder];
    [idNumerTextField resignFirstResponder];
    
    /*
     * 1.用户实名认证过，点击下一步，不用校验，直接加载开户webview
     * 2.用户没有实名认证，点击下一步，先校验，通过后，再加载开户webview
     */
    if ([[UserDefaultsUtil getUser].isIdentityAuth boolValue] == YES) {
        
        NSString *baseURL = [NSString stringWithFormat:@"%@%@",[Constant sharedConstant].baseUrl,CGAccountRegister_URL];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[UserDefaultsUtil getUser].userId forKey:@"userId"];
        [params setValue:[UserDefaultsUtil getUser].realName forKey:@"realName"];
        [params setValue:[UserDefaultsUtil getUser].idNumber forKey:@"idCard"];
        [params setValue:_type == 1 ? @"INVESTOR" : @"BORROWERS" forKey:@"userRole"];// 1:存管账户开户 2：借款账户开户
        [params setValue:baseURL forKey:@"baseURL"];
        
        CGAccounWebViewController *cgWebVC = [[CGAccounWebViewController alloc] initWithParams:params];
        cgWebVC.openType = _type;
        [self.navigationController pushViewController:cgWebVC animated:YES];
        
        return;
    }
    
    if (nameTextField.text.length == 0) {
        [self showPromptTip:XYBString(@"str_enter_realName", @"请输入真实姓名")];
        return;
    }
    
    //校验姓名是否为汉字
    BOOL isChinese = [self IsChinese:nameTextField.text];
    if (isChinese == NO) {
        [self showPromptTip:XYBString(@"str_financing_nameMustChinese", @"姓名只能为汉字")];
        return;
    }
    
    if (idNumerTextField.text.length == 0) {
        [self showPromptTip:XYBString(@"str_enter_id_number", @"请输入身份证号")];
        return;
    }
    
    if (idNumerTextField.text.length == 15 || idNumerTextField.text.length == 18) {
        
        NSString *emailRegex = @"^[0-9]*$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        BOOL sfzNo = [emailTest evaluateWithObject:[idNumerTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        if (idNumerTextField.text.length == 15) {
            if (sfzNo == NO) {
                [self showPromptTip:XYBString(@"str_id_number_length", @"身份证为18位字母或数字")];
                return;
            }
            
        } else if (idNumerTextField.text.length == 18) {
            BOOL sfz18NO = [self checkIdentityCardNo:idNumerTextField.text];
            if (sfz18NO == NO) {
                [self showPromptTip:XYBString(@"str_id_number_invalid", @"身份证无效")];
                return;
            }
        }
        
    } else {
        [self showPromptTip:XYBString(@"str_id_number_length", @"身份证为18位字母或数字")];
        return;
    }
    
    NSString *baseURL = [NSString stringWithFormat:@"%@%@",[Constant sharedConstant].baseUrl,CGAccountRegister_URL];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[UserDefaultsUtil getUser].userId forKey:@"userId"];
    [params setValue:nameTextField.text forKey:@"realName"];
    [params setValue:idNumerTextField.text forKey:@"idCard"];
    [params setValue:_type == 1 ? @"INVESTOR" : @"BORROWERS" forKey:@"userRole"];// 1:存管账户开户 2：借款账户开户
    [params setValue:baseURL forKey:@"baseURL"];
    
    CGAccounWebViewController *cgWebVC = [[CGAccounWebViewController alloc] initWithParams:params];
    cgWebVC.openType = _type;
    [self.navigationController pushViewController:cgWebVC animated:YES];
}

//判断输入的字符串是否全是中文
-(BOOL)IsChinese:(NSString *)str {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:str];
}

/**
 身份证检测是否有效

 @param cardNo 身份证号码
 @return YES/NO
 */
- (BOOL)checkIdentityCardNo:(NSString *)cardNo {
    
    if (cardNo.length != 18) {
        return NO;
    }
    
    NSArray *codeArray = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    NSDictionary *checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", nil] forKeys:[NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil]];
    
    NSScanner *scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    
    int sumValue = 0;
    for (int i = 0; i < 17; i++) {
        sumValue += [[cardNo substringWithRange:NSMakeRange(i, 1)] intValue] * [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString *strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d", sumValue % 11]];
    
    if ([strlast isEqualToString:[[cardNo substringWithRange:NSMakeRange(17, 1)] uppercaseString]]) {
        return YES;
    }
    
    return NO;
}

//返回
- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 数据请求

- (void)callRealNameInfoWebService {
    
    [self showDataLoading];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"userId" : [UserDefaultsUtil getUser].userId}];
    NSString *urlPath = [RequestURL getRequestURL:AuthRealNameURL param:params];
    [WebService postRequest:urlPath param:params JSONModelClass:[RealNamesResponseModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        RealNamesResponseModel *model = responseObject;
                        
                        if (![model.realName isEqual:[NSNull null]] && ![model.idNumber isEqual:[NSNull null]]) {
                            
                            NSString *name = model.realName;
                            NSString *idCard = model.idNumber;
                            
                            User *user = [UserDefaultsUtil getUser];
                            user.realName = name;
                            user.idNumbers = idCard;
                            [UserDefaultsUtil setUser:user];
                        
                            nameTextField.text = name;
                            idNumerTextField.text = idCard;
                        }
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }
     ];
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
