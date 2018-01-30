//
//  DqFinanceView.m
//  Ixyb
//
//  Created by dengjian on 16/12/13.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "DqFinanceView.h"
#import "Utility.h"

//首页价值产品模块（一键出借、定期宝、信投宝、债权转让）
@implementation DqFinanceView {
    UILabel *titleLab;     //产品名称
    UILabel *gxTipsLab;    //高效转让
    UILabel *fltipsLab;    //费率超低
    UILabel *activityLab;  //活动Lab
    UILabel *addProfitLab; //加息Lab
    UILabel *rateLab;
    UILabel *addLab;       //加息多少
    UILabel *durationLab;  //出借期限
    UILabel *repaymentLab; //还款方式
    UILabel *remainLab;    //剩余金额
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        [self createMainUI];
    }
    return self;
}

- (void)createMainUI {

    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    backImageView.image = [UIImage imageNamed:@"radioBackImg"];
    backImageView.userInteractionEnabled = YES;
    [self addSubview:backImageView];

    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self).offset(11);
        make.width.equalTo(@(MainScreenWidth - 22));
        make.height.equalTo(@(140));
    }];

    titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = BIG_TEXT_FONT_17;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = XYBString(@"str_financing_jzProduct", @"价值产品");
    titleLab.userInteractionEnabled = NO;
    [backImageView addSubview:titleLab];

    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView).offset(19);
        make.top.equalTo(backImageView).offset(11.5);
        make.height.equalTo(@(17));
    }];
    
    gxTipsLab = [[UILabel alloc] initWithFrame:CGRectZero];
    gxTipsLab.backgroundColor = COLOR_COMMON_CLEAR;
    gxTipsLab.font = TEXT_FONT_12;
    gxTipsLab.textColor = COLOR_ORANGE;
    gxTipsLab.layer.borderColor = COLOR_ORANGE_BORDER.CGColor;
    gxTipsLab.layer.borderWidth = Border_Width_2;
    gxTipsLab.layer.cornerRadius = Corner_Radius_9;
    gxTipsLab.clipsToBounds = YES;
    gxTipsLab.textAlignment = NSTextAlignmentCenter;
    gxTipsLab.text = XYBString(@"str_financing_gxzr", @"高效转让");
    gxTipsLab.hidden = YES;
    [backImageView addSubview:gxTipsLab];
    
    [gxTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_right).offset(8);
        make.centerY.equalTo(titleLab.mas_centerY);
        make.width.equalTo(@63);
        make.height.equalTo(@(18));
    }];
    
    fltipsLab = [[UILabel alloc] initWithFrame:CGRectZero];
    fltipsLab.backgroundColor = COLOR_COMMON_CLEAR;
    fltipsLab.font = TEXT_FONT_12;
    fltipsLab.textColor = COLOR_ORANGE;
    fltipsLab.layer.borderColor = COLOR_ORANGE_BORDER.CGColor;
    fltipsLab.layer.borderWidth = Border_Width_2;
    fltipsLab.layer.cornerRadius = Corner_Radius_9;
    fltipsLab.clipsToBounds = YES;
    fltipsLab.textAlignment = NSTextAlignmentCenter;
    fltipsLab.text = XYBString(@"str_financing_flcd", @"费率超低");
    fltipsLab.hidden = YES;
    [backImageView addSubview:fltipsLab];
    
    [fltipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gxTipsLab.mas_right).offset(8);
        make.centerY.equalTo(gxTipsLab.mas_centerY);
        make.width.equalTo(@63);
        make.height.equalTo(@(18));
    }];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = COLOR_LINE;
    lineView.userInteractionEnabled = NO;
    [backImageView addSubview:lineView];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(Line_Height));
        make.left.equalTo(titleLab.mas_left);
        make.right.equalTo(backImageView.mas_right).offset(-3);
        make.top.equalTo(titleLab.mas_bottom).offset(11.5);
    }];
    
    XYButton *button = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [button setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_CLEAR] forState:UIControlStateNormal];
//    [button setBackgroundImage:[ColorUtil imageWithColor:COLOR_LIGHTGRAY_BUTTONDISABLE] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickTheImage:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.bottom.equalTo(backImageView.mas_bottom).offset(-5);
        make.left.equalTo(backImageView.mas_left).offset(4);
        make.right.equalTo(backImageView.mas_right).offset(-4);
    }];

    rateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    rateLab.attributedText = [Utility rateAttributedStr:0 size:40 sizeSymble:18 color:COLOR_MAIN_GREY];
    rateLab.userInteractionEnabled = NO;
    [backImageView addSubview:rateLab];

    [rateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_left).offset(0);
        make.top.equalTo(lineView.mas_bottom).offset(Margin_Length);
        make.height.equalTo(@(40));
    }];

    UILabel *showLab = [[UILabel alloc] initWithFrame:CGRectZero];
    showLab.font = TEXT_FONT_12;
    showLab.textColor = COLOR_LIGHT_GREY;
    showLab.text = XYBString(@"str_np_rate", @"综合约定年化利率");
    showLab.userInteractionEnabled = NO;
    [backImageView addSubview:showLab];

    [showLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rateLab.mas_left).offset(0);
        make.top.equalTo(rateLab.mas_bottom).offset(4);
    }];

    UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    arrowImgView.image = [UIImage imageNamed:@"cell_arrow"];
    [backImageView addSubview:arrowImgView];

    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backImageView.mas_right).offset(-19);
        make.bottom.equalTo(rateLab.mas_bottom);
    }];

    durationLab = [[UILabel alloc] initWithFrame:CGRectZero];
    durationLab.font = TEXT_FONT_14;
    durationLab.textColor = COLOR_MAIN;
    durationLab.text = XYBString(@"str_financing_fromeSevenDaysToTwoYear", @"7天-24个月");
    [backImageView addSubview:durationLab];

    [durationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImgView.mas_left);
        make.centerY.equalTo(arrowImgView.mas_centerY);
    }];
}

- (void)clickTheImage:(id)sender {
    self.block();
}

- (void)setDqModel:(DqFinanceHomePageModel *)dqModel {
    
    _dqModel = dqModel;
    
    NSString *tipsStr = _dqModel.tips;
    NSArray *strArr = [tipsStr componentsSeparatedByString:@","];
    
    NSString *tip1;
    NSString *tip2;
    
    if (strArr.count == 2) {
        tip1 = [strArr objectAtIndex:0];
        tip2 = [strArr objectAtIndex:1];
    }
    
    if (tip1) {
        gxTipsLab.hidden = NO;
        gxTipsLab.text = tip1;
    }
    
    if (tip2) {
        fltipsLab.hidden = NO;
        fltipsLab.text = tip2;
    }
    
    //定期产品利率
    NSString *minRateStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [dqModel.minRate doubleValue] * 100]];
    NSString *maxRateStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [dqModel.maxRate doubleValue] * 100]];
    NSString *rateStr = [[[minRateStr stringByAppendingString:@"-"] stringByAppendingString:maxRateStr] stringByAppendingString:XYBString(@"str_financing_percentSymbol", @"%")];
    
    NSMutableAttributedString *mutAttStr = [[NSMutableAttributedString alloc] initWithString:rateStr];
    [mutAttStr addAttributes:@{ NSFontAttributeName : BORROW_TEXT_FONT_40,
                                NSForegroundColorAttributeName : COLOR_MAIN_GREY }
                       range:NSMakeRange(0, minRateStr.length)];
    [mutAttStr addAttributes:@{ NSFontAttributeName : TEXT_FONT_18,
                                NSForegroundColorAttributeName : COLOR_MAIN_GREY }
                       range:NSMakeRange(minRateStr.length, rateStr.length - minRateStr.length)];
    rateLab.attributedText = mutAttStr;

    NSString *minTermStr = [NSString stringWithFormat:@"%@", dqModel.minTerm];
    NSString *maxTermStr = [NSString stringWithFormat:@"%@", dqModel.maxTerm];
    NSString *termStr = [[minTermStr stringByAppendingString:@"-"] stringByAppendingString:maxTermStr];
    durationLab.text = termStr;
}

@end
