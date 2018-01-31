//
//  LuckdrawRecordTableViewCell.m
//  Ixyb
//
//  Created by dengjian on 10/24/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "LuckdrawRecordTableViewCell.h"

#import "DMLuckdrawRecord.h"
#import "Utility.h"

@implementation LuckdrawRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
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
    moneyLabel.textColor = COLOR_MAIN_GREY;
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.tag = 301;
    [self.contentView addSubview:moneyLabel];

    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

    [XYCellLine initWithBottomLine_3_AtSuperView:self.contentView];
}

- (void)setRecord:(DMLuckdrawRecord *)record {
    UILabel *lab1 = (UILabel *) [self viewWithTag:300];
    UILabel *lab2 = (UILabel *) [self viewWithTag:301];
    UILabel *lab3 = (UILabel *) [self viewWithTag:302];

    lab1.text = record.desc;
    lab2.text = record.sendStr;
    lab3.text = record.createdDate;
}

@end
