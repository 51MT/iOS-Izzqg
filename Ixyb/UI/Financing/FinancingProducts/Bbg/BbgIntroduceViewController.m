//
//  BbgIntroduceViewController.m
//  Ixyb
//
//  Created by dengjian on 2017/9/7.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "BbgIntroduceViewController.h"
#import "XYUtil.h"
#import "Masonry.h"

@interface BbgIntroduceViewController () {
    
    XYScrollView *mainScroll;
    UIView *backView;
    UIView *backView2;
}


@end

@implementation BbgIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

-(void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createFirstUI {
    
    mainScroll = [[XYScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:mainScroll];
    
    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageView setImage:[UIImage imageNamed:@"sydzgzImage"]];
    [backView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(backView).offset(Margin_Length);
        make.width.height.equalTo(@22);
    }];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = TEXT_FONT_BOLD_15;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = XYBString(@"str_financing_sydzgz", @"收益递增规则");
    [backView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(6);
        make.centerY.equalTo(imageView.mas_centerY);
        make.right.equalTo(backView.mas_right);
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
    
    // 历史年化结算利率
    UILabel *remaindLab = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab.font = TEXT_FONT_12;
    remaindLab.textColor = COLOR_AUXILIARY_GREY;
    remaindLab.textAlignment = NSTextAlignmentLeft;
    remaindLab.numberOfLines = 0;
    [backView addSubview:remaindLab];
    
    NSString *remaindStr = XYBString(@"str_financing_lsnhsyl", @"历史年化结算利率8%起，按自然月逐月+1%，12%封顶");
    remaindLab.attributedText = [self getAttributedStringWithString:remaindStr color:COLOR_AUXILIARY_GREY font:TEXT_FONT_12 space:6];
    
    [remaindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(10);
        make.top.equalTo(grayLine.mas_bottom).offset(15);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
    }];

    UIView *grayRound = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound.backgroundColor = COLOR_LINE_GREY;
    grayRound.layer.cornerRadius = 1.5f;
    grayRound.layer.masksToBounds = YES;
    [backView addSubview:grayRound];
    
    [grayRound mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(0);
        make.top.equalTo(remaindLab.mas_top).offset(4.5);
        make.width.height.equalTo(@3);
    }];
    
    UILabel *remaindLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab2.font = TEXT_FONT_12;
    remaindLab2.textColor = COLOR_AUXILIARY_GREY;
    remaindLab2.textAlignment = NSTextAlignmentLeft;
    remaindLab2.numberOfLines = 0;
    [backView addSubview:remaindLab2];
    
    NSString *remaindStr2 = XYBString(@"str_financing_jxsptgjdqnh", @"结息时平台根据当前年化收益率和过去持有期间年化收益率的差额乘以当前本金计算并发放补息奖励");
    remaindLab2.attributedText = [self getAttributedStringWithString:remaindStr2 color:COLOR_AUXILIARY_GREY font:TEXT_FONT_12 space:6];
    
    [remaindLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(10);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
        make.top.equalTo(remaindLab.mas_bottom).offset(6);
    }];
    
    UIView *grayRound2 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound2.backgroundColor = COLOR_LINE_GREY;
    grayRound2.layer.cornerRadius = 1.5f;
    grayRound2.layer.masksToBounds = YES;
    [backView addSubview:grayRound2];
    
    [grayRound2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(0);
        make.top.equalTo(remaindLab2.mas_top).offset(4.5);
        make.width.height.equalTo(@3);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = COLOR_LINE;
    [backView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayRound.mas_left);
        make.top.equalTo(remaindLab2.mas_bottom).offset(16);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
        make.height.equalTo(@(Line_Height));
    }];
    
    UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectZero];
    detailLab.font = TEXT_FONT_12;
    detailLab.textColor = COLOR_STRONG_RED;
    detailLab.numberOfLines = 0;
    [backView addSubview:detailLab];
    
    NSString *detailStr = XYBString(@"str_financing_syfd", @"*在账户已投项目查看收益时，预期收益会根据债权的实际收益向上浮动");
    NSMutableAttributedString *mutAttr = [self getAttributedStringWithString:detailStr color:COLOR_STRONG_RED font:TEXT_FONT_12 space:6];
    [mutAttr addAttribute:NSForegroundColorAttributeName value:COLOR_INTRODUCE_RED range:NSMakeRange(0, 1)];
    
    detailLab.attributedText = mutAttr;
    
    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView);
        make.top.equalTo(lineView.mas_bottom).offset(16);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
        make.bottom.equalTo(backView.mas_bottom).offset(-17);
    }];
}

- (void)createSecondUI {
    
    backView2 = [[UIView alloc] initWithFrame:CGRectZero];
    backView2.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:backView2];
    
    [backView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
        make.top.equalTo(backView.mas_bottom).offset(10);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageView setImage:[UIImage imageNamed:@"joinImage"]];
    [backView2 addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(backView2).offset(Margin_Length);
        make.width.height.equalTo(@22);
    }];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = TEXT_FONT_BOLD_15;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = XYBString(@"str_financing_jxgz", @"计息规则");
    [backView2 addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageView.mas_centerY);
        make.left.equalTo(imageView.mas_right).offset(6);
    }];
    
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectZero];
    grayLine.backgroundColor = COLOR_LINE;
    [backView2 addSubview:grayLine];
    
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_left);
        make.top.equalTo(titleLab.mas_bottom).offset(12);
        make.right.equalTo(backView2);
        make.height.equalTo(@(Line_Height));
    }];
    
    //100元起投
    UILabel *remaindLab1 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab1.font = TEXT_FONT_12;
    remaindLab1.textColor = COLOR_AUXILIARY_GREY;
    remaindLab1.textAlignment = NSTextAlignmentLeft;
    remaindLab1.numberOfLines = 0;
    remaindLab1.text = XYBString(@"str_financing_100YuanQT", @"100元起投");
    [backView2 addSubview:remaindLab1];
    
    [remaindLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(10);
        make.top.equalTo(grayLine.mas_bottom).offset(12);
        make.right.equalTo(backView2.mas_right).offset(-Margin_Length);
    }];
    
    UIView *grayRound = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound.backgroundColor = COLOR_LINE_GREY;
    grayRound.layer.cornerRadius = Circular_WH/2;
    grayRound.layer.masksToBounds = YES;
    [backView2 addSubview:grayRound];
    
    [grayRound mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(0);
        make.centerY.equalTo(remaindLab1.mas_centerY);
        make.width.height.equalTo(@Circular_WH);
    }];
    
    //T（出借日）+1工作日开始计息
    UILabel *remaindLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab2.font = TEXT_FONT_12;
    remaindLab2.textColor = COLOR_AUXILIARY_GREY;
    remaindLab2.textAlignment = NSTextAlignmentLeft;
    remaindLab2.numberOfLines = 0;
    remaindLab2.text = XYBString(@"str_financing_whenksjx", @"T（出借日）+1工作日开始计息");
    [backView2 addSubview:remaindLab2];
    
    [remaindLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(10);
        make.top.equalTo(remaindLab1.mas_bottom).offset(6);
        make.right.equalTo(backView2.mas_right).offset(-Margin_Length);
    }];
    
    UIView *grayRound2 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound2.backgroundColor = COLOR_LINE_GREY;
    grayRound2.layer.cornerRadius = Circular_WH/2;
    grayRound2.layer.masksToBounds = YES;
    [backView2 addSubview:grayRound2];
    
    [grayRound2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(0);
        make.centerY.equalTo(remaindLab2.mas_centerY);
        make.width.height.equalTo(@Circular_WH);
    }];
    
    //计息金额不足1分时,不计入收益
    UILabel *remaindLab3 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab3.font = TEXT_FONT_12;
    remaindLab3.textColor = COLOR_AUXILIARY_GREY;
    remaindLab3.textAlignment = NSTextAlignmentLeft;
    remaindLab3.numberOfLines = 0;
    remaindLab3.text = XYBString(@"str_financing_jxjebz", @"计息金额不足1分时,不计入收益");
    [backView2 addSubview:remaindLab3];
    
    [remaindLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(10);
        make.top.equalTo(remaindLab2.mas_bottom).offset(6);
        make.right.equalTo(backView2.mas_right).offset(-Margin_Length);
    }];
    
    UIView *grayRound3 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound3.backgroundColor = COLOR_LINE_GREY;
    grayRound3.layer.cornerRadius = Circular_WH/2;
    grayRound3.layer.masksToBounds = YES;
    [backView2 addSubview:grayRound3];
    
    [grayRound3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(0);
        make.centerY.equalTo(remaindLab3.mas_centerY);
        make.width.height.equalTo(@Circular_WH);
    }];
    
    //T（出借日）+1工作日开始计息
    UILabel *remaindLab4 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab4.font = TEXT_FONT_12;
    remaindLab4.textColor = COLOR_AUXILIARY_GREY;
    remaindLab4.textAlignment = NSTextAlignmentLeft;
    remaindLab4.numberOfLines = 0;
    NSString *str = XYBString(@"str_financing_myfx", @"每月返息,个人退出金额无上限,不退出时本金自动续投");
    remaindLab4.attributedText = [self getAttributedStringWithString:str color:COLOR_AUXILIARY_GREY font:TEXT_FONT_12 space:6.0f];
    [backView2 addSubview:remaindLab4];
    
    [remaindLab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(10);
        make.top.equalTo(remaindLab3.mas_bottom).offset(6);
        make.right.equalTo(backView2.mas_right).offset(-Margin_Length);
        make.bottom.equalTo(backView2.mas_bottom).offset(-17);
    }];
    
    UIView *grayRound4 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound4.backgroundColor = COLOR_LINE_GREY;
    grayRound4.layer.cornerRadius = Circular_WH/2;
    grayRound4.layer.masksToBounds = YES;
    [backView2 addSubview:grayRound4];
    
    [grayRound4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(0);
        make.top.equalTo(remaindLab4.mas_top).offset(4.5);
        make.width.height.equalTo(@Circular_WH);
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
        make.bottom.equalTo(mainScroll.mas_bottom);
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
        make.top.equalTo(tipView.mas_top).offset(0);
        make.left.equalTo(insureImageView.mas_right).offset(6.0f);
        make.right.equalTo(tipView.mas_right);
        make.bottom.equalTo(tipView.mas_bottom);
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
