//
//  RecomendView.m
//  Ixyb
//
//  Created by dengjian on 16/12/12.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "RecomendView.h"
#import "Utility.h"

//首页推荐模块（定期宝）
@implementation RecomendView {
    UILabel *titleLab; //产品名称
    UILabel *rateLab;
    UILabel *addLab;       //加息多少
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

    UIImageView *recommendImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recommend"]];
    [backImageView addSubview:recommendImgView];

    [recommendImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_top);
        make.right.equalTo(backImageView.mas_right).offset(-20);
    }];

    titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = BIG_TEXT_FONT_17;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = XYBString(@"str_common_ccny", @"策诚年盈");
    [backImageView addSubview:titleLab];

    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView).offset(19);
        make.top.equalTo(backImageView).offset(Margin_Length);
        make.height.equalTo(@(17));
    }];

    _activityLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _activityLab.backgroundColor = COLOR_COMMON_CLEAR;
    _activityLab.font = TEXT_FONT_12;
    _activityLab.textColor = COLOR_ORANGE;
    _activityLab.layer.borderColor = COLOR_ORANGE_BORDER.CGColor;
    _activityLab.layer.borderWidth = Border_Width_2;
    _activityLab.layer.cornerRadius = Corner_Radius_9;
    _activityLab.clipsToBounds = YES;
    _activityLab.textAlignment = NSTextAlignmentCenter;
    _activityLab.text = XYBString(@"str_financing_activity", @"活动");
    _activityLab.hidden = YES;
    [backImageView addSubview:_activityLab];

    [_activityLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_right).offset(8);
        make.centerY.equalTo(titleLab.mas_centerY);
        make.width.equalTo(@45);
        make.height.equalTo(@(18));
    }];

    _addProfitLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _addProfitLab.backgroundColor = COLOR_COMMON_CLEAR;
    _addProfitLab.font = TEXT_FONT_12;
    _addProfitLab.textColor = COLOR_ORANGE;
    _addProfitLab.layer.borderColor = COLOR_ORANGE_BORDER.CGColor;
    _addProfitLab.layer.borderWidth = Border_Width_2;
    _addProfitLab.layer.cornerRadius = Corner_Radius_9;
    _addProfitLab.clipsToBounds = YES;
    _addProfitLab.textAlignment = NSTextAlignmentCenter;
    _addProfitLab.text = XYBString(@"str_financing_addProfit", @"加息");
    _addProfitLab.hidden = YES;
    [backImageView addSubview:_addProfitLab];

    [_addProfitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_activityLab.mas_right).offset(8);
        make.centerY.equalTo(titleLab.mas_centerY);
        make.width.equalTo(@45);
        make.height.equalTo(@(18));
    }];

    //backView将rateLab、addLab和showLab包裹起来
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
        make.top.equalTo(@(0));
        make.height.equalTo(@(40));
    }];

    addLab = [[UILabel alloc] initWithFrame:CGRectZero];
    addLab.backgroundColor = COLOR_BG;
    addLab.font = TEXT_FONT_12;
    addLab.textColor = COLOR_MAIN_GREY;
    addLab.layer.borderColor = COLOR_LINE.CGColor;
    addLab.layer.borderWidth = Border_Width;
    addLab.layer.borderWidth = Border_Width;
    addLab.layer.cornerRadius = Corner_Radius_9;
    addLab.clipsToBounds = YES;
    addLab.textAlignment = NSTextAlignmentCenter;
    addLab.text = XYBString(@"str_financing_addZeroPercent", @"+0%");
    [backView addSubview:addLab];

    [addLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rateLab.mas_right).offset(8);
        make.bottom.equalTo(rateLab.mas_bottom).offset(-5);
        make.height.equalTo(@(19));
        make.width.equalTo(@(36));
    }];

    UILabel *showLab = [[UILabel alloc] initWithFrame:CGRectZero];
    showLab.font = TEXT_FONT_12;
    showLab.textColor = COLOR_LIGHT_GREY;
    showLab.text = XYBString(@"str_bbg_dq_rate", @"历史年化结算利率");
    [backView addSubview:showLab];

    [showLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rateLab.mas_left).offset(0);
        make.top.equalTo(rateLab.mas_bottom).offset(4);
        make.bottom.equalTo(backView.mas_bottom);
        make.right.equalTo(backView.mas_right);
    }];

    //出借按钮
    buyBtn = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, 90.f, 40.f) Title:XYBString(@"str_financing_panicBuy", @"出借") ByGradientType:leftToRight];
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
    durationLab.text = XYBString(@"str_financing_12Months", @"12个月");
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
        _block(self.model);
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
    //利率
    NSMutableAttributedString *mutStr = [Utility rateAttributedStr:[model.rate doubleValue] size:40 sizeSymble:18 color:COLOR_MAIN_GREY];
    rateLab.attributedText = mutStr;

    //推荐中活动
    if (model.activityDesc.length > 0) {
        self.activityLab.hidden = NO;
        self.activityLab.text = [NSString stringWithFormat:@"%@", model.activityDesc];
        CGFloat width = model.activityDesc.length * 12 + 16;
        [self.activityLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLab.mas_right).offset(8);
            make.width.equalTo(@(width));
        }];
        
    } else {
        self.activityLab.hidden = YES;
        [self.activityLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLab.mas_right).offset(0);
            make.width.equalTo(@0);
        }];
    }

    //推荐中的加息
    if (model.rewardDesc.length > 0) {
        self.addProfitLab.hidden = NO;
        self.addProfitLab.text = [NSString stringWithFormat:@"%@", model.rewardDesc];

        CGFloat width = [self calculateWidthWithString:self.addProfitLab.text MaxSize:CGSizeMake(MainScreenWidth, 14) AndFont:14.0f LineSpace:0] + 8;
        [self.addProfitLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_activityLab.mas_right).offset(8);
            make.width.equalTo(@(width));
        }];
        
    } else {
        self.addProfitLab.hidden = YES;
        [self.addProfitLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_activityLab.mas_right).offset(0);
            make.width.equalTo(@0);
        }];
    }

    //加息多少
    if ([model.addRate doubleValue] <= 0) {
        addLab.hidden = YES;
    } else {
        addLab.hidden = NO;
        addLab.text = [NSString stringWithFormat:XYBString(@"str_financing_addSomePercent", @"+%@%%"), [Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [model.addRate doubleValue]* 100]]];
        CGFloat width = [self calculateWidthWithString:addLab.text MaxSize:CGSizeMake(MainScreenWidth, 14) AndFont:12.0f LineSpace:0] + 8;

        [addLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width));
        }];
    }

    //出借期限
    durationLab.text = [NSString stringWithFormat:@"%@", model.periodsStr];
    //还款方式
    repaymentLab.text = [NSString stringWithFormat:@"%@", model.refundTypeString];
    //剩余金额
    if ([model.restAmount doubleValue] <= 0) {
        remainLab.text = XYBString(@"str_financing_remainZeroYuan", @"剩余0.00元");
        buyBtn.isColorEnabled = NO;
        [buyBtn setTitle:XYBString(@"str_financing_soldOut", @"售罄") forState:UIControlStateNormal];
    } else {
        remainLab.text = [NSString stringWithFormat:XYBString(@"str_financing_bidRemain", @"剩余%@元"), [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [model.restAmount doubleValue]]]];
        buyBtn.isColorEnabled = YES;
        [buyBtn setTitle:XYBString(@"str_financing_panicBuy", @"出借") forState:UIControlStateNormal];
    }
}

//计算文字的宽度
- (CGFloat)calculateWidthWithString:(NSString *)str MaxSize:(CGSize)maxSize AndFont:(CGFloat)font LineSpace:(CGFloat)lineSpace {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 字体的行间距

    CGSize size = [str boundingRectWithSize:maxSize
                                    options:NSStringDrawingTruncatesLastVisibleLine |
                                            NSStringDrawingUsesLineFragmentOrigin |
                                            NSStringDrawingUsesFontLeading
                                 attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:font],
                                               NSParagraphStyleAttributeName : paragraphStyle }
                                    context:nil]
                      .size;

    return size.width;
}

@end
