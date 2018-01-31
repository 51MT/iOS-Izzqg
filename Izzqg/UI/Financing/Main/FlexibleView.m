//
//  FlexibleView.m
//  Ixyb
//
//  Created by dengjian on 16/12/13.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "FlexibleView.h"
#import "Utility.h"

//首页灵活产品模块（步步高）
@implementation FlexibleView {
    UILabel *titleLab2;   //产品名称2 步步高
    UILabel *durationLab; //1个月起 每月付息
    UILabel *rateLab2;
    ColorButton *buyBtn2;   //出借
    UILabel *remainLab2; //剩余金额2
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        [self createMainUI];
    }
    return self;
}

#pragma mark - 创建页面

- (void)createMainUI {

    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    backImageView.image = [UIImage imageNamed:@"radioBackImg"];
    backImageView.userInteractionEnabled = YES;
    [self addSubview:backImageView];

    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(11);
        make.width.equalTo(@(MainScreenWidth - 22));
        make.height.equalTo(@(185));
    }];

    //灵活产品
    UILabel *flexiblaLab = [[UILabel alloc] initWithFrame:CGRectZero];
    flexiblaLab.font = BIG_TEXT_FONT_17;
    flexiblaLab.textColor = COLOR_MAIN_GREY;
    flexiblaLab.text = XYBString(@"str_flexible_product", @"灵活产品");
    [backImageView addSubview:flexiblaLab];

    [flexiblaLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView).offset(19);
        make.top.equalTo(backImageView).offset(13);
    }];
    
    UILabel *anounceLab = [[UILabel alloc] initWithFrame:CGRectZero];
    anounceLab.font = TEXT_FONT_14;
    anounceLab.textColor = COLOR_MAIN_GREY;
    anounceLab.text = XYBString(@"str_financing_secondDayCauculateProfit", @"T+1工作日计息");
    [backImageView addSubview:anounceLab];
    
    [anounceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backImageView.mas_right).offset(-19);
        make.centerY.equalTo(flexiblaLab.mas_centerY);
    }];

    //画线1
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectZero];
    firstLine.backgroundColor = COLOR_LINE;
    [backImageView addSubview:firstLine];

    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(flexiblaLab.mas_left);
        make.top.equalTo(flexiblaLab.mas_bottom).offset(12);
        make.right.equalTo(backImageView.mas_right).offset(-3);
        make.height.equalTo(@(Line_Height));
    }];

#pragma mark 创建步步高UI

    XYButton *button2 = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [button2 setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_CLEAR] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(clickBbgBackImage:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:button2];

    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLine.mas_bottom).offset(0);
        make.bottom.equalTo(backImageView.mas_bottom).offset(-5);
        make.left.equalTo(backImageView.mas_left).offset(4);
        make.right.equalTo(backImageView.mas_right).offset(-4);
    }];

    titleLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab2.font = TEXT_FONT_16;
    titleLab2.textColor = COLOR_MAIN;
    titleLab2.text = XYBString(@"str_common_bbg", @"步步高");
    [backImageView addSubview:titleLab2];

    [titleLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView).offset(19);
        make.top.equalTo(firstLine.mas_bottom).offset(Margin_Length);
        make.height.equalTo(@(17));
    }];

    durationLab = [[UILabel alloc] initWithFrame:CGRectZero];
    durationLab.backgroundColor = COLOR_COMMON_CLEAR;
    durationLab.font = TEXT_FONT_14;
    durationLab.textColor = COLOR_XTB_ORANGE;
    durationLab.textAlignment = NSTextAlignmentLeft;
    durationLab.text = XYBString(@"str_financing_oneMonthAtLeast_repayEveryMonth", @"1个月起 每月付息");
    [backImageView addSubview:durationLab];

    [durationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab2.mas_right).offset(8);
        make.centerY.equalTo(titleLab2.mas_centerY);
        make.height.equalTo(@(18));
    }];

    UILabel *showLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    showLab2.font = TEXT_FONT_12;
    showLab2.textColor = COLOR_LIGHT_GREY;
    showLab2.text = XYBString(@"str_bbg_dq_rate", @"历史年化结算利率");
    [backImageView addSubview:showLab2];

    [showLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView).offset(19);
        make.bottom.equalTo(backImageView.mas_bottom).offset(-25);
    }];

    rateLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    NSMutableAttributedString *mutAttStr = [Utility rateAttributedStr:0 size:40 sizeSymble:18 color:COLOR_MAIN_GREY];
    rateLab2.attributedText = mutAttStr;
    [backImageView addSubview:rateLab2];

    [rateLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView).offset(19);
        make.bottom.equalTo(showLab2.mas_top).offset(-4);
    }];

    //出借按钮
    buyBtn2 = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, 90.f, 40.f) Title:XYBString(@"str_financing_panicBuy", @"出借") ByGradientType:leftToRight];
    [buyBtn2 addTarget:self action:@selector(clickTouchDown:) forControlEvents:UIControlEventTouchDown];
    [buyBtn2 addTarget:self action:@selector(clickDragOutside:) forControlEvents:UIControlEventTouchDragInside];
    [buyBtn2 addTarget:self action:@selector(clickDragOutside:) forControlEvents:UIControlEventTouchDragExit];
    [buyBtn2 addTarget:self action:@selector(clickDragOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [buyBtn2 addTarget:self action:@selector(clickBbgBuyBtn:) forControlEvents:UIControlEventTouchUpInside];
    buyBtn2.isColorEnabled = NO; //解决步步高收益传值为null的问题
    [backImageView addSubview:buyBtn2];

    [buyBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backImageView.mas_right).offset(-19);
        make.top.equalTo(firstLine.mas_bottom).offset(51);
        make.width.equalTo(@(90));
        make.height.equalTo(@(40));
    }];
    
    remainLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    remainLab2.font = TEXT_FONT_14;
    remainLab2.textColor = COLOR_AUXILIARY_GREY;
    remainLab2.text = XYBString(@"str_financing_remainZeroYuan", @"剩余0.00元");
    [backImageView addSubview:remainLab2];

    [remainLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backImageView.mas_right).offset(-19);
        make.bottom.equalTo(showLab2.mas_bottom);
    }];
}

#pragma mark - 点击事件

- (void)clickBbgBackImage:(id)sender {
    if (self.bbgModel) {
        self.bbgInvestBlock(self.bbgModel);
    }
}

/**
 *  @brief 点击步步高出借按钮，进入出借界面
 */
- (void)clickBbgBuyBtn:(id)sender {
    buyBtn2.transform = CGAffineTransformMakeScale(0.9, 0.9);
    buyBtn2.transform = CGAffineTransformIdentity;
    [self performSelector:@selector(bbgReturnBlock) withObject:nil afterDelay:0.1];
}

- (void)clickDragOutside:(id)sender {
    buyBtn2.transform = CGAffineTransformMakeScale(0.9, 0.9);
    buyBtn2.transform = CGAffineTransformIdentity;
}

- (void)bbgReturnBlock {
    if (self.bbgModel) {
        self.bbgInvestBlock(self.bbgModel);
    }
}
- (void)clickTouchDown:(id)sender {
    buyBtn2.transform = CGAffineTransformIdentity;
    buyBtn2.transform = CGAffineTransformMakeScale(0.9, 0.9);
}

#pragma mark - UI赋值刷新

/**
 *  @brief 步步高UI赋值
 *
 *  @param bbgModel 步步高model
 */
- (void)setBbgModel:(BbgProductModel *)bbgModel {
    _bbgModel = bbgModel;
    buyBtn2.isColorEnabled = YES; //解决步步高收益传值为null的问题
    //步步高
    titleLab2.text = [NSString stringWithFormat:@"%@", bbgModel.title];
    //步步高利率
    NSString *minRateStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [bbgModel.baseRate doubleValue] * 100]];
    NSString *maxRateStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [bbgModel.maxRate doubleValue] * 100]];
    NSString *rateStr = [[[minRateStr stringByAppendingString:@"-"] stringByAppendingString:maxRateStr] stringByAppendingString:XYBString(@"str_financing_percentSymbol", @"%")];
    NSMutableAttributedString *mutAttStr2 = [[NSMutableAttributedString alloc] initWithString:rateStr];
    [mutAttStr2 addAttributes:@{ NSFontAttributeName : BORROW_TEXT_FONT_40,
                                 NSForegroundColorAttributeName : COLOR_MAIN_GREY }
                        range:NSMakeRange(0, minRateStr.length)];
    [mutAttStr2 addAttributes:@{ NSFontAttributeName : TEXT_FONT_18,
                                 NSForegroundColorAttributeName : COLOR_MAIN_GREY }
                        range:NSMakeRange(minRateStr.length, maxRateStr.length + 2)];
    rateLab2.attributedText = mutAttStr2;

    //步步高剩余金额
    if ([bbgModel.restAmount doubleValue] == 0) {
        remainLab2.text = XYBString(@"str_financing_remainZeroYuan", @"剩余0.00元");
        buyBtn2.isColorEnabled = NO;
        [buyBtn2 setTitle:XYBString(@"str_financing_soldOut", @"售罄") forState:UIControlStateNormal];
        
    } else {
        remainLab2.text = [NSString stringWithFormat:XYBString(@"str_financing_bidRemain", @"剩余%@元"), [Utility replaceTheNumberForNSNumberFormatter:bbgModel.restAmount]];
        buyBtn2.isColorEnabled = YES;
        [buyBtn2 setTitle:XYBString(@"str_financing_panicBuy", @"出借") forState:UIControlStateNormal];
    }
}

@end
