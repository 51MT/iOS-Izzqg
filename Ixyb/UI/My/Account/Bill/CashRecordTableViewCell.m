//
//  CashRecordTableViewCell.m
//  Ixyb
//
//  Created by wangjianimac on 15/6/30.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "CashRecordTableViewCell.h"

#import "Utility.h"

#define VIEW_TAG_CANCEL_BUTTON 51401

@implementation CashRecordTableViewCell

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

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = TEXT_FONT_16;
    titleLabel.textColor = COLOR_MAIN_GREY;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.tag = 300;
    [self.contentView addSubview:titleLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];

    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    dateLabel.text = @"05-22";
    dateLabel.tag = 302;
    dateLabel.font = TEXT_FONT_12;
    dateLabel.textColor = COLOR_LIGHT_GREY;
    [self.contentView addSubview:dateLabel];

    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];

    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    moneyLabel.text = @"530.33";
    moneyLabel.font = TEXT_FONT_16;
    moneyLabel.textColor = COLOR_LIGHT_GREEN;
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.tag = 301;
    [self.contentView addSubview:moneyLabel];

    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:button];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = Corner_Radius;
    button.backgroundColor = COLOR_MAIN;
    button.tag = VIEW_TAG_CANCEL_BUTTON;
    [button setTitle:XYBString(@"string_cash_cancel", @"撤销") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button setTitleColor:COLOR_COMMON_WHITE forState:UIControlStateNormal];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@25);
        make.right.equalTo(@-Margin_Length);
        make.centerY.equalTo(@0);
    }];
    button.hidden = YES;

    [XYCellLine initWithBottomLine_3_AtSuperView:self.contentView];
}

- (void)clickCancelButton:(id)sender {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(cashRecordTableViewCell:didClickCancelButtonOfId:)]) {
        [self.cellDelegate cashRecordTableViewCell:self didClickCancelButtonOfId:self.cashRecord.id];
    }
}

- (void)setCashRecord:(WithdrawalsRecord *)cashRecord {
    _cashRecord = cashRecord;

    UILabel *lab1 = (UILabel *) [self viewWithTag:300];
    UILabel *lab2 = (UILabel *) [self viewWithTag:301];
    UILabel *lab3 = (UILabel *) [self viewWithTag:302];

    lab1.text = cashRecord.moneyWithdrawStateString;
    lab2.text = [NSString stringWithFormat:@"- %@", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", cashRecord.moneyAmount]]];
    lab3.text = cashRecord.dateStr;

    UIButton *button = (UIButton *) [self.contentView viewWithTag:VIEW_TAG_CANCEL_BUTTON];
    if (cashRecord.isCancel == 1) { //审核中
        button.hidden = NO;
        [lab2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(button.mas_left).offset(-5);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    } else {
        button.hidden = YES;
        [lab2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-Margin_Length);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
