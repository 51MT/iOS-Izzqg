//
//  EarnBonusCell.m
//  Ixyb
//
//  Created by wang on 15/9/1.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "EarnBonusCell.h"

#import "Utility.h"

@implementation EarnBonusCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        [self setUI];
    }
    return self;
}

- (void)setUI {

    UILabel *stageLabel = [[UILabel alloc] init];
    stageLabel.text = XYBString(@"string_invest", @"出借");
    stageLabel.tag = 303;
    stageLabel.font = TEXT_FONT_16;
    stageLabel.textColor = COLOR_MAIN_GREY;
    [self.contentView addSubview:stageLabel];

    [stageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];

    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = @"05-22";
    dateLabel.tag = 302;
    dateLabel.font = TEXT_FONT_12;
    dateLabel.textColor = COLOR_LIGHT_GREY;
    [self.contentView addSubview:dateLabel];

    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];

    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.text = @"530.33";
    moneyLabel.font = TEXT_FONT_16;
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.tag = 301;
    moneyLabel.textColor = COLOR_LIGHT_GREEN;
    [self.contentView addSubview:moneyLabel];

    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [XYCellLine initWithBottomLine_3_AtSuperView:self.contentView];
}

- (void)setEarnBonus:(EarnEarmBonus *)earnBonus {

    UILabel *lab1 = (UILabel *) [self viewWithTag:301];
    UILabel *lab2 = (UILabel *) [self viewWithTag:302];
    UILabel *lab3 = (UILabel *) [self viewWithTag:303];
    NSString *amontString = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [earnBonus.amount doubleValue]]];
    NSString *amuntStr = [Utility replaceTheNumberForNSNumberFormatter:amontString];
    lab1.text = [NSString stringWithFormat:XYBString(@"string_some_yuan", @"%@元"), amuntStr];
    lab3.text = earnBonus.username;

    if (earnBonus.isInvest) {
        lab1.textColor = COLOR_STRONG_RED;
        lab2.text = earnBonus.realName;
        lab2.textColor = COLOR_LIGHT_GREY;
    } else {
        lab1.textColor = COLOR_LIGHT_GREY;
        lab2.text = XYBString(@"string_not_invested", @"未出借");
        lab2.textColor = COLOR_STRONG_RED;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
