//
//  IncomeDetailTableViewCell.m
//  Ixyb
//
//  Created by wangjianimac on 15/6/30.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "IncomeDetailTableViewCell.h"

#import "Utility.h"

@implementation IncomeDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = TEXT_FONT_16;
    titleLabel.textColor = COLOR_MAIN_GREY;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.tag = 300;
    [self.contentView addSubview:titleLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];

    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = @"05-22";
    dateLabel.tag = 301;
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
    moneyLabel.textColor = COLOR_ORANGE;
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.tag = 302;
    [self.contentView addSubview:moneyLabel];

    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];

    UILabel *useableLabel = [[UILabel alloc] init];
    useableLabel.text = @"30.33";
    useableLabel.font = TEXT_FONT_12;
    useableLabel.textColor = COLOR_LIGHT_GREY;
    useableLabel.textAlignment = NSTextAlignmentRight;
    useableLabel.tag = 303;
    [self.contentView addSubview:useableLabel];

    [useableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];

    [XYCellLine initWithBottomLine_3_AtSuperView:self.contentView];
}

- (void)setIncomeDetail:(transDetails *)transDetail {

    UILabel *lab1 = (UILabel *) [self viewWithTag:300];
    UILabel *lab2 = (UILabel *) [self viewWithTag:301];
    UILabel *lab3 = (UILabel *) [self viewWithTag:302];
    UILabel *lab4 = (UILabel *) [self viewWithTag:303];

    lab1.text = transDetail.accountActionTypeString;
    lab2.text = transDetail.dateStr;
    if (transDetail.income) {
        lab3.text = [NSString stringWithFormat:@"+ %@", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", transDetail.amount]]];
        lab3.textColor = COLOR_ORANGE;
    } else {
        lab3.text = [NSString stringWithFormat:@"- %@", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", transDetail.amount]]];
        lab3.textColor = COLOR_LIGHT_GREEN;
    }
    if (transDetail.balance == 0) {
        lab4.text = XYBString(@"string_useabel_zero", @"可用 0.00");
    } else {
        lab4.text = [NSString stringWithFormat:XYBString(@"string_useabel_some", @"可用 %@"),
                                               [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", transDetail.balance]]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
