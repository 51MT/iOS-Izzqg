//
//  ReportView.m
//  Ixyb
//
//  Created by wang on 15/10/20.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "ReportView.h"

@implementation ReportView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_WHITE;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    UILabel *customLab = nil;
    NSArray *titleArr = @[ XYBString(@"str_level", @"层级"),
                           XYBString(@"str_register_num", @"注册人数"),
                           XYBString(@"str_amount_money", @"出借金额(元)"),
                           XYBString(@"str_income_money", @"预期收益(元)") ];
    for (int x = 0; x < 4; x++) {
        UILabel *headerLab = [[UILabel alloc] init];
        headerLab.text = [titleArr objectAtIndex:x];
        headerLab.textColor = COLOR_LIGHT_GREY;
        if (IS_IPHONE_6P || IS_IPHONE_6) {
            headerLab.font = TEXT_FONT_12;
        } else {
            headerLab.font = TEXT_FONT_10;
        }
        if (x == 3) {
            headerLab.textAlignment = NSTextAlignmentRight;
        } else {
            headerLab.textAlignment = NSTextAlignmentLeft;
        }
        [self addSubview:headerLab];
        [headerLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@((MainScreenWidth - 60) / 4));
            make.top.equalTo(@8);
            if (customLab) {
                make.left.equalTo(customLab.mas_right);
            } else {
                make.left.equalTo(@(Margin_Left));
            }
        }];
        customLab = headerLab;
    }
    UIImageView *verlineImage1 = [[UIImageView alloc] init];
    verlineImage1.image = [UIImage imageNamed:@"onePoint"];

    [self addSubview:verlineImage1];
    [verlineImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Left);
        make.right.equalTo(@-Margin_Right);
        make.top.equalTo(@29.5);
        make.height.equalTo(@1);
    }];

    UIView *dataView = [[UIView alloc] init];
    dataView.backgroundColor = COLOR_COMMON_WHITE;
    [self addSubview:dataView];

    [dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(verlineImage1.mas_bottom);
        make.height.equalTo(@90);
    }];

    UILabel *custom1Lab = nil;
    NSArray *dataArr = @[ XYBString(@"str_one_level", @"1级"),
                          @"0",
                          @"0.00",
                          @"0.00" ];
    for (int x = 0; x < 4; x++) {
        UILabel *data1Lab = [[UILabel alloc] init];
        data1Lab.tag = 500 + x;
        data1Lab.text = [dataArr objectAtIndex:x];
        data1Lab.textColor = COLOR_MAIN_GREY;
        if (IS_IPHONE_6) {
            data1Lab.font = TEXT_FONT_12;
        } else if (IS_IPHONE_6P) {
            data1Lab.font = TEXT_FONT_14;
        } else {
            data1Lab.font = TEXT_FONT_10;
        }
        if (x == 3) { //更改列的文本颜色
            data1Lab.textColor = COLOR_STRONG_RED;
        }
        if (x == 3) {
            data1Lab.textAlignment = NSTextAlignmentRight;
        } else {
            data1Lab.textAlignment = NSTextAlignmentLeft;
        }

        [dataView addSubview:data1Lab];

        [data1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@((MainScreenWidth - 60) / 4));
            if (IS_IPHONE_6 || IS_IPHONE_6P) {
                make.top.equalTo(@12);
            } else {
                make.top.equalTo(@17);
            }

            if (custom1Lab) {
                make.left.equalTo(custom1Lab.mas_right);
            } else {
                make.left.equalTo(@(Margin_Left));
            }
        }];
        custom1Lab = data1Lab;
    }

    UIImageView *verlineImage2 = [[UIImageView alloc] init];
    verlineImage2.image = [UIImage imageNamed:@"onePoint"];

    [self addSubview:verlineImage2];
    [verlineImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Left);
        make.right.equalTo(@-Margin_Right);
        make.top.equalTo(verlineImage1.mas_bottom).offset(44.5);
        ;
        make.height.equalTo(@1);
    }];

    UILabel *custom2Lab = nil;
    NSArray *data2Arr = @[ XYBString(@"str_two_level", @"2级"), @"0", @"0.00", @"0.00" ];
    for (int x = 0; x < 4; x++) {
        UILabel *data2Lab = [[UILabel alloc] init];
        data2Lab.tag = 600 + x;
        data2Lab.text = [data2Arr objectAtIndex:x];
        data2Lab.textColor = COLOR_MAIN_GREY;
        if (IS_IPHONE_6) {
            data2Lab.font = TEXT_FONT_12;
        } else if (IS_IPHONE_6P) {
            data2Lab.font = TEXT_FONT_14;
        } else {
            data2Lab.font = TEXT_FONT_10;
        }
        if (x == 3) { //更改列的文本颜色
            data2Lab.textColor = COLOR_STRONG_RED;
        }
        if (x == 3) {
            data2Lab.textAlignment = NSTextAlignmentRight;
        } else {
            data2Lab.textAlignment = NSTextAlignmentLeft;
        }
        [dataView addSubview:data2Lab];

        [data2Lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@((MainScreenWidth - 60) / 4));
            if (IS_IPHONE_6 || IS_IPHONE_6P) {
                make.top.equalTo(verlineImage2.mas_bottom).offset(10);
            } else {
                make.top.equalTo(verlineImage2.mas_bottom).offset(15);
            }
            if (custom2Lab) {
                make.left.equalTo(custom2Lab.mas_right);
            } else {
                make.left.equalTo(@(Margin_Left));
            }
        }];
        custom2Lab = data2Lab;
    }
}

- (void)setReport1:(ReportModel *)report1 {
    UILabel *lab1 = (UILabel *) [self viewWithTag:500];
    UILabel *lab2 = (UILabel *) [self viewWithTag:501];
    UILabel *lab3 = (UILabel *) [self viewWithTag:502];
    UILabel *lab4 = (UILabel *) [self viewWithTag:503];

    if (report1.relationlevel && [report1.relationlevel isEqualToString:@""]) {
        lab1.text = XYBString(@"str_one_level", @"1级");
    }
    if (report1.registerNum != 0) {
        lab2.text = [NSString stringWithFormat:@"%ld", (long) report1.registerNum];
    } else {
        lab2.text = @"0";
    }
    if (report1.totalAmount != 0) {
        lab3.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", report1.totalAmount]];
    } else {
        lab3.text = @"0.00";
    }
    if (![StrUtil isEmptyString:report1.incomeAmount] && [report1.incomeAmount doubleValue] > 0) {
        lab4.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [report1.incomeAmount doubleValue]]];
    } else {
        lab4.text = @"0.00";
    }
}

- (void)setReport2:(ReportModel *)report2 {

    UILabel *lab5 = (UILabel *) [self viewWithTag:600];
    UILabel *lab6 = (UILabel *) [self viewWithTag:601];
    UILabel *lab7 = (UILabel *) [self viewWithTag:602];
    UILabel *lab8 = (UILabel *) [self viewWithTag:603];

    if (report2.relationlevel && [report2.relationlevel isEqualToString:@""]) {
        lab5.text = XYBString(@"str_one_level", @"1级");
    }
    if (report2.registerNum != 0) {
        lab6.text = [NSString stringWithFormat:@"%ld", (long) report2.registerNum];
    } else {
        lab6.text = @"0";
    }
    if (report2.totalAmount != 0) {
        lab7.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", report2.totalAmount]];
    } else {
        lab7.text = @"0.00";
    }
    if (![StrUtil isEmptyString:report2.incomeAmount] && [report2.incomeAmount doubleValue] > 0) {
        lab8.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [report2.incomeAmount doubleValue]]];
    } else {
        lab8.text = @"0.00";
    }
}
@end
