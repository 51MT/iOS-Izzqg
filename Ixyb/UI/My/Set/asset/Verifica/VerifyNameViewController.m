//
//  VerifyNameViewController.m
//  Ixyb
//
//  Created by dengjian on 2017/9/18.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "VerifyNameViewController.h"
#import "Masonry.h"
#import "Utility.h"
#import "ChargeViewController.h"

@interface VerifyNameViewController ()

@property (nonatomic,assign) int type;

@end

@implementation VerifyNameViewController

- (instancetype)initWithType:(int)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createMainUI];
}

- (void)createNav {
    
    if (_type == 1) {
        self.navItem.title = XYBString(@"realNameAuthentication", @"实名认证");
    }else{
        self.navItem.title = XYBString(@"str_real_bank_card", @"银行卡认证");
    }
    
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)createMainUI {
    
    XYScrollView *mainScroll = [[XYScrollView alloc] initWithFrame:CGRectZero];
    mainScroll.backgroundColor = COLOR_BG;
    [self.view addSubview:mainScroll];
    
    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"promotMessage"]];
    [backView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top).offset(29);
        make.centerX.equalTo(backView);
    }];
    
    UILabel *remaindLab = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab.font = FONT_TEXT_20;
    remaindLab.textColor = COLOR_TITLE_GREY;
    [backView addSubview:remaindLab];
    
    if (_type == 1) {
        remaindLab.text = XYBString(@"str_finance_noVerifyRealName", @"您还未完成实名认证");
    }else{
        remaindLab.text = XYBString(@"str_finance_noVerifyBankAccount", @"您还未完成银行卡认证");
    }
    
    [remaindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.top.equalTo(imageView.mas_bottom).offset(21);
    }];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = NORMAL_TEXT_FONT_15;
    titleLab.textColor = COLOR_TITLE_GREY;
    [backView addSubview:titleLab];
    
    if (_type == 1) {
        titleLab.text = XYBString(@"str_finance_verifyNameZY", @"实名认证作用：");
    }else{
        titleLab.text = XYBString(@"str_finance_verifyBankCardZY", @"银行卡认证作用：");
    }
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(Margin_Length);
        make.top.equalTo(remaindLab.mas_bottom).offset(27);
    }];
    
    // • 可以保证资金的安全，让平台更好的进行风控。
    UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectZero];
    detailLab.font = TEXT_FONT_12;
    detailLab.textColor = COLOR_AUXILIARY_GREY;
    detailLab.textAlignment = NSTextAlignmentLeft;
    detailLab.numberOfLines = 0;
    NSString *text = XYBString(@"str_financing_kybzzjaq", @"可以保证资金的安全，让平台更好的进行风控。");
    detailLab.text = text;
    [backView addSubview:detailLab];
    
    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(26);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
        make.top.equalTo(titleLab.mas_bottom).offset(18);
    }];
    
    UIView *grayRound = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound.backgroundColor = COLOR_ROUND_GRAY;
    grayRound.layer.cornerRadius = 3;
    grayRound.layer.masksToBounds = YES;
    [backView addSubview:grayRound];
    
    [grayRound mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(detailLab.mas_left).offset(-6);
        make.centerY.equalTo(detailLab.mas_centerY).offset(0);
        make.width.height.equalTo(@6);
    }];

    // • 保障用户的合法权益，并及时获取更多的平台信息。
    UILabel *detailLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    detailLab2.font = TEXT_FONT_12;
    detailLab2.textColor = COLOR_AUXILIARY_GREY;
    detailLab2.textAlignment = NSTextAlignmentLeft;
    detailLab2.numberOfLines = 0;
    NSString *text2 = XYBString(@"str_financing_bzyhdhfqy", @"保障用户的合法权益，并及时获取更多的平台信息。");
    detailLab2.attributedText = [self getAttributedStringWithString:text2 color:COLOR_AUXILIARY_GREY font:TEXT_FONT_12 space:6];
    [backView addSubview:detailLab2];
    
    [detailLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(26);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
        make.top.equalTo(detailLab.mas_bottom).offset(6);
    }];
    
    UIView *grayRound2 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound2.backgroundColor = COLOR_ROUND_GRAY;
    grayRound2.layer.cornerRadius = 3;
    grayRound2.layer.masksToBounds = YES;
    [backView addSubview:grayRound2];
    
    [grayRound2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(detailLab2.mas_left).offset(-6);
        make.top.equalTo(detailLab2.mas_top).offset(4);
        make.width.height.equalTo(@6);
    }];

    // • 保障用户的合法权益，并及时获取更多的平台信息。
    UILabel *detailLab3 = [[UILabel alloc] initWithFrame:CGRectZero];
    detailLab3.font = TEXT_FONT_12;
    detailLab3.textColor = COLOR_AUXILIARY_GREY;
    detailLab3.textAlignment = NSTextAlignmentLeft;
    detailLab3.numberOfLines = 0;
    NSString *text3 = XYBString(@"str_financing_kebzyhzsx", @"可以保证用户在凭的借款和投资信息的真实性。");
    detailLab3.text = text3;
    [backView addSubview:detailLab3];
    
    [detailLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(26);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
        make.top.equalTo(detailLab2.mas_bottom).offset(6);
        make.bottom.equalTo(backView.mas_bottom).offset(-28);
    }];
    
    UIView *grayRound3 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound3.backgroundColor = COLOR_ROUND_GRAY;
    grayRound3.layer.cornerRadius = 3;
    grayRound3.layer.masksToBounds = YES;
    [backView addSubview:grayRound3];
    
    [grayRound3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(detailLab3.mas_left).offset(-6);
        make.centerY.equalTo(detailLab3.mas_centerY).offset(0);
        make.width.height.equalTo(@6);
    }];
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    iconImage.image = [UIImage imageNamed:@"icon_info_gray"];
    [mainScroll addSubview:iconImage];
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScroll.mas_left).offset(Margin_Length);
        make.top.equalTo(backView.mas_bottom).offset(24);
    }];
    
    UILabel *detailLab4 = [[UILabel alloc] initWithFrame:CGRectZero];
    detailLab4.font = TEXT_FONT_12;
    detailLab4.textColor = COLOR_AUXILIARY_GREY;
    detailLab4.textAlignment = NSTextAlignmentLeft;
    detailLab4.numberOfLines = 0;
    NSString *text4 = XYBString(@"str_financing_czcgh", @"充值成功后，即可完成实名认证和银行卡的绑定");
    detailLab4.text = text4;
    [mainScroll addSubview:detailLab4];
    
    [detailLab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconImage.mas_centerY);
        make.left.equalTo(iconImage.mas_right).offset(6);
    }];
    
    NSString *titleStr;
    if (_type == 1) {
        titleStr = XYBString(@"str_financing_qczwcsmrz", @"去充值完成实名认证");
    }else{
        titleStr = XYBString(@"str_financing_qczwcyhkrz", @"去充值完成银行卡认证");
    }
    
    ColorButton *chargeBtn =  [[ColorButton alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:titleStr  ByGradientType:leftToRight];
    [chargeBtn addTarget:self action:@selector(clickTheChargeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:chargeBtn];
    
    [chargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(mainScroll.mas_centerX);
        make.top.equalTo(iconImage.mas_bottom).offset(16);
        make.height.equalTo(@(Cell_Height));
        make.width.equalTo(@(MainScreenWidth - 30));
        make.bottom.equalTo(mainScroll.mas_bottom).offset(-Margin_Length);
    }];
}

#pragma mark - 点击时间

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickTheChargeBtn:(id)sender {
    
    ChargeViewController *chargeViewController = [[ChargeViewController alloc] initWithIdetifer:YES];
    chargeViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chargeViewController animated:YES];
}

- (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)text color:(UIColor *)color font:(UIFont *)font space:(CGFloat)space {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = space; // 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSParagraphStyleAttributeName : paragraphStyle,
                                 NSForegroundColorAttributeName : color,
                                 NSFontAttributeName : font
                                 };
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attrStr;
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
