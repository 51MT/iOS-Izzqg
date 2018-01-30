//
//  SelectionView.m
//  Ixyb
//
//  Created by dengjian on 16/12/13.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "SelectionView.h"
#import "Utility.h"

//首页周周盈模块
@implementation SelectionView {
    UILabel *titleLab;       //产品名称
    UILabel *investCountLab; //可投次数
    UILabel *rateLab;
    ColorButton *buyBtn;      //出借按钮
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
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(11);
        make.width.equalTo(@(MainScreenWidth - 22));
        make.height.equalTo(@(170));
    }];

    XYButton *button = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [button setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_CLEAR] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickTheImage:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:button];

    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_top).offset(1);
        make.bottom.equalTo(backImageView.mas_bottom).offset(-5);
        make.left.equalTo(backImageView.mas_left).offset(4);
        make.right.equalTo(backImageView.mas_right).offset(-4);
    }];

    UIImageView *recommendImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selection"]];
    [backImageView addSubview:recommendImgView];

    [recommendImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_top);
        make.right.equalTo(backImageView.mas_right).offset(-20);
    }];

    titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = BIG_TEXT_FONT_17;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = XYBString(@"dqb_zzy_product", @"周周盈");
    [backImageView addSubview:titleLab];

    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView).offset(19);
        make.top.equalTo(backImageView).offset(Margin_Length);
        make.height.equalTo(@(17));
    }];

    investCountLab = [[UILabel alloc] initWithFrame:CGRectZero];
    investCountLab.backgroundColor = COLOR_COMMON_CLEAR;
    investCountLab.font = TEXT_FONT_12;
    investCountLab.textColor = COLOR_ORANGE;
    investCountLab.layer.borderColor = COLOR_ORANGE_BORDER.CGColor;
    investCountLab.layer.borderWidth = Border_Width_2;
    investCountLab.layer.cornerRadius = Corner_Radius_9;
    investCountLab.clipsToBounds = YES;
    investCountLab.textAlignment = NSTextAlignmentCenter;
    investCountLab.text = XYBString(@"str_financing_restInvestCount", @"可投0次");
    [backImageView addSubview:investCountLab];

    [investCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_right).offset(8);
        make.centerY.equalTo(titleLab.mas_centerY);
        make.width.equalTo(@60);
        make.height.equalTo(@(18));
    }];
    
    UILabel *anounceLab = [[UILabel alloc] initWithFrame:CGRectZero];
    anounceLab.backgroundColor = COLOR_COMMON_CLEAR;
    anounceLab.font = TEXT_FONT_12;
    anounceLab.textColor = COLOR_ORANGE;
    anounceLab.layer.borderColor = COLOR_ORANGE_BORDER.CGColor;
    anounceLab.layer.borderWidth = Border_Width_2;
    anounceLab.layer.cornerRadius = Corner_Radius_9;
    anounceLab.clipsToBounds = YES;
    anounceLab.textAlignment = NSTextAlignmentCenter;
    anounceLab.text = XYBString(@"str_financing_calculatedInterestRighNow", @"当日计息");
    [backImageView addSubview:anounceLab];
    
    [anounceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(investCountLab.mas_right).offset(8);
        make.centerY.equalTo(investCountLab.mas_centerY);
        make.width.equalTo(@63);
        make.height.equalTo(@(18));
    }];
    
    //backView将rateLab和showLab包裹起来
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = COLOR_COMMON_CLEAR;
    backView.userInteractionEnabled = NO;
    [backImageView addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView).offset(19);
        make.top.equalTo(titleLab.mas_bottom).offset(Margin_Length);
        make.width.equalTo(@(MainScreenWidth / 2));
        make.bottom.equalTo(backImageView.mas_bottom).offset(-52);
    }];

    rateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    NSMutableAttributedString *mutAttStr = [Utility rateAttributedStr:0 size:40 sizeSymble:18 color:COLOR_MAIN_GREY];
    rateLab.attributedText = mutAttStr;
    [backView addSubview:rateLab];

    [rateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(0);
        make.top.equalTo(@(4));
        make.height.equalTo(@(40));
    }];

    UILabel *showLab = [[UILabel alloc] initWithFrame:CGRectZero];
    showLab.font = TEXT_FONT_12;
    showLab.textColor = COLOR_LIGHT_GREY;
    showLab.text = XYBString(@"str_bbg_dq_rate", @"历史年化结算利率");
    [backView addSubview:showLab];

    [showLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rateLab.mas_left).offset(0);
        make.top.equalTo(rateLab.mas_bottom).offset(1);
        make.bottom.equalTo(backView.mas_bottom);
        make.right.equalTo(backView.mas_right);
    }];

    //出借按钮
    buyBtn = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, 90, 40) Title:XYBString(@"str_financing_panicBuy", @"出借") ByGradientType:leftToRight];
    buyBtn.frame = CGRectMake(MainScreenWidth - 22 - 19 - 90, 57, 90, 40);
    [buyBtn addTarget:self action:@selector(clickTouchDown:) forControlEvents:UIControlEventTouchDown];
    [buyBtn addTarget:self action:@selector(clickDragOutside:) forControlEvents:UIControlEventTouchDragInside];
    [buyBtn addTarget:self action:@selector(clickDragOutside:) forControlEvents:UIControlEventTouchDragExit];
    [buyBtn addTarget:self action:@selector(clickDragOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [buyBtn addTarget:self action:@selector(clickBuyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:buyBtn];

    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backImageView.mas_right).offset(-19);
        make.top.equalTo(backImageView.mas_top).offset(57);
        make.width.equalTo(@(90));
        make.height.equalTo(@(40));
    }];

    //画线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = COLOR_LINE;
    [backImageView addSubview:lineView];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView.mas_left).offset(19);
        make.height.equalTo(@(Line_Height));
        make.right.equalTo(backImageView.mas_right).offset(-19);
        make.bottom.equalTo(backImageView.mas_bottom).offset(-47);
    }];
    
    //时间图标
    UIImageView * financingTime = [[UIImageView alloc] init];
    financingTime.image = [UIImage imageNamed:@"financing_time"];
    [backImageView addSubview:financingTime];
    [financingTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView.mas_left).offset(19);
        make.top.equalTo(lineView.mas_bottom).offset(12);
    }];

    //出借期限
    durationLab = [[UILabel alloc] initWithFrame:CGRectZero];
    durationLab.font = TEXT_FONT_14;
    durationLab.textColor = COLOR_AUXILIARY_GREY;
    durationLab.text = XYBString(@"str_financing_sevenDays", @"7天");
    [backImageView addSubview:durationLab];

    [durationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(financingTime.mas_right).offset(5);
        make.centerY.equalTo(financingTime.mas_centerY);
    }];

    //竖线
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
    verticalLine.backgroundColor = COLOR_LINE;
    [backImageView addSubview:verticalLine];

    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(durationLab.mas_right).offset(8);
        make.width.equalTo(@(Line_Height));
        make.centerY.equalTo(durationLab.mas_centerY);
        make.height.equalTo(@(14));
    }];

    //还款方式
    repaymentLab = [[UILabel alloc] initWithFrame:CGRectZero];
    repaymentLab.font = TEXT_FONT_14;
    repaymentLab.textColor = COLOR_AUXILIARY_GREY;
    repaymentLab.text = XYBString(@"str_financing_expireBackProfitAndInvestMoney", @"到期还本息");
    [backImageView addSubview:repaymentLab];

    [repaymentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLine.mas_right).offset(8);
        make.centerY.equalTo(durationLab);
    }];

    remainLab = [[UILabel alloc] initWithFrame:CGRectZero];
    remainLab.font = TEXT_FONT_14;
    remainLab.textColor = COLOR_AUXILIARY_GREY;
    remainLab.text = XYBString(@"str_financing_remainZeroYuan", @"剩余0.00元");
    [backImageView addSubview:remainLab];

    [remainLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backImageView.mas_right).offset(-19);
        make.centerY.equalTo(durationLab);
    }];
}

- (void)clickTheImage:(id)sender {
    if (self.model) {
        self.block(self.model);
    }
}

/**
 *  @brief 点击出借按钮，进入出借界面
 */
- (void)clickBuyBtn:(id)sender {
    buyBtn.transform = CGAffineTransformMakeScale(0.9, 0.9);
    buyBtn.transform = CGAffineTransformIdentity;
    [self performSelector:@selector(ccReturnBlock) withObject:nil afterDelay:0.1];
}

- (void)clickDragOutside:(id)sender {
    buyBtn.transform = CGAffineTransformMakeScale(0.9, 0.9);
    buyBtn.transform = CGAffineTransformIdentity;
}

- (void)ccReturnBlock {
    if (self.model) {
        _block(self.model);
    }
}

- (void)clickTouchDown:(id)sender {
    buyBtn.transform = CGAffineTransformIdentity;
    buyBtn.transform = CGAffineTransformMakeScale(0.9, 0.9);
}

- (void)setModel:(CcProductModel *)model {
    _model = model;

    //产品名称
    titleLab.text = [NSString stringWithFormat:@"%@", model.typeStr];
    //剩余可投次数
    investCountLab.text = [NSString stringWithFormat:XYBString(@"str_financing_canInvestTime_zi", @"可投%@次"), model.restInvestCount];
    CGFloat width = [self calculateWidthWithString:investCountLab.text MaxSize:CGSizeMake(MainScreenWidth, 12) AndFont:12.0f LineSpace:0];

    [investCountLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width + 12));
    }];
    //利率
    NSMutableAttributedString *mutStr = [Utility rateAttributedStr:[model.rate doubleValue] size:40 sizeSymble:18 color:COLOR_MAIN_GREY];
    rateLab.attributedText = mutStr;

    //出借期限
    durationLab.text = [NSString stringWithFormat:@"%@", model.periodsStr];
    //还款方式
    repaymentLab.text = [NSString stringWithFormat:@"%@", model.refundTypeString];
    //剩余金额
    if ([model.restAmount doubleValue] == 0) {
        remainLab.text = XYBString(@"str_financing_remainZeroYuan", @"剩余0.00元");
        buyBtn.isColorEnabled = NO;
        [buyBtn setTitle:XYBString(@"str_financing_soldOut", @"售罄") forState:UIControlStateNormal];
    } else {
        remainLab.text = [NSString stringWithFormat:XYBString(@"str_financing_bidRemain", @"剩余%@元"), [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [model.restAmount doubleValue]]]];
        buyBtn.isColorEnabled = YES;
        [buyBtn setTitle:XYBString(@"str_financing_panicBuy", @"出借") forState:UIControlStateNormal];
    }

    /*
     *周周盈次数已用完，且
     * 1.周周盈剩余可投为0，则按钮为 售罄并置灰
     * 2.周周盈剩余可投不为0，则按钮为 出借并置灰
     */
    if ([model.restInvestCount doubleValue] == 0 && [model.restAmount doubleValue] <= 0) {
        buyBtn.isColorEnabled = NO;
        [buyBtn setTitle:XYBString(@"str_financing_soldOut", @"售罄") forState:UIControlStateNormal];
    } else if ([model.restInvestCount doubleValue] == 0 && [model.restAmount doubleValue] > 0) {
        buyBtn.isColorEnabled = YES;
        [buyBtn setTitle:XYBString(@"str_financing_panicBuy", @"出借") forState:UIControlStateNormal];
    }
}

//计算文字的宽度

- (CGFloat)calculateWidthWithString:(NSString *)str MaxSize:(CGSize)maxSize AndFont:(CGFloat)font LineSpace:(CGFloat)lineSpace {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 字体的行间距

    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine |
                                                            NSStringDrawingUsesLineFragmentOrigin |
                                                            NSStringDrawingUsesFontLeading
                                 attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:font],
                                               NSParagraphStyleAttributeName : paragraphStyle }
                                    context:nil]
                      .size;

    return size.width;
}

@end
