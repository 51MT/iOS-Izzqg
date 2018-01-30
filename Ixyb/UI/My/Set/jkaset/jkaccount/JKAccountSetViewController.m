//
//  JKAccountSetViewController.m
//  Ixyb
//
//  Created by wangjianimac on 2017/12/19.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "JKAccountSetViewController.h"
#import "Utility.h"
#import "RequestURL.h"
#import "WebService.h"
#import "CGAccounWebViewController.h"

@interface JKAccountSetViewController () {
    XYScrollView * mainScorll;
    UILabel      * nameLab;       //姓名
    UILabel      * idNumberLab;   //身份证号
    UILabel      * bankNameLab;   //银行卡
    UILabel      * bankCardLab;   //银行卡号
    UILabel      * dbdrxeLab;     //单笔单日限额
}
@property (nonatomic,strong) CGAccountInfoModel *model;
@property (nonatomic,assign) int type;

@end

@implementation JKAccountSetViewController

- (instancetype)initWithModel:(CGAccountInfoModel *)model type:(int)type {
    self = [super init];
    if (self) {
        _model = model;
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self initUI];
}

#pragma mark -- 初始化 UI

-(void)setNav {
    
    if (_type == 1) {
        self.navItem.title = XYBString(@"str_cga", @"存管账户");
    }else{
        self.navItem.title = XYBString(@"str_jka", @"借款账户");
    }

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

-(void)initUI {
    
    mainScorll = [[XYScrollView alloc] init];
    [self.view addSubview:mainScorll];
    
    [mainScorll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.width.equalTo(@(MainScreenWidth));
        make.left.right.bottom.equalTo(self.view);
    }];
    
    //身份证视图
    UIView * sfzView = [[UIView alloc] init];
    sfzView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScorll addSubview:sfzView];
    
    [sfzView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Margin_Top));
        make.left.right.equalTo(mainScorll);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(70.f));
    }];
    
    UIImageView * idImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cg_idMessage"]];
    [sfzView addSubview:idImageView];
    [idImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(8.f));
        make.left.equalTo(@(Margin_Left));
    }];
    
    nameLab = [[UILabel alloc] init];
    nameLab.font = BIG_TEXT_FONT_17;
    nameLab.text = _model.realName;
    nameLab.textColor = COLOR_MAIN_GREY;
    [sfzView addSubview:nameLab];
    
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(idImageView.mas_right).offset(Margin_Left);
        make.centerY.equalTo(idImageView);
    }];
    
    idNumberLab = [[UILabel alloc] init];
    idNumberLab.font = TEXT_FONT_14;
    idNumberLab.text = _model.idCard;
    idNumberLab.textColor = COLOR_AUXILIARY_GREY;
    [sfzView addSubview:idNumberLab];
    
    [idNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLab.mas_left);
        make.top.equalTo(nameLab.mas_bottom).offset(11.f);
    }];
    
    //银行卡视图
    UIView * yhkView = [[UIView alloc] init];
    yhkView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScorll addSubview:yhkView];
    
    [yhkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sfzView.mas_bottom).offset(Margin_Top);
        make.left.right.equalTo(mainScorll);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(130.f));
    }];
    
    UIImageView * bankImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cg_bankCard"]];
    [yhkView addSubview:bankImageView];
    
    [bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(8.f));
        make.left.equalTo(@(Margin_Left));
        make.width.height.equalTo(@29);
    }];
    
    NSString *bankJson = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"json"];
    NSArray *bankArr = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:bankJson] options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *bankDic in bankArr) {
        int bankType = [[bankDic objectForKey:@"bankType"] intValue];
        if (bankType == [_model.bankType intValue]) {
            bankImageView.image = [UIImage imageNamed:[bankDic objectForKey:@"bankImage"]];
            break;
        }
    }
    
    bankNameLab = [[UILabel alloc] init];
    bankNameLab.font = BIG_TEXT_FONT_17;
    bankNameLab.text = _model.bankName;
    bankNameLab.textColor = COLOR_MAIN_GREY;
    [yhkView addSubview:bankNameLab];
    
    [bankNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankImageView.mas_right).offset(Margin_Left);
        make.centerY.equalTo(bankImageView);
    }];
    
    UIButton * ghBankBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [ghBankBut setTitle:XYBString(@"str_ghbankCard", @"更换银行卡") forState:UIControlStateNormal];
    ghBankBut.titleLabel.font = SMALL_TEXT_FONT_13;
    [ghBankBut setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [ghBankBut addTarget:self action:@selector(clickGhBankMethod) forControlEvents:UIControlEventTouchUpInside];
    [yhkView addSubview:ghBankBut];
    
    [ghBankBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bankNameLab.mas_centerY);
        make.right.equalTo(@(-Margin_Right));
    }];
    
    bankCardLab = [[UILabel alloc] init];
    bankCardLab.font = TEXT_FONT_14;
    bankCardLab.text = _model.cardNo;
    bankCardLab.textColor = COLOR_AUXILIARY_GREY;
    [yhkView addSubview:bankCardLab];
    
    [bankCardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankNameLab.mas_left);
        make.top.equalTo(bankNameLab.mas_bottom).offset(18.f);
    }];
    
    UIView *splieView = [[UIView alloc] initWithFrame:CGRectZero];
    splieView.backgroundColor = COLOR_LINE;
    [yhkView addSubview:splieView];
    
    [splieView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-38.f));
        make.left.equalTo(bankCardLab.mas_left);
        make.right.equalTo(yhkView);
        make.height.equalTo(@(Line_Height));
    }];
    
    dbdrxeLab = [[UILabel alloc] init];
    dbdrxeLab.font = TEXT_FONT_14;
    dbdrxeLab.text = [NSString stringWithFormat:XYBString(@"str_cgdbxetips", @"单笔限额%@ | 单日限额%@"),_model.limitOnceStr,_model.limitDayStr];
    dbdrxeLab.textColor = COLOR_AUXILIARY_GREY;
    [yhkView addSubview:dbdrxeLab];
    
    [dbdrxeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(splieView.mas_left);
        make.bottom.equalTo(yhkView.mas_bottom).offset(-10.f);
    }];
    
    //交易密码
    UIView * jymmView = [[UIView alloc] init];
    jymmView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScorll addSubview:jymmView];
    
    [jymmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yhkView.mas_bottom).offset(Margin_Top);
        make.left.right.equalTo(mainScorll);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(70.f));
    }];
    
    UIImageView * jymmImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cg_jymm"]];
    [jymmView addSubview:jymmImageView];
    
    [jymmImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(8.f));
        make.left.equalTo(@(Margin_Left));
    }];
    
    UILabel * jymmLab = [[UILabel alloc] init];
    jymmLab.font = BIG_TEXT_FONT_17;
    jymmLab.text = XYBString(@"string_tradePassword", @"交易密码");
    jymmLab.textColor = COLOR_MAIN_GREY;
    [jymmView addSubview:jymmLab];
    
    [jymmLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jymmImageView.mas_right).offset(Margin_Left);
        make.centerY.equalTo(jymmImageView);
    }];
    
    UIButton * xgBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [xgBut setTitle:XYBString(@"str_xgbut", @"修改") forState:UIControlStateNormal];
    xgBut.titleLabel.font = SMALL_TEXT_FONT_13;
    [xgBut setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [xgBut addTarget:self action:@selector(clickXgMethod) forControlEvents:UIControlEventTouchUpInside];
    [jymmView addSubview:xgBut];
    
    [xgBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(jymmImageView.mas_centerY);
        make.right.equalTo(@(-Margin_Right));
    }];
    
    UILabel * jymmTipsLab = [[UILabel alloc] init];
    jymmTipsLab.font = SMALL_TEXT_FONT_13;
    jymmTipsLab.text = XYBString(@"STR_cgjymmTips", @"存管银行交易密码（用于充值/提现）");
    jymmTipsLab.textColor = COLOR_AUXILIARY_GREY;
    [jymmView addSubview:jymmTipsLab];
    
    [jymmTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jymmLab.mas_left);
        make.top.equalTo(jymmLab.mas_bottom).offset(11.f);
    }];
}


#pragma mark - 响应事件

//返回
-(void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//修改交易密码
-(void)clickXgMethod {
    [self callCGAccountWebserviceWithRequestType:2];
}

//更换银行卡
-(void)clickGhBankMethod {
    [self callCGAccountWebserviceWithRequestType:1];
}


#pragma mark - 存管换绑卡 + 存管修改密码 数据请求

/**
 存管换绑卡 + 存管修改密码 数据请求

 @param reqType  requestURL的类型 1)存管换绑卡URL; 2)存管修改密码URL
 */
- (void)callCGAccountWebserviceWithRequestType:(int)reqType {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[UserDefaultsUtil getUser].userId forKey:@"userId"];
    [params setValue:_type == 1 ? @"INVESTOR":@"BORROWERS" forKey:@"userRole"];
    
    NSString *baseURL = [NSString stringWithFormat:@"%@%@",[Constant sharedConstant].baseUrl,reqType == 1 ? CGAccountChangeCard_URL:CGAccountResetPassword_URL];
    [params setValue:baseURL forKey:@"baseURL"];
    
    CGAccounWebViewController *cgWebVC = [[CGAccounWebViewController alloc] initWithParams:params];
    [self.navigationController pushViewController:cgWebVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
