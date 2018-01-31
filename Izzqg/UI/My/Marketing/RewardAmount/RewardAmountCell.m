//
//  RewardAmountCell.m
//  Ixyb
//
//  Created by wang on 15/8/8.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "RewardAmountCell.h"

#import "Utility.h"

@implementation RewardAmountCell

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

    UILabel *titleabel = [[UILabel alloc] init];
    titleabel.text = XYBString(@"str_recorded", @"入账");
    titleabel.font = TEXT_FONT_16;
    titleabel.textAlignment = NSTextAlignmentCenter;
    titleabel.tag = 300;
    titleabel.textColor = COLOR_MAIN_GREY;
    [self.contentView addSubview:titleabel];

    [titleabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];

    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = XYBString(@"str_gift_date", @"05-22");
    dateLabel.tag = 302;
    dateLabel.font = TEXT_FONT_12;
    dateLabel.textAlignment = NSTextAlignmentLeft;
    dateLabel.textColor = COLOR_LIGHT_GREY;
    [self.contentView addSubview:dateLabel];

    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];

    UILabel *stageLabel = [[UILabel alloc] init];
    stageLabel.text = XYBString(@"str_gift_plus", @"+54.56");
    stageLabel.tag = 303;
    stageLabel.font = [UIFont systemFontOfSize:14.0f];
    stageLabel.textAlignment = NSTextAlignmentRight;
    stageLabel.textColor = COLOR_LIGHT_GREEN;
    [self.contentView addSubview:stageLabel];

    [stageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

    [XYCellLine initWithBottomLine_3_AtSuperView:self.contentView];
}

- (void)setRewardAmountModel:(AccountActionListModel *)rewardAmountModel {

    UILabel *lab1 = (UILabel *) [self viewWithTag:300];
    UILabel *lab2 = (UILabel *) [self viewWithTag:302];
    UILabel *lab3 = (UILabel *) [self viewWithTag:303];

    lab1.text = rewardAmountModel.issueTypeStr;
    lab2.text = rewardAmountModel.createDate;

    double amt = [rewardAmountModel.amount doubleValue];
    NSString *amountStr = @"0.00";
    if (amt != 0) {
        amountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", amt]];
    }
    lab3.text = amountStr;

    if (amt > 0) {
        lab3.textColor = COLOR_ORANGE;
        lab3.text = [NSString stringWithFormat:@"+%@", amountStr];
    } else {
        lab3.textColor = COLOR_LIGHT_GREEN;
    }
}

- (void)setIsOverDue:(BOOL)isOverDue {
    UILabel *lab3 = (UILabel *) [self viewWithTag:303];
    if (isOverDue) {
        lab3.textColor = COLOR_LIGHT_GREY;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
