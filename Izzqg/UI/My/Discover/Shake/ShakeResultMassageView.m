//
//  ShakeResultMassageView.m
//  Ixyb
//
//  Created by wang on 15/11/23.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "ShakeResultMassageView.h"

#import "Utility.h"
#import <objc/runtime.h>

@implementation ShakeResultMassageView

static ShakeResultMassageView *_resultView = nil;

+ (ShakeResultMassageView *)shareInstanceResulView:(shakeType)type dataDic:(NSDictionary *)resultDic {
    UIApplication *app = [UIApplication sharedApplication];
    app.applicationSupportsShakeToEdit = NO;
    if (_resultView) {
        _resultView = nil;
        _resultView = [[ShakeResultMassageView alloc] init];
        _resultView.type = type;
        [_resultView setUI:resultDic];
        return _resultView;

    } else {
        _resultView = [[ShakeResultMassageView alloc] init];
        _resultView.type = type;
        [_resultView setUI:resultDic];
    }
    return _resultView;
}

- (void)setUI:(NSDictionary *)resultDic {
    self.backgroundColor = [UIColor colorWithRed:0 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.5f];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(hiddenTheView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = COLOR_COMMON_WHITE;
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = Corner_Radius_3;
    [self addSubview:contentView];

    switch (_type) {
        case Winning: {
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.centerX.equalTo(self.mas_centerX);
                make.left.equalTo(self.mas_left).offset(Margin_Length);
                make.right.equalTo(self.mas_right).offset(-Margin_Length);
            }];

            UIView *titleView = [[UIView alloc] init];
            [contentView addSubview:titleView];

            [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(contentView);
                make.top.equalTo(@30);
            }];

            UILabel *contentLab = [[UILabel alloc] init];
            contentLab.font = TEXT_FONT_18;
            contentLab.textColor = COLOR_MAIN_GREY;
            contentLab.text = XYBString(@"str_shakeGame_congratulations", @"恭喜您获得");
            [titleView addSubview:contentLab];

            [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.equalTo(@0);
            }];

            UILabel *giftLab = [[UILabel alloc] init];
            giftLab.font = TEXT_FONT_18;
            giftLab.textColor = COLOR_RED_LEVEL1;
            [titleView addSubview:giftLab];

            [giftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(contentLab.mas_right).offset(1);
                make.top.equalTo(contentLab.mas_top);
                make.right.equalTo(titleView.mas_right);
            }];

            UILabel *detailLab = [[UILabel alloc] init];
            detailLab.font = TEXT_FONT_14;
            detailLab.textColor = COLOR_AUXILIARY_GREY;
            [contentView addSubview:detailLab];
            
            [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleView.mas_bottom).offset(6);
                make.centerX.equalTo(contentView.mas_centerX);
            }];
            
            UIImageView *winImage = [[UIImageView alloc] init];
            winImage.image = [UIImage imageNamed:@"shakeGift"];
            [contentView addSubview:winImage];
            
            [winImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(detailLab.mas_bottom).offset(20);
                make.centerX.equalTo(contentView.mas_centerX);
            }];

            NSString *prizeCodeStr = [resultDic objectForKey:@"prizeCode"];
            
            NSString *buttonTitle = XYBString(@"str_look", @"查看");
            float prizeValue = [[NSString stringWithFormat:@"%.3f", [[resultDic objectForKey:@"prizeValue"] floatValue]] floatValue];

#pragma mark - V1.4.8版本后台配置摇摇乐中奖弹窗

            if ([prizeCodeStr isEqualToString:@"REWARD"]) { //礼金
                //giftLab赋值
                NSString *valueStr = [NSString stringWithFormat:XYBString(@"str_shakeGame_decimalMoney", @"%.0f元"), prizeValue];
                giftLab.attributedText = [self mutableAttributedStringWithValueStr:valueStr NameStr:XYBString(@"str_shakeGame_cash", @"礼金")];
                detailLab.text = XYBString(@"str_shakeGame_cashStoreToAcount", @"礼金已放入账户中");
                winImage.image = [UIImage imageNamed:@"shakeGift"];
                buttonTitle = XYBString(@"str_shakeGame_useRightNow", @"立即使用");

            } else if ([prizeCodeStr isEqualToString:@"SLEEPREWARD"]) { //红包
                NSString *valueStr = [NSString stringWithFormat:XYBString(@"str_shakeGame_decimalMoney", @"%.0f元"), prizeValue];
                giftLab.attributedText = [self mutableAttributedStringWithValueStr:valueStr NameStr:XYBString(@"str_shakeGame_sleepReward", @"红包")];
                detailLab.text = XYBString(@"str_shakeGame_sleepRewardStoreToAcount", @"红包已放入账户中");
                winImage.image = [UIImage imageNamed:@"shakePresent"];
                buttonTitle = XYBString(@"str_shakeGame_useRightNow", @"立即使用");

            } else if ([prizeCodeStr isEqualToString:@"INCREASECARD"]) { //收益提升卡
                NSString *valueStr = [NSString stringWithFormat:@"%.1f倍", prizeValue];
                giftLab.attributedText = [self mutableAttributedStringWithValueStr:valueStr NameStr:XYBString(@"str_increase_syk_upgrade_card", @"收益提升卡")];
                detailLab.text = XYBString(@"str_shakeGame_increaseCardStoreToAcount", @"收益提升卡已放入账户中");
                winImage.image = [UIImage imageNamed:@"shakeIncreaseCard"];
                buttonTitle = XYBString(@"str_shakeGame_useRightNow", @"立即使用");

            } else if ([prizeCodeStr isEqualToString:@"INCREASECARD_POINT"]) { //加息券
                NSString *valueStr = [NSString stringWithFormat:@"%.1f", prizeValue * 100];
                //去掉小数点后面的0
                NSString *zeroStr = [[valueStr componentsSeparatedByString:@"."] objectAtIndex:1];
                if ([zeroStr isEqualToString:@"0"]) {
                    valueStr = [valueStr substringWithRange:NSMakeRange(0, valueStr.length - 2)];
                }
                valueStr = [NSString stringWithFormat:@"%@%%倍", valueStr];
                giftLab.attributedText = [self mutableAttributedStringWithValueStr:valueStr NameStr:XYBString(@"str_increase_jxj_upgrade_card", @"加息券")];
                detailLab.text = XYBString(@"str_shakeGame_increaseCard_pointStoreToAcount", @"加息券已放入账户中");
                winImage.image = [UIImage imageNamed:@"shakeCoupons"];
                buttonTitle = XYBString(@"str_shakeGame_useRightNow", @"立即使用");

            } else if ([prizeCodeStr isEqualToString:@"ZZY"]) { //周周盈
                giftLab.attributedText = [self mutableAttributedStringWithValueStr:XYBString(@"str_shakeGame_oneTimeZZY", @"1次周周盈") NameStr:XYBString(@"str_shakeGame_investChance", @"出借机会")];
                detailLab.text = @"";
                buttonTitle = XYBString(@"str_shakeGame_useRightNow", @"立即使用");
                winImage.image = [UIImage imageNamed:@"shakezzy"];

            } else if ([prizeCodeStr isEqualToString:@"MPOS"]) { //刷卡器
                giftLab.attributedText = [self mutableAttributedStringWithValueStr:XYBString(@"str_shakeGame_oneMpos", @"刷卡器1台") NameStr:@""];
                detailLab.text = XYBString(@"str_shakeGame_getMposAtRecord", @"可到“中奖记录”中领取");
                winImage.image = [UIImage imageNamed:@"shakepos"];
                buttonTitle = XYBString(@"str_shakeGame_getRightNow", @"立即领取");

            } else if ([prizeCodeStr isEqualToString:@"SCORE"]) { //  积分
                NSString *valueStr = [NSString stringWithFormat:@"%.0f", prizeValue];
                giftLab.attributedText = [self mutableAttributedStringWithValueStr:valueStr NameStr:XYBString(@"str_invested_project_jf", @"积分")];
                detailLab.text = XYBString(@"str_shakeGame_scoreStoreToAcount", @"积分已放入账户中");
                winImage.image = [UIImage imageNamed:@"score"];
                buttonTitle = XYBString(@"str_look", @"查看");
            }

            UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
            lineView.backgroundColor = COLOR_LINE;
            [contentView addSubview:lineView];

            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(contentView);
                make.height.equalTo(@(Line_Height));
                make.top.equalTo(winImage.mas_bottom).offset(Margin_Length);
            }];

            XYButton *shareBtn = [[XYButton alloc] initWithSubordinationButtonTitle:XYBString(@"str_shakeGame_shareToOthers", @"炫耀一下") isUserInteractionEnabled:YES];
            [shareBtn setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
            [shareBtn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:shareBtn];

            [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(contentView.mas_left).offset(0);
                make.top.equalTo(lineView.mas_bottom).offset(0);
                make.height.equalTo(@(45));
                make.bottom.equalTo(contentView.mas_bottom).offset(0);
            }];

            UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
            lineView2.backgroundColor = COLOR_LINE;
            [contentView addSubview:lineView2];

            [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(shareBtn.mas_right).offset(0);
                make.top.equalTo(lineView.mas_bottom).offset(0);
                make.width.equalTo(@(Line_Height));
                make.bottom.equalTo(contentView.mas_bottom).offset(0);
            }];

            XYButton *btn = [[XYButton alloc] initWithSubordinationButtonTitle:buttonTitle isUserInteractionEnabled:YES];
            objc_setAssociatedObject(btn, "prizeCodeStr", nil, OBJC_ASSOCIATION_RETAIN);
            objc_setAssociatedObject(btn, "prizeCodeStr", prizeCodeStr, OBJC_ASSOCIATION_RETAIN);
            [btn addTarget:self action:@selector(clickTheMyCardButton:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:btn];

            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(shareBtn.mas_right).offset(Line_Height);
                make.right.equalTo(contentView.mas_right).offset(0);
                make.centerY.equalTo(shareBtn.mas_centerY);
                make.width.equalTo(shareBtn.mas_width);
                make.height.equalTo(@(45));
            }];

        } break;
        case NotWinAndHaveOpportunity: {
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.centerY.equalTo(self.mas_centerY);
                make.left.equalTo(self.mas_left).offset(Margin_Length);
                make.right.equalTo(self.mas_right).offset(-Margin_Length);
                make.height.equalTo(@200);
            }];

            UILabel *titleLab = [[UILabel alloc] init];
            titleLab.font = TEXT_FONT_18;
            titleLab.textColor = COLOR_RED_LEVEL1;
            titleLab.text = XYBString(@"str_shakeGame_noGift", @"哎呀,没摇到奖品!");
            [contentView addSubview:titleLab];

            [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(contentView.mas_centerX);
                make.top.equalTo(@30);
            }];

            UILabel *contentLab = [[UILabel alloc] init];
            contentLab.font = TEXT_FONT_18;
            contentLab.textColor = COLOR_MAIN_GREY;
            contentLab.text = XYBString(@"str_shakeGame_investGetShakeChance", @"出借满1000元摇奖次数");
            [contentView addSubview:contentLab];

            [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(contentView.mas_centerX).offset(-Margin_Length);
                make.top.equalTo(titleLab.mas_bottom).offset(10);
            }];
            UILabel *addtitleLab = [[UILabel alloc] init];
            addtitleLab.font = TEXT_FONT_18;
            addtitleLab.textColor = COLOR_RED_LEVEL1;
            addtitleLab.text = @"+1";
            [contentView addSubview:addtitleLab];

            [addtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(contentLab.mas_right);
                make.top.equalTo(contentLab.mas_top);
            }];

            UILabel *describeLab = [[UILabel alloc] init];
            describeLab.textColor = COLOR_LIGHT_GREY;
            describeLab.font = TEXT_FONT_14;
            describeLab.text = XYBString(@"str_shakeGame_onlyInvestFHQInvest", @"(仅限APP出借)");
            //            contentLab.numberOfLines = 2;
            describeLab.textAlignment = NSTextAlignmentCenter;
            [contentView addSubview:describeLab];

            [describeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@20);
                make.right.equalTo(@(-20));
                make.top.equalTo(contentLab.mas_bottom).offset(Margin_Length);
            }];

            ColorButton *financingButton = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 40, 50.F) Title:XYBString(@"str_shakeGame_IWantToInvest", @"我要出借") ByGradientType:leftToRight];
            [financingButton addTarget:self action:@selector(clickTheFinancingButton:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:financingButton];

            [financingButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@20);
                make.right.equalTo(@(-20));
                make.bottom.equalTo(contentView.mas_bottom).offset(-20);
                make.height.equalTo(@50);
            }];

        } break;
        case NotWinAndNoOpportunity: {
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.centerY.equalTo(self.mas_centerY);
                make.left.equalTo(self.mas_left).offset(Margin_Length);
                make.right.equalTo(self.mas_right).offset(-Margin_Length);
                make.height.equalTo(@120);
            }];

            UILabel *titleLab = [[UILabel alloc] init];
            titleLab.font = TEXT_FONT_18;
            titleLab.textColor = COLOR_RED_LEVEL1;
            titleLab.text = XYBString(@"str_shakeGame_noGift", @"哎呀,没摇到奖品！");
            [contentView addSubview:titleLab];

            [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(contentView.mas_centerX);
                make.centerY.equalTo(contentView.mas_centerY);
            }];

        } break;
        case NoOpportunity: {
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.centerY.equalTo(self.mas_centerY);
                make.left.equalTo(self.mas_left).offset(Margin_Length);
                make.right.equalTo(self.mas_right).offset(-Margin_Length);
                make.height.equalTo(@140);
            }];

            UILabel *titleLab = [[UILabel alloc] init];
            titleLab.font = TEXT_FONT_18;
            titleLab.textColor = COLOR_RED_LEVEL1;
            titleLab.text = XYBString(@"str_shakeGame_noGift", @"哎呀,没摇到奖品！");
            [contentView addSubview:titleLab];

            [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(contentView.mas_centerX);
                make.top.equalTo(@50);
            }];

            UILabel *contentLab = [[UILabel alloc] init];
            contentLab.textColor = COLOR_LIGHT_GREY;
            contentLab.font = TEXT_FONT_12;
            contentLab.text = XYBString(@"str_shakeGame_shakeTimeUseUpAndComeTomorrow", @"您今天的摇摇次数都用完了明天再来吧");
            contentLab.numberOfLines = 2;
            contentLab.textAlignment = NSTextAlignmentCenter;
            [contentView addSubview:contentLab];

            [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@20);
                make.right.equalTo(@(-20));
                make.top.equalTo(titleLab.mas_bottom).offset(Margin_Length);
            }];
        } break;
        case Financing: {
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.centerY.equalTo(self.mas_centerY);
                make.left.equalTo(self.mas_left).offset(Margin_Length);
                make.right.equalTo(self.mas_right).offset(-Margin_Length);
                make.height.equalTo(@180);
            }];

            UILabel *titleLab = [[UILabel alloc] init];
            titleLab.font = TEXT_FONT_18;
            titleLab.textColor = COLOR_MAIN_GREY;
            titleLab.text = XYBString(@"str_shakeGame_investGetShakeChance", @"出借满1000元摇奖次数");
            [contentView addSubview:titleLab];

            [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(contentView.mas_centerX);
                make.top.equalTo(@30);
            }];
            UILabel *addtitleLab = [[UILabel alloc] init];
            addtitleLab.font = TEXT_FONT_18;
            addtitleLab.textColor = COLOR_RED_LEVEL1;
            addtitleLab.text = @"+1";
            [contentView addSubview:addtitleLab];

            [addtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(titleLab.mas_right);
                make.top.equalTo(titleLab.mas_top);
            }];

            UILabel *contentLab = [[UILabel alloc] init];
            contentLab.textColor = COLOR_LIGHT_GREY;
            contentLab.font = TEXT_FONT_14;
            contentLab.text = XYBString(@"str_shakeGame_onlyInvestFHQInvest", @"(仅限APP出借)");
            //            contentLab.numberOfLines = 2;
            contentLab.textAlignment = NSTextAlignmentCenter;
            [contentView addSubview:contentLab];

            [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@20);
                make.right.equalTo(@(-20));
                make.top.equalTo(titleLab.mas_bottom).offset(Margin_Length);
            }];


            ColorButton *financingButton = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 40, 50.F) Title:XYBString(@"str_shakeGame_IWantToInvest", @"我要出借") ByGradientType:leftToRight];
            [financingButton addTarget:self action:@selector(clickTheFinancingButton:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:financingButton];

            [financingButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@20);
                make.right.equalTo(@(-20));
                make.bottom.equalTo(contentView.mas_bottom).offset(-20);
                make.height.equalTo(@50);
            }];

        } break;
        case IsNullOpportunity: {
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.centerY.equalTo(self.mas_centerY);
                make.left.equalTo(self.mas_left).offset(Margin_Length);
                make.right.equalTo(self.mas_right).offset(-Margin_Length);
                make.height.equalTo(@100);
            }];
            UILabel *contentLab = [[UILabel alloc] init];
            contentLab.textColor = COLOR_MAIN_GREY;
            contentLab.font = TEXT_FONT_18;
            contentLab.text = XYBString(@"str_shakeGame_shakeTimeUseUpAndComeTomorrow", @"您今天的摇摇次数都用完了明天再来吧");
            contentLab.numberOfLines = 2;
            contentLab.textAlignment = NSTextAlignmentCenter;
            [contentView addSubview:contentLab];

            [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@20);
                make.right.equalTo(@(-20));
                make.centerY.equalTo(contentView.mas_centerY);
            }];
        } break;
        default:
            break;
    }

    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"alret_close"] forState:UIControlStateNormal];
    [deleteBtn setImage:[UIImage imageNamed:@"alret_close"] forState:UIControlStateHighlighted];
    [deleteBtn addTarget:self action:@selector(hiddenTheView) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:deleteBtn];

    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.top.equalTo(@10);
    }];
}

- (NSMutableAttributedString *)mutableAttributedStringWithValueStr:(NSString *)valueStr NameStr:(NSString *)nameStr {
    NSArray *attrArray = @[
        @{
            @"kStr" : valueStr,
            @"kColor" : COLOR_STRONG_RED,
            @"kFont" : TEXT_FONT_18,
        },
        @{
            @"kStr" : nameStr,
            @"kColor" : COLOR_MAIN_GREY,
            @"kFont" : TEXT_FONT_18,
        }
    ];

    NSMutableAttributedString *attributedStr = [Utility multAttributedString:attrArray];
    return attributedStr;
}

- (void)hiddenTheView {

    if (self.clickHiddenButton) {
        self.clickHiddenButton();
    }
    [self removeFromSuperview];
}

- (void)clickTheMyCardButton:(id)sender {
    if (self.clickMyCardButton) {
        XYButton *btn = (XYButton *) sender;
        NSString *prizeCodeStr = (NSString *) objc_getAssociatedObject(btn, "prizeCodeStr");
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
        if (prizeCodeStr) {
            [param setObject:prizeCodeStr forKey:@"prizeCodeStr"];
        }
        self.clickMyCardButton(param);
    }
    [self removeFromSuperview];
}

/**
 *  分享
 *
 *  @param sender
 */
- (void)clickShareBtn:(id)sender {
    if (self.clickShareButton) {
        self.clickShareButton();
    }
    [self removeFromSuperview];
}

- (void)clickTheFinancingButton:(id)sender {
    if (self.clickFinancingButton) {
        self.clickFinancingButton();
    }
    [self removeFromSuperview];
}

@end
