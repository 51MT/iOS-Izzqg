//
//  InvestedDetailActionTableViewCell.m
//  Ixyb
//
//  Created by dengjian on 10/15/15.
//  Copyright (c) 2015 xyb. All rights reserved.
//

#import "InvestedDetailActionTableViewCell.h"

#import "Utility.h"

#define VIEW_TAG_TITLE_LABEL 50701
#define VIEW_TAG_TIME_LABEL 50702
#define VIEW_TAG_AMOUNT_LABEL 50703
#define VIEW_TAG_LX_LABEL 50704

@implementation InvestedDetailActionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"07-19 16:06:01";
    timeLabel.textColor = COLOR_MAIN_GREY;
    timeLabel.font = TEXT_FONT_14;
    timeLabel.tag = VIEW_TAG_TIME_LABEL;
    [self.contentView addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.top.equalTo(self.contentView.mas_top).offset(Margin_Top);
    }];
    
    UILabel * interestLabel = [[UILabel alloc] init];
    interestLabel.text = @"利息: 1.00";
    interestLabel.textColor = COLOR_LIGHT_GREY;
    interestLabel.font = TEXT_FONT_12;
    interestLabel.tag = VIEW_TAG_LX_LABEL;
    [self.contentView addSubview:interestLabel];
    
    [interestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-Margin_Bottom);
    }];

    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.text = XYBString(@"str_120_yuan", @"120元");
    amountLabel.font = TEXT_FONT_16;
    amountLabel.textColor = COLOR_CHU_ORANGE;
    amountLabel.tag = VIEW_TAG_AMOUNT_LABEL;
    amountLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:amountLabel];

    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

}

- (void)setDetail:(NSDictionary *)detail {

    UILabel *titleLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_TITLE_LABEL];
    UILabel *timeLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_TIME_LABEL];
    UILabel *interestLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_LX_LABEL];
    UILabel *amountLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_AMOUNT_LABEL];


    titleLabel.text = [NSString stringWithFormat:@"%@",detail[@"title"]];
    timeLabel.text = [NSString stringWithFormat:@"%@期%@",detail[@"monthIndex"],detail[@"deadline"]];
    CGFloat principal = [detail[@"principal"] doubleValue];
    CGFloat interest = [detail[@"interest"] doubleValue];
    CGFloat addInterest = [detail[@"addInterest"]doubleValue];

    NSString *amtStr = @"";
    if (addInterest > 0) {
        CGFloat addinterest = principal + interest+addInterest;
         amtStr= [NSString stringWithFormat:@"%.2f",addinterest];
    }else
    {
        amtStr= [NSString stringWithFormat:@"%.2f", principal + interest];
    }
    amountLabel.text = [NSString stringWithFormat:XYBString(@"str_some_yuan", @"%@元"), [Utility replaceTheNumberForNSNumberFormatter:amtStr]];


    if ([detail[@"addInterest"] doubleValue] <= 0) {
        interestLabel.text = [NSString stringWithFormat:XYBString(@"str_receive_rest_lx", @"利息: %@元"),detail[@"interest"]];
    }else
    {
        interestLabel.text = [NSString stringWithFormat:XYBString(@"str_receive_rest_tips", @"利息: %@元 补息: %@元"),detail[@"interest"],detail[@"addInterest"]];
    }

}

@end
