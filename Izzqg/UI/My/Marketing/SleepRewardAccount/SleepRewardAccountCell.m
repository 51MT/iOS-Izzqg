//
//  SleepRewardAccountCell.m
//  Ixyb
//
//  Created by wang on 15/8/8.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "SleepRewardAccountCell.h"

#import "Utility.h"
#import "XYCellLine.h"

@implementation SleepRewardAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_COMMON_WHITE;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {

    UILabel *titleabel = [[UILabel alloc] init];
    titleabel.text = XYBString(@"str_red_activity_gifts", @"活动赠送");
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
    dateLabel.text = XYBString(@"str_red_date", @"05-22");
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
    stageLabel.text = XYBString(@"str_red_money", @"0.00");
    stageLabel.tag = 303;
    stageLabel.font = [UIFont systemFontOfSize:14.0f];
    stageLabel.textAlignment = NSTextAlignmentRight;
    stageLabel.textColor = COLOR_ORANGE;
    [self.contentView addSubview:stageLabel];

    [stageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

    [XYCellLine initWithBottomLine_3_AtSuperView:self.contentView];
}

- (void)setModel:(SleepRewardAccountDetailListModel *)model {

    UILabel *lab1 = (UILabel *) [self viewWithTag:300];
    UILabel *lab2 = (UILabel *) [self viewWithTag:302];
    UILabel *lab3 = (UILabel *) [self viewWithTag:303];

    lab1.text = model.issueTypeStr;
    lab2.text = model.createTime;

    NSString *symbols = @"";
    
    double amt = [model.reward doubleValue];
    if (amt > 0) {
        lab3.textColor = COLOR_ORANGE;
        symbols = @"+";
    } else {
        if (self.isBeoverdue == YES) {
            lab3.textColor = COLOR_LIGHT_GREEN;
        }else
        {
            lab3.textColor = COLOR_AUXILIARY_GREY;
        }

    }
    
//    if ([model.streamTypeStr isEqualToString:@"0"]) {
//        symbols = @"+";
//        lab3.textColor = COLOR_ORANGE;
//    } else if ([model.streamTypeStr isEqualToString:@"1"]) {
//        symbols = @"-";
//        lab3.textColor = COLOR_LIGHT_GREEN;
//    } else {
//        symbols = @"-";
//        lab3.textColor = COLOR_AUXILIARY_GREY;
//    }

    NSString *amountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [model.reward doubleValue]]];
    lab3.text = [NSString stringWithFormat:@"%@%@", symbols, amountStr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
