//
//  ExchangeRecordTableViewCell.m
//  Ixyb
//
//  Created by dengjian on 10/24/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "ExchangeRecordTableViewCell.h"

#import "DMExchangeRecord.h"
#import "Utility.h"

#define VIEW_TAG_TITLE_LABEL 50801
#define VIEW_TAG_TIME_LABEL 50802
#define VIEW_TAG_ASSIGNMENT_AMOUNT_LABEL 50803
#define VIEW_TAG_INTEREST_LABEL 50804
#define VIEW_TAG_TRANS_FEE_LABEL 50805
#define VIEW_TAG_BACK_FEE_LABEL 50806

@implementation ExchangeRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = COLOR_COMMON_WHITE;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    UILabel *timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:timeLabel];
    timeLabel.font = TEXT_FONT_14;
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = COLOR_LIGHT_GREY;
    timeLabel.tag = VIEW_TAG_TIME_LABEL;
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@Margin_Length);
        make.right.equalTo(@-Margin_Length);
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:titleLabel];
    titleLabel.font = TEXT_FONT_16;
    titleLabel.tag = VIEW_TAG_TITLE_LABEL;
    titleLabel.text = @"188";
    titleLabel.textColor = COLOR_MAIN_GREY;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@Margin_Length);
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(timeLabel.mas_left).offset(-5);
    }];

    UILabel *tip1Label = [[UILabel alloc] init];
    [self.contentView addSubview:tip1Label];
    tip1Label.text = XYBString(@"string_exchage_number", @"兑换数量");
    tip1Label.textColor = COLOR_LIGHT_GREY;
    tip1Label.font = TEXT_FONT_14;
    [tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
    }];

    UILabel *assignmentAmountLabel = [[UILabel alloc] init];
    assignmentAmountLabel.font = TEXT_FONT_16;
    assignmentAmountLabel.tag = VIEW_TAG_ASSIGNMENT_AMOUNT_LABEL;
    assignmentAmountLabel.textColor = COLOR_MAIN_GREY;
    [self.contentView addSubview:assignmentAmountLabel];
    [assignmentAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(timeLabel);
        make.centerY.equalTo(tip1Label);
    }];

    UILabel *tip2Label = [[UILabel alloc] init];
    [self.contentView addSubview:tip2Label];
    tip2Label.text = XYBString(@"string_score_consume", @"积分消耗");
    tip2Label.textColor = COLOR_LIGHT_GREY;
    tip2Label.font = TEXT_FONT_14;
    [tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(tip1Label.mas_bottom).offset(10);
    }];

    UILabel *interestLabel = [[UILabel alloc] init];
    interestLabel.font = TEXT_FONT_16;
    interestLabel.tag = VIEW_TAG_INTEREST_LABEL;
    interestLabel.textColor = COLOR_LIGHT_GREEN;
    [self.contentView addSubview:interestLabel];
    [interestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(timeLabel);
        make.centerY.equalTo(tip2Label);
    }];

    UILabel *tip3Label = [[UILabel alloc] init];
    [self.contentView addSubview:tip3Label];
    tip3Label.text = XYBString(@"string_exchage_state", @"兑换状态");
    tip3Label.textColor = COLOR_LIGHT_GREY;
    tip3Label.font = TEXT_FONT_14;
    [tip3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(tip2Label.mas_bottom).offset(10);
    }];

    UILabel *feeLabel = [[UILabel alloc] init];
    feeLabel.font = TEXT_FONT_16;
    feeLabel.tag = VIEW_TAG_TRANS_FEE_LABEL;
    feeLabel.textColor = COLOR_MAIN_GREY;
    [self.contentView addSubview:feeLabel];
    [feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(timeLabel);
        make.centerY.equalTo(tip3Label);
    }];

    UILabel *tip4Label = [[UILabel alloc] init];
    [self.contentView addSubview:tip4Label];
    tip4Label.text = XYBString(@"string_serial_num", @"流水号");
    tip4Label.textColor = COLOR_LIGHT_GREY;
    tip4Label.font = TEXT_FONT_14;
    [tip4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(tip3Label.mas_bottom).offset(10);
    }];

    UILabel *backFeeLabel = [[UILabel alloc] init];
    backFeeLabel.font = TEXT_FONT_16;
    backFeeLabel.tag = VIEW_TAG_BACK_FEE_LABEL;
    backFeeLabel.textColor = COLOR_MAIN_GREY;
    [self.contentView addSubview:backFeeLabel];
    [backFeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(timeLabel);
        make.centerY.equalTo(tip4Label);
    }];

    UIImageView *verlineImage = [[UIImageView alloc] init];
    verlineImage.image = [UIImage imageNamed:@"onePoint"];
    [self addSubview:verlineImage];
    [verlineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@(-Margin_Length));
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@Line_Height);
    }];
}

- (void)setRecord:(DMExchangeRecord *)record {

    UILabel *titleLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_TITLE_LABEL];
    UILabel *timeLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_TIME_LABEL];
    UILabel *asignmentAmountLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_ASSIGNMENT_AMOUNT_LABEL];
    UILabel *interestLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_INTEREST_LABEL];
    UILabel *transFeeLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_TRANS_FEE_LABEL];
    UILabel *backFeeLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_BACK_FEE_LABEL];

    NSString *phoneStr = [NSString stringWithFormat:@"%@", record.name];
    if ([phoneStr length] <= 0) {
        titleLabel.text = @" ";
    } else {
        titleLabel.text = phoneStr;
    }

    timeLabel.text = [NSString stringWithFormat:@"%@", record.createdDate];
    NSString *amts = [NSString stringWithFormat:@"%.2f", record.count];
    asignmentAmountLabel.text = [Utility replaceTheNumberForNSNumberFormatter:amts];
    interestLabel.text = [NSString stringWithFormat:@"%zd", record.score];
    transFeeLabel.text = [NSString stringWithFormat:@"%@", record.stateDesc];
    backFeeLabel.text = [NSString stringWithFormat:@"%@", record.no];
}

@end
