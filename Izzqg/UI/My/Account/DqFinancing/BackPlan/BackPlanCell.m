//
//  BackPlanCell.m
//  Ixyb
//
//  Created by wang on 15/7/1.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "BackPlanCell.h"

#import "Utility.h"

@implementation BackPlanCell

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

    UILabel *titleabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleabel.font = TEXT_FONT_16;
    titleabel.textAlignment = NSTextAlignmentLeft;
    titleabel.tag = 300;
    titleabel.textColor = COLOR_MAIN_GREY;
    [self.contentView addSubview:titleabel];

    [titleabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];

    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    moneyLabel.text = @"530.33";
    moneyLabel.font = TEXT_FONT_16;
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.tag = 301;
    moneyLabel.textColor = COLOR_ORANGE;
    [self.contentView addSubview:moneyLabel];

    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-Margin_Length);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];

    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    dateLabel.text = @"05-22";
    dateLabel.tag = 302;
    dateLabel.font = TEXT_FONT_12;
    dateLabel.textColor = COLOR_LIGHT_GREY;
    [self.contentView addSubview:dateLabel];

    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];

    UILabel *stageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    stageLabel.text = XYBString(@"string_two_slash_two", @"2/2期");
    stageLabel.tag = 303;
    stageLabel.font = TEXT_FONT_12;
    stageLabel.textColor = COLOR_LIGHT_GREY;
    [self.contentView addSubview:stageLabel];

    [stageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-Margin_Length);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];

    [XYCellLine initWithBottomLine_3_AtSuperView:self.contentView];
}

- (void)setBackPlanModel:(DetailsModel *)backPlanModel {

    UILabel *titleLabel = (UILabel *) [self viewWithTag:300]; //titleabel
    UILabel *moneyLabel = (UILabel *) [self viewWithTag:301]; //money
    UILabel *lab3 = (UILabel *) [self viewWithTag:302];
    UILabel *lab4 = (UILabel *) [self viewWithTag:303];

    titleLabel.text = backPlanModel.br_title;
    moneyLabel.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [backPlanModel.totalAmount doubleValue]]];
    [moneyLabel sizeToFit];
    lab3.text = backPlanModel.deadline;
    lab4.text = backPlanModel.periodsStr;

    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-2);
        make.width.equalTo(@(MainScreenWidth - 15 - 15 - moneyLabel.frame.size.width - 5));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
