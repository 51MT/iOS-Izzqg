//
//  DqbIntroduceViewController.m
//  Ixyb
//
//  Created by dengjian on 2017/9/7.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "DqbIntroduceViewController.h"
#import "XYUtil.h"
#import "Masonry.h"
#import "RTLabel.h"
#import "RequestURL.h"
#import "XYWebViewController.h"

@interface DqbIntroduceViewController () <RTLabelDelegate> {
    
    XYScrollView *mainScroll;
    UIView *backView;
    UILabel *remaindLab;
    
    UIView *backView2;
}

@property (nonatomic,strong) CcProductModel *dqbModel;

@end

@implementation DqbIntroduceViewController

- (instancetype)initWithDqbModel:(CcProductModel *)model {
    self = [super init];
    if (self) {
        _dqbModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNav];
    [self createFirstUI];
    [self createSecondUI];
//    [self createBottomView];
}

- (void)setNav {
    self.navItem.title = XYBString(@"str_financing_productIntroduce", @"产品介绍");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    self.view.backgroundColor = COLOR_BG;
}

- (void)createFirstUI {
    
    mainScroll = [[XYScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:mainScroll];
    
    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
        make.width.equalTo(@(MainScreenWidth));
    }];
    
    backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.top.equalTo(mainScroll.mas_top).offset(10);
        make.width.equalTo(@(MainScreenWidth));
    }];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = TEXT_FONT_BOLD_15;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = XYBString(@"str_financing_joinAndProfitRule", @"加入及计息规则");
    [backView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top).offset(20);
        make.left.equalTo(backView.mas_left).offset(47);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageView setImage:[UIImage imageNamed:@"joinImage"]];
    [backView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleLab.mas_left).offset(-6);
        make.centerY.equalTo(titleLab);
    }];
    
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectZero];
    grayLine.backgroundColor = COLOR_LINE;
    [backView addSubview:grayLine];
    
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_left);
        make.top.equalTo(titleLab.mas_bottom).offset(12);
        make.right.equalTo(backView.mas_right);
        make.height.equalTo(@(Line_Height));
    }];
    
    UIView *grayRound = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound.backgroundColor = COLOR_LINE_GREY;
    grayRound.layer.cornerRadius = Circular_WH/2;
    grayRound.layer.masksToBounds = YES;
    [backView addSubview:grayRound];
    
    [grayRound mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left);
        make.top.equalTo(grayLine.mas_bottom).offset(Margin_Length);
        make.width.height.equalTo(@Circular_WH);
    }];
    
    float spacing = IS_IPHONE_5_OR_LESS ? 17 : 18;
    
    UIView *grayRound1 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound1.backgroundColor = COLOR_LINE_GREY;
    grayRound1.layer.cornerRadius = Circular_WH/2;
    grayRound1.layer.masksToBounds = YES;
    [backView addSubview:grayRound1];
    
    [grayRound1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayRound.mas_left);
        make.top.equalTo(grayRound.mas_bottom).offset(spacing);
        make.width.height.equalTo(@Circular_WH);
    }];
    
    UIView *grayRound2 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound2.backgroundColor = COLOR_LINE_GREY;
    grayRound2.layer.cornerRadius = Circular_WH/2;
    grayRound2.layer.masksToBounds = YES;
    [backView addSubview:grayRound2];
    
    [grayRound2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayRound1.mas_left);
        make.top.equalTo(grayRound1.mas_bottom).offset(spacing);
        make.width.height.equalTo(@Circular_WH);
    }];
    
    UIView *grayRound3 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound3.backgroundColor = COLOR_LINE_GREY;
    grayRound3.layer.cornerRadius = Circular_WH/2;
    grayRound3.layer.masksToBounds = YES;
    [backView addSubview:grayRound3];
    
    [grayRound3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayRound2.mas_left);
        make.top.equalTo(grayRound2.mas_bottom).offset(spacing);
        make.width.height.equalTo(@Circular_WH);
    }];
    
    remaindLab = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab.font = TEXT_FONT_12;
    remaindLab.textColor = COLOR_AUXILIARY_GREY;
    remaindLab.textAlignment = NSTextAlignmentLeft;
    remaindLab.numberOfLines = 0;
    NSString *text;
    if ([_dqbModel.type isEqualToString:@"ZZY"]) {
        grayRound3.hidden = NO;
        text = [NSString stringWithFormat:@"新手用户专享（首次出借用户），每个用户最多6次\n%@元起投，限购上限10万\n%@\n计息金额不足1分时，不计入收益",_dqbModel.minBidAmount,_dqbModel.interestDay];
    }else{
        grayRound3.hidden = YES;
        text = [NSString stringWithFormat:@"%@元起投\n%@\n计息金额不足1分时，不计入收益",_dqbModel.minBidAmount,@"T(出借日)+1工作日开始计息"];
    }

    remaindLab.attributedText = [self getAttributedStringWithString:text color:COLOR_AUXILIARY_GREY font: IS_IPHONE_5_OR_LESS ? WEAK_TEXT_FONT_11 : TEXT_FONT_12  space:6];
    
    [backView addSubview:remaindLab];
    
    [remaindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayRound.mas_right).offset(6);
        make.top.equalTo(grayLine.mas_bottom).offset(10);
        make.bottom.equalTo(backView.mas_bottom).offset(-Margin_Length);
    }];
}

- (void)createSecondUI {
    
    backView2 = [[UIView alloc] initWithFrame:CGRectZero];
    backView2.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:backView2];
    
    [backView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.top.equalTo(backView.mas_bottom).offset(10);
        make.width.equalTo(@(MainScreenWidth));
    }];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = TEXT_FONT_BOLD_15;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = XYBString(@"str_financing_otherImportantExplain", @"其他重要说明");
    [backView2 addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView2.mas_top).offset(20);
        make.left.equalTo(backView2.mas_left).offset(47);
    }];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageView setImage:[UIImage imageNamed:@"sydzgzImage"]];
    [backView2 addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleLab.mas_left).offset(-6);
        make.centerY.equalTo(titleLab);
    }];
    
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectZero];
    grayLine.backgroundColor = COLOR_LINE;
    [backView2 addSubview:grayLine];
    
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_left);
        make.top.equalTo(titleLab.mas_bottom).offset(12);
        make.right.equalTo(backView.mas_right);
        make.height.equalTo(@(Line_Height));
    }];
    
    //出借范围
    UIView *grayRound = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound.backgroundColor = COLOR_LINE_GREY;
    grayRound.layer.cornerRadius = Circular_WH/2;
    grayRound.layer.masksToBounds = YES;
    [backView2 addSubview:grayRound];
    
    [grayRound mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left);
        make.top.equalTo(grayLine.mas_bottom).offset(Margin_Length);
        make.width.height.equalTo(@Circular_WH);
    }];
    
    UILabel *remaindLab1 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab1.font = TEXT_FONT_14;
    remaindLab1.textColor = COLOR_AUXILIARY_GREY;
    remaindLab1.textAlignment = NSTextAlignmentLeft;
    remaindLab1.numberOfLines = 0;
    remaindLab1.text = XYBString(@"str_financing_cjfw", @"出借范围");
    [backView2 addSubview:remaindLab1];
    
    [remaindLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(grayRound.mas_centerY);
        make.left.equalTo(grayRound.mas_right).offset(6);
    }];
    
    
    UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectZero];
    detailLab.font = TEXT_FONT_12;
    detailLab.textColor = COLOR_AUXILIARY_GREY;
    NSString *text = XYBString(@"str_financing_cjfw_detail", @"机构担保标、实地认证标。本期产品用于信闪贷等短期借款需求，该笔债权由风险缓释金保障。");
    detailLab.attributedText = [self getAttributedStringWithString:text color:COLOR_AUXILIARY_GREY font: IS_IPHONE_5_OR_LESS ? WEAK_TEXT_FONT_11 : TEXT_FONT_12 space:6];
    detailLab.numberOfLines = 0;
    [backView2 addSubview:detailLab];
    
    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(remaindLab1.mas_left).offset(0);
        make.top.equalTo(remaindLab1.mas_bottom).offset(9);
        make.right.equalTo(backView2.mas_right).offset(-26);
    }];

    //保障方式
    
    UIView *grayRound2 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound2.backgroundColor = COLOR_LINE_GREY;
    grayRound2.layer.cornerRadius = Circular_WH/2;
    grayRound2.layer.masksToBounds = YES;
    [backView2 addSubview:grayRound2];
    
    [grayRound2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left);
        make.top.equalTo(detailLab.mas_bottom).offset(14);
        make.width.height.equalTo(@Circular_WH);
    }];
    
    
    UILabel *remaindLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab2.font = TEXT_FONT_14;
    remaindLab2.textColor = COLOR_AUXILIARY_GREY;
    remaindLab2.textAlignment = NSTextAlignmentLeft;
    remaindLab2.text = XYBString(@"str_financing_bzfs", @"保障方式");
    [backView2 addSubview:remaindLab2];
    
    [remaindLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(grayRound2.mas_centerY);
        make.left.equalTo(grayRound2.mas_right).offset(6);
    }];
    

    
    RTLabel *detailLab2 = [[RTLabel alloc] initWithFrame:CGRectZero];
    detailLab2.font =  IS_IPHONE_5_OR_LESS ? WEAK_TEXT_FONT_11 : TEXT_FONT_12;
    detailLab2.textColor = COLOR_AUXILIARY_GREY;
    detailLab2.textAlignment = NSTextAlignmentLeft;
    detailLab2.delegate = self;
    NSString *text2 = XYBString(@"str_financing_zjaqbzAndzbfwzkdf", @"①资金安全保障；\n②风险缓释金垫付;\n③信用宝风控综述。请参见<font color='#4385f5' ><u color=clear><a href='aqbz'>安全保障</a></u></font>。");
    detailLab2.text = text2;
    [backView2 addSubview:detailLab2];
    
    [detailLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(remaindLab2.mas_left).offset(0);
        make.top.equalTo(remaindLab2.mas_bottom).offset(9);
        make.right.equalTo(backView2.mas_right).offset(-26);
        make.height.equalTo(@60);
    }];
    
    //收益规则
    UIView *grayRound3 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound3.backgroundColor = COLOR_LINE_GREY;
    grayRound3.layer.cornerRadius = Circular_WH/2;
    grayRound3.layer.masksToBounds = YES;
    [backView2 addSubview:grayRound3];
    
    [grayRound3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left);
        make.top.equalTo(detailLab2.mas_bottom).offset(14);
        make.width.height.equalTo(@Circular_WH);
    }];
    
    UILabel *remaindLab3 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab3.font = TEXT_FONT_14;
    remaindLab3.textColor = COLOR_AUXILIARY_GREY;
    remaindLab3.textAlignment = NSTextAlignmentLeft;
    remaindLab3.numberOfLines = 0;
    remaindLab3.text = XYBString(@"str_financing_profitRule", @"收益规则");
    [backView2 addSubview:remaindLab3];
    
    [remaindLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(grayRound3.mas_centerY);
        make.left.equalTo(grayRound3.mas_right).offset(6);
    }];
    
    UILabel *detailLab3 = [[UILabel alloc] initWithFrame:CGRectZero];
    detailLab3.font = TEXT_FONT_12;
    detailLab3.textColor = COLOR_AUXILIARY_GREY;
    detailLab3.textAlignment = NSTextAlignmentLeft;
    detailLab3.numberOfLines = 0;
    NSString *text3 = XYBString(@"str_financing_tzxybzh", @"提至信用宝账户，可再出借。该产品收益由借款真实收益和信用宝补贴构成。");
    detailLab3.attributedText = [self getAttributedStringWithString:text3 color:COLOR_AUXILIARY_GREY font: IS_IPHONE_5_OR_LESS ? WEAK_TEXT_FONT_11 : TEXT_FONT_12 space:6];
    [backView2 addSubview:detailLab3];
    
    [detailLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(remaindLab3.mas_left).offset(0);
        make.top.equalTo(remaindLab3.mas_bottom).offset(9);
        make.right.equalTo(backView2.mas_right).offset(-26);
        make.bottom.equalTo(backView2.mas_bottom).offset(-Margin_Length);
    }];
}

/**
 *  @brief 底部安全部分 图片+文字(风险缓释金保障)
 */
- (void)createBottomView {
    
    UIView *tipSafeView = [[UIView alloc] initWithFrame:CGRectZero];
    tipSafeView.backgroundColor = COLOR_BG;
    [mainScroll addSubview:tipSafeView];
    
    [tipSafeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.height.equalTo(@40);
        make.top.equalTo(backView2.mas_bottom).offset(0);
        make.bottom.equalTo(mainScroll.mas_bottom).offset(0);
    }];
    
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectZero];
    [tipSafeView addSubview:tipView];
    
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tipSafeView.mas_centerX);
        make.centerY.equalTo(tipSafeView.mas_centerY);
    }];
    
    UIImageView *insureImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    UIImage *img = [UIImage imageNamed:@"bsj_icon"];
    [insureImageView setImage:img];
    [tipView addSubview:insureImageView];
    
    [insureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipView.mas_top).offset(0);
        make.left.equalTo(tipView.mas_left).offset(0);
        make.size.mas_equalTo(img.size);
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.text = XYBString(@"str_financing_platformRiskProtectMoney", @"风险缓释金保障");
    tipLab.font = TEXT_FONT_12;
    tipLab.textColor = COLOR_AUXILIARY_GREY;
    [tipView addSubview:tipLab];
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(insureImageView.mas_centerY);
        make.left.equalTo(insureImageView.mas_right).offset(6.0f);
        make.right.equalTo(tipView.mas_right);
        make.bottom.equalTo(tipView.mas_bottom);
    }];
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

-(void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - RTLableDelegate

// 安全保障链接
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url {
    if ([url.description isEqualToString:@"aqbz"]) {
        NSString *urlStr = [RequestURL getNodeJsH5URL:App_Safe_URL withIsSign:NO];
        XYWebViewController *webView = [[XYWebViewController alloc] initWithTitle:nil webUrlString:urlStr];
        [self.navigationController pushViewController:webView animated:YES];
    }
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
