//
//  MyScoreCell.m
//  Ixyb
//
//  Created by wang on 15/9/1.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "MyScoreCell.h"

#import "Utility.h"

#import "XYCellLine.h"

@implementation MyScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_COMMON_WHITE;
        [self setUI];
    }
    return self;
}

- (void)setUI {

    UILabel *stageLabel = [[UILabel alloc] init];
    stageLabel.text = XYBString(@"str_score_invest_type", @"出借");
    stageLabel.tag = 303;
    stageLabel.font = TEXT_FONT_16;
    stageLabel.textColor = COLOR_MAIN_GREY;
    [self.contentView addSubview:stageLabel];

    [stageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];

    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = XYBString(@"str_score_date", @"05-22");
    dateLabel.tag = 302;
    dateLabel.font = TEXT_FONT_12;
    dateLabel.textColor = COLOR_LIGHT_GREY;
    [self.contentView addSubview:dateLabel];

    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];

    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.text = XYBString(@"str_score_money", @"530.33");
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

- (void)setScoreDetail:(ScoreDetailList *)scoreDetail {

    UILabel *lab1 = (UILabel *) [self viewWithTag:301];
    UILabel *lab2 = (UILabel *) [self viewWithTag:302];
    UILabel *lab3 = (UILabel *) [self viewWithTag:303];

    if (scoreDetail.score < 0) {
        lab1.textColor = COLOR_LIGHT_GREEN;
        lab1.text = [NSString stringWithFormat:XYBString(@"str_some_score_long", @"%ld"), (long) scoreDetail.score];
    } else {
        lab1.textColor = COLOR_ORANGE;
        lab1.text = [NSString stringWithFormat:XYBString(@"str_some_score_more_long", @"+%ld"), (long) scoreDetail.score];
    }

    lab2.text = scoreDetail.createTime;
    lab3.text = scoreDetail.issueTypeStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
