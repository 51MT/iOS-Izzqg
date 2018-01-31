//
//  BindingBankView.m
//  Ixyb
//
//  Created by wang on 15/10/22.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "BindedBankView.h"

#import "Utility.h"

@implementation BindedBankView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        [self setUI];
    }
    return self;
}

- (void)setUI {

    UIView *bindedView = [[UIView alloc] initWithFrame:CGRectZero];
    bindedView.backgroundColor = COLOR_COMMON_WHITE;
    bindedView.layer.masksToBounds = YES;
    bindedView.layer.cornerRadius = Corner_Radius;
    [self addSubview:bindedView];

    [bindedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.height.equalTo(@160);
    }];

    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    logoImage.tag = 201;
    [bindedView addSubview:logoImage];
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@10);
        make.width.height.equalTo(@26);
    }];

    UILabel *bankNameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    bankNameLab.font = TEXT_FONT_18;
    bankNameLab.textColor = COLOR_MAIN_GREY;
    //    bankNameLab.text = XYBString(@"string_gongshan_bank",@"中国工商银行");
    bankNameLab.tag = 202;
    [bindedView addSubview:bankNameLab];

    [bankNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.centerY.equalTo(logoImage.mas_centerY);

    }];

    UILabel *bankStateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    bankStateLab.font = TEXT_FONT_12;
    bankStateLab.textColor = COLOR_LIGHT_GREY;
    bankStateLab.text = XYBString(@"string_state_bank", @"已绑定");
    //    bankStateLab.tag = 202;
    [bindedView addSubview:bankStateLab];

    [bankStateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-20));
        make.centerY.equalTo(logoImage.mas_centerY);

    }];

    UILabel *cardTypeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    cardTypeLab.font = TEXT_FONT_16;
    cardTypeLab.textColor = COLOR_LIGHT_GREY;
    cardTypeLab.text = XYBString(@"string_cxk", @"储蓄卡");
    [bindedView addSubview:cardTypeLab];

    [cardTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logoImage.mas_right).offset(5);
        make.top.equalTo(bankNameLab.mas_bottom).offset(9);

    }];

    UILabel *cardNumberLab = [[UILabel alloc] initWithFrame:CGRectZero];
    cardNumberLab.font = GENERAL_MIDDLE_BIG_FONT;
    cardNumberLab.textColor = COLOR_MAIN_GREY;
    cardNumberLab.text = @"**** **** **** ****";
    cardNumberLab.tag = 203;
    [bindedView addSubview:cardNumberLab];

    [cardNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankNameLab.mas_left);
        make.centerY.equalTo(bindedView.mas_centerY).offset(10);
        make.right.equalTo(bindedView.mas_right).offset(-Margin_Length);
    }];

    UIImageView *verLineImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    verLineImage.image = [UIImage imageNamed:@"verLine"];
    [bindedView addSubview:verLineImage];

    [verLineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankNameLab.mas_left);
        make.top.equalTo(bindedView.mas_bottom).offset(-43);
        make.right.equalTo(bindedView.mas_right).offset(-Margin_Length);
        make.height.equalTo(@1);
    }];

    UILabel *phoneLab = [[UILabel alloc] initWithFrame:CGRectZero];
    phoneLab.font = TEXT_FONT_16;
    phoneLab.textColor = COLOR_LIGHT_GREY;
    phoneLab.text = @"13*****";
    phoneLab.tag = 204;
    [bindedView addSubview:phoneLab];

    [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankNameLab.mas_left);
        make.top.equalTo(verLineImage.mas_bottom).offset(10);
    }];
}

- (void)setBankDic:(NSMutableDictionary *)bankDic {

    UIImageView *imgeView = (UIImageView *) [self viewWithTag:201];

    UILabel *lab1 = (UILabel *) [self viewWithTag:202];
    UILabel *lab2 = (UILabel *) [self viewWithTag:203];
    UILabel *lab3 = (UILabel *) [self viewWithTag:204];

    if ([bankDic objectForKey:@"bankName"]) {
        lab1.text = [bankDic objectForKey:@"bankName"];
    } else {
        lab1.text = @" ";
    }

    if ([bankDic objectForKey:@"bankImage"]) {
        imgeView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bank%@", [bankDic objectForKey:@"bankImage"]]];
    }
    //    else {//不要默认
    //        imgeView.image = [UIImage imageNamed:@"bank1"];
    //    }

    NSString *bankNumStr = [bankDic objectForKey:@"accountNumber"];
    if (bankNumStr) {
        lab2.text = [NSString stringWithFormat:@"**** **** **** %@", [bankNumStr substringWithRange:NSMakeRange(bankNumStr.length - 4, 4)]];
    } else {
        lab2.text = @"";
    }

    if ([bankDic objectForKey:@"mobilePhone"]) {
        lab3.text = [Utility thePhoneReplaceTheStr:[bankDic objectForKey:@"mobilePhone"]];
    } else {
        lab3.text = @"";
    }
}

@end
