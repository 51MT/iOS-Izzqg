//
//  DqbProductView.m
//  Ixyb
//
//  Created by wang on 15/8/25.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "DqbHomeProductView.h"

#import "ProductFeaturesView.h"
#import "Utility.h"

#define FEATUREVIEWTAG 2001
#define RESTAMOUNTLABTAG 2002
@implementation DqbHomeProductView {
    UILabel *investTimeLab; //可投次数
}

@synthesize ccInfo;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        [self setUI];
    }
    return self;
}

- (void)setUI {

    _titleLab = [[UILabel alloc] init];
    _titleLab.textColor = COLOR_MAIN_GREY;
    _titleLab.font = TEXT_FONT_18;
    _titleLab.text = XYBString(@"str_common_zzy", @"周周盈");
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLab];

    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(@34);
    }];

    UIView *remainView = [[UIView alloc] init];
    [self addSubview:remainView];

    [remainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLab.mas_bottom).offset(14);
        make.centerX.equalTo(_titleLab.mas_centerX);
    }];

    UILabel *remainLab = [[UILabel alloc] init];
    remainLab.textColor = COLOR_AUXILIARY_GREY;
    remainLab.font = TEXT_FONT_16;
    remainLab.text = XYBString(@"str_financing_remainCanInvestMoney", @"剩余可投");
    [remainView addSubview:remainLab];

    [remainLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(remainView.mas_centerY);
        make.left.equalTo(remainView.mas_left).offset(Margin_Length);
        make.bottom.equalTo(remainView.mas_bottom);
        //make.centerX.equalTo(titleLab.mas_centerX).offset(-30);
    }];

    UILabel *restAmountLab = [[UILabel alloc] init];
    restAmountLab.text = XYBString(@"str_financing_zero_yuan", @"0.00元");
    restAmountLab.textColor = COLOR_STRONG_RED;
    restAmountLab.font = TEXT_FONT_16;
    restAmountLab.tag = RESTAMOUNTLABTAG;
    [remainView addSubview:restAmountLab];

    [restAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(remainLab.mas_centerY);
        make.left.equalTo(remainLab.mas_right).offset(5);
        make.right.equalTo(remainView.mas_right).offset(-Margin_Length);
    }];

    UIImageView *rateBackImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dqb_rateBack"]];
    [self addSubview:rateBackImage];

    [rateBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(remainView.mas_bottom).offset(34);

    }];

    UILabel *rateTitleLabel = [[UILabel alloc] init];
    rateTitleLabel.text = XYBString(@"str_bbg_dq_rate", @"历史年化结算利率");
    rateTitleLabel.font = TEXT_FONT_12;
    rateTitleLabel.textColor = COLOR_COMMON_WHITE;
    [rateBackImage addSubview:rateTitleLabel];

    [rateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(rateBackImage.mas_bottom).offset(-68);
        make.centerX.equalTo(rateBackImage.mas_centerX);
    }];

    _rateLabel = [[UILabel alloc] init];
    //    _rateLabel.backgroundColor = COLOR_COMMON_WHITE;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"0%@", @"%"]];
    [str addAttributes:@{ NSForegroundColorAttributeName : COLOR_COMMON_WHITE,
                          NSFontAttributeName : DQB_RATE_63 }
                 range:NSMakeRange(0, str.length - 1)];
    [str addAttributes:@{ NSForegroundColorAttributeName : COLOR_COMMON_WHITE,
                          NSFontAttributeName : GENERAL_MIDDLE_BIG_FONT }
                 range:NSMakeRange(str.length - 1, 1)];
    _rateLabel.attributedText = str;
    [rateBackImage addSubview:_rateLabel];

    [_rateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(rateTitleLabel.mas_top).offset(0);
        make.centerX.equalTo(rateBackImage.mas_centerX);
        make.height.equalTo(@(65));
    }];

    investTimeLab = [[UILabel alloc] init];
    investTimeLab.textColor = COLOR_COMMON_WHITE;
    investTimeLab.font = SMALL_TEXT_FONT_13;
    investTimeLab.textAlignment = NSTextAlignmentCenter;
    investTimeLab.layer.cornerRadius = Corner_Radius_8;
    investTimeLab.layer.borderColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:0.5].CGColor;
    investTimeLab.layer.borderWidth = Border_Width;
    investTimeLab.text = [NSString stringWithFormat:XYBString(@"str_financing_canInvestTime", @"可投%@次"), @"0"];
    [rateBackImage addSubview:investTimeLab];

    [investTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rateBackImage.mas_centerX);
        make.top.equalTo(rateTitleLabel.mas_bottom).offset(12);
        make.height.equalTo(@(21));
        make.width.equalTo(@(72));
    }];

    ProductFeaturesView *fratureView = [[ProductFeaturesView alloc] init];
    fratureView.tag = FEATUREVIEWTAG;
    [self addSubview:fratureView];
    fratureView.productArr = @[
        XYBString(@"str_financing_aWeekTimeLimit", @"7天期限"),
        XYBString(@"str_financing_calculatedInterestRighNow", @"当日计息"),
        XYBString(@"str_financing_100yqt", @"100元起投")
    ];
    [fratureView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.equalTo(self.mas_centerX);
        //        make.width.equalTo(@320);//产品特点宽度
        make.left.equalTo(self.mas_left).offset(30);
        make.top.equalTo(rateBackImage.mas_bottom).offset(34);
        make.height.equalTo(@18);
    }];

    //产品详情页点击区域
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailButton addTarget:self action:@selector(clickTheDetailButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:detailButton];

    [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(fratureView.mas_bottom);
        //        make.height.equalTo(@400);
    }];

    _investButton = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Button_Height) Title:XYBString(@"str_financing_investedImmidiate", @"立即出借") ByGradientType:leftToRight];
    [_investButton addTarget:self action:@selector(clickInvestButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_investButton];

    [_investButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@(-Margin_Length));
        make.top.equalTo(fratureView.mas_bottom).offset(Margin_Length);
        make.height.equalTo(@(Button_Height));
        make.bottom.equalTo(self.mas_bottom);
    }];
}

/**
 *  对年化率数值的处理
 *
 *  @param str 年化率
 *
 *  @return 处理好的NSMutableAttributedString
 */
- (NSMutableAttributedString *)processTheDecimal:(NSString *)str {

    NSArray *array = [str componentsSeparatedByString:@"."];
    if (array.count < 1) {
        return nil;
    }
    NSString *intStr = [array objectAtIndex:0];
    NSString *pointStr = [array objectAtIndex:1];
    NSString *returnStr;

    if ([pointStr intValue] == 0) {
        returnStr = [array objectAtIndex:0];
    } else {

        NSRange range;
        range.location = pointStr.length - 1;
        range.length = 1;
        NSString *lastString = [pointStr substringWithRange:range];
        if ([lastString isEqualToString:@"0"]) {
            returnStr = [str substringToIndex:str.length - 1];
        } else {
            returnStr = str;
        }
    }
    NSMutableAttributedString *rateStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", returnStr, @"%"]];
    [rateStr addAttributes:@{ NSForegroundColorAttributeName : COLOR_COMMON_WHITE,
                              NSFontAttributeName : DQB_RATE_70 }
                     range:NSMakeRange(0, intStr.length)];
    [rateStr addAttributes:@{ NSForegroundColorAttributeName : COLOR_COMMON_WHITE,
                              NSFontAttributeName : XTB_RATE_FONT }
                     range:NSMakeRange(intStr.length, rateStr.length - intStr.length)];
    return rateStr;
}

/**
 *  UI赋值
 *
 *  @param info 定期宝产品对象
 */
- (void)setInfo:(CcProductModel *)info {

    _titleLab.text = info.typeStr;
    _rateLabel.attributedText = [self processTheDecimal:[NSString stringWithFormat:@"%.2f", [info.rate doubleValue]* 100]];
    ProductFeaturesView *fratureView = (ProductFeaturesView *) [self viewWithTag:FEATUREVIEWTAG];
    UILabel *amountLab = (UILabel *) [self viewWithTag:RESTAMOUNTLABTAG];

    if ([info.type isEqualToString:@"ZZY"]) {
        fratureView.productArr = @[
            XYBString(@"str_financing_aWeekTimeLimit", @"7天期限"),
            XYBString(@"str_financing_calculatedInterestRighNow", @"当日计息"),
            XYBString(@"str_financing_100yqt", @"100元起投")
        ];
        amountLab.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [info.restAmount doubleValue]]]];
        investTimeLab.text = [NSString stringWithFormat:XYBString(@"str_financing_canInvestTime", @"可投%@次"), [NSString stringWithFormat:@"%d", [info.restInvestCount intValue]]];
    } else if ([info.type isEqualToString:@"RXYY"]) {
        fratureView.productArr = @[
            XYBString(@"str_financing_12MonthsAtLeast", @"12个月起"),
            XYBString(@"str_financing_T+2_drjx", @"T+2计息"),
            XYBString(@"str_financing_100yqt", @"100元起投")
        ];
        amountLab.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [info.restAmount doubleValue]]]];

    } else {
        fratureView.productArr = @[
            XYBString(@"str_financing_oneYearAtLeast", @"1年期限"),
            XYBString(@"str_financing_T+2_drjx", @"T+2计息"),
            XYBString(@"str_financing_100yqt", @"100元起投")
        ];
        amountLab.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [info.restAmount doubleValue]]]];
    }

    if (info.restAmount > 0) {
        if ([info.type isEqualToString:@"ZZY"]) {
            if (info.restInvestCount == 0) {
                _investButton.isColorEnabled = NO;

            } else {
                _investButton.isColorEnabled = YES;
            }
        } else {
            _investButton.isColorEnabled = YES;
            
        }
    } else {
        amountLab.text = XYBString(@"str_financing_zero_yuan", @"0.00元");
        _investButton.isColorEnabled = NO;
        [_investButton setTitle:XYBString(@"str_financing_haveSoldOut", @"已售罄") forState:UIControlStateNormal];
    }
}

- (void)clickInvestButton:(id)sender {
    if (self.clickInvestButton) {
        self.clickInvestButton(ccInfo);
    }
}

- (void)clickTheDetailButton:(id)sender {
    if (self.clickDetailButton) {
        self.clickDetailButton(ccInfo);
    }
}

@end
